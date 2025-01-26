#ifndef _INCLUDE_JP_KEIJIRO_NOISESHADER_NOISE_1D_HLSL_
#define _INCLUDE_JP_KEIJIRO_NOISESHADER_NOISE_1D_HLSL_

#include "Packages/jp.keijiro.noiseshader/Shader/Common.hlsl"

float GradientNoise(float x, float seed)
{
    float2 i = wglnoise_mod289(floor(float2(x, x + 1)));
    i = wglnoise_permute(wglnoise_permute(i) + seed);

    float2 phi = i / 41 * 3.14159265359 * 2;
    float2 grad = sin(phi);

    float f = frac(x);
    float2 n = grad * float2(f, f - 1);

    float fade = wglnoise_fade(f);
    float v = lerp(n.x, n.y, fade);

    return v * 2;
}

float GradientNoise(float x)
{
    return GradientNoise(x, 1);
}

#endif
