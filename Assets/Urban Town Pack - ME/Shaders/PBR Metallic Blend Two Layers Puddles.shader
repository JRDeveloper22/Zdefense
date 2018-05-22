// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "FlamingSands/PBR Metallic Blend Two Layers Puddles"
{
	Properties
	{
		_Layer1Tiling("Layer 1 Tiling", Float) = 1
		_Layer2Tiling("Layer 2 Tiling", Float) = 1
		[NoScaleOffset]_Albedo("Albedo", 2D) = "white" {}
		_Glossiness("Glossiness", Float) = 1
		_Metallic("Metallic", Float) = 1
		[NoScaleOffset]_RMA("RMA", 2D) = "white" {}
		_NormalIntensity("Normal Intensity", Float) = 1
		[NoScaleOffset][Normal]_Normal("Normal", 2D) = "bump" {}
		[NoScaleOffset]_Albedo2("Albedo 2", 2D) = "white" {}
		[NoScaleOffset]_RMA2("RMA 2", 2D) = "white" {}
		[NoScaleOffset][Normal]_Normal2("Normal 2", 2D) = "bump" {}
		[Header(Height Blend)]
		_HeightContrast("Height Contrast", Float) = 1
		[Toggle]_InvertHeight("Invert Height", Int) = 1
		[Header(Water Puddles)]
		_WetnessColor("Wetness Color", Color) = (0.9607843,0.9607843,0.9607843,1)
		_PuddlesColorDepth("Puddles Color (Depth)", Color) = (0.2705882,0.254902,0.2078431,0.9019608)
		[Toggle]_InvertDepth("Invert Depth", Int) = 1
		_PuddlesSmoothness("Puddles Smoothness", Range( 0 , 1)) = 0.95
		[HideInInspector]_WaterNormal("Water Normal", 2D) = "bump" {}
		_WetnessSmoothness("Wetness Smoothness", Range( 0 , 1)) = 0.75
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Opaque"  "Queue" = "Geometry+0" }
		Cull Back
		CGPROGRAM
		#include "UnityStandardUtils.cginc"
		#include "UnityShaderVariables.cginc"
		#pragma target 3.0
		#pragma shader_feature _INVERTHEIGHT_ON
		#pragma shader_feature _INVERTDEPTH_ON
		#pragma surface surf Standard keepalpha addshadow fullforwardshadows vertex:vertexDataFunc 
		struct Input
		{
			float3 worldPos;
			float2 texcoord_0;
			float2 texcoord_1;
			float4 vertexColor : COLOR;
		};

		uniform sampler2D _WaterNormal;
		uniform float _NormalIntensity;
		uniform sampler2D _Normal2;
		uniform float _Layer2Tiling;
		uniform sampler2D _Normal;
		uniform float _Layer1Tiling;
		uniform float _HeightContrast;
		uniform sampler2D _RMA;
		uniform sampler2D _RMA2;
		uniform sampler2D _Albedo2;
		uniform sampler2D _Albedo;
		uniform float4 _PuddlesColorDepth;
		uniform float4 _WetnessColor;
		uniform float _Metallic;
		uniform float _PuddlesSmoothness;
		uniform float _Glossiness;
		uniform float _WetnessSmoothness;


		float4 CalculateContrast( float contrastValue, float4 colorTarget )
		{
			float t = 0.5 * ( 1.0 - contrastValue );
			return mul( float4x4( contrastValue,0,0,t, 0,contrastValue,0,t, 0,0,contrastValue,t, 0,0,0,1 ), colorTarget );
		}

		void vertexDataFunc( inout appdata_full v, out Input o )
		{
			UNITY_INITIALIZE_OUTPUT( Input, o );
			float2 temp_cast_0 = (_Layer2Tiling).xx;
			o.texcoord_0.xy = v.texcoord.xy * temp_cast_0 + float2( 0,0 );
			float2 temp_cast_1 = (_Layer1Tiling).xx;
			o.texcoord_1.xy = v.texcoord.xy * temp_cast_1 + float2( 0,0 );
		}

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float3 ase_worldPos = i.worldPos;
			float2 appendResult32_g298 = (float2(ase_worldPos.x , ase_worldPos.z));
			float2 temp_output_33_0_g298 = ( appendResult32_g298 / 2.0 );
			float2 panner30_g298 = ( temp_output_33_0_g298 + 1.0 * _Time.y * float2( 0.05,0.05 ));
			float2 panner41_g298 = ( temp_output_33_0_g298 + 1.0 * _Time.y * float2( -0.05,0 ));
			float4 tex2DNode32 = tex2D( _RMA, i.texcoord_1 );
			float temp_output_15_0_g294 = ( 1.0 - tex2DNode32.a );
			#ifdef _INVERTHEIGHT_ON
				float staticSwitch19_g294 = temp_output_15_0_g294;
			#else
				float staticSwitch19_g294 = ( 1.0 - temp_output_15_0_g294 );
			#endif
			float clampResult8_g294 = clamp( ( ( staticSwitch19_g294 - 1.0 ) + ( i.vertexColor.r * 2.0 ) ) , 0.0 , 1.0 );
			float4 temp_cast_0 = (clampResult8_g294).xxxx;
			float4 clampResult10_g294 = clamp( CalculateContrast(_HeightContrast,temp_cast_0) , float4( 0,0,0,0 ) , float4( 1,0,0,0 ) );
			float temp_output_89_0 = ( 1.0 - (clampResult10_g294).r );
			float3 lerpResult83 = lerp( UnpackScaleNormal( tex2D( _Normal2, i.texcoord_0 ) ,_NormalIntensity ) , UnpackScaleNormal( tex2D( _Normal, i.texcoord_1 ) ,_NormalIntensity ) , temp_output_89_0);
			float4 lerpResult84 = lerp( tex2D( _RMA2, i.texcoord_0 ) , tex2DNode32 , temp_output_89_0);
			float temp_output_17_0_g298 = ( 1.0 - lerpResult84.a );
			float temp_output_15_0_g299 = temp_output_17_0_g298;
			#ifdef _INVERTHEIGHT_ON
				float staticSwitch19_g299 = temp_output_15_0_g299;
			#else
				float staticSwitch19_g299 = ( 1.0 - temp_output_15_0_g299 );
			#endif
			float clampResult8_g299 = clamp( ( ( staticSwitch19_g299 - 1.0 ) + ( i.vertexColor.g * 2.0 ) ) , 0.0 , 1.0 );
			float4 temp_cast_1 = (clampResult8_g299).xxxx;
			float4 clampResult10_g299 = clamp( CalculateContrast(_HeightContrast,temp_cast_1) , float4( 0,0,0,0 ) , float4( 1,0,0,0 ) );
			float temp_output_82_0_g298 = ( 1.0 - (clampResult10_g299).r );
			float3 lerpResult8_g298 = lerp( BlendNormals( UnpackScaleNormal( tex2D( _WaterNormal, panner30_g298 ) ,0.25 ) , UnpackScaleNormal( tex2D( _WaterNormal, panner41_g298 ) ,0.25 ) ) , lerpResult83 , temp_output_82_0_g298);
			o.Normal = lerpResult8_g298;
			float4 lerpResult82 = lerp( tex2D( _Albedo2, i.texcoord_0 ) , tex2D( _Albedo, i.texcoord_1 ) , temp_output_89_0);
			float4 temp_output_20_0_g298 = lerpResult82;
			#ifdef _INVERTDEPTH_ON
				float staticSwitch90_g298 = ( 1.0 - temp_output_17_0_g298 );
			#else
				float staticSwitch90_g298 = temp_output_17_0_g298;
			#endif
			float clampResult75_g298 = clamp( ( staticSwitch90_g298 + _PuddlesColorDepth.a ) , 0.0 , 1.0 );
			float4 lerpResult4_g298 = lerp( temp_output_20_0_g298 , _PuddlesColorDepth , clampResult75_g298);
			float4 lerpResult6_g298 = lerp( lerpResult4_g298 , temp_output_20_0_g298 , temp_output_82_0_g298);
			float temp_output_15_0_g300 = temp_output_17_0_g298;
			#ifdef _INVERTHEIGHT_ON
				float staticSwitch19_g300 = temp_output_15_0_g300;
			#else
				float staticSwitch19_g300 = ( 1.0 - temp_output_15_0_g300 );
			#endif
			float clampResult8_g300 = clamp( ( ( staticSwitch19_g300 - 1.0 ) + ( i.vertexColor.b * 2.0 ) ) , 0.0 , 1.0 );
			float4 temp_cast_7 = (clampResult8_g300).xxxx;
			float4 clampResult10_g300 = clamp( CalculateContrast(_HeightContrast,temp_cast_7) , float4( 0,0,0,0 ) , float4( 1,0,0,0 ) );
			float clampResult88_g298 = clamp( ( temp_output_82_0_g298 - ( 1.0 - (clampResult10_g300).r ) ) , 0.0 , 1.0 );
			float4 lerpResult65_g298 = lerp( lerpResult6_g298 , ( _WetnessColor * temp_output_20_0_g298 ) , clampResult88_g298);
			o.Albedo = lerpResult65_g298.rgb;
			o.Metallic = ( lerpResult84.g * _Metallic );
			float lerpResult7_g298 = lerp( _PuddlesSmoothness , ( lerpResult84.r * _Glossiness ) , temp_output_82_0_g298);
			float clampResult58_g298 = clamp( lerpResult7_g298 , 0.0 , 1.0 );
			float lerpResult54_g298 = lerp( clampResult58_g298 , _WetnessSmoothness , clampResult88_g298);
			o.Smoothness = lerpResult54_g298;
			float lerpResult45_g298 = lerp( 1.0 , lerpResult84.b , temp_output_82_0_g298);
			o.Occlusion = lerpResult45_g298;
			o.Alpha = 1;
		}

		ENDCG
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=13701
0;92;1173;926;1483.606;-157.5131;1;True;False
Node;AmplifyShaderEditor.RangedFloatNode;76;-1948.985,-29.8106;Float;False;Property;_Layer1Tiling;Layer 1 Tiling;0;0;1;0;0;0;1;FLOAT
Node;AmplifyShaderEditor.TextureCoordinatesNode;211;-1692.494,-39.64117;Float;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;FLOAT;FLOAT;FLOAT;FLOAT
Node;AmplifyShaderEditor.SamplerNode;32;-944,-96;Float;True;Property;_RMA;RMA;5;1;[NoScaleOffset];None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;1.0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1.0;False;5;COLOR;FLOAT;FLOAT;FLOAT;FLOAT
Node;AmplifyShaderEditor.VertexColorNode;37;-855.6008,-497.4376;Float;False;0;5;COLOR;FLOAT;FLOAT;FLOAT;FLOAT
Node;AmplifyShaderEditor.RangedFloatNode;118;-1981.511,790.3434;Float;False;Property;_Layer2Tiling;Layer 2 Tiling;1;0;1;0;0;0;1;FLOAT
Node;AmplifyShaderEditor.OneMinusNode;216;-583.9517,-257.5275;Float;False;1;0;FLOAT;0.0;False;1;FLOAT
Node;AmplifyShaderEditor.TextureCoordinatesNode;213;-1724.032,768.9888;Float;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;FLOAT;FLOAT;FLOAT;FLOAT
Node;AmplifyShaderEditor.FunctionNode;250;-418.0861,-580.7354;Float;False;Height Blend;11;;294;2;0;FLOAT;0.0;False;1;FLOAT;0.0;False;1;FLOAT
Node;AmplifyShaderEditor.OneMinusNode;89;-227.448,-353.8153;Float;False;1;0;FLOAT;0.0;False;1;FLOAT
Node;AmplifyShaderEditor.SamplerNode;80;-985.2155,738.2877;Float;True;Property;_RMA2;RMA 2;9;1;[NoScaleOffset];None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;1.0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1.0;False;5;COLOR;FLOAT;FLOAT;FLOAT;FLOAT
Node;AmplifyShaderEditor.RangedFloatNode;9;-1536.5,656;Float;False;Property;_NormalIntensity;Normal Intensity;6;0;1;0;0;0;1;FLOAT
Node;AmplifyShaderEditor.LerpOp;84;-346.3156,342.0886;Float;False;3;0;COLOR;0.0,0,0,0;False;1;COLOR;0.0,0,0,0;False;2;FLOAT;0.0,0,0,0;False;1;COLOR
Node;AmplifyShaderEditor.SamplerNode;1;-944,-304;Float;True;Property;_Albedo;Albedo;2;1;[NoScaleOffset];None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;1.0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1.0;False;5;COLOR;FLOAT;FLOAT;FLOAT;FLOAT
Node;AmplifyShaderEditor.SamplerNode;7;-896,304;Float;True;Property;_Normal;Normal;7;2;[NoScaleOffset];[Normal];None;True;0;True;bump;Auto;True;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;1.0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1.0;False;5;FLOAT3;FLOAT;FLOAT;FLOAT;FLOAT
Node;AmplifyShaderEditor.SamplerNode;81;-992,960;Float;True;Property;_Normal2;Normal 2;10;2;[NoScaleOffset];[Normal];None;True;0;True;bump;Auto;True;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;1.0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1.0;False;5;FLOAT3;FLOAT;FLOAT;FLOAT;FLOAT
Node;AmplifyShaderEditor.RangedFloatNode;13;-896,110.7;Float;False;Property;_Glossiness;Glossiness;3;0;1;0;0;0;1;FLOAT
Node;AmplifyShaderEditor.BreakToComponentsNode;85;-137.1153,188.289;Float;False;COLOR;1;0;COLOR;0,0,0,0;False;16;FLOAT;FLOAT;FLOAT;FLOAT;FLOAT;FLOAT;FLOAT;FLOAT;FLOAT;FLOAT;FLOAT;FLOAT;FLOAT;FLOAT;FLOAT;FLOAT
Node;AmplifyShaderEditor.RangedFloatNode;2;-896,192;Float;False;Property;_Metallic;Metallic;4;0;1;0;0;0;1;FLOAT
Node;AmplifyShaderEditor.SamplerNode;79;-985.2155,528.6877;Float;True;Property;_Albedo2;Albedo 2;8;1;[NoScaleOffset];None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;1.0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1.0;False;5;COLOR;FLOAT;FLOAT;FLOAT;FLOAT
Node;AmplifyShaderEditor.LerpOp;83;-176,496;Float;False;3;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT;0.0,0,0;False;1;FLOAT3
Node;AmplifyShaderEditor.OneMinusNode;218;571.5192,58.78705;Float;False;1;0;FLOAT;0.0;False;1;FLOAT
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;12;200.6,3.899991;Float;False;2;2;0;FLOAT;0.0;False;1;FLOAT;0.0;False;1;FLOAT
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;33;203.6,104.8999;Float;False;2;2;0;FLOAT;0.0;False;1;FLOAT;0.0;False;1;FLOAT
Node;AmplifyShaderEditor.LerpOp;82;0,-160;Float;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0.0,0,0,0;False;2;FLOAT;0.0,0,0,0;False;1;COLOR
Node;AmplifyShaderEditor.FunctionNode;251;1023.973,-160.2147;Float;False;Water Puddles;14;;298;8;0;FLOAT;0.0;False;1;FLOAT;0.0;False;2;FLOAT4;0,0,0,0;False;3;FLOAT3;0,0,0;False;4;FLOAT;0.0;False;5;FLOAT;0.0;False;6;FLOAT;0.0;False;7;FLOAT;0.0;False;6;COLOR;FLOAT3;FLOAT;FLOAT;FLOAT;FLOAT
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;1955.711,114.7165;Float;False;True;2;Float;ASEMaterialInspector;0;0;Standard;FlamingSands/PBR Metallic Blend Two Layers Puddles;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;0;False;0;0;Opaque;0.5;True;True;0;False;Opaque;Geometry;All;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;False;0;255;255;0;0;0;0;0;0;0;0;False;0;4;10;25;False;0.5;True;0;Zero;Zero;0;Zero;Zero;Add;Add;0;False;0;0,0,0,0;VertexOffset;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;0;0;False;15;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0.0;False;4;FLOAT;0.0;False;5;FLOAT;0.0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0.0;False;9;FLOAT;0.0;False;10;FLOAT;0.0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;211;0;76;0
WireConnection;32;1;211;0
WireConnection;216;0;32;4
WireConnection;213;0;118;0
WireConnection;250;0;216;0
WireConnection;250;1;37;1
WireConnection;89;0;250;0
WireConnection;80;1;213;0
WireConnection;84;0;80;0
WireConnection;84;1;32;0
WireConnection;84;2;89;0
WireConnection;1;1;211;0
WireConnection;7;1;211;0
WireConnection;7;5;9;0
WireConnection;81;1;213;0
WireConnection;81;5;9;0
WireConnection;85;0;84;0
WireConnection;79;1;213;0
WireConnection;83;0;81;0
WireConnection;83;1;7;0
WireConnection;83;2;89;0
WireConnection;218;0;85;3
WireConnection;12;0;85;0
WireConnection;12;1;13;0
WireConnection;33;0;85;1
WireConnection;33;1;2;0
WireConnection;82;0;79;0
WireConnection;82;1;1;0
WireConnection;82;2;89;0
WireConnection;251;0;218;0
WireConnection;251;1;37;2
WireConnection;251;2;82;0
WireConnection;251;3;83;0
WireConnection;251;4;12;0
WireConnection;251;5;33;0
WireConnection;251;6;85;2
WireConnection;251;7;37;3
WireConnection;0;0;251;0
WireConnection;0;1;251;1
WireConnection;0;3;251;3
WireConnection;0;4;251;2
WireConnection;0;5;251;4
ASEEND*/
//CHKSM=931EC32D0859EF1BBF986FBD31F5C981CC653F38