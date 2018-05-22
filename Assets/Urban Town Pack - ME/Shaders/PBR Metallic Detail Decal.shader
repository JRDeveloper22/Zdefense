// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "FlamingSands/Decals/PBR Detail Decal"
{
	Properties
	{
		_Cutoff( "Mask Clip Value", Float ) = 0.5
		[NoScaleOffset]_Albedo("Albedo", 2D) = "white" {}
		_Glossiness("Glossiness", Float) = 1
		_Metallic("Metallic", Float) = 1
		[NoScaleOffset]_RMA("RMA", 2D) = "white" {}
		[NoScaleOffset][Normal]_Normal("Normal", 2D) = "bump" {}
		_NormalIntensity("Normal Intensity", Float) = 1
		_Tiling("Tiling", Float) = 1
		_AlbedoDetail("Albedo Detail", Range( 0 , 1)) = 1
		_DetailBrightness("Detail Brightness", Float) = 1
		[NoScaleOffset]_DetailAlbedo("Detail Albedo", 2D) = "white" {}
		_DetailTiling("Detail Tiling", Float) = 1
		[NoScaleOffset][Normal]_DetailNormal("Detail Normal", 2D) = "bump" {}
		_DetailNormalIntensity("Detail Normal Intensity", Float) = 1
		[Header(Height Blend)]
		_HeightContrast("Height Contrast", Float) = 1
		[Toggle]_InvertHeight("Invert Height", Int) = 1
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "TransparentCutout"  "Queue" = "AlphaTest+0" }
		Cull Back
		CGPROGRAM
		#include "UnityStandardUtils.cginc"
		#pragma target 3.0
		#pragma shader_feature _INVERTHEIGHT_ON
		#pragma surface surf Standard keepalpha addshadow fullforwardshadows vertex:vertexDataFunc 
		struct Input
		{
			float2 texcoord_0;
			float2 texcoord_1;
			float4 vertexColor : COLOR;
		};

		uniform float _NormalIntensity;
		uniform sampler2D _Normal;
		uniform float _Tiling;
		uniform float _DetailNormalIntensity;
		uniform sampler2D _DetailNormal;
		uniform float _DetailTiling;
		uniform sampler2D _Albedo;
		uniform float _DetailBrightness;
		uniform sampler2D _DetailAlbedo;
		uniform float _AlbedoDetail;
		uniform sampler2D _RMA;
		uniform float _Metallic;
		uniform float _Glossiness;
		uniform float _HeightContrast;
		uniform float _Cutoff = 0.5;


		float4 CalculateContrast( float contrastValue, float4 colorTarget )
		{
			float t = 0.5 * ( 1.0 - contrastValue );
			return mul( float4x4( contrastValue,0,0,t, 0,contrastValue,0,t, 0,0,contrastValue,t, 0,0,0,1 ), colorTarget );
		}

		void vertexDataFunc( inout appdata_full v, out Input o )
		{
			UNITY_INITIALIZE_OUTPUT( Input, o );
			float2 temp_cast_0 = (_Tiling).xx;
			o.texcoord_0.xy = v.texcoord.xy * temp_cast_0 + float2( 0,0 );
			float2 temp_cast_1 = (_DetailTiling).xx;
			o.texcoord_1.xy = v.texcoord.xy * temp_cast_1 + float2( 0,0 );
		}

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			o.Normal = BlendNormals( UnpackScaleNormal( tex2D( _Normal, i.texcoord_0 ) ,_NormalIntensity ) , UnpackScaleNormal( tex2D( _DetailNormal, i.texcoord_1 ) ,_DetailNormalIntensity ) );
			float4 tex2DNode1 = tex2D( _Albedo, i.texcoord_0 );
			float clampResult83 = clamp( ( _DetailBrightness * tex2D( _DetailAlbedo, i.texcoord_1 ).b ) , 0.0 , 1.0 );
			float4 lerpResult85 = lerp( tex2DNode1 , ( clampResult83 * tex2DNode1 ) , _AlbedoDetail);
			o.Albedo = lerpResult85.rgb;
			float4 tex2DNode32 = tex2D( _RMA, i.texcoord_0 );
			o.Metallic = ( tex2DNode32.g * _Metallic );
			o.Smoothness = ( tex2DNode32.r * _Glossiness );
			o.Occlusion = tex2DNode32.b;
			o.Alpha = 1;
			float temp_output_15_0_g1 = tex2DNode32.a;
			#ifdef _INVERTHEIGHT_ON
				float staticSwitch19_g1 = temp_output_15_0_g1;
			#else
				float staticSwitch19_g1 = ( 1.0 - temp_output_15_0_g1 );
			#endif
			float clampResult8_g1 = clamp( ( ( staticSwitch19_g1 - 1.0 ) + ( i.vertexColor.r * 2.0 ) ) , 0.0 , 1.0 );
			float4 temp_cast_1 = (clampResult8_g1).xxxx;
			float4 clampResult10_g1 = clamp( CalculateContrast(_HeightContrast,temp_cast_1) , float4( 0,0,0,0 ) , float4( 1,0,0,0 ) );
			clip( (clampResult10_g1).r - _Cutoff );
		}

		ENDCG
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=13701
0;92;1173;926;1824.57;389.2159;1.326774;True;False
Node;AmplifyShaderEditor.RangedFloatNode;91;-1826.813,-30.11383;Float;False;Property;_DetailTiling;Detail Tiling;11;0;1;0;0;0;1;FLOAT
Node;AmplifyShaderEditor.TextureCoordinatesNode;90;-1593.212,-74.91388;Float;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;FLOAT;FLOAT;FLOAT;FLOAT
Node;AmplifyShaderEditor.RangedFloatNode;76;-3282.4,-333.6;Float;False;Property;_Tiling;Tiling;7;0;1;0;0;0;1;FLOAT
Node;AmplifyShaderEditor.RangedFloatNode;81;-960,-592;Float;False;Property;_DetailBrightness;Detail Brightness;9;0;1;0;0;0;1;FLOAT
Node;AmplifyShaderEditor.SamplerNode;79;-960,-512;Float;True;Property;_DetailAlbedo;Detail Albedo;10;1;[NoScaleOffset];None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;1.0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1.0;False;5;COLOR;FLOAT;FLOAT;FLOAT;FLOAT
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;82;-517.912,-532.8127;Float;False;2;2;0;FLOAT;0.0;False;1;FLOAT;0.0;False;1;FLOAT
Node;AmplifyShaderEditor.TextureCoordinatesNode;29;-3042.4,-269.6;Float;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;FLOAT;FLOAT;FLOAT;FLOAT
Node;AmplifyShaderEditor.RangedFloatNode;89;-1281,511;Float;False;Property;_DetailNormalIntensity;Detail Normal Intensity;13;0;1;0;0;0;1;FLOAT
Node;AmplifyShaderEditor.RangedFloatNode;9;-1280,303;Float;False;Property;_NormalIntensity;Normal Intensity;6;0;1;0;0;0;1;FLOAT
Node;AmplifyShaderEditor.SamplerNode;1;-960,-320;Float;True;Property;_Albedo;Albedo;1;1;[NoScaleOffset];None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;1.0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1.0;False;5;COLOR;FLOAT;FLOAT;FLOAT;FLOAT
Node;AmplifyShaderEditor.ClampOpNode;83;-288,-544;Float;False;3;0;FLOAT;0.0;False;1;FLOAT;0.0;False;2;FLOAT;1.0;False;1;FLOAT
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;84;-27.91199,-457.8127;Float;False;2;2;0;FLOAT;0.0;False;1;COLOR;0;False;1;COLOR
Node;AmplifyShaderEditor.RangedFloatNode;13;-896,80;Float;False;Property;_Glossiness;Glossiness;2;0;1;0;0;0;1;FLOAT
Node;AmplifyShaderEditor.SamplerNode;80;-960,448;Float;True;Property;_DetailNormal;Detail Normal;12;2;[NoScaleOffset];[Normal];None;True;0;True;bump;Auto;True;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;1.0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1.0;False;5;FLOAT3;FLOAT;FLOAT;FLOAT;FLOAT
Node;AmplifyShaderEditor.SamplerNode;7;-958.851,256;Float;True;Property;_Normal;Normal;5;2;[NoScaleOffset];[Normal];None;True;0;True;bump;Auto;True;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;1.0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1.0;False;5;FLOAT3;FLOAT;FLOAT;FLOAT;FLOAT
Node;AmplifyShaderEditor.SamplerNode;32;-960,-128;Float;True;Property;_RMA;RMA;4;1;[NoScaleOffset];None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;1.0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1.0;False;5;COLOR;FLOAT;FLOAT;FLOAT;FLOAT
Node;AmplifyShaderEditor.RangedFloatNode;2;-896,160;Float;False;Property;_Metallic;Metallic;3;0;1;0;0;0;1;FLOAT
Node;AmplifyShaderEditor.VertexColorNode;37;-1920,-784;Float;False;0;5;COLOR;FLOAT;FLOAT;FLOAT;FLOAT
Node;AmplifyShaderEditor.RangedFloatNode;86;-118.912,-630.8127;Float;False;Property;_AlbedoDetail;Albedo Detail;8;0;1;0;1;0;1;FLOAT
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;33;-384,192;Float;False;2;2;0;FLOAT;0.0;False;1;FLOAT;0.0;False;1;FLOAT
Node;AmplifyShaderEditor.FunctionNode;92;-785.0583,-1022.898;Float;False;Height Blend;14;;1;2;0;FLOAT;0.0;False;1;FLOAT;0.0;False;1;FLOAT
Node;AmplifyShaderEditor.LerpOp;85;229.088,-552.8127;Float;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0.0,0,0,0;False;2;FLOAT;0.0,0,0,0;False;1;COLOR
Node;AmplifyShaderEditor.BlendNormalsNode;87;-256,304;Float;False;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT3
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;12;-387,91;Float;False;2;2;0;FLOAT;0.0;False;1;FLOAT;0.0;False;1;FLOAT
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;640,-256;Float;False;True;2;Float;ASEMaterialInspector;0;0;Standard;FlamingSands/Decals/PBR Detail Decal;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;0;False;0;0;Masked;0.5;True;True;0;False;TransparentCutout;AlphaTest;All;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;False;0;255;255;0;0;0;0;0;0;0;0;False;0;4;10;25;False;0.5;True;0;Zero;Zero;0;Zero;Zero;Add;Add;0;False;0;0,0,0,0;VertexOffset;False;Cylindrical;False;Relative;0;;0;-1;-1;-1;0;0;0;False;15;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0.0;False;4;FLOAT;0.0;False;5;FLOAT;0.0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0.0;False;9;FLOAT;0.0;False;10;FLOAT;0.0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;90;0;91;0
WireConnection;79;1;90;0
WireConnection;82;0;81;0
WireConnection;82;1;79;3
WireConnection;29;0;76;0
WireConnection;1;1;29;0
WireConnection;83;0;82;0
WireConnection;84;0;83;0
WireConnection;84;1;1;0
WireConnection;80;1;90;0
WireConnection;80;5;89;0
WireConnection;7;1;29;0
WireConnection;7;5;9;0
WireConnection;32;1;29;0
WireConnection;33;0;32;2
WireConnection;33;1;2;0
WireConnection;92;0;32;4
WireConnection;92;1;37;1
WireConnection;85;0;1;0
WireConnection;85;1;84;0
WireConnection;85;2;86;0
WireConnection;87;0;7;0
WireConnection;87;1;80;0
WireConnection;12;0;32;1
WireConnection;12;1;13;0
WireConnection;0;0;85;0
WireConnection;0;1;87;0
WireConnection;0;3;33;0
WireConnection;0;4;12;0
WireConnection;0;5;32;3
WireConnection;0;10;92;0
ASEEND*/
//CHKSM=19D87EAEBA8D4AB3A310A914E43C5E2B7B5F376E