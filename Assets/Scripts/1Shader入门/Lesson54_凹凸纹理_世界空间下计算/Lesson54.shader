Shader "Unlit/Lesson54" {
    Properties {
        _MainColor ("MainColor", Color) = (1, 1, 1, 1)
        _MainTex ("MainTex", 2D) = "" { }
        _BumpMap ("BumpMap", 2D) = "" { }
        _BumpScale ("BumpScale", Range(0, 1)) = 1
        _SpecularColor ("SpecularColor", Color) = (1, 1, 1, 1)
        _SpecularNumber ("SpecularNumber", Range(0, 20)) = 18
    }
    SubShader {
        Pass {
            Tags { "LightMode" = "ForwardBase" }
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

            float _BumpScale;//凹凸程度
            float _SpecularNumber;
            
            struct v2f {
                float4 pos : SV_POSITION;
                float4 uv : TEXCOORD0;

                //float3 worldPos : TEXCOORD1;
                //float3x3 rotation : TEXCOORD2;

                float4 T2W0 : TEXCOORD1;//rotation第一行 + worldPos.x
                float4 T2W1 : TEXCOORD2;//rotation第二行 + worldPos.y
                float4 T2W2 : TEXCOORD3;//rotation第三行 + worldPos.z
            };

            v2f vert(appdata_full v) {
                v2f data;
                data.pos = UnityObjectToClipPos(v.vertex);
                data.uv.xy = v.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                data.uv.zw = v.texcoord.xy * _BumpMap_ST.xy + _BumpMap_ST.zw;

                //data.worldPos = mul(unity_ObjectToWorld, v.vertex);
                float3 worldPos = mul(unity_ObjectToWorld, v.vertex);

                float3 worldNormal = UnityObjectToWorldNormal(v.normal);
                float3 worldTangent = UnityObjectToWorldDir(v.tangent);
                float3 worldBinormal = cross(normalize(worldNormal), normalize(worldTangent)) * v.tangent.w;

                //data.rotation = fixed3x3(worldTangent.x, worldBinormal.x, worldNormal.x,
                //                         worldTangent.y, worldBinormal.y, worldNormal.y,
                //                         worldTangent.z, worldBinormal.z, worldNormal.z);

                data.T2W0 = float4(worldTangent.x, worldBinormal.x, worldNormal.x,worldPos.x);
                data.T2W1 = float4(worldTangent.y, worldBinormal.y, worldNormal.y,worldPos.y);
                data.T2W2 = float4(worldTangent.z, worldBinormal.z, worldNormal.z,worldPos.z);

                return data;
            }

            fixed4 frag(v2f i) : SV_Target { 
                fixed3 lightDir = normalize(_WorldSpaceLightPos0.xyz);

                float3 worldPos = float3(i.T2W0.w,i.T2W1.w,i.T2W2.w);
                fixed3 viewDir = normalize(UnityWorldSpaceViewDir(worldPos));

                float4 packedNormal = tex2D(_BumpMap,i.uv.zw);
                float3 tangentNormal = UnpackNormal(packedNormal);
                tangentNormal.xy *= _BumpScale;
                tangentNormal.z = sqrt(1.0 - saturate(dot(tangentNormal.xy,tangentNormal.xy)));

                //float3x3 rotation = float3x3(i.T2W0.xyz,i.T2W1.xyz,i.T2W2.xyz);
                //float3 worldNormal = mul(rotation,tangentNormal);
                float3 worldNormal = float3(dot(i.T2W0.xyz,tangentNormal),dot(i.T2W1.xyz,tangentNormal),dot(i.T2W2.xyz,tangentNormal));

                fixed3 albedo = tex2D(_MainTex,i.uv.xy) * _MainColor.rgb;

                fixed3 lambertColor = _LightColor0.rgb * albedo * max(0,dot(worldNormal,normalize(lightDir)));

                float3 halfAngle = normalize(normalize(viewDir) + normalize(lightDir));
                fixed3 specularColor = _LightColor0.rgb * _SpecularColor.rgb * pow(max(0,dot(worldNormal,halfAngle)),_SpecularNumber);

                fixed3 blinnColor = UNITY_LIGHTMODEL_AMBIENT * albedo + lambertColor + specularColor;
                return fixed4(blinnColor.rgb,1);
            }
            ENDCG
        }
    }
}