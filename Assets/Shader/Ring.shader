Shader "Custom/Ring" {
	Properties {
        _Size("Size" ,float) = 0
        _Period("Period", float) = 1
        _Speed("Speed", float) = 1
	}
	SubShader {
		Tags { "RenderType"="Opaque" }
		LOD 200

		CGPROGRAM
		// Physically based Standard lighting model, and enable shadows on all light types
		#pragma surface surf Standard fullforwardshadows

		// Use shader model 3.0 target, to get nicer looking lighting
		#pragma target 3.0

		float _Size;
		float _Period;
		float _Speed;

		struct Input {
			float3 worldPos;
		};

		void surf (Input IN, inout SurfaceOutputStandard o) {
		    float dist = distance(IN.worldPos, fixed3(0, 0, 0));
		    float val = abs(sin(dist * 2 * 3.1415 * _Period - _Time * _Speed));
		    if(val < 1 - _Size)
		    {
		        o.Albedo = fixed4(110/255.0, 87/255.0, 139/255.0, 1);
		    }
		    else
		    {
		        o.Albedo = fixed4(1, 1, 1, 1);
		    }
		}
		ENDCG
	}
	FallBack "Diffuse"
}
