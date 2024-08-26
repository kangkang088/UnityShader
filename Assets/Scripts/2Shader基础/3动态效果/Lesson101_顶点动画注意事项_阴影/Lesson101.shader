Shader "Unlit/Lesson101"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        _Color("Color",Color) = (1,1,1,1)
        //��������
        _WaveAmplitude("WaveAmplitude",Float) = 1 
        //����Ƶ��
        _WaveFrequency("WaveFrequency",Float) = 1
        //�����ĵ���
        _InversalWaveLength("InversalWaveLength",Float) = 1

        //����仯�ٶ�
        _Speed("Speed",Float) = 1
    }
    SubShader
    {
        Tags { "RenderType"="Transparent" "Queue"="Transparent" "IgnoreProjector"="True" "DisableBatching"="True" }

        Pass
        {
            ZWrite Off
            Blend SrcAlpha OneMinusSrcAlpha

            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #include "UnityCG.cginc"

            struct v2f
            {
                float2 uv : TEXCOORD0;
                float4 vertex : SV_POSITION;
            };

            sampler2D _MainTex;
            float4 _MainTex_ST;
            float4 _Color;
            float _WaveAmplitude;
            float _WaveFrequency;
            float _InversalWaveLength;
            float _Speed;

            v2f vert (appdata_base v)
            {
                v2f o;

                //ģ�Ϳռ��µ�ƫ��λ��
                float4 offset;
                //��x�᷽��ģ�Ϳռ䣩ƫ��
                offset.x = sin(_Time.y * _WaveFrequency + v.vertex.z * _InversalWaveLength) * _WaveAmplitude;
                offset.yzw = float3(0,0,0);
                o.vertex = UnityObjectToClipPos(v.vertex + offset);

                o.uv = v.texcoord * _MainTex_ST.xy + _MainTex_ST.zw;

                o.uv += float2(0,_Time.y * _Speed);

                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                fixed4 color = tex2D(_MainTex,i.uv);
                color.rgb = color.rgb * _Color.rgb;
                return color;
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

            float _WaveAmplitude;
            float _WaveFrequency;
            float _InversalWaveLength;

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

                //ģ�Ϳռ��µ�ƫ��λ��
                float4 offset;
                //��x�᷽��ģ�Ϳռ䣩ƫ��
                offset.x = sin(_Time.y * _WaveFrequency + v.vertex.z * _InversalWaveLength) * _WaveAmplitude;
                offset.yzw = float3(0,0,0);

                v.vertex = v.vertex + offset;

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

    Fallback "VertexLit"
}
