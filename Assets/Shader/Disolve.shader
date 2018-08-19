Shader "Custom/Disolve" {
	Properties {
		_Color ("Color", Color) = (1,1,1,1)
		_MainTex ("Albedo (RGB)", 2D) = "white" {}
		_DisolveTex("Disolve", 2D) = "white"{}
		_Glossiness ("Smoothness", Range(0,1)) = 0.5
		_Metallic ("Metallic", Range(0,1)) = 0.0
		_Threshold("Threshold", Range(0, 1)) = 0.0
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
		sampler2D _DisolveTex;

		struct Input {
			float2 uv_MainTex;
		};

		half _Glossiness;
		half _Metallic;
		half _Threshold;
		fixed4 _Color;

		// Add instancing support for this shader. You need to check 'Enable Instancing' on materials that use the shader.
		// See https://docs.unity3d.com/Manual/GPUInstancing.html for more information about instancing.
		// #pragma instancing_options assumeuniformscaling
		UNITY_INSTANCING_BUFFER_START(Props)
			// put more per-instance properties here
		UNITY_INSTANCING_BUFFER_END(Props)

		void surf (Input IN, inout SurfaceOutputStandard o) {
			// Albedo comes from a texture tinted by color
			//MainTexのuv座標に対応する_DisolveTexのデータを取得
			fixed4 c = tex2D (_DisolveTex, IN.uv_MainTex);
			//グレースケールに変換
		    half g = c.r * 0.2 + c.g * 0.7 + c.b * 0.1;
		    //閾値以下の場合
		    if(g < _Threshold)
		    {
		        //その画素を画面に描かない (何も出力しない)
		        discard;
		    }
		    
		    //以下は通常と同じ
		    fixed4 d = tex2D(_MainTex, IN.uv_MainTex) * _Color;
			o.Albedo = d.rgb;
			// Metallic and smoothness come from slider variables
			//表面がどれくらい「金属的か」を決定
			o.Metallic = _Metallic;
			//どの程度表面が滑らかか決定する(0だとザラザラ)
			o.Smoothness = _Glossiness;
			o.Alpha = d.a;
		}
		ENDCG
	}
	FallBack "Diffuse"
}
