Shader "NoiseTest/HLSL/NoiseTest"
{
    CGINCLUDE

    #pragma multi_compile CNOISE PNOISE SNOISE BCCNOISE4 BCCNOISE8
    #pragma multi_compile _ THREED
    #pragma multi_compile _ FRACTAL
    #pragma multi_compile _ GRAD_NUMERICAL GRAD_ANALYTICAL

    #include "UnityCG.cginc"

    #if defined(CNOISE) || defined(PNOISE)

        #if defined(THREED)
            #include "ClassicNoise3D.hlsl"
        #else
            #include "ClassicNoise2D.hlsl"
        #endif

        #define INITIAL_WEIGHT 0.5

        #if defined(GRAD_ANALYTICAL)
            #define NOISE_FUNC(coord, period) 0
        #elif defined(CNOISE)
            #define NOISE_FUNC(coord, period) cnoise(coord)
        #else // PNOISE
            #define NOISE_FUNC(coord, period) pnoise(coord, period)
        #endif

    #endif

    #if defined(SNOISE)

        #if defined(THREED)
            #include "SimplexNoise3D.hlsl"
        #else
            #include "SimplexNoise2D.hlsl"
        #endif

        #define INITIAL_WEIGHT 0.25

        #if defined(GRAD_ANALYTICAL)
            #define NOISE_FUNC(coord, period) snoise_grad(coord)
        #else
            #define NOISE_FUNC(coord, period) snoise(coord)
        #endif

    #endif

    #if defined(BCCNOISE4)

        #include "BCCNoise4.hlsl"

        #define INITIAL_WEIGHT 0.25

        #if defined(THREED)
            #if defined(GRAD_ANALYTICAL)
                #define NOISE_FUNC(coord, period) (Bcc4NoiseClassic(coord).xyz)
            #else
                #define NOISE_FUNC(coord, period) (Bcc4NoiseClassic(coord).w)
            #endif
        #else
            #if defined(GRAD_ANALYTICAL)
                #define NOISE_FUNC(coord, period) (Bcc4NoisePlaneFirst(float3(coord, 0)).xy)
            #else
                #define NOISE_FUNC(coord, period) (Bcc4NoisePlaneFirst(float3(coord, 0)).w)
            #endif
        #endif

    #endif

    #if defined(BCCNOISE8)

        #include "BCCNoise8.hlsl"

        #define INITIAL_WEIGHT 0.25

        #if defined(THREED)
            #if defined(GRAD_ANALYTICAL)
                #define NOISE_FUNC(coord, period) (Bcc8NoiseClassic(coord).xyz)
            #else
                #define NOISE_FUNC(coord, period) (Bcc8NoiseClassic(coord).w)
            #endif
        #else
            #if defined(GRAD_ANALYTICAL)
                #define NOISE_FUNC(coord, period) (Bcc8NoisePlaneFirst(float3(coord, 0)).xy)
            #else
                #define NOISE_FUNC(coord, period) (Bcc8NoisePlaneFirst(float3(coord, 0)).w)
            #endif
        #endif

    #endif

    v2f_img vert(appdata_base v)
    {
        v2f_img o;
        o.pos = UnityObjectToClipPos(v.vertex);
        o.uv = v.texcoord.xy;
        return o;
    }

    float4 frag(v2f_img i) : SV_Target
    {
        const float epsilon = 0.0001;

        float2 uv = i.uv * 4.0 + float2(0.2, 1) * _Time.y;

        #if defined(GRAD_ANALYTICAL) || defined(GRAD_NUMERICAL)
            #if defined(THREED)
                float3 o = 0.5;
            #else
                float2 o = 0.5;
            #endif
        #else
            float o = 0.5;
        #endif

        float s = 1.0;
        float w = INITIAL_WEIGHT;

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

            #if defined(GRAD_NUMERICAL)
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

        #if defined(GRAD_ANALYTICAL) || defined(GRAD_NUMERICAL)
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
            #pragma target 3.0
            #pragma vertex vert
            #pragma fragment frag
            ENDCG
        }
    }
}
