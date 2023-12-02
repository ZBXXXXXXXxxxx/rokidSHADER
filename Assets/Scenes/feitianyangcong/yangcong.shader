// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "yangcong"
{
	Properties
	{
		_TextureSample0("Texture Sample 0", 2D) = "white" {}
		_TextureSample1("Texture Sample 1", 2D) = "white" {}
		_Lightrange1("Lightrange", Float) = 0
		_Vector2("Vector 1", Vector) = (0,1,0,0)
		[HDR]_Color1("Color 0", Color) = (0,0,0,0)
		_Float4("Float 3", Float) = 0
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
				UNITY_VERTEX_INPUT_INSTANCE_ID
				UNITY_VERTEX_OUTPUT_STEREO
			};

			uniform sampler2D _TextureSample1;
			uniform float4 _TextureSample1_ST;
			uniform sampler2D _TextureSample0;
			uniform float4 _TextureSample0_ST;
			uniform float3 POS;
			uniform float _Lightrange1;
			uniform float3 ssss;
			uniform float2 _Vector2;
			uniform float _Float4;
			uniform float4 _Color1;
			float3 HSVToRGB( float3 c )
			{
				float4 K = float4( 1.0, 2.0 / 3.0, 1.0 / 3.0, 3.0 );
				float3 p = abs( frac( c.xxx + K.xyz ) * 6.0 - K.www );
				return c.z * lerp( K.xxx, saturate( p - K.xxx ), c.y );
			}
			
					float2 voronoihash21( float2 p )
					{
						
						p = float2( dot( p, float2( 127.1, 311.7 ) ), dot( p, float2( 269.5, 183.3 ) ) );
						return frac( sin( p ) *43758.5453);
					}
			
					float voronoi21( float2 v, float time, inout float2 id, inout float2 mr, float smoothness )
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
						 		float2 o = voronoihash21( n + g );
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

				o.ase_texcoord1 = v.vertex;
				o.ase_texcoord2.xy = v.ase_texcoord.xy;
				
				//setting value to unused interpolator channels and avoid initialization warnings
				o.ase_texcoord2.zw = 0;
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
				float time21 = 0.0;
				float2 coords21 = i.ase_texcoord1.xyz.xy * 4.91;
				float2 id21 = 0;
				float2 uv21 = 0;
				float voroi21 = voronoi21( coords21, time21, id21, uv21, 0 );
				float mulTime12 = _Time.y * 0.09;
				float3 hsvTorgb6 = HSVToRGB( float3(( voroi21 + ( ( ( 0.0 + mulTime12 ) + i.ase_texcoord1.xyz.z ) * -1.93 ) ),1.26,1.26) );
				float2 uv_TextureSample1 = i.ase_texcoord2.xy * _TextureSample1_ST.xy + _TextureSample1_ST.zw;
				float2 uv_TextureSample0 = i.ase_texcoord2.xy * _TextureSample0_ST.xy + _TextureSample0_ST.zw;
				float3 position59 = POS;
				float Scale30 = ssss.x;
				float3 _Vector1 = float3(0,0,1);
				float ifLocalVar67 = 0;
				if( ( distance( WorldPosition , position59 ) + _Lightrange1 ) > Scale30 )
				ifLocalVar67 = _Vector1.x;
				else if( ( distance( WorldPosition , position59 ) + _Lightrange1 ) == Scale30 )
				ifLocalVar67 = _Vector1.y;
				else if( ( distance( WorldPosition , position59 ) + _Lightrange1 ) < Scale30 )
				ifLocalVar67 = _Vector1.z;
				clip( ifLocalVar67 - 0.99);
				float4 CLIP52 = ( ( float4( hsvTorgb6 , 0.0 ) * tex2D( _TextureSample1, uv_TextureSample1 ) ) + tex2D( _TextureSample0, uv_TextureSample0 ) );
				float lerpResult43 = lerp( _Vector2.x , _Vector2.y , ( distance( WorldPosition , position59 ) - ( Scale30 + _Float4 ) ));
				float3 break36 = ( WorldPosition * 0.26 );
				float mulTime31 = _Time.y * 0.08;
				float4 appendResult40 = (float4(break36.x , ( break36.y + mulTime31 ) , 0.0 , 0.0));
				float simplePerlin2D45 = snoise( appendResult40.xy*19.12 );
				simplePerlin2D45 = simplePerlin2D45*0.5 + 0.5;
				float3 _Vector3 = float3(0,0,1);
				float ifLocalVar51 = 0;
				if( ( lerpResult43 * simplePerlin2D45 ) > 0.03 )
				ifLocalVar51 = _Vector3.x;
				else if( ( lerpResult43 * simplePerlin2D45 ) == 0.03 )
				ifLocalVar51 = _Vector3.y;
				else if( ( lerpResult43 * simplePerlin2D45 ) < 0.03 )
				ifLocalVar51 = _Vector3.z;
				
				
				finalColor = ( CLIP52 + ( ifLocalVar51 * _Color1 ) );
				return finalColor;
			}
			ENDCG
		}
	}
	CustomEditor "ASEMaterialInspector"
	
	
}
/*ASEBEGIN
Version=18800
110.4;612.8;1440.8;867;-22.11841;2058.255;1;True;False
Node;AmplifyShaderEditor.CommentaryNode;71;-1735.881,-4190.08;Inherit;False;2045.407;1303.815;baseshader;17;15;17;12;13;10;19;22;16;18;21;9;23;6;3;1;5;2;;1,1,1,1;0;0
Node;AmplifyShaderEditor.RangedFloatNode;15;-1464.308,-3339.95;Inherit;False;Constant;_Float1;Float 1;3;0;Create;True;0;0;0;False;0;False;0.09;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleTimeNode;12;-1362.832,-3451.268;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.PosVertexDataNode;17;-1685.881,-3814.991;Inherit;False;0;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.BreakToComponentsNode;10;-1324.732,-3660.395;Inherit;False;FLOAT;1;0;FLOAT;0;False;16;FLOAT;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT;5;FLOAT;6;FLOAT;7;FLOAT;8;FLOAT;9;FLOAT;10;FLOAT;11;FLOAT;12;FLOAT;13;FLOAT;14;FLOAT;15
Node;AmplifyShaderEditor.SimpleAddOpNode;13;-1128.677,-3528.272;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.Vector3Node;57;-1848.985,-2286.18;Inherit;False;Global;POS;POS;3;0;Create;True;0;0;0;False;0;False;0,0,0;-0.79,1.06,-14.85;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SimpleAddOpNode;16;-1035.993,-3770.837;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;22;-1098.431,-3956.167;Inherit;False;Constant;_Float3;Float 3;2;0;Create;True;0;0;0;False;0;False;4.91;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;19;-987.7214,-3629.818;Inherit;False;Constant;_Float2;Float 2;2;0;Create;True;0;0;0;False;0;False;-1.93;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;24;-1643.567,-2802.687;Inherit;False;2034.706;773.7719;CLIP;15;69;68;67;66;65;64;63;62;61;60;59;48;44;35;30;;1,1,1,1;0;0
Node;AmplifyShaderEditor.RangedFloatNode;26;54.95129,-1367.818;Inherit;False;Constant;_Float9;Float 8;8;0;Create;True;0;0;0;False;0;False;0.26;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.WorldPosInputsNode;27;-143.6766,-1470.459;Inherit;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.Vector3Node;58;-1844.506,-2096.001;Inherit;False;Global;ssss;ssss;3;0;Create;True;0;0;0;False;0;False;0,0,0;6.74421,6.74421,6.74421;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;28;180.8808,-1486.401;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;18;-869.7211,-3740.818;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;59;-1643.001,-2283.2;Inherit;False;position;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;30;-1632.848,-2084.402;Inherit;False;Scale;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.VoronoiNode;21;-918.0378,-4140.079;Inherit;True;0;0;1;0;1;False;1;False;False;4;0;FLOAT2;0,0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;0;False;3;FLOAT;0;FLOAT2;1;FLOAT2;2
Node;AmplifyShaderEditor.RangedFloatNode;29;121.8044,-1266.893;Inherit;False;Constant;_Float8;Float 7;8;0;Create;True;0;0;0;False;0;False;0.08;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.WorldPosInputsNode;35;-355.8854,-2091.138;Inherit;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.RangedFloatNode;9;-858.8446,-3574.62;Inherit;False;Constant;_Float0;Float 0;3;0;Create;True;0;0;0;False;0;False;1.26;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;34;-367.0284,-1678.194;Inherit;False;30;Scale;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;33;-347.1824,-1856.181;Inherit;False;59;position;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode;32;-312.8694,-1552.432;Inherit;False;Property;_Float4;Float 3;5;0;Create;True;0;0;0;False;0;False;0;-1.97;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleTimeNode;31;273.9248,-1302.912;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.WorldPosInputsNode;61;-1593.567,-2752.687;Inherit;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.BreakToComponentsNode;36;382.7094,-1596.414;Inherit;False;FLOAT3;1;0;FLOAT3;0,0,0;False;16;FLOAT;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT;5;FLOAT;6;FLOAT;7;FLOAT;8;FLOAT;9;FLOAT;10;FLOAT;11;FLOAT;12;FLOAT;13;FLOAT;14;FLOAT;15
Node;AmplifyShaderEditor.GetLocalVarNode;60;-1444.597,-2595.141;Inherit;False;59;position;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleAddOpNode;23;-551.1053,-3818.427;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DistanceOpNode;37;90.62799,-1910.754;Inherit;False;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;38;557.8855,-1513.291;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;3;-790.8558,-3335.95;Inherit;True;Property;_TextureSample1;Texture Sample 1;1;0;Create;True;0;0;0;False;0;False;-1;None;c502757d591f33c4783b39e940bf237f;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.DistanceOpNode;62;-1070.254,-2561.102;Inherit;False;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;63;-1117.392,-2399.355;Inherit;False;Property;_Lightrange1;Lightrange;2;0;Create;True;0;0;0;False;0;False;0;-0.38;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;39;91.32843,-1668.924;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.HSVToRGBNode;6;-381.5508,-3709.839;Inherit;True;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.Vector3Node;64;-991.8763,-2182.599;Inherit;False;Constant;_Vector1;Vector 0;2;0;Create;True;0;0;0;False;0;False;0,0,1;0,0,0;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.DynamicAppendNode;40;696.8942,-1667.744;Inherit;False;FLOAT4;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.Vector2Node;42;560.0594,-2196.356;Inherit;False;Property;_Vector2;Vector 1;3;0;Create;True;0;0;0;False;0;False;0,1;0.29,0.2;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;5;-1.872533,-3348.595;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;70;405.8624,-1859.057;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;66;-1392.633,-2335.874;Inherit;False;30;Scale;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;1;-770.108,-3116.263;Inherit;True;Property;_TextureSample0;Texture Sample 0;0;0;Create;True;0;0;0;False;0;False;-1;None;ac21fc94a9ee3674fa4bd0d404994ff9;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleAddOpNode;65;-859.9614,-2496.965;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;41;833.6088,-1313.06;Inherit;False;Constant;_Float5;Float 4;6;0;Create;True;0;0;0;False;0;False;19.12;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.NoiseGeneratorNode;45;888.9562,-1749.798;Inherit;True;Simplex2D;True;False;2;0;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;43;862.4113,-2209.927;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;2;157.1274,-3250.595;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;44;-370.2513,-2288.98;Inherit;False;Constant;_Float6;Float 1;1;0;Create;True;0;0;0;False;0;False;0.99;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.ConditionalIfNode;67;-661.6914,-2398.202;Inherit;False;False;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;4;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;47;882.2275,-2073.198;Inherit;False;Constant;_Float7;Float 2;5;0;Create;True;0;0;0;False;0;False;0.03;0.51;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.Vector3Node;49;883.0373,-1981.102;Inherit;False;Constant;_Vector3;Vector 2;5;0;Create;True;0;0;0;False;0;False;0,0,1;0,0,0;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;46;1041.456,-2288.434;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ClipNode;48;-110.3781,-2468.31;Inherit;False;3;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.ConditionalIfNode;51;1344.406,-2276.968;Inherit;False;False;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;4;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;50;1337.01,-2021.797;Inherit;False;Property;_Color1;Color 0;4;1;[HDR];Create;True;0;0;0;False;0;False;0,0,0,0;0,592.8203,1024,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RegisterLocalVarNode;52;454.6755,-2459.209;Inherit;False;CLIP;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;54;1655.816,-2307.718;Inherit;False;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;53;1054.562,-2429.626;Inherit;False;52;CLIP;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;55;1854.921,-2420.518;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;56;-254.1564,-1141.892;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;69;-1362.672,-2133.145;Inherit;False;Property;_Float10;Float 5;6;0;Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;68;-1127.578,-2257.225;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;0;1739.916,-625.1496;Float;False;True;-1;2;ASEMaterialInspector;100;1;yangcong;0770190933193b94aaa3065e307002fa;True;Unlit;0;0;Unlit;2;True;0;1;False;-1;0;False;-1;0;1;False;-1;0;False;-1;True;0;False;-1;0;False;-1;False;False;False;False;False;False;True;0;False;-1;True;0;False;-1;True;True;True;True;True;0;False;-1;False;False;False;True;False;255;False;-1;255;False;-1;255;False;-1;7;False;-1;1;False;-1;1;False;-1;1;False;-1;7;False;-1;1;False;-1;1;False;-1;1;False;-1;True;1;False;-1;True;3;False;-1;True;True;0;False;-1;0;False;-1;True;1;RenderType=Opaque=RenderType;True;2;0;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;1;LightMode=ForwardBase;False;0;;0;0;Standard;1;Vertex Position,InvertActionOnDeselection;1;0;1;True;False;;False;0
WireConnection;12;0;15;0
WireConnection;10;0;17;3
WireConnection;13;1;12;0
WireConnection;16;0;13;0
WireConnection;16;1;10;0
WireConnection;28;0;27;0
WireConnection;28;1;26;0
WireConnection;18;0;16;0
WireConnection;18;1;19;0
WireConnection;59;0;57;0
WireConnection;30;0;58;1
WireConnection;21;0;17;0
WireConnection;21;2;22;0
WireConnection;31;0;29;0
WireConnection;36;0;28;0
WireConnection;23;0;21;0
WireConnection;23;1;18;0
WireConnection;37;0;35;0
WireConnection;37;1;33;0
WireConnection;38;0;36;1
WireConnection;38;1;31;0
WireConnection;62;0;61;0
WireConnection;62;1;60;0
WireConnection;39;0;34;0
WireConnection;39;1;32;0
WireConnection;6;0;23;0
WireConnection;6;1;9;0
WireConnection;6;2;9;0
WireConnection;40;0;36;0
WireConnection;40;1;38;0
WireConnection;5;0;6;0
WireConnection;5;1;3;0
WireConnection;70;0;37;0
WireConnection;70;1;39;0
WireConnection;65;0;62;0
WireConnection;65;1;63;0
WireConnection;45;0;40;0
WireConnection;45;1;41;0
WireConnection;43;0;42;1
WireConnection;43;1;42;2
WireConnection;43;2;70;0
WireConnection;2;0;5;0
WireConnection;2;1;1;0
WireConnection;67;0;65;0
WireConnection;67;1;66;0
WireConnection;67;2;64;1
WireConnection;67;3;64;2
WireConnection;67;4;64;3
WireConnection;46;0;43;0
WireConnection;46;1;45;0
WireConnection;48;0;2;0
WireConnection;48;1;67;0
WireConnection;48;2;44;0
WireConnection;51;0;46;0
WireConnection;51;1;47;0
WireConnection;51;2;49;1
WireConnection;51;3;49;2
WireConnection;51;4;49;3
WireConnection;52;0;48;0
WireConnection;54;0;51;0
WireConnection;54;1;50;0
WireConnection;55;0;53;0
WireConnection;55;1;54;0
WireConnection;68;0;66;0
WireConnection;68;1;69;0
WireConnection;0;0;55;0
ASEEND*/
//CHKSM=CAE6080809A27C05E0881330A47422834D484CDC