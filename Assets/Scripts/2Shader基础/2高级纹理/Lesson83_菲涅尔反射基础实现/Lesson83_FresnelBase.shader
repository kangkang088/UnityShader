Shader "Unlit/Lesson83_FresnelBase" {
    Properties {
        //立方体纹理
        _Cube ("Cubemap", Cube) = "" { }
        //菲涅尔反射中介质的反射率
        _FresnelScale ("FresnelScale", Range(0, 1)) = 1
    }
    SubShader {
        Tags { "RenderType" = "Opaque" "Queue" = "Geometry" }
        Pass {
            Tags { "LightMode" = "ForwardBase" }

            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #include "UnityCG.cginc"
            #include "Lighting.cginc"

            samplerCUBE _Cube;
            float _FresnelScale;

            struct v2f {
                float4 pos : SV_POSITION;//裁剪空间下顶点坐标
                float3 worldNormal : NORMAL;//世界空间下的法线
                float3 worldViewDir : TEXCOORD0;//世界空间下视角的方向
                float3 worldReflect : TEXCOORD1;//世界空间下反射向量

            };

            v2f vert(appdata_base v) {
                v2f o;
                o.pos = UnityObjectToClipPos(v.vertex);

                o.worldNormal = UnityObjectToWorldNormal(v.normal);
                fixed3 worldPos = mul(unity_ObjectToWorld, v.vertex).xyz;
                //视角方向，内部是摄像机位置-顶点位置。
                o.worldViewDir = UnityWorldSpaceViewDir(worldPos);
                o.worldReflect = reflect(-o.worldViewDir, o.worldNormal);

                return o;
            }

            fixed4 frag(v2f i) : SV_TARGET {
                fixed4 cubemapColor = texCUBE(_Cube, i.worldReflect);

                //利用schlick菲涅尔近似等式，计算菲涅尔反射率
                fixed fresnel = _FresnelScale + (1 - _FresnelScale) * pow(1 - dot(normalize(i.worldViewDir), normalize(i.worldNormal)), 5);

                return cubemapColor * fresnel;
            }

            ENDCG
        }
    }
}