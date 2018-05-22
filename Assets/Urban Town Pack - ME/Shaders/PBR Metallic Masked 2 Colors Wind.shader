// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "FlamingSands/Transparent/PBR Metallic Masked 2 Colors Wind"
{
	Properties
	{
		_Cutoff( "Mask Clip Value", Float ) = 0.5
		[NoScaleOffset]_AlbedoA("Albedo (A)", 2D) = "white" {}
		[NoScaleOffset]_RMA("RMA", 2D) = "white" {}
		_MetallnessValue("Metallness Value", Float) = 1
		_Glossiness("Glossiness", Float) = 1
		_NormalIntensity("Normal Intensity", Float) = 1
		[NoScaleOffset][Normal]_Normal("Normal", 2D) = "bump" {}
		[NoScaleOffset]_Mask("Mask", 2D) = "white" {}
		_BaseColor("Base Color", Color) = (1,1,1,0)
		_TopColor("Top Color", Color) = (0.3308824,0.5293103,1,0)
		[Header(Wind Shader)]
		[HideInInspector]_windmap("wind map", 2D) = "white" {}
		_WindStrength("Wind Strength", Range( 0 , 0.4)) = 0.1
		_WindRadius("Wind Radius", Range( 0 , 30)) = 10
		_WindSpeed("Wind Speed", Range( 0 , 0.4)) = 0.1
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "TransparentCutout"  "Queue" = "AlphaTest+0" }
		Cull Back
		CGPROGRAM
		#include "UnityStandardUtils.cginc"
		#include "UnityShaderVariables.cginc"
		#pragma target 3.0
		#pragma surface surf Standard keepalpha addshadow fullforwardshadows vertex:vertexDataFunc 
		struct Input
		{
			float2 uv_texcoord;
		};

		uniform float _NormalIntensity;
		uniform sampler2D _Normal;
		uniform sampler2D _AlbedoA;
		uniform float4 _BaseColor;
		uniform sampler2D _Mask;
		uniform float4 _TopColor;
		uniform sampler2D _RMA;
		uniform float _MetallnessValue;
		uniform float _Glossiness;
		uniform float _WindStrength;
		uniform sampler2D _windmap;
		uniform float _WindSpeed;
		uniform float _WindRadius;
		uniform float _Cutoff = 0.5;

		void vertexDataFunc( inout appdata_full v, out Input o )
		{
			UNITY_INITIALIZE_OUTPUT( Input, o );
			float mulTime14_g33 = _Time.y * _WindSpeed;
			float3 ase_worldPos = mul( unity_ObjectToWorld, v.vertex );
			float2 panner15_g33 = ( (( ase_worldPos / _WindRadius )).xz + mulTime14_g33 * float2( 1,1 ));
			v.vertex.xyz += ( v.color.r * ( _WindStrength * tex2Dlod( _windmap, float4( panner15_g33, 0, 1.0) ) ) ).rgb;
		}

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float2 uv_Normal = i.uv_texcoord;
			o.Normal = UnpackScaleNormal( tex2D( _Normal, uv_Normal ) ,_NormalIntensity );
			float2 uv_AlbedoA = i.uv_texcoord;
			float4 tex2DNode1 = tex2D( _AlbedoA, uv_AlbedoA );
			float2 uv_Mask = i.uv_texcoord;
			float4 tex2DNode183 = tex2D( _Mask, uv_Mask );
			float4 lerpResult188 = lerp( tex2DNode1 , ( _BaseColor * tex2DNode1 ) , tex2DNode183.r);
			float4 lerpResult190 = lerp( lerpResult188 , ( _TopColor * tex2DNode1 ) , tex2DNode183.g);
			o.Albedo = lerpResult190.rgb;
			float2 uv_RMA = i.uv_texcoord;
			float4 tex2DNode19 = tex2D( _RMA, uv_RMA );
			float clampResult182 = clamp( ( tex2DNode19.g * _MetallnessValue ) , 0.0 , 1.0 );
			o.Metallic = clampResult182;
			float clampResult181 = clamp( ( tex2DNode19.r * _Glossiness ) , 0.0 , 0.0 );
			o.Smoothness = clampResult181;
			o.Occlusion = tex2DNode19.b;
			o.Alpha = 1;
			clip( tex2DNode1.a - _Cutoff );
		}

		ENDCG
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=13701
0;92;1173;926;1826.958;268.0204;1.67527;True;False
Node;AmplifyShaderEditor.SamplerNode;1;-1158.5,-417.9754;Float;True;Property;_AlbedoA;Albedo (A);1;1;[NoScaleOffset];None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;1.0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1.0;False;5;COLOR;FLOAT;FLOAT;FLOAT;FLOAT
Node;AmplifyShaderEditor.ColorNode;186;-1120,-1008;Float;False;Property;_BaseColor;Base Color;8;0;1,1,1,0;0;5;COLOR;FLOAT;FLOAT;FLOAT;FLOAT
Node;AmplifyShaderEditor.SamplerNode;19;-1158.5,-144.3;Float;True;Property;_RMA;RMA;2;1;[NoScaleOffset];None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;1.0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1.0;False;5;COLOR;FLOAT;FLOAT;FLOAT;FLOAT
Node;AmplifyShaderEditor.SamplerNode;183;-1152,-672;Float;True;Property;_Mask;Mask;7;1;[NoScaleOffset];None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;1.0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1.0;False;5;COLOR;FLOAT;FLOAT;FLOAT;FLOAT
Node;AmplifyShaderEditor.RangedFloatNode;13;-640,-272;Float;False;Property;_Glossiness;Glossiness;4;0;1;0;0;0;1;FLOAT
Node;AmplifyShaderEditor.RangedFloatNode;2;-640,-32;Float;False;Property;_MetallnessValue;Metallness Value;3;0;1;0;0;0;1;FLOAT
Node;AmplifyShaderEditor.ColorNode;185;-1120,-849;Float;False;Property;_TopColor;Top Color;9;0;0.3308824,0.5293103,1,0;0;5;COLOR;FLOAT;FLOAT;FLOAT;FLOAT
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;187;-564.1878,-793.5061;Float;True;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR
Node;AmplifyShaderEditor.RangedFloatNode;9;-1540.5,153.6992;Float;False;Property;_NormalIntensity;Normal Intensity;5;0;1;0;0;0;1;FLOAT
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;189;-262.5575,-895.0348;Float;True;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;6;-384,-48;Float;False;2;2;0;FLOAT;0.0;False;1;FLOAT;0.0;False;1;FLOAT
Node;AmplifyShaderEditor.VertexColorNode;195;-780.0668,269.3735;Float;False;0;5;COLOR;FLOAT;FLOAT;FLOAT;FLOAT
Node;AmplifyShaderEditor.LerpOp;188;-309.2297,-648.9235;Float;True;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0.0,0,0,0;False;1;COLOR
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;12;-384,-288;Float;False;2;2;0;FLOAT;0.0;False;1;FLOAT;0.0;False;1;FLOAT
Node;AmplifyShaderEditor.FunctionNode;230;-777.5396,452.9971;Float;False;Wind Shader;10;;33;0;1;COLOR
Node;AmplifyShaderEditor.ClampOpNode;182;-192,-48;Float;False;3;0;FLOAT;0.0;False;1;FLOAT;0.0;False;2;FLOAT;1.0;False;1;FLOAT
Node;AmplifyShaderEditor.SamplerNode;7;-1150.325,129.6753;Float;True;Property;_Normal;Normal;6;2;[NoScaleOffset];[Normal];None;True;0;True;bump;Auto;True;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;1.0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1.0;False;5;FLOAT3;FLOAT;FLOAT;FLOAT;FLOAT
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;196;-327.0668,348.3735;Float;False;2;2;0;FLOAT;0.0;False;1;COLOR;0;False;1;COLOR
Node;AmplifyShaderEditor.ClampOpNode;181;-192,-304;Float;False;3;0;FLOAT;0.0;False;1;FLOAT;0.0;False;2;FLOAT;0.0;False;1;FLOAT
Node;AmplifyShaderEditor.LerpOp;190;-16.28086,-660.8214;Float;True;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0.0,0,0,0;False;1;COLOR
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;128,0;Float;False;True;2;Float;ASEMaterialInspector;0;0;Standard;FlamingSands/Transparent/PBR Metallic Masked 2 Colors Wind;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;0;False;0;0;Masked;0.5;True;True;0;False;TransparentCutout;AlphaTest;All;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;False;0;255;255;0;0;0;0;0;0;0;0;False;0;4;10;25;False;0.5;True;0;Zero;Zero;0;Zero;Zero;Add;Add;0;False;0;0,0,0,0;VertexOffset;False;Cylindrical;False;Relative;0;;0;-1;-1;-1;0;0;0;False;15;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0.0;False;4;FLOAT;0.0;False;5;FLOAT;0.0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0.0;False;9;FLOAT;0.0;False;10;FLOAT;0.0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;187;0;186;0
WireConnection;187;1;1;0
WireConnection;189;0;185;0
WireConnection;189;1;1;0
WireConnection;6;0;19;2
WireConnection;6;1;2;0
WireConnection;188;0;1;0
WireConnection;188;1;187;0
WireConnection;188;2;183;1
WireConnection;12;0;19;1
WireConnection;12;1;13;0
WireConnection;182;0;6;0
WireConnection;7;5;9;0
WireConnection;196;0;195;1
WireConnection;196;1;230;0
WireConnection;181;0;12;0
WireConnection;190;0;188;0
WireConnection;190;1;189;0
WireConnection;190;2;183;2
WireConnection;0;0;190;0
WireConnection;0;1;7;0
WireConnection;0;3;182;0
WireConnection;0;4;181;0
WireConnection;0;5;19;3
WireConnection;0;10;1;4
WireConnection;0;11;196;0
ASEEND*/
//CHKSM=8D0E9CC6EE3DB1553EAAAB090D1C5C251E117B45