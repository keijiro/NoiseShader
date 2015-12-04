Shader "NoiseTest/GLSL/NoiseTest"
{
    GLSLINCLUDE

    #pragma multi_compile CNOISE PNOISE SNOISE SNOISE_NGRAD SNOISE_AGRAD
    #pragma multi_compile _ THREED
    #pragma multi_compile _ FRACTAL

    #include "UnityCG.glslinc"

    #if defined(SNOISE) || defined(SNOISE_NGRAD)
        #if defined(THREED)
            #include "SimplexNoise3D.glsl"
        #else
            #include "SimplexNoise2D.glsl"
        #endif
    #elif defined(SNOISE_AGRAD)
        #if defined(THREED)
            #include "SimplexNoiseGrad3D.glsl"
        #else
            #include "SimplexNoiseGrad2D.glsl"
        #endif
    #else // CNOISE/PNOISE
        #if defined(THREED)
            #include "ClassicNoise3D.glsl"
        #else
            #include "ClassicNoise2D.glsl"
        #endif
    #endif

    varying vec4 uv;

    #if defined(VERTEX)

    void main()
    {
        gl_Position = gl_ModelViewProjectionMatrix * gl_Vertex;
        uv = gl_MultiTexCoord0;
    }

    #endif

    #if defined(FRAGMENT)

    void main()
    {
        const float epsilon = 0.0001;

        vec2 uv = uv.xy * 4.0;

        float s = 1.0;

        #if defined(SNOISE_NGRAD) || defined(SNOISE_AGRAD)
            #if defined(THREED)
                vec3 o = vec3(0.5);
            #else
                vec2 o = vec2(0.5);
            #endif
        #else
            float o = 0.5;
        #endif

        #if defined(SNOISE)
            float w = 0.25;
        #else
            float w = 0.5;
        #endif

        #if defined(FRACTAL)
        for (int i = 0; i < 6; i++)
        #endif
        {
            vec3 coord = vec3((uv + vec2(0.2, 1.0) * _Time.y) * s, _Time.y);
            vec3 period = vec3(s, s, 1.0) * 2.0;

            #if defined(CNOISE)
                #if defined(THREED)
                    o += cnoise(coord) * w;
                #else
                    o += cnoise(coord.xy) * w;
                #endif
            #elif defined(PNOISE)
                #if defined(THREED)
                    o += pnoise(coord, period) * w;
                #else
                    o += pnoise(coord.xy, period.xy) * w;
                #endif
            #elif defined(SNOISE)
                #if defined(THREED)
                    o += snoise(coord) * w;
                #else
                    o += snoise(coord.xy) * w;
                #endif
            #elif defined(SNOISE_NGRAD)
                #if defined(THREED)
                    float v0 = snoise(coord);
                    float vx = snoise(coord + vec3(epsilon, 0, 0));
                    float vy = snoise(coord + vec3(0, epsilon, 0));
                    float vz = snoise(coord + vec3(0, 0, epsilon));
                    o += w * vec3(vx - v0, vy - v0, vz - v0) / epsilon;
                #else
                    float v0 = snoise(coord.xy);
                    float vx = snoise(coord.xy + vec2(epsilon, 0));
                    float vy = snoise(coord.xy + vec2(0, epsilon));
                    o += w * vec2(vx - v0, vy - v0) / epsilon;
                #endif
            #else // SNOISE_AGRAD
                #if defined(THREED)
                    o += snoise_grad(coord) * w;
                #else
                    o += snoise_grad(coord.xy) * w;
                #endif
            #endif

            s *= 2.0;
            w *= 0.5;
        }

        #if defined(SNOISE_NGRAD) || defined(SNOISE_AGRAD)
            #if defined(THREED)
                gl_FragColor = vec4(o, 1);
            #else
                gl_FragColor = vec4(o, 1, 1);
            #endif
        #else
            gl_FragColor = vec4(o, o, o, 1);
        #endif
    }

    #endif

    ENDGLSL
    SubShader
    {
        Pass
        {
            GLSLPROGRAM
            ENDGLSL
        }
    } 
}
