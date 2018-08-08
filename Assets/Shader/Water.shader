Shader "Custom/Water" {
	Properties {
		_Water("Water", 2D) = "white" {}
	}
	SubShader {
		Tags { "RenderType"="Opaque" }
		LOD 200

		CGPROGRAM
		// Physically based Standard lighting model, and enable shadows on all light types
		#pragma surface surf Standard fullforwardshadows

		// Use shader model 3.0 target, to get nicer looking lighting
		#pragma target 3.0

		sampler2D _Water;

		struct Input {
			float2 uv_Water;
		};
		
		void surf (Input IN, inout SurfaceOutputStandard o) {
			// Albedo comes from a texture tinted by color
			fixed2 uv = IN.uv_Water;
			uv.x += 0.2 * _Time;
			uv.y += 0.4 * _Time;
			o.Albedo = tex2D(_Water, uv);
		}
		ENDCG
	}
	FallBack "Diffuse"
}
