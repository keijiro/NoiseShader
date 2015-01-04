Shader "Custom/Noise Mesh"
{
    Properties
    {
    }
    CGINCLUDE

#include "UnityCG.cginc"
#include "ClassicNoise3D.cginc"

struct v2f
{
    float4 pos : SV_POSITION;
};

v2f vert(appdata_base v)
{
    v2f o;
    float3 offs = float3(0, 0, 0.05) * _Time.y;
    float3 crd = v.vertex.xyz;

    float n1 =
        cnoise(crd * 1 + offs) +
        cnoise(crd * 2 + offs) * 0.25 +
        cnoise(crd * 4 + offs) * 0.125;

    offs += float3(0, 0, 5.3);

    float n2 =
        cnoise(crd * 1 + offs) +
        cnoise(crd * 2 + offs) * 0.25 +
        cnoise(crd * 4 + offs) * 0.125;

    offs += float3(0, 0, 5.3);

    float n3 =
        cnoise(crd * 1 + offs) +
        cnoise(crd * 2 + offs) * 0.25 +
        cnoise(crd * 4 + offs) * 0.125;

    o.pos = mul(UNITY_MATRIX_MVP, v.vertex + float4(n1 * 0.4, n2 * 0.4, n3 * 0.6, 0));
    return o;
}

float4 frag(v2f i) : SV_Target 
{
    return float4(1, 1, 1, 1);
}

    ENDCG
    SubShader
    {
        Pass
        {
            CGPROGRAM
            #pragma target 3.0
            #pragma glsl
            #pragma vertex vert
            #pragma fragment frag
            ENDCG
        }
    }
}
