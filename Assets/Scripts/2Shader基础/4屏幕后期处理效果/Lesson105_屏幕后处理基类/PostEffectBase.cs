using UnityEngine;

[ExecuteInEditMode]
[RequireComponent(typeof(Camera))]
public class PostEffectBase : MonoBehaviour
{
    public Shader shader;

    private Material _material;

    protected Material material
    {
        get
        {
            if(shader == null || !shader.isSupported)
            {
                return null;
            }
            else
            {
                if(_material != null && _material.shader == shader)
                {
                    return _material;
                }

                _material = new(shader)
                {
                    hideFlags = HideFlags.DontSave
                };

                return _material;
            }
        }
    }

    protected virtual void OnRenderImage(RenderTexture source,RenderTexture destination)
    {
        if(material != null)
        {
            Graphics.Blit(source,destination,material);
        }
        else
        {
            Graphics.Blit(source,destination);
        }
    }
}