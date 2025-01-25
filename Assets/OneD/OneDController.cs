using Unity.Properties;
using UnityEngine;
using UnityEngine.VFX;
using UnityEngine.UIElements;

public sealed class OneDController : MonoBehaviour
{
    [field:SerializeField, CreateProperty]
    public float Frequency { get; set; } = 1;

    [field:SerializeField, CreateProperty]
    public bool Fractal { get; set; } = true;

    [field:SerializeField, CreateProperty]
    public bool Animation { get; set; } = true;

    [SerializeField] VisualEffect[] _vfx = null;

    void Start()
      => GetComponent<UIDocument>().rootVisualElement.dataSource = this;

    void Update()
    {
        foreach (var vfx in _vfx)
        {
            vfx.SetFloat("Frequency", Frequency);
            vfx.SetUInt("Octaves", Fractal ? 5u : 1u);
            vfx.SetFloat("Scroll", Animation ? 2 : 0);
        }
    }
}
