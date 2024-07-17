Shader "Unlit/Lesson89_GlassBase" {
    Properties {
        //������
        _MainTex ("MainTex", 2D) = "" { }
        //����������
        _Cube ("Cubemap", Cube) = "" { }
        //����̶� 0����ȫ���䣨�����䣩 1����ȫ���䣨͸�����൱�ڹ�ȫ�������ڲ���
        _RefractAmount ("RefractAmount", Range(0, 1)) = 1
    }
    SubShader {
        Tags { "RenderType" = "Opaque" "Queue" = "Transparent" }
        //����ǰ��Ļ���ݣ����洢��Ĭ����Ⱦ���������
        GrabPass { }
        Pass {
            Tags { "LightMode" = "ForwardBase" }

            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #include "UnityCG.cginc"
            #include "Lighting.cginc"

            sampler2D _MainTex;
            float4 _MainTex_ST;
            samplerCUBE _Cube;
            float _RefractAmount;
            //GrabPassĬ�ϵĴ洢�������
            sampler2D _GrabTexture;

            struct v2f {
                float4 pos : SV_POSITION;//�ü��ռ��¶�������
                //���ڴ洢����Ļͼ���в���������
                float4 grabPos : TEXCOORD0;
                //��ɫ���������uv����
                float2 uv : TEXCOORD1;
                float3 worldReflect : TEXCOORD2;//����ռ��·�������

            };

            v2f vert(appdata_base v) {
                v2f o;
                o.pos = UnityObjectToClipPos(v.vertex);

                //��Ļ����ת��
                o.grabPos = ComputeGrabScreenPos(o.pos);

                //uv�������
                o.uv.xy = v.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;

                float3 worldNormal = UnityObjectToWorldNormal(v.normal);
                fixed3 worldPos = mul(unity_ObjectToWorld, v.vertex).xyz;
                //�ӽǷ����ڲ��������λ��-����λ�á�
                fixed3 worldViewDir = UnityWorldSpaceViewDir(worldPos);
                o.worldReflect = reflect(-worldViewDir, worldNormal);

                return o;
            }

            fixed4 frag(v2f i) : SV_TARGET {
                //��������ɫ����
                fixed4 mainTex = tex2D(_MainTex,i.uv);

                //������ɫ����������ɫ����
                fixed4 reflectColor = texCUBE(_Cube, i.worldReflect) * mainTex;

                //��Ҫ����Ч���������ڲ���֮ǰ������xy��Ļ�����ƫ��
                float2 offset = 1 - _RefractAmount;
                i.grabPos.xy = i.grabPos.xy - offset * 0.1;

                //������ص���ɫ����ץȡ����Ļ��Ⱦ�����н��в�������
                //͸�ӳ���������Ļ����ת����0~1
                fixed2 screenUV = i.grabPos.xy / i.grabPos.w;

                fixed4 grabColor = tex2D(_GrabTexture,screenUV);

                float4 color = reflectColor * (1 - _RefractAmount) + grabColor * _RefractAmount;

                return color;
            }

            ENDCG
        }
    }
}