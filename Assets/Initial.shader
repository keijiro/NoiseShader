Shader "Hidden/Noise/Initialization"
{
    Properties
    {
        _Size("-", Vector) = (5, 5, 0, 0)
    }

    CGINCLUDE
    #include "UnityCG.cginc"
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
                return float4(_Size * (i.uv - 0.5), 0, 0);
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
                return float4(0, 0, 1, 0);
            }
            ENDCG
        }
    }
}
