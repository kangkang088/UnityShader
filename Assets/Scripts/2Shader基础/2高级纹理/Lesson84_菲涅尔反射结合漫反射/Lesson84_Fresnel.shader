Shader "Unlit/Lesson84_Fresnel"
{
    Properties {
        //��������ɫ
        _Color ("Color", Color) = (1, 1, 1, 1)
        //����������
        _Cube ("Cubemap", Cube) = "" { }
        //������
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
                float4 pos : SV_POSITION;//�ü��ռ��¶�������
                fixed3 worldNormal : NORMAL;//����ռ��µķ���
                float3 worldPos : TEXCOORD0;//����ռ��µĶ���
                float3 worldReflect : TEXCOORD1;//����ռ��·�������
                float3 worldViewDir : TEXCOORD2;//����ռ����ӽǵķ���

                SHADOW_COORDS(3)

            };

            v2f vert(appdata_base v) {
                v2f o;
                o.pos = UnityObjectToClipPos(v.vertex);

                o.worldNormal = UnityObjectToWorldNormal(v.normal);
                o.worldPos = mul(unity_ObjectToWorld, v.vertex).xyz;
                //�ӽǷ����ڲ��������λ��-����λ�á�
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

                //�����������ʼ��㣬����schlick���Ƶ�ʽ
                fixed fresnel = _FresnelScale + (1 - _FresnelScale) * pow(1 - dot(normalize(i.worldViewDir),normalize(i.worldNormal)),5);

                //��������ͷ���������֮����в�ֵ��0��û�з��������䡣1��ֻ�з���������Ч���� 0-1��������ͷ������
                fixed3 color = UNITY_LIGHTMODEL_AMBIENT.rgb + lerp(diffuse,cubemapColor,fresnel) * atten;

                return fixed4(color,1.0);
            }

            ENDCG
        }
    }
    Fallback "Reflective/VertexLit"
}
