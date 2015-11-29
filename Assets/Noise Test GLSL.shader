Shader "Noise/Test/GLSL"
{
    SubShader
    {
        Pass
        {
            GLSLPROGRAM

            #pragma multi_compile CNOISE PNOISE SNOISE
            #pragma multi_compile TWO_DEE THREE_DEE

            #include "UnityCG.glslinc"

            #ifdef SNOISE
                #ifdef TWO_DEE
                    #include "noise2D.glsl"
                #else
                    #include "noise3D.glsl"
                #endif
            #else
                #ifdef TWO_DEE
                    #include "classicnoise2D.glsl"
                #else
                    #include "classicnoise3D.glsl"
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

                for (int i = 0; i < 6; i++)
                {
                    vec3 coord = vec3((uv + vec2(0.2, 1.0) * _Time.y) * s, _Time.y);
                    vec3 period = vec3(s, s, 1.0) * 2.0;

                    #ifdef CNOISE
                        #ifdef TWO_DEE
                            o += cnoise(coord.xy) * w;
                        #else
                            o += cnoise(coord) * w;
                        #endif
                    #elif PNOISE
                        #ifdef TWO_DEE
                            o += pnoise(coord.xy, period.xy) * w;
                        #else
                            o += pnoise(coord, period) * w;
                        #endif
                    #else
                        #ifdef TWO_DEE
                            o += snoise(coord.xy) * w;
                        #else
                            o += snoise(coord) * w;
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
