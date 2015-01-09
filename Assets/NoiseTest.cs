using UnityEngine;
using System.Collections;

public class NoiseTest : MonoBehaviour
{
    public bool periodic;

    [Range(2, 3)]
    public int dimension = 2;

    public Shader shader;

    void Start()
    {
        renderer.material = new Material(shader);
    }

    void Update()
    {
        if (periodic)
        {
            renderer.material.DisableKeyword("CNOISE");
            renderer.material.EnableKeyword("PNOISE");
        }
        else
        {
            renderer.material.EnableKeyword("CNOISE");
            renderer.material.DisableKeyword("PNOISE");
        }

        if (dimension == 2)
        {
            renderer.material.EnableKeyword("TWO_DEE");
            renderer.material.DisableKeyword("THREE_DEE");
        }
        else
        {
            renderer.material.DisableKeyword("TWO_DEE");
            renderer.material.EnableKeyword("THREE_DEE");
        }
    }
}
