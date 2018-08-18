Shader "Custom/VertexColor" {
	SubShader {
		Tags { "RenderType"="Opaque" }
		LOD 200

		CGPROGRAM
		// Physically based Standard lighting model, and enable shadows on all light types
		//Lambertはランバート反射を表している(どの方向から見ても、輝度が一定になるモデル)
		#pragma surface surf Lambert vertex:vert

		// Use shader model 3.0 target, to get nicer looking lighting
		#pragma target 3.0

		struct Input {
			fixed4 vertColor;
		};
        
        /*
        input: 入力であり出力であることを意味する。
        out: 出力を意味する
        appdata_fullはあらかじめ用意された構造体
        struct appdata_full {
        float4 vertex : POSITION;
        float4 tangent : TANGENT;
        float3 normal : NORMAL;
        float4 texcoord : TEXCOORD0;
        float4 texcoord1 : TEXCOORD1;
        float4 texcoord2 : TEXCOORD2;
        float4 texcoord3 : TEXCOORD3;
    #if defined(SHADER_API_XBOX360)
        half4 texcoord4 : TEXCOORD4;
        half4 texcoord5 : TEXCOORD5;
    #endif
        fixed4 color : COLOR;
        };
        
        詳しくはQiita: https://qiita.com/sune2/items/fa5d50d9ea9bd48761b2
        
        また、２つめの引数であるINPUTは、上で定義した
        struct Input {
			fixed4 vertColor;
		};
		を指している
        */
        
		void vert(inout appdata_full v,  out Input o) {
		    //UNITY_INITIALIZE_OUTPUTで指定された 型 の変数 name を 0 に初期化してくれる
		    //今回でいうと、vertColor = (0, 0, 0, 0)ということ
		    //Unity内部でのシェーダーのコンパイラがUnityのバージョンと共に変わり、出力変数に対して初期化が必須になったため、基本しておいたほうが良い
		    UNITY_INITIALIZE_OUTPUT(Input, o);
		    o.vertColor = v.color;      //v.colorは頂点カラー
		}

		void surf (Input IN, inout SurfaceOutput o) {
			o.Albedo = IN.vertColor.rgb;        //　rgb表記に変換してるってことかな? (o.Albedoはfloat3, vertColorはfixed4のため)
		}
		ENDCG
	}
	FallBack "Diffuse"
}
