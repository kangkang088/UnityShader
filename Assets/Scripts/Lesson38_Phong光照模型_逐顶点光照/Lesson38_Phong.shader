Shader "Unlit/Lesson38_Phong"
{
    Properties
    {
        _MainColor ("Main Color", Color) = (1,1,1,1)

        //�߹ⷴ����ɫ
        _SpecularColor("SpecularColor",Color) = (1,1,1,1)
        //�����
        _SpecularNumber("SpecularNumber",Range(0,20)) = 0.5
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

            fixed4 _MainColor;//������������ɫ
            fixed4 _SpecularColor;
            float _SpecularNumber;

            struct v2f
            {
                float4 pos : SV_POSITION;
                fixed3 color : COLOR;
            };
            //���������ع���ģ�������ɫ����
            fixed3 GetLambertColor(in float3 objNormal)
            {
                //�����������ϵ�µķ��ߵĵ�λ����
                float3 normal = UnityObjectToWorldNormal(objNormal);
                //�����������ϵ�µĹ�Դ����ĵ�λ����
                float3 lightDir = normalize(_WorldSpaceLightPos0.xyz);
                //labboert����ģ��
                //_LightColor0 ������ɫ
                fixed3 color = _LightColor0 * _MainColor.rgb * max(0,dot(normal,lightDir));

                return color;
            }
            //����Phongʽ�߹ⷴ�������ɫ
            fixed3 GetSpecularColor(in float4 objVertex,in float3 objNormal)
            {
                //��׼����۲췽������
                float3 worldPos = mul(UNITY_MATRIX_M,objVertex);
                float3 viewDir = _WorldSpaceCameraPos.xyz - worldPos;
                viewDir = normalize(viewDir);
                //��׼�����䷽������
                float3 lightDir = normalize(_WorldSpaceLightPos0.xyz);
                float3 normal = UnityObjectToWorldNormal(objNormal);
                float3 reflectDir = reflect(-lightDir,normal);

                float3 color = _LightColor0.rgb * _SpecularColor.rgb * pow(max(0,dot(viewDir,reflectDir)),_SpecularNumber); 

                return color;
            }

            v2f vert (appdata_base v)
            {
                v2f data;
                data.pos = UnityObjectToClipPos(v.vertex);

                float3 lambertColor = GetLambertColor(v.normal);
                float3 specularColor = GetSpecularColor(v.vertex,v.normal);

                data.color = UNITY_LIGHTMODEL_AMBIENT.rgb + lambertColor + specularColor;
                return data;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                return fixed4(i.color.rgb,1);
            }
            ENDCG
        }
    }
}
