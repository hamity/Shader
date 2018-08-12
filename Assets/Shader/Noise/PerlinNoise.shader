Shader "Custom/PerlinNoise" {
	Properties {
	    _MainTex("Albedo(2D)", 2D) = "white"{}
	    _Divide("Divide", int) = 8
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
		
		//fixed2で返すところに注意
		fixed2 randomFixed2(fixed2 p)
		{
		    //x,　y座標共に内積を代入する
		    p = fixed2( dot(p,fixed2(127.1,311.7)), dot(p,fixed2(269.5,183.3)));
		    return -1.0 + 2.0 * frac(sin(p)*43758.5453123);
		}
		
		float perlinNoise(fixed2 st)
		{
		    fixed2 p = floor(st);
		    //frac: pの小数部を返す
		    fixed2 f = frac(st);
		    
		    fixed2 uv00 = randomFixed2(p + fixed2(0, 0));
		    fixed2 uv01 = randomFixed2(p + fixed2(0, 1));
		    fixed2 uv10 = randomFixed2(p + fixed2(1, 0));
		    fixed2 uv11 = randomFixed2(p + fixed2(1, 1));
		    
		    fixed2 u = f * f * (3.0 - 2.0 * f);
		    
		    //perlinNoiseでは、格子点に設定されたランダムな値と、ブロック内の点から格子点に向かうベクトルの内積で色情報を決める
		    //つまり、格子点上の値は必ず0になる(黒色になる)
		    return lerp( lerp( dot( uv00, f - fixed2(0,0) ), dot( uv10, f - fixed2(1,0) ), u.x ),
                         lerp( dot( uv01, f - fixed2(0,1) ), dot( uv11, f - fixed2(1,1) ), u.x ), 
                         u.y)+0.5f;
		}

		void surf (Input IN, inout SurfaceOutputStandard o) {
			float r = perlinNoise(IN.uv_MainTex * _Divide);     //uv値を入れると、対応する値が帰って来る
		    o.Albedo = fixed4(r, r, r, 1);
		    o.Metallic = 0;
            o.Smoothness = 0;
            o.Alpha = 1;
		}
		ENDCG
	}
	FallBack "Diffuse"
}
//valuNoiseでは格子状の四隅の色をもとに、内部の情報を設定していた