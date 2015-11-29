Shader "Noise/Test/GLSL"
{
    SubShader
    {
        Pass
        {
            GLSLPROGRAM

            #pragma multi_compile CNOISE PNOISE SNOISE
            #pragma multi_compile _ THREED
            #pragma multi_compile _ FRACTAL

            #include "UnityCG.glslinc"

            #ifdef SNOISE
                #ifdef THREED
                    #include "noise3D.glsl"
                #else
                    #include "noise2D.glsl"
                #endif
            #else
                #ifdef THREED
                    #include "classicnoise3D.glsl"
                #else
                    #include "classicnoise2D.glsl"
                #endif
            #endif

            varying vec4 uv;

            #ifdef VERTEX

            void main()
            {
                gl_Position = gl_ModelViewProjectionMatrix * gl_Vertex;
                uv = gl_MultiTexCoord0;
            }

            #endif

            #ifdef FRAGMENT

            void main()
            {
                vec2 uv = uv.xy * 4.0;

                float o = 0.5;
                float s = 1.0;
                #ifdef SNOISE
                float w = 0.25;
                #else
                float w = 0.5;
                #endif

                #ifdef FRACTAL
                for (int i = 0; i < 6; i++)
                #endif
                {
                    vec3 coord = vec3((uv + vec2(0.2, 1.0) * _Time.y) * s, _Time.y);
                    vec3 period = vec3(s, s, 1.0) * 2.0;

                    #ifdef CNOISE
                        #ifdef THREED
                            o += cnoise(coord) * w;
                        #else
                            o += cnoise(coord.xy) * w;
                        #endif
                    #elif defined(PNOISE)
                        #ifdef THREED
                            o += pnoise(coord, period) * w;
                        #else
                            o += pnoise(coord.xy, period.xy) * w;
                        #endif
                    #else
                        #ifdef THREED
                            o += snoise(coord) * w;
                        #else
                            o += snoise(coord.xy) * w;
                        #endif
                    #endif

                    s *= 2.0;
                    w *= 0.5;
                }

                gl_FragColor = vec4(o, o, o, 1);
            }

            #endif

            ENDGLSL
        }
    } 
}
