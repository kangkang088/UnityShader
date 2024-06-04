Shader "Unlit/Lesson38_Phong"
{
    Properties
    {
        _MainColor ("Main Color", Color) = (1,1,1,1)

        //高光反射颜色
        _SpecularColor("SpecularColor",Color) = (1,1,1,1)
        //光泽度
        _SpecularNumber("SpecularNumber",Range(0,20)) = 0.5
    }
    SubShader
    {
        

        Pass
        {
            Tags { "LightMode"="ForwardBase" }
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #include "UnityCG.cginc"
            #include "Lighting.cginc"

            fixed4 _MainColor;//材质漫反射颜色
            fixed4 _SpecularColor;
            float _SpecularNumber;

            struct v2f
            {
                float4 pos : SV_POSITION;
                fixed3 color : COLOR;
            };
            //计算兰伯特光照模型相关颜色函数
            fixed3 GetLambertColor(in float3 objNormal)
            {
                //相对世界坐标系下的法线的单位向量
                float3 normal = UnityObjectToWorldNormal(objNormal);
                //相对世界坐标系下的光源方向的单位向量
                float3 lightDir = normalize(_WorldSpaceLightPos0.xyz);
                //labboert光照模型
                //_LightColor0 光照颜色
                fixed3 color = _LightColor0 * _MainColor.rgb * max(0,dot(normal,lightDir));

                return color;
            }
            //计算Phong式高光反射相关颜色
            fixed3 GetSpecularColor(in float4 objVertex,in float3 objNormal)
            {
                //标准化后观察方向向量
                float3 worldPos = mul(UNITY_MATRIX_M,objVertex);
                float3 viewDir = _WorldSpaceCameraPos.xyz - worldPos;
                viewDir = normalize(viewDir);
                //标准化后反射方向向量
                float3 lightDir = normalize(_WorldSpaceLightPos0.xyz);
                float3 normal = UnityObjectToWorldNormal(objNormal);
                float3 reflectDir = reflect(-lightDir,normal);

                float3 color = _LightColor0.rgb * _SpecularColor.rgb * pow(max(0,dot(viewDir,reflectDir)),_SpecularNumber); 

                return color;
            }

            v2f vert (appdata_base v)
            {
                v2f data;
                data.pos = UnityObjectToClipPos(v.vertex);

                float3 lambertColor = GetLambertColor(v.normal);
                float3 specularColor = GetSpecularColor(v.vertex,v.normal);

                data.color = UNITY_LIGHTMODEL_AMBIENT.rgb + lambertColor + specularColor;
                return data;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                return fixed4(i.color.rgb,1);
            }
            ENDCG
        }
    }
}
