Shader "NoiseTest/GLSL/NoiseTest"
{
    SubShader
    {
        Pass
        {
            GLSLPROGRAM
            #pragma multi_compile CNOISE PNOISE SNOISE BCCNOISE4 BCCNOISE8
            #pragma multi_compile _ THREED
            #pragma multi_compile _ FRACTAL
            #pragma multi_compile _ GRAD_NUMERICAL GRAD_ANALYTICAL
            #include "NoiseTest.glslinc"
            ENDGLSL
        }
    }
}
