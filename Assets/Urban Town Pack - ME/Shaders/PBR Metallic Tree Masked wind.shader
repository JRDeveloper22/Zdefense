// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "FlamingSands/Nature/PBR Metallic Tree Masked wind"
{
	Properties
	{
		[Header(Wind Shader Foliage)]
		[HideInInspector]_windmap("wind map", 2D) = "white" {}
		_WindStrength("Wind Strength", Range( 0 , 0.4)) = 0.1
		_WindRadius("Wind Radius", Range( 0 , 30)) = 10
		_WindSpeed("Wind Speed", Range( 0 , 0.4)) = 0.1
		_VertexAO("Vertex AO", Range( 0 , 1)) = 1
		_Cutoff( "Mask Clip Value", Float ) = 0.25
		[NoScaleOffset]_AlbedoA("Albedo (A)", 2D) = "white" {}
		_MetallnessValue("Metallness Value", Float) = 1
		_Glossiness("Glossiness", Float) = 1
		_NormalIntensity("Normal Intensity", Float) = 1
		[NoScaleOffset][Normal]_Normal("Normal", 2D) = "bump" {}
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "TransparentCutout"  "Queue" = "AlphaTest+0" }
		Cull Off
		CGPROGRAM
		#include "UnityStandardUtils.cginc"
		#include "UnityShaderVariables.cginc"
		#pragma target 3.0
		#pragma surface surf Standard keepalpha addshadow fullforwardshadows vertex:vertexDataFunc 
		struct Input
		{
			float2 uv_texcoord;
			float4 vertexColor : COLOR;
			float2 texcoord_0;
		};

		uniform float _NormalIntensity;
		uniform sampler2D _Normal;
		uniform sampler2D _AlbedoA;
		uniform float _VertexAO;
		uniform float _MetallnessValue;
		uniform float _Glossiness;
		uniform float _WindStrength;
		uniform sampler2D _windmap;
		uniform float _WindSpeed;
		uniform float _WindRadius;
		uniform float _Cutoff = 0.25;

		void vertexDataFunc( inout appdata_full v, out Input o )
		{
			UNITY_INITIALIZE_OUTPUT( Input, o );
			float mulTime14_g8 = _Time.y * _WindSpeed;
			float3 ase_worldPos = mul( unity_ObjectToWorld, v.vertex );
			float2 panner15_g8 = ( (( ase_worldPos / _WindRadius )).xz + mulTime14_g8 * float2( 1,1 ));
			float4 temp_cast_0 = (0.0).xxxx;
			o.texcoord_0.xy = v.texcoord.xy * float2( 1,1 ) + float2( 0,0 );
			float4 lerpResult10_g8 = lerp( ( _WindStrength * tex2Dlod( _windmap, float4( panner15_g8, 0, 1.0) ) ) , temp_cast_0 , pow( ( 1.0 - (o.texcoord_0).y ) , 4.0 ));
			v.vertex.xyz += ( v.color.r * lerpResult10_g8 ).rgb;
		}

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float2 uv_Normal = i.uv_texcoord;
			o.Normal = UnpackScaleNormal( tex2D( _Normal, uv_Normal ) ,_NormalIntensity );
			float2 uv_AlbedoA = i.uv_texcoord;
			float4 tex2DNode1 = tex2D( _AlbedoA, uv_AlbedoA );
			float4 lerpResult298 = lerp( tex2DNode1 , ( tex2DNode1 * i.vertexColor.r ) , _VertexAO);
			o.Albedo = lerpResult298.rgb;
			float clampResult182 = clamp( _MetallnessValue , 0.0 , 1.0 );
			o.Metallic = clampResult182;
			float clampResult181 = clamp( _Glossiness , 0.0 , 0.0 );
			o.Smoothness = clampResult181;
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
0;92;1173;926;2254.291;877.7803;2.047435;True;False
Node;AmplifyShaderEditor.VertexColorNode;290;-681.6775,435.3477;Float;False;0;5;COLOR;FLOAT;FLOAT;FLOAT;FLOAT
Node;AmplifyShaderEditor.SamplerNode;1;-1158.5,-416.3001;Float;True;Property;_AlbedoA;Albedo (A);7;1;[NoScaleOffset];None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;1.0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1.0;False;5;COLOR;FLOAT;FLOAT;FLOAT;FLOAT
Node;AmplifyShaderEditor.RangedFloatNode;9;-1540.5,153.6992;Float;False;Property;_NormalIntensity;Normal Intensity;10;0;1;0;0;0;1;FLOAT
Node;AmplifyShaderEditor.RangedFloatNode;299;-722.6223,-498.276;Float;False;Property;_VertexAO;Vertex AO;5;0;1;0;1;0;1;FLOAT
Node;AmplifyShaderEditor.FunctionNode;303;-706.5403,636.4227;Float;False;Wind Shader Foliage;0;;8;0;1;COLOR
Node;AmplifyShaderEditor.RangedFloatNode;2;-640,-32;Float;False;Property;_MetallnessValue;Metallness Value;8;0;1;0;0;0;1;FLOAT
Node;AmplifyShaderEditor.RangedFloatNode;13;-640,-272;Float;False;Property;_Glossiness;Glossiness;9;0;1;0;0;0;1;FLOAT
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;291;-606.5143,-362.613;Float;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0.0,0,0,0;False;1;COLOR
Node;AmplifyShaderEditor.RangedFloatNode;301;-363.7389,200.9451;Float;False;Constant;_Float0;Float 0;8;0;1;0;0;0;1;FLOAT
Node;AmplifyShaderEditor.LerpOp;300;-172.6223,178.724;Float;False;3;0;FLOAT;0.0;False;1;FLOAT;0.0;False;2;FLOAT;0.0;False;1;FLOAT
Node;AmplifyShaderEditor.SamplerNode;7;-1142.5,127.6998;Float;True;Property;_Normal;Normal;11;2;[NoScaleOffset];[Normal];None;True;0;True;bump;Auto;True;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;1.0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1.0;False;5;FLOAT3;FLOAT;FLOAT;FLOAT;FLOAT
Node;AmplifyShaderEditor.ClampOpNode;182;-192,-48;Float;False;3;0;FLOAT;0.0;False;1;FLOAT;0.0;False;2;FLOAT;1.0;False;1;FLOAT
Node;AmplifyShaderEditor.ClampOpNode;181;-192,-304;Float;False;3;0;FLOAT;0.0;False;1;FLOAT;0.0;False;2;FLOAT;0.0;False;1;FLOAT
Node;AmplifyShaderEditor.LerpOp;298;-396.6223,-447.276;Float;False;3;0;COLOR;0.0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0.0,0,0,0;False;1;COLOR
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;289;-275.4776,557.7478;Float;False;2;2;0;FLOAT;0.0;False;1;COLOR;0;False;1;COLOR
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;128,0;Float;False;True;2;Float;ASEMaterialInspector;0;0;Standard;FlamingSands/Nature/PBR Metallic Tree Masked wind;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Off;0;0;False;0;0;Masked;0.25;True;True;0;False;TransparentCutout;AlphaTest;All;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;False;0;255;255;0;0;0;0;0;0;0;0;False;0;4;10;25;False;0.5;True;0;Zero;Zero;0;Zero;Zero;Add;Add;0;False;0;0,0,0,0;VertexOffset;False;Cylindrical;False;Relative;0;;6;-1;-1;-1;0;0;0;False;15;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0.0;False;4;FLOAT;0.0;False;5;FLOAT;0.0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0.0;False;9;FLOAT;0.0;False;10;FLOAT;0.0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;291;0;1;0
WireConnection;291;1;290;1
WireConnection;300;0;301;0
WireConnection;300;1;290;1
WireConnection;300;2;299;0
WireConnection;7;5;9;0
WireConnection;182;0;2;0
WireConnection;181;0;13;0
WireConnection;298;0;1;0
WireConnection;298;1;291;0
WireConnection;298;2;299;0
WireConnection;289;0;290;1
WireConnection;289;1;303;0
WireConnection;0;0;298;0
WireConnection;0;1;7;0
WireConnection;0;3;182;0
WireConnection;0;4;181;0
WireConnection;0;10;1;4
WireConnection;0;11;289;0
ASEEND*/
//CHKSM=B816021EF6CDA0DDFFF3D645500C3B11E41E332E