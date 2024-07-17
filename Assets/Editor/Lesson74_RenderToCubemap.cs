using UnityEditor;
using UnityEngine;

public class Lesson74_RenderToCubemap : EditorWindow
{
    private GameObject obj;
    private Cubemap cubemap;

    [MenuItem("立方体纹理动态生成/打开生成窗口")]
    private static void OpenWindow()
    {
        Lesson74_RenderToCubemap window = GetWindow<Lesson74_RenderToCubemap>("立方体纹理生成窗口");
        window.Show();
    }

    private void OnGUI()
    {
        GUILayout.Label("关联对应位置对象");
        obj = EditorGUILayout.ObjectField(obj,typeof(GameObject),true) as GameObject;
        GUILayout.Label("关联对应立方体纹理");
        cubemap = EditorGUILayout.ObjectField(cubemap,typeof(Cubemap),false) as Cubemap;

        if(GUILayout.Button("生成立方体纹理"))
        {
            if(obj == null || cubemap == null)
            {
                EditorUtility.DisplayDialog("提醒","请先关联对应对象或立方体纹理贴图","确认");
                return;
            }

            GameObject tempObj = new GameObject("Temp Obj");
            tempObj.transform.position = obj.transform.position;
            Camera camera = tempObj.AddComponent<Camera>();
            camera.RenderToCubemap(cubemap);
            DestroyImmediate(tempObj);
        }
    }
}