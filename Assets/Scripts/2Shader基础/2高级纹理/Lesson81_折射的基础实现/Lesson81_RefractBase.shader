Shader "Unlit/Lesson81_RefractBase"
{
    Properties
    {
        //介质A折射率
        _RefractiveIndexA("RefractiveIndexA",Range(1,2)) = 1
        //介质B折射率
        _RefractiveIndexB("RefractiveIndexB",Range(1,2)) = 1.3
        //立方体纹理贴图
        _Cube("Cubemap",Cube) = ""{}
        //折射程度
        _RefractAmount("RefractAmount",Range(0,1)) = 1
    }
    SubShader
    {
        Tags {"RenderType"="Opaque" "Queue"="Geometry"}
        Pass
        {
            CGPROGRAM
            
            #pragma vertex vert
            #pragma fragment frag
            
            #include "UnityCG.cginc"

            samplerCUBE _Cube;
            fixed _RefractiveIndexA;
            fixed _RefractiveIndexB;
            fixed _RefractAmount;

            struct v2f
            {
                float4 pos : SV_POSITION;
                float3 worldRefract : TEXCOORD0;
            };

            v2f vert(appdata_base v)
            {
                v2f o;
                o.pos = UnityObjectToClipPos(v.vertex);
                fixed3 worldNormal = normalize(UnityObjectToWorldNormal(v.normal));
                fixed3 worldPos = mul(unity_ObjectToWorld,v.vertex).xyz;
                fixed3 worldViewDir = UnityWorldSpaceViewDir(worldPos);

                o.worldRefract = refract(-normalize(worldViewDir),normalize(worldNormal),_RefractiveIndexA / _RefractiveIndexB);

                return o;
            }

            float4 frag(v2f i) : SV_Target
            {
                fixed4 cubemapColor = texCUBE(_Cube,i.worldRefract);
                return cubemapColor * _RefractAmount;
            }

            ENDCG
        }
    }
}
