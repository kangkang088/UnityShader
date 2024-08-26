using UnityEngine;

public class Lesson104 : MonoBehaviour
{
    public Material material;

    private void Start()
    {
    }

    //[ImageEffectOpaque]
    private void OnRenderImage(RenderTexture source,RenderTexture destination)
    {
        //Graphics.Blit(source,destination);

        Graphics.Blit(source,destination,material);
    }
}