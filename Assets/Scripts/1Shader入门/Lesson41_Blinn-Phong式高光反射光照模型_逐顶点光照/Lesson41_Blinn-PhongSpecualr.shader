Shader "Unlit/Lesson41_Blinn-PhongSpecular" {
    Properties {
        _SpecularColor ("SpecularColor", Color) = (1, 1, 1, 1)
        _SpecularNumber ("SpecularNumber", Range(0, 20)) = 5
    }
    SubShader {
        Pass {
            Tags { "LightMode" = "ForwardBase" }
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #include "UnityCG.cginc"
            #include "Lighting.cginc"


            fixed4 _SpecularColor;
            float _SpecularNumber;

            struct v2f {
                float4 pos : SV_POSITION;
                fixed3 color : COLOR;
            };
            

            v2f vert(appdata_base v) {
                v2f data;
                data.pos = UnityObjectToClipPos(v.vertex);

                float3 wNormal = UnityObjectToWorldNormal(v.normal);

                float3 wPos = mul(unity_ObjectToWorld,v.vertex);
                float3 viewDir = normalize(_WorldSpaceCameraPos.xyz - wPos);
                float3 lightDir = normalize(_WorldSpaceLightPos0.xyz);
                float3 halfAngleDir = normalize(viewDir + lightDir);

                data.color = _LightColor0.rgb * _SpecularColor.rgb * pow(max(0,dot(wNormal,halfAngleDir)),_SpecularNumber);

                return data;
            }

            fixed4 frag(v2f i) : SV_Target 
            {
                return fixed4(i.color.rgb,1);
            }
            ENDCG
        }
    }
}