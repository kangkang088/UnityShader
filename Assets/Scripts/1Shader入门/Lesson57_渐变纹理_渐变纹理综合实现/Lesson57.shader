Shader "Unlit/Lesson57"
{
    Properties
    {
        _MainColor("MainColor",Color) = (1,1,1,1)
        _MainTex("MainTex",2D) = ""{}
        _BumpMap("BumpMap",2D) = ""{}
        _RampTex("RampTex",2D) = ""{}
        _BumpScale("BumpScale",Range(0,1)) = 1
        _SpecularColor("SpecularColor",Color) = (1,1,1,1)
        _SpecularNumber("SpecularNumber",Range(0,20)) = 18
    }
    SubShader
    {
        Pass
        {
            Tags { "LightMode"="ForwardBase" }
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #include "UnityCG.cginc"
            #include "Lighting.cginc"

            fixed4 _MainColor;
            fixed4 _SpecularColor;

            sampler2D _MainTex;
            float4 _MainTex_ST;
            sampler2D _BumpMap;
            float4 _BumpMap_ST;
            //��������
            sampler2D _RampTex;
            float4 _RampTex_ST;

            float _BumpScale;//��͹�̶�
            float _SpecularNumber;

            struct v2f
            {
                float4 pos : SV_POSITION;
                
                //float2 uvTex : TEXCOORD0;
                //float2 uvBump : TEXCOORD1;
                float4 uv : TEXCOORD0;//xy : uvTex; zw : uvBump

                float3 lightDir : TEXCOORD1;
                float3 viewDir : TEXCOORD2;
            };

            v2f vert (appdata_full v)
            {
                v2f data;
                data.pos = UnityObjectToClipPos(v.vertex);
                data.uv.xy = v.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                data.uv.zw = v.texcoord.xy * _BumpMap_ST.xy + _BumpMap_ST.zw;

                //ģ�Ϳռ䵽���߿ռ�ı任����
                //���� ������ ����

                //������   *v.tangent.w �� ȷ������һ��������
                float3 binormal = cross(normalize(v.tangent),normalize(v.normal)) * v.tangent.w;
                //translate matrix 
                float3x3 rotation = float3x3(v.tangent.xyz,
                                            binormal.xyz,
                                            v.normal.xyz);
                data.lightDir = ObjSpaceLightDir(v.vertex);//ģ�Ϳռ��¹�ķ���
                data.lightDir = mul(rotation,data.lightDir);//���߿ռ��¹�ķ���
                data.viewDir = ObjSpaceViewDir(v.vertex);//ģ�Ϳռ����ӽǵķ���
                data.viewDir = mul(rotation,data.viewDir);//���߿ռ����ӽǵķ���

                return data;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                //�������������ȡ������������ͼ���е����ݣ�ѹ����
                float4 packedNormal = tex2D(_BumpMap,i.uv.zw);
                //������ͽ�ѹ�����㣬�õ���������
                float3 tangentNormal = UnpackNormal(packedNormal);
                tangentNormal *= _BumpScale;

                fixed3 albedo = tex2D(_MainTex,i.uv.xy) * _MainColor.rgb;

                fixed halfLambertNum = dot(tangentNormal,normalize(i.lightDir)) * 0.5 + 0.5;
                fixed3 diffuseColor = _LightColor0.rgb * albedo.rgb * tex2D(_RampTex,fixed2(halfLambertNum,halfLambertNum)).rgb;
                

                float3 halfAngle = normalize(normalize(i.viewDir) + normalize(i.lightDir));
                fixed3 specularColor = _LightColor0.rgb * _SpecularColor.rgb * pow(max(0,dot(tangentNormal,halfAngle)),_SpecularNumber);

                fixed3 color = UNITY_LIGHTMODEL_AMBIENT * albedo + diffuseColor + specularColor;
                return fixed4(color.rgb,1);
            }
            ENDCG
        }
    }
}
