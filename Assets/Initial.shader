Shader "Hidden/Noise/Initialization"
{
    Properties
    {
        _Size("-", Vector) = (5, 10, 0, 0)
    }

    CGINCLUDE

    #include "UnityCG.cginc"

    #define PI2 6.28318530718

    float2 _Size;

    ENDCG

    SubShader
    {
        Pass
        {
            CGPROGRAM
            #pragma vertex vert_img
            #pragma fragment frag
            float4 frag(v2f_img i) : SV_Target 
            {
                float x = cos(i.uv.x * PI2) * _Size.x;
                float y = sin(i.uv.x * PI2) * _Size.x;
                float z = (i.uv.y - 0.5) * _Size.y;
                return float4(x, y, z, 1);
            }
            ENDCG
        }
        Pass
        {
            CGPROGRAM
            #pragma vertex vert_img
            #pragma fragment frag
            float4 frag(v2f_img i) : SV_Target 
            {
                float x = cos(i.uv.x * PI2);
                float y = sin(i.uv.x * PI2);
                return float4(-x, -y, 0, 0);
            }
            ENDCG
        }
    }
}
