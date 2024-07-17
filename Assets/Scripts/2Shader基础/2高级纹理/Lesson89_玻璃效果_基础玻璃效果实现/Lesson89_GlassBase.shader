Shader "Unlit/Lesson89_GlassBase" {
    Properties {
        //主纹理
        _MainTex ("MainTex", 2D) = "" { }
        //立方体纹理
        _Cube ("Cubemap", Cube) = "" { }
        //折射程度 0：完全反射（不折射） 1：完全折射（透明，相当于光全部进入内部）
        _RefractAmount ("RefractAmount", Range(0, 1)) = 1
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
            samplerCUBE _Cube;
            float _RefractAmount;
            //GrabPass默认的存储纹理变量
            sampler2D _GrabTexture;

            struct v2f {
                float4 pos : SV_POSITION;//裁剪空间下顶点坐标
                //用于存储从屏幕图像中采样的坐标
                float4 grabPos : TEXCOORD0;
                //颜色纹理采样的uv坐标
                float2 uv : TEXCOORD1;
                float3 worldReflect : TEXCOORD2;//世界空间下反射向量

            };

            v2f vert(appdata_base v) {
                v2f o;
                o.pos = UnityObjectToClipPos(v.vertex);

                //屏幕坐标转换
                o.grabPos = ComputeGrabScreenPos(o.pos);

                //uv坐标计算
                o.uv.xy = v.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;

                float3 worldNormal = UnityObjectToWorldNormal(v.normal);
                fixed3 worldPos = mul(unity_ObjectToWorld, v.vertex).xyz;
                //视角方向，内部是摄像机位置-顶点位置。
                fixed3 worldViewDir = UnityWorldSpaceViewDir(worldPos);
                o.worldReflect = reflect(-worldViewDir, worldNormal);

                return o;
            }

            fixed4 frag(v2f i) : SV_TARGET {
                //主纹理颜色采样
                fixed4 mainTex = tex2D(_MainTex,i.uv);

                //反射颜色和主纹理颜色叠加
                fixed4 reflectColor = texCUBE(_Cube, i.worldReflect) * mainTex;

                //想要折射效果，可以在采样之前，进行xy屏幕坐标的偏移
                float2 offset = 1 - _RefractAmount;
                i.grabPos.xy = i.grabPos.xy - offset * 0.1;

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