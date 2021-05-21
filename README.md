Noise Shader Library for Unity
==============================

**NoiseShader** is a Unity package that provides 2D/3D gradient noise
functions written in the shader language. These functions are ported from the
[webgl-noise] library that is originally written by Stefan Gustavson and Ahima
Arts.

[webgl-noise]: https://github.com/ashima/webgl-noise

At the moment, it contains the following functions:

- Classic Perlin noise (2D/3D)
- Periodic Perlin noise (2D/3D)
- Simplex noise (2D/3D)
- Analytical derivatives of simplex noise (2D/3D)

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
"jp.keijiro.noiseshader": "2.0.0"
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
    "jp.keijiro.noiseshader": "2.0.0",
...
```
