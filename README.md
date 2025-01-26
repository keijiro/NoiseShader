# Noise Shader Library for Unity

**NoiseShader** is a Unity package that provides 2D/3D gradient noise functions
written HLSL. These functions are ported from the [webgl-noise] library,
originally developed by Stefan Gustavson and Ahima Arts.

[webgl-noise]: https://github.com/stegu/webgl-noise

Currently, the package includes the following noise functions:

- 1D gradient noise
- Classic Perlin noise (2D/3D)
- Periodic Perlin noise (2D/3D)
- Simplex noise (2D/3D)
- Analytical derivatives of simplex noise (2D/3D)

## How to Install

The Klutter Tools package (`jp.keijiro.noiseshader`) can be installed via the
"Keijiro" scoped registry using Package Manager. To add the registry to your
project, please follow [these instructions].

[these instructions]:
  https://gist.github.com/keijiro/f8c7e8ff29bfe63d86b888901b82644c
