Shader "Unlit/Lesson79_ReflectBase" {
    Properties {
        //立方体纹理
        _Cube ("Cubemap", Cube) = "" { }
        //反射率
        _Reflectivity ("Reflectivity", Range(0, 1)) = 1
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
            float _Reflectivity;

            struct v2f
            {
                float4 pos : SV_POSITION;//裁剪空间下顶点坐标
                float3 worldReflect : TEXCOORD0;//世界空间下反射向量
            };

            v2f vert(appdata_base v)
            {
                v2f o;
                o.pos = UnityObjectToClipPos(v.vertex);

                float3 worldNormal = UnityObjectToWorldNormal(v.normal);
                fixed3 worldPos = mul(unity_ObjectToWorld,v.vertex).xyz;
                //视角方向，内部是摄像机位置-顶点位置。
                fixed3 worldViewDir = UnityWorldSpaceViewDir(worldPos);
                o.worldReflect = reflect(-worldViewDir,worldNormal);

                return o;
            }

            fixed4 frag(v2f i) : SV_TARGET
            {
                fixed4 cubemapColor = texCUBE(_Cube,i.worldReflect);

                return cubemapColor * _Reflectivity;
            }

            ENDCG
        }
    }
}