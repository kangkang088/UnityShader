Shader "Unlit/Lesson59"
{
    Properties
    {
        _MainColor("MainColor",Color) = (1,1,1,1)
        _MainTex("MainTex",2D) = ""{}

        _BumpMap("BumpMap",2D) = ""{}
        _BumpScale("BumpScale",Range(0,1)) = 1

        _SpecularMask("SpecularMask",2D) = ""{}
        _SpecularMaskScale("SpecularMaskScale",Float) = 1
        
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

            sampler2D _SpecularMask;//高光遮罩纹理
            float4 _SpecularMask_ST;//高光遮罩纹理的缩放平移
            float _SpecularMaskScale;//遮罩系数

            float _BumpScale;//凹凸程度
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

                //模型空间到切线空间的变换矩阵
                //切线 副切线 法线

                //副切线   *v.tangent.w ： 确定是哪一条副切线
                float3 binormal = cross(normalize(v.tangent),normalize(v.normal)) * v.tangent.w;
                //translate matrix 
                float3x3 rotation = float3x3(v.tangent.xyz,
                                            binormal.xyz,
                                            v.normal.xyz);
                data.lightDir = ObjSpaceLightDir(v.vertex);//模型空间下光的方向
                data.lightDir = mul(rotation,data.lightDir);//切线空间下光的方向
                data.viewDir = ObjSpaceViewDir(v.vertex);//模型空间下视角的方向
                data.viewDir = mul(rotation,data.viewDir);//切线空间下视角的方向

                return data;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                //纹理采样函数，取出法线纹理贴图当中的数据（压缩）
                float4 packedNormal = tex2D(_BumpMap,i.uv.zw);
                //逆运算和解压缩计算，得到法线数据
                float3 tangentNormal = UnpackNormal(packedNormal);
                tangentNormal *= _BumpScale;

                fixed3 albedo = tex2D(_MainTex,i.uv.xy) * _MainColor.rgb;

                fixed3 lambertColor = _LightColor0.rgb * albedo * max(0,dot(tangentNormal,normalize(i.lightDir)));

                float3 halfAngle = normalize(normalize(i.viewDir) + normalize(i.lightDir));

                //高光遮罩纹理值的计算
                fixed maskNumber = tex2D(_SpecularMask,i.uv.xy).r;//1.
                fixed specularMaskValue = maskNumber * _SpecularMaskScale;//2.

                fixed3 specularColor = _LightColor0.rgb * _SpecularColor.rgb * pow(max(0,dot(tangentNormal,halfAngle)),_SpecularNumber);
                specularColor *= specularMaskValue;//3.

                fixed3 blinnColor = UNITY_LIGHTMODEL_AMBIENT * albedo + lambertColor + specularColor;
                return fixed4(blinnColor.rgb,1);
            }
            ENDCG
        }
    }
}
