// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "color"
{
	Properties
	{
		_TextureSample0("Texture Sample 0", 2D) = "white" {}
		_exp("exp", Float) = 0
		[HDR]_Color0("Color 0", Color) = (0,0,0,0)
		_Lightrange1("Lightrange", Float) = 0
		_Vector3("Vector 2", Vector) = (0,1,0,0)
		[HDR]_Color3("Color 2", Color) = (0,0,0,0)
		_Float5("Float 4", Float) = 0
		[HideInInspector] _texcoord( "", 2D ) = "white" {}

	}
	
	SubShader
	{
		
		
		Tags { "RenderType"="Opaque" }
	LOD 100

		CGINCLUDE
		#pragma target 3.0
		ENDCG
		Blend Off
		AlphaToMask Off
		Cull Back
		ColorMask RGBA
		ZWrite On
		ZTest LEqual
		Offset 0 , 0
		
		
		
		Pass
		{
			Name "Unlit"
			Tags { "LightMode"="ForwardBase" }
			CGPROGRAM

			

			#ifndef UNITY_SETUP_STEREO_EYE_INDEX_POST_VERTEX
			//only defining to not throw compilation error over Unity 5.5
			#define UNITY_SETUP_STEREO_EYE_INDEX_POST_VERTEX(input)
			#endif
			#pragma vertex vert
			#pragma fragment frag
			#pragma multi_compile_instancing
			#include "UnityCG.cginc"
			#include "UnityShaderVariables.cginc"
			#define ASE_NEEDS_FRAG_POSITION
			#define ASE_NEEDS_FRAG_WORLD_POSITION


			struct MeshData
			{
				float4 vertex : POSITION;
				float4 color : COLOR;
				float4 ase_texcoord : TEXCOORD0;
				float3 ase_normal : NORMAL;
				UNITY_VERTEX_INPUT_INSTANCE_ID
			};
			
			struct V2FData
			{
				float4 vertex : SV_POSITION;
				#ifdef ASE_NEEDS_FRAG_WORLD_POSITION
				float3 worldPos : TEXCOORD0;
				#endif
				float4 ase_texcoord1 : TEXCOORD1;
				float4 ase_texcoord2 : TEXCOORD2;
				float4 ase_texcoord3 : TEXCOORD3;
				UNITY_VERTEX_INPUT_INSTANCE_ID
				UNITY_VERTEX_OUTPUT_STEREO
			};

			uniform float _exp;
			uniform sampler2D _TextureSample0;
			uniform float4 _TextureSample0_ST;
			uniform float4 _Color0;
			uniform float3 POS;
			uniform float _Lightrange1;
			uniform float3 ssss;
			uniform float2 _Vector3;
			uniform float _Float5;
			uniform float4 _Color3;
					float2 voronoihash11( float2 p )
					{
						
						p = float2( dot( p, float2( 127.1, 311.7 ) ), dot( p, float2( 269.5, 183.3 ) ) );
						return frac( sin( p ) *43758.5453);
					}
			
					float voronoi11( float2 v, float time, inout float2 id, inout float2 mr, float smoothness )
					{
						float2 n = floor( v );
						float2 f = frac( v );
						float F1 = 8.0;
						float F2 = 8.0; float2 mg = 0;
						for ( int j = -1; j <= 1; j++ )
						{
							for ( int i = -1; i <= 1; i++ )
						 	{
						 		float2 g = float2( i, j );
						 		float2 o = voronoihash11( n + g );
								o = ( sin( time + o * 6.2831 ) * 0.5 + 0.5 ); float2 r = f - g - o;
								float d = 0.5 * dot( r, r );
						 		if( d<F1 ) {
						 			F2 = F1;
						 			F1 = d; mg = g; mr = r; id = o;
						 		} else if( d<F2 ) {
						 			F2 = d;
						 		}
						 	}
						}
						return F1;
					}
			
			float3 HSVToRGB( float3 c )
			{
				float4 K = float4( 1.0, 2.0 / 3.0, 1.0 / 3.0, 3.0 );
				float3 p = abs( frac( c.xxx + K.xyz ) * 6.0 - K.www );
				return c.z * lerp( K.xxx, saturate( p - K.xxx ), c.y );
			}
			
			float3 mod2D289( float3 x ) { return x - floor( x * ( 1.0 / 289.0 ) ) * 289.0; }
			float2 mod2D289( float2 x ) { return x - floor( x * ( 1.0 / 289.0 ) ) * 289.0; }
			float3 permute( float3 x ) { return mod2D289( ( ( x * 34.0 ) + 1.0 ) * x ); }
			float snoise( float2 v )
			{
				const float4 C = float4( 0.211324865405187, 0.366025403784439, -0.577350269189626, 0.024390243902439 );
				float2 i = floor( v + dot( v, C.yy ) );
				float2 x0 = v - i + dot( i, C.xx );
				float2 i1;
				i1 = ( x0.x > x0.y ) ? float2( 1.0, 0.0 ) : float2( 0.0, 1.0 );
				float4 x12 = x0.xyxy + C.xxzz;
				x12.xy -= i1;
				i = mod2D289( i );
				float3 p = permute( permute( i.y + float3( 0.0, i1.y, 1.0 ) ) + i.x + float3( 0.0, i1.x, 1.0 ) );
				float3 m = max( 0.5 - float3( dot( x0, x0 ), dot( x12.xy, x12.xy ), dot( x12.zw, x12.zw ) ), 0.0 );
				m = m * m;
				m = m * m;
				float3 x = 2.0 * frac( p * C.www ) - 1.0;
				float3 h = abs( x ) - 0.5;
				float3 ox = floor( x + 0.5 );
				float3 a0 = x - ox;
				m *= 1.79284291400159 - 0.85373472095314 * ( a0 * a0 + h * h );
				float3 g;
				g.x = a0.x * x0.x + h.x * x0.y;
				g.yz = a0.yz * x12.xz + h.yz * x12.yw;
				return 130.0 * dot( m, g );
			}
			

			
			V2FData vert ( MeshData v )
			{
				V2FData o;
				UNITY_SETUP_INSTANCE_ID(v);
				UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(o);
				UNITY_TRANSFER_INSTANCE_ID(v, o);

				float3 ase_worldNormal = UnityObjectToWorldNormal(v.ase_normal);
				o.ase_texcoord3.xyz = ase_worldNormal;
				
				o.ase_texcoord1 = v.vertex;
				o.ase_texcoord2.xy = v.ase_texcoord.xy;
				
				//setting value to unused interpolator channels and avoid initialization warnings
				o.ase_texcoord2.zw = 0;
				o.ase_texcoord3.w = 0;
				float3 vertexValue = float3(0, 0, 0);
				#if ASE_ABSOLUTE_VERTEX_POS
				vertexValue = v.vertex.xyz;
				#endif
				vertexValue = vertexValue;
				#if ASE_ABSOLUTE_VERTEX_POS
				v.vertex.xyz = vertexValue;
				#else
				v.vertex.xyz += vertexValue;
				#endif
				o.vertex = UnityObjectToClipPos(v.vertex);

				#ifdef ASE_NEEDS_FRAG_WORLD_POSITION
				o.worldPos = mul(unity_ObjectToWorld, v.vertex).xyz;
				#endif
				return o;
			}
			
			fixed4 frag (V2FData i ) : SV_Target
			{
				UNITY_SETUP_INSTANCE_ID(i);
				UNITY_SETUP_STEREO_EYE_INDEX_POST_VERTEX(i);
				fixed4 finalColor;
				#ifdef ASE_NEEDS_FRAG_WORLD_POSITION
				float3 WorldPosition = i.worldPos;
				#endif
				float time11 = ( i.ase_texcoord1.xyz.z + _Time.y );
				float4 appendResult14 = (float4(i.ase_texcoord1.xyz.y , i.ase_texcoord1.xyz.z , 0.0 , 0.0));
				float2 coords11 = appendResult14.xy * 452.7;
				float2 id11 = 0;
				float2 uv11 = 0;
				float voroi11 = voronoi11( coords11, time11, id11, uv11, 0 );
				float2 uv_TextureSample0 = i.ase_texcoord2.xy * _TextureSample0_ST.xy + _TextureSample0_ST.zw;
				float3 hsvTorgb25 = HSVToRGB( float3(WorldPosition.x,1.28,1.28) );
				float3 ase_worldViewDir = UnityWorldSpaceViewDir(WorldPosition);
				ase_worldViewDir = normalize(ase_worldViewDir);
				float3 ase_worldNormal = i.ase_texcoord3.xyz;
				float3 _Vector1 = float3(0,1.09,4.21);
				float fresnelNdotV20 = dot( ase_worldNormal, ase_worldViewDir );
				float fresnelNode20 = ( _Vector1.x + _Vector1.y * pow( 1.0 - fresnelNdotV20, _Vector1.z ) );
				float3 position36 = POS;
				float Scale38 = ssss.x;
				float3 _Vector2 = float3(0,0,1);
				float ifLocalVar61 = 0;
				if( ( distance( WorldPosition , position36 ) + _Lightrange1 ) > Scale38 )
				ifLocalVar61 = _Vector2.x;
				else if( ( distance( WorldPosition , position36 ) + _Lightrange1 ) == Scale38 )
				ifLocalVar61 = _Vector2.y;
				else if( ( distance( WorldPosition , position36 ) + _Lightrange1 ) < Scale38 )
				ifLocalVar61 = _Vector2.z;
				clip( ifLocalVar61 - 0.99);
				float4 CLIP70 = ( ( ( 1.0 - voroi11 ) * ( 1.0 - pow( ( -40.0 * i.ase_texcoord1.xyz.z ) , _exp ) ) ) + tex2D( _TextureSample0, uv_TextureSample0 ) + ( ( _Color0 * float4( hsvTorgb25 , 0.0 ) ) * fresnelNode20 ) );
				float lerpResult60 = lerp( _Vector3.x , _Vector3.y , ( distance( WorldPosition , position36 ) - ( Scale38 + _Float5 ) ));
				float3 break45 = ( WorldPosition * 0.26 );
				float mulTime44 = _Time.y * 0.08;
				float4 appendResult53 = (float4(break45.x , ( break45.y + mulTime44 ) , 0.0 , 0.0));
				float simplePerlin2D62 = snoise( appendResult53.xy*19.12 );
				simplePerlin2D62 = simplePerlin2D62*0.5 + 0.5;
				float3 _Vector4 = float3(0,0,1);
				float ifLocalVar69 = 0;
				if( ( lerpResult60 * simplePerlin2D62 ) > 0.03 )
				ifLocalVar69 = _Vector4.x;
				else if( ( lerpResult60 * simplePerlin2D62 ) == 0.03 )
				ifLocalVar69 = _Vector4.y;
				else if( ( lerpResult60 * simplePerlin2D62 ) < 0.03 )
				ifLocalVar69 = _Vector4.z;
				
				
				finalColor = ( CLIP70 + ( ifLocalVar69 * _Color3 ) );
				return finalColor;
			}
			ENDCG
		}
	}
	CustomEditor "ASEMaterialInspector"
	
	
}
/*ASEBEGIN
Version=18800
110.4;612.8;1440.8;867;1416.771;-204.9904;2.506419;True;False
Node;AmplifyShaderEditor.RangedFloatNode;18;-1057.939,-504.2548;Inherit;False;Constant;_Float1;Float 1;2;0;Create;True;0;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.Vector3Node;31;-1945.571,310.9429;Inherit;False;Global;POS;POS;3;0;Create;True;0;0;0;False;0;False;0,0,0;-0.79,1.06,-14.85;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.RangedFloatNode;33;-41.63525,1236.923;Inherit;False;Constant;_Float10;Float 9;8;0;Create;True;0;0;0;False;0;False;0.26;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.WorldPosInputsNode;32;-240.2623,1134.281;Inherit;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.CommentaryNode;35;-1740.153,-197.9463;Inherit;False;2034.706;773.7719;CLIP;17;75;74;65;63;61;57;56;55;49;48;43;42;41;38;36;1;9;;1,1,1,1;0;0
Node;AmplifyShaderEditor.Vector3Node;34;-1941.092,508.7397;Inherit;False;Global;ssss;ssss;3;0;Create;True;0;0;0;False;0;False;0,0,0;1.796523,1.796523,1.796523;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.PosVertexDataNode;12;-990.1787,-733.342;Inherit;False;0;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleTimeNode;16;-910.5914,-484.689;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;6;-563.8785,-337.0813;Inherit;False;Constant;_Float0;Float 0;1;0;Create;True;0;0;0;False;0;False;-40;-40;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.PosVertexDataNode;4;-766.6785,-257.7813;Inherit;False;0;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleAddOpNode;17;-594.5272,-583.0755;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;14;-482.3845,-722.395;Inherit;False;FLOAT4;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;5;-354.3627,-330.2535;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;26;-294.2033,-1092.825;Inherit;False;Constant;_Float2;Float 2;3;0;Create;True;0;0;0;False;0;False;1.28;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.WorldPosInputsNode;24;-609.4482,-1413.167;Inherit;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.RangedFloatNode;9;-358.4268,-188.3311;Inherit;False;Property;_exp;exp;1;0;Create;True;0;0;0;False;0;False;0;-0.1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;39;84.29468,1118.339;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;38;-1729.434,520.3387;Inherit;False;Scale;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;37;25.21875,1337.848;Inherit;False;Constant;_Float9;Float 8;8;0;Create;True;0;0;0;False;0;False;0.08;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;36;-1739.587,321.5406;Inherit;False;position;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.Vector2Node;13;-392.3913,-517.39;Inherit;False;Constant;_Vector0;Vector 0;2;0;Create;True;0;0;0;False;0;False;23.57,452.7;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.PowerNode;8;-176.0907,-320.7574;Inherit;False;False;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.Vector3Node;23;-170.8218,-847.0412;Inherit;False;Constant;_Vector1;Vector 1;3;0;Create;True;0;0;0;False;0;False;0,1.09,4.21;0,0,0;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.HSVToRGBNode;25;9.907711,-1156.721;Inherit;True;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.VoronoiNode;11;-50.16655,-628.2419;Inherit;True;0;0;1;0;1;False;1;False;False;4;0;FLOAT2;0,0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;0;False;3;FLOAT;0;FLOAT2;1;FLOAT2;2
Node;AmplifyShaderEditor.ColorNode;29;2.396349,-1390.133;Inherit;False;Property;_Color0;Color 0;2;1;[HDR];Create;True;0;0;0;False;0;False;0,0,0,0;0,0.3114843,3.446487,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.WorldPosInputsNode;43;-1690.153,-147.9463;Inherit;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SimpleTimeNode;44;177.3387,1301.829;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;40;-409.4553,1052.309;Inherit;False;Property;_Float5;Float 4;6;0;Create;True;0;0;0;False;0;False;0;0.14;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.WorldPosInputsNode;41;-452.4713,513.6027;Inherit;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.GetLocalVarNode;42;-1541.183,9.599731;Inherit;False;36;position;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.GetLocalVarNode;47;-463.6143,926.5468;Inherit;False;38;Scale;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.BreakToComponentsNode;45;286.1232,1008.327;Inherit;False;FLOAT3;1;0;FLOAT3;0,0,0;False;16;FLOAT;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT;5;FLOAT;6;FLOAT;7;FLOAT;8;FLOAT;9;FLOAT;10;FLOAT;11;FLOAT;12;FLOAT;13;FLOAT;14;FLOAT;15
Node;AmplifyShaderEditor.GetLocalVarNode;46;-443.7683,748.5597;Inherit;False;36;position;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleAddOpNode;51;-5.258301,935.8167;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.FresnelNode;20;31.32929,-837.6273;Inherit;True;Standard;WorldNormal;ViewDir;False;False;5;0;FLOAT3;0,0,1;False;4;FLOAT3;0,0,0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;5;False;1;FLOAT;0
Node;AmplifyShaderEditor.DistanceOpNode;52;-5.958252,693.9867;Inherit;False;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;50;461.2993,1091.45;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;28;342.5502,-1092.284;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT3;0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.DistanceOpNode;48;-1166.84,43.63867;Inherit;False;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;10;-30.00481,-318.3998;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;19;235.3624,-532.8286;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;49;-1213.978,204.0177;Inherit;False;Property;_Lightrange1;Lightrange;3;0;Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;56;-1489.219,268.8667;Inherit;False;38;Scale;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;58;309.2762,745.6837;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;59;737.0226,1291.681;Inherit;False;Constant;_Float6;Float 5;6;0;Create;True;0;0;0;False;0;False;19.12;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;1;-218.4287,-17.16231;Inherit;True;Property;_TextureSample0;Texture Sample 0;0;0;Create;True;0;0;0;False;0;False;-1;None;c63c979580b75814aba0e92d56ef9083;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleAddOpNode;55;-956.5474,107.7758;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.Vector3Node;57;-1088.462,422.1417;Inherit;False;Constant;_Vector2;Vector 1;2;0;Create;True;0;0;0;False;0;False;0,0,1;0,0,0;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.DynamicAppendNode;53;600.308,936.9967;Inherit;False;FLOAT4;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;15;248.4791,-316.9977;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;21;476.289,-662.7037;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.Vector2Node;54;463.4732,408.3848;Inherit;False;Property;_Vector3;Vector 2;4;0;Create;True;0;0;0;False;0;False;0,1;0.26,-2.13;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.SimpleAddOpNode;7;432.6745,-305.8292;Inherit;False;3;3;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;63;-466.8373,315.7607;Inherit;False;Constant;_Float4;Float 3;1;0;Create;True;0;0;0;False;0;False;0.99;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.NoiseGeneratorNode;62;792.37,854.9427;Inherit;True;Simplex2D;True;False;2;0;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;60;765.8251,394.8137;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ConditionalIfNode;61;-758.2772,206.5387;Inherit;False;False;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;4;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;67;944.87,316.3068;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.Vector3Node;66;786.4511,623.6387;Inherit;False;Constant;_Vector4;Vector 3;5;0;Create;True;0;0;0;False;0;False;0,0,1;0,0,0;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.ClipNode;65;-206.9642,136.4307;Inherit;False;3;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;64;785.6414,531.5427;Inherit;False;Constant;_Float7;Float 6;5;0;Create;True;0;0;0;False;0;False;0.03;0.51;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;68;1240.424,582.9437;Inherit;False;Property;_Color3;Color 2;5;1;[HDR];Create;True;0;0;0;False;0;False;0,0,0,0;0,2.462395,4.237095,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ConditionalIfNode;69;1247.819,327.7727;Inherit;False;False;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;4;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;70;358.0893,145.5317;Inherit;False;CLIP;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;72;957.9756,175.1147;Inherit;False;70;CLIP;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;71;1559.23,297.0227;Inherit;False;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;73;-350.7423,1462.849;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;74;-1459.258,471.5957;Inherit;False;Property;_Float8;Float 7;7;0;Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;75;-1224.164,347.5157;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;76;1758.334,184.2227;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.BreakToComponentsNode;30;-226.7283,570.3566;Inherit;False;FLOAT;1;0;FLOAT;0;False;16;FLOAT;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT;5;FLOAT;6;FLOAT;7;FLOAT;8;FLOAT;9;FLOAT;10;FLOAT;11;FLOAT;12;FLOAT;13;FLOAT;14;FLOAT;15
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;0;1791.082,-784.071;Float;False;True;-1;2;ASEMaterialInspector;100;1;color;0770190933193b94aaa3065e307002fa;True;Unlit;0;0;Unlit;2;True;0;1;False;-1;0;False;-1;0;1;False;-1;0;False;-1;True;0;False;-1;0;False;-1;False;False;False;False;False;False;True;0;False;-1;True;0;False;-1;True;True;True;True;True;0;False;-1;False;False;False;True;False;255;False;-1;255;False;-1;255;False;-1;7;False;-1;1;False;-1;1;False;-1;1;False;-1;7;False;-1;1;False;-1;1;False;-1;1;False;-1;True;1;False;-1;True;3;False;-1;True;True;0;False;-1;0;False;-1;True;1;RenderType=Opaque=RenderType;True;2;0;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;1;LightMode=ForwardBase;False;0;;0;0;Standard;1;Vertex Position,InvertActionOnDeselection;1;0;1;True;False;;False;0
WireConnection;16;0;18;0
WireConnection;17;0;12;3
WireConnection;17;1;16;0
WireConnection;14;0;12;2
WireConnection;14;1;12;3
WireConnection;5;0;6;0
WireConnection;5;1;4;3
WireConnection;39;0;32;0
WireConnection;39;1;33;0
WireConnection;38;0;34;1
WireConnection;36;0;31;0
WireConnection;8;0;5;0
WireConnection;8;1;9;0
WireConnection;25;0;24;1
WireConnection;25;1;26;0
WireConnection;25;2;26;0
WireConnection;11;0;14;0
WireConnection;11;1;17;0
WireConnection;11;2;13;2
WireConnection;44;0;37;0
WireConnection;45;0;39;0
WireConnection;51;0;47;0
WireConnection;51;1;40;0
WireConnection;20;1;23;1
WireConnection;20;2;23;2
WireConnection;20;3;23;3
WireConnection;52;0;41;0
WireConnection;52;1;46;0
WireConnection;50;0;45;1
WireConnection;50;1;44;0
WireConnection;28;0;29;0
WireConnection;28;1;25;0
WireConnection;48;0;43;0
WireConnection;48;1;42;0
WireConnection;10;0;8;0
WireConnection;19;0;11;0
WireConnection;58;0;52;0
WireConnection;58;1;51;0
WireConnection;55;0;48;0
WireConnection;55;1;49;0
WireConnection;53;0;45;0
WireConnection;53;1;50;0
WireConnection;15;0;19;0
WireConnection;15;1;10;0
WireConnection;21;0;28;0
WireConnection;21;1;20;0
WireConnection;7;0;15;0
WireConnection;7;1;1;0
WireConnection;7;2;21;0
WireConnection;62;0;53;0
WireConnection;62;1;59;0
WireConnection;60;0;54;1
WireConnection;60;1;54;2
WireConnection;60;2;58;0
WireConnection;61;0;55;0
WireConnection;61;1;56;0
WireConnection;61;2;57;1
WireConnection;61;3;57;2
WireConnection;61;4;57;3
WireConnection;67;0;60;0
WireConnection;67;1;62;0
WireConnection;65;0;7;0
WireConnection;65;1;61;0
WireConnection;65;2;63;0
WireConnection;69;0;67;0
WireConnection;69;1;64;0
WireConnection;69;2;66;1
WireConnection;69;3;66;2
WireConnection;69;4;66;3
WireConnection;70;0;65;0
WireConnection;71;0;69;0
WireConnection;71;1;68;0
WireConnection;75;0;56;0
WireConnection;75;1;74;0
WireConnection;76;0;72;0
WireConnection;76;1;71;0
WireConnection;0;0;76;0
ASEEND*/
//CHKSM=BD31258B416CBEE2157F76E0B494667181205EDB