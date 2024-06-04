Shader "Unlit/Lesson32_LambertHalfVertex"
{
    Properties
    {
        _MainColor ("Main Color", Color) = (1,1,1,1)
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
                float4 vertex : SV_POSITION;
                fixed3 color : COLOR;
            };
            v2f vert (appdata_base data)
            {
               v2f v;
               v.vertex = UnityObjectToClipPos(data.vertex);

               float3 normal = UnityObjectToWorldNormal(data.normal);
               float3 lightDir = normalize(_WorldSpaceLightPos0.xyz);
               fixed3 color = _LightColor0.rgb * _MainColor.rgb * (dot(normal, lightDir) * 0.5 + 0.5);
               v.color = color + UNITY_LIGHTMODEL_AMBIENT.rgb;
               return v;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                return fixed4(i.color, 1);
            }
            ENDCG
        }
    }
}
