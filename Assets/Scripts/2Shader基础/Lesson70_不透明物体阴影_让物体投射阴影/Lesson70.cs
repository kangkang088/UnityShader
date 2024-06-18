using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Lesson70 : MonoBehaviour
{
    // Start is called before the first frame update
    void Start()
    {
        #region 知识点一 感受Fallback的作用
        //我们新建一个材质球
        //将其的Shader设置为我们之前编写的多种光源综合实现Shader
        //Lesson64_ForwardLighting

        //并将该材质球赋值给较大的立方体使用
        //我们会发现该立方体不再投射阴影也不再接受阴影
        //1.不投射阴影的原因
        //  该Shader中没有LightMode为ShaderCaster的Pass，无法参与光源的阴影映射纹理的计算
        //2.不接收阴影的原因
        //  该Shader并没有对阴影映射相关纹理进行采样，没有进行阴影相关颜色运算

        //我们之前学习理论知识时提到过
        //Unity会寻找LightMode为ShaderCaster的Pass来进行处理，如果该Shader没有该Pass
        //会在它FallBack指定的Shader中寻找，直到找到为止

        //我们现在在该Shader 最后加上FallBack "Specular"
        //便可以让该立方体投射阴影
        #endregion

        #region 知识点二 让物体投射阴影
        //物体向其它物体投射阴影的关键点是：
        //1. 需要实现 LightMode(灯光模式) 为 ShadowCaster(阴影投射) 的 Pass(渲染通道)
        //   这样该物体才能参与到光源的阴影映射纹理计算中

        //2. 一个编译指令，一个内置文件，三个关键宏
        //  编译指令：
        //  #pragma multi_compile_shadowcaster
        //  该编译指令时告诉Unity编译器生成多个着色器变体
        //  用于支持不同类型的阴影（SM，SSSM等等）
        //  可以确保着色器能够在所有可能的阴影投射模式下正确渲染

        //  内置文件：
        //  #include "UnityCG.cginc"
        //  其中包含了关键的阴影计算相关的宏

        //  三个关键宏:
        //  2-1.V2F_SHADOW_CASTER
        //    顶点到片元着色器阴影投射结构体数据宏
        //    这个宏定义了一些标准的成员变量
        //    这些变量用于在阴影投射路径中传递顶点数据到片元着色器
        //    我们主要在结构体中使用
        //  2-2.TRANSFER_SHADOW_CASTER_NORMALOFFSET
        //    转移阴影投射器法线偏移宏
        //    用于在顶点着色器中计算和传递阴影投射所需的变量
        //    主要做了
        //    2-2-1.将对象空间的顶点位置转换为裁剪空间的位置
        //    2-2-2.考虑法线偏移，以减轻阴影失真问题，尤其是在处理自阴影时
        //    2-2-3.传递顶点的投影空间位置，用于后续的阴影计算
        //    我们主要在顶点着色器中使用
        //  2-3.SHADOW_CASTER_FRAGMENT
        //    阴影投射片元宏
        //    将深度值写入到阴影映射纹理中
        //    我们主要在片元着色器中使用

        //3.利用这些内容在Shader中实现代码
        #endregion

        #region 知识点三 建议
        //由于投射阴影相关的代码较为通用
        //因此建议大家不用自己去实现相关Shader代码
        //直接通过FallBack调用Unity中默认Shader中的相关代码即可
        #endregion
    }

    // Update is called once per frame
    void Update()
    {

    }
}
