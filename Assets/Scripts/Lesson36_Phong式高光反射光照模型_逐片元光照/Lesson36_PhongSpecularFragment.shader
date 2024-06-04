Shader "Unlit/Lesson36_PhongSpecularFragment"
{
    Properties
    {
        _SpecularColor("SpecularColor",Color) = (1,1,1,1)
        _SpecularNumber("SpecularNumber",Range(0,20)) = 1
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

            fixed4 _SpecularColor;
            float _SpecularNumber;

            struct v2f
            {
                float4 pos : SV_POSITION;
                float3 wNormal : NORMAL;
                //世界空间下的顶点坐标
                float3 wPOS : TEXCOORD0;
            };

            v2f vert (appdata_base v)
            {
                v2f data;

                data.pos = UnityObjectToClipPos(v.vertex);

                data.wNormal = UnityObjectToWorldNormal(v.normal);

                //data.wPOS = mul(UNITY_MATRIX_M,v.vertex).xyz;
                //data.wPOS = mul(_Object2World,v.vertex).xyz;
                data.wPOS = mul(unity_ObjectToWorld,v.vertex).xyz;

                return data;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                float3 viewDir = _WorldSpaceCameraPos.xyz - i.wPOS;
                viewDir = normalize(viewDir);

                float3 lightDir = normalize(_WorldSpaceLightPos0.xyz);
                float3 reflectDir = reflect(-lightDir,i.wNormal);

                float3 color = _LightColor0.rgb * _SpecularColor.rgb * pow(max(0,dot(viewDir,reflectDir)),_SpecularNumber);
                return fixed4(color.rgb,1);
            }
            ENDCG
        }
    }
}
