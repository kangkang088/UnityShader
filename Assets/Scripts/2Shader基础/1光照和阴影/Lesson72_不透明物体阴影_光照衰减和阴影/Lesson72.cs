using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Lesson72 : MonoBehaviour
{
    // Start is called before the first frame update
    void Start()
    {
        #region 知识回顾
        //1.多种光源的效果实现
        //  在Additional Pass（附加渲染通道）中根据光源类型
        //  计算出不同的光源衰减值，参与到最终的颜色计算中

        //2.计算阴影时需要使用的三剑客
        //  2-1.SHADOW_COORDS      (阴影坐标宏)
        //      在v2f结构体中声明，本质是声明了一个表示阴影映射纹理坐标的变量

        //  2-2.TRANSFER_SHADOW    (转移阴影宏)
        //      在顶点着色器中调用，本质是将顶点进行坐标转换并存储到_ShadowCoord阴影纹理坐标变量中

        //  2-3.SHADOW_ATTENUATION (阴影衰减宏)
        //      本质是利用_ShadowCoord对阴影映射纹理进行采用
        //      将采样得到的深度值进行比较，以计算出一个fixed3的阴影衰减值

        //  最终之所以能够接受阴影
        //  主要就是因为利用了最终得到的阴影衰减值参与到了最终的颜色计算中
        #endregion

        #region 知识点一 光照衰减和阴影
        //通过之前的学习
        //我们发现光照衰减和接受阴影相关的计算是类似的
        //关键点都是通过计算出一个衰减值，参与到颜色计算中
        //都是用 (漫反射+高光反射) 的结果乘以对应的衰减值

        //由于它们对最终颜色影响的计算非常类似，都是通过乘法进行运算
        //因此Unity中专门提供了对应的宏
        //来综合处理光照衰减和阴影衰减的计算

        //AutoLight.cginc 内置文件中的
        //UNITY_LIGHT_ATTENUATION（Unity光照衰减宏）
        //该宏中会统一的对 光照衰减进行计算 并且也会计算出 阴影衰减值
        //最后将两者相乘得到综合衰减值

        //我们只需要利用该宏来处理 光照和阴影的衰减即可

        //我们可以在 Unity安装目录的Editor->Data->CGIncludes中找到该内置文件
        //查看该宏的逻辑
        #endregion

        #region 知识点二 光照衰减和阴影的综合实现
        //我们将利用
        //AutoLight.cginc 内置文件中的
        //UNITY_LIGHT_ATTENUATION（Unity光照衰减宏）
        //来综合处理光照衰减和阴影相关的逻辑

        //1.创建一个新的Shader 并将Lesson67_Shadow中的代码赋值过来

        //2.将三剑客中的前两剑客，在Additional Pass 附加渲染通道中也添加上
        //  注意：需要在附加渲染通道中包含内置文件 AutoLight.cginc
        //      （因为不仅三剑客来自于它，UNITY_LIGHT_ATTENUATION-Unity光照衰减宏也来自于它）

        //3.修改两个Pass的片元着色器中衰减计算相关的代码
        //  使用 UNITY_LIGHT_ATTENUATION 宏替代原有逻辑
        //  该宏需要传入3个参数
        //  第一个参数是用来存储最终衰减值的变量名（不用声明，内部会声明）
        //  第二个参数是片元着色器中传入的v2f结构体对象
        //  第三个参数是顶点相对于世界坐标系的位置
        //  最终将得到的衰减结果和  (漫反射+高光反射) 的结果相乘即可

        //4.为了让Additional Pass 附加渲染通道能够添加阴影效果
        //需要将编译指令进行修改
        //将原本的 #pragma multi_compile_fwdadd
        //修改为 #pragma multi_compile_fwdadd_fullshadows
        //这样Unity会生成多个包括支持和不支持阴影的Shader变体
        //从而为额外的逐像素光源计算阴影，并传递给Shader了
        #endregion
    }

    // Update is called once per frame
    void Update()
    {

    }
}
