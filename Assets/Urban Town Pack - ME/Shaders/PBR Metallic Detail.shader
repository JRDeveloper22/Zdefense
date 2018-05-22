// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "FlamingSands/PBR Metallic Detail"
{
	Properties
	{
		[NoScaleOffset]_Albedo("Albedo", 2D) = "white" {}
		[NoScaleOffset]_RMA("RMA", 2D) = "white" {}
		[NoScaleOffset][Normal]_Normal("Normal", 2D) = "bump" {}
		_NormalIntensity("Normal Intensity", Float) = 1
		_Metallic("Metallic", Float) = 1
		_Glossiness("Glossiness", Float) = 1
		_AlbedoDetail("Albedo Detail", Range( 0 , 1)) = 1
		[NoScaleOffset]_DetailAlbedo("Detail Albedo", 2D) = "white" {}
		_DetailBrightness("Detail Brightness", Float) = 1
		[NoScaleOffset][Normal]_DetailNormal("Detail Normal", 2D) = "bump" {}
		_DetailNormalIntenisty("Detail Normal Intenisty", Float) = 1
		_DetailTiling("Detail Tiling", Float) = 2
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Opaque"  "Queue" = "Geometry+0" }
		Cull Back
		CGPROGRAM
		#include "UnityStandardUtils.cginc"
		#pragma target 3.0
		#pragma surface surf Standard keepalpha addshadow fullforwardshadows vertex:vertexDataFunc 
		struct Input
		{
			float2 uv_texcoord;
			float2 texcoord_0;
		};

		uniform float _NormalIntensity;
		uniform sampler2D _Normal;
		uniform float _DetailNormalIntenisty;
		uniform sampler2D _DetailNormal;
		uniform float _DetailTiling;
		uniform sampler2D _Albedo;
		uniform sampler2D _DetailAlbedo;
		uniform float _DetailBrightness;
		uniform float _AlbedoDetail;
		uniform sampler2D _RMA;
		uniform float _Metallic;
		uniform float _Glossiness;

		void vertexDataFunc( inout appdata_full v, out Input o )
		{
			UNITY_INITIALIZE_OUTPUT( Input, o );
			float2 temp_cast_0 = (_DetailTiling).xx;
			o.texcoord_0.xy = v.texcoord.xy * temp_cast_0 + float2( 0,0 );
		}

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float2 uv_Normal = i.uv_texcoord;
			o.Normal = BlendNormals( UnpackScaleNormal( tex2D( _Normal, uv_Normal ) ,_NormalIntensity ) , UnpackScaleNormal( tex2D( _DetailNormal, i.texcoord_0 ) ,_DetailNormalIntenisty ) );
			float2 uv_Albedo = i.uv_texcoord;
			float4 tex2DNode1 = tex2D( _Albedo, uv_Albedo );
			float clampResult31 = clamp( ( tex2D( _DetailAlbedo, i.texcoord_0 ).b * _DetailBrightness ) , 0.0 , 1.0 );
			float4 blendOpSrc25 = tex2DNode1;
			float blendOpDest25 = clampResult31;
			float4 lerpResult26 = lerp( tex2DNode1 , ( saturate( ( blendOpSrc25 * blendOpDest25 ) )) , _AlbedoDetail);
			o.Albedo = lerpResult26.rgb;
			float2 uv_RMA = i.uv_texcoord;
			float4 tex2DNode32 = tex2D( _RMA, uv_RMA );
			o.Metallic = ( tex2DNode32.g * _Metallic );
			o.Smoothness = ( tex2DNode32.r * _Glossiness );
			o.Occlusion = tex2DNode32.b;
			o.Alpha = 1;
		}

		ENDCG
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=13701
0;92;1173;926;1406.454;93.38727;1;True;False
Node;AmplifyShaderEditor.RangedFloatNode;37;-1741.031,278.3176;Float;False;Property;_DetailTiling;Detail Tiling;11;0;2;0;0;0;1;FLOAT
Node;AmplifyShaderEditor.TextureCoordinatesNode;29;-1520,320;Float;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;FLOAT;FLOAT;FLOAT;FLOAT
Node;AmplifyShaderEditor.SamplerNode;20;-928,-370.8273;Float;True;Property;_DetailAlbedo;Detail Albedo;7;1;[NoScaleOffset];None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;1.0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1.0;False;5;COLOR;FLOAT;FLOAT;FLOAT;FLOAT
Node;AmplifyShaderEditor.RangedFloatNode;22;-896,-176;Float;False;Property;_DetailBrightness;Detail Brightness;8;0;1;0;0;0;1;FLOAT
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;21;-528,-224;Float;False;2;2;0;FLOAT;0.0;False;1;FLOAT;0.0;False;1;FLOAT
Node;AmplifyShaderEditor.RangedFloatNode;19;-1248,528;Float;False;Property;_DetailNormalIntenisty;Detail Normal Intenisty;10;0;1;0;0;0;1;FLOAT
Node;AmplifyShaderEditor.SamplerNode;1;-928,-560;Float;True;Property;_Albedo;Albedo;0;1;[NoScaleOffset];None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;1.0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1.0;False;5;COLOR;FLOAT;FLOAT;FLOAT;FLOAT
Node;AmplifyShaderEditor.RangedFloatNode;9;-1184,336;Float;False;Property;_NormalIntensity;Normal Intensity;3;0;1;0;0;0;1;FLOAT
Node;AmplifyShaderEditor.ClampOpNode;31;-320,-160;Float;False;3;0;FLOAT;0.0;False;1;FLOAT;0.0;False;2;FLOAT;1.0;False;1;FLOAT
Node;AmplifyShaderEditor.RangedFloatNode;13;-896,112;Float;False;Property;_Glossiness;Glossiness;5;0;1;0;0;0;1;FLOAT
Node;AmplifyShaderEditor.SamplerNode;17;-897,496;Float;True;Property;_DetailNormal;Detail Normal;9;2;[NoScaleOffset];[Normal];None;True;0;True;bump;Auto;True;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;1.0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1.0;False;5;FLOAT3;FLOAT;FLOAT;FLOAT;FLOAT
Node;AmplifyShaderEditor.SamplerNode;7;-896,304;Float;True;Property;_Normal;Normal;2;2;[NoScaleOffset];[Normal];None;True;0;True;bump;Auto;True;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;1.0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1.0;False;5;FLOAT3;FLOAT;FLOAT;FLOAT;FLOAT
Node;AmplifyShaderEditor.RangedFloatNode;2;-896,192;Float;False;Property;_Metallic;Metallic;4;0;1;0;0;0;1;FLOAT
Node;AmplifyShaderEditor.RangedFloatNode;27;-192,-240;Float;False;Property;_AlbedoDetail;Albedo Detail;6;0;1;0;1;0;1;FLOAT
Node;AmplifyShaderEditor.BlendOpsNode;25;-96,-160;Float;False;Multiply;True;2;0;COLOR;0,0,0,0;False;1;FLOAT;0,0,0,0;False;1;COLOR
Node;AmplifyShaderEditor.SamplerNode;32;-944,-96;Float;True;Property;_RMA;RMA;1;1;[NoScaleOffset];None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;1.0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1.0;False;5;COLOR;FLOAT;FLOAT;FLOAT;FLOAT
Node;AmplifyShaderEditor.BlendNormalsNode;18;-384,320;Float;False;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT3
Node;AmplifyShaderEditor.LerpOp;26;208.2974,-235.0002;Float;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0.0,0,0,0;False;1;COLOR
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;12;-387,91;Float;False;2;2;0;FLOAT;0.0;False;1;FLOAT;0.0;False;1;FLOAT
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;33;-384,192;Float;False;2;2;0;FLOAT;0.0;False;1;FLOAT;0.0;False;1;FLOAT
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;410,-16;Float;False;True;2;Float;ASEMaterialInspector;0;0;Standard;FlamingSands/PBR Metallic Detail;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;0;False;0;0;Opaque;0.5;True;True;0;False;Opaque;Geometry;All;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;False;0;255;255;0;0;0;0;0;0;0;0;False;0;4;10;25;False;0.5;True;0;Zero;Zero;0;Zero;Zero;Add;Add;0;False;0;0,0,0,0;VertexOffset;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;0;0;False;15;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0.0;False;4;FLOAT;0.0;False;5;FLOAT;0.0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0.0;False;9;FLOAT;0.0;False;10;FLOAT;0.0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;29;0;37;0
WireConnection;20;1;29;0
WireConnection;21;0;20;3
WireConnection;21;1;22;0
WireConnection;31;0;21;0
WireConnection;17;1;29;0
WireConnection;17;5;19;0
WireConnection;7;5;9;0
WireConnection;25;0;1;0
WireConnection;25;1;31;0
WireConnection;18;0;7;0
WireConnection;18;1;17;0
WireConnection;26;0;1;0
WireConnection;26;1;25;0
WireConnection;26;2;27;0
WireConnection;12;0;32;1
WireConnection;12;1;13;0
WireConnection;33;0;32;2
WireConnection;33;1;2;0
WireConnection;0;0;26;0
WireConnection;0;1;18;0
WireConnection;0;3;33;0
WireConnection;0;4;12;0
WireConnection;0;5;32;3
ASEEND*/
//CHKSM=B35A369149D4B742D188FD9E9528A10B7CFC4F82