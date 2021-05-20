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
// Description : Array and textureless GLSL 2D simplex noise function.
//      Author : Ian McEwan, Ashima Arts.
//  Maintainer : ijm
//     Lastmod : 20110822 (ijm)
//     License : Copyright (C) 2011 Ashima Arts. All rights reserved.
//               Distributed under the MIT License. See LICENSE file.
//               https://github.com/ashima/webgl-noise
//

#ifndef _INCLUDE_JP_KEIJIRO_NOISESHADER_SIMPLEX_NOISE_2D_HLSL_
#define _INCLUDE_JP_KEIJIRO_NOISESHADER_SIMPLEX_NOISE_2D_HLSL_

#include "Packages/jp.keijiro.noiseshader/Shader/Common.hlsl"

float snoise(float2 v)
{
    const float3 C1 = (3 - sqrt(3)) / 6;
    const float3 C2 = (sqrt(3) - 1) / 2;

    // First corner
    float2 i  = floor(v + dot(v, C2));
    float2 x0 = v -   i + dot(i, C1);

    // Other corners
    float2 i1;
    i1.x = x0.y <= x0.x;
    i1.y = 1 - i1.x;

    float2 x1 = x0 + C1 - i1;
    float2 x2 = x0 + C1 * 2 - 1;

    // Permutations
    i = wglnoise_mod289(i); // Avoid truncation effects in permutation
    float3 p = wglnoise_permute(    i.y + float3(0, i1.y, 1));
           p = wglnoise_permute(p + i.x + float3(0, i1.x, 1));

    float3 m = max(0.5 - float3(dot(x0, x0), dot(x1, x1), dot(x2, x2)), 0);
    float3 m4 = m = m * m * m * m;

    // Gradients: 41 points uniformly over a line, mapped onto a diamond.
    // The ring size 17*17 = 289 is close to a multiple of 41 (41*7 = 287)
    float3 x = lerp(-1, 1, frac(p / 41));
    float3 h = abs(x) - 0.5;
    float3 a0 = x - floor(x + 0.5);

    // Normalise gradients
    float2 g0 = normalize(float2(a0.x, h.x));
    float2 g1 = normalize(float2(a0.y, h.y));
    float2 g2 = normalize(float2(a0.z, h.z));

    // Compute final noise value at P
    float3 px = float3(dot(x0, g0), dot(x1, g1), dot(x2, g2));

    return 130 * dot(m4, px);
}

float3 snoise_grad(float2 v)
{
    const float3 C1 = (3 - sqrt(3)) / 6;
    const float3 C2 = (sqrt(3) - 1) / 2;

    // First corner
    float2 i  = floor(v + dot(v, C2));
    float2 x0 = v -   i + dot(i, C1);

    // Other corners
    float2 i1;
    i1.x = x0.y <= x0.x;
    i1.y = 1 - i1.x;

    float2 x1 = x0 + C1 - i1;
    float2 x2 = x0 + C1 * 2 - 1;

    // Permutations
    i = wglnoise_mod289(i); // Avoid truncation effects in permutation
    float3 p = wglnoise_permute(    i.y + float3(0, i1.y, 1));
           p = wglnoise_permute(p + i.x + float3(0, i1.x, 1));

    float3 m = max(0.5 - float3(dot(x0, x0), dot(x1, x1), dot(x2, x2)), 0);
    float3 m3 = m * m * m;
    float3 m4 = m3 * m;

    // Gradients: 41 points uniformly over a line, mapped onto a diamond.
    // The ring size 17*17 = 289 is close to a multiple of 41 (41*7 = 287)
    float3 x = lerp(-1, 1, frac(p / 41));
    float3 h = abs(x) - 0.5;
    float3 a0 = x - floor(x + 0.5);

    // Normalise gradients
    float2 g0 = normalize(float2(a0.x, h.x));
    float2 g1 = normalize(float2(a0.y, h.y));
    float2 g2 = normalize(float2(a0.z, h.z));

    // Compute noise and gradient at P
    float2 grad = m4.x * g0 - 6 * m3.x * x0 * dot(x0, g0) +
                  m4.y * g1 - 6 * m3.y * x1 * dot(x1, g1) +
                  m4.z * g2 - 6 * m3.z * x2 * dot(x2, g2);

    float3 px = float3(dot(x0, g0), dot(x1, g1), dot(x2, g2));

    return 130.0 * float3(grad, dot(m4, px));
}

#endif
