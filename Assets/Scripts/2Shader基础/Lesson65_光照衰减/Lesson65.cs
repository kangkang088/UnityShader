using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Lesson65 : MonoBehaviour
{
    // Start is called before the first frame update
    void Start()
    {
        #region 知识点一 光照衰减的基本概念
        //光照衰减通常指的是在渲染过程中考虑光线在空间中传播时的减弱效应
        //比如：
        //任何光源的光照亮度会随着物体离光源的距离增加而迅速衰减

        //一般常见的光照衰减计算方式有
        //1.线性衰减
        //  光强度与距离成线性关系。即光照衰减与光源到被照射表面的距离成正比。
        //2.平方衰减
        //  光强度与距离的平方成反比。这种模型更符合现实世界中光照的特性，因为光在空间中的传播过程中通常会遵循平方衰减规律。
        #endregion

        #region 知识点二 Unity中的光照衰减
        //Unity中为了提升性能，我们一般不会直接通过数学公式计算光照衰减
        //而是使用一张纹理作为查找表（LUT, lookup table） 在片元着色器中计算逐像素光照的 衰减

        //Unity Shader中有一个内置的纹理类型的变量 _LightTexture0
        //该纹理中存储了衰减值相关的数据
        //Unity 内部预先就计算好了相关数据 并存入到该纹理中，避免重复计算，提升性能表现
        //其中
        //它的对角线上的纹理颜色值，表明了光源空间中不同位置的点对应的衰减值
        //纹理中的对角线
        //起点 (0,0) 位置，表示和光源重合的点的衰减值
        //终点（1,1) 位置，表示在光源空间中离光源距离最远的点的衰减值

        //一般我们直接从_LightTexture0中进行纹理采样后，利用其中的UNITY_ATTEN_CHANNEL宏来得到衰减值所在的分量
        //tex2D(_LightTexture0, 对应纹理uv坐标).UNITY_ATTEN_CHANNEL

        //注意:
        //如果光源存在cookie，也就是灯光遮罩
        //那么衰减查找纹理便是 _LightTextureB0
        #endregion

        #region 知识点三 光源空间变换矩阵
        //Unity Shader中 内置的 光源空间变换矩阵
        //是用于将世界空间下的位置转换到光源空间下（光源位置为原点）的
        //老版本：_LightMatrix0
        //新版本：unity_WorldToLight

        //由于我们需要从 _LightTexture0 光照纹理中取出对应的衰减数据
        //因此我们需要将顶点位置从世界空间中转换到光源空间中
        //然后再来从其中取得衰减数据

        //我们可以通过矩阵运算将世界空间下的点转换到光源空间下
        //mul(unity_WorldToLight, float4(worldPos, 1));
        #endregion

        #region 总结
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
    }

    // Update is called once per frame
    void Update()
    {

    }
}
