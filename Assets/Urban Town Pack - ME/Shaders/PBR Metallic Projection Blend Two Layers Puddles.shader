// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "FlamingSands/PBR Metallic Projection Blend Two Layers Puddles"
{
	Properties
	{
		_Layer1Sizesquaremeter("Layer 1 Size (square meter)", Float) = 1
		_Layer2squaremeter("Layer 2 (square meter)", Float) = 1
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
		#pragma surface surf Standard keepalpha addshadow fullforwardshadows 
		struct Input
		{
			float3 worldPos;
			float4 vertexColor : COLOR;
		};

		uniform sampler2D _WaterNormal;
		uniform float _NormalIntensity;
		uniform sampler2D _Normal2;
		uniform float _Layer2squaremeter;
		uniform sampler2D _Normal;
		uniform float _Layer1Sizesquaremeter;
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

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float3 ase_worldPos = i.worldPos;
			float2 appendResult32_g206 = (float2(ase_worldPos.x , ase_worldPos.z));
			float2 temp_output_33_0_g206 = ( appendResult32_g206 / 2.0 );
			float2 panner30_g206 = ( temp_output_33_0_g206 + 1.0 * _Time.y * float2( 0.05,0.05 ));
			float2 panner41_g206 = ( temp_output_33_0_g206 + 1.0 * _Time.y * float2( -0.05,0 ));
			float2 appendResult114 = (float2(ase_worldPos.x , ase_worldPos.z));
			float2 temp_output_117_0 = ( appendResult114 / _Layer2squaremeter );
			float2 temp_output_116_0 = ( appendResult114 / _Layer1Sizesquaremeter );
			float4 tex2DNode32 = tex2D( _RMA, temp_output_116_0 );
			float temp_output_15_0_g4 = tex2DNode32.a;
			#ifdef _INVERTHEIGHT_ON
				float staticSwitch19_g4 = temp_output_15_0_g4;
			#else
				float staticSwitch19_g4 = ( 1.0 - temp_output_15_0_g4 );
			#endif
			float clampResult8_g4 = clamp( ( ( staticSwitch19_g4 - 1.0 ) + ( i.vertexColor.r * 2.0 ) ) , 0.0 , 1.0 );
			float4 temp_cast_0 = (clampResult8_g4).xxxx;
			float4 clampResult10_g4 = clamp( CalculateContrast(_HeightContrast,temp_cast_0) , float4( 0,0,0,0 ) , float4( 1,0,0,0 ) );
			float temp_output_89_0 = ( 1.0 - (clampResult10_g4).r );
			float3 lerpResult83 = lerp( UnpackScaleNormal( tex2D( _Normal2, temp_output_117_0 ) ,_NormalIntensity ) , UnpackScaleNormal( tex2D( _Normal, temp_output_116_0 ) ,_NormalIntensity ) , temp_output_89_0);
			float4 lerpResult84 = lerp( tex2D( _RMA2, temp_output_117_0 ) , tex2DNode32 , temp_output_89_0);
			float temp_output_17_0_g206 = lerpResult84.a;
			float temp_output_15_0_g207 = temp_output_17_0_g206;
			#ifdef _INVERTHEIGHT_ON
				float staticSwitch19_g207 = temp_output_15_0_g207;
			#else
				float staticSwitch19_g207 = ( 1.0 - temp_output_15_0_g207 );
			#endif
			float clampResult8_g207 = clamp( ( ( staticSwitch19_g207 - 1.0 ) + ( i.vertexColor.g * 2.0 ) ) , 0.0 , 1.0 );
			float4 temp_cast_1 = (clampResult8_g207).xxxx;
			float4 clampResult10_g207 = clamp( CalculateContrast(_HeightContrast,temp_cast_1) , float4( 0,0,0,0 ) , float4( 1,0,0,0 ) );
			float temp_output_82_0_g206 = ( 1.0 - (clampResult10_g207).r );
			float3 lerpResult8_g206 = lerp( BlendNormals( UnpackScaleNormal( tex2D( _WaterNormal, panner30_g206 ) ,0.25 ) , UnpackScaleNormal( tex2D( _WaterNormal, panner41_g206 ) ,0.25 ) ) , lerpResult83 , temp_output_82_0_g206);
			o.Normal = lerpResult8_g206;
			float4 lerpResult82 = lerp( tex2D( _Albedo2, temp_output_117_0 ) , tex2D( _Albedo, temp_output_116_0 ) , temp_output_89_0);
			float4 temp_output_20_0_g206 = lerpResult82;
			#ifdef _INVERTDEPTH_ON
				float staticSwitch90_g206 = ( 1.0 - temp_output_17_0_g206 );
			#else
				float staticSwitch90_g206 = temp_output_17_0_g206;
			#endif
			float clampResult75_g206 = clamp( ( staticSwitch90_g206 + _PuddlesColorDepth.a ) , 0.0 , 1.0 );
			float4 lerpResult4_g206 = lerp( temp_output_20_0_g206 , _PuddlesColorDepth , clampResult75_g206);
			float4 lerpResult6_g206 = lerp( lerpResult4_g206 , temp_output_20_0_g206 , temp_output_82_0_g206);
			float temp_output_15_0_g208 = temp_output_17_0_g206;
			#ifdef _INVERTHEIGHT_ON
				float staticSwitch19_g208 = temp_output_15_0_g208;
			#else
				float staticSwitch19_g208 = ( 1.0 - temp_output_15_0_g208 );
			#endif
			float clampResult8_g208 = clamp( ( ( staticSwitch19_g208 - 1.0 ) + ( i.vertexColor.b * 2.0 ) ) , 0.0 , 1.0 );
			float4 temp_cast_7 = (clampResult8_g208).xxxx;
			float4 clampResult10_g208 = clamp( CalculateContrast(_HeightContrast,temp_cast_7) , float4( 0,0,0,0 ) , float4( 1,0,0,0 ) );
			float clampResult88_g206 = clamp( ( temp_output_82_0_g206 - ( 1.0 - (clampResult10_g208).r ) ) , 0.0 , 1.0 );
			float4 lerpResult65_g206 = lerp( lerpResult6_g206 , ( _WetnessColor * temp_output_20_0_g206 ) , clampResult88_g206);
			o.Albedo = lerpResult65_g206.rgb;
			o.Metallic = ( lerpResult84.g * _Metallic );
			float lerpResult7_g206 = lerp( _PuddlesSmoothness , ( lerpResult84.r * _Glossiness ) , temp_output_82_0_g206);
			float clampResult58_g206 = clamp( lerpResult7_g206 , 0.0 , 1.0 );
			float lerpResult54_g206 = lerp( clampResult58_g206 , _WetnessSmoothness , clampResult88_g206);
			o.Smoothness = lerpResult54_g206;
			float lerpResult45_g206 = lerp( 1.0 , lerpResult84.b , temp_output_82_0_g206);
			o.Occlusion = lerpResult45_g206;
			o.Alpha = 1;
		}

		ENDCG
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=13701
0;92;1173;926;1419.266;-80.81384;1;True;False
Node;AmplifyShaderEditor.WorldPosInputsNode;113;-3288.878,-413.4059;Float;False;0;4;FLOAT3;FLOAT;FLOAT;FLOAT
Node;AmplifyShaderEditor.DynamicAppendNode;114;-2954.878,-397.4059;Float;False;FLOAT2;4;0;FLOAT;0.0;False;1;FLOAT;0.0;False;2;FLOAT;0.0;False;3;FLOAT;0.0;False;1;FLOAT2
Node;AmplifyShaderEditor.RangedFloatNode;76;-3005.12,-278.7792;Float;False;Property;_Layer1Sizesquaremeter;Layer 1 Size (square meter);0;0;1;0;0;0;1;FLOAT
Node;AmplifyShaderEditor.SimpleDivideOpNode;116;-2676.878,-414.4059;Float;False;2;0;FLOAT2;0,0;False;1;FLOAT;0,0;False;1;FLOAT2
Node;AmplifyShaderEditor.VertexColorNode;37;-855.6008,-497.4376;Float;False;0;5;COLOR;FLOAT;FLOAT;FLOAT;FLOAT
Node;AmplifyShaderEditor.RangedFloatNode;118;-2837.836,412.9242;Float;False;Property;_Layer2squaremeter;Layer 2 (square meter);1;0;1;0;0;0;1;FLOAT
Node;AmplifyShaderEditor.SamplerNode;32;-944,-96;Float;True;Property;_RMA;RMA;5;1;[NoScaleOffset];None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;1.0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1.0;False;5;COLOR;FLOAT;FLOAT;FLOAT;FLOAT
Node;AmplifyShaderEditor.FunctionNode;112;-418.0861,-580.7354;Float;False;Height Blend;11;;4;2;0;FLOAT;0.0;False;1;FLOAT;0.0;False;1;FLOAT
Node;AmplifyShaderEditor.SimpleDivideOpNode;117;-2033.736,407.514;Float;False;2;0;FLOAT2;0,0;False;1;FLOAT;0.0,0;False;1;FLOAT2
Node;AmplifyShaderEditor.OneMinusNode;89;-227.448,-353.8153;Float;False;1;0;FLOAT;0.0;False;1;FLOAT
Node;AmplifyShaderEditor.SamplerNode;80;-985.2155,738.2877;Float;True;Property;_RMA2;RMA 2;9;1;[NoScaleOffset];None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;1.0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1.0;False;5;COLOR;FLOAT;FLOAT;FLOAT;FLOAT
Node;AmplifyShaderEditor.LerpOp;84;-346.3156,342.0886;Float;False;3;0;COLOR;0.0,0,0,0;False;1;COLOR;0.0,0,0,0;False;2;FLOAT;0.0,0,0,0;False;1;COLOR
Node;AmplifyShaderEditor.RangedFloatNode;9;-1536.5,656;Float;False;Property;_NormalIntensity;Normal Intensity;6;0;1;0;0;0;1;FLOAT
Node;AmplifyShaderEditor.BreakToComponentsNode;85;-137.1153,188.289;Float;False;COLOR;1;0;COLOR;0,0,0,0;False;16;FLOAT;FLOAT;FLOAT;FLOAT;FLOAT;FLOAT;FLOAT;FLOAT;FLOAT;FLOAT;FLOAT;FLOAT;FLOAT;FLOAT;FLOAT;FLOAT
Node;AmplifyShaderEditor.SamplerNode;7;-896,304;Float;True;Property;_Normal;Normal;7;2;[NoScaleOffset];[Normal];None;True;0;True;bump;Auto;True;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;1.0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1.0;False;5;FLOAT3;FLOAT;FLOAT;FLOAT;FLOAT
Node;AmplifyShaderEditor.SamplerNode;81;-992,960;Float;True;Property;_Normal2;Normal 2;10;2;[NoScaleOffset];[Normal];None;True;0;True;bump;Auto;True;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;1.0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1.0;False;5;FLOAT3;FLOAT;FLOAT;FLOAT;FLOAT
Node;AmplifyShaderEditor.RangedFloatNode;13;-896,110.7;Float;False;Property;_Glossiness;Glossiness;3;0;1;0;0;0;1;FLOAT
Node;AmplifyShaderEditor.RangedFloatNode;2;-896,192;Float;False;Property;_Metallic;Metallic;4;0;1;0;0;0;1;FLOAT
Node;AmplifyShaderEditor.SamplerNode;1;-944,-304;Float;True;Property;_Albedo;Albedo;2;1;[NoScaleOffset];None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;1.0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1.0;False;5;COLOR;FLOAT;FLOAT;FLOAT;FLOAT
Node;AmplifyShaderEditor.SamplerNode;79;-985.2155,528.6877;Float;True;Property;_Albedo2;Albedo 2;8;1;[NoScaleOffset];None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;1.0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1.0;False;5;COLOR;FLOAT;FLOAT;FLOAT;FLOAT
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;33;203.6,104.8999;Float;False;2;2;0;FLOAT;0.0;False;1;FLOAT;0.0;False;1;FLOAT
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;12;200.6,3.899991;Float;False;2;2;0;FLOAT;0.0;False;1;FLOAT;0.0;False;1;FLOAT
Node;AmplifyShaderEditor.LerpOp;82;0,-160;Float;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0.0,0,0,0;False;2;FLOAT;0.0,0,0,0;False;1;COLOR
Node;AmplifyShaderEditor.LerpOp;83;-176,496;Float;False;3;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT;0.0,0,0;False;1;FLOAT3
Node;AmplifyShaderEditor.FunctionNode;214;1023.973,-160.2147;Float;False;Water Puddles;14;;206;8;0;FLOAT;0.0;False;1;FLOAT;0.0;False;2;FLOAT4;0,0,0,0;False;3;FLOAT3;0,0,0;False;4;FLOAT;0.0;False;5;FLOAT;0.0;False;6;FLOAT;0.0;False;7;FLOAT;0.0;False;6;COLOR;FLOAT3;FLOAT;FLOAT;FLOAT;FLOAT
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;1955.711,114.7165;Float;False;True;2;Float;ASEMaterialInspector;0;0;Standard;FlamingSands/PBR Metallic Projection Blend Two Layers Puddles;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;0;False;0;0;Opaque;0.5;True;True;0;False;Opaque;Geometry;All;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;False;0;255;255;0;0;0;0;0;0;0;0;False;0;4;10;25;False;0.5;True;0;Zero;Zero;0;Zero;Zero;Add;Add;0;False;0;0,0,0,0;VertexOffset;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;0;0;False;15;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0.0;False;4;FLOAT;0.0;False;5;FLOAT;0.0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0.0;False;9;FLOAT;0.0;False;10;FLOAT;0.0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;114;0;113;1
WireConnection;114;1;113;3
WireConnection;116;0;114;0
WireConnection;116;1;76;0
WireConnection;32;1;116;0
WireConnection;112;0;32;4
WireConnection;112;1;37;1
WireConnection;117;0;114;0
WireConnection;117;1;118;0
WireConnection;89;0;112;0
WireConnection;80;1;117;0
WireConnection;84;0;80;0
WireConnection;84;1;32;0
WireConnection;84;2;89;0
WireConnection;85;0;84;0
WireConnection;7;1;116;0
WireConnection;7;5;9;0
WireConnection;81;1;117;0
WireConnection;81;5;9;0
WireConnection;1;1;116;0
WireConnection;79;1;117;0
WireConnection;33;0;85;1
WireConnection;33;1;2;0
WireConnection;12;0;85;0
WireConnection;12;1;13;0
WireConnection;82;0;79;0
WireConnection;82;1;1;0
WireConnection;82;2;89;0
WireConnection;83;0;81;0
WireConnection;83;1;7;0
WireConnection;83;2;89;0
WireConnection;214;0;85;3
WireConnection;214;1;37;2
WireConnection;214;2;82;0
WireConnection;214;3;83;0
WireConnection;214;4;12;0
WireConnection;214;5;33;0
WireConnection;214;6;85;2
WireConnection;214;7;37;3
WireConnection;0;0;214;0
WireConnection;0;1;214;1
WireConnection;0;3;214;3
WireConnection;0;4;214;2
WireConnection;0;5;214;4
ASEEND*/
//CHKSM=BF4BDF6118C0E6C224540F8DB8230D002D62D7D5