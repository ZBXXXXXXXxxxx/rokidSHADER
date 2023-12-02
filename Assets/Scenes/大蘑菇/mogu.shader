// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "mogu"
{
	Properties
	{
		_basecolor("basecolor", 2D) = "white" {}
		_Lightrange("Lightrange", Float) = 0
		_Vector2("Vector 2", Vector) = (0,1,0,0)
		[HDR]_Color2("Color 2", Color) = (0,0,0,0)
		_Float4("Float 4", Float) = 0
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

			uniform sampler2D _basecolor;
			uniform float4 _basecolor_ST;
			uniform float3 POS;
			uniform float _Lightrange;
			uniform float3 ssss;
			uniform float2 _Vector2;
			uniform float _Float4;
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
				float2 uv_basecolor = i.ase_texcoord1.xy * _basecolor_ST.xy + _basecolor_ST.zw;
				float3 position60 = POS;
				float Scale31 = ssss.x;
				float3 _Vector1 = float3(0,0,1);
				float ifLocalVar68 = 0;
				if( ( distance( WorldPosition , position60 ) + _Lightrange ) > Scale31 )
				ifLocalVar68 = _Vector1.x;
				else if( ( distance( WorldPosition , position60 ) + _Lightrange ) == Scale31 )
				ifLocalVar68 = _Vector1.y;
				else if( ( distance( WorldPosition , position60 ) + _Lightrange ) < Scale31 )
				ifLocalVar68 = _Vector1.z;
				clip( ifLocalVar68 - 0.99);
				float4 CLIP53 = ( tex2D( _basecolor, uv_basecolor ) + float4( 0,0,0,0 ) );
				float lerpResult44 = lerp( _Vector2.x , _Vector2.y , ( distance( WorldPosition , position60 ) - ( Scale31 + _Float4 ) ));
				float3 break37 = ( WorldPosition * 0.26 );
				float mulTime32 = _Time.y * 0.08;
				float4 appendResult41 = (float4(break37.x , ( break37.y + mulTime32 ) , 0.0 , 0.0));
				float simplePerlin2D46 = snoise( appendResult41.xy*19.12 );
				simplePerlin2D46 = simplePerlin2D46*0.5 + 0.5;
				float3 _Vector3 = float3(0,0,1);
				float ifLocalVar52 = 0;
				if( ( lerpResult44 * simplePerlin2D46 ) > 0.03 )
				ifLocalVar52 = _Vector3.x;
				else if( ( lerpResult44 * simplePerlin2D46 ) == 0.03 )
				ifLocalVar52 = _Vector3.y;
				else if( ( lerpResult44 * simplePerlin2D46 ) < 0.03 )
				ifLocalVar52 = _Vector3.z;
				
				
				finalColor = ( CLIP53 + ( ifLocalVar52 * _Color2 ) );
				return finalColor;
			}
			ENDCG
		}
	}
	CustomEditor "ASEMaterialInspector"
	
	
}
/*ASEBEGIN
Version=18800
-0.8;497.6;1440.8;855.8;2728.252;3456.925;1.870493;True;False
Node;AmplifyShaderEditor.CommentaryNode;25;-3013.196,-2169.396;Inherit;False;2034.706;773.7719;CLIP;15;70;69;68;67;66;65;64;63;62;61;60;49;45;36;31;;1,1,1,1;0;0
Node;AmplifyShaderEditor.Vector3Node;58;-3218.614,-1652.889;Inherit;False;Global;POS;POS;3;0;Create;True;0;0;0;False;0;False;0,0,0;-1,3.91,-14.46;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.RangedFloatNode;27;-1314.678,-734.5269;Inherit;False;Constant;_Float9;Float 9;8;0;Create;True;0;0;0;False;0;False;0.26;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.WorldPosInputsNode;28;-1513.305,-837.1685;Inherit;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.Vector3Node;59;-3214.135,-1462.71;Inherit;False;Global;ssss;ssss;3;0;Create;True;0;0;0;False;0;False;0,0,0;14.28632,14.28632,14.28632;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;29;-1188.748,-853.1105;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;31;-3002.477,-1451.111;Inherit;False;Scale;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;60;-3012.63,-1649.909;Inherit;False;position;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode;30;-1247.824,-633.6019;Inherit;False;Constant;_Float8;Float 8;8;0;Create;True;0;0;0;False;0;False;0.08;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.BreakToComponentsNode;37;-986.9195,-963.1225;Inherit;False;FLOAT3;1;0;FLOAT3;0,0,0;False;16;FLOAT;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT;5;FLOAT;6;FLOAT;7;FLOAT;8;FLOAT;9;FLOAT;10;FLOAT;11;FLOAT;12;FLOAT;13;FLOAT;14;FLOAT;15
Node;AmplifyShaderEditor.RangedFloatNode;33;-1682.498,-919.1406;Inherit;False;Property;_Float4;Float 4;9;0;Create;True;0;0;0;False;0;False;0;-0.26;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;61;-2814.226,-1961.85;Inherit;False;60;position;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.GetLocalVarNode;34;-1716.811,-1222.89;Inherit;False;60;position;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.WorldPosInputsNode;62;-2963.196,-2119.396;Inherit;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SimpleTimeNode;32;-1095.704,-669.6208;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;35;-1736.657,-1044.903;Inherit;False;31;Scale;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.WorldPosInputsNode;36;-1725.514,-1457.847;Inherit;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SimpleAddOpNode;39;-811.7434,-880.0001;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DistanceOpNode;38;-1279.001,-1277.463;Inherit;False;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;40;-1278.301,-1035.633;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;64;-2487.021,-1767.432;Inherit;False;Property;_Lightrange;Lightrange;3;0;Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.DistanceOpNode;63;-2439.883,-1927.811;Inherit;False;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.Vector3Node;65;-2361.505,-1549.308;Inherit;False;Constant;_Vector1;Vector 1;2;0;Create;True;0;0;0;False;0;False;0,0,1;0,0,0;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.Vector2Node;43;-809.5695,-1563.065;Inherit;False;Property;_Vector2;Vector 2;5;0;Create;True;0;0;0;False;0;False;0,1;0.26,-2.13;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.SimpleSubtractOpNode;71;-963.7665,-1225.766;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;41;-672.7347,-1034.453;Inherit;False;FLOAT4;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.GetLocalVarNode;67;-2762.262,-1702.583;Inherit;False;31;Scale;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;1;-1576.429,-3775.138;Inherit;True;Property;_basecolor;basecolor;0;0;Create;True;0;0;0;False;0;False;-1;None;47a5ba3907c91854aa8f8aa382393eb5;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleAddOpNode;66;-2229.59,-1863.674;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;42;-536.0201,-679.7689;Inherit;False;Constant;_Float5;Float 5;6;0;Create;True;0;0;0;False;0;False;19.12;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;45;-1739.88,-1655.689;Inherit;False;Constant;_Float3;Float 3;1;0;Create;True;0;0;0;False;0;False;0.99;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;3;-792.5913,-3194.8;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.NoiseGeneratorNode;46;-480.6727,-1116.507;Inherit;True;Simplex2D;True;False;2;0;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.ConditionalIfNode;68;-2031.32,-1764.911;Inherit;False;False;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;4;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;44;-507.2176,-1576.636;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ClipNode;49;-1480.007,-1835.019;Inherit;False;3;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.Vector3Node;50;-486.5916,-1347.811;Inherit;False;Constant;_Vector3;Vector 3;5;0;Create;True;0;0;0;False;0;False;0,0,1;0,0,0;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;47;-328.1727,-1655.143;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;48;-487.4014,-1439.907;Inherit;False;Constant;_Float6;Float 6;5;0;Create;True;0;0;0;False;0;False;0.03;0.51;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.ConditionalIfNode;52;-25.22339,-1643.677;Inherit;False;False;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;4;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;53;-914.9534,-1825.918;Inherit;False;CLIP;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.ColorNode;51;-32.61841,-1388.506;Inherit;False;Property;_Color2;Color 2;7;1;[HDR];Create;True;0;0;0;False;0;False;0,0,0,0;0,2.462395,4.237095,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;55;286.1875,-1674.427;Inherit;False;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;54;-315.0671,-1796.335;Inherit;False;53;CLIP;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;57;-1623.785,-508.601;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;4;-1130.269,-3162.35;Inherit;False;3;3;0;FLOAT;0;False;1;FLOAT3;0,0,0;False;2;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.FresnelNode;2;-1665.318,-3521.756;Inherit;True;Standard;WorldNormal;ViewDir;False;False;5;0;FLOAT3;0,0,1;False;4;FLOAT3;0,0,0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;5;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;69;-2497.207,-1623.934;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;22;-2190.634,-3229.708;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.Vector3Node;23;-1893.893,-3468.991;Inherit;False;Property;_fresnal;fresnal;6;0;Create;True;0;0;0;False;0;False;0,1,5;0.92,9,3.4;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.RangedFloatNode;70;-2732.301,-1499.854;Inherit;False;Property;_Float7;Float 7;10;0;Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;56;485.2917,-1787.227;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;26;-2333.493,-2495.377;Inherit;True;Property;_TextureSample0;Texture Sample 0;1;0;Create;True;0;0;0;False;0;False;-1;None;ffc2f2f6939768948a7dfda098fe288e;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.WorldPosInputsNode;11;-2491.056,-3123.427;Inherit;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.ColorNode;24;-1233.048,-2873.085;Inherit;False;Property;_Color0;Color 0;8;1;[HDR];Create;True;0;0;0;False;0;False;0,0,0,0;0,0.4243557,0.4313726,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;17;-1331.722,-2626.084;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;6;-1463.028,-2466.112;Inherit;True;Property;_emi;emi;2;0;Create;True;0;0;0;False;0;False;-1;None;21ef06e1a4ea5e040be697bf0b56430e;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.HSVToRGBNode;12;-1519.306,-3031.971;Inherit;True;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.ColorNode;9;-1716.795,-2641.074;Inherit;False;Property;_Color1;Color 1;4;1;[HDR];Create;True;0;0;0;False;0;False;0,0,0,0;0.02881723,0.01780332,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;20;-1679.919,-3126.168;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;13;-1807.405,-2798.008;Inherit;False;Constant;_Float0;Float 0;4;0;Create;True;0;0;0;False;0;False;1.07;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;14;-1788.065,-3044.567;Inherit;False;3;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;21;-1826.919,-3149.168;Inherit;False;Constant;_Float2;Float 2;3;0;Create;True;0;0;0;False;0;False;0.41;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleTimeNode;16;-1972.153,-2958.38;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.PosVertexDataNode;72;-2218.042,-3286.349;Inherit;False;0;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.VoronoiNode;18;-2067.293,-2826.791;Inherit;True;0;0;1;0;1;False;1;False;False;4;0;FLOAT2;0,0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;0;False;3;FLOAT;0;FLOAT2;1;FLOAT2;2
Node;AmplifyShaderEditor.Vector2Node;19;-2354.663,-2715.334;Inherit;False;Constant;_Vector0;Vector 0;3;0;Create;True;0;0;0;False;0;False;-3.95,-6.3;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.RangedFloatNode;15;-2276.464,-2944.022;Inherit;False;Constant;_Float1;Float 1;4;0;Create;True;0;0;0;False;0;False;0.54;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;10;-1114.354,-2565.024;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;0;933.0423,-1829.061;Float;False;True;-1;2;ASEMaterialInspector;100;1;mogu;0770190933193b94aaa3065e307002fa;True;Unlit;0;0;Unlit;2;True;0;1;False;-1;0;False;-1;0;1;False;-1;0;False;-1;True;0;False;-1;0;False;-1;False;False;False;False;False;False;True;0;False;-1;True;0;False;-1;True;True;True;True;True;0;False;-1;False;False;False;True;False;255;False;-1;255;False;-1;255;False;-1;7;False;-1;1;False;-1;1;False;-1;1;False;-1;7;False;-1;1;False;-1;1;False;-1;1;False;-1;True;1;False;-1;True;3;False;-1;True;True;0;False;-1;0;False;-1;True;1;RenderType=Opaque=RenderType;True;2;0;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;1;LightMode=ForwardBase;False;0;;0;0;Standard;1;Vertex Position,InvertActionOnDeselection;1;0;1;True;False;;False;0
WireConnection;29;0;28;0
WireConnection;29;1;27;0
WireConnection;31;0;59;1
WireConnection;60;0;58;0
WireConnection;37;0;29;0
WireConnection;32;0;30;0
WireConnection;39;0;37;1
WireConnection;39;1;32;0
WireConnection;38;0;36;0
WireConnection;38;1;34;0
WireConnection;40;0;35;0
WireConnection;40;1;33;0
WireConnection;63;0;62;0
WireConnection;63;1;61;0
WireConnection;71;0;38;0
WireConnection;71;1;40;0
WireConnection;41;0;37;0
WireConnection;41;1;39;0
WireConnection;66;0;63;0
WireConnection;66;1;64;0
WireConnection;3;0;1;0
WireConnection;46;0;41;0
WireConnection;46;1;42;0
WireConnection;68;0;66;0
WireConnection;68;1;67;0
WireConnection;68;2;65;1
WireConnection;68;3;65;2
WireConnection;68;4;65;3
WireConnection;44;0;43;1
WireConnection;44;1;43;2
WireConnection;44;2;71;0
WireConnection;49;0;3;0
WireConnection;49;1;68;0
WireConnection;49;2;45;0
WireConnection;47;0;44;0
WireConnection;47;1;46;0
WireConnection;52;0;47;0
WireConnection;52;1;48;0
WireConnection;52;2;50;1
WireConnection;52;3;50;2
WireConnection;52;4;50;3
WireConnection;53;0;49;0
WireConnection;55;0;52;0
WireConnection;55;1;51;0
WireConnection;4;0;2;0
WireConnection;4;1;12;0
WireConnection;4;2;24;0
WireConnection;2;1;23;1
WireConnection;2;2;23;2
WireConnection;2;3;23;3
WireConnection;69;0;67;0
WireConnection;69;1;70;0
WireConnection;56;0;54;0
WireConnection;56;1;55;0
WireConnection;17;0;12;0
WireConnection;17;1;9;0
WireConnection;12;0;20;0
WireConnection;12;1;13;0
WireConnection;12;2;13;0
WireConnection;20;0;21;0
WireConnection;20;1;14;0
WireConnection;14;0;72;3
WireConnection;14;1;16;0
WireConnection;14;2;18;0
WireConnection;16;0;15;0
WireConnection;18;0;11;0
WireConnection;18;1;19;1
WireConnection;18;2;19;2
WireConnection;10;0;17;0
WireConnection;10;1;6;0
WireConnection;0;0;56;0
ASEEND*/
//CHKSM=3C7786220785393CE27A0A5CFEC48A234A5EF954