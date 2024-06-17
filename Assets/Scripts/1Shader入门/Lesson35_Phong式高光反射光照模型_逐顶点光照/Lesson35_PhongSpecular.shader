Shader "Unlit/Lesson35_PhongSpecular"
{
    Properties
    {
        //高光反射颜色
        _SpecularColor("SpecularColor",Color) = (1,1,1,1)
        //光泽度
        _SpecularNumber("SpecularNumber",Range(0,20)) = 0.5
    }
    SubShader
    {
        Tags { "LightMode"="ForwardBase" }

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #include "UnityCG.cginc"
            #include "Lighting.cginc"

            fixed4 _SpecularColor;
            float _SpecularNumber;

            struct v2f
            {
                float4 pos : SV_POSITION;
                fixed3 color : COLOR;
            };

            v2f vert (appdata_base v)
            {
                v2f data;
                data.pos = UnityObjectToClipPos(v.vertex);

                //标准化后观察方向向量
                float3 worldPos = mul(UNITY_MATRIX_M,v.vertex);
                float3 viewDir = _WorldSpaceCameraPos.xyz - worldPos;
                viewDir = normalize(viewDir);
                //标准化后反射方向向量
                float3 lightDir = normalize(_WorldSpaceLightPos0.xyz);
                float3 normal = UnityObjectToWorldNormal(v.normal);
                float3 reflectDir = reflect(-lightDir,normal);

                float3 color = _LightColor0.rgb * _SpecularColor.rgb * pow(max(0,dot(viewDir,reflectDir)),_SpecularNumber); 
                data.color = color;
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
