Shader "Custom/StandGrass" {
	Properties {
		_MainTex("Texture", 2D) = "white"{}
	}
	SubShader {
		Tags { "Queue"="Transparent" }
		LOD 200

		CGPROGRAM
		// Physically based Standard lighting model, and enable shadows on all light types
		#pragma surface surf Standard fullforwardshadows alpha:fade

		// Use shader model 3.0 target, to get nicer looking lighting
		#pragma target 3.0

		sampler2D _MainTex;

		struct Input {
			float2 uv_MainTex;
		};

		half _Glossiness;
		half _Metallic;
		fixed4 _Color;

		// Add instancing support for this shader. You need to check 'Enable Instancing' on materials that use the shader.
		// See https://docs.unity3d.com/Manual/GPUInstancing.html for more information about instancing.
		// #pragma instancing_options assumeuniformscaling
		UNITY_INSTANCING_BUFFER_START(Props)
			// put more per-instance properties here
		UNITY_INSTANCING_BUFFER_END(Props)

		void surf (Input IN, inout SurfaceOutputStandard o) {
		    fixed4 c = tex2D(_MainTex, IN.uv_MainTex);
		    o.Albedo = c;
		    o.Alpha = saturate(0.299 * c.x + 0.587 * c.y + 0.114 * c.z < 0.4) ? 1 : 0.7;
		}
		ENDCG
	}
	FallBack "Diffuse"
}
