Shader "Noise/Test/HLSL"
{
    CGINCLUDE

    #pragma multi_compile CNOISE PNOISE
    #pragma multi_compile TWO_DEE THREE_DEE

    #include "UnityCG.cginc"

    #ifdef TWO_DEE
        #include "ClassicNoise2D.cginc"
    #else
        #include "ClassicNoise3D.cginc"
    #endif

    v2f_img vert(appdata_base v)
    {
        v2f_img o;
        o.pos = mul(UNITY_MATRIX_MVP, v.vertex);
        o.uv = v.texcoord.xy;
        return o;
    }

    float4 frag(v2f_img i) : SV_Target 
    {
        float2 uv = i.uv * 4.0;

        float o = 0.5;
        float s = 1.0;
        float w = 0.5;

        for (int i = 0; i < 6; i++)
        {
            float3 coord = float3((uv + float2(0.2, 1) * _Time.y) * s, _Time.y);
            float3 period = float3(s, s, 1) * 2;

            #ifdef CNOISE
                #ifdef TWO_DEE
                    o += cnoise(coord.xy) * w;
                #else
                    o += cnoise(coord) * w;
                #endif
            #else
                #ifdef TWO_DEE
                    o += pnoise(coord.xy, period.xy) * w;
                #else
                    o += pnoise(coord, period) * w;
                #endif
            #endif

            s *= 2.0;
            w *= 0.5;
        }

        return float4(o, o, o, 1);
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
