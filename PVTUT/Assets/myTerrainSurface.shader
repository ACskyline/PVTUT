Shader "Custom/myTerrainSurface" {
	Properties{
		[HideInInspector]_TextureArray_0("Texture Array 0", 2DArray) = "" {}
		[HideInInspector]_TextureArray_1("Texture Array 1", 2DArray) = "" {}
		[HideInInspector]_TextureArray_2("Texture Array 2", 2DArray) = "" {}
		[HideInInspector]_TextureArray_3("Texture Array 3", 2DArray) = "" {}
		[HideInInspector]_TextureArray_4("Texture Array 4", 2DArray) = "" {}
		[HideInInspector]_TextureArray_5("Texture Array 5", 2DArray) = "" {}
		[HideInInspector]_TextureArray_6("Texture Array 6", 2DArray) = "" {}
		[HideInInspector]_NormalArray_0("Normal Array 0", 2DArray) = "" {}
		[HideInInspector]_NormalArray_1("Normal Array 1", 2DArray) = "" {}
		[HideInInspector]_NormalArray_2("Normal Array 2", 2DArray) = "" {}
		[HideInInspector]_NormalArray_3("Normal Array 3", 2DArray) = "" {}
		[HideInInspector]_NormalArray_4("Normal Array 4", 2DArray) = "" {}
		[HideInInspector]_NormalArray_5("Normal Array 5", 2DArray) = "" {}
		[HideInInspector]_NormalArray_6("Normal Array 6", 2DArray) = "" {}
		[HideInInspector]_PageMipLevelTable_0("Page Mip Level Table 0", 2D) = "black" {}
		[HideInInspector]_PageMipLevelTable_1("Page Mip Level Table 1", 2D) = "black" {}
		[HideInInspector]_PageMipLevelTable_2("Page Mip Level Table 2", 2D) = "black" {}
		[HideInInspector]_PageMipLevelTable_3("Page Mip Level Table 3", 2D) = "black" {}
		[HideInInspector]_PageMipLevelTable_4("Page Mip Level Table 4", 2D) = "black" {}
		[HideInInspector]_PageMipLevelTable_5("Page Mip Level Table 5", 2D) = "black" {}
		[HideInInspector]_PageMipLevelTable_6("Page Mip Level Table 6", 2D) = "black" {}
		[HideInInspector]_TerrainSizeX("Terrain Size X", Float) = 1	
		[HideInInspector]_TerrainSizeZ("Terrain Size Z", Float) = 1
		[HideInInspector]_TerrainCountX("Terrain Count X", Int) = 1
		[HideInInspector]_TerrainCountZ("Terrain Count Z", Int) = 1
		[HideInInspector]_TileCount_2("Tile Count 2", Int) = 1
		[HideInInspector]_TileCount_3("Tile Count 3", Int) = 1
		[HideInInspector]_TileCount_4("Tile Count 4", Int) = 1
		[HideInInspector]_TileCount_5("Tile Count 5", Int) = 1
		[HideInInspector]_TileCount_6("Tile Count 6", Int) = 1
		[HideInInspector]_PageTableTileCountX_0("PageTableTileCountX_0", Int) = 1
		[HideInInspector]_PageTableTileCountX_1("PageTableTileCountX_1", Int) = 1
		[HideInInspector]_PageTableTileCountX_2("PageTableTileCountX_2", Int) = 1
		[HideInInspector]_PageTableTileCountX_3("PageTableTileCountX_3", Int) = 1
		[HideInInspector]_PageTableTileCountX_4("PageTableTileCountX_4", Int) = 1
		[HideInInspector]_PageTableTileCountX_5("PageTableTileCountX_5", Int) = 1
		[HideInInspector]_PageTableTileCountX_6("PageTableTileCountX_6", Int) = 1
		[HideInInspector]_PageTableTileCountY_0("PageTableTileCountY_0", Int) = 1
		[HideInInspector]_PageTableTileCountY_1("PageTableTileCountY_1", Int) = 1
		[HideInInspector]_PageTableTileCountY_2("PageTableTileCountY_2", Int) = 1
		[HideInInspector]_PageTableTileCountY_3("PageTableTileCountY_3", Int) = 1
		[HideInInspector]_PageTableTileCountY_4("PageTableTileCountY_4", Int) = 1
		[HideInInspector]_PageTableTileCountY_5("PageTableTileCountY_5", Int) = 1
		[HideInInspector]_PageTableTileCountY_6("PageTableTileCountY_6", Int) = 1
		[HideInInspector]_BorderScaleX("BorderScaleX", Float) = 1
		[HideInInspector]_BorderScaleY("BorderScaleY", Float) = 1
		[HideInInspector]_MipScale_0("MipScale 0", Float) = 1
		[HideInInspector]_MipScale_1("MipScale 1", Float) = 1
		[HideInInspector]_MipScale_2("MipScale 2", Float) = 1
		[HideInInspector]_MipScale_3("MipScale 3", Float) = 1
		[HideInInspector]_MipScale_4("MipScale 4", Float) = 1
		[HideInInspector]_MipScale_5("MipScale 5", Float) = 1
		[HideInInspector]_MipScale_6("MipScale 6", Float) = 1
		[HideInInspector]_MipLevelMax("MipLevelMax", Int) = 0
		[HideInInspector]_SectorCountX("SectorCountX", Int) = 1
		[HideInInspector]_SectorCountY("SectorCountY", Int) = 1
		[HideInInspector]_PageTableTileCountX("PageTableTileCountX", Int) = 1
		[HideInInspector]_PageTableTileCountY("PageTableTileCountY", Int) = 1
		[HideInInspector]_CurrentSectorX("CurrentSectorX", Int) = 0
		[HideInInspector]_CurrentSectorY("CurrentSectorY", Int) = 0
		[HideInInspector]_TileCount("TileCount", Int) = 1
		[HideInInspector]_MipIncrement("MipIncrement", Int) = 1
		[HideInInspector]_MipInitial("MipInitial", Int) = 1
		[HideInInspector]_MipDifference("MipDifference", Int) = 1
		[HideInInspector]_DebugMode("DebugMode", Int) = 0
		[HideInInspector]_DebugArrayArrayIndex("DebugArrayArrayIndex", Int) = 0
		[HideInInspector]_DebugArrayIndex("DebugArrayIndex", Int) = 0
		[HideInInspector]_DebugShowNormal("DebugShowNormal", Int) = 0
	}
		SubShader{
			Tags {
				"Queue" = "Geometry-100"
				"RenderType" = "Opaque"
			}
			LOD 200

			CGPROGRAM
		//Since we modified vertex shader, need addshadow to render to shadow map, or we can use the fall back pass
		#pragma surface surf Standard vertex:MyVert fullforwardshadows noinstancing addshadow noforwardadd

		#pragma target 3.5

		#include "UnityCG.cginc"
		#include "HLSLSupport.cginc"

		#if defined(SHADER_API_D3D11) || defined(SHADER_API_GLCORE)
			#define MY_SAMPLE_TEX2DARRAY_GRAD(tex,coord,dx,dy) tex.SampleGrad (sampler##tex,coord,dx,dy)
			#define MY_SAMPLE_TEX2DARRAY_GRAD_SAMPLER(tex,samplertex,coord,dx,dy) tex.SampleGrad(sampler##samplertex,coord,dx,dy)
		#else
			// Just match the type i.e. define as a float4 vector
			#define MY_SAMPLE_TEX2DARRAY_GRAD(tex,coord,dx,dy) float4(0,0,0,0)
			#define MY_SAMPLE_TEX2DARRAY_GRAD_SAMPLER(tex,samplertex,coord,dx,dy) float4(0,0,0,0)
		#endif


	sampler2D _PageMipLevelTable_0;
	sampler2D _PageMipLevelTable_1;
	sampler2D _PageMipLevelTable_2;
	sampler2D _PageMipLevelTable_3;
	sampler2D _PageMipLevelTable_4;
	sampler2D _PageMipLevelTable_5;
	sampler2D _PageMipLevelTable_6;

	UNITY_DECLARE_TEX2DARRAY(_TextureArray_0);
	UNITY_DECLARE_TEX2DARRAY_NOSAMPLER(_TextureArray_1);
	UNITY_DECLARE_TEX2DARRAY_NOSAMPLER(_TextureArray_2);
	UNITY_DECLARE_TEX2DARRAY_NOSAMPLER(_TextureArray_3);
	UNITY_DECLARE_TEX2DARRAY_NOSAMPLER(_TextureArray_4);
	UNITY_DECLARE_TEX2DARRAY_NOSAMPLER(_TextureArray_5);
	UNITY_DECLARE_TEX2DARRAY_NOSAMPLER(_TextureArray_6);
	UNITY_DECLARE_TEX2DARRAY(_NormalArray_0);
	UNITY_DECLARE_TEX2DARRAY_NOSAMPLER(_NormalArray_1);
	UNITY_DECLARE_TEX2DARRAY_NOSAMPLER(_NormalArray_2);
	UNITY_DECLARE_TEX2DARRAY_NOSAMPLER(_NormalArray_3);
	UNITY_DECLARE_TEX2DARRAY_NOSAMPLER(_NormalArray_4);
	UNITY_DECLARE_TEX2DARRAY_NOSAMPLER(_NormalArray_5);
	UNITY_DECLARE_TEX2DARRAY_NOSAMPLER(_NormalArray_6);

	float _TerrainSizeX;
	float _TerrainSizeZ;
	uint _TerrainCountX;
	uint _TerrainCountZ;

	uint _TileCount_0;
	uint _TileCount_1;
	uint _TileCount_2;
	uint _TileCount_3;
	uint _TileCount_4;
	uint _TileCount_5;
	uint _TileCount_6;

	uint _PageTableTileCountX_0;
	uint _PageTableTileCountX_1;
	uint _PageTableTileCountX_2;
	uint _PageTableTileCountX_3;
	uint _PageTableTileCountX_4;
	uint _PageTableTileCountX_5;
	uint _PageTableTileCountX_6;

	uint _PageTableTileCountY_0;
	uint _PageTableTileCountY_1;
	uint _PageTableTileCountY_2;
	uint _PageTableTileCountY_3;
	uint _PageTableTileCountY_4;
	uint _PageTableTileCountY_5;
	uint _PageTableTileCountY_6;

	float _BorderScaleX;
	float _BorderScaleY;

	float _MipScale_0;
	float _MipScale_1;
	float _MipScale_2;
	float _MipScale_3;
	float _MipScale_4;
	float _MipScale_5;
	float _MipScale_6;

	uint _MipLevelMax;
	uint _SectorCountX;
	uint _SectorCountY;
	uint _CurrentSectorX;
	uint _CurrentSectorY;
	uint _PageTableTileCountX;
	uint _PageTableTileCountY;
	uint _MipIncrement;
	uint _MipInitial;
	uint _MipDifference;
	uint _TileCount;
	uint _DebugMode;
	uint _DebugArrayArrayIndex;
	uint _DebugArrayIndex;
	uint _DebugShowNormal;

		struct Input {
			float2 notUV : TEXCOORD0;
		};


		float4 samplePageMipLevelTable(float2 uv, uint mipLevel)
		{
			float4 pageMipLevelTableValue = float4(0, 0, 0, 1);

			if (mipLevel == 0)
			{
				uint2 uvUINT = uint2(uv.x * _PageTableTileCountX_0, uv.y * _PageTableTileCountY_0) % uint2(64, 64);
				uv = float2(float(uvUINT.x) / 64.0, float(uvUINT.y) / 64.0);
				pageMipLevelTableValue = tex2D(_PageMipLevelTable_0, uv);
			}
			else if (mipLevel == 1)
			{
				uint2 uvUINT = uint2(uv.x * _PageTableTileCountX_1, uv.y * _PageTableTileCountY_1) % uint2(64, 64);
				uv = float2(float(uvUINT.x) / 64.0, float(uvUINT.y) / 64.0);
				pageMipLevelTableValue = tex2D(_PageMipLevelTable_1, uv);
			}
			else if (mipLevel == 2)
			{
				uint2 uvUINT = uint2(uv.x * _PageTableTileCountX_2, uv.y * _PageTableTileCountY_2) % uint2(64, 64);
				uv = float2(float(uvUINT.x) / 64.0, float(uvUINT.y) / 64.0);
				pageMipLevelTableValue = tex2D(_PageMipLevelTable_2, uv);
			}
			else if (mipLevel == 3)
			{
				uint2 uvUINT = uint2(uv.x * _PageTableTileCountX_3, uv.y * _PageTableTileCountY_3) % uint2(64, 64);
				uv = float2(float(uvUINT.x) / 64.0, float(uvUINT.y) / 64.0);
				pageMipLevelTableValue = tex2D(_PageMipLevelTable_3, uv);
			}
			else if (mipLevel == 4)
			{
				uint2 uvUINT = uint2(uv.x * _PageTableTileCountX_4, uv.y * _PageTableTileCountY_4) % uint2(64, 64);
				uv = float2(float(uvUINT.x) / 64.0, float(uvUINT.y) / 64.0);
				pageMipLevelTableValue = tex2D(_PageMipLevelTable_4, uv);
			}
			else if (mipLevel == 5)
			{
				uint2 uvUINT = uint2(uv.x * _PageTableTileCountX_5, uv.y * _PageTableTileCountY_5) % uint2(64, 64);
				uv = float2(float(uvUINT.x) / 64.0, float(uvUINT.y) / 64.0);
				pageMipLevelTableValue = tex2D(_PageMipLevelTable_5, uv);
			}
			else if (mipLevel == 6)
			{
				uint2 uvUINT = uint2(uv.x * _PageTableTileCountX_6, uv.y * _PageTableTileCountY_6) % uint2(64, 64);
				uv = float2(float(uvUINT.x) / 64.0, float(uvUINT.y) / 64.0);
				pageMipLevelTableValue = tex2D(_PageMipLevelTable_6, uv);
			}

			return pageMipLevelTableValue;
		}

		float4 sampleNormalArrayMipLevel(float2 uv, uint mipLevel)
		{
			float4 result = float4(0, 0, 0, 1);
			float4 pageMipLevelTableValue = samplePageMipLevelTable(uv, mipLevel);
			if (pageMipLevelTableValue.w < 0.5)
			{
				mipLevel = _MipLevelMax;
				pageMipLevelTableValue = samplePageMipLevelTable(uv, mipLevel);
			}

			if (mipLevel == 0)
			{
				float3 uvw = float3((uv.x - pageMipLevelTableValue.x) * _PageTableTileCountX_0 * (1.0 - 2.0*_BorderScaleX) + _BorderScaleX,
					(uv.y - pageMipLevelTableValue.y) * _PageTableTileCountY_0 * (1.0 - 2.0*_BorderScaleY) + _BorderScaleY,
					pageMipLevelTableValue.z * _TileCount_0);
				result = UNITY_SAMPLE_TEX2DARRAY(_NormalArray_0, uvw);
			}
			else if (mipLevel == 1)
			{
				float3 uvw = float3((uv.x - pageMipLevelTableValue.x) * _PageTableTileCountX_1 * (1.0 - 2.0*_BorderScaleX) + _BorderScaleX,
					(uv.y - pageMipLevelTableValue.y) * _PageTableTileCountY_1 * (1.0 - 2.0*_BorderScaleY) + _BorderScaleY,
					pageMipLevelTableValue.z * _TileCount_1);
				result = UNITY_SAMPLE_TEX2DARRAY_SAMPLER(_NormalArray_1, _NormalArray_0, uvw);
			}
			else if (mipLevel == 2)
			{
				float3 uvw = float3((uv.x - pageMipLevelTableValue.x) * _PageTableTileCountX_2 * (1.0 - 2.0*_BorderScaleX) + _BorderScaleX,
					(uv.y - pageMipLevelTableValue.y) * _PageTableTileCountY_2 * (1.0 - 2.0*_BorderScaleY) + _BorderScaleY,
					pageMipLevelTableValue.z * _TileCount_2);
				result = UNITY_SAMPLE_TEX2DARRAY_SAMPLER(_NormalArray_2, _NormalArray_0, uvw);
			}
			else if (mipLevel == 3)
			{
				float3 uvw = float3((uv.x - pageMipLevelTableValue.x) * _PageTableTileCountX_3 * (1.0 - 2.0*_BorderScaleX) + _BorderScaleX,
					(uv.y - pageMipLevelTableValue.y) * _PageTableTileCountY_3 * (1.0 - 2.0*_BorderScaleY) + _BorderScaleY,
					pageMipLevelTableValue.z * _TileCount_3);
				result = UNITY_SAMPLE_TEX2DARRAY_SAMPLER(_NormalArray_3, _NormalArray_0, uvw);
			}
			else if (mipLevel == 4)
			{
				float3 uvw = float3((uv.x - pageMipLevelTableValue.x) * _PageTableTileCountX_4 * (1.0 - 2.0*_BorderScaleX) + _BorderScaleX,
					(uv.y - pageMipLevelTableValue.y) * _PageTableTileCountY_4 * (1.0 - 2.0*_BorderScaleY) + _BorderScaleY,
					pageMipLevelTableValue.z * _TileCount_4);
				result = UNITY_SAMPLE_TEX2DARRAY_SAMPLER(_NormalArray_4, _NormalArray_0, uvw);
			}
			else if (mipLevel == 5)
			{
				float3 uvw = float3((uv.x - pageMipLevelTableValue.x) * _PageTableTileCountX_5 * (1.0 - 2.0*_BorderScaleX) + _BorderScaleX,
					(uv.y - pageMipLevelTableValue.y) * _PageTableTileCountY_5 * (1.0 - 2.0*_BorderScaleY) + _BorderScaleY,
					pageMipLevelTableValue.z * _TileCount_5);
				result = UNITY_SAMPLE_TEX2DARRAY_SAMPLER(_NormalArray_5, _NormalArray_0, uvw);
			}
			else if (mipLevel == 6)
			{
				float3 uvw = float3((uv.x - pageMipLevelTableValue.x) * _PageTableTileCountX_6 * (1.0 - 2.0*_BorderScaleX) + _BorderScaleX,
					(uv.y - pageMipLevelTableValue.y) * _PageTableTileCountY_6 * (1.0 - 2.0*_BorderScaleY) + _BorderScaleY,
					pageMipLevelTableValue.z * _TileCount_6);
				result = UNITY_SAMPLE_TEX2DARRAY_SAMPLER(_NormalArray_6, _NormalArray_0, uvw);
			}

			return result;
		}

		float4 sampleTextureArrayMipLevel(float2 uv, uint mipLevel)
		{
			float4 result = float4(0, 0, 0, 1);
			float4 pageMipLevelTableValue = samplePageMipLevelTable(uv, mipLevel);
			if (pageMipLevelTableValue.w < 0.5)
			{
				return float4(1, 0, 0, 1);
				mipLevel = _MipLevelMax;
				pageMipLevelTableValue = samplePageMipLevelTable(uv, mipLevel);
				if (pageMipLevelTableValue.w < 0.5)
				{
					return float4(0, 0, 1, 1);
				}
			}

			if (mipLevel == 0)
			{
				float3 uvw = float3((uv.x - pageMipLevelTableValue.x) * _PageTableTileCountX_0 * (1.0 - 2.0*_BorderScaleX) + _BorderScaleX,
					(uv.y - pageMipLevelTableValue.y) * _PageTableTileCountY_0 * (1.0 - 2.0*_BorderScaleY) + _BorderScaleY,
					pageMipLevelTableValue.z * _TileCount_0);
				result = UNITY_SAMPLE_TEX2DARRAY(_TextureArray_0, uvw);
			}
			else if (mipLevel == 1)
			{
				float3 uvw = float3((uv.x - pageMipLevelTableValue.x) * _PageTableTileCountX_1 * (1.0 - 2.0*_BorderScaleX) + _BorderScaleX,
					(uv.y - pageMipLevelTableValue.y) * _PageTableTileCountY_1 * (1.0 - 2.0*_BorderScaleY) + _BorderScaleY,
					pageMipLevelTableValue.z * _TileCount_1);
				result = UNITY_SAMPLE_TEX2DARRAY_SAMPLER(_TextureArray_1, _TextureArray_0, uvw);
			}
			else if (mipLevel == 2)
			{
				float3 uvw = float3((uv.x - pageMipLevelTableValue.x) * _PageTableTileCountX_2 * (1.0 - 2.0*_BorderScaleX) + _BorderScaleX,
					(uv.y - pageMipLevelTableValue.y) * _PageTableTileCountY_2 * (1.0 - 2.0*_BorderScaleY) + _BorderScaleY,
					pageMipLevelTableValue.z * _TileCount_2);
				result = UNITY_SAMPLE_TEX2DARRAY_SAMPLER(_TextureArray_2, _TextureArray_0, uvw);
			}
			else if (mipLevel == 3)
			{
				float3 uvw = float3((uv.x - pageMipLevelTableValue.x) * _PageTableTileCountX_3 * (1.0 - 2.0*_BorderScaleX) + _BorderScaleX,
					(uv.y - pageMipLevelTableValue.y) * _PageTableTileCountY_3 * (1.0 - 2.0*_BorderScaleY) + _BorderScaleY,
					pageMipLevelTableValue.z * _TileCount_3);
				result = UNITY_SAMPLE_TEX2DARRAY_SAMPLER(_TextureArray_3, _TextureArray_0, uvw);
			}
			else if (mipLevel == 4)
			{
				float3 uvw = float3((uv.x - pageMipLevelTableValue.x) * _PageTableTileCountX_4 * (1.0 - 2.0*_BorderScaleX) + _BorderScaleX,
					(uv.y - pageMipLevelTableValue.y) * _PageTableTileCountY_4 * (1.0 - 2.0*_BorderScaleY) + _BorderScaleY,
					pageMipLevelTableValue.z * _TileCount_4);
				result = UNITY_SAMPLE_TEX2DARRAY_SAMPLER(_TextureArray_4, _TextureArray_0, uvw);
			}
			else if (mipLevel == 5)
			{
				float3 uvw = float3((uv.x - pageMipLevelTableValue.x) * _PageTableTileCountX_5 * (1.0 - 2.0*_BorderScaleX) + _BorderScaleX,
					(uv.y - pageMipLevelTableValue.y) * _PageTableTileCountY_5 * (1.0 - 2.0*_BorderScaleY) + _BorderScaleY,
					pageMipLevelTableValue.z * _TileCount_5);
				result = UNITY_SAMPLE_TEX2DARRAY_SAMPLER(_TextureArray_5, _TextureArray_0, uvw);
			}
			else if (mipLevel == 6)
			{
				float3 uvw = float3((uv.x - pageMipLevelTableValue.x) * _PageTableTileCountX_6 * (1.0 - 2.0*_BorderScaleX) + _BorderScaleX,
					(uv.y - pageMipLevelTableValue.y) * _PageTableTileCountY_6 * (1.0 - 2.0*_BorderScaleY) + _BorderScaleY,
					pageMipLevelTableValue.z * _TileCount_6);
				result = UNITY_SAMPLE_TEX2DARRAY_SAMPLER(_TextureArray_6, _TextureArray_0, uvw);
			}

			return result;
		}

		float4 sampleTextureArrayMipLevelGrad(float2 uv, uint mipLevel, float2 ddxUV, float2 ddyUV)
		{
			float4 result = float4(0, 0, 0, 1);

			float4 pageMipLevelTableValue = samplePageMipLevelTable(uv, mipLevel);
			if (pageMipLevelTableValue.w < 0.5)
			{
				return float4(1, 0, 0, 1);
				mipLevel = _MipLevelMax;
				pageMipLevelTableValue = samplePageMipLevelTable(uv, mipLevel);
				if (pageMipLevelTableValue.w < 0.5)
				{
					return float4(0, 0, 1, 1);
				}
			}


			if (mipLevel == 0)
			{
				ddxUV = ddxUV * _MipScale_0 * _PageTableTileCountX / _PageTableTileCountX_0;
				ddyUV = ddyUV * _MipScale_0 * _PageTableTileCountY / _PageTableTileCountY_0;
				float3 uvNew = float3((uv.x - pageMipLevelTableValue.x) * _PageTableTileCountX_0 * (1.0 - 2.0*_BorderScaleX) + _BorderScaleX,
					(uv.y - pageMipLevelTableValue.y) * _PageTableTileCountY_0 * (1.0 - 2.0*_BorderScaleY) + _BorderScaleY,
					pageMipLevelTableValue.z * _TileCount_0);
				result = MY_SAMPLE_TEX2DARRAY_GRAD(_TextureArray_0,
					uvNew,
					ddxUV,
					ddyUV);
			}
			else if (mipLevel == 1)
			{
				ddxUV = ddxUV * _MipScale_1 * _PageTableTileCountX / _PageTableTileCountX_1;
				ddyUV = ddyUV * _MipScale_1 * _PageTableTileCountY / _PageTableTileCountY_1;
				float3 uvNew = float3((uv.x - pageMipLevelTableValue.x) * _PageTableTileCountX_1 * (1.0 - 2.0*_BorderScaleX) + _BorderScaleX,
					(uv.y - pageMipLevelTableValue.y) * _PageTableTileCountY_1 * (1.0 - 2.0*_BorderScaleY) + _BorderScaleY,
					pageMipLevelTableValue.z * _TileCount_1);
				result = MY_SAMPLE_TEX2DARRAY_GRAD_SAMPLER(_TextureArray_1,
					_TextureArray_0,
					uvNew,
					ddxUV,
					ddyUV);
			}
			else if (mipLevel == 2)
			{
				ddxUV = ddxUV * _MipScale_2 * _PageTableTileCountX / _PageTableTileCountX_2;
				ddyUV = ddyUV * _MipScale_2 * _PageTableTileCountY / _PageTableTileCountY_2;
				float3 uvNew = float3((uv.x - pageMipLevelTableValue.x) * _PageTableTileCountX_2 * (1.0 - 2.0*_BorderScaleX) + _BorderScaleX,
					(uv.y - pageMipLevelTableValue.y) * _PageTableTileCountY_2 * (1.0 - 2.0*_BorderScaleY) + _BorderScaleY,
					pageMipLevelTableValue.z * _TileCount_2);
				result = MY_SAMPLE_TEX2DARRAY_GRAD_SAMPLER(_TextureArray_2,
					_TextureArray_0,
					uvNew,
					ddxUV,
					ddyUV);
			}
			else if (mipLevel == 3)
			{
				ddxUV = ddxUV * _MipScale_3 * _PageTableTileCountX / _PageTableTileCountX_3;
				ddyUV = ddyUV * _MipScale_3 * _PageTableTileCountY / _PageTableTileCountY_3;
				float3 uvNew = float3((uv.x - pageMipLevelTableValue.x) * _PageTableTileCountX_3 * (1.0 - 2.0*_BorderScaleX) + _BorderScaleX,
					(uv.y - pageMipLevelTableValue.y) * _PageTableTileCountY_3 * (1.0 - 2.0*_BorderScaleY) + _BorderScaleY,
					pageMipLevelTableValue.z * _TileCount_3);
				result = MY_SAMPLE_TEX2DARRAY_GRAD_SAMPLER(_TextureArray_3,
					_TextureArray_0,
					uvNew,
					ddxUV,
					ddyUV);
			}
			else if (mipLevel == 4)
			{
				ddxUV = ddxUV * _MipScale_4 * _PageTableTileCountX / _PageTableTileCountX_4;
				ddyUV = ddyUV * _MipScale_4 * _PageTableTileCountY / _PageTableTileCountY_4;
				float3 uvNew = float3((uv.x - pageMipLevelTableValue.x) * _PageTableTileCountX_4 * (1.0 - 2.0*_BorderScaleX) + _BorderScaleX,
					(uv.y - pageMipLevelTableValue.y) * _PageTableTileCountY_4 * (1.0 - 2.0*_BorderScaleY) + _BorderScaleY,
					pageMipLevelTableValue.z * _TileCount_4);
				result = MY_SAMPLE_TEX2DARRAY_GRAD_SAMPLER(_TextureArray_4,
					_TextureArray_0,
					uvNew,
					ddxUV,
					ddyUV);
			}
			else if (mipLevel == 5)
			{
				ddxUV = ddxUV * _MipScale_5 * _PageTableTileCountX / _PageTableTileCountX_5;
				ddyUV = ddyUV * _MipScale_5 * _PageTableTileCountY / _PageTableTileCountY_5;
				float3 uvNew = float3((uv.x - pageMipLevelTableValue.x) * _PageTableTileCountX_5 * (1.0 - 2.0*_BorderScaleX) + _BorderScaleX,
					(uv.y - pageMipLevelTableValue.y) * _PageTableTileCountY_5 * (1.0 - 2.0*_BorderScaleY) + _BorderScaleY,
					pageMipLevelTableValue.z * _TileCount_5);
				result = MY_SAMPLE_TEX2DARRAY_GRAD_SAMPLER(_TextureArray_5,
					_TextureArray_0,
					uvNew,
					ddxUV,
					ddyUV);
			}
			else if (mipLevel == 6)
			{
				ddxUV = ddxUV * _MipScale_6 * _PageTableTileCountX / _PageTableTileCountX_6;
				ddyUV = ddyUV * _MipScale_6 * _PageTableTileCountY / _PageTableTileCountY_6;
				float3 uvNew = float3((uv.x - pageMipLevelTableValue.x) * _PageTableTileCountX_6 * (1.0 - 2.0*_BorderScaleX) + _BorderScaleX,
					(uv.y - pageMipLevelTableValue.y) * _PageTableTileCountY_6 * (1.0 - 2.0*_BorderScaleY) + _BorderScaleY,
					pageMipLevelTableValue.z * _TileCount_6);
				result = MY_SAMPLE_TEX2DARRAY_GRAD_SAMPLER(_TextureArray_6,
					_TextureArray_0,
					uvNew,
					ddxUV,
					ddyUV);
			}


			return result;
		}

		float4 sampleNormalArrayMipLevelGrad(float2 uv, uint mipLevel, float2 ddxUV, float2 ddyUV)
		{
			float4 result = float4(0, 0, 0, 1);


			float4 pageMipLevelTableValue = samplePageMipLevelTable(uv, mipLevel);

			if (pageMipLevelTableValue.w < 0.5)
			{
				mipLevel = _MipLevelMax;
				pageMipLevelTableValue = samplePageMipLevelTable(uv, mipLevel);
			}

			if (mipLevel == 0)
			{
				ddxUV = ddxUV * _MipScale_0 * _PageTableTileCountX / _PageTableTileCountX_0;
				ddyUV = ddyUV * _MipScale_0 * _PageTableTileCountY / _PageTableTileCountY_0;
				float3 uvNew = float3((uv.x - pageMipLevelTableValue.x) * _PageTableTileCountX_0 * (1.0 - 2.0*_BorderScaleX) + _BorderScaleX,
					(uv.y - pageMipLevelTableValue.y) * _PageTableTileCountY_0 * (1.0 - 2.0*_BorderScaleY) + _BorderScaleY,
					pageMipLevelTableValue.z * _TileCount_0);
				result = MY_SAMPLE_TEX2DARRAY_GRAD(_NormalArray_0,
					uvNew,
					ddxUV,
					ddyUV);
			}
			else if (mipLevel == 1)
			{
				ddxUV = ddxUV * _MipScale_1 * _PageTableTileCountX / _PageTableTileCountX_1;
				ddyUV = ddyUV * _MipScale_1 * _PageTableTileCountY / _PageTableTileCountY_1;
				float3 uvNew = float3((uv.x - pageMipLevelTableValue.x) * _PageTableTileCountX_1 * (1.0 - 2.0*_BorderScaleX) + _BorderScaleX,
					(uv.y - pageMipLevelTableValue.y) * _PageTableTileCountY_1 * (1.0 - 2.0*_BorderScaleY) + _BorderScaleY,
					pageMipLevelTableValue.z * _TileCount_1);
				result = MY_SAMPLE_TEX2DARRAY_GRAD_SAMPLER(_NormalArray_1,
					_NormalArray_0,
					uvNew,
					ddxUV,
					ddyUV);
			}
			else if (mipLevel == 2)
			{
				ddxUV = ddxUV * _MipScale_2 * _PageTableTileCountX / _PageTableTileCountX_2;
				ddyUV = ddyUV * _MipScale_2 * _PageTableTileCountY / _PageTableTileCountY_2;
				float3 uvNew = float3((uv.x - pageMipLevelTableValue.x) * _PageTableTileCountX_2 * (1.0 - 2.0*_BorderScaleX) + _BorderScaleX,
					(uv.y - pageMipLevelTableValue.y) * _PageTableTileCountY_2 * (1.0 - 2.0*_BorderScaleY) + _BorderScaleY,
					pageMipLevelTableValue.z * _TileCount_2);
				result = MY_SAMPLE_TEX2DARRAY_GRAD_SAMPLER(_NormalArray_2,
					_NormalArray_0,
					uvNew,
					ddxUV,
					ddyUV);
			}
			else if (mipLevel == 3)
			{
				ddxUV = ddxUV * _MipScale_3 * _PageTableTileCountX / _PageTableTileCountX_3;
				ddyUV = ddyUV * _MipScale_3 * _PageTableTileCountY / _PageTableTileCountY_3;
				float3 uvNew = float3((uv.x - pageMipLevelTableValue.x) * _PageTableTileCountX_3 * (1.0 - 2.0*_BorderScaleX) + _BorderScaleX,
					(uv.y - pageMipLevelTableValue.y) * _PageTableTileCountY_3 * (1.0 - 2.0*_BorderScaleY) + _BorderScaleY,
					pageMipLevelTableValue.z * _TileCount_3);
				result = MY_SAMPLE_TEX2DARRAY_GRAD_SAMPLER(_NormalArray_3,
					_NormalArray_0,
					uvNew,
					ddxUV,
					ddyUV);
			}
			else if (mipLevel == 4)
			{
				ddxUV = ddxUV * _MipScale_4 * _PageTableTileCountX / _PageTableTileCountX_4;
				ddyUV = ddyUV * _MipScale_4 * _PageTableTileCountY / _PageTableTileCountY_4;
				float3 uvNew = float3((uv.x - pageMipLevelTableValue.x) * _PageTableTileCountX_4 * (1.0 - 2.0*_BorderScaleX) + _BorderScaleX,
					(uv.y - pageMipLevelTableValue.y) * _PageTableTileCountY_4 * (1.0 - 2.0*_BorderScaleY) + _BorderScaleY,
					pageMipLevelTableValue.z * _TileCount_4);
				result = MY_SAMPLE_TEX2DARRAY_GRAD_SAMPLER(_NormalArray_4,
					_NormalArray_0,
					uvNew,
					ddxUV,
					ddyUV);
			}
			else if (mipLevel == 5)
			{
				ddxUV = ddxUV * _MipScale_5 * _PageTableTileCountX / _PageTableTileCountX_5;
				ddyUV = ddyUV * _MipScale_5 * _PageTableTileCountY / _PageTableTileCountY_5;
				float3 uvNew = float3((uv.x - pageMipLevelTableValue.x) * _PageTableTileCountX_5 * (1.0 - 2.0*_BorderScaleX) + _BorderScaleX,
					(uv.y - pageMipLevelTableValue.y) * _PageTableTileCountY_5 * (1.0 - 2.0*_BorderScaleY) + _BorderScaleY,
					pageMipLevelTableValue.z * _TileCount_5);
				result = MY_SAMPLE_TEX2DARRAY_GRAD_SAMPLER(_NormalArray_5,
					_NormalArray_0,
					uvNew,
					ddxUV,
					ddyUV);
			}
			else if (mipLevel == 6)
			{
				ddxUV = ddxUV * _MipScale_6 * _PageTableTileCountX / _PageTableTileCountX_6;
				ddyUV = ddyUV * _MipScale_6 * _PageTableTileCountY / _PageTableTileCountY_6;
				float3 uvNew = float3((uv.x - pageMipLevelTableValue.x) * _PageTableTileCountX_6 * (1.0 - 2.0*_BorderScaleX) + _BorderScaleX,
					(uv.y - pageMipLevelTableValue.y) * _PageTableTileCountY_6 * (1.0 - 2.0*_BorderScaleY) + _BorderScaleY,
					pageMipLevelTableValue.z * _TileCount_6);
				result = MY_SAMPLE_TEX2DARRAY_GRAD_SAMPLER(_NormalArray_6,
					_NormalArray_0,
					uvNew,
					ddxUV,
					ddyUV);
			}


			return result;
		}

		void MyVert(inout appdata_full v, out Input data)
		{
			UNITY_INITIALIZE_OUTPUT(Input, data);

			//uv coordinates conversion
			float4 worldPos = mul(unity_ObjectToWorld, float4(v.vertex.xyz, 1));
			data.notUV = worldPos.xz / float2(_TerrainCountX * _TerrainSizeX, _TerrainCountZ * _TerrainSizeZ);

			float4 pos = mul(UNITY_MATRIX_VP, worldPos);

			UNITY_TRANSFER_FOG(data, pos);

			v.tangent.xyz = cross(v.normal, float3(0, 0, 1));
			v.tangent.w = -1;

		}

		float S(int i)
		{
			return _MipInitial * (i + 1) + i * (i + 1) * _MipDifference / 2.0f;
		}

		void surf(Input IN, inout SurfaceOutputStandard o) {

			uint absMax = max(abs((int)_CurrentSectorX - (int)(IN.notUV.x * _SectorCountX)),
				abs((int)_CurrentSectorY - (int)(IN.notUV.y * _SectorCountY)));

			int mipLevelSign = (int)floor((-2.0f * _MipInitial - _MipDifference +
				sqrt(8.0f * _MipDifference * absMax +
				(2.0f * _MipInitial - _MipDifference) *
					(2.0f * _MipInitial - _MipDifference)))
				/ (2.0f * _MipDifference)) + 1;

			uint mipLevel = clamp(mipLevelSign, 0, _MipLevelMax);

			float4 result = float4(0.1, 0.2, 0.8, 1);
			float4 resultNormal = float4(1, 1, 1, 1);

			float2 ddxUV = ddx(IN.notUV) * uint2(_TerrainCountX, _TerrainCountZ);
			float2 ddyUV = ddy(IN.notUV) * uint2(_TerrainCountX, _TerrainCountZ);

			o.Smoothness = 0.1;
			o.Alpha = 1;
			o.Metallic = 0.1;
			o.Normal = float3(0, 0, 1);

			result = sampleTextureArrayMipLevelGrad(IN.notUV, mipLevel, ddxUV, ddyUV);
			if (mipLevel == _MipLevelMax - 1)
			{
				float4 resultPlus = sampleTextureArrayMipLevelGrad(IN.notUV, _MipLevelMax, ddxUV, ddyUV);
				float f = clamp(((absMax)-S(mipLevel - 1)) / (_MipInitial + (mipLevel)* _MipDifference), 0.0f, 1.0f);
				result = lerp(result, resultPlus, f);
			}
			resultNormal = sampleNormalArrayMipLevelGrad(IN.notUV, mipLevel, ddxUV, ddyUV);

			if (_DebugMode == 1)
			{
				result = float4(mipLevel / (float)_MipLevelMax, 0, 0, 1);
				o.Albedo = result.rgb;
			}
			else if (_DebugMode == 2)
			{
				resultNormal.z = 1 - dot(resultNormal.xy, resultNormal.xy);
				o.Albedo = resultNormal.xyz;
			}
			else if (_DebugMode == 3)
			{
				result = float4(uint(IN.notUV.x * _SectorCountX) % 2,
					uint(IN.notUV.y * _SectorCountY) % 2, 0, 1);
				o.Albedo = result.rgb;
			}
			else
			{
				o.Albedo = result.rgb;
				o.Metallic = resultNormal.z;
				o.Smoothness = result.a;
				o.Alpha = resultNormal.w;
				if (_DebugShowNormal)
				{
					resultNormal.z = 1 - dot(resultNormal.xy, resultNormal.xy);
					o.Normal = resultNormal.xyz;
				}
			}

		}
		ENDCG
	}

		FallBack "Diffuse"//keep this so that when rendering depth map for shadow, a pass in this can be used, we can also use addshadow to achieve the same goal
}
