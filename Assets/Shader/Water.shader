Shader "Custom/Water" {
	Properties {
		_Water("Water", 2D) = "white" {}
		_SpeedX("SpeedX", float) = 0
		_SpeedY("SpeedY", float) = 0
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
		float _SpeedX, _SpeedY;

		struct Input {
			float2 uv_Water;
		};
		
		void surf (Input IN, inout SurfaceOutputStandard o) {
			// Albedo comes from a texture tinted by color
			fixed2 uv = IN.uv_Water;
			uv.x += _SpeedX * _Time;
			uv.y += _SpeedY * _Time;
			o.Albedo = tex2D(_Water, uv);
		}
		ENDCG
	}
	FallBack "Diffuse"
}
