using UnityEngine;

[ExecuteInEditMode]
public class NoiseTest : MonoBehaviour
{
    public enum NoiseType
        { ClassicPerlin, PeriodicPerlin, Simplex, FastSimplex, SuperSimplex }

    public enum GradientType { None, Numerical, Analytical }

    [SerializeField] NoiseType _noiseType = NoiseType.ClassicPerlin;
    [SerializeField] GradientType _gradientType = GradientType.None;
    [SerializeField] bool _is3D = false;
    [SerializeField] bool _isFractal = false;
    [SerializeField] Shader shader = null;

    Material _material;

    void Update()
    {
        if (_material == null)
        {
            _material = new Material(shader);
            _material.hideFlags = HideFlags.DontSave;
            GetComponent<Renderer>().material = _material;
        }

        _material.shaderKeywords = null;

        if (_noiseType == NoiseType.ClassicPerlin)
            _material.EnableKeyword("CNOISE");
        else if (_noiseType == NoiseType.PeriodicPerlin)
            _material.EnableKeyword("PNOISE");
        else if (_noiseType == NoiseType.Simplex)
            _material.EnableKeyword("SNOISE");
        else if (_noiseType == NoiseType.FastSimplex)
            _material.EnableKeyword("BCCNOISE4");
        else if (_noiseType == NoiseType.SuperSimplex)
            _material.EnableKeyword("BCCNOISE8");

        if (_gradientType == GradientType.Analytical)
            _material.EnableKeyword("GRAD_ANALYTICAL");
        else if (_gradientType == GradientType.Numerical)
            _material.EnableKeyword("GRAD_NUMERICAL");

        if (_is3D)
            _material.EnableKeyword("THREED");

        if (_isFractal)
            _material.EnableKeyword("FRACTAL");
    }
}
