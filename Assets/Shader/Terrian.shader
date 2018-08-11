Shader "Custom/Terrian" {
	Properties {
		_MainTex("MainTex", 2D) = "white"{}
		_SubTex("SubTex", 2D) = "white"{}
		_MaskTex("MaskTex", 2D) = "white"{}
	}
	SubShader {
		Tags { "RenderType"="Opaque" }
		LOD 200

		CGPROGRAM
		// Physically based Standard lighting model, and enable shadows on all light types
		#pragma surface surf Standard fullforwardshadows

		// Use shader model 3.0 target, to get nicer looking lighting
		#pragma target 3.0

        sampler2D _MainTex;
        sampler2D _SubTex;
        sampler2D _MaskTex;

		struct Input {
			float2 uv_MainTex;
			float2 uv_SubTex;
			float2 uv_MaskTex;
		};

		void surf (Input IN, inout SurfaceOutputStandard o) {
		    float4 main = tex2D(_MainTex, IN.uv_MainTex);
		    float4 sub = tex2D(_SubTex, IN.uv_SubTex);
		    float4 mask = tex2D(_MaskTex, IN.uv_MaskTex);
		    
		    /*
		    lerpで ap + b(1 - p)を行なっている
		    今回はfixed4同士のlerpだから、
		    color.r = c1.r * p + c2.r * (1-p);
            color.g = c1.g * p + c2.g * (1-p);
            color.b = c1.b * p + c2.b * (1-p);
            color.a = c1.a * p + c2.a * (1-p);
            を行なっている
		    */
		    o.Albedo = lerp(main, sub, mask);
		}
		ENDCG
	}
	FallBack "Diffuse"
}
