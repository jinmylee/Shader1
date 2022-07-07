Shader "Custom/SnowBuildup"
{
    Properties
    {
        _MainTex("Albedo (RGB)", 2D) = "white" {}
        _SnowHeight("´«ÀÌ ½×ÀÌ´Â Á¤µµ",range(0,0.1)) = 0 
        _SnowAngle("´«ÀÌ ½×ÀÌ´Â ¹æÇâ",vector) = (0,1,0,0)
        _SnowSize("´«ÀÌ ½×ÀÌ´Â ¹üÀ§",range(-1.1,1.1)) = 0 
    }
        SubShader
        {
            Tags { "RenderType" = "Opaque" }
            LOD 200

            CGPROGRAM
            #pragma surface surf Standard fullforwardshadows vertex:vert addshadow

            #pragma target 3.0

            sampler2D _MainTex;
            float _SnowHeight;
            float _SnowSize;
            float4 _SnowAngle;

            void vert(inout appdata_full v)
            {
                float4 snowA = mul(normalize(_SnowAngle), unity_ObjectToWorld); 
                //´«ÀÌ ½×ÀÌ´Â ¹üÀ§¿Í Å©±â¸¦ Á¶Àý
                if (dot(v.normal, snowA.xyz) >= _SnowSize)
                {
                    v.vertex.xyz += v.normal.xyz * _SnowHeight;
                }
            }

            struct Input
            {
                float2 uv_MainTex;
            };

            void surf(Input IN, inout SurfaceOutputStandard o)
            {
                fixed4 c = tex2D(_MainTex, IN.uv_MainTex);
                o.Albedo = c.rgb;
                o.Alpha = c.a;

                //´« µ¤ÀÎ °÷¿¡ Èò»öÀ» Ä¥ÇÔ
                float4 snowA = mul(normalize(_SnowAngle), unity_ObjectToWorld);
                if (dot(mul(o.Normal,unity_ObjectToWorld) , snowA.xyz) >= _SnowSize - 0.1)
                {
                    o.Albedo = 1;//can fixed
                }

            }
            ENDCG
        }
            FallBack "Diffuse"
              


}
