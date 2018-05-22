// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "FlamingSands/Nature/PBR Metallic Tree"
{
	Properties
	{
		[HideInInspector] _DummyTex2( "", 2D ) = "white" {}
		_VertexAO("Vertex AO", Range( 0 , 1)) = 1
		[NoScaleOffset]_Albedo("Albedo", 2D) = "white" {}
		_MetallnessValue("Metallness Value", Float) = 0
		_Glossiness("Glossiness", Float) = 1
		_NormalIntensity("Normal Intensity", Float) = 1
		[NoScaleOffset][Normal]_Normal("Normal", 2D) = "bump" {}
		[NoScaleOffset]_DetailAlbedo("Detail Albedo", 2D) = "white" {}
		[NoScaleOffset][Normal]_DetailNormal("Detail Normal", 2D) = "white" {}
		[NoScaleOffset]_Height("Height", 2D) = "white" {}
		[NoScaleOffset]_DetailHeight("Detail Height", 2D) = "white" {}
		_TessValue( "Max Tessellation", Range( 1, 32 ) ) = 32
		_TessMin( "Tess Min Distance", Float ) = 5
		_TessMax( "Tess Max Distance", Float ) = 15
		_TessPhongStrength( "Phong Tess Strength", Range( 0, 1 ) ) = 0.5
		_TessellationBias("Tessellation Bias", Range( -1 , 1)) = 0
		_TessellationHeight("Tessellation Height", Range( 0 , 0.2)) = 0.05
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Opaque"  "Queue" = "Geometry+0" }
		Cull Off
		CGPROGRAM
		#include "UnityStandardUtils.cginc"
		#include "Tessellation.cginc"
		#pragma target 5.0
		#pragma surface surf Standard keepalpha addshadow fullforwardshadows vertex:vertexDataFunc tessellate:tessFunction tessphong:_TessPhongStrength 
		struct Input
		{
			float2 uv_texcoord;
			float2 uv2_DummyTex2;
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

		uniform float _NormalIntensity;
		uniform sampler2D _Normal;
		uniform sampler2D _DetailNormal;
		uniform sampler2D _DummyTex2;
		uniform sampler2D _DetailAlbedo;
		uniform sampler2D _Albedo;
		uniform float _VertexAO;
		uniform float _MetallnessValue;
		uniform float _Glossiness;
		uniform sampler2D _Height;
		uniform sampler2D _DetailHeight;
		uniform float _TessellationBias;
		uniform float _TessellationHeight;
		uniform float _TessValue;
		uniform float _TessMin;
		uniform float _TessMax;
		uniform float _TessPhongStrength;

		float4 tessFunction( appdata v0, appdata v1, appdata v2 )
		{
			return UnityDistanceBasedTess( v0.vertex, v1.vertex, v2.vertex, _TessMin, _TessMax, _TessValue );
		}

		void vertexDataFunc( inout appdata v )
		{
			float2 uv_Height = v.texcoord;
			v.texcoord1.xy = v.texcoord1.xy * float2( 1,1 ) + float2( 0,0 );
			float4 tex2DNode29 = tex2Dlod( _DetailAlbedo, float4( v.texcoord1.xy, 0, 0.0) );
			float4 lerpResult40 = lerp( tex2Dlod( _Height, float4( uv_Height, 0, 0.0) ) , tex2Dlod( _DetailHeight, float4( v.texcoord1.xy, 0, 0.0) ) , tex2DNode29.a);
			float3 ase_vertexNormal = v.normal.xyz;
			v.vertex.xyz += ( ( ( lerpResult40 + _TessellationBias ) * float4( ase_vertexNormal , 0.0 ) ) * _TessellationHeight ).rgb;
		}

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float2 uv_Normal = i.uv_texcoord;
			float2 texCoordDummy31 = i.uv2_DummyTex2*float2( 1,1 ) + float2( 0,0 );
			float4 tex2DNode29 = tex2D( _DetailAlbedo, texCoordDummy31 );
			float3 lerpResult33 = lerp( UnpackScaleNormal( tex2D( _Normal, uv_Normal ) ,_NormalIntensity ) , UnpackScaleNormal( tex2D( _DetailNormal, texCoordDummy31 ) ,_NormalIntensity ) , tex2DNode29.a);
			o.Normal = lerpResult33;
			float2 uv_Albedo = i.uv_texcoord;
			float4 lerpResult32 = lerp( tex2D( _Albedo, uv_Albedo ) , tex2DNode29 , tex2DNode29.a);
			float4 lerpResult37 = lerp( lerpResult32 , ( i.vertexColor.r * lerpResult32 ) , _VertexAO);
			o.Albedo = lerpResult37.rgb;
			float clampResult21 = clamp( _MetallnessValue , 0.0 , 1.0 );
			o.Metallic = clampResult21;
			float clampResult20 = clamp( _Glossiness , 0.0 , 1.0 );
			o.Smoothness = clampResult20;
			o.Alpha = 1;
		}

		ENDCG
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=13701
0;92;1173;926;1559.887;167.9597;1.570396;True;False
Node;AmplifyShaderEditor.TextureCoordinatesNode;31;-1354.308,796.7989;Float;False;1;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;FLOAT;FLOAT;FLOAT;FLOAT
Node;AmplifyShaderEditor.SamplerNode;29;-904.5071,653.7991;Float;True;Property;_DetailAlbedo;Detail Albedo;6;1;[NoScaleOffset];None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0.0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1.0;False;5;COLOR;FLOAT;FLOAT;FLOAT;FLOAT
Node;AmplifyShaderEditor.SamplerNode;38;-411.6104,1050.299;Float;True;Property;_Height;Height;8;1;[NoScaleOffset];None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0.0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1.0;False;5;COLOR;FLOAT;FLOAT;FLOAT;FLOAT
Node;AmplifyShaderEditor.SamplerNode;39;-408.0101,1252.095;Float;True;Property;_DetailHeight;Detail Height;9;1;[NoScaleOffset];None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0.0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1.0;False;5;COLOR;FLOAT;FLOAT;FLOAT;FLOAT
Node;AmplifyShaderEditor.LerpOp;40;-2.01062,1198.499;Float;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0.0,0,0,0;False;2;FLOAT;0.0,0,0,0;False;1;COLOR
Node;AmplifyShaderEditor.RangedFloatNode;45;-118.3112,970.2985;Float;False;Property;_TessellationBias;Tessellation Bias;15;0;0;-1;1;0;1;FLOAT
Node;AmplifyShaderEditor.SamplerNode;1;-930.1995,-153.6001;Float;True;Property;_Albedo;Albedo;1;1;[NoScaleOffset];None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;1.0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1.0;False;5;COLOR;FLOAT;FLOAT;FLOAT;FLOAT
Node;AmplifyShaderEditor.RangedFloatNode;9;-1212,506;Float;False;Property;_NormalIntensity;Normal Intensity;4;0;1;0;0;0;1;FLOAT
Node;AmplifyShaderEditor.VertexColorNode;34;-886.4096,157.1988;Float;False;0;5;COLOR;FLOAT;FLOAT;FLOAT;FLOAT
Node;AmplifyShaderEditor.NormalVertexDataNode;42;-101.1105,1354.999;Float;False;0;5;FLOAT3;FLOAT;FLOAT;FLOAT;FLOAT
Node;AmplifyShaderEditor.SimpleAddOpNode;46;167.9884,1148.999;Float;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0.0,0,0,0;False;1;COLOR
Node;AmplifyShaderEditor.LerpOp;32;-188.2062,363.8989;Float;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0.0,0,0,0;False;2;FLOAT;0.0,0,0,0;False;1;COLOR
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;35;66.59184,332.6992;Float;False;2;2;0;FLOAT;0.0;False;1;COLOR;0;False;1;COLOR
Node;AmplifyShaderEditor.RangedFloatNode;2;-896,352;Float;False;Property;_MetallnessValue;Metallness Value;2;0;0;0;0;0;1;FLOAT
Node;AmplifyShaderEditor.RangedFloatNode;13;-896,80;Float;False;Property;_Glossiness;Glossiness;3;0;1;0;0;0;1;FLOAT
Node;AmplifyShaderEditor.RangedFloatNode;43;233.2882,1438.999;Float;False;Property;_TessellationHeight;Tessellation Height;16;0;0.05;0;0.2;0;1;FLOAT
Node;AmplifyShaderEditor.SamplerNode;7;-896,432;Float;True;Property;_Normal;Normal;5;2;[NoScaleOffset];[Normal];None;True;0;True;bump;Auto;True;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;1.0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1.0;False;5;FLOAT3;FLOAT;FLOAT;FLOAT;FLOAT
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;41;278.7894,1214.099;Float;False;2;2;0;COLOR;0.0,0,0,0;False;1;FLOAT3;0.0,0,0,0;False;1;COLOR
Node;AmplifyShaderEditor.RangedFloatNode;36;-241.5068,-72.90104;Float;False;Property;_VertexAO;Vertex AO;0;0;1;0;1;0;1;FLOAT
Node;AmplifyShaderEditor.SamplerNode;30;-924.0076,873.499;Float;True;Property;_DetailNormal;Detail Normal;7;2;[NoScaleOffset];[Normal];None;True;0;False;white;Auto;True;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0.0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1.0;False;5;FLOAT3;FLOAT;FLOAT;FLOAT;FLOAT
Node;AmplifyShaderEditor.LerpOp;33;-179.1062,541.9992;Float;False;3;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT;0,0,0;False;1;FLOAT3
Node;AmplifyShaderEditor.ClampOpNode;20;-192,64;Float;False;3;0;FLOAT;0.0;False;1;FLOAT;0.0;False;2;FLOAT;1.0;False;1;FLOAT
Node;AmplifyShaderEditor.LerpOp;37;295.3928,241.6991;Float;False;3;0;COLOR;0.0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0.0,0,0,0;False;1;COLOR
Node;AmplifyShaderEditor.ClampOpNode;21;-199.8,183.6999;Float;False;3;0;FLOAT;0.0;False;1;FLOAT;0.0;False;2;FLOAT;1.0;False;1;FLOAT
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;44;508.8882,1332.399;Float;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0.0,0,0,0;False;1;COLOR
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;501.1998,33.8;Float;False;True;7;Float;ASEMaterialInspector;0;0;Standard;FlamingSands/Nature/PBR Metallic Tree;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Off;0;0;False;0;0;Opaque;0.5;True;True;0;False;Opaque;Geometry;All;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;False;0;255;255;0;0;0;0;0;0;0;0;True;0;32;5;15;True;0.5;True;0;Zero;Zero;0;Zero;Zero;Add;Add;0;False;0;0,0,0,0;VertexOffset;False;Cylindrical;False;Relative;0;;-1;-1;-1;10;0;0;0;False;15;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0.0;False;4;FLOAT;0.0;False;5;FLOAT;0.0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0.0;False;9;FLOAT;0.0;False;10;FLOAT;0.0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;29;1;31;0
WireConnection;39;1;31;0
WireConnection;40;0;38;0
WireConnection;40;1;39;0
WireConnection;40;2;29;4
WireConnection;46;0;40;0
WireConnection;46;1;45;0
WireConnection;32;0;1;0
WireConnection;32;1;29;0
WireConnection;32;2;29;4
WireConnection;35;0;34;1
WireConnection;35;1;32;0
WireConnection;7;5;9;0
WireConnection;41;0;46;0
WireConnection;41;1;42;0
WireConnection;30;1;31;0
WireConnection;30;5;9;0
WireConnection;33;0;7;0
WireConnection;33;1;30;0
WireConnection;33;2;29;4
WireConnection;20;0;13;0
WireConnection;37;0;32;0
WireConnection;37;1;35;0
WireConnection;37;2;36;0
WireConnection;21;0;2;0
WireConnection;44;0;41;0
WireConnection;44;1;43;0
WireConnection;0;0;37;0
WireConnection;0;1;33;0
WireConnection;0;3;21;0
WireConnection;0;4;20;0
WireConnection;0;11;44;0
ASEEND*/
//CHKSM=A511F0B55E820A84E503446601CE150A8E22C9B9