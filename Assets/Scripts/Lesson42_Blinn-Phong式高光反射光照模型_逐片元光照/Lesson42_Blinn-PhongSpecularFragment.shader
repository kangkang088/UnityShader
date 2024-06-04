Shader "Unlit/Lesson42_Blinn-PhongSpecularFragment"
{
    Properties
    {
        _SpecularColor ("SpecularColor", Color) = (1, 1, 1, 1)
        _SpecularNumber ("SpecularNumber", Range(0, 20)) = 5
    }
    SubShader
    {
        Pass
        {
            Tags { "LightMode" = "ForwardBase" }
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #include "UnityCG.cginc"
            #include "Lighting.cginc"

            fixed4 _SpecularColor;
            float _SpecularNumber;


            struct v2f
            {
                float4 pos : SV_POSITION;
                float3 wPos : TEXCOORD0;
                float3 wNormal : NORMAL;
            };

            v2f vert (appdata_base v)
            {
                v2f data;
                data.pos = UnityObjectToClipPos(v.vertex);
                data.wPos = mul(unity_ObjectToWorld,v.vertex);
                data.wNormal = UnityObjectToWorldNormal(v.normal);

                return data;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                float3 viewDir = normalize(_WorldSpaceCameraPos.xyz - i.wPos);
                float3 lightDir = normalize(_WorldSpaceLightPos0.xyz);
                float3 halfAngleDir = normalize(viewDir + lightDir);
    
                fixed3 color = _LightColor0.rgb * _SpecularColor.rgb * pow(max(0,dot(i.wNormal,halfAngleDir)),_SpecularNumber);
                return fixed4(color.rgb,1);
            }
            ENDCG
        }
    }
}
