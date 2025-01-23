#ifdef _NOISEFUNC_CLASSIC
#ifdef _COORDTYPE_TWO
#include "Packages/jp.keijiro.noiseshader/Shader/ClassicNoise2D.hlsl"
float NoiseFunc(float2 x) { return ClassicNoise(x); }
#else
#include "Packages/jp.keijiro.noiseshader/Shader/ClassicNoise3D.hlsl"
float NoiseFunc(float3 x) { return ClassicNoise(x); }
#endif
#else
#ifdef _COORDTYPE_TWO
#include "Packages/jp.keijiro.noiseshader/Shader/SimplexNoise2D.hlsl"
float NoiseFunc(float2 x) { return SimplexNoise(x); }
#else
#include "Packages/jp.keijiro.noiseshader/Shader/SimplexNoise3D.hlsl"
float NoiseFunc(float3 x) { return SimplexNoise(x); }
#endif
#endif

void ImageGeneratorMain_float
  (float2 UV,
   float Frequency,
   float Octaves,
   float3 Offset,
   float Amplitude,
   out float Output)
{
    float3 pos = float3(Frequency * UV, 0) + Offset;
    float sum = 0;
    float amp = 1;

    const uint itr = Octaves;
    for (uint i = 0; i < itr; i++)
    {
        sum += amp * NoiseFunc(pos);
        pos *= 2;
        amp /= 2;
    }

    Output = (1 + sum * Amplitude) / 2;
}
