using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Lesson62 : MonoBehaviour
{
    // Start is called before the first frame update
    void Start()
    {
        #region 重要知识回顾
        //在Shader中进行光照衰减处理时
        //我们是通过从纹理中取出衰减数据
        //不使用灯光遮罩时，从 _LightTexture0 纹理中获取
        //使用时，从 _LightTextureB0 纹理中获取
        //在纹理采样之前
        //我们需要将顶点坐标从世界空间中转换到光源空间中
        //变换矩阵为：
        //老版本：_LightMatrix0
        //新版本：unity_WorldToLight
        #endregion

        #region 知识点 点光源衰减计算
        //注意：一般点光源我们不会为其添加cookie光照遮罩
        //      一般想要使用光照遮罩都会在聚光灯中使用
        //      因此我们不用考虑cookie纹理的问题

        //1.将顶点从世界空间转换到光源空间
        // float3 lightCoord = mul(unity_WorldToLight, float4(worldPos, 1)).xyz;
        // lightCoord 是光源坐标系下顶点根据光源的范围range规范化后的坐标
        // 相当于是一个模长为0~1之间的向量

        //2.利用该光源空间下的坐标来计算离光源的距离
        //  并利用距离参数，从光源纹理中采样
        //  fixed atten = tex2D(_LightTexture0, dot(lightCoord, lightCoord).xx).UNITY_ATTEN_CHANNEL;

        //  dot(LightCoord, LightCoord).xx 中
        //  dot(LightCoord, LightCoord) 是为了通过点乘得到 结果 x² + y² + z² = 离光源距离 distance²
        //  xx是一种特殊写法，目的是构建一个 float2 代表uv坐标
        //  这里的 uv坐标 相当于是 (distance², distance²)
        //  用distance²做uv坐标，而不是distance
        //  1.为了避免开平方带来性能消耗
        //  2.采用这种平方衰减更符合现实世界中光照的特性
        //      因为人眼对亮部不敏感，而对暗部敏感，这样我们就可以将 衰减值的精度 集中在比较远的地方
        //      distance是0.5时，distance2是0.25，这样LUT查找表中大部分值都会留给比较远的部分
        #endregion
    }

    // Update is called once per frame
    void Update()
    {

    }
}
