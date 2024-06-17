Shader "Unlit/Lesson29"
{
    Properties
    {
        _MainColor ("Main Color", Color) = (1,1,1,1)
    }
    SubShader
    {
        Tags{"LightMode"="ForwardBase"}//设置光照模式，向前渲染模式，主要用来处理不透明物体的光照效果
        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #include "UnityCG.cginc"//struct about 
            #include "Lighting.cginc"//light about

            fixed4 _MainColor;//材质漫反射颜色
            struct v2fs
            {
                float4 pos : SV_POSITION;
                fixed3 color : COLOR;
            };

            v2fs vert (appdata_base data)
            {
                //相对世界坐标系下的法线的单位向量
                float3 normal = UnityObjectToWorldNormal(data.normal);
                //相对世界坐标系下的光源方向的单位向量
                float3 lightDir = normalize(_WorldSpaceLightPos0.xyz);
                //labboert光照模型
                //_LightColor0 光照颜色
                fixed3 color = _LightColor0 * _MainColor.rgb * max(0,dot(normal,lightDir));
                v2fs v;
                v.pos = UnityObjectToClipPos(data.vertex);
                //避免背面全黑，使效果更真实
                v.color = color + UNITY_LIGHTMODEL_AMBIENT.rgb;
                return v;

            }

            fixed4 frag (v2fs i) : SV_Target
            {
                //将计算好的labboert光照颜色返回
                return fixed4(i.color,1);
            }
            ENDCG
        }
    }
}
