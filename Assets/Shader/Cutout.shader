Shader "Custom/Cutout" {
	Properties {
    _Color("Color", Color) = (1, 1, 1, 1)
	}
	SubShader {
        //Queueの情報がdepthバッファーに登録される
        //今は、球のdepthバッファーは後ろの四角オブジェクトより小さい数字になっている
        //RenderQueueが小さい順から描画されるため、このQueueより後ろの数字の四角オブジェクトの球と重なっている部分は描画されない
        //床の処理を追加する前は 床; 2000, 長方形: 2000, 球: 1999のため、球 -> 球に重なるところ以外を長方形, 床が描画ということになる
		Tags { "Queue"="Geometry-1" }

		Pass{
            ZWrite On       //オブジェクトのピクセルをデプスバッファに書き込むかどうかを制御します (デフォルトは On)
            ColorMask 0     //ColorMask 0が設定されているため何も描画されません
        }
	}
}
