Shader "Unlit/LavaRighting"
{
//UnlintShaderは光のないShader(光源情報を持たないという意味)
	Properties
	{
		_MainTex ("Texture", 2D) = "white" {}
	}
	SubShader
	{
		Tags { "RenderType"="Opaque" }
		LOD 100

		Pass
		{
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			// make fog work
			#pragma multi_compile_fog
			
			#include "UnityCG.cginc"

			struct appdata
			{
				float4 vertex : POSITION;
				float2 uv : TEXCOORD0;
			};

			struct v2f
			{
				float2 uv : TEXCOORD0;
				UNITY_FOG_COORDS(1)
				float4 vertex : SV_POSITION;
			};

			sampler2D _MainTex;
			float4 _MainTex_ST;
			
			v2f vert (appdata v)
			{
				v2f o;
				o.vertex = UnityObjectToClipPos(v.vertex);
				o.uv = TRANSFORM_TEX(v.uv, _MainTex);
				UNITY_TRANSFER_FOG(o,o.vertex);
				return o;
			}
			
			fixed4 frag (v2f i) : SV_Target
			{
				half2 p = i.uv.xy;
				half2 a = p * 4.;
				a.y -= _Time.w * 0.5;
				//小数部を返す
				half2 f = frac(a);
				//aは整数になる
				a -= f;
				f = f * f * (3.0 - 2.0 * f);
				
				//1e3 = 1000 = 10^3
				half4 r = frac(sin((a.x + a.y * 1e3) + half4(0, 1, 1e3, 1001)) * 1e5) * 30 / p.y;
				return half4(p.y + half3(1.0, 0.5, 0.2) * clamp(lerp(lerp(r.x, r.y, f.x), lerp(r.z, r.w, f.x), f.y)-30.0, -2, 1),  1);
				//上の文わかりにくいが、
				/*
				half4(p.y + half3(1.0, 0.5, 0.2) * A, 1)である 左側のみでhalf3になる
				A = clamp(lerp(lerp(r.x, r.y, f.x), lerp(r.z, r.w, f.x), f.y)-30.0, -2, 1)
				lerp(a, b, x) aとbの線型補完
				a = lerp(r.x, r.y, f.x), b =  lerp(r.z, r.w, f.x), x = f.y
				clamp( x, min, max )	xがmin以下ならmin, max以上ならmax
                x = lerp(a, b, x), min = -2, max = 1
				*/
			}
			ENDCG
		}
	}
}
