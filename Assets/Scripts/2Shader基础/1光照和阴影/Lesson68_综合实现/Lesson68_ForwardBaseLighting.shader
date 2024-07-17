Shader "Unlit/Lesson68_ForwardBaseLighting" {
    Properties {
        _MainColor ("Main Color", Color) = (1, 1, 1, 1)
        //�߹ⷴ����ɫ
        _SpecularColor ("SpecularColor", Color) = (1, 1, 1, 1)
        //�����
        _SpecularNumber ("SpecularNumber", Range(0, 20)) = 0.5
    }
    SubShader {
        //Base pass ������Ⱦͨ��
        Pass {
            Tags { "LightMode" = "ForwardBase" }
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            //�������Ǳ������б��壬���ұ�֤˥����ع��ձ����ܹ���ȷ��ֵ����Ӧ�����ñ�����
            #pragma multi_compile_fwdbase

            #include "UnityCG.cginc"
            #include "Lighting.cginc"

            fixed4 _MainColor;//������������ɫ
            fixed4 _SpecularColor;
            float _SpecularNumber;

            struct v2f {
                float4 pos : SV_POSITION;
                fixed3 wNormal : NORMAL;
                //����ռ��µĶ�������
                float3 wPOS : TEXCOORD0;
            };

            fixed3 GetLambertColorFragment(in float3 wNormal) {
                float3 lightDir = normalize(_WorldSpaceLightPos0.xyz);
                fixed3 color = _MainColor.rgb * _LightColor0.rgb * max(0, (dot(wNormal, lightDir)));
                return color;
            }
            fixed3 GetSpecularColorFragment(in float3 wPos, in float3 objNormal) {
                float3 viewDir = _WorldSpaceCameraPos.xyz - wPos;
                viewDir = normalize(viewDir);

                float3 lightDir = normalize(_WorldSpaceLightPos0.xyz);
                float3 halfAngle = normalize(viewDir + lightDir);

                float3 color = _LightColor0.rgb * _SpecularColor.rgb * pow(max(0, dot(objNormal, halfAngle)), _SpecularNumber);

                return color;
            }

            v2f vert(appdata_base v) {
                v2f data;
                data.pos = UnityObjectToClipPos(v.vertex);
                data.wNormal = UnityObjectToWorldNormal(v.normal);
                data.wPOS = mul(unity_ObjectToWorld, v.vertex).xyz;
                return data;
            }

            fixed4 frag(v2f i) : SV_Target {

                fixed3 lambertColor = GetLambertColorFragment(i.wNormal);

                fixed3 specularColor = GetSpecularColorFragment(i.wPOS, i.wNormal);

                fixed attenuation = 1;

                //˥��ֵ��ͣ���������ɫ+�߹ⷴ����ɫ������г˷�����
                fixed3 blinnPhongColorFragment = UNITY_LIGHTMODEL_AMBIENT.rgb + (lambertColor + specularColor) * attenuation;

                return fixed4(blinnPhongColorFragment.rgb, 1);
            }
            ENDCG
        }

        //Additional pass ������Ⱦͨ��
        Pass {
            Tags { "LightMode" = "ForwardAdd" }

            //���Լ���Ч�������й�����ɫ���
            Blend One One

            CGPROGRAM

            #pragma vertex vert
            #pragma fragment frag
            //�������Ǳ������б��壬���ұ�֤˥����ع��ձ����ܹ���ȷ��ֵ����Ӧ�����ñ�����
            #pragma multi_compile_fwdadd

            #include "UnityCG.cginc"
            #include "Lighting.cginc"

            fixed4 _MainColor;//������������ɫ
            fixed4 _SpecularColor;
            float _SpecularNumber;

            struct v2f {
                float4 pos : SV_POSITION;
                fixed3 wNormal : NORMAL;
                //����ռ��µĶ�������
                float3 wPOS : TEXCOORD0;
            };


            v2f vert(appdata_base v) {
                v2f data;
                data.pos = UnityObjectToClipPos(v.vertex);
                data.wNormal = UnityObjectToWorldNormal(v.normal);
                data.wPOS = mul(unity_ObjectToWorld, v.vertex).xyz;
                return data;
            }

            fixed4 frag(v2f i) : SV_Target {
                //������������
                fixed3 worldNormal = normalize(i.wNormal);

                //ƽ�й� �ⷽ����ͬ����Ϊ��Դ��λ��
                //���Դ�;۹�� ��ķ���ͬ��Ϊ���λ�� - ����λ��
                #if defined(_DIRECTIONAL_LIGHT)
                    fixed3 worldLightDir = normalize(_WorldSpaceLightPos0.xyz);
                #else
                    fixed3 worldLightDir = normalize(_WorldSpaceLightPos0.xyz - i.wPOS);
                #endif

                fixed3 diffuse = _LightColor0.rgb * _MainColor.rgb * max(0,dot(worldNormal,worldLightDir));

                //BlinnPhong�߹ⷴ��
                fixed3 viewDir = normalize(_WorldSpaceCameraPos.xyz - i.wPOS.xyz);

                fixed3 halfDir = normalize(viewDir + worldLightDir);

                fixed3 specular = _LightColor0.rgb * _SpecularColor.rgb * pow(max(0,dot(worldNormal,halfDir)),_SpecularNumber);

                //˥��ֵ
                #if defined(_DIRECTIONAL_LIGHT)

                    fixed attenuation = 1;

                #elif defined(_POINT_LIGHT)

                    //��������ϵ�µĶ���ת������Դ����ϵ��
                    float3 lightCoordinate  = mul(unity_WorldToLight,float4(i.wPOS,1)).xyz;

                    float3 attenuation = tex2D(_LightTexture0,dot(lightCoordinate,lightCoordinate).xx).UNITY_ATTEN_CHANNEL;

                #elif defined(_SPOT_LIGHT)

                    float4 lightCoordinate  = mul(unity_WorldToLight,float4(i.wPOS,1));
                    
                    fixed attenuation = (lightCoordinate.z > 0) * 
                                        tex2D(_LightTexture0,lightCoordinate.xy / lightCoordinate.w + 0.5).w * 
                                        tex2D(_LightTextureB0,dot(lightCoordinate,lightCoordinate).xx).UNITY_ATTEN_CHANNEL;
                #else

                    fixed attenuation = 1;

                #endif

                //˥��ֵ��ͣ���������ɫ+�߹ⷴ����ɫ������г˷�����
                //�ڸ�����Ⱦͨ���У�����Ҫ�ټ��ϻ�������ɫ�ˣ���ֻ��Ҫ����һ�Σ��ڻ�����Ⱦͨ�����Ѿ�������
                fixed3 blinnPhongColorFragment = (diffuse + specular) * attenuation;

                return fixed4(blinnPhongColorFragment.rgb, 1);
            }
            ENDCG
        }

        //��Pass���ڽ�����ӰͶӰ����Ҫ������������Ӱӳ�������
        Pass {

            Tags{"LightMode"="ShadowCaster"}

            CGPROGRAM

            #pragma vertex vert
            #pragma fragment frag

            //�ñ���ָ��ʱ����Unity���������ɶ����ɫ������
            //����֧�ֲ�ͬ���͵���Ӱ��SM��SSSM�ȵȣ�
            //����ȷ����ɫ���ܹ������п��ܵ���ӰͶ��ģʽ����ȷ��Ⱦ
            #pragma multi_compile_shadowcaster

            #include "UnityCG.cginc"

            struct v2f
            {
                //���㵽ƬԪ��ɫ����ӰͶ��ṹ�����ݺ�
                //����궨����һЩ��׼�ĳ�Ա����
                //��Щ������������ӰͶ��·���д��ݶ������ݵ�ƬԪ��ɫ��
                //������Ҫ�ڽṹ����ʹ��
                V2F_SHADOW_CASTER;
            };

            v2f vert(appdata_base v){
                
                v2f data;

                //ת����ӰͶ��������ƫ�ƺ�
                //�����ڶ�����ɫ���м���ʹ�����ӰͶ������ı���
                //��Ҫ����
                //2-2-1.������ռ�Ķ���λ��ת��Ϊ�ü��ռ��λ��
                //2-2-2.���Ƿ���ƫ�ƣ��Լ�����Ӱʧ�����⣬�������ڴ�������Ӱʱ
                //2-2-3.���ݶ����ͶӰ�ռ�λ�ã����ں�������Ӱ����
                //������Ҫ�ڶ�����ɫ����ʹ��
                TRANSFER_SHADOW_CASTER_NORMALOFFSET(data);

                return data;    
            }

            float4 frag(v2f i):SV_TARGET{
                //��ӰͶ��ƬԪ��
                //�����ֵд�뵽��Ӱӳ��������
                //������Ҫ��ƬԪ��ɫ����ʹ��

                SHADOW_CASTER_FRAGMENT(i);
            }  

            ENDCG
        }

    }
    //FallBack "Specular"
}