using UnityEngine;

[ExecuteInEditMode]
public class NoiseTest : MonoBehaviour
{
    public enum NoiseType { ClassicPerlin, PeriodicPerlin, Simplex }

    [SerializeField]
    NoiseType _noiseType;

    [SerializeField, Range(2, 3)]
    int dimension = 2;

    [SerializeField]
    Shader shader;

    Material _material;

    void Update()
    {
        if (_material == null)
        {
            _material = new Material(shader);
            _material.hideFlags = HideFlags.DontSave;
            GetComponent<Renderer>().material = _material;
        }

        if (_noiseType == NoiseType.ClassicPerlin)
        {
            _material.EnableKeyword("CNOISE");
            _material.DisableKeyword("PNOISE");
            _material.DisableKeyword("SNOISE");
        }
        else if (_noiseType == NoiseType.PeriodicPerlin)
        {
            _material.DisableKeyword("CNOISE");
            _material.EnableKeyword("PNOISE");
            _material.DisableKeyword("SNOISE");
        }
        else
        {
            _material.DisableKeyword("CNOISE");
            _material.DisableKeyword("PNOISE");
            _material.EnableKeyword("SNOISE");
        }

        if (dimension == 2)
        {
            _material.EnableKeyword("TWO_DEE");
            _material.DisableKeyword("THREE_DEE");
        }
        else
        {
            _material.DisableKeyword("TWO_DEE");
            _material.EnableKeyword("THREE_DEE");
        }
    }
}
