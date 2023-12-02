// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "gudu"
{
	Properties
	{
		_TextureSample0("Texture Sample 0", 2D) = "white" {}
		[HDR]_Color0("Color 0", Color) = (0,0,0,0)
		_Lightrange("Lightrange", Float) = 0
		_Vector1("Vector 1", Vector) = (0,1,0,0)
		[HDR]_Color2("Color 2", Color) = (0,0,0,0)
		_Float2("Float 2", Float) = 0
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
			#define ASE_NEEDS_FRAG_WORLD_POSITION


			struct MeshData
			{
				float4 vertex : POSITION;
				float4 color : COLOR;
				float3 ase_normal : NORMAL;
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

			uniform float4 _Color0;
			uniform sampler2D _TextureSample0;
			uniform float4 _TextureSample0_ST;
			uniform float3 POS;
			uniform float _Lightrange;
			uniform float3 ssss;
			uniform float2 _Vector1;
			uniform float _Float2;
			uniform float4 _Color2;
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
				
				o.ase_texcoord2.xy = v.ase_texcoord.xy;
				
				//setting value to unused interpolator channels and avoid initialization warnings
				o.ase_texcoord1.w = 0;
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
				float3 ase_worldViewDir = UnityWorldSpaceViewDir(WorldPosition);
				ase_worldViewDir = normalize(ase_worldViewDir);
				float3 ase_worldNormal = i.ase_texcoord1.xyz;
				float3 _Vector0 = float3(0,1,5.53);
				float fresnelNdotV2 = dot( ase_worldNormal, ase_worldViewDir );
				float fresnelNode2 = ( _Vector0.x + _Vector0.y * pow( 1.0 - fresnelNdotV2, _Vector0.z ) );
				float2 uv_TextureSample0 = i.ase_texcoord2.xy * _TextureSample0_ST.xy + _TextureSample0_ST.zw;
				float3 position13 = POS;
				float Scale15 = ssss.x;
				float3 _Vector2 = float3(0,0,1);
				float ifLocalVar38 = 0;
				if( ( distance( WorldPosition , position13 ) + _Lightrange ) > Scale15 )
				ifLocalVar38 = _Vector2.x;
				else if( ( distance( WorldPosition , position13 ) + _Lightrange ) == Scale15 )
				ifLocalVar38 = _Vector2.y;
				else if( ( distance( WorldPosition , position13 ) + _Lightrange ) < Scale15 )
				ifLocalVar38 = _Vector2.z;
				clip( ifLocalVar38 - 0.99);
				float4 CLIP47 = ( ( _Color0 * fresnelNode2 ) + tex2D( _TextureSample0, uv_TextureSample0 ) );
				float lerpResult37 = lerp( _Vector1.x , _Vector1.y , ( distance( WorldPosition , position13 ) - ( Scale15 + _Float2 ) ));
				float3 break22 = ( WorldPosition * 0.26 );
				float mulTime21 = _Time.y * 0.08;
				float4 appendResult30 = (float4(break22.x , ( break22.y + mulTime21 ) , 0.0 , 0.0));
				float simplePerlin2D39 = snoise( appendResult30.xy*19.12 );
				simplePerlin2D39 = simplePerlin2D39*0.5 + 0.5;
				float3 _Vector3 = float3(0,0,1);
				float ifLocalVar46 = 0;
				if( ( lerpResult37 * simplePerlin2D39 ) > 0.03 )
				ifLocalVar46 = _Vector3.x;
				else if( ( lerpResult37 * simplePerlin2D39 ) == 0.03 )
				ifLocalVar46 = _Vector3.y;
				else if( ( lerpResult37 * simplePerlin2D39 ) < 0.03 )
				ifLocalVar46 = _Vector3.z;
				
				
				finalColor = ( CLIP47 + ( ifLocalVar46 * _Color2 ) );
				return finalColor;
			}
			ENDCG
		}
	}
	CustomEditor "ASEMaterialInspector"
	
	
}
/*ASEBEGIN
Version=18800
110.4;612.8;1440.8;867;2393.713;-451.5428;1;True;False
Node;AmplifyShaderEditor.CommentaryNode;12;-2448.871,-39.6936;Inherit;False;2034.706;773.7719;CLIP;15;52;51;42;40;38;34;33;32;26;25;20;19;18;15;13;;1,1,1,1;0;0
Node;AmplifyShaderEditor.Vector3Node;8;-2654.289,476.8134;Inherit;False;Global;POS;POS;3;0;Create;True;0;0;0;False;0;False;0,0,0;-0.79,1.06,-14.85;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.WorldPosInputsNode;9;-948.9799,1292.534;Inherit;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.RangedFloatNode;10;-750.3528,1395.176;Inherit;False;Constant;_Float0;Float 0;8;0;Create;True;0;0;0;False;0;False;0.26;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.Vector3Node;11;-2649.81,666.9924;Inherit;False;Global;ssss;ssss;3;0;Create;True;0;0;0;False;0;False;0,0,0;1.796523,1.796523,1.796523;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.RegisterLocalVarNode;13;-2448.305,479.7933;Inherit;False;position;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode;14;-683.4988,1496.1;Inherit;False;Constant;_Float1;Float 1;8;0;Create;True;0;0;0;False;0;False;0.08;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;15;-2438.152,678.5914;Inherit;False;Scale;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;16;-624.4229,1276.592;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode;17;-1118.173,1210.562;Inherit;False;Property;_Float2;Float 2;5;0;Create;True;0;0;0;False;0;False;0;0.14;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.WorldPosInputsNode;18;-1161.189,671.8553;Inherit;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.GetLocalVarNode;19;-2249.901,167.8524;Inherit;False;13;position;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleTimeNode;21;-531.3788,1460.082;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.WorldPosInputsNode;20;-2398.871,10.3064;Inherit;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.GetLocalVarNode;23;-1152.486,906.8124;Inherit;False;13;position;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.GetLocalVarNode;24;-1172.332,1084.799;Inherit;False;15;Scale;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.Vector3Node;3;-1781.86,-404.393;Inherit;False;Constant;_Vector0;Vector 0;1;0;Create;True;0;0;0;False;0;False;0,1,5.53;0,0,0;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.BreakToComponentsNode;22;-422.5943,1166.58;Inherit;False;FLOAT3;1;0;FLOAT3;0,0,0;False;16;FLOAT;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT;5;FLOAT;6;FLOAT;7;FLOAT;8;FLOAT;9;FLOAT;10;FLOAT;11;FLOAT;12;FLOAT;13;FLOAT;14;FLOAT;15
Node;AmplifyShaderEditor.DistanceOpNode;25;-1875.558,201.8914;Inherit;False;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;26;-1922.696,362.2704;Inherit;False;Property;_Lightrange;Lightrange;2;0;Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;27;-247.4182,1249.702;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;28;-713.9758,1094.069;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DistanceOpNode;29;-714.6758,852.2394;Inherit;False;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.FresnelNode;2;-1479.45,-506.679;Inherit;True;Standard;WorldNormal;ViewDir;False;False;5;0;FLOAT3;0,0,1;False;4;FLOAT3;0,0,0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;5;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;7;-1492.928,-802.173;Inherit;False;Property;_Color0;Color 0;1;1;[HDR];Create;True;0;0;0;False;0;False;0,0,0,0;0.01184153,0.01184153,0.01184153,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.DynamicAppendNode;30;-108.4095,1095.249;Inherit;False;FLOAT4;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.GetLocalVarNode;33;-2197.937,427.1194;Inherit;False;15;Scale;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;35;-399.4413,903.9364;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.Vector2Node;31;-245.2443,566.6375;Inherit;False;Property;_Vector1;Vector 1;3;0;Create;True;0;0;0;False;0;False;0,1;0.26,-2.13;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.SamplerNode;1;-1621.359,-170.3462;Inherit;True;Property;_TextureSample0;Texture Sample 0;0;0;Create;True;0;0;0;False;0;False;-1;None;8aa4f3007717c704793befc56f60375b;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.Vector3Node;34;-1797.18,580.3944;Inherit;False;Constant;_Vector2;Vector 2;2;0;Create;True;0;0;0;False;0;False;0,0,1;0,0,0;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.RangedFloatNode;36;28.30511,1449.933;Inherit;False;Constant;_Float5;Float 5;6;0;Create;True;0;0;0;False;0;False;19.12;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;6;-1151.864,-550.6815;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;32;-1665.265,266.0284;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;37;57.1076,553.0664;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;5;-1005.447,-409.4327;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;40;-1175.555,474.0134;Inherit;False;Constant;_Float3;Float 3;1;0;Create;True;0;0;0;False;0;False;0.99;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.NoiseGeneratorNode;39;83.6525,1013.195;Inherit;True;Simplex2D;True;False;2;0;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.ConditionalIfNode;38;-1466.995,364.7914;Inherit;False;False;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;4;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.Vector3Node;43;77.73358,781.8914;Inherit;False;Constant;_Vector3;Vector 3;5;0;Create;True;0;0;0;False;0;False;0,0,1;0,0,0;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.RangedFloatNode;41;76.9238,689.7954;Inherit;False;Constant;_Float6;Float 6;5;0;Create;True;0;0;0;False;0;False;0.03;0.51;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;44;236.1525,474.5594;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ClipNode;42;-915.6818,294.6833;Inherit;False;3;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.ConditionalIfNode;46;539.1018,486.0254;Inherit;False;False;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;4;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;47;-350.6282,303.7844;Inherit;False;CLIP;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.ColorNode;45;531.7068,741.1964;Inherit;False;Property;_Color2;Color 2;4;1;[HDR];Create;True;0;0;0;False;0;False;0,0,0,0;0,2.462395,4.237095,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;48;850.5127,455.2754;Inherit;False;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;49;249.2581,333.3674;Inherit;False;47;CLIP;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;53;1049.617,342.4753;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;52;-1932.882,505.7684;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;51;-2167.976,629.8484;Inherit;False;Property;_Float7;Float 7;6;0;Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;50;-1059.46,1621.101;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;0;1511.79,301.3889;Float;False;True;-1;2;ASEMaterialInspector;100;1;gudu;0770190933193b94aaa3065e307002fa;True;Unlit;0;0;Unlit;2;True;0;1;False;-1;0;False;-1;0;1;False;-1;0;False;-1;True;0;False;-1;0;False;-1;False;False;False;False;False;False;True;0;False;-1;True;0;False;-1;True;True;True;True;True;0;False;-1;False;False;False;True;False;255;False;-1;255;False;-1;255;False;-1;7;False;-1;1;False;-1;1;False;-1;1;False;-1;7;False;-1;1;False;-1;1;False;-1;1;False;-1;True;1;False;-1;True;3;False;-1;True;True;0;False;-1;0;False;-1;True;1;RenderType=Opaque=RenderType;True;2;0;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;1;LightMode=ForwardBase;False;0;;0;0;Standard;1;Vertex Position,InvertActionOnDeselection;1;0;1;True;False;;False;0
WireConnection;13;0;8;0
WireConnection;15;0;11;1
WireConnection;16;0;9;0
WireConnection;16;1;10;0
WireConnection;21;0;14;0
WireConnection;22;0;16;0
WireConnection;25;0;20;0
WireConnection;25;1;19;0
WireConnection;27;0;22;1
WireConnection;27;1;21;0
WireConnection;28;0;24;0
WireConnection;28;1;17;0
WireConnection;29;0;18;0
WireConnection;29;1;23;0
WireConnection;2;1;3;1
WireConnection;2;2;3;2
WireConnection;2;3;3;3
WireConnection;30;0;22;0
WireConnection;30;1;27;0
WireConnection;35;0;29;0
WireConnection;35;1;28;0
WireConnection;6;0;7;0
WireConnection;6;1;2;0
WireConnection;32;0;25;0
WireConnection;32;1;26;0
WireConnection;37;0;31;1
WireConnection;37;1;31;2
WireConnection;37;2;35;0
WireConnection;5;0;6;0
WireConnection;5;1;1;0
WireConnection;39;0;30;0
WireConnection;39;1;36;0
WireConnection;38;0;32;0
WireConnection;38;1;33;0
WireConnection;38;2;34;1
WireConnection;38;3;34;2
WireConnection;38;4;34;3
WireConnection;44;0;37;0
WireConnection;44;1;39;0
WireConnection;42;0;5;0
WireConnection;42;1;38;0
WireConnection;42;2;40;0
WireConnection;46;0;44;0
WireConnection;46;1;41;0
WireConnection;46;2;43;1
WireConnection;46;3;43;2
WireConnection;46;4;43;3
WireConnection;47;0;42;0
WireConnection;48;0;46;0
WireConnection;48;1;45;0
WireConnection;53;0;49;0
WireConnection;53;1;48;0
WireConnection;52;0;33;0
WireConnection;52;1;51;0
WireConnection;0;0;53;0
ASEEND*/
//CHKSM=86282950B660C33CA400D26B46C13D34BA897394