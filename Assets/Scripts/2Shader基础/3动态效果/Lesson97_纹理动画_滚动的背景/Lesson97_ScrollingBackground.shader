Shader "Unlit/Lesson97_ScrollingBackground"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        //水平和数值的滚动速度
        _ScrollSpeedU("ScrollSpeedU",float) = 0.5
        _ScrollSpeedV("ScrollSpeedV",float) = 0.5
    }
    SubShader
    {
        Tags { "RenderType"="Transparent" "Queue"="Transparent" "IgnoreProjector"="True" }

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
            float _ScrollSpeedU;
            float _ScrollSpeedV;

            v2f vert (appdata_base v)
            {
                v2f o;
              
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = v.texcoord;

                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                //利用时间计算UV偏移
                float2 scrollUV = frac(i.uv + float2(_Time.y * _ScrollSpeedU, _Time.y * _ScrollSpeedV));

                return tex2D(_MainTex,scrollUV);
            }
            ENDCG
        }
    }
}
