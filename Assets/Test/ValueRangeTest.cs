using UnityEngine;

class ValueRangeTest : MonoBehaviour
{
    [SerializeField, HideInInspector] ComputeShader _compute = null;

    const uint TotalIteration = 1u << 30;
    const uint ThreadPerGroup = 64u;
    const uint IterationPerThread = 512u;
    const uint ThreadGroupCount = TotalIteration / ThreadPerGroup / IterationPerThread;

    unsafe GraphicsBuffer AllocBuffer<T>(int count) where T : unmanaged
      => new GraphicsBuffer(GraphicsBuffer.Target.Structured, count, sizeof(T));

    void RunTest(int kernel, string name,
                 GraphicsBuffer accBuffer,
                 GraphicsBuffer recvBuffer)
    {
        _compute.SetBuffer(kernel, "_AccBuffer", accBuffer);
        _compute.Dispatch(kernel, (int)ThreadGroupCount, 1, 1);

        _compute.SetBuffer(0, "_AccBuffer", accBuffer);
        _compute.SetBuffer(0, "_OutBuffer", recvBuffer);
        _compute.Dispatch(0, 1, 1, 1);

        var read = new float[1];
        recvBuffer.GetData(read);
        Debug.Log($"{name} max value = {read[0]}");
    }

    void Start()
    {
        using var accBuffer = AllocBuffer<float>((int)ThreadGroupCount);
        using var recvBuffer = AllocBuffer<float>(1);
        RunTest(1, "1D gradient noise", accBuffer, recvBuffer);
        RunTest(2, "2D classic perlin noise", accBuffer, recvBuffer);
        RunTest(3, "3D classic perlin noise", accBuffer, recvBuffer);
        RunTest(4, "2D simplex noise", accBuffer, recvBuffer);
        RunTest(5, "3d simplex noise", accBuffer, recvBuffer);
    }
}
