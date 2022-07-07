// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "Unlit/Color2"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        _Second("Texture2", 2D) = "White"{}
        _TintColor("Tintcolor", Color) = (0.5,0.5,0.5,0.5)
    }
    SubShader
    {
        Tags {"IgnoreProjector" = "True" "Queue" = "Transparent"   "RenderType"="Opaque" }
        LOD 100

        Pass
        {
            Name "FORWARD"
            Tags{
            "LightMode" = "ForwardBase"
            }
            Blend SrcAlpha OneMinusSrcAlpha
            Cull Off
            ZWrite Off


            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #include "UnityCG.cginc"

            struct v2f
            {
                fixed2 uv : TEXCOORD0;
                fixed2 uv1 : TEXCOORD1;
                fixed4 pos : SV_POSITION;

                fixed4 color : COLOR;
            };

            sampler2D _MainTex;
            sampler2D _Second;

            fixed4 _MainTex_ST;
            fixed4 _Second_ST;

            fixed4 _TintColor;


            v2f vert (appdata_full v)
            {
                v2f o;

                o.color = v.color;
                o.pos = UnityObjectToClipPos(v.vertex);


                o.uv = TRANSFORM_TEX(v.texcoord, _MainTex);
                o.uv1 = TRANSFORM_TEX(v.texcoord, _Second);
               

                return o;
            }

            fixed4 frag(v2f i) : COLOR
            {

                fixed4 _MainTex_var = tex2D(_MainTex, i.uv);
                fixed4 _Second_var = tex2D(_Second, i.uv);

                fixed3 emissive = _MainTex_var.rgb * i.color.rgb;
                fixed node_9936 = _Second_var.r;

                fixed3 finalColor = emissive * (_TintColor * 2);


                return fixed4(finalColor, (i.color.a * _MainTex_var.a * node_9936));


              
            }
            ENDCG
        }
    }
}
