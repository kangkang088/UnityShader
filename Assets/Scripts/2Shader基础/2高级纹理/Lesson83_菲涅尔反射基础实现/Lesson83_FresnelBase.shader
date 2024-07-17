Shader "Unlit/Lesson83_FresnelBase" {
    Properties {
        //����������
        _Cube ("Cubemap", Cube) = "" { }
        //�����������н��ʵķ�����
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
                float4 pos : SV_POSITION;//�ü��ռ��¶�������
                float3 worldNormal : NORMAL;//����ռ��µķ���
                float3 worldViewDir : TEXCOORD0;//����ռ����ӽǵķ���
                float3 worldReflect : TEXCOORD1;//����ռ��·�������

            };

            v2f vert(appdata_base v) {
                v2f o;
                o.pos = UnityObjectToClipPos(v.vertex);

                o.worldNormal = UnityObjectToWorldNormal(v.normal);
                fixed3 worldPos = mul(unity_ObjectToWorld, v.vertex).xyz;
                //�ӽǷ����ڲ��������λ��-����λ�á�
                o.worldViewDir = UnityWorldSpaceViewDir(worldPos);
                o.worldReflect = reflect(-o.worldViewDir, o.worldNormal);

                return o;
            }

            fixed4 frag(v2f i) : SV_TARGET {
                fixed4 cubemapColor = texCUBE(_Cube, i.worldReflect);

                //����schlick���������Ƶ�ʽ�����������������
                fixed fresnel = _FresnelScale + (1 - _FresnelScale) * pow(1 - dot(normalize(i.worldViewDir), normalize(i.worldNormal)), 5);

                return cubemapColor * fresnel;
            }

            ENDCG
        }
    }
}