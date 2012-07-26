Shader "Custom/ShaderFog" {
	Properties {
		_MainTex ("Base (RGB)", 2D) = "white" {}
		_FogColor ("Fog Color (RGB)", Color) = (0.5, 0.5, 0.5, 1.0)
		_FogStart ("Fog Start", Float) = 0.0
		_FogEnd ("Fog End", Float) = 10.0
	}
	SubShader {
		Tags { "RenderType"="Opaque" }
		Fog { Mode off }
		
		CGPROGRAM
		#pragma surface surf Lambert vertex:vert finalcolor:fcolor

		sampler2D _MainTex;
		fixed4 _FogColor;
		float _FogStart;
		float _FogEnd;

		struct Input {
			float2 uv_MainTex;
			float fogVar;
		};

		void vert(inout appdata_full v, out Input data) {
			data.uv_MainTex = v.texcoord.xy;
			float zpos = mul(UNITY_MATRIX_MVP, v.vertex).z;
			data.fogVar = saturate(1.0 - (_FogEnd - zpos) / (_FogEnd - _FogStart));
		}

		void surf(Input IN, inout SurfaceOutput o) {
			half4 c = tex2D(_MainTex, IN.uv_MainTex);
			o.Albedo = c.rgb;
			o.Alpha = c.a;
		}

		void fcolor(Input IN, SurfaceOutput o, inout fixed4 color) {
			fixed3 fogColor = _FogColor.rgb;
	 #ifndef UNITY_PASS_FORWARDBASE
	 		fogColor = 0;
	 #endif
     		color.rgb = lerp(color.rgb, fogColor, IN.fogVar);
		}

		ENDCG
	} 
}
