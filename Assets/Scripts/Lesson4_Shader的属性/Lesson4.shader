Shader "TeachShader/Lesson4"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        _MyInt("MyInt",Int) = 1
        _MyFloat("MyFloat",Float) = 1.0
        _MyRange("MyRange",Range(0,1)) = 0.5



        _MyColor("MyColor",Color) = (1,1,1,1)
        _MyVector("MyVector",Vector) = (10,11,12,13)

        _My2D("My2D",2D) = "white" {}
        _MyCube("MyCube",Cube) = "" {}

        _My2DArray("My2DArray",2DArray) = "" {}
        _My3D("My3D",3D) = "" {}
    }
    SubShader
    {
        Tags { "RenderType"="Opaque"
                "Queue"="Transparent-1"
        }
        LOD 100
        Cull Off
        Pass
        {
            Name "MyLesson8Pass"
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
                return col;
            }
            ENDCG
        }
        
    }
}
