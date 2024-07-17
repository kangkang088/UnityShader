using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Lesson69 : MonoBehaviour
{
    // Start is called before the first frame update
    void Start()
    {
        #region 知识点一 搭建测试场景
        //我们新建一个场景
        //专门来测试阴影效果
        //并且在该场景中搭建测试场景
        #endregion

        #region 知识点二 设置光源和物体的参数
        //1.设置平行光参数，让其开启阴影
        //2.设置物体的投射阴影和接收阴影选项
        //注意：对于一些单面对象，我们可以将Cast Shadows（投射阴影）设置为Two Sided（双面）
        //     设置为投射双面阴影。这意味着，即使光源在网格后面，平面或四边形等单面对象也可以投射阴影。
        #endregion
    }

    // Update is called once per frame
    void Update()
    {

    }
}
