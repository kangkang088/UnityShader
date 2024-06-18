Shader "Unlit/Lesson72_Attenuation"
{
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
            //该内置文件中，有用于计算阴影时需要使用的三剑客
            #include "AutoLight.cginc"

            fixed4 _MainColor;//材质漫反射颜色
            fixed4 _SpecularColor;
            float _SpecularNumber;

            struct v2f {
                float4 pos : SV_POSITION;
                fixed3 wNormal : NORMAL;
                //世界空间下的顶点坐标
                float3 wPOS : TEXCOORD0;

                //(阴影坐标宏)
                //该宏在v2f结构体（顶点着色器返回值）中使用
                //本质上就是声明了一个用于对阴影纹理进行采样的坐标
                //在内部实际上就是声明了一个名为_ShadowCoord的阴影纹理坐标变量
                //需要注意的是：
                //在使用时 SHADOW_COORDS(2) 传入参数2
                //表示需要时下一个可用的插值寄存器的索引值   
                SHADOW_COORDS(2)
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

                //(转移阴影宏)
                //该宏会在内部自己判断应该使用哪种阴影映射技术（SM、SSSM）
                //最终的目的就是将顶点进行坐标转换并存储到_ShadowCoord阴影纹理坐标变量中
                //需要注意的是：
                //1.该宏会在内部使用顶点着色器中传入的结构体
                //该结构体中顶点的命名必须是vertex
                //2.该宏会在内部使用顶点着色器的返回结构体
                //其中的顶点位置命名必须是pos
                TRANSFER_SHADOW(data);

                return data;
            }

            fixed4 frag(v2f i) : SV_Target {

                fixed3 lambertColor = GetLambertColorFragment(i.wNormal);

                fixed3 specularColor = GetSpecularColorFragment(i.wPOS, i.wNormal);

                //阴影衰减值
                //(阴影衰减宏)
                //该宏在片元着色器中调用，传入对应的v2f结构体对象
                //该宏会在内部利用v2f中的 阴影纹理坐标变量(ShadowCoord)对相关纹理进行采样
                //将采样得到的深度值进行比较，以计算出一个fixed3的阴影衰减值
                //我们只需要使用它返回的结果和 (漫反射+高光反射) 的结果相乘即可

                //fixed3 shadowAttenuation = SHADOW_ATTENUATION(i);

                //衰减值
                //fixed attenuation = 1;

                //利用灯光衰减和阴影衰减计算宏，统一进行衰减值的计算、
                UNITY_LIGHT_ATTENUATION(attenuation,i,i.wPOS);

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
            //#pragma multi_compile_fwdadd
            #pragma multi_compile_fwdadd_fullshadows

            #include "UnityCG.cginc"
            #include "Lighting.cginc"

            //该内置文件中，有用于计算阴影时需要使用的三剑客
            #include "AutoLight.cginc"

            fixed4 _MainColor;//材质漫反射颜色
            fixed4 _SpecularColor;
            float _SpecularNumber;

            struct v2f {
                float4 pos : SV_POSITION;
                fixed3 wNormal : NORMAL;
                //世界空间下的顶点坐标
                float3 wPOS : TEXCOORD0;

                //(阴影坐标宏)
                //该宏在v2f结构体（顶点着色器返回值）中使用
                //本质上就是声明了一个用于对阴影纹理进行采样的坐标
                //在内部实际上就是声明了一个名为_ShadowCoord的阴影纹理坐标变量
                //需要注意的是：
                //在使用时 SHADOW_COORDS(2) 传入参数2
                //表示需要时下一个可用的插值寄存器的索引值   
                SHADOW_COORDS(2)
            };


            v2f vert(appdata_base v) {
                v2f data;
                data.pos = UnityObjectToClipPos(v.vertex);
                data.wNormal = UnityObjectToWorldNormal(v.normal);
                data.wPOS = mul(unity_ObjectToWorld, v.vertex).xyz;

                //(转移阴影宏)
                //该宏会在内部自己判断应该使用哪种阴影映射技术（SM、SSSM）
                //最终的目的就是将顶点进行坐标转换并存储到_ShadowCoord阴影纹理坐标变量中
                //需要注意的是：
                //1.该宏会在内部使用顶点着色器中传入的结构体
                //该结构体中顶点的命名必须是vertex
                //2.该宏会在内部使用顶点着色器的返回结构体
                //其中的顶点位置命名必须是pos
                TRANSFER_SHADOW(data);
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
                //#if defined(_DIRECTIONAL_LIGHT)

                //    fixed attenuation = 1;

                //#elif defined(_POINT_LIGHT)

                //    //世家坐标系下的顶点转换到光源坐标系下
                //    float3 lightCoordinate  = mul(unity_WorldToLight,float4(i.wPOS,1)).xyz;

                //    float3 attenuation = tex2D(_LightTexture0,dot(lightCoordinate,lightCoordinate).xx).UNITY_ATTEN_CHANNEL;

                //#elif defined(_SPOT_LIGHT)

                //    float4 lightCoordinate  = mul(unity_WorldToLight,float4(i.wPOS,1));
                    
                //    fixed attenuation = (lightCoordinate.z > 0) * 
                //                        tex2D(_LightTexture0,lightCoordinate.xy / lightCoordinate.w + 0.5).w * 
                //                        tex2D(_LightTextureB0,dot(lightCoordinate,lightCoordinate).xx).UNITY_ATTEN_CHANNEL;
                //#else

                //    fixed attenuation = 1;

                //#endif

                //利用灯光衰减和阴影衰减计算宏，统一进行衰减值的计算、
                UNITY_LIGHT_ATTENUATION(attenuation,i,i.wPOS);

                //衰减值会和（漫反射颜色+高光反射颜色）后进行乘法运算
                //在附加渲染通道中，不需要再加上环境光颜色了，它只需要计算一次，在基础渲染通道中已经计算了
                fixed3 blinnPhongColorFragment = (diffuse + specular) * attenuation;

                return fixed4(blinnPhongColorFragment.rgb, 1);
            }
            ENDCG
        }
    }
    FallBack "Specular"
}
