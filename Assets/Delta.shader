Shader "Hidden/Noise/Delta"
{
    Properties
    {
        _MainTex("-", 2D) = ""{}
    }

    CGINCLUDE

    sampler2D _MainTex;
    float2 _MainTex_TexelSize;

    #include "UnityCG.cginc"
    #include "ClassicNoise3D.cginc"

    float4 frag_offs(v2f_img i) : SV_Target 
    {
        float3 coord = tex2D(_MainTex, i.uv).xyz;
        float3 offs = float3(-1, 0, 0) * _Time.y;

        float n1 =
            cnoise(coord * 1 + offs) +
            cnoise(coord * 2 + offs) * 0.5 +
            cnoise(coord * 4 + offs) * 0.25;

        offs += float3(0, 0, 5.3);

        float n2 =
            cnoise(coord * 1 + offs) +
            cnoise(coord * 2 + offs) * 0.5 +
            cnoise(coord * 4 + offs) * 0.25;

        offs += float3(0, 0, 5.3);

        float n3 =
            cnoise(coord * 1 + offs) +
            cnoise(coord * 2 + offs) * 0.5 +
            cnoise(coord * 4 + offs) * 0.25;

        coord += float3(n1 * 0.5, n2 * 0.5, n3 * 0.5);

        return float4(coord, 0);
    }

    float4 frag_norm1(v2f_img i) : SV_Target 
    {
        float2 duv = _MainTex_TexelSize;

        float3 v1 = tex2D(_MainTex, i.uv).xyz;
        float3 v2 = tex2D(_MainTex, i.uv + float2(0, duv.y)).xyz;
        float3 v3 = tex2D(_MainTex, i.uv + duv).xyz;

        float3 n = normalize(cross(v2 - v1, v3 - v2));

        return float4(n, 0);
    }

    float4 frag_norm2(v2f_img i) : SV_Target 
    {
        float2 duv = _MainTex_TexelSize;

        float3 v1 = tex2D(_MainTex, i.uv).xyz;
        float3 v2 = tex2D(_MainTex, i.uv + duv).xyz;
        float3 v3 = tex2D(_MainTex, i.uv + float2(duv.x, 0)).xyz;

        float3 n = normalize(cross(v2 - v3, v3 - v1));

        return float4(n, 0);
    }

    ENDCG

    SubShader
    {
        Pass
        {
            CGPROGRAM
            #pragma target 3.0
            #pragma glsl
            #pragma vertex vert_img
            #pragma fragment frag_offs
            ENDCG
        }
        Pass
        {
            CGPROGRAM
            #pragma target 3.0
            #pragma glsl
            #pragma vertex vert_img
            #pragma fragment frag_norm1
            ENDCG
        }
        Pass
        {
            CGPROGRAM
            #pragma target 3.0
            #pragma glsl
            #pragma vertex vert_img
            #pragma fragment frag_norm2
            ENDCG
        }
    }
}
