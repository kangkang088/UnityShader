using UnityEngine;

public class Lesson103 : MonoBehaviour
{
    public Color color;

    [Range(0f,1f)]
    public float fresnelScale;

    private void Start()
    {
        Renderer renderer = GetComponent<Renderer>();

        if(renderer != null)
        {
            Material material = renderer.material;
            //Material[] materials = renderer.sharedMaterials;

            //material.color = color;
            //material.mainTexture = Resources.Load<Texture2D>("path");

            if(material.HasColor("_Color"))
                material.SetColor("_Color",color);

            if(material.HasColor("_FresnelScale"))
                material.SetFloat("_FresnelScale",fresnelScale);

            material.shader = Shader.Find("Unlit/Lesson84_Fresnel");

            material.SetTextureOffset("_MainTex",new Vector2(0.5f,0.5f));
            material.SetTextureScale("_MainTex",new Vector2(0.5f,0.5f));
        }
    }
}