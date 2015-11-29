using UnityEngine;

[ExecuteInEditMode]
public class NoiseTest : MonoBehaviour
{
    public enum NoiseType { ClassicPerlin, PeriodicPerlin, Simplex }

    [SerializeField]
    NoiseType _noiseType;

    [SerializeField]
    bool _is3D;

    [SerializeField]
    bool _isFractal;

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

        if (_is3D)
            _material.EnableKeyword("THREED");
        else
            _material.DisableKeyword("THREED");

        if (_isFractal)
            _material.EnableKeyword("FRACTAL");
        else
            _material.DisableKeyword("FRACTAL");
    }
}
