Shader "Custom/ValueNoise" {
	Properties {
	    _MainTex("Albedo(2D)", 2D) = "white"{}
	    _Divide("Divide", float) = 8
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
		float _Divide;

		struct Input {
			float2 uv_MainTex;
		};
		
		float random(fixed2 p)
		{
		    //dot(x, y): xとyの内積
		    //frac(x): x - floor(x) (つまり、xの小数点を返す)
		    //floor(x): x以下の最大の整数
		    return frac(sin(dot(p, fixed2(12.9898,78.233))) * 43758.5453);
		}
		
		float noise(fixed2 p)
		{
			//floor(x): x以下の最大の整数
		    //今回の場合は x.x, x.yのいずれにもfloor()が適用される
		    fixed2 r = floor(p);
		    return random(r);
		}
		
		float valueNoise(fixed2 p)
		{
		    fixed2 a = floor(p);
		    //frac: pの小数部を返す
		    fixed2 b = frac(p);
		    
		    float uv00 = noise(p + fixed2(0, 0));
		    float uv01 = noise(p + fixed2(0, 1));
		    float uv10 = noise(p + fixed2(1, 0));
		    float uv11 = noise(p + fixed2(1, 1));
		    
		    fixed2 u = b * b * (3.0 - 2.0 * b);
		    float uv00_10 = lerp(uv00, uv10, u.x);
		    float uv01_11 = lerp(uv01, uv11, u.x);
		    return lerp(uv00_10, uv01_11, u.y);
		}

		void surf (Input IN, inout SurfaceOutputStandard o) {
			float r = valueNoise(IN.uv_MainTex * _Divide);     //uv値を入れると、対応する値が帰って来る
		    o.Albedo = fixed4(r, r, r, 1);
		}
		ENDCG
	}
	FallBack "Diffuse"
}
