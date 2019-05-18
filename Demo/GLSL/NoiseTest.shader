Shader "Hidden/NoiseTest/GLSL/NoiseTest"
{
    SubShader
    {
        Pass
        {
            GLSLPROGRAM
            #pragma multi_compile CNOISE PNOISE SNOISE SNOISE_AGRAD SNOISE_NGRAD
            #pragma multi_compile _ THREED
            #pragma multi_compile _ FRACTAL
            #include "Packages/com.unity.keijiro.shader.noise/Runtime/GLSL/NoiseTest.glslinc"
            ENDGLSL
        }
    }
}
