Shader "Unlit/Lesson96_SequentialFrameAnimation"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        //图集行列
        _Rows("Rows",int) = 8
        _Columns("Columns",int) = 8
        //动画切换速度
        _Speed("Speed",float) = 1
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
            float _Rows;
            float _Columns;
            float _Speed;

            v2f vert (appdata_base v)
            {
                v2f o;

                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = v.texcoord;

                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                //得到当前帧
                float frameIndex = (floor(_Time.y * _Speed)) % (_Rows * _Columns);
                //小图片采样时的起始位置计算
                //列，行
                //除以行列，是为了把坐标转换到0~1，用于采样
                //+1：把格子左上角转换为左下角
                //1-：UV坐标采样是从左下角开始的，不同于动画序列从左上角开始
                float2 frameUV = float2((frameIndex % _Columns) / _Columns,1 - (floor(frameIndex / _Columns) + 1) / _Rows);

                //缩放比例：从0~1的UV大图，映射到0~1/n的小图中,采样范围
                float2 size = float2(1 / _Columns,1 / _Rows);

                float2 uv = i.uv * size + frameUV;

                return tex2D(_MainTex,uv);
            }
            ENDCG
        }
    }
}
