Shader "Custom/PNoise GLSL"
{
    Properties
    {
        _Density("Density", Float) = 4
        _Period("Period", Float) = 4
    }
    SubShader
    {
        Pass
        {
            GLSLPROGRAM

#include "UnityCG.glslinc"
#include "classicnoise3D.glsl"

uniform float _Density;
uniform float _Period;

varying vec4 uv;

#ifdef VERTEX

void main()
{
    gl_Position = gl_ModelViewProjectionMatrix * gl_Vertex;
    uv = gl_MultiTexCoord0 * _Density;
}

#endif

#ifdef FRAGMENT

void main()
{
    vec2 c = uv.xy;
    float w = 0.5;
    float s = 0.5;
    float p = _Period;
    for (int i = 0; i < 6; i++)
    {
        s += pnoise(vec3(c.x, c.y, _Time.y), vec3(p, p, 3)) * w;
        c *= 2.0;
        p *= 2.0;
        w *= 0.5;
    }
    gl_FragColor = vec4(s);
}

#endif

            ENDGLSL
        }
    } 
}
