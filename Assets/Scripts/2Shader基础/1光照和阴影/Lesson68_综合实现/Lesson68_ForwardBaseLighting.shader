Shader "Unlit/Lesson68_ForwardBaseLighting" {
    Properties {
        _MainColor ("Main Color", Color) = (1, 1, 1, 1)
        //高光反射颜色
        _SpecularColor ("SpecularColor", Color) = (1, 1, 1, 1)
        //光泽度
        _SpecularNumber ("SpecularNumber", Range(0, 20)) = 0.5
    }
    SubShader {
        //Base pass 基础渲染通道
        Pass {
            Tags { "LightMode" = "ForwardBase" }
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            //帮助我们编译所有变体，并且保证衰减相关光照变量能够正确赋值到对应的内置变量中
            #pragma multi_compile_fwdbase

            #include "UnityCG.cginc"
            #include "Lighting.cginc"

            fixed4 _MainColor;//材质漫反射颜色
            fixed4 _SpecularColor;
            float _SpecularNumber;

            struct v2f {
                float4 pos : SV_POSITION;
                fixed3 wNormal : NORMAL;
                //世界空间下的顶点坐标
                float3 wPOS : TEXCOORD0;
            };

            fixed3 GetLambertColorFragment(in float3 wNormal) {
                float3 lightDir = normalize(_WorldSpaceLightPos0.xyz);
                fixed3 color = _MainColor.rgb * _LightColor0.rgb * max(0, (dot(wNormal, lightDir)));
                return color;
            }
            fixed3 GetSpecularColorFragment(in float3 wPos, in float3 objNormal) {
                float3 viewDir = _WorldSpaceCameraPos.xyz - wPos;
                viewDir = normalize(viewDir);

                float3 lightDir = normalize(_WorldSpaceLightPos0.xyz);
                float3 halfAngle = normalize(viewDir + lightDir);

                float3 color = _LightColor0.rgb * _SpecularColor.rgb * pow(max(0, dot(objNormal, halfAngle)), _SpecularNumber);

                return color;
            }

            v2f vert(appdata_base v) {
                v2f data;
                data.pos = UnityObjectToClipPos(v.vertex);
                data.wNormal = UnityObjectToWorldNormal(v.normal);
                data.wPOS = mul(unity_ObjectToWorld, v.vertex).xyz;
                return data;
            }

            fixed4 frag(v2f i) : SV_Target {

                fixed3 lambertColor = GetLambertColorFragment(i.wNormal);

                fixed3 specularColor = GetSpecularColorFragment(i.wPOS, i.wNormal);

                fixed attenuation = 1;

                //衰减值会和（漫反射颜色+高光反射颜色）后进行乘法运算
                fixed3 blinnPhongColorFragment = UNITY_LIGHTMODEL_AMBIENT.rgb + (lambertColor + specularColor) * attenuation;

                return fixed4(blinnPhongColorFragment.rgb, 1);
            }
            ENDCG
        }

        //Additional pass 附加渲染通道
        Pass {
            Tags { "LightMode" = "ForwardAdd" }

            //线性减淡效果，进行光照颜色混合
            Blend One One

            CGPROGRAM

            #pragma vertex vert
            #pragma fragment frag
            //帮助我们编译所有变体，并且保证衰减相关光照变量能够正确赋值到对应的内置变量中
            #pragma multi_compile_fwdadd

            #include "UnityCG.cginc"
            #include "Lighting.cginc"

            fixed4 _MainColor;//材质漫反射颜色
            fixed4 _SpecularColor;
            float _SpecularNumber;

            struct v2f {
                float4 pos : SV_POSITION;
                fixed3 wNormal : NORMAL;
                //世界空间下的顶点坐标
                float3 wPOS : TEXCOORD0;
            };


            v2f vert(appdata_base v) {
                v2f data;
                data.pos = UnityObjectToClipPos(v.vertex);
                data.wNormal = UnityObjectToWorldNormal(v.normal);
                data.wPOS = mul(unity_ObjectToWorld, v.vertex).xyz;
                return data;
            }

            fixed4 frag(v2f i) : SV_Target {
                //兰伯特漫反射
                fixed3 worldNormal = normalize(i.wNormal);

                //平行光 光方向相同，即为光源的位置
                //点光源和聚光灯 光的方向不同，为光的位置 - 顶点位置
                #if defined(_DIRECTIONAL_LIGHT)
                    fixed3 worldLightDir = normalize(_WorldSpaceLightPos0.xyz);
                #else
                    fixed3 worldLightDir = normalize(_WorldSpaceLightPos0.xyz - i.wPOS);
                #endif

                fixed3 diffuse = _LightColor0.rgb * _MainColor.rgb * max(0,dot(worldNormal,worldLightDir));

                //BlinnPhong高光反射
                fixed3 viewDir = normalize(_WorldSpaceCameraPos.xyz - i.wPOS.xyz);

                fixed3 halfDir = normalize(viewDir + worldLightDir);

                fixed3 specular = _LightColor0.rgb * _SpecularColor.rgb * pow(max(0,dot(worldNormal,halfDir)),_SpecularNumber);

                //衰减值
                #if defined(_DIRECTIONAL_LIGHT)

                    fixed attenuation = 1;

                #elif defined(_POINT_LIGHT)

                    //世家坐标系下的顶点转换到光源坐标系下
                    float3 lightCoordinate  = mul(unity_WorldToLight,float4(i.wPOS,1)).xyz;

                    float3 attenuation = tex2D(_LightTexture0,dot(lightCoordinate,lightCoordinate).xx).UNITY_ATTEN_CHANNEL;

                #elif defined(_SPOT_LIGHT)

                    float4 lightCoordinate  = mul(unity_WorldToLight,float4(i.wPOS,1));
                    
                    fixed attenuation = (lightCoordinate.z > 0) * 
                                        tex2D(_LightTexture0,lightCoordinate.xy / lightCoordinate.w + 0.5).w * 
                                        tex2D(_LightTextureB0,dot(lightCoordinate,lightCoordinate).xx).UNITY_ATTEN_CHANNEL;
                #else

                    fixed attenuation = 1;

                #endif

                //衰减值会和（漫反射颜色+高光反射颜色）后进行乘法运算
                //在附加渲染通道中，不需要再加上环境光颜色了，它只需要计算一次，在基础渲染通道中已经计算了
                fixed3 blinnPhongColorFragment = (diffuse + specular) * attenuation;

                return fixed4(blinnPhongColorFragment.rgb, 1);
            }
            ENDCG
        }

        //该Pass用于进行阴影投影，主要是用来计算阴影映射纹理的
        Pass {

            Tags{"LightMode"="ShadowCaster"}

            CGPROGRAM

            #pragma vertex vert
            #pragma fragment frag

            //该编译指令时告诉Unity编译器生成多个着色器变体
            //用于支持不同类型的阴影（SM，SSSM等等）
            //可以确保着色器能够在所有可能的阴影投射模式下正确渲染
            #pragma multi_compile_shadowcaster

            #include "UnityCG.cginc"

            struct v2f
            {
                //顶点到片元着色器阴影投射结构体数据宏
                //这个宏定义了一些标准的成员变量
                //这些变量用于在阴影投射路径中传递顶点数据到片元着色器
                //我们主要在结构体中使用
                V2F_SHADOW_CASTER;
            };

            v2f vert(appdata_base v){
                
                v2f data;

                //转移阴影投射器法线偏移宏
                //用于在顶点着色器中计算和传递阴影投射所需的变量
                //主要做了
                //2-2-1.将对象空间的顶点位置转换为裁剪空间的位置
                //2-2-2.考虑法线偏移，以减轻阴影失真问题，尤其是在处理自阴影时
                //2-2-3.传递顶点的投影空间位置，用于后续的阴影计算
                //我们主要在顶点着色器中使用
                TRANSFER_SHADOW_CASTER_NORMALOFFSET(data);

                return data;    
            }

            float4 frag(v2f i):SV_TARGET{
                //阴影投射片元宏
                //将深度值写入到阴影映射纹理中
                //我们主要在片元着色器中使用

                SHADOW_CASTER_FRAGMENT(i);
            }  

            ENDCG
        }

    }
    //FallBack "Specular"
}