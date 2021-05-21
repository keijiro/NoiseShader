Shader "NoiseTest/Visualizer"
{
    Properties
    {
        [KeywordEnum(Classic, Periodic, Simplex)] _NoiseType("Noise Type", Float) = 0
        [KeywordEnum(None, Numerical, Analytical)] _Gradient("Gradient Method", Float) = 0
        [Toggle(THREED)] _ThreeD("3D", Float) = 0
        [Toggle(FRACTAL)] _Fractal("Fractal", Float) = 0
    }

    CGINCLUDE

    #pragma multi_compile _NOISETYPE_CLASSIC _NOISETYPE_PERIODIC _NOISETYPE_SIMPLEX
    #pragma multi_compile _GRADIENT_NONE _GRADIENT_NUMERICAL _GRADIENT_ANALYTICAL
    #pragma multi_compile _ THREED
    #pragma multi_compile _ FRACTAL

    #include "UnityCG.cginc"
    #include "Packages/jp.keijiro.noiseshader/Shader/ClassicNoise2D.hlsl"
    #include "Packages/jp.keijiro.noiseshader/Shader/ClassicNoise3D.hlsl"
    #include "Packages/jp.keijiro.noiseshader/Shader/SimplexNoise2D.hlsl"
    #include "Packages/jp.keijiro.noiseshader/Shader/SimplexNoise3D.hlsl"

    #if defined(_NOISETYPE_CLASSIC) || defined(_NOISETYPE_PERIODIC)

        #if defined(_GRADIENT_ANALYTICAL)
            #define NOISE_FUNC(coord, period) 0
        #elif defined(_NOISETYPE_CLASSIC)
            #define NOISE_FUNC(coord, period) ClassicNoise(coord)
        #else // PNOISE
            #define NOISE_FUNC(coord, period) PeriodicNoise(coord, period)
        #endif

    #endif

    #if defined(_NOISETYPE_SIMPLEX)

        #if defined(_GRADIENT_ANALYTICAL)
            #define NOISE_FUNC(coord, period) SimplexNoiseGrad(coord)
        #else
            #define NOISE_FUNC(coord, period) SimplexNoise(coord)
        #endif

    #endif

    void Vertex(float4 position : POSITION,
                float2 uv : TEXCOORD,
                out float4 outPosition : SV_Position,
                out float2 outUV : TEXCOORD)
    {
        outPosition = UnityObjectToClipPos(position);
        outUV = uv;
    }

    float4 Fragment(float4 position : SV_Position,
                    float2 uv : TEXCOORD) : SV_Target
    {
        const float epsilon = 0.0001;

        uv = uv * 4 + float2(0.2, 1) * _Time.y;

        #if defined(_GRADIENT_ANALYTICAL) || defined(_GRADIENT_NUMERICAL)
            #if defined(THREED)
                float3 o = 0.5;
            #else
                float2 o = 0.5;
            #endif
        #else
            float o = 0.5;
        #endif

        float s = 1;
        float w = 0.5;

        #ifdef FRACTAL
        for (int i = 0; i < 6; i++)
        #endif
        {
            #if defined(THREED)
                float3 coord = float3(uv * s, _Time.y);
                float3 period = float3(s, s, 1.0) * 2.0;
            #else
                float2 coord = uv * s;
                float2 period = s * 2.0;
            #endif

            #if defined(_GRADIENT_NUMERICAL)
                #if defined(THREED)
                    float v0 = NOISE_FUNC(coord, period);
                    float vx = NOISE_FUNC(coord + float3(epsilon, 0, 0), period);
                    float vy = NOISE_FUNC(coord + float3(0, epsilon, 0), period);
                    float vz = NOISE_FUNC(coord + float3(0, 0, epsilon), period);
                    o += w * float3(vx - v0, vy - v0, vz - v0) / epsilon;
                #else
                    float v0 = NOISE_FUNC(coord, period);
                    float vx = NOISE_FUNC(coord + float2(epsilon, 0), period);
                    float vy = NOISE_FUNC(coord + float2(0, epsilon), period);
                    o += w * float2(vx - v0, vy - v0) / epsilon;
                #endif
            #else
                o += NOISE_FUNC(coord, period) * w;
            #endif

            s *= 2.0;
            w *= 0.5;
        }

        #if defined(_GRADIENT_ANALYTICAL) || defined(_GRADIENT_NUMERICAL)
            #if defined(THREED)
                return float4(o, 1);
            #else
                return float4(o, 1, 1);
            #endif
        #else
            return float4(o, o, o, 1);
        #endif
    }

    ENDCG
    SubShader
    {
        Pass
        {
            CGPROGRAM
            #pragma vertex Vertex
            #pragma fragment Fragment
            ENDCG
        }
    }
}
