using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Lesson64 : MonoBehaviour
{
    // Start is called before the first frame update
    private void Start()
    {
        #region 重要知识回顾

        //1.预处理指令
        //  Shader中也存在预处理指令
        //  可以通过选修课回顾下C#中的预处理指令
        //  它的使用和Shader当中类似

        //2.前向渲染路径在哪里进行光照计算
        //  Base Pass（基础渲染通道）：
        //  主要用于处理影响该物体的一个高质量光源（平行光）、所有中（逐顶点处理）低质量（SH处理）光源 等
        //  Additional Pass（附加渲染通道）：
        //  主要用于处理影响该物体的除平行光以外的其它高质量光源（每个高质量光源都会调用）

        #endregion 重要知识回顾

        #region 知识点一 前向渲染路径中我们主要关注处理什么内容？

        //两个Pass
        //1.Base Pass（基础渲染通道，每个片元只会计算一次）：
        //  只需要处理一个逐像素平行光源（一般场景中最亮会自动赋值对应变量）
        //  其他的中（逐顶点）、低质量（SH）光源Unity会帮助我们处理
        //2.Additional Pass（附加渲染通道）:
        //  除了最亮的平行光、其他高质量的光源(可能是平行光、点光源、聚光灯)都会调用一次该Pass进行计算

        //因此我们一般需要在Additional Pass中判断光源类型来分别处理部分逻辑

        #endregion 知识点一 前向渲染路径中我们主要关注处理什么内容？

        #region 知识点二 如何在Shader中判断光源类型

        //Unity中提供了三个重要的宏
        //分别是：
        //_DIRECTIONAL_LIGHT:平行光
        //_POINT_LIGHT:点光源
        //_SPOT_LIGHT:聚光灯

        //宏在这里的作用：
        //可以用于在编译时根据条件判断来包含或排除不同的代码块，实现条件编译

        //我们可以使用这些宏配合Unity Shader中的条件编译预处理指令
        //用于在编译时根据一定的条件选择性地包含或排除代码块
        //#if defined(_DIRECTIONAL_LIGHT)
        //  平行光逻辑
        //#elif defined (_POINT_LIGHT)
        //  点光源逻辑
        //#elif defined (_SPOT_LIGHT)
        //  聚光灯逻辑
        //#else
        //  其他逻辑
        //#endif

        //Unity底层会根据该条件编译指令
        //生成成多个 Shader Variants（着色器变体）
        //这些 Variants 变体共享相同的核心代码
        //但根据条件编译的选择会包含不同的代码块

        //Shader variants 的基本概念是在编写 shader 时，
        //通过条件编译指令（#if, #elif, #else, #endif）
        //根据不同的配置选项生成多个版本的 shader。
        //这些不同版本的 shader 称为 shader variants。

        #endregion 知识点二 如何在Shader中判断光源类型
    }

    // Update is called once per frame
    private void Update()
    {
    }
}