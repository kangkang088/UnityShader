Shader "Unlit/Lesson93_ShaderPT"
{
    Properties
    {
        //期盼行列数
        _TileCount("TileCount",Float) = 8
        //格子颜色1
        _Color1("Color1",Color) = (1,1,1,1) 
        //格子颜色2
        _Color2("Color2",Color) = (0,0,0,1)
    }
    SubShader
    {
        Tags{"RenderType"="Opaque"}

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #include "UnityCG.cginc"

            float _TileCount;
            float4 _Color1;
            float4 _Color2;

            struct v2f
            {
                float2 uv : TEXCOORD0;
                float4 vertex : SV_POSITION;
            };

            v2f vert (appdata_base v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = v.texcoord;
                return o;
            }

            fixed4 frag (v2f i) : SV_TARGET
            {
                //把uv坐标从0~1变为0~_TileCount
                float2 uv = i.uv * _TileCount;
                float2 posIndex = floor(uv);
                float value = (posIndex.x + posIndex.y) % 2;

                return lerp(_Color1,_Color2,value);
            }
            ENDCG
        }
    }
}
