//
// Noise Shader Library for Unity - https://github.com/keijiro/NoiseShader
//
// Original work (webgl-noise) Copyright (C) 2011 Stefan Gustavson
// Translation and modification was made by Keijiro Takahashi.
//
// This shader is based on the webgl-noise GLSL shader. For further details
// of the original shader, please see the following description from the
// original source code.
//

//
// GLSL textureless classic 3D noise "cnoise",
// with an RSL-style periodic variant "pnoise".
// Author:  Stefan Gustavson (stefan.gustavson@liu.se)
// Version: 2011-10-11
//
// Many thanks to Ian McEwan of Ashima Arts for the
// ideas for permutation and gradient selection.
//
// Copyright (c) 2011 Stefan Gustavson. All rights reserved.
// Distributed under the MIT license. See LICENSE file.
// https://github.com/ashima/webgl-noise
//

#ifndef _INCLUDE_JP_KEIJIRO_NOISESHADER_CLASSIC_NOISE_3D_HLSL_
#define _INCLUDE_JP_KEIJIRO_NOISESHADER_CLASSIC_NOISE_3D_HLSL_

#include "Packages/jp.keijiro.noiseshader/Shader/Common.hlsl"

// Classic Perlin noise
float cnoise(float3 P)
{
  float3 Pi0 = floor(P); // Integer part for indexing
  float3 Pi1 = Pi0 + 1;

  Pi0 = wglnoise_mod289(Pi0);
  Pi1 = wglnoise_mod289(Pi1);

  float3 Pf0 = frac(P); // Fractional part for interpolation
  float3 Pf1 = Pf0 - 1;

  float4 ix = float4(Pi0.x, Pi1.x, Pi0.x, Pi1.x);
  float4 iy = float4(Pi0.y, Pi0.y, Pi1.y, Pi1.y);
  float4 iz0 = Pi0.z;
  float4 iz1 = Pi1.z;

  float4 ixy = wglnoise_permute(wglnoise_permute(ix) + iy);
  float4 ixy0 = wglnoise_permute(ixy + iz0);
  float4 ixy1 = wglnoise_permute(ixy + iz1);

  float4 gx0 = frac(      ixy0      / 7) - 0.5;
  float4 gy0 = frac(floor(ixy0 / 7) / 7) - 0.5;
  float4 gz0 = 0.5 - abs(gx0) - abs(gy0);

  float4 sz0 = gz0 <= 0;
  gx0 -= sz0 * ((0 <= gx0) - 0.5);
  gy0 -= sz0 * ((0 <= gy0) - 0.5);

  float4 gx1 = frac(      ixy1      / 7) - 0.5;
  float4 gy1 = frac(floor(ixy1 / 7) / 7) - 0.5;
  float4 gz1 = 0.5 - abs(gx1) - abs(gy1);

  float4 sz1 = gz1 <= 0;
  gx1 -= sz1 * ((0 <= gx1) - 0.5);
  gy1 -= sz1 * ((0 <= gy1) - 0.5);

  float3 g000 = normalize(float3(gx0.x, gy0.x, gz0.x));
  float3 g100 = normalize(float3(gx0.y, gy0.y, gz0.y));
  float3 g010 = normalize(float3(gx0.z, gy0.z, gz0.z));
  float3 g110 = normalize(float3(gx0.w, gy0.w, gz0.w));
  float3 g001 = normalize(float3(gx1.x, gy1.x, gz1.x));
  float3 g101 = normalize(float3(gx1.y, gy1.y, gz1.y));
  float3 g011 = normalize(float3(gx1.z, gy1.z, gz1.z));
  float3 g111 = normalize(float3(gx1.w, gy1.w, gz1.w));

  float n000 = dot(g000, Pf0);
  float n100 = dot(g100, float3(Pf1.x, Pf0.y, Pf0.z));
  float n010 = dot(g010, float3(Pf0.x, Pf1.y, Pf0.z));
  float n110 = dot(g110, float3(Pf1.x, Pf1.y, Pf0.z));
  float n001 = dot(g001, float3(Pf0.x, Pf0.y, Pf1.z));
  float n101 = dot(g101, float3(Pf1.x, Pf0.y, Pf1.z));
  float n011 = dot(g011, float3(Pf0.x, Pf1.y, Pf1.z));
  float n111 = dot(g111, Pf1);

  float3 fade_xyz = wglnoise_fade(Pf0);
  float4 n_z = lerp(float4(n000, n100, n010, n110),
                    float4(n001, n101, n011, n111), fade_xyz.z);
  float2 n_yz = lerp(n_z.xy, n_z.zw, fade_xyz.y);
  float n_xyz = lerp(n_yz.x, n_yz.y, fade_xyz.x);
  return n_xyz;
}

