// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "FlamingSands/PBR Metallic Blend Two Layers Puddles POM"
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
		_Layer1Scale("Layer 1 Scale", Range( 0 , 1)) = 0.03
		_Layer1Bias("Layer 1 Bias", Range( -1 , 1)) = 0
		_Layer2Scale("Layer 2 Scale", Range( 0 , 1)) = 0.03
		_Layer2Bias("Layer 2 Bias", Range( -1 , 1)) = 0
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Opaque"  "Queue" = "Geometry+0" }
		Cull Back
		CGINCLUDE
		#include "UnityStandardUtils.cginc"
		#include "UnityShaderVariables.cginc"
		#include "UnityPBSLighting.cginc"
		#include "Lighting.cginc"
		#pragma target 3.0
		#pragma shader_feature _INVERTHEIGHT_ON
		#pragma shader_feature _INVERTDEPTH_ON
		#ifdef UNITY_PASS_SHADOWCASTER
			#undef INTERNAL_DATA
			#undef WorldReflectionVector
			#undef WorldNormalVector
			#define INTERNAL_DATA half3 internalSurfaceTtoW0; half3 internalSurfaceTtoW1; half3 internalSurfaceTtoW2;
			#define WorldReflectionVector(data,normal) reflect (data.worldRefl, half3(dot(data.internalSurfaceTtoW0,normal), dot(data.internalSurfaceTtoW1,normal), dot(data.internalSurfaceTtoW2,normal)))
			#define WorldNormalVector(data,normal) fixed3(dot(data.internalSurfaceTtoW0,normal), dot(data.internalSurfaceTtoW1,normal), dot(data.internalSurfaceTtoW2,normal))
		#endif
		struct Input
		{
			float3 worldPos;
			float2 texcoord_0;
			float3 viewDir;
			INTERNAL_DATA
			float3 worldNormal;
			float2 texcoord_1;
			float4 vertexColor : COLOR;
		};

		uniform sampler2D _WaterNormal;
		uniform float _NormalIntensity;
		uniform sampler2D _Normal2;
		uniform float _Layer2Tiling;
		uniform sampler2D _RMA2;
		uniform float _Layer2Scale;
		uniform float _Layer2Bias;
		uniform float4 _RMA2_ST;
		uniform sampler2D _Normal;
		uniform float _Layer1Tiling;
		uniform sampler2D _RMA;
		uniform float _Layer1Scale;
		uniform float _Layer1Bias;
		uniform float4 _RMA_ST;
		uniform float _HeightContrast;
		uniform sampler2D _Albedo2;
		uniform sampler2D _Albedo;
		uniform float4 _PuddlesColorDepth;
		uniform float4 _WetnessColor;
		uniform float _Metallic;
		uniform float _PuddlesSmoothness;
		uniform float _Glossiness;
		uniform float _WetnessSmoothness;


		inline float2 POM( sampler2D heightMap, float2 uvs, float2 dx, float2 dy, float3 normalWorld, float3 viewWorld, float3 viewDirTan, int minSamples, int maxSamples, float parallax, float refPlane, float2 tilling, float2 curv, int index )
		{
			float3 result = 0;
			int stepIndex = 0;
			int numSteps = ( int )lerp( (float)maxSamples, (float)minSamples, (float)dot( normalWorld, viewWorld ) );
			float layerHeight = 1.0 / numSteps;
			float2 plane = parallax * ( viewDirTan.xy / viewDirTan.z );
			uvs += refPlane * plane;
			float2 deltaTex = -plane * layerHeight;
			float2 prevTexOffset = 0;
			float prevRayZ = 1.0f;
			float prevHeight = 0.0f;
			float2 currTexOffset = deltaTex;
			float currRayZ = 1.0f - layerHeight;
			float currHeight = 0.0f;
			float intersection = 0;
			float2 finalTexOffset = 0;
			while ( stepIndex < numSteps + 1 )
			{
				currHeight = tex2Dgrad( heightMap, uvs + currTexOffset, dx, dy ).a;
				if ( currHeight > currRayZ )
				{
					stepIndex = numSteps + 1;
				}
				else
				{
					stepIndex++;
					prevTexOffset = currTexOffset;
					prevRayZ = currRayZ;
					prevHeight = currHeight;
					currTexOffset += deltaTex;
					currRayZ -= layerHeight;
				}
			}
			int sectionSteps = 2;
			int sectionIndex = 0;
			float newZ = 0;
			float newHeight = 0;
			while ( sectionIndex < sectionSteps )
			{
				intersection = ( prevHeight - prevRayZ ) / ( prevHeight - currHeight + currRayZ - prevRayZ );
				finalTexOffset = prevTexOffset + intersection * deltaTex;
				newZ = prevRayZ - intersection * layerHeight;
				newHeight = tex2Dgrad( heightMap, uvs + finalTexOffset, dx, dy ).a;
				if ( newHeight > newZ )
				{
					currTexOffset = finalTexOffset;
					currHeight = newHeight;
					currRayZ = newZ;
					deltaTex = intersection * deltaTex;
					layerHeight = intersection * layerHeight;
				}
				else
				{
					prevTexOffset = finalTexOffset;
					prevHeight = newHeight;
					prevRayZ = newZ;
					deltaTex = ( 1 - intersection ) * deltaTex;
					layerHeight = ( 1 - intersection ) * layerHeight;
				}
				sectionIndex++;
			}
			return uvs + finalTexOffset;
		}


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
			float3 ase_worldNormal = WorldNormalVector( i, float3( 0, 0, 1 ) );
			float3 worldViewDir = normalize( UnityWorldSpaceViewDir( i.worldPos ) );
			float2 OffsetPOM231 = POM( _RMA2, i.texcoord_0, ddx(i.texcoord_0), ddx(i.texcoord_0), ase_worldNormal, worldViewDir, i.viewDir, 8, 32, _Layer2Scale, _Layer2Bias, _RMA2_ST.xy, float2(0,0), 0.0 );
			float2 OffsetPOM229 = POM( _RMA, i.texcoord_1, ddx(i.texcoord_1), ddx(i.texcoord_1), ase_worldNormal, worldViewDir, i.viewDir, 8, 32, _Layer1Scale, _Layer1Bias, _RMA_ST.xy, float2(0,0), 0.0 );
			float4 tex2DNode32 = tex2D( _RMA, OffsetPOM229 );
			float temp_output_15_0_g291 = ( 1.0 - tex2DNode32.a );
			#ifdef _INVERTHEIGHT_ON
				float staticSwitch19_g291 = temp_output_15_0_g291;
			#else
				float staticSwitch19_g291 = ( 1.0 - temp_output_15_0_g291 );
			#endif
			float clampResult8_g291 = clamp( ( ( staticSwitch19_g291 - 1.0 ) + ( i.vertexColor.r * 2.0 ) ) , 0.0 , 1.0 );
			float4 temp_cast_0 = (clampResult8_g291).xxxx;
			float4 clampResult10_g291 = clamp( CalculateContrast(_HeightContrast,temp_cast_0) , float4( 0,0,0,0 ) , float4( 1,0,0,0 ) );
			float temp_output_89_0 = ( 1.0 - (clampResult10_g291).r );
			float3 lerpResult83 = lerp( UnpackScaleNormal( tex2D( _Normal2, OffsetPOM231, ddx( i.texcoord_0 ), ddy( i.texcoord_0 ) ) ,_NormalIntensity ) , UnpackScaleNormal( tex2D( _Normal, OffsetPOM229, ddx( i.texcoord_1 ), ddy( i.texcoord_1 ) ) ,_NormalIntensity ) , temp_output_89_0);
			float4 lerpResult84 = lerp( tex2D( _RMA2, OffsetPOM231 ) , tex2DNode32 , temp_output_89_0);
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
			float4 lerpResult82 = lerp( tex2D( _Albedo2, OffsetPOM231 ) , tex2D( _Albedo, OffsetPOM229 ) , temp_output_89_0);
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
		CGPROGRAM
		#pragma surface surf Standard keepalpha fullforwardshadows vertex:vertexDataFunc 

		ENDCG
		Pass
		{
			Name "ShadowCaster"
			Tags{ "LightMode" = "ShadowCaster" }
			ZWrite On
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#pragma target 3.0
			#pragma multi_compile_shadowcaster
			#pragma multi_compile UNITY_PASS_SHADOWCASTER
			#pragma skip_variants FOG_LINEAR FOG_EXP FOG_EXP2
			# include "HLSLSupport.cginc"
			#if ( SHADER_API_D3D11 || SHADER_API_GLCORE || SHADER_API_GLES3 || SHADER_API_METAL || SHADER_API_VULKAN )
				#define CAN_SKIP_VPOS
			#endif
			#include "UnityCG.cginc"
			#include "Lighting.cginc"
			#include "UnityPBSLighting.cginc"
			sampler3D _DitherMaskLOD;
			struct v2f
			{
				V2F_SHADOW_CASTER;
				float4 tSpace0 : TEXCOORD1;
				float4 tSpace1 : TEXCOORD2;
				float4 tSpace2 : TEXCOORD3;
				UNITY_VERTEX_INPUT_INSTANCE_ID
			};
			v2f vert( appdata_full v )
			{
				v2f o;
				UNITY_SETUP_INSTANCE_ID( v );
				UNITY_INITIALIZE_OUTPUT( v2f, o );
				UNITY_TRANSFER_INSTANCE_ID( v, o );
				Input customInputData;
				vertexDataFunc( v, customInputData );
				float3 worldPos = mul( unity_ObjectToWorld, v.vertex ).xyz;
				fixed3 worldNormal = UnityObjectToWorldNormal( v.normal );
				fixed3 worldTangent = UnityObjectToWorldDir( v.tangent.xyz );
				fixed tangentSign = v.tangent.w * unity_WorldTransformParams.w;
				fixed3 worldBinormal = cross( worldNormal, worldTangent ) * tangentSign;
				o.tSpace0 = float4( worldTangent.x, worldBinormal.x, worldNormal.x, worldPos.x );
				o.tSpace1 = float4( worldTangent.y, worldBinormal.y, worldNormal.y, worldPos.y );
				o.tSpace2 = float4( worldTangent.z, worldBinormal.z, worldNormal.z, worldPos.z );
				TRANSFER_SHADOW_CASTER_NORMALOFFSET( o )
				return o;
			}
			fixed4 frag( v2f IN
			#if !defined( CAN_SKIP_VPOS )
			, UNITY_VPOS_TYPE vpos : VPOS
			#endif
			) : SV_Target
			{
				UNITY_SETUP_INSTANCE_ID( IN );
				Input surfIN;
				UNITY_INITIALIZE_OUTPUT( Input, surfIN );
				float3 worldPos = float3( IN.tSpace0.w, IN.tSpace1.w, IN.tSpace2.w );
				fixed3 worldViewDir = normalize( UnityWorldSpaceViewDir( worldPos ) );
				surfIN.viewDir = IN.tSpace0.xyz * worldViewDir.x + IN.tSpace1.xyz * worldViewDir.y + IN.tSpace2.xyz * worldViewDir.z;
				surfIN.worldPos = worldPos;
				surfIN.worldNormal = float3( IN.tSpace0.z, IN.tSpace1.z, IN.tSpace2.z );
				surfIN.internalSurfaceTtoW0 = IN.tSpace0.xyz;
				surfIN.internalSurfaceTtoW1 = IN.tSpace1.xyz;
				surfIN.internalSurfaceTtoW2 = IN.tSpace2.xyz;
				SurfaceOutputStandard o;
				UNITY_INITIALIZE_OUTPUT( SurfaceOutputStandard, o )
				surf( surfIN, o );
				#if defined( CAN_SKIP_VPOS )
				float2 vpos = IN.pos;
				#endif
				SHADOW_CASTER_FRAGMENT( IN )
			}
			ENDCG
		}
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=13701
0;92;1173;926;2189.259;82.72348;1.497401;True;False
Node;AmplifyShaderEditor.RangedFloatNode;76;-2274.461,-12.03707;Float;False;Property;_Layer1Tiling;Layer 1 Tiling;0;0;1;0;0;0;1;FLOAT
Node;AmplifyShaderEditor.TextureCoordinatesNode;211;-2017.971,-21.86765;Float;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;FLOAT;FLOAT;FLOAT;FLOAT
Node;AmplifyShaderEditor.TexturePropertyNode;217;-2040.35,-264.2389;Float;True;Property;_RMA;RMA;5;1;[NoScaleOffset];None;False;white;Auto;0;1;SAMPLER2D
Node;AmplifyShaderEditor.ViewDirInputsCoordNode;230;-1989.049,337.9484;Float;False;Tangent;0;4;FLOAT3;FLOAT;FLOAT;FLOAT
Node;AmplifyShaderEditor.RangedFloatNode;228;-2064.187,258.0784;Float;False;Property;_Layer1Bias;Layer 1 Bias;22;0;0;-1;1;0;1;FLOAT
Node;AmplifyShaderEditor.RangedFloatNode;227;-2062.187,181.6229;Float;False;Property;_Layer1Scale;Layer 1 Scale;21;0;0.03;0;1;0;1;FLOAT
Node;AmplifyShaderEditor.ParallaxOcclusionMappingNode;229;-1547.246,-277.1167;Float;False;3;8;32;2;0.02;0;False;1,1;False;0,0;False;7;0;FLOAT2;0,0;False;1;SAMPLER2D;;False;2;FLOAT;0.02;False;3;FLOAT3;0,0,0;False;4;FLOAT;0.0;False;5;FLOAT2;0,0;False;6;FLOAT;0.0;False;1;FLOAT2
Node;AmplifyShaderEditor.RangedFloatNode;118;-2187.954,749.2957;Float;False;Property;_Layer2Tiling;Layer 2 Tiling;1;0;1;0;0;0;1;FLOAT
Node;AmplifyShaderEditor.SamplerNode;32;-945.4108,-96;Float;True;Property;_RMA_t2d;RMA_t2d;5;1;[NoScaleOffset];None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;1.0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1.0;False;5;COLOR;FLOAT;FLOAT;FLOAT;FLOAT
Node;AmplifyShaderEditor.TextureCoordinatesNode;213;-1930.475,727.941;Float;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;FLOAT;FLOAT;FLOAT;FLOAT
Node;AmplifyShaderEditor.VertexColorNode;37;-855.6008,-497.4376;Float;False;0;5;COLOR;FLOAT;FLOAT;FLOAT;FLOAT
Node;AmplifyShaderEditor.OneMinusNode;238;-578.8496,-137.7491;Float;False;1;0;FLOAT;0.0;False;1;FLOAT
Node;AmplifyShaderEditor.RangedFloatNode;241;-1962.296,923.6134;Float;False;Property;_Layer2Scale;Layer 2 Scale;23;0;0.03;0;1;0;1;FLOAT
Node;AmplifyShaderEditor.RangedFloatNode;242;-1998.296,989.069;Float;False;Property;_Layer2Bias;Layer 2 Bias;24;0;0;-1;1;0;1;FLOAT
Node;AmplifyShaderEditor.TexturePropertyNode;224;-1927.096,529.2813;Float;True;Property;_RMA2;RMA 2;9;1;[NoScaleOffset];None;False;white;Auto;0;1;SAMPLER2D
Node;AmplifyShaderEditor.FunctionNode;272;-418.0861,-580.7354;Float;False;Height Blend;11;;291;2;0;FLOAT;0.0;False;1;FLOAT;0.0;False;1;FLOAT
Node;AmplifyShaderEditor.ParallaxOcclusionMappingNode;231;-1529.094,741.4197;Float;False;3;8;32;2;0.02;0;False;1,1;False;0,0;False;7;0;FLOAT2;0,0;False;1;SAMPLER2D;;False;2;FLOAT;0.02;False;3;FLOAT3;0,0,0;False;4;FLOAT;0.0;False;5;FLOAT2;0,0;False;6;FLOAT;0.0;False;1;FLOAT2
Node;AmplifyShaderEditor.SamplerNode;80;-980.3864,746.7386;Float;True;Property;_RMA2t2d;RMA 2 t2d;12;1;[NoScaleOffset];None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;1.0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1.0;False;5;COLOR;FLOAT;FLOAT;FLOAT;FLOAT
Node;AmplifyShaderEditor.OneMinusNode;89;-227.448,-353.8153;Float;False;1;0;FLOAT;0.0;False;1;FLOAT
Node;AmplifyShaderEditor.DdxOpNode;222;-1624.072,136.9205;Float;False;1;0;FLOAT2;0,0;False;1;FLOAT2
Node;AmplifyShaderEditor.RangedFloatNode;9;-1561.844,463.667;Float;False;Property;_NormalIntensity;Normal Intensity;6;0;1;0;0;0;1;FLOAT
Node;AmplifyShaderEditor.LerpOp;84;-346.3156,342.0886;Float;False;3;0;COLOR;0.0,0,0,0;False;1;COLOR;0.0,0,0,0;False;2;FLOAT;0.0,0,0,0;False;1;COLOR
Node;AmplifyShaderEditor.DdyOpNode;226;-1514.962,1053.403;Float;False;1;0;FLOAT2;0,0;False;1;FLOAT2
Node;AmplifyShaderEditor.DdxOpNode;225;-1513.754,980.9673;Float;False;1;0;FLOAT2;0,0;False;1;FLOAT2
Node;AmplifyShaderEditor.DdyOpNode;223;-1625.28,209.3566;Float;False;1;0;FLOAT2;0,0;False;1;FLOAT2
Node;AmplifyShaderEditor.BreakToComponentsNode;85;-137.1153,188.289;Float;False;COLOR;1;0;COLOR;0,0,0,0;False;16;FLOAT;FLOAT;FLOAT;FLOAT;FLOAT;FLOAT;FLOAT;FLOAT;FLOAT;FLOAT;FLOAT;FLOAT;FLOAT;FLOAT;FLOAT;FLOAT
Node;AmplifyShaderEditor.SamplerNode;81;-992,960;Float;True;Property;_Normal2;Normal 2;10;2;[NoScaleOffset];[Normal];None;True;0;True;bump;Auto;True;Object;-1;Derivative;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;1.0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1.0;False;5;FLOAT3;FLOAT;FLOAT;FLOAT;FLOAT
Node;AmplifyShaderEditor.SamplerNode;7;-896,302.7927;Float;True;Property;_Normal;Normal;7;2;[NoScaleOffset];[Normal];None;True;0;True;bump;Auto;True;Object;-1;Derivative;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;1.0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1.0;False;5;FLOAT3;FLOAT;FLOAT;FLOAT;FLOAT
Node;AmplifyShaderEditor.SamplerNode;1;-944,-304;Float;True;Property;_Albedo;Albedo;2;1;[NoScaleOffset];None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;1.0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1.0;False;5;COLOR;FLOAT;FLOAT;FLOAT;FLOAT
Node;AmplifyShaderEditor.SamplerNode;79;-985.2155,528.6877;Float;True;Property;_Albedo2;Albedo 2;8;1;[NoScaleOffset];None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;1.0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1.0;False;5;COLOR;FLOAT;FLOAT;FLOAT;FLOAT
Node;AmplifyShaderEditor.RangedFloatNode;13;-896,110.7;Float;False;Property;_Glossiness;Glossiness;3;0;1;0;0;0;1;FLOAT
Node;AmplifyShaderEditor.RangedFloatNode;2;-896,192;Float;False;Property;_Metallic;Metallic;4;0;1;0;0;0;1;FLOAT
Node;AmplifyShaderEditor.LerpOp;83;-171.8791,496;Float;False;3;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT;0.0,0,0;False;1;FLOAT3
Node;AmplifyShaderEditor.LerpOp;82;0,-160;Float;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0.0,0,0,0;False;2;FLOAT;0.0,0,0,0;False;1;COLOR
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;33;203.6,104.8999;Float;False;2;2;0;FLOAT;0.0;False;1;FLOAT;0.0;False;1;FLOAT
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;12;200.6,3.899991;Float;False;2;2;0;FLOAT;0.0;False;1;FLOAT;0.0;False;1;FLOAT
Node;AmplifyShaderEditor.OneMinusNode;243;567.4183,61.63818;Float;False;1;0;FLOAT;0.0;False;1;FLOAT
Node;AmplifyShaderEditor.FunctionNode;275;1023.973,-160.2147;Float;False;Water Puddles;14;;298;8;0;FLOAT;0.0;False;1;FLOAT;0.0;False;2;FLOAT4;0,0,0,0;False;3;FLOAT3;0,0,0;False;4;FLOAT;0.0;False;5;FLOAT;0.0;False;6;FLOAT;0.0;False;7;FLOAT;0.0;False;6;COLOR;FLOAT3;FLOAT;FLOAT;FLOAT;FLOAT
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;1955.711,114.7165;Float;False;True;2;Float;ASEMaterialInspector;0;0;Standard;FlamingSands/PBR Metallic Blend Two Layers Puddles POM;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;0;False;0;0;Opaque;0.5;True;True;0;False;Opaque;Geometry;All;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;False;0;255;255;0;0;0;0;0;0;0;0;False;0;4;10;25;False;0.5;True;0;Zero;Zero;0;Zero;Zero;Add;Add;0;False;0;0,0,0,0;VertexOffset;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;0;0;False;15;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0.0;False;4;FLOAT;0.0;False;5;FLOAT;0.0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0.0;False;9;FLOAT;0.0;False;10;FLOAT;0.0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;211;0;76;0
WireConnection;229;0;211;0
WireConnection;229;1;217;0
WireConnection;229;2;227;0
WireConnection;229;3;230;0
WireConnection;229;4;228;0
WireConnection;32;0;217;0
WireConnection;32;1;229;0
WireConnection;213;0;118;0
WireConnection;238;0;32;4
WireConnection;272;0;238;0
WireConnection;272;1;37;1
WireConnection;231;0;213;0
WireConnection;231;1;224;0
WireConnection;231;2;241;0
WireConnection;231;3;230;0
WireConnection;231;4;242;0
WireConnection;80;0;224;0
WireConnection;80;1;231;0
WireConnection;89;0;272;0
WireConnection;222;0;211;0
WireConnection;84;0;80;0
WireConnection;84;1;32;0
WireConnection;84;2;89;0
WireConnection;226;0;213;0
WireConnection;225;0;213;0
WireConnection;223;0;211;0
WireConnection;85;0;84;0
WireConnection;81;1;231;0
WireConnection;81;3;225;0
WireConnection;81;4;226;0
WireConnection;81;5;9;0
WireConnection;7;1;229;0
WireConnection;7;3;222;0
WireConnection;7;4;223;0
WireConnection;7;5;9;0
WireConnection;1;1;229;0
WireConnection;79;1;231;0
WireConnection;83;0;81;0
WireConnection;83;1;7;0
WireConnection;83;2;89;0
WireConnection;82;0;79;0
WireConnection;82;1;1;0
WireConnection;82;2;89;0
WireConnection;33;0;85;1
WireConnection;33;1;2;0
WireConnection;12;0;85;0
WireConnection;12;1;13;0
WireConnection;243;0;85;3
WireConnection;275;0;243;0
WireConnection;275;1;37;2
WireConnection;275;2;82;0
WireConnection;275;3;83;0
WireConnection;275;4;12;0
WireConnection;275;5;33;0
WireConnection;275;6;85;2
WireConnection;275;7;37;3
WireConnection;0;0;275;0
WireConnection;0;1;275;1
WireConnection;0;3;275;3
WireConnection;0;4;275;2
WireConnection;0;5;275;4
ASEEND*/
//CHKSM=BE3721EDAC78CB997FAFF08F73EBB2276D54FBC5