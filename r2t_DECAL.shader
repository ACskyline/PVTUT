Shader "Custom/r2t_DECAL"
{
	Properties
	{
		_DecalTexture ("DecalTexture", 2D) = "black" {}
		_DecalTextureNormal("DecalTextureNormal", 2D) = "bump" {}
	}
	SubShader
	{
		Tags { "RenderType"="Opaque" }

		//you can choose the alpha chanel operation separately if necessary
		Blend 0 Off
		Blend 1 SrcAlpha OneMinusSrcAlpha

		LOD 100

		Pass
		{

			CGPROGRAM

			#pragma vertex vert
			#pragma fragment frag
			#pragma multi_compile_instancing
			#pragma target 5.0

			#include "UnityCG.cginc"
			
			struct appdata
			{
				float4 vertex : POSITION;
				float2 uv : TEXCOORD0;
				UNITY_VERTEX_INPUT_INSTANCE_ID
			};

			struct v2f
			{
				float2 uv : TEXCOORD0;
				float2 uvNormal : TEXCOORD1;
				float4 vertex : SV_POSITION;
				UNITY_VERTEX_INPUT_INSTANCE_ID
			};

			struct fragOutput {
				float4 color : SV_Target0;
				float4 normal : SV_Target1;
			};

			sampler2D _DecalTexture;
			sampler2D _DecalTextureNormal;
			
			v2f vert (appdata v)
			{
				v2f o;
				
				UNITY_INITIALIZE_OUTPUT(v2f, o)

				UNITY_SETUP_INSTANCE_ID(v);

				o.vertex = v.vertex;

				float cos = unity_ObjectToWorld[0][0];
				float sin = unity_ObjectToWorld[1][0];
				float offsetX = unity_ObjectToWorld[2][0];
				float offsetY = unity_ObjectToWorld[3][0];
				float factorX = unity_ObjectToWorld[0][1];
				float factorY = unity_ObjectToWorld[1][1];

				o.vertex.x = factorX * v.vertex.x * cos - factorY * v.vertex.y * sin + offsetX;
				o.vertex.y = factorX * v.vertex.x * sin + factorY * v.vertex.y * cos + offsetY;

				o.vertex.z = 1 - 1 / (unity_ObjectToWorld[3][1] + 2);//convert priority to depth value to sort out render order

				o.uv = v.uv;
				o.uvNormal = v.uv;

				o.uv.x = v.uv.x * unity_ObjectToWorld[0][2] + unity_ObjectToWorld[2][2];
				o.uv.y = v.uv.y * unity_ObjectToWorld[1][2] + unity_ObjectToWorld[3][2];

				o.uvNormal.x = v.uv.x * unity_ObjectToWorld[0][3] + unity_ObjectToWorld[2][3];
				o.uvNormal.y = v.uv.y * unity_ObjectToWorld[1][3] + unity_ObjectToWorld[3][3];
				
				return o;
			}
			
			fragOutput frag (v2f i)
			{
				fragOutput result;
				result.color = tex2D(_DecalTexture, i.uv);//DEBUG
				result.color.a = 0;//DEBUG
				result.normal = float4(1, 1, 1, 1);
				//Because we are rendering to textures, the value in it should conform to the sampling formality
				result.normal.xyz = UnpackNormal(tex2D(_DecalTextureNormal, i.uvNormal));
				result.normal.xyz = normalize(result.normal.xyz);//important, but it seems unity has already done this
				//result.normal.xy = (result.normal.xz + 1) * 0.5;//important use r and g to store x and z, we are using ARGBhalf render texture now, don't need to convert the values to 0 to 1
				result.normal.z = 0;

				if(unity_ObjectToWorld[0][3] < 0 || unity_ObjectToWorld[1][3] < 0 || unity_ObjectToWorld[2][3] < 0 || unity_ObjectToWorld[3][3] < 0)//if decal doesn't have normal texture, use terrain normal
					result.normal.w = 0.0;//no blending
				else
					result.normal.w = 1.0;//use decal normal, might create problem because in our normal buffer, w component is alpha value used in terrain rendering

				return result;
			}
			ENDCG
		}
	}
			FallBack Off
}
