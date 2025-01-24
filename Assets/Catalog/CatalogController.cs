using Unity.Properties;
using UnityEngine;
using UnityEngine.UIElements;
using Unity.Mathematics;

[System.Serializable]
public struct ImageGeneratorUIPair
{
    public ImageGenerator generator;
    public string uiName;
}

public sealed class CatalogController : MonoBehaviour
{
    [field:SerializeField, CreateProperty]
    public float Frequency { get; set; } = 5;

    [field:SerializeField, CreateProperty]
    public bool Animation { get; set; }

    [SerializeField]
    ImageGeneratorUIPair[] _generators = null;

    float3 _offset;

    void Start()
    {
        var root = GetComponent<UIDocument>().rootVisualElement;

        root.dataSource = this;

        foreach (var pair in _generators)
            root.Q(pair.uiName).style.backgroundImage =
              Background.FromRenderTexture(pair.generator.Texture);
    }

    void Update()
    {
        _offset += (float3)Time.deltaTime;

        foreach (var pair in _generators)
        {
            pair.generator.Frequency = Frequency;
            pair.generator.Offset = Animation ? _offset : 0;
        }
    }
}
