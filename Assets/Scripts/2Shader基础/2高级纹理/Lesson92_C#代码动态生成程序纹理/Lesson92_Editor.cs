using UnityEditor;
using UnityEngine;

[CustomEditor(typeof(Lesson92))]
public class Lesson92_Editor : Editor
{
    public override void OnInspectorGUI()
    {
        //绘制默认参数相关的内容
        DrawDefaultInspector();

        //获取目标脚本
        Lesson92 scriptObj = (Lesson92)target;
        if(GUILayout.Button("更新程序纹理"))
        {
            scriptObj.UpdateTexture();
        }
    }
}
