// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "ke"
{
	Properties
	{
		_TextureSample0("Texture Sample 0", 2D) = "white" {}
		[HDR]_Color0("Color 0", Color) = (0,0.1307677,0.2496474,0)
		_Float15("Float 13", Float) = 0
		_TextureSample1("Texture Sample 1", 2D) = "white" {}
		_XXX("XXX", Float) = 0
		[HDR]_Color1("Color 1", Color) = (0,0,0,0)
		_Float20("Float 18", Float) = 0
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

			#define ASE_ABSOLUTE_VERTEX_POS 1


			#ifndef UNITY_SETUP_STEREO_EYE_INDEX_POST_VERTEX
			//only defining to not throw compilation error over Unity 5.5
			#define UNITY_SETUP_STEREO_EYE_INDEX_POST_VERTEX(input)
			#endif
			#pragma vertex vert
			#pragma fragment frag
			#pragma multi_compile_instancing
			#include "UnityCG.cginc"
			#include "UnityShaderVariables.cginc"
			#define ASE_NEEDS_VERT_POSITION
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

			uniform float _Float15;
			uniform float _XXX;
			uniform sampler2D _TextureSample1;
			uniform float4 _TextureSample1_ST;
			uniform float4 _Color0;
			uniform sampler2D _TextureSample0;
			uniform float4 _TextureSample0_ST;
			uniform float4 _Color1;
			uniform float _Float20;
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

				float3 break67 = v.vertex.xyz;
				float2 texCoord51 = v.ase_texcoord.xy * float2( 1,1 ) + float2( 0,0 );
				float2 break52 = texCoord51;
				float mulTime53 = _Time.y * 0.27;
				float4 appendResult57 = (float4(break52.x , ( break52.x + break52.y + mulTime53 ) , 0.0 , 0.0));
				float simplePerlin2D65 = snoise( appendResult57.xy*20.64 );
				simplePerlin2D65 = simplePerlin2D65*0.5 + 0.5;
				float4 appendResult75 = (float4(break67.x , break67.y , ( break67.z * _Float15 * simplePerlin2D65 ) , 0.0));
				float2 texCoord62 = v.ase_texcoord.xy * float2( 1,1 ) + float2( 0,0 );
				float2 _Vector4 = float2(1,0);
				float ifLocalVar77 = 0;
				if( ( _XXX + texCoord62.y ) <= 0.0 )
				ifLocalVar77 = _Vector4.y;
				else
				ifLocalVar77 = _Vector4.x;
				float4 lerpResult80 = lerp( float4( v.vertex.xyz , 0.0 ) , appendResult75 , ifLocalVar77);
				
				o.ase_texcoord1.xy = v.ase_texcoord.xy;
				o.ase_texcoord2 = v.vertex;
				
				//setting value to unused interpolator channels and avoid initialization warnings
				o.ase_texcoord1.zw = 0;
				float3 vertexValue = float3(0, 0, 0);
				#if ASE_ABSOLUTE_VERTEX_POS
				vertexValue = v.vertex.xyz;
				#endif
				vertexValue = lerpResult80.xyz;
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
				float2 uv_TextureSample1 = i.ase_texcoord1.xy * _TextureSample1_ST.xy + _TextureSample1_ST.zw;
				float3 break19 = WorldPosition;
				float4 appendResult18 = (float4(break19.x , ( break19.y + _Time.y ) , 0.0 , 0.0));
				float simplePerlin2D9 = snoise( appendResult18.xy*1.24 );
				simplePerlin2D9 = simplePerlin2D9*0.5 + 0.5;
				float2 uv_TextureSample0 = i.ase_texcoord1.xy * _TextureSample0_ST.xy + _TextureSample0_ST.zw;
				float2 _Vector5 = float2(1,0);
				float ifLocalVar72 = 0;
				if( ( _XXX + ( i.ase_texcoord2.xyz.z * 5.96 ) ) <= 0.0 )
				ifLocalVar72 = _Vector5.y;
				else
				ifLocalVar72 = _Vector5.x;
				clip( ( 1.0 - ifLocalVar72 ) - _Float20);
				
				
				finalColor = ( ( tex2D( _TextureSample1, uv_TextureSample1 ) * simplePerlin2D9 * _Color0 ) + ( tex2D( _TextureSample0, uv_TextureSample0 ) * _Color1 ) );
				return finalColor;
			}
			ENDCG
		}
	}
	CustomEditor "ASEMaterialInspector"
	
	
}
/*ASEBEGIN
Version=18800
6.4;242.4;1440.8;848.6;1866.459;-2404.423;2.769408;True;False
Node;AmplifyShaderEditor.WorldPosInputsNode;31;-850.5317,422.0718;Inherit;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.TextureCoordinatesNode;51;734.5612,3120.665;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;50;770.4582,3364.687;Inherit;False;Constant;_Float18;Float 16;10;0;Create;True;0;0;0;False;0;False;0.27;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.BreakToComponentsNode;19;-486.0322,391.9545;Inherit;False;FLOAT3;1;0;FLOAT3;0,0,0;False;16;FLOAT;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT;5;FLOAT;6;FLOAT;7;FLOAT;8;FLOAT;9;FLOAT;10;FLOAT;11;FLOAT;12;FLOAT;13;FLOAT;14;FLOAT;15
Node;AmplifyShaderEditor.SimpleTimeNode;15;-484.0049,583.7275;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleTimeNode;53;984.7272,3350.588;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.BreakToComponentsNode;52;982.5292,3085.72;Inherit;False;FLOAT2;1;0;FLOAT2;0,0;False;16;FLOAT;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT;5;FLOAT;6;FLOAT;7;FLOAT;8;FLOAT;9;FLOAT;10;FLOAT;11;FLOAT;12;FLOAT;13;FLOAT;14;FLOAT;15
Node;AmplifyShaderEditor.SimpleAddOpNode;13;-275.0322,467.9545;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.PosVertexDataNode;56;-650.9165,1886.872;Inherit;False;0;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;55;-481.8192,2077.826;Inherit;False;Constant;_Float1;Float 0;5;0;Create;True;0;0;0;False;0;False;5.96;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;54;1179.337,3151.365;Inherit;False;3;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;58;-228.0087,1946.585;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;20;7.226252,445.5336;Inherit;False;Constant;_Float0;Float 0;2;0;Create;True;0;0;0;False;0;False;1.24;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.PosVertexDataNode;61;368.372,2474.8;Inherit;False;0;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;79;681.024,3600.08;Inherit;False;Property;_XXX;XXX;5;0;Create;True;0;0;0;False;0;False;0;-1.29;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;60;1208.711,3308.218;Inherit;False;Constant;_Float13;Float 11;7;0;Create;True;0;0;0;False;0;False;20.64;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;57;1319.728,3100.32;Inherit;False;FLOAT4;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.DynamicAppendNode;18;-118.0322,381.9545;Inherit;False;FLOAT4;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.NoiseGeneratorNode;9;184.1295,175.4909;Inherit;True;Simplex2D;True;False;2;0;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;47;138.2759,-47.68289;Inherit;True;Property;_TextureSample1;Texture Sample 1;4;0;Create;True;0;0;0;False;0;False;-1;None;8147961f6fd10a2459c99783f3ae2293;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;49;557.5491,993.0097;Inherit;False;Property;_Color1;Color 1;6;1;[HDR];Create;True;0;0;0;False;0;False;0,0,0,0;0,1.059274,0.9952229,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;1;223.6178,669.4692;Inherit;True;Property;_TextureSample0;Texture Sample 0;0;0;Create;True;0;0;0;False;0;False;-1;None;e2de75fb59916de45b7c68ecba20c574;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.NoiseGeneratorNode;65;1468.32,3106.882;Inherit;True;Simplex2D;True;False;2;0;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;21;478.6828,411.3016;Inherit;False;Property;_Color0;Color 0;2;1;[HDR];Create;True;0;0;0;False;0;False;0,0.1307677,0.2496474,0;33.89676,0.7098798,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;63;143.751,1884.316;Inherit;False;Constant;_Float19;Float 17;9;0;Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.BreakToComponentsNode;67;879.9891,2545.611;Inherit;True;FLOAT3;1;0;FLOAT3;0,0,0;False;16;FLOAT;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT;5;FLOAT;6;FLOAT;7;FLOAT;8;FLOAT;9;FLOAT;10;FLOAT;11;FLOAT;12;FLOAT;13;FLOAT;14;FLOAT;15
Node;AmplifyShaderEditor.Vector2Node;68;148.462,1960.181;Inherit;False;Constant;_Vector5;Vector 3;9;0;Create;True;0;0;0;False;0;False;1,0;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.TextureCoordinatesNode;62;674.596,3709.84;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleAddOpNode;66;134.1,1778.029;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;64;1001.668,2759.138;Inherit;False;Property;_Float15;Float 13;3;0;Create;True;0;0;0;False;0;False;0;2.26;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;48;627.8442,668.3358;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;73;1238.138,2610.393;Inherit;False;3;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;3;690.1078,120.3259;Inherit;False;3;3;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;2;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.Vector2Node;69;1009.046,3762.04;Inherit;False;Constant;_Vector4;Vector 2;9;0;Create;True;0;0;0;False;0;False;1,0;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.SimpleAddOpNode;71;994.6852,3579.887;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ConditionalIfNode;72;600.765,1727.817;Inherit;False;False;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;4;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;70;1004.336,3686.174;Inherit;False;Constant;_Float16;Float 14;9;0;Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.PosVertexDataNode;76;1014.096,2183.39;Inherit;False;0;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;74;1016.315,2009.923;Inherit;False;Property;_Float20;Float 18;7;0;Create;True;0;0;0;False;0;False;0;0.96;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;78;1049.02,1859.04;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;46;1031.544,135.093;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.ConditionalIfNode;77;1595.659,3569.967;Inherit;False;False;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;4;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;75;1393.576,2498.372;Inherit;False;FLOAT4;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.Vector3Node;4;-52.65035,921.144;Inherit;False;Property;_Vector0;Vector 0;1;0;Create;True;0;0;0;False;0;False;0,0,0;2.48,5.01,1.56;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.ClipNode;81;1802.539,648.7399;Inherit;False;3;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.Vector3Node;59;147.7428,3155.56;Inherit;False;Global;boom;boom;5;0;Create;True;0;0;0;False;0;False;0,0,0;-5.32,5.53,-1.3;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.LerpOp;80;2109.053,2037.652;Inherit;False;3;0;FLOAT4;0,0,0,0;False;1;FLOAT4;0,0,0,0;False;2;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.FresnelNode;2;282.9262,897.6681;Inherit;False;Standard;WorldNormal;ViewDir;False;False;5;0;FLOAT3;0,0,1;False;4;FLOAT3;0,0,0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;5;False;1;FLOAT;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;0;2515.54,200.7518;Float;False;True;-1;2;ASEMaterialInspector;100;1;ke;0770190933193b94aaa3065e307002fa;True;Unlit;0;0;Unlit;2;True;0;1;False;-1;0;False;-1;0;1;False;-1;0;False;-1;True;0;False;-1;0;False;-1;False;False;False;False;False;False;True;0;False;-1;True;0;False;-1;True;True;True;True;True;0;False;-1;False;False;False;True;False;255;False;-1;255;False;-1;255;False;-1;7;False;-1;1;False;-1;1;False;-1;1;False;-1;7;False;-1;1;False;-1;1;False;-1;1;False;-1;True;1;False;-1;True;3;False;-1;True;True;0;False;-1;0;False;-1;True;1;RenderType=Opaque=RenderType;True;2;0;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;1;LightMode=ForwardBase;False;2;Include;;False;;Native;Include;;False;;Custom;;0;0;Standard;1;Vertex Position,InvertActionOnDeselection;0;0;1;True;False;;False;0
WireConnection;19;0;31;0
WireConnection;53;0;50;0
WireConnection;52;0;51;0
WireConnection;13;0;19;1
WireConnection;13;1;15;0
WireConnection;54;0;52;0
WireConnection;54;1;52;1
WireConnection;54;2;53;0
WireConnection;58;0;56;3
WireConnection;58;1;55;0
WireConnection;57;0;52;0
WireConnection;57;1;54;0
WireConnection;18;0;19;0
WireConnection;18;1;13;0
WireConnection;9;0;18;0
WireConnection;9;1;20;0
WireConnection;65;0;57;0
WireConnection;65;1;60;0
WireConnection;67;0;61;0
WireConnection;66;0;79;0
WireConnection;66;1;58;0
WireConnection;48;0;1;0
WireConnection;48;1;49;0
WireConnection;73;0;67;2
WireConnection;73;1;64;0
WireConnection;73;2;65;0
WireConnection;3;0;47;0
WireConnection;3;1;9;0
WireConnection;3;2;21;0
WireConnection;71;0;79;0
WireConnection;71;1;62;2
WireConnection;72;0;66;0
WireConnection;72;1;63;0
WireConnection;72;2;68;1
WireConnection;72;3;68;2
WireConnection;72;4;68;2
WireConnection;78;0;72;0
WireConnection;46;0;3;0
WireConnection;46;1;48;0
WireConnection;77;0;71;0
WireConnection;77;1;70;0
WireConnection;77;2;69;1
WireConnection;77;3;69;2
WireConnection;77;4;69;2
WireConnection;75;0;67;0
WireConnection;75;1;67;1
WireConnection;75;2;73;0
WireConnection;81;0;46;0
WireConnection;81;1;78;0
WireConnection;81;2;74;0
WireConnection;80;0;76;0
WireConnection;80;1;75;0
WireConnection;80;2;77;0
WireConnection;2;1;4;1
WireConnection;2;2;4;2
WireConnection;2;3;4;3
WireConnection;0;0;81;0
WireConnection;0;1;80;0
ASEEND*/
//CHKSM=C9AE7A7E94FA22C85030F4BCFA192894B39B9939