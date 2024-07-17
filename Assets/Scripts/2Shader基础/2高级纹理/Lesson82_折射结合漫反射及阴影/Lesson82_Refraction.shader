Shader "Unlit/Lesson82_Refraction"
{
    Properties
    {
        //漫反射颜色
        _Color ("Color", Color) = (1, 1, 1, 1)
        //折射颜色
        _RefractColor ("RefractColor", Color) = (1, 1, 1, 1)
        //折射率比值
        _RefractRatio("RefractRatio",Range(0.1,1)) = 0.5
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
            Tags { "LightMode" = "ForwardBase" }
            CGPROGRAM
            
            #pragma vertex vert
            #pragma fragment frag
            #pragma multi_compile_fwdbase
            
            #include "UnityCG.cginc"
            #include "Lighting.cginc"
            #include "AutoLight.cginc"

            samplerCUBE _Cube;
            fixed _RefractRatio;
            fixed _RefractAmount;
            fixed4 _Color;
            fixed4 _RefractColor;

            struct v2f
            {
                float4 pos : SV_POSITION;
                float3 worldRefract : TEXCOORD0;
                fixed3 worldNormal : NORMAL;//世界空间下的法线
                float3 worldPos : TEXCOORD1;//世界空间下的顶点

                SHADOW_COORDS(2)
            };

            v2f vert(appdata_base v)
            {
                v2f o;
                o.pos = UnityObjectToClipPos(v.vertex);
                o.worldNormal = normalize(UnityObjectToWorldNormal(v.normal));
                o.worldPos = mul(unity_ObjectToWorld,v.vertex).xyz;
                fixed3 worldViewDir = UnityWorldSpaceViewDir(o.worldPos);

                o.worldRefract = refract(-normalize(worldViewDir),normalize(o.worldNormal),_RefractRatio);

                TRANSFER_SHADOW(o);

                return o;
            }

            fixed4 frag(v2f i) : SV_Target
            {
                fixed3 worldLightDir = normalize(UnityWorldSpaceLightDir(i.worldPos));
                fixed3 diffuse = _LightColor0.rgb * _Color.rgb * max(0,dot(normalize(i.worldNormal),worldLightDir));


                fixed3 cubemapColor = texCUBE(_Cube,i.worldRefract).rgb * _RefractColor.rgb;

                 UNITY_LIGHT_ATTENUATION(atten,i,i.worldPos);

                 //在漫反射和折射之间进行插值。0：没有折射。1：只有折射效果。 0-1：漫反射和折射叠加
                fixed3 color = UNITY_LIGHTMODEL_AMBIENT.rgb + lerp(diffuse,cubemapColor,_RefractAmount) * atten;

                return fixed4(color,1.0);
            }

            ENDCG
        }
    }
    Fallback "Reflective/VertexLit"
}
