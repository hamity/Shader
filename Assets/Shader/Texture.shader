Shader "Custom/Texture" {
	Properties {
	    //変数名("Inspector上の表示名", 変数の種類) = デフォルト値
	    _MainTex("Texture", 2D) = "white"{}
	    _ScrollY("ScrollY", float) = 0
	}
	SubShader {
		Tags { "RenderType"="Opaque" }
		LOD 200

		CGPROGRAM
		// Physically based Standard lighting model, and enable shadows on all light types
		#pragma surface surf Standard fullforwardshadows

		// Use shader model 3.0 target, to get nicer looking lighting
		#pragma target 3.0

		struct Input {
		    //変数名であるMainTexの前にuvとつけることで、自動的にマテリアルのテクスチャ座標設定(TilingとOffset)が適用されたUV座標が入ってきます
			float2 uv_MainTex;
		};

        //プロパティで受け取ったデータをシェーダ内で使うための定義です。
        //2Dテクスチャの場合は、sampler2Dです。
        sampler2D _MainTex;
        float _ScrollY;

		void surf (Input IN, inout SurfaceOutputStandard o) {
		//Texture関数は UV座標(uv_MainTex)からテクスチャ(_MainTex)上のピクセルの色を計算して返します
			o.Albedo = tex2D(_MainTex, IN.uv_MainTex + float2(0, _ScrollY) * _Time.y);
	    //uv座標とは? 3DCGモデルにテクスチャをマッピングするとき、貼り付ける位置や方向、大きさなどを指定するために使う座標系のこと
	    //ここのTextureを3Dのここの部分に貼り付けるといったことを決める
		}
		ENDCG
	}
	FallBack "Diffuse"
}
