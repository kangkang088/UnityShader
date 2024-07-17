Shader "Unlit/Lesson79_ReflectBase" {
    Properties {
        //����������
        _Cube ("Cubemap", Cube) = "" { }
        //������
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
                float4 pos : SV_POSITION;//�ü��ռ��¶�������
                float3 worldReflect : TEXCOORD0;//����ռ��·�������
            };

            v2f vert(appdata_base v)
            {
                v2f o;
                o.pos = UnityObjectToClipPos(v.vertex);

                float3 worldNormal = UnityObjectToWorldNormal(v.normal);
                fixed3 worldPos = mul(unity_ObjectToWorld,v.vertex).xyz;
                //�ӽǷ����ڲ��������λ��-����λ�á�
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