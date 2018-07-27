// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "Custom/r2t" {
	
	Properties {
		[HideInInspector] _Shit0 ("Shit 0", 2D) = "black" {}
		[HideInInspector] _Shit1 ("Shit 1", 2D) = "black" {}
		[HideInInspector] _Shit2 ("Shit 2", 2D) = "black" {}
		[HideInInspector] _Shit3 ("Shit 3", 2D) = "black" {}
		[HideInInspector] _Shit4 ("Shit 4", 2D) = "black" {}
		[HideInInspector] _Shit5 ("Shit 5", 2D) = "black" {}
		[HideInInspector] _Shit6 ("Shit 6", 2D) = "black" {}
		[HideInInspector] _Shit7 ("Shit 7", 2D) = "black" {}
		[HideInInspector] _Shit8 ("Shit 8", 2D) = "black" {}
		[HideInInspector] _Shit9 ("Shit 9", 2D) = "black" {}
		[HideInInspector] _Shit10 ("Shit 10", 2D) = "black" {}
		[HideInInspector] _Shit11 ("Shit 11", 2D) = "black" {}

		[HideInInspector] _NormalShit0("NormalShit 0", 2D) = "bump" {}
		[HideInInspector] _NormalShit1("NormalShit 1", 2D) = "bump" {}
		[HideInInspector] _NormalShit2("NormalShit 2", 2D) = "bump" {}
		[HideInInspector] _NormalShit3("NormalShit 3", 2D) = "bump" {}
		[HideInInspector] _NormalShit4("NormalShit 4", 2D) = "bump" {}
		[HideInInspector] _NormalShit5("NormalShit 5", 2D) = "bump" {}
		[HideInInspector] _NormalShit6("NormalShit 6", 2D) = "bump" {}
		[HideInInspector] _NormalShit7("NormalShit 7", 2D) = "bump" {}
		[HideInInspector] _NormalShit8("NormalShit 8", 2D) = "bump" {}
		[HideInInspector] _NormalShit9("NormalShit 9", 2D) = "bump" {}
		[HideInInspector] _NormalShit10("NormalShit 10", 2D) = "bump" {}
		[HideInInspector] _NormalShit11("NormalShit 11", 2D) = "bump" {}

		[HideInInspector] _ControlShit0("Control Shit 0", 2D) = "black" {}
		[HideInInspector] _ControlShit1("Control Shit 1", 2D) = "black" {}
		[HideInInspector] _ControlShit2("Control Shit 2", 2D) = "black" {}

		[HideInInspector] _Shit0_ST ("Shit 1 ST", Vector) = (1,1,0,0)
		[HideInInspector] _Shit1_ST ("Shit 1 ST", Vector) = (1,1,0,0)
		[HideInInspector] _Shit2_ST ("Shit 2 ST", Vector) = (1,1,0,0)
		[HideInInspector] _Shit3_ST ("Shit 3 ST", Vector) = (1,1,0,0)
		[HideInInspector] _Shit4_ST ("Shit 4 ST", Vector) = (1,1,0,0)
		[HideInInspector] _Shit5_ST ("Shit 5 ST", Vector) = (1,1,0,0)
		[HideInInspector] _Shit6_ST ("Shit 6 ST", Vector) = (1,1,0,0)
		[HideInInspector] _Shit7_ST ("Shit 7 ST", Vector) = (1,1,0,0)
		[HideInInspector] _Shit8_ST("Shit 8 ST", Vector) = (1,1,0,0)
		[HideInInspector] _Shit9_ST("Shit 9 ST", Vector) = (1,1,0,0)
		[HideInInspector] _Shit10_ST("Shit 10 ST", Vector) = (1,1,0,0)
		[HideInInspector] _Shit11_ST("Shit 11 ST", Vector) = (1,1,0,0)

		[HideInInspector] _Tile_ST ("Tile ST", Vector) = (1,1,0,0)

		[HideInInspector][Gamma] _Metallic0("Metallic 0", Range(0.0, 1.0)) = 0.0
		[HideInInspector][Gamma] _Metallic1("Metallic 1", Range(0.0, 1.0)) = 0.0
		[HideInInspector][Gamma] _Metallic2("Metallic 2", Range(0.0, 1.0)) = 0.0
		[HideInInspector][Gamma] _Metallic3("Metallic 3", Range(0.0, 1.0)) = 0.0
		[HideInInspector][Gamma] _Metallic4("Metallic 4", Range(0.0, 1.0)) = 0.0
		[HideInInspector][Gamma] _Metallic5("Metallic 5", Range(0.0, 1.0)) = 0.0
		[HideInInspector][Gamma] _Metallic6("Metallic 6", Range(0.0, 1.0)) = 0.0
		[HideInInspector][Gamma] _Metallic7("Metallic 7", Range(0.0, 1.0)) = 0.0
		[HideInInspector][Gamma] _Metallic8("Metallic 8", Range(0.0, 1.0)) = 0.0
		[HideInInspector][Gamma] _Metallic9("Metallic 9", Range(0.0, 1.0)) = 0.0
		[HideInInspector][Gamma] _Metallic10("Metallic 10", Range(0.0, 1.0)) = 0.0
		[HideInInspector][Gamma] _Metallic11("Metallic 11", Range(0.0, 1.0)) = 0.0
		[HideInInspector] _Smoothness0("Smoothness 0", Range(0.0, 1.0)) = 1.0
		[HideInInspector] _Smoothness1("Smoothness 1", Range(0.0, 1.0)) = 1.0
		[HideInInspector] _Smoothness2("Smoothness 2", Range(0.0, 1.0)) = 1.0
		[HideInInspector] _Smoothness3("Smoothness 3", Range(0.0, 1.0)) = 1.0
		[HideInInspector] _Smoothness4("Smoothness 4", Range(0.0, 1.0)) = 1.0
		[HideInInspector] _Smoothness5("Smoothness 5", Range(0.0, 1.0)) = 1.0
		[HideInInspector] _Smoothness6("Smoothness 6", Range(0.0, 1.0)) = 1.0
		[HideInInspector] _Smoothness7("Smoothness 7", Range(0.0, 1.0)) = 1.0
		[HideInInspector] _Smoothness4("Smoothness 8", Range(0.0, 1.0)) = 1.0
		[HideInInspector] _Smoothness5("Smoothness 9", Range(0.0, 1.0)) = 1.0
		[HideInInspector] _Smoothness6("Smoothness 10", Range(0.0, 1.0)) = 1.0
		[HideInInspector] _Smoothness7("Smoothness 11", Range(0.0, 1.0)) = 1.0
	}

	SubShader {
		Tags { "RenderType"="Opaque" "Queue"="Geometry"}
		
		Pass {
			CGPROGRAM
			
			#pragma vertex vert
			#pragma fragment frag
			#pragma target 5.0

			#include "UnityCG.cginc"

			UNITY_DECLARE_TEX2D(_Shit0);
			UNITY_DECLARE_TEX2D_NOSAMPLER(_Shit1);
			UNITY_DECLARE_TEX2D_NOSAMPLER(_Shit2);
			UNITY_DECLARE_TEX2D_NOSAMPLER(_Shit3);
			UNITY_DECLARE_TEX2D_NOSAMPLER(_Shit4);
			UNITY_DECLARE_TEX2D_NOSAMPLER(_Shit5);
			UNITY_DECLARE_TEX2D_NOSAMPLER(_Shit6);
			UNITY_DECLARE_TEX2D_NOSAMPLER(_Shit7);
			UNITY_DECLARE_TEX2D_NOSAMPLER(_Shit8);
			UNITY_DECLARE_TEX2D_NOSAMPLER(_Shit9);
			UNITY_DECLARE_TEX2D_NOSAMPLER(_Shit10);
			UNITY_DECLARE_TEX2D_NOSAMPLER(_Shit11);

			UNITY_DECLARE_TEX2D(_NormalShit0);
			UNITY_DECLARE_TEX2D_NOSAMPLER(_NormalShit1);
			UNITY_DECLARE_TEX2D_NOSAMPLER(_NormalShit2);
			UNITY_DECLARE_TEX2D_NOSAMPLER(_NormalShit3);
			UNITY_DECLARE_TEX2D_NOSAMPLER(_NormalShit4);
			UNITY_DECLARE_TEX2D_NOSAMPLER(_NormalShit5);
			UNITY_DECLARE_TEX2D_NOSAMPLER(_NormalShit6);
			UNITY_DECLARE_TEX2D_NOSAMPLER(_NormalShit7);
			UNITY_DECLARE_TEX2D_NOSAMPLER(_NormalShit8);
			UNITY_DECLARE_TEX2D_NOSAMPLER(_NormalShit9);
			UNITY_DECLARE_TEX2D_NOSAMPLER(_NormalShit10);
			UNITY_DECLARE_TEX2D_NOSAMPLER(_NormalShit11);

			UNITY_DECLARE_TEX2D(_ControlShit0);
			UNITY_DECLARE_TEX2D_NOSAMPLER(_ControlShit1);
			UNITY_DECLARE_TEX2D_NOSAMPLER(_ControlShit2);

			float4 _Shit0_ST;
			float4 _Shit1_ST;
			float4 _Shit2_ST;
			float4 _Shit3_ST;
			float4 _Shit4_ST;
			float4 _Shit5_ST;
			float4 _Shit6_ST;
			float4 _Shit7_ST;
			float4 _Shit8_ST;
			float4 _Shit9_ST;
			float4 _Shit10_ST;
			float4 _Shit11_ST;

			float4 _Tile_ST;

			float _Smoothness0;
			float _Smoothness1;
			float _Smoothness2;
			float _Smoothness3;
			float _Smoothness4;
			float _Smoothness5;
			float _Smoothness6;
			float _Smoothness7;
			float _Smoothness8;
			float _Smoothness9;
			float _Smoothness10;
			float _Smoothness11;

			float _Metallic0;
			float _Metallic1;
			float _Metallic2;
			float _Metallic3;
			float _Metallic4;
			float _Metallic5;
			float _Metallic6;
			float _Metallic7;
			float _Metallic8;
			float _Metallic9;
			float _Metallic10;
			float _Metallic11;

			struct a2v {
				float4 vertex : POSITION;
				float2 texcoord : TEXCOORD0;
			};
			
			struct v2f {
				float4 pos : SV_POSITION;
				float2 uv : TEXCOORD0;
			};
			
			struct fragOutput {
				float4 color : SV_Target0;
				float4 normal : SV_Target1;
			};

			v2f vert(a2v v) {
				v2f o;
				o.pos = v.vertex;
				
				o.uv = v.texcoord;

				return o;
			}
			
			fragOutput frag(v2f i) {
				fragOutput result;

				//Sample all the textures
				float4 controlShit0 = UNITY_SAMPLE_TEX2D(_ControlShit0, i.uv * _Tile_ST.xy + _Tile_ST.zw);
				float4 controlShit1 = UNITY_SAMPLE_TEX2D_SAMPLER(_ControlShit1, _ControlShit0, i.uv * _Tile_ST.xy + _Tile_ST.zw);
				float4 controlShit2 = UNITY_SAMPLE_TEX2D_SAMPLER(_ControlShit2, _ControlShit0, i.uv * _Tile_ST.xy + _Tile_ST.zw);

				float4 shit0 = UNITY_SAMPLE_TEX2D(_Shit0, (_Shit0_ST.xy * (i.uv * _Tile_ST.xy + _Tile_ST.zw) + _Shit0_ST.zw));
				float4 shit1 = UNITY_SAMPLE_TEX2D_SAMPLER(_Shit1, _Shit0, (_Shit1_ST.xy * (i.uv * _Tile_ST.xy + _Tile_ST.zw) + _Shit1_ST.zw));
				float4 shit2 = UNITY_SAMPLE_TEX2D_SAMPLER(_Shit2, _Shit0, (_Shit2_ST.xy * (i.uv * _Tile_ST.xy + _Tile_ST.zw) + _Shit2_ST.zw));
				float4 shit3 = UNITY_SAMPLE_TEX2D_SAMPLER(_Shit3, _Shit0, (_Shit3_ST.xy * (i.uv * _Tile_ST.xy + _Tile_ST.zw) + _Shit3_ST.zw));
				float4 shit4 = UNITY_SAMPLE_TEX2D_SAMPLER(_Shit4, _Shit0, (_Shit4_ST.xy * (i.uv * _Tile_ST.xy + _Tile_ST.zw) + _Shit4_ST.zw));
				float4 shit5 = UNITY_SAMPLE_TEX2D_SAMPLER(_Shit5, _Shit0, (_Shit5_ST.xy * (i.uv * _Tile_ST.xy + _Tile_ST.zw) + _Shit5_ST.zw));
				float4 shit6 = UNITY_SAMPLE_TEX2D_SAMPLER(_Shit6, _Shit0, (_Shit6_ST.xy * (i.uv * _Tile_ST.xy + _Tile_ST.zw) + _Shit6_ST.zw));
				float4 shit7 = UNITY_SAMPLE_TEX2D_SAMPLER(_Shit7, _Shit0, (_Shit7_ST.xy * (i.uv * _Tile_ST.xy + _Tile_ST.zw) + _Shit7_ST.zw));
				float4 shit8 = UNITY_SAMPLE_TEX2D_SAMPLER(_Shit8, _Shit0, (_Shit8_ST.xy * (i.uv * _Tile_ST.xy + _Tile_ST.zw) + _Shit8_ST.zw));
				float4 shit9 = UNITY_SAMPLE_TEX2D_SAMPLER(_Shit9, _Shit0, (_Shit9_ST.xy * (i.uv * _Tile_ST.xy + _Tile_ST.zw) + _Shit9_ST.zw));
				float4 shit10 = UNITY_SAMPLE_TEX2D_SAMPLER(_Shit10, _Shit0, (_Shit10_ST.xy * (i.uv * _Tile_ST.xy + _Tile_ST.zw) + _Shit10_ST.zw));
				float4 shit11 = UNITY_SAMPLE_TEX2D_SAMPLER(_Shit11, _Shit0, (_Shit11_ST.xy * (i.uv * _Tile_ST.xy + _Tile_ST.zw) + _Shit11_ST.zw));

				float4 normalshit0 = (UNITY_SAMPLE_TEX2D(_NormalShit0, (_Shit0_ST.xy * (i.uv * _Tile_ST.xy + _Tile_ST.zw) + _Shit0_ST.zw)));
				float4 normalshit1 = (UNITY_SAMPLE_TEX2D_SAMPLER(_NormalShit1, _NormalShit0, (_Shit1_ST.xy * (i.uv * _Tile_ST.xy + _Tile_ST.zw) + _Shit1_ST.zw)));
				float4 normalshit2 = (UNITY_SAMPLE_TEX2D_SAMPLER(_NormalShit2, _NormalShit0, (_Shit2_ST.xy * (i.uv * _Tile_ST.xy + _Tile_ST.zw) + _Shit2_ST.zw)));
				float4 normalshit3 = (UNITY_SAMPLE_TEX2D_SAMPLER(_NormalShit3, _NormalShit0, (_Shit3_ST.xy * (i.uv * _Tile_ST.xy + _Tile_ST.zw) + _Shit3_ST.zw)));
				float4 normalshit4 = (UNITY_SAMPLE_TEX2D_SAMPLER(_NormalShit4, _NormalShit0, (_Shit4_ST.xy * (i.uv * _Tile_ST.xy + _Tile_ST.zw) + _Shit4_ST.zw)));
				float4 normalshit5 = (UNITY_SAMPLE_TEX2D_SAMPLER(_NormalShit5, _NormalShit0, (_Shit5_ST.xy * (i.uv * _Tile_ST.xy + _Tile_ST.zw) + _Shit5_ST.zw)));
				float4 normalshit6 = (UNITY_SAMPLE_TEX2D_SAMPLER(_NormalShit6, _NormalShit0, (_Shit6_ST.xy * (i.uv * _Tile_ST.xy + _Tile_ST.zw) + _Shit6_ST.zw)));
				float4 normalshit7 = (UNITY_SAMPLE_TEX2D_SAMPLER(_NormalShit7, _NormalShit0, (_Shit7_ST.xy * (i.uv * _Tile_ST.xy + _Tile_ST.zw) + _Shit7_ST.zw)));
				float4 normalshit8 = (UNITY_SAMPLE_TEX2D_SAMPLER(_NormalShit8, _NormalShit0, (_Shit4_ST.xy * (i.uv * _Tile_ST.xy + _Tile_ST.zw) + _Shit8_ST.zw)));
				float4 normalshit9 = (UNITY_SAMPLE_TEX2D_SAMPLER(_NormalShit9, _NormalShit0, (_Shit5_ST.xy * (i.uv * _Tile_ST.xy + _Tile_ST.zw) + _Shit9_ST.zw)));
				float4 normalshit10 = (UNITY_SAMPLE_TEX2D_SAMPLER(_NormalShit10, _NormalShit0, (_Shit6_ST.xy * (i.uv * _Tile_ST.xy + _Tile_ST.zw) + _Shit10_ST.zw)));
				float4 normalshit11 = (UNITY_SAMPLE_TEX2D_SAMPLER(_NormalShit11, _NormalShit0, (_Shit7_ST.xy * (i.uv * _Tile_ST.xy + _Tile_ST.zw) + _Shit11_ST.zw)));
				
				float weight = dot(controlShit0, float4(1, 1, 1, 1)) + dot(controlShit1, float4(1, 1, 1, 1)) + dot(controlShit2, float4(1, 1, 1, 1));

				// Normalize weights before lighting and restore weights in final modifier functions so that the overal
				// lighting result can be correctly weighted.
				controlShit0 /= (weight + 1e-3f);
				controlShit1 /= (weight + 1e-3f);
				controlShit2 /= (weight + 1e-3f);
				
				result.color = controlShit0.r * shit0 * half4(1, 1, 1, _Smoothness0) +
							   controlShit0.g * shit1 * half4(1, 1, 1, _Smoothness1) +
							   controlShit0.b * shit2 * half4(1, 1, 1, _Smoothness2) +
							   controlShit0.a * shit3 * half4(1, 1, 1, _Smoothness3) +
					           controlShit1.r * shit4 * half4(1, 1, 1, _Smoothness4) +
					           controlShit1.g * shit5 * half4(1, 1, 1, _Smoothness5) +
					           controlShit1.b * shit6 * half4(1, 1, 1, _Smoothness6) +
					           controlShit1.a * shit7 * half4(1, 1, 1, _Smoothness7) +
							   controlShit2.r * shit8 * half4(1, 1, 1, _Smoothness8) +
							   controlShit2.g * shit9 * half4(1, 1, 1, _Smoothness9) +
							   controlShit2.b * shit10 * half4(1, 1, 1, _Smoothness10) +
							   controlShit2.a * shit11 * half4(1, 1, 1, _Smoothness11);//alpha channel is smoothness
				
				result.normal.xyz = UnpackNormal(controlShit0.r * normalshit0 +
												 controlShit0.g * normalshit1 +
												 controlShit0.b * normalshit2 +
												 controlShit0.a * normalshit3 +
					                             controlShit1.r * normalshit4 + 
					                             controlShit1.g * normalshit5 + 
					                             controlShit1.b * normalshit6 + 
					                             controlShit1.a * normalshit7 +
												 controlShit2.r * normalshit8 +
												 controlShit2.g * normalshit9 +
												 controlShit2.b * normalshit10 +
												 controlShit2.a * normalshit11);//blend before unpack, unpack here to match the format

				result.normal.xyz = normalize(result.normal.xyz);//important, but it seems unity has already done this
				//result.normal.xy = (result.normal.xy + 1) * 0.5;//important use r and g to store x and y, we are using ARGBhalf render texture now, don't need to convert the values to 0 to 1
				result.normal.z = controlShit0.r * _Metallic0 +
								  controlShit0.g * _Metallic1 +
								  controlShit0.b * _Metallic2 +
								  controlShit0.a * _Metallic3 +
								  controlShit1.r * _Metallic4 +
								  controlShit1.g * _Metallic5 +
								  controlShit1.b * _Metallic6 +
								  controlShit1.a * _Metallic7 +
								  controlShit2.r * _Metallic8 +
								  controlShit2.g * _Metallic9 +
								  controlShit2.b * _Metallic10 +
								  controlShit2.a * _Metallic11;//metallic
				result.normal.w = weight;//alpha, notice in terrain shader, this value should be used to scale albedo according to the standard terrain surface shader, but I found not using it is also acceptable in my case.
				return result;
			}
			
			ENDCG
		}
	} 

 	FallBack Off

}
