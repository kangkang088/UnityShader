Shader "Unlit/Lesson99_Billboard"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        _Color("Color",Color) = (1,1,1,1)
        _VerticalBillboard("VerticalBillboard",Range(0,1)) = 1 //0-垂直广告牌 1-全向广告牌
    }
    SubShader
    {
        Tags
        {
            "RenderType"="Transparent"
            "Queue"="Transparent"
            "IgnoreProjector"="True"
            "DisableBatching"="True"
        }

        Pass
        {
            ZWrite Off
            Blend SrcAlpha OneMinusSrcAlpha
            Cull Off
            
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            
            #include "UnityCG.cginc"
            

            struct v2f
            {
                float uv : TEXCOORD0;
                float4 vertex : SV_POSITION;
            };

            sampler2D _MainTex;
            float4 _MainTex_ST;
            fixed4 _Color;
            float _VerticalBillboard;

            v2f vert(appdata_base v)
            {
                v2f o;

                //新坐标戏中心点（默认使用模型空间坐标系原点）
                float3 center = float3(0,0,0);
                
                //calculate z（normal）
                float3 cameraInObjectPos = mul(unity_WorldToObject,float4(_WorldSpaceCameraPos,1));
                //view dir(z)
                float3 normalDir = cameraInObjectPos - center;
                normalDir.y *= _VerticalBillboard;
                normalDir = normalize(normalDir);

                //z may be close close to y(0,1,0),will get 0 by zero Vector.
                //calculate x(right)
                float3 upDir = normalDir.y > 0.999 ? float3(0,0,1) : float3(0,1,0);//Y dir in objectSpace(old up)
                //use cross
                float3 rightDir = normalize(cross(upDir,normalDir));

                //calculate y(new up) by cross
                upDir = normalize(cross(rightDir,normalDir));

                //calculate vertex's offset face to new coordinate
                float3 centerOffset = v.vertex.xyz - center;

                //calculate new vertex(actually,is dot)
                float3 newVertex = center + rightDir * centerOffset.x + upDir * centerOffset.y + normalDir * centerOffset.z;

                o.vertex = UnityObjectToClipPos(float4(newVertex,1));
                o.uv = v.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                
                return o; 
            }

            fixed4 frag(v2f i) : SV_Target
            {
                fixed4 color = tex2D(_MainTex,i.uv);
                color.rgb *= _Color.rgb;
                return  color;
            }
            ENDCG
        }
    }
}