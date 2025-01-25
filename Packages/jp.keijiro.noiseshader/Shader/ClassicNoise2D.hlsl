//
// GLSL textureless classic 2D noise "cnoise",
// with an RSL-style periodic variant "pnoise".
// Author:  Stefan Gustavson (stefan.gustavson@gmail.com)
// Version: 2024-11-07
//
// Many thanks to Ian McEwan of Ashima Arts for the
// ideas for permutation and gradient selection.
//
// Copyright (c) 2011 Stefan Gustavson. All rights reserved.
// Distributed under the MIT license. See LICENSE file.
// https://github.com/stegu/webgl-noise
//

//
// This code has been modified by Keijiro Takahashi for use in Unity,
// including a rewrite in HLSL with simplifications and optimizations.
// Rights to the modifications are waived, and the original license
// terms remain unchanged.
//

#ifndef _INCLUDE_JP_KEIJIRO_NOISESHADER_CLASSIC_NOISE_2D_HLSL_
#define _INCLUDE_JP_KEIJIRO_NOISESHADER_CLASSIC_NOISE_2D_HLSL_

#include "Packages/jp.keijiro.noiseshader/Shader/Common.hlsl"

float ClassicNoise_impl(float2 pi0, float2 pf0, float2 pi1, float2 pf1)
{
    pi0 = wglnoise_mod289(pi0); // To avoid truncation effects in permutation
    pi1 = wglnoise_mod289(pi1);

    float4 ix = float2(pi0.x, pi1.x).xyxy;
    float4 iy = float2(pi0.y, pi1.y).xxyy;
    float4 fx = float2(pf0.x, pf1.x).xyxy;
    float4 fy = float2(pf0.y, pf1.y).xxyy;

    float4 i = wglnoise_permute(wglnoise_permute(ix) + iy);

    // Gradients: 41 points uniformly over a unit circle.
    // The ring size 17*17 = 289 is close to a multiple of 41 (41*7 = 287)
    float4 phi = i / 41 * 3.14159265359 * 2;
    float2 g00 = float2(cos(phi.x), sin(phi.x));
    float2 g10 = float2(cos(phi.y), sin(phi.y));
    float2 g01 = float2(cos(phi.z), sin(phi.z));
    float2 g11 = float2(cos(phi.w), sin(phi.w));

    float n00 = dot(g00, float2(fx.x, fy.x));
    float n10 = dot(g10, float2(fx.y, fy.y));
    float n01 = dot(g01, float2(fx.z, fy.z));
    float n11 = dot(g11, float2(fx.w, fy.w));

    float2 fade_xy = wglnoise_fade(pf0);
    float2 n_x = lerp(float2(n00, n01), float2(n10, n11), fade_xy.x);
    float n_xy = lerp(n_x.x, n_x.y, fade_xy.y);
    return 1.41421356237 * n_xy;
}

// Classic Perlin noise
float ClassicNoise(float2 p)
{
    float2 i = floor(p);
    float2 f = frac(p);
    return ClassicNoise_impl(i, f, i + 1, f - 1);
}

// Classic Perlin noise, periodic variant
float PeriodicNoise(float2 p, float2 rep)
{
    float2 i0 = wglnoise_mod(floor(p), rep);
    float2 i1 = wglnoise_mod(i0 + 1, rep);
    float2 f = frac(p);
    return ClassicNoise_impl(i0, f, i1, f - 1);
}

#endif
