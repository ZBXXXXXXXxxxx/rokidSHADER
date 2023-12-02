// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "heitoudoudou"
{
	Properties
	{
		_basecolor("basecolor", 2D) = "white" {}
		_Float0("Float 0", Float) = 0
		_emi("emi", 2D) = "white" {}
		[HDR]_Color0("Color 0", Color) = (0,1,0.7955875,0)
		_Lightrange1("Lightrange", Float) = 0
		[HDR]_Color1("Color 1", Color) = (0,0,0,0)
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

			uniform float4 _Color1;
			uniform sampler2D _emi;
			uniform float4 _emi_ST;
			uniform sampler2D _basecolor;
			uniform float4 _basecolor_ST;
			uniform float4 _Color0;
			uniform float _Float0;
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
				o.ase_texcoord2.xyz = ase_worldNormal;
				
				o.ase_texcoord1.xy = v.ase_texcoord.xy;
				
				//setting value to unused interpolator channels and avoid initialization warnings
				o.ase_texcoord1.zw = 0;
				o.ase_texcoord2.w = 0;
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
				float2 uv_emi = i.ase_texcoord1.xy * _emi_ST.xy + _emi_ST.zw;
				float2 uv_basecolor = i.ase_texcoord1.xy * _basecolor_ST.xy + _basecolor_ST.zw;
				float3 ase_worldViewDir = UnityWorldSpaceViewDir(WorldPosition);
				ase_worldViewDir = normalize(ase_worldViewDir);
				float3 ase_worldNormal = i.ase_texcoord2.xyz;
				float3 _Vector0 = float3(0,13.83,5);
				float fresnelNdotV6 = dot( ase_worldNormal, ase_worldViewDir );
				float fresnelNode6 = ( _Vector0.x + _Vector0.y * pow( 1.0 - fresnelNdotV6, _Vector0.z ) );
				float4 appendResult2 = (float4(( tex2D( _basecolor, uv_basecolor ) + ( fresnelNode6 * _Color0 ) ).rgb , _Float0));
				float3 position19 = POS;
				float Scale21 = ssss.x;
				float3 _Vector2 = float3(0,0,1);
				float ifLocalVar44 = 0;
				if( ( distance( WorldPosition , position19 ) + _Lightrange1 ) > Scale21 )
				ifLocalVar44 = _Vector2.x;
				else if( ( distance( WorldPosition , position19 ) + _Lightrange1 ) == Scale21 )
				ifLocalVar44 = _Vector2.y;
				else if( ( distance( WorldPosition , position19 ) + _Lightrange1 ) < Scale21 )
				ifLocalVar44 = _Vector2.z;
				clip( ifLocalVar44 - 0.99);
				float4 CLIP53 = ( ( _Color1 * tex2D( _emi, uv_emi ) ) + appendResult2 );
				float lerpResult43 = lerp( _Vector3.x , _Vector3.y , ( distance( WorldPosition , position19 ) - ( Scale21 + _Float5 ) ));
				float3 break28 = ( WorldPosition * 0.26 );
				float mulTime27 = _Time.y * 0.08;
				float4 appendResult36 = (float4(break28.x , ( break28.y + mulTime27 ) , 0.0 , 0.0));
				float simplePerlin2D45 = snoise( appendResult36.xy*19.12 );
				simplePerlin2D45 = simplePerlin2D45*0.5 + 0.5;
				float3 _Vector4 = float3(0,0,1);
				float ifLocalVar52 = 0;
				if( ( lerpResult43 * simplePerlin2D45 ) > 0.03 )
				ifLocalVar52 = _Vector4.x;
				else if( ( lerpResult43 * simplePerlin2D45 ) == 0.03 )
				ifLocalVar52 = _Vector4.y;
				else if( ( lerpResult43 * simplePerlin2D45 ) < 0.03 )
				ifLocalVar52 = _Vector4.z;
				
				
				finalColor = ( CLIP53 + ( ifLocalVar52 * _Color3 ) );
				return finalColor;
			}
			ENDCG
		}
	}
	CustomEditor "ASEMaterialInspector"
	
	
}
/*ASEBEGIN
Version=18800
110.4;612.8;1440.8;867;1823.546;-993.4141;1.849307;True;False
Node;AmplifyShaderEditor.CommentaryNode;18;-2651.693,463.676;Inherit;False;2034.706;773.7719;CLIP;15;58;57;48;46;44;40;39;38;32;31;26;25;24;21;19;;1,1,1,1;0;0
Node;AmplifyShaderEditor.Vector3Node;8;-2060.656,-9.287912;Inherit;False;Constant;_Vector0;Vector 0;3;0;Create;True;0;0;0;False;0;False;0,13.83,5;0,0,0;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.Vector3Node;14;-2878.249,911.4865;Inherit;False;Global;POS;POS;3;0;Create;True;0;0;0;False;0;False;0,0,0;-0.79,1.06,-14.85;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.RangedFloatNode;16;-974.3127,1829.849;Inherit;False;Constant;_Float10;Float 9;8;0;Create;True;0;0;0;False;0;False;0.26;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.WorldPosInputsNode;15;-1172.94,1727.207;Inherit;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.Vector3Node;17;-2881.093,1094.342;Inherit;False;Global;ssss;ssss;3;0;Create;True;0;0;0;False;0;False;0,0,0;4.950242,4.950242,4.950242;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.FresnelNode;6;-1765.442,-91.99937;Inherit;True;Standard;WorldNormal;ViewDir;False;False;5;0;FLOAT3;0,0,1;False;4;FLOAT3;0,0,0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;5;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;11;-1873.545,208.7184;Inherit;False;Property;_Color0;Color 0;3;1;[HDR];Create;True;0;0;0;False;0;False;0,1,0.7955875,0;0,0.2437835,1,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RegisterLocalVarNode;19;-2651.127,983.163;Inherit;False;position;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode;20;-907.4587,1930.774;Inherit;False;Constant;_Float9;Float 8;8;0;Create;True;0;0;0;False;0;False;0.08;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;21;-2640.974,1181.961;Inherit;False;Scale;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;22;-848.3828,1711.265;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.GetLocalVarNode;30;-1396.292,1519.473;Inherit;False;21;Scale;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;29;-1376.446,1341.485;Inherit;False;19;position;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.BreakToComponentsNode;28;-646.5543,1601.253;Inherit;False;FLOAT3;1;0;FLOAT3;0,0,0;False;16;FLOAT;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT;5;FLOAT;6;FLOAT;7;FLOAT;8;FLOAT;9;FLOAT;10;FLOAT;11;FLOAT;12;FLOAT;13;FLOAT;14;FLOAT;15
Node;AmplifyShaderEditor.GetLocalVarNode;25;-2452.723,671.2221;Inherit;False;19;position;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.WorldPosInputsNode;26;-2601.693,513.676;Inherit;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.RangedFloatNode;23;-1342.133,1645.235;Inherit;False;Property;_Float5;Float 4;8;0;Create;True;0;0;0;False;0;False;0;0.14;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;10;-1099.689,-35.2766;Inherit;False;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;1;-1809.3,-349.0961;Inherit;True;Property;_basecolor;basecolor;0;0;Create;True;0;0;0;False;0;False;-1;None;538d3a811c99b4c4881a1c83a915bad2;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.WorldPosInputsNode;24;-1364.011,1175.225;Inherit;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SimpleTimeNode;27;-755.3387,1894.755;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;9;-582.3448,-10.67396;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.ColorNode;13;-682.8582,-548.9763;Inherit;False;Property;_Color1;Color 1;5;1;[HDR];Create;True;0;0;0;False;0;False;0,0,0,0;16.87444,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.DistanceOpNode;31;-2078.38,705.261;Inherit;False;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;33;-471.3782,1684.375;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DistanceOpNode;35;-938.6357,1286.912;Inherit;False;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;3;-450.0842,200.3113;Inherit;False;Property;_Float0;Float 0;1;0;Create;True;0;0;0;False;0;False;0;0.87;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;32;-2125.518,865.6401;Inherit;False;Property;_Lightrange1;Lightrange;4;0;Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;34;-937.9358,1528.742;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;4;-810.0157,-321.6852;Inherit;True;Property;_emi;emi;2;0;Create;True;0;0;0;False;0;False;-1;None;06be4dee89878b840b70f9471ed87b8d;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.Vector2Node;37;-469.2043,1001.311;Inherit;False;Property;_Vector3;Vector 2;6;0;Create;True;0;0;0;False;0;False;0,1;0.26,-2.13;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.SimpleSubtractOpNode;41;-623.4012,1338.609;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;39;-2400.759,930.4891;Inherit;False;21;Scale;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;38;-1868.088,769.3981;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.Vector3Node;40;-2000.002,1083.764;Inherit;False;Constant;_Vector2;Vector 1;2;0;Create;True;0;0;0;False;0;False;0,0,1;0,0,0;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.DynamicAppendNode;2;-220.1794,-103.0876;Inherit;False;FLOAT4;4;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.RangedFloatNode;42;-195.6548,1884.607;Inherit;False;Constant;_Float6;Float 5;6;0;Create;True;0;0;0;False;0;False;19.12;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;12;-424.6847,-498.1736;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.DynamicAppendNode;36;-332.3694,1529.922;Inherit;False;FLOAT4;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.LerpOp;43;-166.8524,987.7395;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;5;66.32434,-295.1715;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT4;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;46;-1378.377,977.3831;Inherit;False;Constant;_Float4;Float 3;1;0;Create;True;0;0;0;False;0;False;0.99;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.ConditionalIfNode;44;-1669.817,868.1611;Inherit;False;False;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;4;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.NoiseGeneratorNode;45;-140.3075,1447.869;Inherit;True;Simplex2D;True;False;2;0;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;47;-147.0362,1124.469;Inherit;False;Constant;_Float7;Float 6;5;0;Create;True;0;0;0;False;0;False;0.03;0.51;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.ClipNode;48;-1118.504,798.053;Inherit;False;3;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.Vector3Node;49;-146.2264,1216.564;Inherit;False;Constant;_Vector4;Vector 3;5;0;Create;True;0;0;0;False;0;False;0,0,1;0,0,0;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;50;12.19254,909.2325;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;53;-574.5882,738.4575;Inherit;False;CLIP;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.ColorNode;51;307.7468,1175.87;Inherit;False;Property;_Color3;Color 2;7;1;[HDR];Create;True;0;0;0;False;0;False;0,0,0,0;0,2.462395,4.237095,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ConditionalIfNode;52;315.1418,920.6985;Inherit;False;False;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;4;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;54;626.5527,889.9485;Inherit;False;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;55;25.29813,768.0405;Inherit;False;53;CLIP;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;56;-1283.42,2055.774;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleAddOpNode;59;825.6569,777.1484;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;57;-2370.798,1133.218;Inherit;False;Property;_Float8;Float 7;9;0;Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;58;-2135.704,1009.138;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;0;469.8579,-314.3299;Float;False;True;-1;2;ASEMaterialInspector;100;1;heitoudoudou;0770190933193b94aaa3065e307002fa;True;Unlit;0;0;Unlit;2;True;2;5;False;-1;10;False;-1;0;1;False;-1;0;False;-1;True;0;False;-1;0;False;-1;False;False;False;False;False;False;True;0;False;-1;True;0;False;-1;True;True;True;True;True;0;False;-1;False;False;False;True;False;255;False;-1;255;False;-1;255;False;-1;7;False;-1;1;False;-1;1;False;-1;1;False;-1;7;False;-1;1;False;-1;1;False;-1;1;False;-1;True;1;False;-1;True;3;False;-1;True;True;0;False;-1;0;False;-1;True;1;RenderType=Opaque=RenderType;True;2;0;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;1;LightMode=ForwardBase;False;0;;0;0;Standard;1;Vertex Position,InvertActionOnDeselection;1;0;1;True;False;;False;0
WireConnection;6;1;8;1
WireConnection;6;2;8;2
WireConnection;6;3;8;3
WireConnection;19;0;14;0
WireConnection;21;0;17;1
WireConnection;22;0;15;0
WireConnection;22;1;16;0
WireConnection;28;0;22;0
WireConnection;10;0;6;0
WireConnection;10;1;11;0
WireConnection;27;0;20;0
WireConnection;9;0;1;0
WireConnection;9;1;10;0
WireConnection;31;0;26;0
WireConnection;31;1;25;0
WireConnection;33;0;28;1
WireConnection;33;1;27;0
WireConnection;35;0;24;0
WireConnection;35;1;29;0
WireConnection;34;0;30;0
WireConnection;34;1;23;0
WireConnection;41;0;35;0
WireConnection;41;1;34;0
WireConnection;38;0;31;0
WireConnection;38;1;32;0
WireConnection;2;0;9;0
WireConnection;2;3;3;0
WireConnection;12;0;13;0
WireConnection;12;1;4;0
WireConnection;36;0;28;0
WireConnection;36;1;33;0
WireConnection;43;0;37;1
WireConnection;43;1;37;2
WireConnection;43;2;41;0
WireConnection;5;0;12;0
WireConnection;5;1;2;0
WireConnection;44;0;38;0
WireConnection;44;1;39;0
WireConnection;44;2;40;1
WireConnection;44;3;40;2
WireConnection;44;4;40;3
WireConnection;45;0;36;0
WireConnection;45;1;42;0
WireConnection;48;0;5;0
WireConnection;48;1;44;0
WireConnection;48;2;46;0
WireConnection;50;0;43;0
WireConnection;50;1;45;0
WireConnection;53;0;48;0
WireConnection;52;0;50;0
WireConnection;52;1;47;0
WireConnection;52;2;49;1
WireConnection;52;3;49;2
WireConnection;52;4;49;3
WireConnection;54;0;52;0
WireConnection;54;1;51;0
WireConnection;59;0;55;0
WireConnection;59;1;54;0
WireConnection;58;0;39;0
WireConnection;58;1;57;0
WireConnection;0;0;59;0
ASEEND*/
//CHKSM=492D84764F561E28CA40D1368B6B5FA324020ACF