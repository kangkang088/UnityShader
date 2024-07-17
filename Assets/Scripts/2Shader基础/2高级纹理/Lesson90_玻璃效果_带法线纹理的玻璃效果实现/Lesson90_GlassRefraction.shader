Shader "Unlit/Lesson90_GlassRefraction"
{
    Properties {
        //主纹理
        _MainTex ("MainTex", 2D) = "" { }
        //法线纹理
        _BumpMap ("BumpMap", 2D) = "" { }
        //立方体纹理
        _Cube ("Cubemap", Cube) = "" { }
        //折射程度 0：完全反射（不折射） 1：完全折射（透明，相当于光全部进入内部）
        _RefractAmount ("RefractAmount", Range(0, 1)) = 1
        //折射扭曲程度
        _Distortion ("Distortion", Range(0,10)) = 0
    }
    SubShader {
        Tags { "RenderType" = "Opaque" "Queue" = "Transparent" }
        //捕获当前屏幕内容，并存储到默认渲染纹理变量中
        GrabPass { }
        Pass {
            Tags { "LightMode" = "ForwardBase" }

            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #include "UnityCG.cginc"
            #include "Lighting.cginc"

            sampler2D _MainTex;
            float4 _MainTex_ST;
            sampler2D _BumpMap;
            float4 _BumpMap_ST;
            samplerCUBE _Cube;
            float _RefractAmount;
            //GrabPass默认的存储纹理变量
            sampler2D _GrabTexture;
            float _Distortion;

            struct v2f {
                float4 pos : SV_POSITION;//裁剪空间下顶点坐标
                //用于存储从屏幕图像中采样的坐标
                float4 grabPos : TEXCOORD0;
                //颜色纹理采样的uv坐标
                float4 uv : TEXCOORD1;
                //float3 worldReflect : TEXCOORD2;//世界空间下反射向量
                
                float4 T2W0 : TEXCOORD3;//rotation第一行 + worldPos.x
                float4 T2W1 : TEXCOORD4;//rotation第二行 + worldPos.y
                float4 T2W2 : TEXCOORD5;//rotation第三行 + worldPos.z
            };

            v2f vert(appdata_full v) {
                v2f o;
                o.pos = UnityObjectToClipPos(v.vertex);

                //屏幕坐标转换
                o.grabPos = ComputeGrabScreenPos(o.pos);

                //uv坐标计算
                o.uv.xy = v.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                //法线纹理的uv坐标计算
                o.uv.zw = v.texcoord.xy * _BumpMap_ST.xy + _BumpMap_ST.zw;

                float3 worldNormal = UnityObjectToWorldNormal(v.normal);
                fixed3 worldPos = mul(unity_ObjectToWorld, v.vertex).xyz;
                //视角方向，内部是摄像机位置-顶点位置。
                //fixed3 worldViewDir = UnityWorldSpaceViewDir(worldPos);
                //o.worldReflect = reflect(-worldViewDir, worldNormal);

                float3 worldTangent = UnityObjectToWorldDir(v.tangent);
                float3 worldBinormal = cross(normalize(worldNormal), normalize(worldTangent)) * v.tangent.w;

                o.T2W0 = float4(worldTangent.x, worldBinormal.x, worldNormal.x, worldPos.x);
                o.T2W1 = float4(worldTangent.y, worldBinormal.y, worldNormal.y, worldPos.y);
                o.T2W2 = float4(worldTangent.z, worldBinormal.z, worldNormal.z, worldPos.z);

                return o;
            }

            fixed4 frag(v2f i) : SV_TARGET {
                float3 worldPos = float3(i.T2W0.w, i.T2W1.w, i.T2W2.w);
                fixed3 viewDir = normalize(UnityWorldSpaceViewDir(worldPos));

                float4 packedNormal = tex2D(_BumpMap, i.uv.zw);
                float3 tangentNormal = UnpackNormal(packedNormal);

                float3 worldNormal = float3(dot(i.T2W0.xyz, tangentNormal), dot(i.T2W1.xyz, tangentNormal), dot(i.T2W2.xyz, tangentNormal));

                //主纹理颜色采样
                fixed4 mainTex = tex2D(_MainTex,i.uv);

                //反射向量计算
                float3 reflectDir = reflect(-viewDir,worldNormal);

                //反射颜色和主纹理颜色叠加
                fixed4 reflectColor = texCUBE(_Cube, reflectDir) * mainTex;

                //想要折射效果，可以在采样之前，进行xy屏幕坐标的偏移
                //光线经过法线扰动后的偏移程度
                float2 offset = tangentNormal.xy * _Distortion;
                i.grabPos.xy = offset * i.grabPos.z + i.grabPos.xy;

                //折射相关的颜色：从抓取的屏幕渲染纹理中进行采样计算
                //透视除法，将屏幕坐标转换到0~1
                fixed2 screenUV = i.grabPos.xy / i.grabPos.w;

                fixed4 grabColor = tex2D(_GrabTexture,screenUV);

                float4 color = reflectColor * (1 - _RefractAmount) + grabColor * _RefractAmount;

                return color;
            }

            ENDCG
        }
    }
}
