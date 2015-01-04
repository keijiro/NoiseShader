Shader "Hidden/Noise/Mesh"
{
    Properties
    {
        _PositionTex("-", 2D) = ""{}
        _NormalTex("-", 2D) = ""{}
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        
        CGPROGRAM

        #pragma surface surf Lambert vertex:vert addshadow
        #pragma glsl

        sampler2D _PositionTex;
        float4 _PositionTex_TexelSize;

        sampler2D _NormalTex;
        float4 _NormalTex_TexelSize;

        struct Input
        {
            float dummy;
        };

        void vert(inout appdata_full v)
        {
            float2 uv1 = v.texcoord;
            float2 uv2 = v.texcoord1;

#ifdef UNITY_HALF_TEXEL_OFFSET
            uv1 += _PositionTex_TexelSize.xy * 0.5;
            uv2 += _NormalTex_TexelSize.xy * 0.5;
#endif

            v.vertex.xyz += tex2D(_PositionTex, uv1).xyz;
            v.normal = tex2D(_NormalTex, uv2).xyz;
        }

        void surf(Input IN, inout SurfaceOutput o)
        {
            o.Albedo = float3(1, 1, 1);
            o.Alpha = 1;
        }

        ENDCG
    } 
}
