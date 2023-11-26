// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "wing"
{
	Properties
	{
		_TextureSample0("Texture Sample 0", 2D) = "white" {}
		_TextureSample1("Texture Sample 1", 2D) = "white" {}
		[HDR]_Color1("Color 1", Color) = (1.624505,1.624505,1.624505,0)
		[HDR]_fresnal("fresnal", Color) = (1.624505,1.624505,1.624505,0)
		_Float1("Float 1", Float) = 0
		_Vector0("Vector 0", Vector) = (0,0,0,0)
		_exp("exp", Float) = 0
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

			uniform float4 _Color1;
			uniform sampler2D _TextureSample0;
			uniform float4 _TextureSample0_ST;
			uniform sampler2D _TextureSample1;
			uniform float4 _TextureSample1_ST;
			uniform float _Float1;
			uniform float _exp;
			uniform float3 _Vector0;
			uniform float4 _fresnal;
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
			
			float3 HSVToRGB( float3 c )
			{
				float4 K = float4( 1.0, 2.0 / 3.0, 1.0 / 3.0, 3.0 );
				float3 p = abs( frac( c.xxx + K.xyz ) * 6.0 - K.www );
				return c.z * lerp( K.xxx, saturate( p - K.xxx ), c.y );
			}
			

			
			V2FData vert ( MeshData v )
			{
				V2FData o;
				UNITY_SETUP_INSTANCE_ID(v);
				UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(o);
				UNITY_TRANSFER_INSTANCE_ID(v, o);

				float3 ase_worldNormal = UnityObjectToWorldNormal(v.ase_normal);
				o.ase_texcoord3.xyz = ase_worldNormal;
				
				o.ase_texcoord1.xy = v.ase_texcoord.xy;
				o.ase_texcoord2 = v.vertex;
				
				//setting value to unused interpolator channels and avoid initialization warnings
				o.ase_texcoord1.zw = 0;
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
				float2 uv_TextureSample0 = i.ase_texcoord1.xy * _TextureSample0_ST.xy + _TextureSample0_ST.zw;
				float3 ase_worldViewDir = UnityWorldSpaceViewDir(WorldPosition);
				ase_worldViewDir = normalize(ase_worldViewDir);
				float simplePerlin2D57 = snoise( ( -ase_worldViewDir * -74.66 ).xy );
				simplePerlin2D57 = simplePerlin2D57*0.5 + 0.5;
				float3 break66 = i.ase_texcoord2.xyz;
				float2 _Vector1 = float2(4,4);
				float3 hsvTorgb62 = HSVToRGB( float3(( ( break66.x + break66.y + break66.z ) * 107.62 ),_Vector1.x,_Vector1.y) );
				float4 color73 = IsGammaSpace() ? float4(0.1172395,0,3.732132,0) : float4(0.0129096,0,18.12614,0);
				float4 star74 = ( pow( simplePerlin2D57 , 43.85 ) * float4( hsvTorgb62 , 0.0 ) * color73 );
				float2 uv_TextureSample1 = i.ase_texcoord1.xy * _TextureSample1_ST.xy + _TextureSample1_ST.zw;
				float2 texCoord2 = i.ase_texcoord1.xy * float2( 1,1 ) + float2( 0,0 );
				float mulTime25 = _Time.y * _Float1;
				float2 temp_cast_2 = (( texCoord2.y + mulTime25 )).xx;
				float simplePerlin2D32 = snoise( temp_cast_2*0.85 );
				simplePerlin2D32 = simplePerlin2D32*0.5 + 0.5;
				float3 ase_worldNormal = i.ase_texcoord3.xyz;
				float fresnelNdotV15 = dot( ase_worldNormal, ase_worldViewDir );
				float fresnelNode15 = ( _Vector0.x + _Vector0.y * pow( 1.0 - fresnelNdotV15, _Vector0.z ) );
				float2 temp_cast_3 = (-1.02).xx;
				float2 texCoord41 = i.ase_texcoord1.xy * temp_cast_3 + float2( 0,0 );
				float2 texCoord48 = i.ase_texcoord1.xy * float2( 1,1 ) + float2( 0,0 );
				float2 break51 = texCoord48;
				float mulTime54 = _Time.y * 0.11;
				float4 appendResult52 = (float4(break51.x , ( break51.y + mulTime54 ) , 0.0 , 0.0));
				float simplePerlin2D47 = snoise( appendResult52.xy*0.46 );
				simplePerlin2D47 = simplePerlin2D47*0.5 + 0.5;
				float2 temp_cast_5 = (( texCoord41.x * simplePerlin2D47 )).xx;
				float simplePerlin2D36 = snoise( temp_cast_5*-24.6 );
				simplePerlin2D36 = simplePerlin2D36*0.5 + 0.5;
				
				
				finalColor = ( ( ( ( _Color1 * tex2D( _TextureSample0, uv_TextureSample0 ) ) * 25.0 ) + star74 + ( tex2D( _TextureSample1, uv_TextureSample1 ) * pow( ( simplePerlin2D32 * 49.58 ) , _exp ) ) ) + ( fresnelNode15 * _fresnal * simplePerlin2D36 ) );
				return finalColor;
			}
			ENDCG
		}
	}
	CustomEditor "ASEMaterialInspector"
	
	
}
/*ASEBEGIN
Version=18800
15.2;516;1442.4;515.8;1007.227;-164.1061;1.731609;True;False
Node;AmplifyShaderEditor.PosVertexDataNode;63;-1209.685,1801.257;Inherit;False;0;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ViewDirInputsCoordNode;56;-1001.8,1428.962;Inherit;False;World;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.RangedFloatNode;55;-939.9241,1019.358;Inherit;False;Constant;_Float7;Float 7;6;0;Create;True;0;0;0;False;0;False;0.11;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;48;-856.1174,810.3958;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;24;-858.171,132.9843;Inherit;False;Property;_Float1;Float 1;4;0;Create;True;0;0;0;False;0;False;0;0.47;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;60;-761.9531,1658.271;Inherit;False;Constant;_Float8;Float 8;6;0;Create;True;0;0;0;False;0;False;-74.66;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.BreakToComponentsNode;66;-900.3917,1796.776;Inherit;False;FLOAT3;1;0;FLOAT3;0,0,0;False;16;FLOAT;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT;5;FLOAT;6;FLOAT;7;FLOAT;8;FLOAT;9;FLOAT;10;FLOAT;11;FLOAT;12;FLOAT;13;FLOAT;14;FLOAT;15
Node;AmplifyShaderEditor.NegateNode;58;-707.4479,1487.699;Inherit;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleTimeNode;25;-631.8186,166.4638;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;2;-1101.221,-30.15725;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;59;-563.6635,1583.889;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.BreakToComponentsNode;51;-616.2274,813.2634;Inherit;False;FLOAT2;1;0;FLOAT2;0,0;False;16;FLOAT;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT;5;FLOAT;6;FLOAT;7;FLOAT;8;FLOAT;9;FLOAT;10;FLOAT;11;FLOAT;12;FLOAT;13;FLOAT;14;FLOAT;15
Node;AmplifyShaderEditor.SimpleAddOpNode;69;-735.526,1798.12;Inherit;False;3;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleTimeNode;54;-758.9241,963.3579;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;68;-780.392,1941.776;Inherit;False;Constant;_Float9;Float 9;6;0;Create;True;0;0;0;False;0;False;107.62;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;33;-460.4109,315.6591;Inherit;False;Constant;_Float3;Float 3;7;0;Create;True;0;0;0;False;0;False;0.85;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;67;-583.3915,1801.776;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.Vector2Node;64;-572.5726,1988.336;Inherit;False;Constant;_Vector1;Vector 1;6;0;Create;True;0;0;0;False;0;False;4,4;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.NoiseGeneratorNode;57;-387.4956,1448.636;Inherit;True;Simplex2D;True;False;2;0;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;53;-472.9241,929.3579;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;72;-411.3284,1665.718;Inherit;False;Constant;_Float10;Float 10;6;0;Create;True;0;0;0;False;0;False;43.85;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;23;-458.3977,-16.30385;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.NoiseGeneratorNode;32;-186.401,23.90039;Inherit;True;Simplex2D;True;False;2;0;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.HSVToRGBNode;62;-323.9474,1801.909;Inherit;True;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.ColorNode;73;184.937,1723.387;Inherit;False;Constant;_Color0;Color 0;6;1;[HDR];Create;True;0;0;0;False;0;False;0.1172395,0,3.732132,0;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;35;-75.52827,279.9521;Inherit;False;Constant;_Float2;Float 2;6;0;Create;True;0;0;0;False;0;False;49.58;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.PowerNode;71;-106.5511,1430.228;Inherit;True;False;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;43;-527.4966,635.008;Inherit;False;Constant;_Float5;Float 5;6;0;Create;True;0;0;0;False;0;False;-1.02;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;52;-309.4323,858.1902;Inherit;False;FLOAT4;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.RangedFloatNode;49;-562.9213,1041.406;Inherit;False;Constant;_Float6;Float 6;6;0;Create;True;0;0;0;False;0;False;0.46;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;34;155.91,52.04341;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;41;-176.1036,758.0621;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;77;416.761,214.6354;Inherit;False;Property;_exp;exp;6;0;Create;True;0;0;0;False;0;False;0;0.57;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;70;292.5847,1405.07;Inherit;True;3;3;0;FLOAT;0;False;1;FLOAT3;0,0,0;False;2;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.NoiseGeneratorNode;47;-25.82393,892.0209;Inherit;True;Simplex2D;True;False;2;0;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;1;-171.9614,-553.6693;Inherit;True;Property;_TextureSample0;Texture Sample 0;0;0;Create;True;0;0;0;False;0;False;-1;None;ffc2f2f6939768948a7dfda098fe288e;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;27;-188.3167,-758.2046;Inherit;False;Property;_Color1;Color 1;2;1;[HDR];Create;True;0;0;0;False;0;False;1.624505,1.624505,1.624505,0;0.1008728,0.1008728,0.1008728,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.PowerNode;76;602.3341,76.78091;Inherit;False;False;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;46;161.8983,723.5535;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;42;297.7874,852.3635;Inherit;False;Constant;_Float4;Float 4;6;0;Create;True;0;0;0;False;0;False;-24.6;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;9;-102.3235,-329.3829;Inherit;False;Constant;_Float0;Float 0;3;0;Create;True;0;0;0;False;0;False;25;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;4;-41.49571,-170.5107;Inherit;True;Property;_TextureSample1;Texture Sample 1;1;0;Create;True;0;0;0;False;0;False;-1;None;9741daa64f7f2124ca00dcb6bb481a6e;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;26;372.9841,-560.4468;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;74;1166.65,711.3061;Inherit;False;star;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.Vector3Node;20;-636.4194,424.8039;Inherit;False;Property;_Vector0;Vector 0;5;0;Create;True;0;0;0;False;0;False;0,0,0;-0.01,0.33,2.11;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;5;675.3833,-116.1599;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.ColorNode;18;-36.81549,538.8462;Inherit;False;Property;_fresnal;fresnal;3;1;[HDR];Create;True;0;0;0;False;0;False;1.624505,1.624505,1.624505,0;12.12573,1.935632,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.FresnelNode;15;-313.6622,395.6323;Inherit;False;Standard;WorldNormal;ViewDir;False;False;5;0;FLOAT3;0,0,1;False;4;FLOAT3;0,0,0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;5;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;75;884.8454,156.4504;Inherit;False;74;star;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;7;449.8155,-244.1532;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.NoiseGeneratorNode;36;557.5775,489.1903;Inherit;True;Simplex2D;True;False;2;0;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;17;1040.004,213.4225;Inherit;False;3;3;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;28;838.5914,-231.2808;Inherit;False;3;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;16;1555.372,-94.95892;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;0;2518.687,20.6662;Float;False;True;-1;2;ASEMaterialInspector;100;1;wing;0770190933193b94aaa3065e307002fa;True;Unlit;0;0;Unlit;2;True;0;1;False;-1;0;False;-1;0;1;False;-1;0;False;-1;True;0;False;-1;0;False;-1;False;False;False;False;False;False;True;0;False;-1;True;0;False;-1;True;True;True;True;True;0;False;-1;False;False;False;True;False;255;False;-1;255;False;-1;255;False;-1;7;False;-1;1;False;-1;1;False;-1;1;False;-1;7;False;-1;1;False;-1;1;False;-1;1;False;-1;True;1;False;-1;True;3;False;-1;True;True;0;False;-1;0;False;-1;True;1;RenderType=Opaque=RenderType;True;2;0;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;1;LightMode=ForwardBase;False;0;;0;0;Standard;1;Vertex Position,InvertActionOnDeselection;1;0;1;True;False;;False;0
WireConnection;66;0;63;0
WireConnection;58;0;56;0
WireConnection;25;0;24;0
WireConnection;59;0;58;0
WireConnection;59;1;60;0
WireConnection;51;0;48;0
WireConnection;69;0;66;0
WireConnection;69;1;66;1
WireConnection;69;2;66;2
WireConnection;54;0;55;0
WireConnection;67;0;69;0
WireConnection;67;1;68;0
WireConnection;57;0;59;0
WireConnection;53;0;51;1
WireConnection;53;1;54;0
WireConnection;23;0;2;2
WireConnection;23;1;25;0
WireConnection;32;0;23;0
WireConnection;32;1;33;0
WireConnection;62;0;67;0
WireConnection;62;1;64;1
WireConnection;62;2;64;2
WireConnection;71;0;57;0
WireConnection;71;1;72;0
WireConnection;52;0;51;0
WireConnection;52;1;53;0
WireConnection;34;0;32;0
WireConnection;34;1;35;0
WireConnection;41;0;43;0
WireConnection;70;0;71;0
WireConnection;70;1;62;0
WireConnection;70;2;73;0
WireConnection;47;0;52;0
WireConnection;47;1;49;0
WireConnection;76;0;34;0
WireConnection;76;1;77;0
WireConnection;46;0;41;1
WireConnection;46;1;47;0
WireConnection;26;0;27;0
WireConnection;26;1;1;0
WireConnection;74;0;70;0
WireConnection;5;0;4;0
WireConnection;5;1;76;0
WireConnection;15;1;20;1
WireConnection;15;2;20;2
WireConnection;15;3;20;3
WireConnection;7;0;26;0
WireConnection;7;1;9;0
WireConnection;36;0;46;0
WireConnection;36;1;42;0
WireConnection;17;0;15;0
WireConnection;17;1;18;0
WireConnection;17;2;36;0
WireConnection;28;0;7;0
WireConnection;28;1;75;0
WireConnection;28;2;5;0
WireConnection;16;0;28;0
WireConnection;16;1;17;0
WireConnection;0;0;16;0
ASEEND*/
//CHKSM=555313ED6597902B7AF9FDC84A3208686528A83F