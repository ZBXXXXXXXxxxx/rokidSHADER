// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "seed"
{
	Properties
	{
		_fresnal("fresnal", Vector) = (0,0,0,0)
		[HDR]_Color1("Color 1", Color) = (0,0,0,0)
		_Float14("Float 13", Float) = 0
		_XIAOSAN("XIAOSAN", Float) = 0
		_Float19("Float 18", Float) = 0

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

			uniform float _Float14;
			uniform float _XIAOSAN;
			uniform float3 _fresnal;
			uniform float4 _Color1;
			uniform float _Float19;
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

				float3 break62 = v.vertex.xyz;
				float2 texCoord48 = v.ase_texcoord.xy * float2( 1,1 ) + float2( 0,0 );
				float2 break49 = texCoord48;
				float mulTime50 = _Time.y * 0.27;
				float4 appendResult55 = (float4(break49.x , ( break49.x + break49.y + mulTime50 ) , 0.0 , 0.0));
				float simplePerlin2D56 = snoise( appendResult55.xy*20.64 );
				simplePerlin2D56 = simplePerlin2D56*0.5 + 0.5;
				float4 appendResult69 = (float4(break62.x , break62.y , ( break62.z * _Float14 * simplePerlin2D56 ) , 0.0));
				float2 texCoord57 = v.ase_texcoord.xy * float2( 1,1 ) + float2( 0,0 );
				float2 _Vector3 = float2(1,0);
				float ifLocalVar71 = 0;
				if( ( _XIAOSAN + texCoord57.y ) <= 0.0 )
				ifLocalVar71 = _Vector3.y;
				else
				ifLocalVar71 = _Vector3.x;
				float4 lerpResult73 = lerp( float4( v.vertex.xyz , 0.0 ) , appendResult69 , ifLocalVar71);
				
				float3 ase_worldNormal = UnityObjectToWorldNormal(v.ase_normal);
				o.ase_texcoord1.xyz = ase_worldNormal;
				
				o.ase_texcoord2 = v.vertex;
				
				//setting value to unused interpolator channels and avoid initialization warnings
				o.ase_texcoord1.w = 0;
				float3 vertexValue = float3(0, 0, 0);
				#if ASE_ABSOLUTE_VERTEX_POS
				vertexValue = v.vertex.xyz;
				#endif
				vertexValue = lerpResult73.xyz;
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
				float fresnelNdotV45 = dot( ase_worldNormal, ase_worldViewDir );
				float fresnelNode45 = ( _fresnal.x + _fresnal.y * pow( 1.0 - fresnelNdotV45, _fresnal.z ) );
				float2 _Vector4 = float2(1,0);
				float ifLocalVar67 = 0;
				if( ( _XIAOSAN + ( i.ase_texcoord2.xyz.z * 5.96 ) ) <= 0.0 )
				ifLocalVar67 = _Vector4.y;
				else
				ifLocalVar67 = _Vector4.x;
				clip( ( 1.0 - ifLocalVar67 ) - _Float19);
				
				
				finalColor = ( fresnelNode45 * _Color1 );
				return finalColor;
			}
			ENDCG
		}
	}
	CustomEditor "ASEMaterialInspector"
	
	
}
/*ASEBEGIN
Version=18800
6.4;242.4;1440.8;848.6;1090.641;-1690.524;1.931841;True;False
Node;AmplifyShaderEditor.RangedFloatNode;47;414.9557,2612.888;Inherit;False;Constant;_Float17;Float 16;10;0;Create;True;0;0;0;False;0;False;0.27;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;48;379.0587,2368.866;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.BreakToComponentsNode;49;627.0267,2333.921;Inherit;False;FLOAT2;1;0;FLOAT2;0,0;False;16;FLOAT;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT;5;FLOAT;6;FLOAT;7;FLOAT;8;FLOAT;9;FLOAT;10;FLOAT;11;FLOAT;12;FLOAT;13;FLOAT;14;FLOAT;15
Node;AmplifyShaderEditor.SimpleTimeNode;50;629.2247,2598.789;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;51;823.8345,2399.566;Inherit;False;3;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;79;-837.3217,1326.027;Inherit;False;Constant;_Float0;Float 0;5;0;Create;True;0;0;0;False;0;False;5.96;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.PosVertexDataNode;77;-1006.419,1135.073;Inherit;False;0;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.PosVertexDataNode;52;12.86951,1723.001;Inherit;False;0;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;53;853.2085,2556.419;Inherit;False;Constant;_Float12;Float 11;7;0;Create;True;0;0;0;False;0;False;20.64;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;54;-120.7339,2473.504;Inherit;False;Property;_XIAOSAN;XIAOSAN;3;0;Create;True;0;0;0;False;0;False;0;-0.98;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;55;964.2255,2348.521;Inherit;False;FLOAT4;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;78;-583.5112,1194.786;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.NoiseGeneratorNode;56;1112.817,2355.083;Inherit;True;Simplex2D;True;False;2;0;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;58;-211.7515,1132.517;Inherit;False;Constant;_Float18;Float 17;9;0;Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;59;646.1656,2007.339;Inherit;False;Property;_Float14;Float 13;2;0;Create;True;0;0;0;False;0;False;0;2.26;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;57;319.0935,2958.041;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleAddOpNode;61;-221.4025,1026.23;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.BreakToComponentsNode;62;524.4866,1793.812;Inherit;True;FLOAT3;1;0;FLOAT3;0,0,0;False;16;FLOAT;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT;5;FLOAT;6;FLOAT;7;FLOAT;8;FLOAT;9;FLOAT;10;FLOAT;11;FLOAT;12;FLOAT;13;FLOAT;14;FLOAT;15
Node;AmplifyShaderEditor.Vector3Node;46;638.0231,-409.6187;Inherit;False;Property;_fresnal;fresnal;0;0;Create;True;0;0;0;False;0;False;0,0,0;-0.3,0.28,-0.74;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.Vector2Node;60;-207.0405,1208.382;Inherit;False;Constant;_Vector4;Vector 3;9;0;Create;True;0;0;0;False;0;False;1,0;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.FresnelNode;45;923.4238,-549.9763;Inherit;True;Standard;WorldNormal;ViewDir;False;False;5;0;FLOAT3;0,0,1;False;4;FLOAT3;0,0,0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;5;False;1;FLOAT;0
Node;AmplifyShaderEditor.Vector2Node;65;653.5435,3010.241;Inherit;False;Constant;_Vector3;Vector 2;9;0;Create;True;0;0;0;False;0;False;1,0;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.RangedFloatNode;64;648.8336,2934.375;Inherit;False;Constant;_Float15;Float 14;9;0;Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;63;639.1827,2828.088;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;27;966.0875,-226.8109;Inherit;False;Property;_Color1;Color 1;1;1;[HDR];Create;True;0;0;0;False;0;False;0,0,0,0;0,0.1946466,2.857768,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ConditionalIfNode;67;245.2625,976.0178;Inherit;False;False;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;4;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;66;882.6355,1858.594;Inherit;False;3;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;68;660.8126,1258.124;Inherit;False;Property;_Float19;Float 18;4;0;Create;True;0;0;0;False;0;False;0;0.96;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;69;1038.074,1746.573;Inherit;False;FLOAT4;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.PosVertexDataNode;70;658.5936,1431.591;Inherit;False;0;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ConditionalIfNode;71;1240.157,2818.168;Inherit;False;False;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;4;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;72;693.5176,1107.241;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;26;1286.293,-271.8672;Inherit;False;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.LerpOp;73;1753.551,1285.853;Inherit;False;3;0;FLOAT4;0,0,0,0;False;1;FLOAT4;0,0,0,0;False;2;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.Vector3Node;80;-201.3133,2701.434;Inherit;False;Global;boom;boom;5;0;Create;True;0;0;0;False;0;False;0,0,0;-5.32,5.53,-1.3;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.ClipNode;75;1447.036,-103.0591;Inherit;False;3;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;0;1835.074,-73.32217;Float;False;True;-1;2;ASEMaterialInspector;100;1;seed;0770190933193b94aaa3065e307002fa;True;Unlit;0;0;Unlit;2;True;0;1;False;-1;0;False;-1;0;1;False;-1;0;False;-1;True;0;False;-1;0;False;-1;False;False;False;False;False;False;True;0;False;-1;True;0;False;-1;True;True;True;True;True;0;False;-1;False;False;False;True;False;255;False;-1;255;False;-1;255;False;-1;7;False;-1;1;False;-1;1;False;-1;1;False;-1;7;False;-1;1;False;-1;1;False;-1;1;False;-1;True;1;False;-1;True;3;False;-1;True;True;0;False;-1;0;False;-1;True;1;RenderType=Opaque=RenderType;True;2;0;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;1;LightMode=ForwardBase;False;0;;0;0;Standard;1;Vertex Position,InvertActionOnDeselection;0;0;1;True;False;;False;0
WireConnection;49;0;48;0
WireConnection;50;0;47;0
WireConnection;51;0;49;0
WireConnection;51;1;49;1
WireConnection;51;2;50;0
WireConnection;55;0;49;0
WireConnection;55;1;51;0
WireConnection;78;0;77;3
WireConnection;78;1;79;0
WireConnection;56;0;55;0
WireConnection;56;1;53;0
WireConnection;61;0;54;0
WireConnection;61;1;78;0
WireConnection;62;0;52;0
WireConnection;45;1;46;1
WireConnection;45;2;46;2
WireConnection;45;3;46;3
WireConnection;63;0;54;0
WireConnection;63;1;57;2
WireConnection;67;0;61;0
WireConnection;67;1;58;0
WireConnection;67;2;60;1
WireConnection;67;3;60;2
WireConnection;67;4;60;2
WireConnection;66;0;62;2
WireConnection;66;1;59;0
WireConnection;66;2;56;0
WireConnection;69;0;62;0
WireConnection;69;1;62;1
WireConnection;69;2;66;0
WireConnection;71;0;63;0
WireConnection;71;1;64;0
WireConnection;71;2;65;1
WireConnection;71;3;65;2
WireConnection;71;4;65;2
WireConnection;72;0;67;0
WireConnection;26;0;45;0
WireConnection;26;1;27;0
WireConnection;73;0;70;0
WireConnection;73;1;69;0
WireConnection;73;2;71;0
WireConnection;75;0;26;0
WireConnection;75;1;72;0
WireConnection;75;2;68;0
WireConnection;0;0;75;0
WireConnection;0;1;73;0
ASEEND*/
//CHKSM=13C099C7A80D33AB996CBB35AD5921464640FBB0