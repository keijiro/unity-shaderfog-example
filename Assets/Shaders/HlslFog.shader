Shader "Custom/HlslFog" {
	Properties {
		_MainTex ("Base (RGB)", 2D) = "white" {}
		_FogColor ("Fog Color (RGB)", Color) = (0.5, 0.5, 0.5, 1.0)
		_FogStart ("Fog Start", Float) = 0.0
		_FogEnd ("Fog End", Float) = 10.0
	}
	SubShader {
		Tags { "RenderType"="Opaque" }
		Fog { Mode off }
		
		Pass {
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			
			sampler2D _MainTex;
			float4 _FogColor;
			float _FogStart;
			float _FogEnd;
			
			struct appdata {
				float4 vertex : POSITION;
				float4 texcoord : TEXCOORD0;
			};
			
			struct v2f {
				float4 pos : SV_POSITION;
				float4 uv : TEXCOORD0;
				float fog : TEXCOORD1;
			};
			
			v2f vert(appdata v) {
				v2f o;
				o.pos = mul(UNITY_MATRIX_MVP, v.vertex);
				o.uv = v.texcoord;
				float fogz = mul(UNITY_MATRIX_MV, v.vertex).z;
				o.fog = saturate((fogz + _FogStart) / (_FogStart - _FogEnd));
				return o;
			}
			
			half4 frag(v2f i) : COLOR {
				return lerp(tex2D(_MainTex, i.uv.xy), _FogColor, i.fog);
			}
			
			ENDCG
		}
	} 
}
