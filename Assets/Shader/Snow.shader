Shader "Custom/Snow" {
	Properties {
		_Color ("Color", Color) = (1,1,1,1)
		_MainTex ("Albedo (RGB)", 2D) = "white" {}
		_Glossiness ("Smoothness", Range(0,1)) = 0.5
		_Metallic ("Metallic", Range(0,1)) = 0.0
        _Snow("Snow", Range(0, 2)) = 0
        _SnowVec("SnowVec", Vector) = (0, 0, 0, 0)
	}
	SubShader {
		Tags { }
		LOD 200

		CGPROGRAM
		// Physically based Standard lighting model, and enable shadows on all light types
		#pragma surface surf Standard fullforwardshadows

		// Use shader model 3.0 target, to get nicer looking lighting
		#pragma target 3.0

		sampler2D _MainTex;

		struct Input {
			float2 uv_MainTex;
            float2 worldNormal;
		};

		half _Glossiness;
		half _Metallic;
		fixed4 _Color;
        half _Snow;
        fixed4 _SnowVec;
              
		void surf (Input IN, inout SurfaceOutputStandard o) {
            half d = dot(IN.worldNormal, _SnowVec.xyz);
			// Albedo comes from a texture tinted by color
			fixed4 c = tex2D (_MainTex, IN.uv_MainTex) * _Color;
            fixed4 white = fixed4(1, 1, 1, 1);
            c = lerp(c, white, _Snow * d);
			o.Albedo = c.rgb;
			// Metallic and smoothness come from slider variables
			o.Metallic = _Metallic;
			o.Smoothness = _Glossiness;
			o.Alpha = 1;
		}
		ENDCG
	}
	FallBack "Diffuse"
}
