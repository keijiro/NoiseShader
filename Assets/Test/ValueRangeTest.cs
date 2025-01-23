using UnityEngine;

class ValueRangeTest : MonoBehaviour
{
    [SerializeField, HideInInspector] ComputeShader _compute = null;

    void RunTest(int kernel, string name)
    {
        using var buffer = new ComputeBuffer(1, sizeof(float));

        _compute.SetBuffer(kernel, "_Output", buffer);
        _compute.Dispatch(kernel, 1, 1, 1);

        var read = new float[1];
        buffer.GetData(read);

        Debug.Log($"{name} max value = {read[0]}");
    }

    void Start()
    {
        RunTest(0, "2D classic perlin noise");
        RunTest(1, "3D classic perlin noise");
        RunTest(2, "2D simplex noise");
        RunTest(3, "3d simplex noise");
    }
}
