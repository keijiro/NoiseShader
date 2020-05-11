Noise Shader Library for Unity
==============================

This is a Unity shader library that contains several gradient noise functions.

From webgl-noise written by Stefan Gustavson and Ahima Arts:

https://github.com/ashima/webgl-noise

- Classic Perlin noise (2D/3D)
- Periodic Perlin noise (2D/3D)
- Simplex noise (2D/3D)
- Analytical derivatives of simplex noise (2D/3D)

From K.jpg's SuperSimplex & FastSimplex repository:

https://github.com/KdotJPG/New-Simplex-Style-Gradient-Noise

- SuperSimplexNoise (3D)
- FastSimplexStyleNoise (3D)

How To Install
--------------

This package uses the [scoped registry] feature to resolve package dependencies.
Please add the following sections to the manifest file (Packages/manifest.json).

[scoped registry]: https://docs.unity3d.com/Manual/upm-scoped.html

To the `scopedRegistries` section:

```
{
  "name": "Keijiro",
  "url": "https://registry.npmjs.com",
  "scopes": [ "jp.keijiro" ]
}
```

To the `dependencies` section:

```
"jp.keijiro.noiseshader": "1.0.0"
```

After changes, the manifest file should look like below:

```
{
  "scopedRegistries": [
    {
      "name": "Keijiro",
      "url": "https://registry.npmjs.com",
      "scopes": [ "jp.keijiro" ]
    }
  ],
  "dependencies": {
    "jp.keijiro.noiseshader": "1.0.0",
...
```
