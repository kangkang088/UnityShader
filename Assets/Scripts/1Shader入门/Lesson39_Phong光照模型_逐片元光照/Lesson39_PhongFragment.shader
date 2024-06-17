Shader "Unlit/Lesson39_PhongFragment" {
    Properties {
        _MainColor ("Main Color", Color) = (1, 1, 1, 1)
        //高光反射颜色
        _SpecularColor ("SpecularColor", Color) = (1, 1, 1, 1)
        //光泽度
        _SpecularNumber ("SpecularNumber", Range(0, 20)) = 0.5
    }
    SubShader {
        Pass {
            Tags { "LightMode" = "ForwardBase" }
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #include "UnityCG.cginc"
            #include "Lighting.cginc"

            fixed4 _MainColor;//材质漫反射颜色
            fixed4 _SpecularColor;
            float _SpecularNumber;

            struct v2f {
                float4 pos : SV_POSITION;
                fixed3 wNormal : NORMAL;
                //世界空间下的顶点坐标
                float3 wPOS : TEXCOORD0;
            };

            fixed3 GetLambertColorFragment(in float3 wNormal) {
                float3 lightDir = normalize(_WorldSpaceLightPos0.xyz);
                fixed3 color = _MainColor.rgb * _LightColor0.rgb * max(0, (dot(wNormal, lightDir)));
                return color;
            }
            fixed3 GetSpecularColorFragment(in float3 wPos,in float3 objNormal)
            {
                float3 viewDir = _WorldSpaceCameraPos.xyz - wPos;
                viewDir = normalize(viewDir);

                float3 lightDir = normalize(_WorldSpaceLightPos0.xyz);
                float3 reflectDir = reflect(-lightDir,objNormal);

                float3 color = _LightColor0.rgb * _SpecularColor.rgb * pow(max(0,dot(viewDir,reflectDir)),_SpecularNumber);

                return color;
            }

            v2f vert(appdata_base v) {
                v2f data;
                data.pos = UnityObjectToClipPos(v.vertex);
                data.wNormal = UnityObjectToWorldNormal(v.normal);
                data.wPOS = mul(unity_ObjectToWorld,v.vertex).xyz;
                return data;
            }

            fixed4 frag(v2f i) : SV_Target 
            {
                fixed3 lambertColor = GetLambertColorFragment(i.wNormal);
                fixed3 specularColor = GetSpecularColorFragment(i.wPOS,i.wNormal);

                fixed3 phongColorFragment = UNITY_LIGHTMODEL_AMBIENT.rgb + lambertColor + specularColor;
                return fixed4(phongColorFragment.rgb,1);
            }
            ENDCG
        }
    }
}