// Classic Perlin noise, periodic variant
float pnoise(float3 P, float3 rep)
{
  float3 Pi0 = wglnoise_mod(floor(P), rep); // Integer part, modulo period
  float3 Pi1 = wglnoise_mod(Pi0 + 1, rep);

  Pi0 = wglnoise_mod289(Pi0);
  Pi1 = wglnoise_mod289(Pi1);

  float3 Pf0 = frac(P); // Fractional part for interpolation
  float3 Pf1 = Pf0 - 1;

  float4 ix = float4(Pi0.x, Pi1.x, Pi0.x, Pi1.x);
  float4 iy = float4(Pi0.y, Pi0.y, Pi1.y, Pi1.y);
  float4 iz0 = Pi0.z;
  float4 iz1 = Pi1.z;

  float4 ixy = wglnoise_permute(wglnoise_permute(ix) + iy);
  float4 ixy0 = wglnoise_permute(ixy + iz0);
  float4 ixy1 = wglnoise_permute(ixy + iz1);

  float4 gx0 = frac(      ixy0      / 7) - 0.5;
  float4 gy0 = frac(floor(ixy0 / 7) / 7) - 0.5;
  float4 gz0 = 0.5 - abs(gx0) - abs(gy0);

  float4 sz0 = gz0 <= 0;
  gx0 -= sz0 * ((0 <= gx0) - 0.5);
  gy0 -= sz0 * ((0 <= gy0) - 0.5);

  float4 gx1 = frac(      ixy1      / 7) - 0.5;
  float4 gy1 = frac(floor(ixy1 / 7) / 7) - 0.5;
  float4 gz1 = 0.5 - abs(gx1) - abs(gy1);

  float4 sz1 = gz1 <= 0;
  gx1 -= sz1 * ((0 <= gx1) - 0.5);
  gy1 -= sz1 * ((0 <= gy1) - 0.5);

  float3 g000 = normalize(float3(gx0.x, gy0.x, gz0.x));
  float3 g100 = normalize(float3(gx0.y, gy0.y, gz0.y));
  float3 g010 = normalize(float3(gx0.z, gy0.z, gz0.z));
  float3 g110 = normalize(float3(gx0.w, gy0.w, gz0.w));
  float3 g001 = normalize(float3(gx1.x, gy1.x, gz1.x));
  float3 g101 = normalize(float3(gx1.y, gy1.y, gz1.y));
  float3 g011 = normalize(float3(gx1.z, gy1.z, gz1.z));
  float3 g111 = normalize(float3(gx1.w, gy1.w, gz1.w));

  float n000 = dot(g000, Pf0);
  float n100 = dot(g100, float3(Pf1.x, Pf0.y, Pf0.z));
  float n010 = dot(g010, float3(Pf0.x, Pf1.y, Pf0.z));
  float n110 = dot(g110, float3(Pf1.x, Pf1.y, Pf0.z));
  float n001 = dot(g001, float3(Pf0.x, Pf0.y, Pf1.z));
  float n101 = dot(g101, float3(Pf1.x, Pf0.y, Pf1.z));
  float n011 = dot(g011, float3(Pf0.x, Pf1.y, Pf1.z));
  float n111 = dot(g111, Pf1);

  float3 fade_xyz = wglnoise_fade(Pf0);
  float4 n_z = lerp(float4(n000, n100, n010, n110),
                    float4(n001, n101, n011, n111), fade_xyz.z);
  float2 n_yz = lerp(n_z.xy, n_z.zw, fade_xyz.y);
  float n_xyz = lerp(n_yz.x, n_yz.y, fade_xyz.x);
  return n_xyz;
}

#endif
