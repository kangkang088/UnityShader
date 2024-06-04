// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "Unlit/Lesson20"
{
    Properties
    {
        
    }
    SubShader
    {
        
        Pass
        {
              CGPROGRAM
              #pragma vertex myVert
              #pragma fragment myFrag

              float4 myVert(float4 vertex:POSITION):SV_POSITION
              {
                return UnityObjectToClipPos(vertex);
              }

              fixed4 myFrag():SV_TARGET
              {
                return fixed4(0,1,0,1);
              }
              ENDCG
        }
    }
}
