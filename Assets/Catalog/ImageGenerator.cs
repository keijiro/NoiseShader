using UnityEngine;
using UnityEngine.Rendering;
using Unity.Mathematics;

public enum NoiseType { Classic2D, Classic3D, Simplex2D, Simplex3D }

public sealed class ImageGenerator : MonoBehaviour
{
    [field:SerializeField] public float Frequency { get; set; } = 5;
    [field:SerializeField] public int Octaves { get; set; } = 1;
    [field:SerializeField] public float Amplitude { get; set; } = 1;
    [field:SerializeField] public float3 Offset { get; set; }

    [SerializeField] NoiseType _noiseType = NoiseType.Classic2D;
    [SerializeField] int2 _dimensions = math.int2(1024, 1024);

    [SerializeField, HideInInspector] Shader _shader = null;

    Material _material;
    RenderTexture _rt;

    public RenderTexture Texture
      => _rt ?? (_rt = new RenderTexture(_dimensions.x, _dimensions.y, 0));

    void OnDestroy()
    {
        CoreUtils.Destroy(_material);
        CoreUtils.Destroy(_rt);
    }

    void Update()
    {
        if (_material == null)
            _material = CoreUtils.CreateEngineMaterial(_shader);

        _material.SetFloat("_Frequency", Frequency);
        _material.SetFloat("_Octaves", Octaves);
        _material.SetFloat("_Amplitude", Amplitude);
        _material.SetVector("_Offset", (Vector3)Offset);

        if (_noiseType == NoiseType.Classic2D ||
            _noiseType == NoiseType.Classic3D)
        {
            _material.EnableKeyword("_NOISEFUNC_CLASSIC");
            _material.DisableKeyword("_NOISEFUNC_SIMPLEX");
        }
        else
        {
            _material.DisableKeyword("_NOISEFUNC_CLASSIC");
            _material.EnableKeyword("_NOISEFUNC_SIMPLEX");
        }

        if (_noiseType == NoiseType.Classic2D ||
            _noiseType == NoiseType.Simplex2D)
        {
            _material.EnableKeyword("_COORDTYPE_TWO");
            _material.DisableKeyword("_COORDTYPE_THREE");
        }
        else
        {
            _material.DisableKeyword("_COORDTYPE_TWO");
            _material.EnableKeyword("_COORDTYPE_THREE");
        }

        Graphics.Blit(null, Texture, _material, 0);
    }
}
