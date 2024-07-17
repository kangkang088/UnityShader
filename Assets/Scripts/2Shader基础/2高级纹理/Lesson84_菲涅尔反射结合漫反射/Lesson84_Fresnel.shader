Shader "Unlit/Lesson84_Fresnel"
{
    Properties {
        //漫反射颜色
        _Color ("Color", Color) = (1, 1, 1, 1)
        //立方体纹理
        _Cube ("Cubemap", Cube) = "" { }
        //反射率
        _FresnelScale ("FresnelScale", Range(0, 1)) = 1
    }
    SubShader {
        Tags { "RenderType" = "Opaque" "Queue" = "Geometry" }
        Pass {
            Tags { "LightMode" = "ForwardBase" }

            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #pragma multi_compile_fwdbase

            #include "UnityCG.cginc"
            #include "Lighting.cginc"
            #include "AutoLight.cginc"

            samplerCUBE _Cube;
            float _FresnelScale;
            fixed4 _Color;

            struct v2f {
                float4 pos : SV_POSITION;//裁剪空间下顶点坐标
                fixed3 worldNormal : NORMAL;//世界空间下的法线
                float3 worldPos : TEXCOORD0;//世界空间下的顶点
                float3 worldReflect : TEXCOORD1;//世界空间下反射向量
                float3 worldViewDir : TEXCOORD2;//世界空间下视角的方向

                SHADOW_COORDS(3)

            };

            v2f vert(appdata_base v) {
                v2f o;
                o.pos = UnityObjectToClipPos(v.vertex);

                o.worldNormal = UnityObjectToWorldNormal(v.normal);
                o.worldPos = mul(unity_ObjectToWorld, v.vertex).xyz;
                //视角方向，内部是摄像机位置-顶点位置。
                o.worldViewDir = UnityWorldSpaceViewDir(o.worldPos);
                o.worldReflect = reflect(-o.worldViewDir, o.worldNormal);

                TRANSFER_SHADOW(o);

                return o;
            }

            fixed4 frag(v2f i) : SV_TARGET {
                fixed3 worldLightDir = normalize(UnityWorldSpaceLightDir(i.worldPos));
                fixed3 diffuse = _LightColor0.rgb * _Color.rgb * max(0,dot(normalize(i.worldNormal),worldLightDir));

                fixed3 cubemapColor = texCUBE(_Cube, i.worldReflect).rgb;

                UNITY_LIGHT_ATTENUATION(atten,i,i.worldPos);

                //菲涅尔反射率计算，利用schlick近似等式
                fixed fresnel = _FresnelScale + (1 - _FresnelScale) * pow(1 - dot(normalize(i.worldViewDir),normalize(i.worldNormal)),5);

                //在漫反射和菲涅尔反射之间进行插值。0：没有菲涅尔反射。1：只有菲涅尔反射效果。 0-1：漫反射和反射叠加
                fixed3 color = UNITY_LIGHTMODEL_AMBIENT.rgb + lerp(diffuse,cubemapColor,fresnel) * atten;

                return fixed4(color,1.0);
            }

            ENDCG
        }
    }
    Fallback "Reflective/VertexLit"
}
