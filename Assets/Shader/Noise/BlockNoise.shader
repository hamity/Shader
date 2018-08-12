Shader "Custom/BlockNoise" {
	Properties {
        _MainTex("MainTex", 2D) = "white"{}
        _Divide("Divie", int) = 8
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
        int _Divide;

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

		void surf (Input IN, inout SurfaceOutputStandard o) {
		    float r = noise(IN.uv_MainTex * _Divide);     //uv値を入れると、対応する値が帰って来る
		    o.Albedo = fixed4(r, r, r, 1);
		}
		ENDCG
	}
	FallBack "Diffuse"
}
