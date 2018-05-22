// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "FlamingSands/PBR Planks Painted AO"
{
	Properties
	{
		_AlbedoColor("Albedo Color", Color) = (1,1,1,0)
		[NoScaleOffset]_Albedo("Albedo", 2D) = "white" {}
		_NormalIntensity("Normal Intensity", Float) = 0
		[NoScaleOffset][Normal]_Normal("Normal", 2D) = "bump" {}
		[NoScaleOffset]_RMA("RMA", 2D) = "white" {}
		_Metallic("Metallic", Range( 0 , 1)) = 0.21
		_Glossiness("Glossiness", Range( 0 , 2)) = 1
		[NoScaleOffset]_PaintMask("Paint Mask", 2D) = "white" {}
		_PaintColor("Paint Color", Color) = (0.2666667,0.427451,0.7411765,0)
		_PaintGlossiness("Paint Glossiness", Range( 0 , 1)) = 0.5
		_PaintIntensity("Paint Intensity", Range( 0 , 1)) = 1
		[NoScaleOffset]_AmbientOcclusion("Ambient Occlusion", 2D) = "white" {}
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
		uniform sampler2D _Albedo;
		uniform float4 _AlbedoColor;
		uniform sampler2D _PaintMask;
		uniform float4 _PaintColor;
		uniform float _PaintIntensity;
		uniform float _Metallic;
		uniform sampler2D _RMA;
		uniform float _Glossiness;
		uniform float _PaintGlossiness;
		uniform sampler2D _AmbientOcclusion;

		void vertexDataFunc( inout appdata_full v, out Input o )
		{
			UNITY_INITIALIZE_OUTPUT( Input, o );
			o.texcoord_0.xy = v.texcoord1.xy * float2( 1,1 ) + float2( 0,0 );
		}

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float2 uv_Normal = i.uv_texcoord;
			float3 tex2DNode9 = UnpackScaleNormal( tex2D( _Normal, uv_Normal ) ,_NormalIntensity );
			float3 appendResult37 = (float3(( tex2DNode9.r * _NormalIntensity ) , ( tex2DNode9.g * _NormalIntensity ) , tex2DNode9.b));
			o.Normal = appendResult37;
			float2 uv_Albedo = i.uv_texcoord;
			float4 tex2DNode1 = tex2D( _Albedo, uv_Albedo );
			float2 uv_PaintMask = i.uv_texcoord;
			float4 tex2DNode20 = tex2D( _PaintMask, uv_PaintMask );
			float4 lerpResult30 = lerp( tex2DNode1 , ( _AlbedoColor * tex2DNode1 ) , tex2DNode20.g);
			float dotResult27 = dot( _PaintIntensity , tex2DNode20.r );
			float4 lerpResult19 = lerp( lerpResult30 , _PaintColor , dotResult27);
			o.Albedo = lerpResult19.rgb;
			float2 uv_RMA = i.uv_texcoord;
			float4 tex2DNode10 = tex2D( _RMA, uv_RMA );
			o.Metallic = ( _Metallic * tex2DNode10.g );
			float lerpResult22 = lerp( ( _Glossiness * tex2DNode10.r ) , _PaintGlossiness , dotResult27);
			o.Smoothness = lerpResult22;
			o.Occlusion = ( tex2D( _AmbientOcclusion, i.texcoord_0 ) * tex2DNode10.b ).r;
			o.Alpha = 1;
		}

		ENDCG
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=13701
0;92;1173;926;1926.294;379.5953;1.722257;True;False
Node;AmplifyShaderEditor.RangedFloatNode;33;-1434.474,373.3259;Float;False;Property;_NormalIntensity;Normal Intensity;2;0;0;0;0;0;1;FLOAT
Node;AmplifyShaderEditor.ColorNode;28;-1216,-368;Float;False;Property;_AlbedoColor;Albedo Color;0;0;1,1,1,0;0;5;COLOR;FLOAT;FLOAT;FLOAT;FLOAT
Node;AmplifyShaderEditor.SamplerNode;1;-1232,-32;Float;True;Property;_Albedo;Albedo;1;1;[NoScaleOffset];None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;1.0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1.0;False;5;COLOR;FLOAT;FLOAT;FLOAT;FLOAT
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;29;-765,-155;Float;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0.0,0,0,0;False;1;COLOR
Node;AmplifyShaderEditor.TextureCoordinatesNode;32;-1296,816;Float;False;1;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;FLOAT;FLOAT;FLOAT;FLOAT
Node;AmplifyShaderEditor.SamplerNode;9;-1232,160;Float;True;Property;_Normal;Normal;3;2;[NoScaleOffset];[Normal];None;True;0;True;bump;Auto;True;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;1.0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1.0;False;5;FLOAT3;FLOAT;FLOAT;FLOAT;FLOAT
Node;AmplifyShaderEditor.RangedFloatNode;13;-615,364;Float;False;Property;_Glossiness;Glossiness;6;0;1;0;2;0;1;FLOAT
Node;AmplifyShaderEditor.SamplerNode;20;-976,544;Float;True;Property;_PaintMask;Paint Mask;7;1;[NoScaleOffset];None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;1.0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1.0;False;5;COLOR;FLOAT;FLOAT;FLOAT;FLOAT
Node;AmplifyShaderEditor.SamplerNode;10;-976,352;Float;True;Property;_RMA;RMA;4;1;[NoScaleOffset];None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;1.0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1.0;False;5;COLOR;FLOAT;FLOAT;FLOAT;FLOAT
Node;AmplifyShaderEditor.RangedFloatNode;24;-900,737;Float;False;Property;_PaintIntensity;Paint Intensity;10;0;1;0;1;0;1;FLOAT
Node;AmplifyShaderEditor.RangedFloatNode;21;-402,572;Float;False;Property;_PaintGlossiness;Paint Glossiness;9;0;0.5;0;1;0;1;FLOAT
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;35;-832,208;Float;False;2;2;0;FLOAT;0.0;False;1;FLOAT;0.0;False;1;FLOAT
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;16;-279,450;Float;False;2;2;0;FLOAT;0.0;False;1;FLOAT;0.0;False;1;FLOAT
Node;AmplifyShaderEditor.LerpOp;30;-576,-113.9;Float;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0.0,0,0,0;False;1;COLOR
Node;AmplifyShaderEditor.SamplerNode;31;-976,816;Float;True;Property;_AmbientOcclusion;Ambient Occlusion;11;1;[NoScaleOffset];None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;1.0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1.0;False;5;COLOR;FLOAT;FLOAT;FLOAT;FLOAT
Node;AmplifyShaderEditor.DotProductOpNode;27;-548,723;Float;False;2;0;FLOAT;0.0;False;1;FLOAT;0.0;False;1;FLOAT
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;34;-832,112;Float;False;2;2;0;FLOAT;0.0;False;1;FLOAT;0.0;False;1;FLOAT
Node;AmplifyShaderEditor.ColorNode;18;-1216,-192;Float;False;Property;_PaintColor;Paint Color;8;0;0.2666667,0.427451,0.7411765,0;0;5;COLOR;FLOAT;FLOAT;FLOAT;FLOAT
Node;AmplifyShaderEditor.RangedFloatNode;12;-637.3,253;Float;False;Property;_Metallic;Metallic;5;0;0.21;0;1;0;1;FLOAT
Node;AmplifyShaderEditor.LerpOp;22;-64,544;Float;False;3;0;FLOAT;0.0;False;1;FLOAT;0.0;False;2;FLOAT;0.0;False;1;FLOAT
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;38;-119.0769,362.5265;Float;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0.0,0,0,0;False;1;COLOR
Node;AmplifyShaderEditor.LerpOp;19;-316,17;Float;False;3;0;COLOR;0.0,0,0,0;False;1;COLOR;0.0,0,0,0;False;2;FLOAT;0.0,0,0,0;False;1;COLOR
Node;AmplifyShaderEditor.DynamicAppendNode;37;-661.9729,92.42603;Float;False;FLOAT3;4;0;FLOAT;0.0;False;1;FLOAT;0.0;False;2;FLOAT;0.0;False;3;FLOAT;0.0;False;1;FLOAT3
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;11;-309,247;Float;False;2;2;0;FLOAT;0.0;False;1;FLOAT;0,0,0,0;False;1;FLOAT
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;304,16;Float;False;True;2;Float;ASEMaterialInspector;0;0;Standard;FlamingSands/PBR Planks Painted AO;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;0;False;0;0;Opaque;0.5;True;True;0;False;Opaque;Geometry;All;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;False;0;255;255;0;0;0;0;0;0;0;0;False;0;4;10;25;False;0.5;True;0;Zero;Zero;0;Zero;Zero;Add;Add;0;False;0;0,0,0,0;VertexOffset;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;0;0;False;15;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0.0;False;4;FLOAT;0.0;False;5;FLOAT;0.0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0.0;False;9;FLOAT;0.0;False;10;FLOAT;0.0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;29;0;28;0
WireConnection;29;1;1;0
WireConnection;9;5;33;0
WireConnection;35;0;9;2
WireConnection;35;1;33;0
WireConnection;16;0;13;0
WireConnection;16;1;10;1
WireConnection;30;0;1;0
WireConnection;30;1;29;0
WireConnection;30;2;20;2
WireConnection;31;1;32;0
WireConnection;27;0;24;0
WireConnection;27;1;20;1
WireConnection;34;0;9;1
WireConnection;34;1;33;0
WireConnection;22;0;16;0
WireConnection;22;1;21;0
WireConnection;22;2;27;0
WireConnection;38;0;31;0
WireConnection;38;1;10;3
WireConnection;19;0;30;0
WireConnection;19;1;18;0
WireConnection;19;2;27;0
WireConnection;37;0;34;0
WireConnection;37;1;35;0
WireConnection;37;2;9;3
WireConnection;11;0;12;0
WireConnection;11;1;10;2
WireConnection;0;0;19;0
WireConnection;0;1;37;0
WireConnection;0;3;11;0
WireConnection;0;4;22;0
WireConnection;0;5;38;0
ASEEND*/
//CHKSM=FBF20F4F01D252FC666E9EC4B90B22DDD54568E1