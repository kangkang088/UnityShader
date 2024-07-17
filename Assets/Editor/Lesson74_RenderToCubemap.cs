using UnityEditor;
using UnityEngine;

public class Lesson74_RenderToCubemap : EditorWindow
{
    private GameObject obj;
    private Cubemap cubemap;

    [MenuItem("����������̬����/�����ɴ���")]
    private static void OpenWindow()
    {
        Lesson74_RenderToCubemap window = GetWindow<Lesson74_RenderToCubemap>("�������������ɴ���");
        window.Show();
    }

    private void OnGUI()
    {
        GUILayout.Label("������Ӧλ�ö���");
        obj = EditorGUILayout.ObjectField(obj,typeof(GameObject),true) as GameObject;
        GUILayout.Label("������Ӧ����������");
        cubemap = EditorGUILayout.ObjectField(cubemap,typeof(Cubemap),false) as Cubemap;

        if(GUILayout.Button("��������������"))
        {
            if(obj == null || cubemap == null)
            {
                EditorUtility.DisplayDialog("����","���ȹ�����Ӧ�����������������ͼ","ȷ��");
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