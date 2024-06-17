Shader "Unlit/Lesson33_LambertHalfFragment"
{
    Properties
    {
        _MainColor("Main Color",Color)= (1,1,1,1)
    }
    SubShader
    {
        Tags { "LightMode"="ForwardBase" }

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #include "UnityCG.cginc"
            #include "Lighting.cginc"
            fixed4 _MainColor;
            struct v2f
            {
                float4 pos : SV_POSITION;
                float3 normal : NORMAL;
            };

            v2f vert (appdata_base data)
            {
                v2f v;
                v.normal = UnityObjectToWorldNormal(data.normal);
                v.pos = UnityObjectToClipPos(data.vertex);
                return v;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                float3 lightDir = normalize(_WorldSpaceLightPos0.xyz);
                fixed3 color = _MainColor.rgb * _LightColor0.rgb * (dot(i.normal, lightDir) * 0.5 + 0.5);
                color = color + UNITY_LIGHTMODEL_AMBIENT.rgb;
                return fixed4(color, 1);
            }
            ENDCG
        }
    }
}
