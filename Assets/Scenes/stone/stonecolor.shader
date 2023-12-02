// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "stone"
{
	Properties
	{
		_TextureSample0("Texture Sample 0", 2D) = "white" {}
		_flow("flow", Vector) = (0,0.32,0,0)
		_emi("emi", 2D) = "white" {}
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

			uniform sampler2D _TextureSample0;
			uniform float2 _flow;
			uniform sampler2D _emi;
			uniform float4 _emi_ST;
			uniform float3 POS;
			uniform float _Lightrange1;
			uniform float3 ssss;
			uniform float2 _Vector3;
			uniform float _Float5;
			uniform float4 _Color3;
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
				float4 color17 = IsGammaSpace() ? float4(4.287094,0,0,0) : float4(24.59001,0,0,0);
				float3 ase_worldViewDir = UnityWorldSpaceViewDir(WorldPosition);
				ase_worldViewDir = normalize(ase_worldViewDir);
				float3 ase_worldNormal = i.ase_texcoord1.xyz;
				float3 _Vector1 = float3(0,1,17.75);
				float fresnelNdotV16 = dot( ase_worldNormal, ase_worldViewDir );
				float fresnelNode16 = ( _Vector1.x + _Vector1.y * pow( 1.0 - fresnelNdotV16, _Vector1.z ) );
				float2 texCoord4 = i.ase_texcoord2.xy * float2( 1,1 ) + float2( 0,0 );
				float2 break5 = texCoord4;
				float mulTime13 = _Time.y * 0.05;
				float4 appendResult6 = (float4(break5.x , ( break5.y + mulTime13 ) , 0.0 , 0.0));
				float simplePerlin2D3 = snoise( appendResult6.xy*12.08 );
				simplePerlin2D3 = simplePerlin2D3*0.5 + 0.5;
				float2 texCoord2 = i.ase_texcoord2.xy * float2( 1,1 ) + float2( 0,0 );
				float4 tex2DNode1 = tex2D( _TextureSample0, ( (0.0 + (simplePerlin2D3 - _flow.x) * (1.0 - 0.0) / (_flow.y - _flow.x)) + texCoord2 ) );
				float2 uv_emi = i.ase_texcoord2.xy * _emi_ST.xy + _emi_ST.zw;
				float3 position27 = POS;
				float Scale29 = ssss.x;
				float3 _Vector2 = float3(0,0,1);
				float ifLocalVar52 = 0;
				if( ( distance( WorldPosition , position27 ) + _Lightrange1 ) > Scale29 )
				ifLocalVar52 = _Vector2.x;
				else if( ( distance( WorldPosition , position27 ) + _Lightrange1 ) == Scale29 )
				ifLocalVar52 = _Vector2.y;
				else if( ( distance( WorldPosition , position27 ) + _Lightrange1 ) < Scale29 )
				ifLocalVar52 = _Vector2.z;
				clip( ifLocalVar52 - 0.99);
				float4 CLIP61 = ( ( color17 * fresnelNode16 ) + tex2DNode1 + ( tex2D( _emi, uv_emi ) * tex2DNode1 ) );
				float lerpResult51 = lerp( _Vector3.x , _Vector3.y , ( distance( WorldPosition , position27 ) - ( Scale29 + _Float5 ) ));
				float3 break36 = ( WorldPosition * 0.26 );
				float mulTime35 = _Time.y * 0.08;
				float4 appendResult44 = (float4(break36.x , ( break36.y + mulTime35 ) , 0.0 , 0.0));
				float simplePerlin2D53 = snoise( appendResult44.xy*19.12 );
				simplePerlin2D53 = simplePerlin2D53*0.5 + 0.5;
				float3 _Vector4 = float3(0,0,1);
				float ifLocalVar60 = 0;
				if( ( lerpResult51 * simplePerlin2D53 ) > 0.03 )
				ifLocalVar60 = _Vector4.x;
				else if( ( lerpResult51 * simplePerlin2D53 ) == 0.03 )
				ifLocalVar60 = _Vector4.y;
				else if( ( lerpResult51 * simplePerlin2D53 ) < 0.03 )
				ifLocalVar60 = _Vector4.z;
				
				
				finalColor = ( CLIP61 + ( ifLocalVar60 * _Color3 ) );
				return finalColor;
			}
			ENDCG
		}
	}
	CustomEditor "ASEMaterialInspector"
	
	
}
/*ASEBEGIN
Version=18800
110.4;612.8;1440.8;867;3042.267;2271.365;1.548589;True;False
Node;AmplifyShaderEditor.RangedFloatNode;14;-1446.267,-81.79834;Inherit;False;Constant;_Float1;Float 1;2;0;Create;True;0;0;0;False;0;False;0.05;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;4;-1473.421,-367.1544;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleTimeNode;13;-1299.267,-87.79834;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.BreakToComponentsNode;5;-1183.796,-294.4307;Inherit;False;FLOAT2;1;0;FLOAT2;0,0;False;16;FLOAT;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT;5;FLOAT;6;FLOAT;7;FLOAT;8;FLOAT;9;FLOAT;10;FLOAT;11;FLOAT;12;FLOAT;13;FLOAT;14;FLOAT;15
Node;AmplifyShaderEditor.SimpleAddOpNode;12;-1150.267,-158.7984;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;6;-931.7958,-351.4307;Inherit;False;FLOAT4;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.RangedFloatNode;8;-961.4134,-163.4669;Inherit;False;Constant;_Float0;Float 0;1;0;Create;True;0;0;0;False;0;False;12.08;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.Vector2Node;11;-497.1148,-235.4274;Inherit;False;Property;_flow;flow;1;0;Create;True;0;0;0;False;0;False;0,0.32;0,71.9;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.CommentaryNode;26;-2586.885,-2770.88;Inherit;False;2034.706;773.7719;CLIP;15;66;65;56;54;52;48;47;46;40;39;34;33;32;29;27;;1,1,1,1;0;0
Node;AmplifyShaderEditor.NoiseGeneratorNode;3;-713.2423,-420.7083;Inherit;True;Simplex2D;True;False;2;0;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.WorldPosInputsNode;23;-1086.994,-1438.653;Inherit;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.RangedFloatNode;24;-888.3665,-1336.011;Inherit;False;Constant;_Float10;Float 9;8;0;Create;True;0;0;0;False;0;False;0.26;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.Vector3Node;22;-2792.302,-2254.373;Inherit;False;Global;POS;POS;3;0;Create;True;0;0;0;False;0;False;0,0,0;-0.79,1.06,-14.85;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.Vector3Node;25;-2787.823,-2064.194;Inherit;False;Global;ssss;ssss;3;0;Create;True;0;0;0;False;0;False;0,0,0;1.796523,1.796523,1.796523;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.RegisterLocalVarNode;29;-2576.166,-2052.595;Inherit;False;Scale;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;30;-762.4365,-1454.594;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.TFHCRemapNode;10;-328.3551,-383.0016;Inherit;False;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;0;False;4;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;2;-591.6703,-61.91847;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RegisterLocalVarNode;27;-2586.318,-2251.393;Inherit;False;position;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode;28;-821.5125,-1235.086;Inherit;False;Constant;_Float9;Float 8;8;0;Create;True;0;0;0;False;0;False;0.08;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.Vector3Node;19;-409.779,-574.3578;Inherit;False;Constant;_Vector1;Vector 1;2;0;Create;True;0;0;0;False;0;False;0,1,17.75;0.06,0,0;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SimpleAddOpNode;7;-160.6703,-224.9185;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleTimeNode;35;-669.3925,-1271.105;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.BreakToComponentsNode;36;-560.608,-1564.606;Inherit;False;FLOAT3;1;0;FLOAT3;0,0,0;False;16;FLOAT;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT;5;FLOAT;6;FLOAT;7;FLOAT;8;FLOAT;9;FLOAT;10;FLOAT;11;FLOAT;12;FLOAT;13;FLOAT;14;FLOAT;15
Node;AmplifyShaderEditor.WorldPosInputsNode;32;-1299.203,-2059.331;Inherit;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.WorldPosInputsNode;34;-2536.885,-2720.88;Inherit;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.GetLocalVarNode;33;-2387.915,-2563.334;Inherit;False;27;position;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode;31;-1256.187,-1520.625;Inherit;False;Property;_Float5;Float 4;6;0;Create;True;0;0;0;False;0;False;0;0.14;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;38;-1310.345,-1646.387;Inherit;False;29;Scale;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;37;-1290.5,-1824.374;Inherit;False;27;position;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SamplerNode;20;131.307,-871.0096;Inherit;True;Property;_emi;emi;2;0;Create;True;0;0;0;False;0;False;-1;None;8cf4f75cbb5f74a4bb549a2e5ab26ad3;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.DistanceOpNode;39;-2013.572,-2529.295;Inherit;False;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.FresnelNode;16;-27.24294,-462.4699;Inherit;True;Standard;WorldNormal;ViewDir;False;False;5;0;FLOAT3;0,0,1;False;4;FLOAT3;0,0,0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;5;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;1;5.16519,-178.9656;Inherit;True;Property;_TextureSample0;Texture Sample 0;0;0;Create;True;0;0;0;False;0;False;-1;None;1dabc4f12111bbf40835121006bf10dd;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;40;-2060.709,-2368.916;Inherit;False;Property;_Lightrange1;Lightrange;3;0;Create;True;0;0;0;False;0;False;0;0.01;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;42;-851.9895,-1637.117;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DistanceOpNode;43;-852.6895,-1878.947;Inherit;False;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;41;-385.4319,-1481.484;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;17;27.62739,-654.6691;Inherit;False;Constant;_Color0;Color 0;2;1;[HDR];Create;True;0;0;0;False;0;False;4.287094,0,0,0;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;47;-2335.95,-2304.067;Inherit;False;29;Scale;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.Vector2Node;45;-383.258,-2164.549;Inherit;False;Property;_Vector3;Vector 2;4;0;Create;True;0;0;0;False;0;False;0,1;0.26,-2.13;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;18;307.4915,-555.6393;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.DynamicAppendNode;44;-246.4232,-1635.937;Inherit;False;FLOAT4;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.RangedFloatNode;50;-109.7086,-1281.253;Inherit;False;Constant;_Float6;Float 5;6;0;Create;True;0;0;0;False;0;False;19.12;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;46;-1803.279,-2465.158;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.Vector3Node;48;-1935.193,-2150.792;Inherit;False;Constant;_Vector2;Vector 1;2;0;Create;True;0;0;0;False;0;False;0,0,1;0,0,0;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SimpleSubtractOpNode;49;-537.455,-1827.25;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;21;543.3391,-992.1424;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.ConditionalIfNode;52;-1605.008,-2366.395;Inherit;False;False;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;4;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;51;-80.90607,-2178.12;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.NoiseGeneratorNode;53;-54.36118,-1717.991;Inherit;True;Simplex2D;True;False;2;0;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;15;944.671,-391.6387;Inherit;False;3;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;54;-1313.568,-2257.173;Inherit;False;Constant;_Float4;Float 3;1;0;Create;True;0;0;0;False;0;False;0.99;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;55;-61.08987,-2041.391;Inherit;False;Constant;_Float7;Float 6;5;0;Create;True;0;0;0;False;0;False;0.03;0.51;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.Vector3Node;57;-60.28009,-1949.295;Inherit;False;Constant;_Vector4;Vector 3;5;0;Create;True;0;0;0;False;0;False;0,0,1;0,0,0;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.ClipNode;56;-1053.695,-2436.503;Inherit;False;3;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;58;98.13882,-2256.627;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;59;393.6931,-1989.99;Inherit;False;Property;_Color3;Color 2;5;1;[HDR];Create;True;0;0;0;False;0;False;0,0,0,0;0,2.462395,4.237095,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ConditionalIfNode;60;401.0881,-2245.161;Inherit;False;False;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;4;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;61;-488.6419,-2427.402;Inherit;False;CLIP;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;63;111.2444,-2397.819;Inherit;False;61;CLIP;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;62;712.499,-2275.911;Inherit;False;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;67;911.6032,-2388.711;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;64;-1197.474,-1110.085;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;65;-2305.99,-2101.338;Inherit;False;Property;_Float8;Float 7;7;0;Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;66;-2070.896,-2225.418;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;0;1614.855,-539.2253;Float;False;True;-1;2;ASEMaterialInspector;100;1;stone;0770190933193b94aaa3065e307002fa;True;Unlit;0;0;Unlit;2;True;0;1;False;-1;0;False;-1;0;1;False;-1;0;False;-1;True;0;False;-1;0;False;-1;False;False;False;False;False;False;True;0;False;-1;True;0;False;-1;True;True;True;True;True;0;False;-1;False;False;False;True;False;255;False;-1;255;False;-1;255;False;-1;7;False;-1;1;False;-1;1;False;-1;1;False;-1;7;False;-1;1;False;-1;1;False;-1;1;False;-1;True;1;False;-1;True;3;False;-1;True;True;0;False;-1;0;False;-1;True;1;RenderType=Opaque=RenderType;True;2;0;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;1;LightMode=ForwardBase;False;0;;0;0;Standard;1;Vertex Position,InvertActionOnDeselection;1;0;1;True;False;;False;0
WireConnection;13;0;14;0
WireConnection;5;0;4;0
WireConnection;12;0;5;1
WireConnection;12;1;13;0
WireConnection;6;0;5;0
WireConnection;6;1;12;0
WireConnection;3;0;6;0
WireConnection;3;1;8;0
WireConnection;29;0;25;1
WireConnection;30;0;23;0
WireConnection;30;1;24;0
WireConnection;10;0;3;0
WireConnection;10;1;11;1
WireConnection;10;2;11;2
WireConnection;27;0;22;0
WireConnection;7;0;10;0
WireConnection;7;1;2;0
WireConnection;35;0;28;0
WireConnection;36;0;30;0
WireConnection;39;0;34;0
WireConnection;39;1;33;0
WireConnection;16;1;19;1
WireConnection;16;2;19;2
WireConnection;16;3;19;3
WireConnection;1;1;7;0
WireConnection;42;0;38;0
WireConnection;42;1;31;0
WireConnection;43;0;32;0
WireConnection;43;1;37;0
WireConnection;41;0;36;1
WireConnection;41;1;35;0
WireConnection;18;0;17;0
WireConnection;18;1;16;0
WireConnection;44;0;36;0
WireConnection;44;1;41;0
WireConnection;46;0;39;0
WireConnection;46;1;40;0
WireConnection;49;0;43;0
WireConnection;49;1;42;0
WireConnection;21;0;20;0
WireConnection;21;1;1;0
WireConnection;52;0;46;0
WireConnection;52;1;47;0
WireConnection;52;2;48;1
WireConnection;52;3;48;2
WireConnection;52;4;48;3
WireConnection;51;0;45;1
WireConnection;51;1;45;2
WireConnection;51;2;49;0
WireConnection;53;0;44;0
WireConnection;53;1;50;0
WireConnection;15;0;18;0
WireConnection;15;1;1;0
WireConnection;15;2;21;0
WireConnection;56;0;15;0
WireConnection;56;1;52;0
WireConnection;56;2;54;0
WireConnection;58;0;51;0
WireConnection;58;1;53;0
WireConnection;60;0;58;0
WireConnection;60;1;55;0
WireConnection;60;2;57;1
WireConnection;60;3;57;2
WireConnection;60;4;57;3
WireConnection;61;0;56;0
WireConnection;62;0;60;0
WireConnection;62;1;59;0
WireConnection;67;0;63;0
WireConnection;67;1;62;0
WireConnection;66;0;47;0
WireConnection;66;1;65;0
WireConnection;0;0;67;0
ASEEND*/
//CHKSM=38C96D0309B969F6A5AF7E3DE815E69047BFBF10