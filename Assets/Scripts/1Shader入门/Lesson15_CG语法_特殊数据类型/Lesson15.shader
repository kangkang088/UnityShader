Shader "Unlit/Lesson15"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 100

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            // make fog work
            #pragma multi_compile_fog

            #include "UnityCG.cginc"

            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
                UNITY_FOG_COORDS(1)
                float4 vertex : SV_POSITION;
            };

            sampler2D _MainTex;
            float4 _MainTex_ST;

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                UNITY_TRANSFER_FOG(o,o.vertex);
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                // sample the texture
                fixed4 col = tex2D(_MainTex, i.uv);
                // apply fog
                UNITY_APPLY_FOG(i.fogCoord, col);

                // 特殊数据类型
                float2 f2 = float2(1, 2);
                float3 f3 = float3(1, 2, 3);
                float4 f4 = float4(1, 2, 3, 4);
                half2 h2 = half2(1, 2);
                half3 h3 = half3(1, 2, 3);
                half4 h4 = half4(1, 2, 3, 4);
                fixed2 fx2 = fixed2(1, 2);
                fixed3 fx3 = fixed3(1, 2, 3);
                fixed4 fx4 = fixed4(1, 2, 3, 4);
                int2 i2 = int2(1, 2);
                int3 i3 = int3(1, 2, 3);
                int4 i4 = int4(1, 2, 3, 4);
                uint2 ui2 = uint2(1, 2);
                uint3 ui3 = uint3(1, 2, 3);
                uint4 ui4 = uint4(1, 2, 3, 4);

                int2x2 i2x2 = int2x2(1, 2, 3, 4);
                int3x3 i3x3 = int3x3(1, 2, 3, 4, 5, 6, 7, 8, 9);
                int4x4 i4x4 = int4x4(1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16);
                uint2x2 ui2x2 = uint2x2(1, 2, 3, 4);
                uint3x3 ui3x3 = uint3x3(1, 2, 3, 4, 5, 6, 7, 8, 9);
                uint4x4 ui4x4 = uint4x4(1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16);
                float1x1 f1x1 = float1x1(1);
                float2x1 f2x1 = float2x1(1, 2);
                float3x1 f3x1 = float3x1(1, 2, 3);
                float4x1 f4x1 = float4x1(1, 2, 3, 4);
                half1x1 h1x1 = half1x1(1);
                half2x1 h2x1 = half2x1(1, 2);
                half3x1 h3x1 = half3x1(1, 2, 3);
                half4x1 h4x1 = half4x1(1, 2, 3, 4);
                
                //fixed1x1 m1x1 = fixed1x1(1);
                fixed2x2 m2x2 = fixed2x2(1, 2, 3, 4);
                fixed3x3 m3x3 = fixed3x3(1, 2, 3, 4, 5, 6, 7, 8, 9);
                fixed4x4 m4x4 = fixed4x4(1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16);

                float3 a = float3(1, 2, 3);
                float3 b = float3(4, 5, 6);
                bool3 c = a < b; 
                 


                return col;
            }
            ENDCG
        }
    }
}
