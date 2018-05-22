// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "FlamingSands/PBR Metallic Emissive Flicker"
{
	Properties
	{
		[NoScaleOffset]_Albedo("Albedo", 2D) = "white" {}
		_MetallnessValue("Metallness Value", Float) = 0
		_Glossiness("Glossiness", Float) = 1
		[NoScaleOffset]_RMAA("RMA (A)", 2D) = "white" {}
		_NormalIntensity("Normal Intensity", Float) = 1
		[NoScaleOffset][Normal]_Normal("Normal", 2D) = "bump" {}
		_Tiling("Tiling", Float) = 1
		_Emission("Emission", Float) = 1
		[HDR]_EmmisiveColor("Emmisive Color", Color) = (0,0,0,0)
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Opaque"  "Queue" = "Geometry+0" "IsEmissive" = "true"  }
		Cull Back
		CGPROGRAM
		#include "UnityStandardUtils.cginc"
		#include "UnityShaderVariables.cginc"
		#pragma target 3.0
		#pragma surface surf Standard keepalpha addshadow fullforwardshadows vertex:vertexDataFunc 
		struct Input
		{
			float2 texcoord_0;
		};

		uniform float _NormalIntensity;
		uniform sampler2D _Normal;
		uniform float _Tiling;
		uniform sampler2D _Albedo;
		uniform sampler2D _RMAA;
		uniform float _Emission;
		uniform float4 _EmmisiveColor;
		uniform float _MetallnessValue;
		uniform float _Glossiness;

		void vertexDataFunc( inout appdata_full v, out Input o )
		{
			UNITY_INITIALIZE_OUTPUT( Input, o );
			float2 temp_cast_0 = (_Tiling).xx;
			o.texcoord_0.xy = v.texcoord.xy * temp_cast_0 + float2( 0,0 );
		}

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			o.Normal = UnpackScaleNormal( tex2D( _Normal, i.texcoord_0 ) ,_NormalIntensity );
			float4 tex2DNode1 = tex2D( _Albedo, i.texcoord_0 );
			o.Albedo = tex2DNode1.rgb;
			float4 tex2DNode19 = tex2D( _RMAA, i.texcoord_0 );
			float temp_output_40_0 = ( 5.0 * _Time.y );
			float clampResult45 = clamp( ( 1.0 - radians( ( tan( temp_output_40_0 ) * sin( temp_output_40_0 ) ) ) ) , 0.25 , 1.0 );
			float clampResult25 = clamp( ( tex2DNode19.a * ( _Emission * clampResult45 ) ) , 0 , 1 );
			o.Emission = ( ( clampResult25 * _EmmisiveColor ) * ( tex2DNode1 * 0.5 ) ).rgb;
			float clampResult23 = clamp( ( tex2DNode19.g * _MetallnessValue ) , 0.0 , 1.0 );
			o.Metallic = clampResult23;
			float clampResult24 = clamp( ( tex2DNode19.r * _Glossiness ) , 0.0 , 1.0 );
			o.Smoothness = clampResult24;
			o.Occlusion = tex2DNode19.b;
			o.Alpha = 1;
		}

		ENDCG
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=13701
0;92;1173;926;1454.435;57.12105;1.083916;True;False
Node;AmplifyShaderEditor.RangedFloatNode;39;-2499.212,577.399;Float;False;Constant;_Speed;Speed;8;0;5;0;0;0;1;FLOAT
Node;AmplifyShaderEditor.TimeNode;41;-2541.212,682.399;Float;False;0;5;FLOAT4;FLOAT;FLOAT;FLOAT;FLOAT
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;40;-2223.212,614.399;Float;True;2;2;0;FLOAT;0.0;False;1;FLOAT;0.0;False;1;FLOAT
Node;AmplifyShaderEditor.TanOpNode;48;-1982.913,617.2994;Float;True;1;0;FLOAT;0.0;False;1;FLOAT
Node;AmplifyShaderEditor.SinOpNode;50;-1978.913,866.2994;Float;True;1;0;FLOAT;0.0;False;1;FLOAT
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;51;-1764.913,727.2994;Float;True;2;2;0;FLOAT;0.0;False;1;FLOAT;0.0;False;1;FLOAT
Node;AmplifyShaderEditor.RadiansOpNode;54;-1476.913,743.2993;Float;True;1;0;FLOAT;0.0;False;1;FLOAT
Node;AmplifyShaderEditor.OneMinusNode;46;-1234.913,648.2994;Float;True;1;0;FLOAT;0.0;False;1;FLOAT
Node;AmplifyShaderEditor.RangedFloatNode;56;-1972.318,80.59918;Float;False;Property;_Tiling;Tiling;6;0;1;0;0;0;1;FLOAT
Node;AmplifyShaderEditor.RangedFloatNode;22;-1072,352;Float;False;Property;_Emission;Emission;7;0;1;0;0;0;1;FLOAT
Node;AmplifyShaderEditor.ClampOpNode;45;-1072.213,657.399;Float;True;3;0;FLOAT;0.0;False;1;FLOAT;0.25;False;2;FLOAT;1.0;False;1;FLOAT
Node;AmplifyShaderEditor.TextureCoordinatesNode;55;-1731.318,61.59918;Float;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;FLOAT;FLOAT;FLOAT;FLOAT
Node;AmplifyShaderEditor.SamplerNode;19;-1104,158.6161;Float;True;Property;_RMAA;RMA (A);3;1;[NoScaleOffset];None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;1.0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1.0;False;5;COLOR;FLOAT;FLOAT;FLOAT;FLOAT
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;44;-720,544;Float;False;2;2;0;FLOAT;0.0;False;1;FLOAT;0.0;False;1;FLOAT
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;21;-480,240;Float;False;2;2;0;FLOAT;0.0;False;1;FLOAT;0.0;False;1;FLOAT
Node;AmplifyShaderEditor.RangedFloatNode;30;-332,-101;Float;False;Constant;_Float0;Float 0;8;0;0.5;0;0;0;1;FLOAT
Node;AmplifyShaderEditor.SamplerNode;1;-1104,-114.3839;Float;True;Property;_Albedo;Albedo;0;1;[NoScaleOffset];None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;1.0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1.0;False;5;COLOR;FLOAT;FLOAT;FLOAT;FLOAT
Node;AmplifyShaderEditor.ClampOpNode;25;-303,241;Float;False;3;0;FLOAT;0.0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT
Node;AmplifyShaderEditor.RangedFloatNode;13;-768,128;Float;False;Property;_Glossiness;Glossiness;2;0;1;0;0;0;1;FLOAT
Node;AmplifyShaderEditor.RangedFloatNode;2;-768,0;Float;False;Property;_MetallnessValue;Metallness Value;1;0;0;0;0;0;1;FLOAT
Node;AmplifyShaderEditor.ColorNode;27;-768,368;Float;False;Property;_EmmisiveColor;Emmisive Color;8;1;[HDR];0,0,0,0;0;5;COLOR;FLOAT;FLOAT;FLOAT;FLOAT
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;6;-480,-16;Float;False;2;2;0;FLOAT;0.0;False;1;FLOAT;0.0;False;1;FLOAT
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;31;-88,14;Float;True;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0.0,0,0,0;False;1;COLOR
Node;AmplifyShaderEditor.RangedFloatNode;9;-1344,512;Float;False;Property;_NormalIntensity;Normal Intensity;4;0;1;0;0;0;1;FLOAT
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;12;-480,112;Float;False;2;2;0;FLOAT;0.0;False;1;FLOAT;0.0;False;1;FLOAT
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;28;-80,240;Float;True;2;2;0;FLOAT;0.0;False;1;COLOR;0;False;1;COLOR
Node;AmplifyShaderEditor.ClampOpNode;24;-304,112;Float;False;3;0;FLOAT;0.0;False;1;FLOAT;0.0;False;2;FLOAT;1.0;False;1;FLOAT
Node;AmplifyShaderEditor.SamplerNode;7;-1088,429.5322;Float;True;Property;_Normal;Normal;5;2;[NoScaleOffset];[Normal];None;True;0;True;bump;Auto;True;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;1.0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1.0;False;5;FLOAT3;FLOAT;FLOAT;FLOAT;FLOAT
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;29;171.587,199.7992;Float;True;2;2;0;COLOR;0.0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR
Node;AmplifyShaderEditor.ClampOpNode;23;-304,-16;Float;False;3;0;FLOAT;0.0;False;1;FLOAT;0.0;False;2;FLOAT;1.0;False;1;FLOAT
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;381,-1;Float;False;True;2;Float;ASEMaterialInspector;0;0;Standard;FlamingSands/PBR Metallic Emissive Flicker;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;0;False;0;0;Opaque;0.55;True;True;0;False;Opaque;Geometry;All;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;False;0;255;255;0;0;0;0;0;0;0;0;False;0;4;10;25;False;0.5;True;0;Zero;Zero;0;Zero;Zero;Add;Add;0;False;0;0,0,0,0;VertexOffset;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;0;0;False;15;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0.0;False;4;FLOAT;0.0;False;5;FLOAT;0.0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0.0;False;9;FLOAT;0.0;False;10;FLOAT;0.0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;40;0;39;0
WireConnection;40;1;41;2
WireConnection;48;0;40;0
WireConnection;50;0;40;0
WireConnection;51;0;48;0
WireConnection;51;1;50;0
WireConnection;54;0;51;0
WireConnection;46;0;54;0
WireConnection;45;0;46;0
WireConnection;55;0;56;0
WireConnection;19;1;55;0
WireConnection;44;0;22;0
WireConnection;44;1;45;0
WireConnection;21;0;19;4
WireConnection;21;1;44;0
WireConnection;1;1;55;0
WireConnection;25;0;21;0
WireConnection;6;0;19;2
WireConnection;6;1;2;0
WireConnection;31;0;1;0
WireConnection;31;1;30;0
WireConnection;12;0;19;1
WireConnection;12;1;13;0
WireConnection;28;0;25;0
WireConnection;28;1;27;0
WireConnection;24;0;12;0
WireConnection;7;1;55;0
WireConnection;7;5;9;0
WireConnection;29;0;28;0
WireConnection;29;1;31;0
WireConnection;23;0;6;0
WireConnection;0;0;1;0
WireConnection;0;1;7;0
WireConnection;0;2;29;0
WireConnection;0;3;23;0
WireConnection;0;4;24;0
WireConnection;0;5;19;3
ASEEND*/
//CHKSM=CA40C521B11D8013DA445A58C2A6455ABDC81862