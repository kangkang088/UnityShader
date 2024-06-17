Shader "Unlit/Lesson22"
{
    Properties
    {
        
    }
    SubShader
    {
        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            struct a2v
            {
                float4 vertex : POSITION;
                float3 normal : NORMAL;
                float2 uv : TEXCOORD0;
            };
            struct v2f
            {
                float4 pos : SV_POSITION;
                float3 normal : NORMAL;
                float2 uv : TEXCOORD0;
            };
            v2f vert(a2v data)
            {
                v2f v2fData;
                v2fData.pos = UnityObjectToClipPos(data.vertex);
                v2fData.normal = data.normal;
                v2fData.uv = data.uv;
                return v2fData;
              
            }
            fixed4 frag(v2f data):SV_TARGET
            {
              return fixed4(0,1,0,1);
            }
            ENDCG
        }
    }
}
