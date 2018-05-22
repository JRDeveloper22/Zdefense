// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "FlamingSands/PBR Metallic Blend Two Layers Puddles Tesselation"
{
	Properties
	{
		[HideInInspector] _DummyTex( "", 2D ) = "white" {}
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
		_TessValue( "Max Tessellation", Range( 1, 32 ) ) = 32
		_TessMin( "Tess Min Distance", Float ) = 1
		_TessMax( "Tess Max Distance", Float ) = 10
		_TessPhongStrength( "Phong Tess Strength", Range( 0, 1 ) ) = 0.5
		_TessellationBias("Tessellation Bias", Range( -1 , 1)) = 0
		_TessellationHeight("Tessellation Height", Range( 0 , 0.2)) = 0.05
		_Puddles_height("Puddles_height", Range( -1 , 1)) = 0
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Opaque"  "Queue" = "Geometry+0" }
		Cull Back
		CGPROGRAM
		#include "UnityStandardUtils.cginc"
		#include "UnityShaderVariables.cginc"
		#include "Tessellation.cginc"
		#pragma target 5.0
		#pragma shader_feature _INVERTHEIGHT_ON
		#pragma shader_feature _INVERTDEPTH_ON
		#pragma surface surf Standard keepalpha addshadow fullforwardshadows vertex:vertexDataFunc tessellate:tessFunction tessphong:_TessPhongStrength 
		struct Input
		{
			float3 worldPos;
			float2 uv_DummyTex;
			float4 vertexColor : COLOR;
		};

		struct appdata
		{
			float4 vertex : POSITION;
			float4 tangent : TANGENT;
			float3 normal : NORMAL;
			float4 texcoord : TEXCOORD0;
			float4 texcoord1 : TEXCOORD1;
			float4 texcoord2 : TEXCOORD2;
			float4 texcoord3 : TEXCOORD3;
			fixed4 color : COLOR;
			UNITY_VERTEX_INPUT_INSTANCE_ID
		};

		uniform sampler2D _WaterNormal;
		uniform float _NormalIntensity;
		uniform sampler2D _Normal2;
		uniform float _Layer2Tiling;
		uniform sampler2D _DummyTex;
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
		uniform float _Puddles_height;
		uniform float _TessellationBias;
		uniform float _TessellationHeight;
		uniform float _TessValue;
		uniform float _TessMin;
		uniform float _TessMax;
		uniform float _TessPhongStrength;


		float4 CalculateContrast( float contrastValue, float4 colorTarget )
		{
			float t = 0.5 * ( 1.0 - contrastValue );
			return mul( float4x4( contrastValue,0,0,t, 0,contrastValue,0,t, 0,0,contrastValue,t, 0,0,0,1 ), colorTarget );
		}

		float4 tessFunction( appdata v0, appdata v1, appdata v2 )
		{
			return UnityDistanceBasedTess( v0.vertex, v1.vertex, v2.vertex, _TessMin, _TessMax, _TessValue );
		}

		void vertexDataFunc( inout appdata v )
		{
			float2 temp_cast_0 = (_Layer2Tiling).xx;
			v.texcoord.xy = v.texcoord.xy * temp_cast_0 + float2( 0,0 );
			float4 tex2DNode80 = tex2Dlod( _RMA2, float4( v.texcoord.xy, 0, 1.0) );
			float2 temp_cast_1 = (_Layer1Tiling).xx;
			v.texcoord.xy = v.texcoord.xy * temp_cast_1 + float2( 0,0 );
			float4 tex2DNode32 = tex2Dlod( _RMA, float4( v.texcoord.xy, 0, 1.0) );
			float temp_output_15_0_g294 = ( 1.0 - tex2DNode32.a );
			#ifdef _INVERTHEIGHT_ON
				float staticSwitch19_g294 = temp_output_15_0_g294;
			#else
				float staticSwitch19_g294 = ( 1.0 - temp_output_15_0_g294 );
			#endif
			float clampResult8_g294 = clamp( ( ( staticSwitch19_g294 - 1.0 ) + ( v.color.r * 2.0 ) ) , 0.0 , 1.0 );
			float4 temp_cast_2 = (clampResult8_g294).xxxx;
			float4 clampResult10_g294 = clamp( CalculateContrast(_HeightContrast,temp_cast_2) , float4( 0,0,0,0 ) , float4( 1,0,0,0 ) );
			float temp_output_89_0 = ( 1.0 - (clampResult10_g294).r );
			float lerpResult253 = lerp( tex2DNode80.a , tex2DNode32.a , temp_output_89_0);
			float4 lerpResult84 = lerp( tex2DNode80 , tex2DNode32 , temp_output_89_0);
			float temp_output_17_0_g304 = ( 1.0 - lerpResult84.a );
			float temp_output_15_0_g305 = temp_output_17_0_g304;
			#ifdef _INVERTHEIGHT_ON
				float staticSwitch19_g305 = temp_output_15_0_g305;
			#else
				float staticSwitch19_g305 = ( 1.0 - temp_output_15_0_g305 );
			#endif
			float clampResult8_g305 = clamp( ( ( staticSwitch19_g305 - 1.0 ) + ( v.color.g * 2.0 ) ) , 0.0 , 1.0 );
			float4 temp_cast_3 = (clampResult8_g305).xxxx;
			float4 clampResult10_g305 = clamp( CalculateContrast(_HeightContrast,temp_cast_3) , float4( 0,0,0,0 ) , float4( 1,0,0,0 ) );
			float temp_output_82_0_g304 = ( 1.0 - (clampResult10_g305).r );
			float lerpResult259 = lerp( _Puddles_height , lerpResult253 , temp_output_82_0_g304);
			float3 ase_vertexNormal = v.normal.xyz;
			v.vertex.xyz += ( ( ( lerpResult259 + _TessellationBias ) * ase_vertexNormal ) * _TessellationHeight );
		}

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float3 ase_worldPos = i.worldPos;
			float2 appendResult32_g304 = (float2(ase_worldPos.x , ase_worldPos.z));
			float2 temp_output_33_0_g304 = ( appendResult32_g304 / 2.0 );
			float2 panner30_g304 = ( temp_output_33_0_g304 + 1.0 * _Time.y * float2( 0.05,0.05 ));
			float2 panner41_g304 = ( temp_output_33_0_g304 + 1.0 * _Time.y * float2( -0.05,0 ));
			float2 temp_cast_0 = (_Layer2Tiling).xx;
			float2 texCoordDummy213 = i.uv_DummyTex*temp_cast_0 + float2( 0,0 );
			float2 temp_cast_1 = (_Layer1Tiling).xx;
			float2 texCoordDummy211 = i.uv_DummyTex*temp_cast_1 + float2( 0,0 );
			float4 tex2DNode32 = tex2D( _RMA, texCoordDummy211 );
			float temp_output_15_0_g294 = ( 1.0 - tex2DNode32.a );
			#ifdef _INVERTHEIGHT_ON
				float staticSwitch19_g294 = temp_output_15_0_g294;
			#else
				float staticSwitch19_g294 = ( 1.0 - temp_output_15_0_g294 );
			#endif
			float clampResult8_g294 = clamp( ( ( staticSwitch19_g294 - 1.0 ) + ( i.vertexColor.r * 2.0 ) ) , 0.0 , 1.0 );
			float4 temp_cast_2 = (clampResult8_g294).xxxx;
			float4 clampResult10_g294 = clamp( CalculateContrast(_HeightContrast,temp_cast_2) , float4( 0,0,0,0 ) , float4( 1,0,0,0 ) );
			float temp_output_89_0 = ( 1.0 - (clampResult10_g294).r );
			float3 lerpResult83 = lerp( UnpackScaleNormal( tex2D( _Normal2, texCoordDummy213 ) ,_NormalIntensity ) , UnpackScaleNormal( tex2D( _Normal, texCoordDummy211 ) ,_NormalIntensity ) , temp_output_89_0);
			float4 tex2DNode80 = tex2D( _RMA2, texCoordDummy213 );
			float4 lerpResult84 = lerp( tex2DNode80 , tex2DNode32 , temp_output_89_0);
			float temp_output_17_0_g304 = ( 1.0 - lerpResult84.a );
			float temp_output_15_0_g305 = temp_output_17_0_g304;
			#ifdef _INVERTHEIGHT_ON
				float staticSwitch19_g305 = temp_output_15_0_g305;
			#else
				float staticSwitch19_g305 = ( 1.0 - temp_output_15_0_g305 );
			#endif
			float clampResult8_g305 = clamp( ( ( staticSwitch19_g305 - 1.0 ) + ( i.vertexColor.g * 2.0 ) ) , 0.0 , 1.0 );
			float4 temp_cast_3 = (clampResult8_g305).xxxx;
			float4 clampResult10_g305 = clamp( CalculateContrast(_HeightContrast,temp_cast_3) , float4( 0,0,0,0 ) , float4( 1,0,0,0 ) );
			float temp_output_82_0_g304 = ( 1.0 - (clampResult10_g305).r );
			float3 lerpResult8_g304 = lerp( BlendNormals( UnpackScaleNormal( tex2D( _WaterNormal, panner30_g304 ) ,0.25 ) , UnpackScaleNormal( tex2D( _WaterNormal, panner41_g304 ) ,0.25 ) ) , lerpResult83 , temp_output_82_0_g304);
			o.Normal = lerpResult8_g304;
			float4 lerpResult82 = lerp( tex2D( _Albedo2, texCoordDummy213 ) , tex2D( _Albedo, texCoordDummy211 ) , temp_output_89_0);
			float4 temp_output_20_0_g304 = lerpResult82;
			#ifdef _INVERTDEPTH_ON
				float staticSwitch90_g304 = ( 1.0 - temp_output_17_0_g304 );
			#else
				float staticSwitch90_g304 = temp_output_17_0_g304;
			#endif
			float clampResult75_g304 = clamp( ( staticSwitch90_g304 + _PuddlesColorDepth.a ) , 0.0 , 1.0 );
			float4 lerpResult4_g304 = lerp( temp_output_20_0_g304 , _PuddlesColorDepth , clampResult75_g304);
			float4 lerpResult6_g304 = lerp( lerpResult4_g304 , temp_output_20_0_g304 , temp_output_82_0_g304);
			float temp_output_15_0_g306 = temp_output_17_0_g304;
			#ifdef _INVERTHEIGHT_ON
				float staticSwitch19_g306 = temp_output_15_0_g306;
			#else
				float staticSwitch19_g306 = ( 1.0 - temp_output_15_0_g306 );
			#endif
			float clampResult8_g306 = clamp( ( ( staticSwitch19_g306 - 1.0 ) + ( i.vertexColor.b * 2.0 ) ) , 0.0 , 1.0 );
			float4 temp_cast_9 = (clampResult8_g306).xxxx;
			float4 clampResult10_g306 = clamp( CalculateContrast(_HeightContrast,temp_cast_9) , float4( 0,0,0,0 ) , float4( 1,0,0,0 ) );
			float clampResult88_g304 = clamp( ( temp_output_82_0_g304 - ( 1.0 - (clampResult10_g306).r ) ) , 0.0 , 1.0 );
			float4 lerpResult65_g304 = lerp( lerpResult6_g304 , ( _WetnessColor * temp_output_20_0_g304 ) , clampResult88_g304);
			o.Albedo = lerpResult65_g304.rgb;
			o.Metallic = ( lerpResult84.g * _Metallic );
			float lerpResult7_g304 = lerp( _PuddlesSmoothness , ( lerpResult84.r * _Glossiness ) , temp_output_82_0_g304);
			float clampResult58_g304 = clamp( lerpResult7_g304 , 0.0 , 1.0 );
			float lerpResult54_g304 = lerp( clampResult58_g304 , _WetnessSmoothness , clampResult88_g304);
			o.Smoothness = lerpResult54_g304;
			float lerpResult45_g304 = lerp( 1.0 , lerpResult84.b , temp_output_82_0_g304);
			o.Occlusion = lerpResult45_g304;
			o.Alpha = 1;
		}

		ENDCG
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=13701
0;92;1173;926;1563.406;25.06042;1;True;False
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
Node;AmplifyShaderEditor.LerpOp;84;-346.3156,342.0886;Float;False;3;0;COLOR;0.0,0,0,0;False;1;COLOR;0.0,0,0,0;False;2;FLOAT;0.0,0,0,0;False;1;COLOR
Node;AmplifyShaderEditor.RangedFloatNode;9;-1536.5,656;Float;False;Property;_NormalIntensity;Normal Intensity;6;0;1;0;0;0;1;FLOAT
Node;AmplifyShaderEditor.RangedFloatNode;13;-896,110.7;Float;False;Property;_Glossiness;Glossiness;3;0;1;0;0;0;1;FLOAT
Node;AmplifyShaderEditor.RangedFloatNode;2;-896,192;Float;False;Property;_Metallic;Metallic;4;0;1;0;0;0;1;FLOAT
Node;AmplifyShaderEditor.SamplerNode;79;-985.2155,528.6877;Float;True;Property;_Albedo2;Albedo 2;8;1;[NoScaleOffset];None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;1.0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1.0;False;5;COLOR;FLOAT;FLOAT;FLOAT;FLOAT
Node;AmplifyShaderEditor.SamplerNode;1;-944,-304;Float;True;Property;_Albedo;Albedo;2;1;[NoScaleOffset];None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;1.0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1.0;False;5;COLOR;FLOAT;FLOAT;FLOAT;FLOAT
Node;AmplifyShaderEditor.BreakToComponentsNode;85;-137.1153,188.289;Float;False;COLOR;1;0;COLOR;0,0,0,0;False;16;FLOAT;FLOAT;FLOAT;FLOAT;FLOAT;FLOAT;FLOAT;FLOAT;FLOAT;FLOAT;FLOAT;FLOAT;FLOAT;FLOAT;FLOAT;FLOAT
Node;AmplifyShaderEditor.SamplerNode;7;-895,304;Float;True;Property;_Normal;Normal;7;2;[NoScaleOffset];[Normal];None;True;0;True;bump;Auto;True;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;1.0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1.0;False;5;FLOAT3;FLOAT;FLOAT;FLOAT;FLOAT
Node;AmplifyShaderEditor.SamplerNode;81;-992,960;Float;True;Property;_Normal2;Normal 2;10;2;[NoScaleOffset];[Normal];None;True;0;True;bump;Auto;True;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;1.0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1.0;False;5;FLOAT3;FLOAT;FLOAT;FLOAT;FLOAT
Node;AmplifyShaderEditor.LerpOp;82;0,-160;Float;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0.0,0,0,0;False;2;FLOAT;0.0,0,0,0;False;1;COLOR
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;12;200.6,3.899991;Float;False;2;2;0;FLOAT;0.0;False;1;FLOAT;0.0;False;1;FLOAT
Node;AmplifyShaderEditor.OneMinusNode;218;571.5192,58.78705;Float;False;1;0;FLOAT;0.0;False;1;FLOAT
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;33;203.6,104.8999;Float;False;2;2;0;FLOAT;0.0;False;1;FLOAT;0.0;False;1;FLOAT
Node;AmplifyShaderEditor.LerpOp;83;-176,496;Float;False;3;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT;0.0,0,0;False;1;FLOAT3
Node;AmplifyShaderEditor.LerpOp;253;41.06768,1327.442;Float;False;3;0;FLOAT;0;False;1;FLOAT;0.0;False;2;FLOAT;0.0;False;1;FLOAT
Node;AmplifyShaderEditor.FunctionNode;262;1023.973,-160.2147;Float;False;Water Puddles;14;;304;8;0;FLOAT;0.0;False;1;FLOAT;0.0;False;2;FLOAT4;0,0,0,0;False;3;FLOAT3;0,0,0;False;4;FLOAT;0.0;False;5;FLOAT;0.0;False;6;FLOAT;0.0;False;7;FLOAT;0.0;False;6;COLOR;FLOAT3;FLOAT;FLOAT;FLOAT;FLOAT
Node;AmplifyShaderEditor.RangedFloatNode;260;-42.84106,1180.026;Float;False;Property;_Puddles_height;Puddles_height;28;0;0;-1;1;0;1;FLOAT
Node;AmplifyShaderEditor.LerpOp;259;240.0978,1323.746;Float;False;3;0;FLOAT;0.0;False;1;FLOAT;0.0;False;2;FLOAT;0.0;False;1;FLOAT
Node;AmplifyShaderEditor.RangedFloatNode;252;128.7858,1111.733;Float;False;Property;_TessellationBias;Tessellation Bias;26;0;0;-1;1;0;1;FLOAT
Node;AmplifyShaderEditor.NormalVertexDataNode;255;145.9865,1496.434;Float;False;0;5;FLOAT3;FLOAT;FLOAT;FLOAT;FLOAT
Node;AmplifyShaderEditor.SimpleAddOpNode;254;415.0849,1290.433;Float;False;2;2;0;FLOAT;0,0,0,0;False;1;FLOAT;0.0;False;1;FLOAT
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;256;525.8859,1355.533;Float;False;2;2;0;FLOAT;0.0;False;1;FLOAT3;0;False;1;FLOAT3
Node;AmplifyShaderEditor.RangedFloatNode;257;480.3847,1580.434;Float;False;Property;_TessellationHeight;Tessellation Height;27;0;0.05;0;0.2;0;1;FLOAT
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;258;755.9846,1473.834;Float;False;2;2;0;FLOAT3;0,0,0,0;False;1;FLOAT;0.0,0,0;False;1;FLOAT3
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;1955.711,114.7165;Float;False;True;7;Float;ASEMaterialInspector;0;0;Standard;FlamingSands/PBR Metallic Blend Two Layers Puddles Tesselation;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;0;False;0;0;Opaque;0.5;True;True;0;False;Opaque;Geometry;All;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;False;0;255;255;0;0;0;0;0;0;0;0;True;0;32;1;10;True;0.5;True;0;Zero;Zero;0;Zero;Zero;Add;Add;0;False;0;0,0,0,0;VertexOffset;False;Cylindrical;False;Relative;0;;-1;-1;-1;21;0;0;0;False;15;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0.0;False;4;FLOAT;0.0;False;5;FLOAT;0.0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0.0;False;9;FLOAT;0.0;False;10;FLOAT;0.0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
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
WireConnection;79;1;213;0
WireConnection;1;1;211;0
WireConnection;85;0;84;0
WireConnection;7;1;211;0
WireConnection;7;5;9;0
WireConnection;81;1;213;0
WireConnection;81;5;9;0
WireConnection;82;0;79;0
WireConnection;82;1;1;0
WireConnection;82;2;89;0
WireConnection;12;0;85;0
WireConnection;12;1;13;0
WireConnection;218;0;85;3
WireConnection;33;0;85;1
WireConnection;33;1;2;0
WireConnection;83;0;81;0
WireConnection;83;1;7;0
WireConnection;83;2;89;0
WireConnection;253;0;80;4
WireConnection;253;1;32;4
WireConnection;253;2;89;0
WireConnection;262;0;218;0
WireConnection;262;1;37;2
WireConnection;262;2;82;0
WireConnection;262;3;83;0
WireConnection;262;4;12;0
WireConnection;262;5;33;0
WireConnection;262;6;85;2
WireConnection;262;7;37;3
WireConnection;259;0;260;0
WireConnection;259;1;253;0
WireConnection;259;2;262;5
WireConnection;254;0;259;0
WireConnection;254;1;252;0
WireConnection;256;0;254;0
WireConnection;256;1;255;0
WireConnection;258;0;256;0
WireConnection;258;1;257;0
WireConnection;0;0;262;0
WireConnection;0;1;262;1
WireConnection;0;3;262;3
WireConnection;0;4;262;2
WireConnection;0;5;262;4
WireConnection;0;11;258;0
ASEEND*/
//CHKSM=39BEDCCAA0ACB3E3045BC702C7CB75A372AE0EA7