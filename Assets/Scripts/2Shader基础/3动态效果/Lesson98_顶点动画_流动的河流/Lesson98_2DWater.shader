Shader "Unlit/Lesson98_2DWater"
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
    }
}
