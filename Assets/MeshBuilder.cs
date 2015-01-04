using UnityEngine;
using System.Collections;

[RequireComponent(typeof(MeshFilter))]
public class MeshBuilder : MonoBehaviour
{
    Mesh mesh;

    public Vector2 size = new Vector2(4, 4);
    public float density = 10;

    void Awake()
    {
        mesh = new Mesh();

        var Nx = Mathf.FloorToInt(size.x * density);
        var Ny = Mathf.FloorToInt(size.y * density);

        var Ox = -0.5f * size.x;
        var Oy = -0.5f * size.y;

        var Sx = 1.0f / density;
        var Sy = 1.0f / density;

        var VA = new Vector3[Nx * Ny];

        var i = 0;
        for (var Iy = 0; Iy < Ny; Iy++)
        {
            for (var Ix = 0; Ix < Nx; Ix++)
            {
                VA[i++] = new Vector3(Sx * Ix + Ox, Sy * Iy + Oy, 0);
            }
        }

        var IA = new int[(Nx - 1) * Ny * 2 + Nx * (Ny - 1) * 2];

        i = 0;

        for (var Iy = 0; Iy < Ny; Iy++)
        {
            for (var Ix = 0; Ix < Nx - 1; Ix++)
            {
                var Iref = Iy * Nx + Ix;
                IA[i++] = Iref;
                IA[i++] = Iref + 1;
            }
        }

        for (var Ix = 0; Ix < Nx; Ix++)
        {
            for (var Iy = 0; Iy < Ny - 1; Iy++)
            {
                var Iref = Iy * Nx + Ix;
                IA[i++] = Iref;
                IA[i++] = Iref + Nx;
            }
        }

        mesh.vertices = VA;
        mesh.SetIndices(IA, MeshTopology.Lines, 0);
        mesh.Optimize();

        GetComponent<MeshFilter>().mesh = mesh;
    }
}
