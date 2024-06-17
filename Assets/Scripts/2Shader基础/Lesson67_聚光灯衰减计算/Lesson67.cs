using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Lesson67 : MonoBehaviour
{
    // Start is called before the first frame update
    void Start()
    {
        #region 知识点一 聚光灯默认Cookie
        //我们知道灯光组件中有一个Cookie参数，是用来关联光照遮罩图片的
        //对于平行光和点光源，默认是不会提供任何光照遮罩信息的
        //但是对于聚光灯来说
        //Unity会默认为它提供一个Cookie光照遮罩
        //主要是用于模拟聚光灯的区域性
        //而此时 光照纹理中
        //_LightTexture0 存储的是Cookie纹理信息
        //_LightTextureB0 存储的是光照纹理信息，里面包含衰减值

        //因此
        //1.获取聚光灯衰减值时
        //  需要从_LightTextureB0中进行采样
        //2.获取遮罩范围相关数据时
        //  需要从_LightTexture0中进行采样
        #endregion

        #region 知识点二 聚光灯衰减计算
        //1.将顶点从世界空间转换到光源空间
        // float4 lightCoord = mul(unity_WorldToLight, float4(i.worldPos, 1));
        // 注意：
        // 这里我们转换后和点光源不同的是
        // 点光源只会获取其中的xyz
        // 而聚光灯会获取其中的xyzw
        // 这是因为在聚光灯光源空间下的w值有特殊含义
        // 会参与后续的计算

        //2.利用光源空间下的坐标信息
        //  我们会通过3个步骤去获取聚光灯的衰减信息
        //  fixed atten = (lightCoord.z > 0) * //第一步
        //  tex2D(_LightTexture0, lightCoord.xy / lightCoord.w + 0.5).w * //第二步
        //  tex2D(_LightTextureB0, dot(lightCoord, lightCoord).rr).UNITY_ATTEN_CHANNEL; //第三步

        //  我们首先分析和点光源相同的部分——第三步
        //  tex2D(_LightTextureB0, dot(lightCoord, lightCoord).rr).UNITY_ATTEN_CHANNEL; 
        //  这一步的规则和点光源规则一致，直接根据距离光源原点距离的平方从光照纹理中获取衰减值
        //  需要注意的是
        //  1.聚光灯的光照衰减纹理为_LightTextureB0
        //  2.dot函数只会计算xyz，w不会计算

        //  接着我们来分析用于进行范围判断的部分——第一、二步
        //  第一步：(lightCoord.z > 0) 
        //      CG语法中没有显示的bool类型，一般情况下 0 表示false，1表示true
        //      也就是说lightCoord.z > 0的返回值，条件满足时为1，条件不满足为0
        //      这里的z代表的其实是 目标点 相对于 聚光灯照射面 距离
        //      如果 lightCoord.z <= 0 证明在聚光灯照射方向的背面，就不应该受到聚光灯的影响
        //      也就是说这一步的主要作用，是用来决定顶点是否受到聚光灯光照的影响

        //  第二步：tex2D(_LightTexture0, lightCoord.xy / lightCoord.w + 0.5).w
        //      我们以前在进行纹理采样时都会进行一个 先缩放 后 平移 的操作
        //      比如：uv = v.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
        //      而第二步中的 lightCoord.xy / lightCoord.w + 0.5 其实也是在做这样的一个操作
        //      这样做的主要目的是因为：
        //      我们需要把uv坐标映射到0~1的范围内再从纹理中采样
        //      lightCoord.xy / lightCoord.w 进行缩放后 x,y的取值范围是-0.5~0.5之间
        //      再加上0.5后，x,y的取值范围就是0~1之间，便可以进行正确的纹理采样了
        //      而lightCoord.xy / lightCoord.w 是因为聚光灯有很多横截面
        //      我们需要把各横截面映射到最大的面上进行采样

        //  因此我们总结一下
        //  看似复杂的聚光灯光照衰减计算方式
        //  其实就是由 “遮罩衰减” 和 距离衰减 共同决定的
        //  第一步：判断是否能有机会照到光 看得到为1，看不到为0 
        //  fixed atten = (lightCoord.z > 0) * 
        //  第二步：缩放平移，映射到遮罩纹理采样 根据遮罩纹理的信息决定衰减叠加
        //  tex2D(_LightTexture0, lightCoord.xy / lightCoord.w + 0.5).w * 
        //  第三步：从光照衰减纹理中取出按距离得到的衰减值
        //  tex2D(_LightTextureB0, dot(lightCoord, lightCoord).rr).UNITY_ATTEN_CHANNEL; 
        #endregion
    }

    // Update is called once per frame
    void Update()
    {

    }
}
