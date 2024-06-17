using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Lesson68 : MonoBehaviour
{
    // Start is called before the first frame update
    void Start()
    {
        #region 重要知识回顾

        #region 1.前向渲染路径中如何处理光源
        //两个Pass
        //Base Pass（基础渲染通道）
        //Additional Pass（附加渲染通道）
        #endregion

        #region 2.在Shader当中如何判断多种光源
        //#if defined(_DIRECTIONAL_LIGHT)
        //  平行光逻辑
        //#elif defined (_POINT_LIGHT)
        //  点光源逻辑
        //#elif defined (_SPOT_LIGHT)
        //  聚光灯逻辑
        //#else
        //  其他逻辑
        //#endif
        #endregion

        #region 3.点光源衰减值计算
        // float3 lightCoord = mul(unity_WorldToLight, float4(worldPos, 1)).xyz;
        // fixed atten = tex2D(_LightTexture0, dot(lightCoord, lightCoord).xx).UNITY_ATTEN_CHANNEL;
        #endregion

        #region 4.聚光灯衰减值计算
        // float4 lightCoord = mul(unity_WorldToLight, float4(i.worldPos, 1));
        // fixed atten = (lightCoord.z > 0) * //第一步
        // tex2D(_LightTexture0, lightCoord.xy / lightCoord.w + 0.5).w * //第二步
        // tex2D(_LightTextureB0, dot(lightCoord, lightCoord).rr).UNITY_ATTEN_CHANNEL; //第三步
        #endregion

        #endregion

        #region 知识点 前向渲染路径中处理多种光源的综合实现
        //主要步骤：
        //1.新建一个Shader文件，删除其中无用代码

        //2.复制Lesson45中的Blinn-Phong光照模型的逐片元光照

        //3.其中已存在的Pass，就是我们的BasePass（基础渲染通道）
        //  我们需要为它加上一个编译指令#pragma multi_compile_fwdbase	
        //  该指令可以保证我们在Shader中使用光照衰减等光照等变量可以被正确赋值
        //  并且会帮助我们编译 BasePass 中所有变体

        //4.复制BasePass，基于它来修改我们的Additional Pass（附加渲染通道）

        //5.LightMode 改为 ForwardAdd

        //6.加入混合命令Blend One One 表示开启混合 线性减淡效果

        //7.加入编译指令#pragma multi_compile_fwdadd
        //  该指令保证我们在附加渲染通道中能访问到正确的光照变量
        //  并且会帮助我们编译Additional Pass中所有变体

        //8.修改相关代码，基于不同的光照类型来计算衰减值
        //  8-1:光的方向计算方向修改
        //  8-2:基于不同光照类型计算衰减值
        #endregion
    }

    // Update is called once per frame
    void Update()
    {

    }
}
