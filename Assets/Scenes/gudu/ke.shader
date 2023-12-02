// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "ke"
{
	Properties
	{
		[HDR]_Color0("Color 0", Color) = (0,0,0,0)
		_transform("transform", Float) = 0
		_power("power", Float) = 0
		_Lightrange1("Lightrange", Float) = 0
		_Vector3("Vector 2", Vector) = (0,1,0,0)
		[HDR]_Color3("Color 2", Color) = (0,0,0,0)
		_Float5("Float 4", Float) = 0

	}
	
	SubShader
	{
		
		
		Tags { "RenderType"="Opaque" }
	LOD 100

		CGINCLUDE
		#pragma target 3.0
		ENDCG
		Blend SrcAlpha OneMinusSrcAlpha
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
			#define ASE_NEEDS_FRAG_WORLD_POSITION
			#define ASE_NEEDS_FRAG_POSITION


			struct MeshData
			{
				float4 vertex : POSITION;
				float4 color : COLOR;
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
				UNITY_VERTEX_INPUT_INSTANCE_ID
				UNITY_VERTEX_OUTPUT_STEREO
			};

			uniform float4 _Color0;
			uniform float _power;
			uniform float _transform;
			uniform float3 POS;
			uniform float _Lightrange1;
			uniform float3 ssss;
			uniform float2 _Vector3;
			uniform float _Float5;
			uniform float4 _Color3;
					float2 voronoihash15( float2 p )
					{
						
						p = float2( dot( p, float2( 127.1, 311.7 ) ), dot( p, float2( 269.5, 183.3 ) ) );
						return frac( sin( p ) *43758.5453);
					}
			
					float voronoi15( float2 v, float time, inout float2 id, inout float2 mr, float smoothness )
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
						 		float2 o = voronoihash15( n + g );
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

				float3 ase_worldNormal = UnityObjectToWorldNormal(v.ase_normal);
				o.ase_texcoord1.xyz = ase_worldNormal;
				
				o.ase_texcoord2 = v.vertex;
				
				//setting value to unused interpolator channels and avoid initialization warnings
				o.ase_texcoord1.w = 0;
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
				float3 ase_worldViewDir = UnityWorldSpaceViewDir(WorldPosition);
				ase_worldViewDir = normalize(ase_worldViewDir);
				float3 ase_worldNormal = i.ase_texcoord1.xyz;
				float3 _Vector0 = float3(0,0.76,3.47);
				float fresnelNdotV1 = dot( ase_worldNormal, ase_worldViewDir );
				float fresnelNode1 = ( _Vector0.x + _Vector0.y * pow( 1.0 - fresnelNdotV1, _Vector0.z ) );
				float time15 = ( i.ase_texcoord2.xyz.z + _Time.y );
				float4 appendResult13 = (float4(i.ase_texcoord2.xyz.y , i.ase_texcoord2.xyz.z , 0.0 , 0.0));
				float2 coords15 = appendResult13.xy * 227;
				float2 id15 = 0;
				float2 uv15 = 0;
				float voroi15 = voronoi15( coords15, time15, id15, uv15, 0 );
				float4 appendResult25 = (float4(( _Color0 * ( fresnelNode1 + pow( ( 1.0 - voroi15 ) , _power ) ) ).rgb , _transform));
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
				float4 CLIP70 = appendResult25;
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
110.4;612.8;1440.8;867;1259.824;-1639.322;1.257591;True;False
Node;AmplifyShaderEditor.RangedFloatNode;6;-1803.464,628.9623;Inherit;False;Constant;_Float1;Float 1;2;0;Create;True;0;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleTimeNode;10;-1656.117,648.5281;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.PosVertexDataNode;9;-1735.704,399.8752;Inherit;False;0;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.Vector2Node;12;-1137.917,615.8271;Inherit;False;Constant;_Vector1;Vector 1;2;0;Create;True;0;0;0;False;0;False;23.57,227;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.SimpleAddOpNode;11;-1340.053,550.1415;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;13;-1227.91,410.8221;Inherit;False;FLOAT4;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.Vector3Node;31;-2752.212,1511.75;Inherit;False;Global;POS;POS;3;0;Create;True;0;0;0;False;0;False;0,0,0;-0.79,1.06,-14.85;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.WorldPosInputsNode;32;-1046.903,2327.471;Inherit;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.Vector3Node;34;-2747.733,1701.929;Inherit;False;Global;ssss;ssss;3;0;Create;True;0;0;0;False;0;False;0,0,0;1.796523,1.796523,1.796523;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.CommentaryNode;35;-2546.794,995.2434;Inherit;False;2034.706;773.7719;CLIP;15;75;74;65;63;61;57;56;55;49;48;43;42;41;38;36;;1,1,1,1;0;0
Node;AmplifyShaderEditor.RangedFloatNode;33;-848.2764,2430.113;Inherit;False;Constant;_Float10;Float 9;8;0;Create;True;0;0;0;False;0;False;0.26;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.VoronoiNode;15;-795.6918,504.9752;Inherit;True;0;0;1;0;1;False;1;False;False;4;0;FLOAT2;0,0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;0;False;3;FLOAT;0;FLOAT2;1;FLOAT2;2
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;39;-722.3464,2311.529;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;36;-2546.228,1514.73;Inherit;False;position;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode;30;-312.7393,689.066;Inherit;False;Property;_power;power;2;0;Create;True;0;0;0;False;0;False;0;52.34;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;18;-510.1626,600.3885;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.Vector3Node;2;-892.9885,271.1028;Inherit;False;Constant;_Vector0;Vector 0;0;0;Create;True;0;0;0;False;0;False;0,0.76,3.47;0.08,-23.85,11.99;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.RangedFloatNode;37;-781.4224,2531.038;Inherit;False;Constant;_Float9;Float 8;8;0;Create;True;0;0;0;False;0;False;0.08;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;38;-2536.075,1713.528;Inherit;False;Scale;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.PowerNode;29;-148.9244,458.4319;Inherit;False;False;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.FresnelNode;1;-663.9885,182.1029;Inherit;True;Standard;WorldNormal;ViewDir;False;False;5;0;FLOAT3;0,0,1;False;4;FLOAT3;0,0,0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;5;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleTimeNode;44;-629.3024,2495.019;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.BreakToComponentsNode;45;-520.5179,2201.517;Inherit;False;FLOAT3;1;0;FLOAT3;0,0,0;False;16;FLOAT;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT;5;FLOAT;6;FLOAT;7;FLOAT;8;FLOAT;9;FLOAT;10;FLOAT;11;FLOAT;12;FLOAT;13;FLOAT;14;FLOAT;15
Node;AmplifyShaderEditor.GetLocalVarNode;47;-1270.255,2119.736;Inherit;False;38;Scale;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;46;-1250.409,1941.749;Inherit;False;36;position;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode;40;-1216.096,2245.499;Inherit;False;Property;_Float5;Float 4;6;0;Create;True;0;0;0;False;0;False;0;-1.2;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.WorldPosInputsNode;41;-1259.112,1706.792;Inherit;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.GetLocalVarNode;42;-2347.824,1202.789;Inherit;False;36;position;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.WorldPosInputsNode;43;-2496.794,1045.243;Inherit;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SimpleAddOpNode;50;-345.3418,2284.639;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DistanceOpNode;48;-1973.481,1236.828;Inherit;False;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;4;-674.4601,-64.79114;Inherit;False;Property;_Color0;Color 0;0;1;[HDR];Create;True;0;0;0;False;0;False;0,0,0,0;0,3.51884,18.16482,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;49;-2020.619,1397.207;Inherit;False;Property;_Lightrange1;Lightrange;3;0;Create;True;0;0;0;False;0;False;0;1.27;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.DistanceOpNode;52;-812.5994,1887.176;Inherit;False;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;51;-811.8994,2129.006;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;27;-214.054,169.2389;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.Vector3Node;57;-1895.103,1615.331;Inherit;False;Constant;_Vector2;Vector 1;2;0;Create;True;0;0;0;False;0;False;0,0,1;0,0,0;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.DynamicAppendNode;53;-206.3331,2130.187;Inherit;False;FLOAT4;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.RangedFloatNode;26;239.9219,250.5091;Inherit;False;Property;_transform;transform;1;0;Create;True;0;0;0;False;0;False;0;0.43;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;28;-0.913826,-69.7521;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;55;-1763.188,1300.965;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;58;-497.3649,1938.873;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.Vector2Node;54;-343.1679,1601.574;Inherit;False;Property;_Vector3;Vector 2;4;0;Create;True;0;0;0;False;0;False;0,1;0.26,-2.13;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.GetLocalVarNode;56;-2295.86,1462.056;Inherit;False;38;Scale;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;59;-69.61847,2484.871;Inherit;False;Constant;_Float6;Float 5;6;0;Create;True;0;0;0;False;0;False;19.12;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.ConditionalIfNode;61;-1564.918,1399.728;Inherit;False;False;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;4;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;63;-1273.478,1508.95;Inherit;False;Constant;_Float4;Float 3;1;0;Create;True;0;0;0;False;0;False;0.99;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;60;-40.81598,1588.003;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;25;460.8179,87.59843;Inherit;False;FLOAT4;4;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.NoiseGeneratorNode;62;-14.27109,2048.132;Inherit;True;Simplex2D;True;False;2;0;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;67;138.2289,1509.496;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ClipNode;65;-1013.605,1329.62;Inherit;False;3;0;FLOAT4;0,0,0,0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.RangedFloatNode;64;-20.99979,1724.732;Inherit;False;Constant;_Float7;Float 6;5;0;Create;True;0;0;0;False;0;False;0.03;0.51;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.Vector3Node;66;-20.19,1816.828;Inherit;False;Constant;_Vector4;Vector 3;5;0;Create;True;0;0;0;False;0;False;0,0,1;0,0,0;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.RegisterLocalVarNode;70;-448.5518,1338.721;Inherit;False;CLIP;-1;True;1;0;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.ColorNode;68;433.7832,1776.133;Inherit;False;Property;_Color3;Color 2;5;1;[HDR];Create;True;0;0;0;False;0;False;0,0,0,0;0,2.462395,4.237095,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ConditionalIfNode;69;441.1782,1520.962;Inherit;False;False;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;4;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;72;151.3345,1368.304;Inherit;False;70;CLIP;1;0;OBJECT;;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;71;752.5891,1490.212;Inherit;False;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;75;-2030.805,1540.705;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;73;-1157.383,2656.038;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;74;-2265.899,1664.785;Inherit;False;Property;_Float8;Float 7;7;0;Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;76;951.6933,1377.412;Inherit;False;2;2;0;FLOAT4;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;0;1574.281,253.2548;Float;False;True;-1;2;ASEMaterialInspector;100;1;ke;0770190933193b94aaa3065e307002fa;True;Unlit;0;0;Unlit;2;True;2;5;False;-1;10;False;-1;0;1;False;-1;0;False;-1;True;0;False;-1;0;False;-1;False;False;False;False;False;False;True;0;False;-1;True;0;False;-1;True;True;True;True;True;0;False;-1;False;False;False;True;False;255;False;-1;255;False;-1;255;False;-1;7;False;-1;1;False;-1;1;False;-1;1;False;-1;7;False;-1;1;False;-1;1;False;-1;1;False;-1;True;1;False;-1;True;3;False;-1;True;True;0;False;-1;0;False;-1;True;1;RenderType=Opaque=RenderType;True;2;0;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;1;LightMode=ForwardBase;False;0;;0;0;Standard;1;Vertex Position,InvertActionOnDeselection;1;0;1;True;False;;False;0
WireConnection;10;0;6;0
WireConnection;11;0;9;3
WireConnection;11;1;10;0
WireConnection;13;0;9;2
WireConnection;13;1;9;3
WireConnection;15;0;13;0
WireConnection;15;1;11;0
WireConnection;15;2;12;2
WireConnection;39;0;32;0
WireConnection;39;1;33;0
WireConnection;36;0;31;0
WireConnection;18;0;15;0
WireConnection;38;0;34;1
WireConnection;29;0;18;0
WireConnection;29;1;30;0
WireConnection;1;1;2;1
WireConnection;1;2;2;2
WireConnection;1;3;2;3
WireConnection;44;0;37;0
WireConnection;45;0;39;0
WireConnection;50;0;45;1
WireConnection;50;1;44;0
WireConnection;48;0;43;0
WireConnection;48;1;42;0
WireConnection;52;0;41;0
WireConnection;52;1;46;0
WireConnection;51;0;47;0
WireConnection;51;1;40;0
WireConnection;27;0;1;0
WireConnection;27;1;29;0
WireConnection;53;0;45;0
WireConnection;53;1;50;0
WireConnection;28;0;4;0
WireConnection;28;1;27;0
WireConnection;55;0;48;0
WireConnection;55;1;49;0
WireConnection;58;0;52;0
WireConnection;58;1;51;0
WireConnection;61;0;55;0
WireConnection;61;1;56;0
WireConnection;61;2;57;1
WireConnection;61;3;57;2
WireConnection;61;4;57;3
WireConnection;60;0;54;1
WireConnection;60;1;54;2
WireConnection;60;2;58;0
WireConnection;25;0;28;0
WireConnection;25;3;26;0
WireConnection;62;0;53;0
WireConnection;62;1;59;0
WireConnection;67;0;60;0
WireConnection;67;1;62;0
WireConnection;65;0;25;0
WireConnection;65;1;61;0
WireConnection;65;2;63;0
WireConnection;70;0;65;0
WireConnection;69;0;67;0
WireConnection;69;1;64;0
WireConnection;69;2;66;1
WireConnection;69;3;66;2
WireConnection;69;4;66;3
WireConnection;71;0;69;0
WireConnection;71;1;68;0
WireConnection;75;0;56;0
WireConnection;75;1;74;0
WireConnection;76;0;72;0
WireConnection;76;1;71;0
WireConnection;0;0;76;0
ASEEND*/
//CHKSM=6DABB4D48DFA9D5BF2B151D84E69E9744E9ABAA0