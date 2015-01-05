using UnityEngine;
using System.Collections;

[RequireComponent(typeof(MeshFilter))]
public class MeshBuilder : MonoBehaviour
{
    [SerializeField]
    float _radius = 5;

    [SerializeField]
    float _height = 10;

    [SerializeField]
    int _slices = 40;

    [SerializeField]
    int _stacks = 40;

    [SerializeField]
    Shader _initialShader;
    Material _initialMaterial;

    [SerializeField]
    Shader _deltaShader;
    Material _deltaMaterial;

    [SerializeField]
    Shader _debugShader;
    Material _debugMaterial;

    [SerializeField]
    Shader _meshShader;
    Material _meshMaterial1;
    Material _meshMaterial2;

    RenderTexture _initialRT;
    RenderTexture _positionRT;
    RenderTexture _normal1RT;
    RenderTexture _normal2RT;

    Mesh BuildMesh()
    {
        var Nx = _slices;
        var Ny = _stacks;

        var Sx = 1.0f / Nx;
        var Sy = 1.0f / Ny;

        var TA1 = new Vector2[(Nx - 1) * (Ny - 1) * 6];
        var TA2 = new Vector2[(Nx - 1) * (Ny - 1) * 6];

        var i = 0;

        for (var Iy = 0; Iy < Ny - 1; Iy++)
        {
            for (var Ix = 0; Ix < Nx - 1; Ix++)
            {
                TA1[i + 0] = new Vector2(Sx * (Ix + 0), Sy * (Iy + 0));
                TA1[i + 1] = new Vector2(Sx * (Ix + 0), Sy * (Iy + 1));
                TA1[i + 2] = new Vector2(Sx * (Ix + 1), Sy * (Iy + 1));

                var uv = new Vector2(Sx * Ix, Sy * Iy);
                TA2[i + 0] = uv;
                TA2[i + 1] = uv;
                TA2[i + 2] = uv;

                i += 3;
            }
        }

        for (var Iy = 0; Iy < Ny - 1; Iy++)
        {
            for (var Ix = 0; Ix < Nx - 1; Ix++)
            {
                TA1[i + 0] = new Vector2(Sx * (Ix + 0), Sy * (Iy + 0));
                TA1[i + 1] = new Vector2(Sx * (Ix + 1), Sy * (Iy + 1));
                TA1[i + 2] = new Vector2(Sx * (Ix + 1), Sy * (Iy + 0));

                var uv = new Vector2(Sx * Ix, Sy * Iy);
                TA2[i + 0] = uv;
                TA2[i + 1] = uv;
                TA2[i + 2] = uv;

                i += 3;
            }
        }

        var IA1 = new int[(Nx - 1) * (Ny - 1) * 3];
        var IA2 = new int[(Nx - 1) * (Ny - 1) * 3];

        for (var i1 = 0; i1 < IA1.Length; i1++)
        {
            IA1[i1] = i1;
            IA2[i1] = i1 + IA1.Length;
        }

        var mesh = new Mesh();
        mesh.subMeshCount = 2;
        mesh.vertices = new Vector3[TA1.Length];
        mesh.uv = TA1;
        mesh.uv2 = TA2;
        mesh.SetIndices(IA1, MeshTopology.Triangles, 0);
        mesh.SetIndices(IA2, MeshTopology.Triangles, 1);
        mesh.Optimize();
        mesh.bounds = new Bounds(Vector3.zero, Vector3.one * 10000);

        return mesh;
    }

    void Start()
    {
        var width = _slices;
        var height = _stacks;

        _initialRT  = new RenderTexture(width, height, 0, RenderTextureFormat.ARGBFloat);
        _positionRT = new RenderTexture(width, height, 0, RenderTextureFormat.ARGBFloat);
        _normal1RT  = new RenderTexture(width, height, 0, RenderTextureFormat.ARGBFloat);
        _normal2RT  = new RenderTexture(width, height, 0, RenderTextureFormat.ARGBFloat);

        _initialRT.filterMode  = FilterMode.Point;
        _positionRT.filterMode = FilterMode.Point;
        _normal1RT.filterMode  = FilterMode.Point;
        _normal2RT.filterMode  = FilterMode.Point;

        var material = new Material(_initialShader);
        material.SetVector("_Size", new Vector4(_radius, _height, 0, 0));

        Graphics.Blit(null, _initialRT,  material, 0);
        Graphics.Blit(null, _positionRT, material, 0);
        Graphics.Blit(null, _normal1RT,  material, 1);
        Graphics.Blit(null, _normal2RT,  material, 1);

        _deltaMaterial = new Material(_deltaShader);
        _debugMaterial = new Material(_debugShader);

        GetComponent<MeshFilter>().mesh = BuildMesh();

        var materials = new Material[2];
        materials[0] = new Material(_meshShader);
        materials[1] = new Material(_meshShader);

        materials[0].SetTexture("_PositionTex", _positionRT);
        materials[0].SetTexture("_NormalTex", _normal1RT);

        materials[1].SetTexture("_PositionTex", _positionRT);
        materials[1].SetTexture("_NormalTex", _normal2RT);

        renderer.materials = materials;
    }

    void Update()
    {
        Graphics.Blit(_initialRT, _positionRT, _deltaMaterial, 0);
        Graphics.Blit(_positionRT, _normal1RT, _deltaMaterial, 1);
        Graphics.Blit(_positionRT, _normal2RT, _deltaMaterial, 2);
    }

    void OnGUI()
    {
        if (Event.current.type.Equals(EventType.Repaint))
        {
            Graphics.DrawTexture(new Rect(  0, 0, 64, 64), _initialRT,  _debugMaterial);
            Graphics.DrawTexture(new Rect( 64, 0, 64, 64), _positionRT, _debugMaterial);
            Graphics.DrawTexture(new Rect(128, 0, 64, 64), _normal1RT,  _debugMaterial);
            Graphics.DrawTexture(new Rect(192, 0, 64, 64), _normal2RT,  _debugMaterial);
        }
    }
}
