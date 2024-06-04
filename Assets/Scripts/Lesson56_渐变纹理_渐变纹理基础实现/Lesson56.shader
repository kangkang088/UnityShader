Shader "Unlit/Lesson56"
{
    Properties
    {
        _MainColor("MainColor",Color) = (1,1,1,1)
        _RampTex("RampTex",2D) = ""{}
        _SpecularColor("SpecularColor",Color) = (1,1,1,1)
        _SpecularNumber("SpecularNumber",Range(8,256)) = 18

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
            sampler2D _RampTex;
            float4 _RampTex_ST;
            fixed4 _SpecularColor;
            float _SpecularNumber;

            struct v2f
            {
                float4 pos : SV_POSITION;
                float3 wPos : TEXCOORD0;
                float3 wNormal : TEXCOORD1;
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
                float3 lightDir = normalize(_WorldSpaceLightPos0);
                
                fixed halfLambertNum = dot(normalize(i.wNormal),lightDir) * 0.5 + 0.5;
                fixed3 diffuseColor = _LightColor0.rgb * _MainColor.rgb * tex2D(_RampTex,fixed2(halfLambertNum,halfLambertNum));

                float3 viewDir = normalize(UnityWorldSpaceViewDir(i.wPos));
                float3 halfDir = normalize(lightDir + viewDir);
                fixed3 specularColor = _LightColor0.rgb * _SpecularColor.rgb * pow(max(0,dot(i.wNormal,halfDir)),_SpecularNumber);

                fixed3 blinnColor = UNITY_LIGHTMODEL_AMBIENT.rgb + diffuseColor + specularColor;

                return fixed4(blinnColor.rgb,1);
            }
            ENDCG
        }
    }
}
