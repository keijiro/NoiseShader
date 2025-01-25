using Unity.Properties;
using UnityEngine;
using UnityEngine.VFX;
using UnityEngine.UIElements;

public sealed class CubeController : MonoBehaviour
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
            vfx.SetUInt("Octaves", Fractal ? 4u : 1u);
            vfx.SetVector3("Scroll", Animation ? new Vector3(0.1f, 0.3f, 0.5f) : Vector3.zero);
        }
    }
}
