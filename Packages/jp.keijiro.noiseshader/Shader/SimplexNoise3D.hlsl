//
// Noise Shader Library for Unity - https://github.com/keijiro/NoiseShader
//
// Original work (webgl-noise) Copyright (C) 2011 Ashima Arts.
// Translation and modification was made by Keijiro Takahashi.
//
// This shader is based on the webgl-noise GLSL shader. For further details
// of the original shader, please see the following description from the
// original source code.
//

//
// Description : Array and textureless GLSL 2D/3D/4D simplex
//               noise functions.
//      Author : Ian McEwan, Ashima Arts.
//  Maintainer : ijm
//     Lastmod : 20110822 (ijm)
//     License : Copyright (C) 2011 Ashima Arts. All rights reserved.
//               Distributed under the MIT License. See LICENSE file.
//               https://github.com/ashima/webgl-noise
//

#ifndef _INCLUDE_JP_KEIJIRO_NOISESHADER_SIMPLEX_NOISE_3D_HLSL_
#define _INCLUDE_JP_KEIJIRO_NOISESHADER_SIMPLEX_NOISE_3D_HLSL_

#include "Packages/jp.keijiro.noiseshader/Shader/Common.hlsl"

float snoise(float3 v)
{
    // First corner
    float3 i  = floor(v + dot(v, 1.0 / 3));
    float3 x0 = v   - i + dot(i, 1.0 / 6);

    // Other corners
    float3 g = x0.yzx <= x0.xyz;
    float3 l = 1 - g;
    float3 i1 = min(g.xyz, l.zxy);
    float3 i2 = max(g.xyz, l.zxy);

    float3 x1 = x0 - i1 + 1.0 / 6;
    float3 x2 = x0 - i2 + 1.0 / 3;
    float3 x3 = x0 - 0.5;

    // Permutations
    i = wglnoise_mod289(i); // Avoid truncation effects in permutation
    float4 p = wglnoise_permute(    i.z + float4(0, i1.z, i2.z, 1));
           p = wglnoise_permute(p + i.y + float4(0, i1.y, i2.y, 1));
           p = wglnoise_permute(p + i.x + float4(0, i1.x, i2.x, 1));

    // Gradients: 7x7 points over a square, mapped onto an octahedron.
    // The ring size 17*17 = 289 is close to a multiple of 49 (49*6 = 294)
    float4 j = wglnoise_mod(p, 49);
    float4 x = lerp(-1, 1, floor(j / 7) / 7);
    float4 y = lerp(-1, 1, floor(j % 7) / 7);
    float4 h = 1 - abs(x) - abs(y);

    float4 b0 = float4(x.xy, y.xy);
    float4 b1 = float4(x.zw, y.zw);

    float4 s0 = b0 < 0 ? -1 : 1;
    float4 s1 = b1 < 0 ? -1 : 1;
    float4 sh =  h < 0 ? -1 : 1;

    float4 a0 = b0.xzyw + s0.xzyw * sh.xxyy;
    float4 a1 = b1.xzyw + s1.xzyw * sh.zzww;

    float3 g0 = normalize(float3(a0.xy, h.x));
    float3 g1 = normalize(float3(a0.zw, h.y));
    float3 g2 = normalize(float3(a1.xy, h.z));
    float3 g3 = normalize(float3(a1.zw, h.w));

    // Mix final noise value
    float4 m = float4(dot(x0, x0), dot(x1, x1), dot(x2, x2), dot(x3, x3));
    m = max(0.6 - m, 0.0);
    float4 m4 = m * m * m * m;

    float4 px = float4(dot(x0, g0), dot(x1, g1), dot(x2, g2), dot(x3, g3));

    return 42.0 * dot(m4, px);
}

float4 snoise_grad(float3 v)
{
    // First corner
    float3 i  = floor(v + dot(v, 1.0 / 3));
    float3 x0 = v   - i + dot(i, 1.0 / 6);

    // Other corners
    float3 g = x0.yzx <= x0.xyz;
    float3 l = 1 - g;
    float3 i1 = min(g.xyz, l.zxy);
    float3 i2 = max(g.xyz, l.zxy);

    float3 x1 = x0 - i1 + 1.0 / 6;
    float3 x2 = x0 - i2 + 1.0 / 3;
    float3 x3 = x0 - 0.5;

    // Permutations
    i = wglnoise_mod289(i); // Avoid truncation effects in permutation
    float4 p = wglnoise_permute(    i.z + float4(0, i1.z, i2.z, 1));
           p = wglnoise_permute(p + i.y + float4(0, i1.y, i2.y, 1));
           p = wglnoise_permute(p + i.x + float4(0, i1.x, i2.x, 1));

    // Gradients: 7x7 points over a square, mapped onto an octahedron.
    // The ring size 17*17 = 289 is close to a multiple of 49 (49*6 = 294)
    float4 j = wglnoise_mod(p, 49);
    float4 x = lerp(-1, 1, floor(j / 7) / 7);
    float4 y = lerp(-1, 1, floor(j % 7) / 7);
    float4 h = 1 - abs(x) - abs(y);

    float4 b0 = float4(x.xy, y.xy);
    float4 b1 = float4(x.zw, y.zw);

    float4 s0 = b0 < 0 ? -1 : 1;
    float4 s1 = b1 < 0 ? -1 : 1;
    float4 sh =  h < 0 ? -1 : 1;

    float4 a0 = b0.xzyw + s0.xzyw * sh.xxyy;
    float4 a1 = b1.xzyw + s1.xzyw * sh.zzww;

    float3 g0 = normalize(float3(a0.xy, h.x));
    float3 g1 = normalize(float3(a0.zw, h.y));
    float3 g2 = normalize(float3(a1.xy, h.z));
    float3 g3 = normalize(float3(a1.zw, h.w));

    // Compute noise and gradient at P
    float4 m = float4(dot(x0, x0), dot(x1, x1), dot(x2, x2), dot(x3, x3));
    m = max(0.6 - m, 0);
    float4 m3 = m * m * m;
    float4 m4 = m * m3;

    float4 px = float4(dot(x0, g0), dot(x1, g1), dot(x2, g2), dot(x3, g3));

    float3 grad = m4.x * g0 - 6 * m3.x * x0 * dot(x0, g0) +
                  m4.y * g1 - 6 * m3.y * x1 * dot(x1, g1) +
                  m4.z * g2 - 6 * m3.z * x2 * dot(x2, g2) +
                  m4.w * g3 - 6 * m3.w * x3 * dot(x3, g3);

    return 42.0 * float4(grad, dot(m4, px));
}

#endif
