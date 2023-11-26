// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "New Amplify Shader"
{
	Properties
	{
		_TextureSample0("Texture Sample 0", 2D) = "white" {}
		_Lightrange("Lightrange", Float) = 0
		_Vector1("Vector 1", Vector) = (0,1,0,0)
		[HDR]_Color0("Color 0", Color) = (0,0,0,0)
		_Float3("Float 3", Float) = 0
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
				UNITY_VERTEX_INPUT_INSTANCE_ID
				UNITY_VERTEX_OUTPUT_STEREO
			};

			uniform sampler2D _TextureSample0;
			uniform float4 _TextureSample0_ST;
			uniform float3 PPP;
			uniform float _Lightrange;
			uniform float3 SSS;
			uniform float2 _Vector1;
			uniform float _Float3;
			uniform float4 _Color0;
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

				o.ase_texcoord1.xy = v.ase_texcoord.xy;
				
				//setting value to unused interpolator channels and avoid initialization warnings
				o.ase_texcoord1.zw = 0;
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
				float2 uv_TextureSample0 = i.ase_texcoord1.xy * _TextureSample0_ST.xy + _TextureSample0_ST.zw;
				float3 position34 = PPP;
				float Scale43 = SSS.x;
				float3 _Vector0 = float3(1,0,0);
				float ifLocalVar5 = 0;
				if( ( distance( WorldPosition , position34 ) + _Lightrange ) > Scale43 )
				ifLocalVar5 = _Vector0.x;
				else if( ( distance( WorldPosition , position34 ) + _Lightrange ) == Scale43 )
				ifLocalVar5 = _Vector0.y;
				else if( ( distance( WorldPosition , position34 ) + _Lightrange ) < Scale43 )
				ifLocalVar5 = _Vector0.z;
				clip( ifLocalVar5 - 0.99);
				float4 CLIP22 = tex2D( _TextureSample0, uv_TextureSample0 );
				float lerpResult26 = lerp( _Vector1.x , _Vector1.y , ( distance( WorldPosition , position34 ) - ( Scale43 + _Float3 ) ));
				float3 break59 = ( WorldPosition * 0.26 );
				float mulTime62 = _Time.y * 0.08;
				float4 appendResult60 = (float4(break59.x , ( break59.y + mulTime62 ) , 0.0 , 0.0));
				float simplePerlin2D50 = snoise( appendResult60.xy*19.12 );
				simplePerlin2D50 = simplePerlin2D50*0.5 + 0.5;
				float3 _Vector2 = float3(1,0,0);
				float ifLocalVar40 = 0;
				if( ( lerpResult26 * simplePerlin2D50 ) > 0.03 )
				ifLocalVar40 = _Vector2.x;
				else if( ( lerpResult26 * simplePerlin2D50 ) == 0.03 )
				ifLocalVar40 = _Vector2.y;
				else if( ( lerpResult26 * simplePerlin2D50 ) < 0.03 )
				ifLocalVar40 = _Vector2.z;
				
				
				finalColor = ( CLIP22 + ( ifLocalVar40 * _Color0 ) );
				return finalColor;
			}
			ENDCG
		}
	}
	CustomEditor "ASEMaterialInspector"
	
	
}
/*ASEBEGIN
Version=18800
34.4;372.8;1442.4;718.2;1619.742;159.3375;1.6;True;False
Node;AmplifyShaderEditor.CommentaryNode;24;-2388.219,-401.7455;Inherit;False;2034.706;773.7719;CLIP;14;17;16;21;18;20;5;9;3;1;35;34;44;54;55;;1,1,1,1;0;0
Node;AmplifyShaderEditor.Vector3Node;11;-2593.637,114.761;Inherit;False;Global;PPP;PPP;3;0;Create;True;0;0;0;False;0;False;0,0,0;-0.15,7.1,3.87;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.Vector3Node;15;-2589.158,304.9399;Inherit;False;Global;SSS;SSS;3;0;Create;True;0;0;0;False;0;False;0,0,0;8.330189,4.93572,8.330189;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.RangedFloatNode;66;-689.7003,1033.123;Inherit;False;Constant;_Float8;Float 8;8;0;Create;True;0;0;0;False;0;False;0.26;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.WorldPosInputsNode;64;-888.3282,930.4814;Inherit;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;65;-563.7708,914.5394;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode;63;-622.8472,1134.048;Inherit;False;Constant;_Float7;Float 7;8;0;Create;True;0;0;0;False;0;False;0.08;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;43;-2377.5,316.5392;Inherit;False;Scale;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;34;-2387.653,117.7405;Inherit;False;position;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleTimeNode;62;-470.7268,1098.029;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;47;-1057.521,848.5093;Inherit;False;Property;_Float3;Float 3;4;0;Create;True;0;0;0;False;0;False;0;-5.74;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;36;-1091.834,544.7597;Inherit;False;34;position;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.GetLocalVarNode;46;-1111.68,722.747;Inherit;False;43;Scale;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.WorldPosInputsNode;29;-1100.537,309.8025;Inherit;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.GetLocalVarNode;35;-2189.249,-194.2;Inherit;False;34;position;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.BreakToComponentsNode;59;-361.9422,804.5274;Inherit;False;FLOAT3;1;0;FLOAT3;0,0,0;False;16;FLOAT;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT;5;FLOAT;6;FLOAT;7;FLOAT;8;FLOAT;9;FLOAT;10;FLOAT;11;FLOAT;12;FLOAT;13;FLOAT;14;FLOAT;15
Node;AmplifyShaderEditor.WorldPosInputsNode;17;-2338.219,-351.7455;Inherit;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.DistanceOpNode;31;-654.0236,490.1871;Inherit;False;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;61;-186.7661,887.6498;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;48;-653.3232,732.0173;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DistanceOpNode;16;-1814.906,-160.1609;Inherit;False;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;21;-1862.044,1.585769;Inherit;False;Property;_Lightrange;Lightrange;1;0;Create;True;0;0;0;False;0;False;0;3.08;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;60;-47.75745,733.197;Inherit;False;FLOAT4;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.RangedFloatNode;52;88.95723,1087.881;Inherit;False;Constant;_Float4;Float 4;6;0;Create;True;0;0;0;False;0;False;19.12;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.Vector3Node;18;-1736.528,218.3416;Inherit;False;Constant;_Vector0;Vector 0;2;0;Create;True;0;0;0;False;0;False;1,0,0;0,0,0;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SimpleSubtractOpNode;32;-338.7892,541.8844;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;20;-1604.613,-96.02426;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;44;-2137.285,65.06682;Inherit;False;43;Scale;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.Vector2Node;27;-184.5922,204.5852;Inherit;False;Property;_Vector1;Vector 1;2;0;Create;True;0;0;0;False;0;False;0,1;0.29,0.2;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.LerpOp;26;117.7597,191.0143;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;9;-1114.903,111.9606;Inherit;False;Constant;_Float1;Float 1;1;0;Create;True;0;0;0;False;0;False;0.99;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;3;-1549.307,-329.705;Inherit;True;Property;_TextureSample0;Texture Sample 0;0;0;Create;True;0;0;0;False;0;False;-1;None;ffc2f2f6939768948a7dfda098fe288e;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.NoiseGeneratorNode;50;144.3046,651.1429;Inherit;True;Simplex2D;True;False;2;0;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.ConditionalIfNode;5;-1406.343,2.738426;Inherit;False;False;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;4;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;57;296.8046,112.5068;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;41;137.5759,327.7428;Inherit;False;Constant;_Float2;Float 2;5;0;Create;True;0;0;0;False;0;False;0.03;0.51;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.ClipNode;1;-855.0297,-67.36884;Inherit;False;3;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.Vector3Node;42;138.3857,419.8387;Inherit;False;Constant;_Vector2;Vector 2;5;0;Create;True;0;0;0;False;0;False;1,0,0;0,0,0;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.ColorNode;39;592.3589,379.1434;Inherit;False;Property;_Color0;Color 0;3;1;[HDR];Create;True;0;0;0;False;0;False;0,0,0,0;0,766.9961,606.3687,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ConditionalIfNode;40;599.7539,123.973;Inherit;False;False;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;4;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;22;-289.9761,-58.26785;Inherit;False;CLIP;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;23;309.9102,-28.685;Inherit;False;22;CLIP;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;38;911.1648,93.22272;Inherit;False;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;37;1110.269,-19.57677;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;55;-1872.23,143.7155;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;51;-998.808,1259.049;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;54;-2107.324,267.7957;Inherit;False;Property;_Float5;Float 5;5;0;Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;0;1330.702,-24.45938;Float;False;True;-1;2;ASEMaterialInspector;100;1;New Amplify Shader;0770190933193b94aaa3065e307002fa;True;Unlit;0;0;Unlit;2;True;0;1;False;-1;0;False;-1;0;1;False;-1;0;False;-1;True;0;False;-1;0;False;-1;False;False;False;False;False;False;True;0;False;-1;True;0;False;-1;True;True;True;True;True;0;False;-1;False;False;False;True;False;255;False;-1;255;False;-1;255;False;-1;7;False;-1;1;False;-1;1;False;-1;1;False;-1;7;False;-1;1;False;-1;1;False;-1;1;False;-1;True;1;False;-1;True;3;False;-1;True;True;0;False;-1;0;False;-1;True;1;RenderType=Opaque=RenderType;True;2;0;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;1;LightMode=ForwardBase;False;0;;0;0;Standard;1;Vertex Position,InvertActionOnDeselection;0;0;1;True;False;;False;0
WireConnection;65;0;64;0
WireConnection;65;1;66;0
WireConnection;43;0;15;1
WireConnection;34;0;11;0
WireConnection;62;0;63;0
WireConnection;59;0;65;0
WireConnection;31;0;29;0
WireConnection;31;1;36;0
WireConnection;61;0;59;1
WireConnection;61;1;62;0
WireConnection;48;0;46;0
WireConnection;48;1;47;0
WireConnection;16;0;17;0
WireConnection;16;1;35;0
WireConnection;60;0;59;0
WireConnection;60;1;61;0
WireConnection;32;0;31;0
WireConnection;32;1;48;0
WireConnection;20;0;16;0
WireConnection;20;1;21;0
WireConnection;26;0;27;1
WireConnection;26;1;27;2
WireConnection;26;2;32;0
WireConnection;50;0;60;0
WireConnection;50;1;52;0
WireConnection;5;0;20;0
WireConnection;5;1;44;0
WireConnection;5;2;18;1
WireConnection;5;3;18;2
WireConnection;5;4;18;3
WireConnection;57;0;26;0
WireConnection;57;1;50;0
WireConnection;1;0;3;0
WireConnection;1;1;5;0
WireConnection;1;2;9;0
WireConnection;40;0;57;0
WireConnection;40;1;41;0
WireConnection;40;2;42;1
WireConnection;40;3;42;2
WireConnection;40;4;42;3
WireConnection;22;0;1;0
WireConnection;38;0;40;0
WireConnection;38;1;39;0
WireConnection;37;0;23;0
WireConnection;37;1;38;0
WireConnection;55;0;44;0
WireConnection;55;1;54;0
WireConnection;0;0;37;0
ASEEND*/
//CHKSM=6E58B2A040574FC1C2C321A0D31D72289624BD25