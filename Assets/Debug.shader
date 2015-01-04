Shader "Hidden/Noise/Debug"
{
    Properties
    {
        _MainTex("-", 2D) = ""{}
    }

    CGINCLUDE

    sampler2D _MainTex;

    #include "UnityCG.cginc"

    float4 frag(v2f_img i) : SV_Target 
    {
        float3 c = tex2D(_MainTex, i.uv).xyz;
        return float4(c * 0.5 + 0.5, 1);
    }

    ENDCG

    SubShader
    {
        Pass
        {
            CGPROGRAM
            #pragma vertex vert_img
            #pragma fragment frag
            ENDCG
        }
    }
}
