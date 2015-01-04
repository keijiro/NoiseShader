Shader "Hidden/Noise/Mesh"
{
    Properties
    {
        _PositionTex("-", 2D) = ""{}
        _NormalTex("-", 2D) = ""{}
    }
    CGINCLUDE

    sampler2D _PositionTex;
    float4 _PositionTex_TexelSize;

    sampler2D _NormalTex;
    float4 _NormalTex_TexelSize;

    #include "UnityCG.cginc"

    struct appdata
    {
        float4 position : POSITION;
        float4 texcoord1 : TEXCOORD;
        float4 texcoord2 : TEXCOORD1;
    };

    struct v2f
    {
        float4 position : SV_POSITION;
        float3 normal : NORMAL;
        float2 texcoord : TEXCOORD;
    };

    v2f vert(appdata v)
    {
        float3 pos = v.position.xyz;
        float2 uv1 = v.texcoord1;
        float2 uv2 = v.texcoord2;

#ifdef UNITY_HALF_TEXEL_OFFSET
        uv1 += _PositionTex_TexelSize.xy * 0.5;
        uv2 += _NormalTex_TexelSize.xy * 0.5;
#endif

        pos += tex2D(_PositionTex, uv1).xyz;
        float3 normal = tex2D(_NormalTex, uv2).xyz;

        v2f o;
        o.position = mul(UNITY_MATRIX_MVP, float4(pos, 1));
        o.normal = mul(float4(normal, 0), _World2Object);
        return o;
    }

    float4 frag(v2f i) : SV_Target 
    {
        return float4(saturate(i.normal.y));
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
