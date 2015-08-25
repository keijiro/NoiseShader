using UnityEngine;

public class NoiseTest : MonoBehaviour
{
    public bool periodic;

    [Range(2, 3)]
    public int dimension = 2;

    public Shader shader;

    void Start()
    {
        GetComponent<Renderer>().material = new Material(shader);
    }

    void Update()
    {
        var r = GetComponent<Renderer>();

        if (periodic)
        {
            r.material.DisableKeyword("CNOISE");
            r.material.EnableKeyword("PNOISE");
        }
        else
        {
            r.material.EnableKeyword("CNOISE");
            r.material.DisableKeyword("PNOISE");
        }

        if (dimension == 2)
        {
            r.material.EnableKeyword("TWO_DEE");
            r.material.DisableKeyword("THREE_DEE");
        }
        else
        {
            r.material.DisableKeyword("TWO_DEE");
            r.material.EnableKeyword("THREE_DEE");
        }
    }
}
