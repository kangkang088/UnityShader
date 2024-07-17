using UnityEngine;

public class Lesson92 : MonoBehaviour
{
    public int textureWidth = 256;
    public int textureHeight = 256;
    //国际象棋棋盘行列数
    public int tileCount = 8;
    public Color color1 = Color.white;
    public Color color2 = Color.black;
    // Start is called before the first frame update
    void Start()
    {
        UpdateTexture();
    }

    /// <summary>
    /// 更新纹理
    /// </summary>
    public void UpdateTexture()
    {
        //创建一个纹理对象，指定宽高，内存中。
        Texture2D texture2D = new Texture2D(textureWidth,textureHeight);
        for (int y = 0; y < textureHeight; y++)
        {
            for (int x = 0; x < textureWidth; x++)
            {
                //需要知道格子的宽高
                if(x / (textureWidth / tileCount) % 2 == y / (textureHeight / tileCount) % 2)
                {
                    texture2D.SetPixel(x,y,color1);
                }
                else
                {
                    texture2D.SetPixel(x,y,color2);
                }
            }
        }
        texture2D.Apply();

        Renderer renderer = GetComponent<Renderer>();
        if(renderer != null)
            renderer.sharedMaterial.mainTexture = texture2D;
    }
}
