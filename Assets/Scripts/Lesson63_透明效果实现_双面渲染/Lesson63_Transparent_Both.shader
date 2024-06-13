Shader "Unlit/Lesson63_Transparent_Both" {
    Properties {
        _MainTex ("Texture", 2D) = "" { }
        _MainColor ("MainColor", Color) = (1, 1, 1, 1)
        _SpecularColor ("SpecularColor", Color) = (1, 1, 1, 1)
        _SpecularNumber ("SpecularNumber", Range(0, 20)) = 15
        //对象整体的透明度值
        _AlphaScale ("AlphaScale", Range(0, 1)) = 1
    }
    SubShader {
        Tags { "Queue" = "Transparent" "IgnoreProjector" = "True" "RenderType" = "Transparent" }
        Pass {
            Tags { "LightMode" = "ForwardBase" }
            
            //剔除正面，先渲染背面
            Cull Front

            ZWrite Off
            Blend SrcAlpha OneMinusSrcAlpha

            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #include "UnityCG.cginc"
            #include "Lighting.cginc"

            sampler2D _MainTex;
            float4 _MainTex_ST;
            fixed4 _MainColor;
            fixed4 _SpecularColor;
            float _SpecularNumber;
            //对象整体的透明度值
            fixed _AlphaScale;
            
            struct v2f {
                float4 pos : SV_POSITION;
                float2 uv : TEXCOORD0;
                float3 wNormal : NORMAL;
                float3 wPos : TEXCOORD1;
            };
            v2f vert(appdata_base v) {
                v2f data;
                data.pos = UnityObjectToClipPos(v.vertex);
                data.uv = v.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                data.wNormal = UnityObjectToWorldNormal(v.normal);
                data.wPos = mul(unity_ObjectToWorld, v.vertex);
                return data;
            }

            fixed4 frag(v2f i) : SV_Target {
                fixed4 texColor = tex2D(_MainTex, i.uv);//取出纹理中的颜色rgba

                fixed3 albedo = texColor.rgb * _MainColor.rgb;

                //Lambert
                float3 lightDir = normalize(_WorldSpaceLightPos0.xyz);
                fixed3 lambertColor = _LightColor0.rgb * albedo * max(0, dot(i.wNormal, lightDir));
                //Specular
                float3 viewDir = normalize(_WorldSpaceCameraPos.xyz - i.wPos);
                //float3 viewDir = UnityWorldSpaceViewDir(i.wPos);
                float3 halfAngle = normalize(viewDir + lightDir);
                fixed3 specularColor = _LightColor0.rgb * _SpecularColor.rgb * pow(max(0, dot(i.wNormal, halfAngle)), _SpecularNumber);

                fixed3 blinnPhongColor = UNITY_LIGHTMODEL_AMBIENT * albedo + lambertColor + specularColor;

                //修改Alpha
                return fixed4(blinnPhongColor.rgb, texColor.a * _AlphaScale);
            }
            ENDCG
        }
        Pass {
            Tags { "LightMode" = "ForwardBase" }

            //剔除背面，后渲染正面
            Cull Back

            ZWrite Off
            Blend SrcAlpha OneMinusSrcAlpha

            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #include "UnityCG.cginc"
            #include "Lighting.cginc"

            sampler2D _MainTex;
            float4 _MainTex_ST;
            fixed4 _MainColor;
            fixed4 _SpecularColor;
            float _SpecularNumber;
            //对象整体的透明度值
            fixed _AlphaScale;
            
            struct v2f {
                float4 pos : SV_POSITION;
                float2 uv : TEXCOORD0;
                float3 wNormal : NORMAL;
                float3 wPos : TEXCOORD1;
            };
            v2f vert(appdata_base v) {
                v2f data;
                data.pos = UnityObjectToClipPos(v.vertex);
                data.uv = v.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                data.wNormal = UnityObjectToWorldNormal(v.normal);
                data.wPos = mul(unity_ObjectToWorld, v.vertex);
                return data;
            }

            fixed4 frag(v2f i) : SV_Target {
                fixed4 texColor = tex2D(_MainTex, i.uv);//取出纹理中的颜色rgba

                fixed3 albedo = texColor.rgb * _MainColor.rgb;

                //Lambert
                float3 lightDir = normalize(_WorldSpaceLightPos0.xyz);
                fixed3 lambertColor = _LightColor0.rgb * albedo * max(0, dot(i.wNormal, lightDir));
                //Specular
                float3 viewDir = normalize(_WorldSpaceCameraPos.xyz - i.wPos);
                //float3 viewDir = UnityWorldSpaceViewDir(i.wPos);
                float3 halfAngle = normalize(viewDir + lightDir);
                fixed3 specularColor = _LightColor0.rgb * _SpecularColor.rgb * pow(max(0, dot(i.wNormal, halfAngle)), _SpecularNumber);

                fixed3 blinnPhongColor = UNITY_LIGHTMODEL_AMBIENT * albedo + lambertColor + specularColor;

                //修改Alpha
                return fixed4(blinnPhongColor.rgb, texColor.a * _AlphaScale);
            }
            ENDCG
        }
    }
}