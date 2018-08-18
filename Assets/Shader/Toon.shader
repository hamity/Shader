Shader "Custom/Toon" {
	Properties {
		_Color ("Color", Color) = (1,1,1,1)
		_MainTex ("Albedo (RGB)", 2D) = "white" {}
		_RampTex("RampTex", 2D) = "white"{}
	}
	SubShader {
		Tags { "RenderType"="Opaque" }
		LOD 200

		CGPROGRAM
		// Physically based Standard lighting model, and enable shadows on all light types
		//#pragma surface surf Standard fullforwardshadows

		// Use shader model 3.0 target, to get nicer looking lighting
		//surf, ToonRampをsurfaceシェーダーとして登録している?
		#pragma surface surf ToonRamp
		#pragma target 3.0

		sampler2D _MainTex;
		sampler2D _RampTex;

		struct Input {
			float2 uv_MainTex;
		};
		
		fixed4 _Color;

        //カスタムライティングを行うためのメソッド
        //サーフェイスシェーダに追加するかたちで、ライティングの工程をフックする必要があります。
        //参考: (バーテックスシェーダー ->) サーフェスシェーダー -> ライティング
        //ライティングの工程のフック方法
        /*
        1. ライティング用のメソッド（Lighting◯◯◯）を作る Lightingで始めないとNG
        2. メソッド名をUnityに伝える
        #programa surface surf ToonRamp
        上でsurfaceとは書いてあるけどLightingとメソッド名につけているので、ライティング処理で扱われるものと思われる
        3. StandardSurfaceOutputを使わないようにする
        */
		fixed4 LightingToonRamp(SurfaceOutput s, fixed3 lightDir, fixed aften)
		{
		    // 0 ~ 1 の値に変換する
		    // half3 Normal;    法線ベクトル
		    half d = dot(s.Normal, lightDir) * 0.5 + 0.5;
		    //_RampTexのuv座標が(d, 0.5)のところの色を取得する(つまり法線ベクトルと光線ベクトルの内積で計算されたdに対応するu座標の色を取得する)
		    fixed3 ramp = tex2D(_RampTex, fixed2(d, 0.5)).rgb;
		    fixed4 c;
		    //    half3 Albedo;   拡散反射光（＝Diffuse）(他の場所に反射する光 = これが目に飛んでいくと、その色が表示される)
		    c.rgb = s.Albedo * _LightColor0.rgb * ramp;
		    c.a = 0;
		    return c;
		}

        /*
        surfシェーダでライティングの工程をフックした場合には、
        surfの出力にはSurfaceOutputStandard型を使うことができないため、SurfaceOutput型に書き換えている。
        SurfaceOutput型にはEmmisionやSmoothnessは定義されていないので削除
        */
		void surf (Input IN, inout SurfaceOutput o) {       // StandardSurfaceOutputからSurfaceOutputに変更
			// Albedo comes from a texture tinted by color
			//uv_MainTexは、uv座標に対応するTextureを返すのだと思われる
			fixed4 c = tex2D (_MainTex, IN.uv_MainTex) * _Color;
			o.Albedo = c.rgb;
			o.Alpha = c.a;
		}
		ENDCG
	}
	FallBack "Diffuse"
}
