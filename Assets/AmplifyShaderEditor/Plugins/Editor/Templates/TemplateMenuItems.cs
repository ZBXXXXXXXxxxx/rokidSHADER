// Amplify Shader Editor - Visual Shader Editing Tool
// Copyright (c) Amplify Creations, Lda <info@amplify.pt>
using UnityEditor;

namespace AmplifyShaderEditor
{
	public class TemplateMenuItems
	{
		[MenuItem( "Assets/Create/Amplify Shader/Legacy/Unlit", false, 85 )]
		public static void ApplyTemplateLegacyUnlit()
		{
			AmplifyShaderEditorWindow.CreateConfirmationTemplateShader( "0770190933193b94aaa3065e307002fa" );
		}
		[MenuItem( "Assets/Create/Amplify Shader/Legacy/Post Process", false, 85 )]
		public static void ApplyTemplateLegacyPostProcess()
		{
			AmplifyShaderEditorWindow.CreateConfirmationTemplateShader( "c71b220b631b6344493ea3cf87110c93" );
		}
		[MenuItem( "Assets/Create/Amplify Shader/Deprecated/Legacy/Default Unlit", false, 85 )]
		public static void ApplyTemplateDeprecatedLegacyDefaultUnlit()
		{
			AmplifyShaderEditorWindow.CreateConfirmationTemplateShader( "6e114a916ca3e4b4bb51972669d463bf" );
		}
		[MenuItem( "Assets/Create/Amplify Shader/Legacy/Default UI", false, 85 )]
		public static void ApplyTemplateLegacyDefaultUI()
		{
			AmplifyShaderEditorWindow.CreateConfirmationTemplateShader( "5056123faa0c79b47ab6ad7e8bf059a4" );
		}
		[MenuItem( "Assets/Create/Amplify Shader/Legacy/Unlit Lightmap", false, 85 )]
		public static void ApplyTemplateLegacyUnlitLightmap()
		{
			AmplifyShaderEditorWindow.CreateConfirmationTemplateShader( "899e609c083c74c4ca567477c39edef0" );
		}
		[MenuItem( "Assets/Create/Amplify Shader/Legacy/Default Sprites", false, 85 )]
		public static void ApplyTemplateLegacyDefaultSprites()
		{
			AmplifyShaderEditorWindow.CreateConfirmationTemplateShader( "0f8ba0101102bb14ebf021ddadce9b49" );
		}
		[MenuItem( "Assets/Create/Amplify Shader/Legacy/Particles Alpha Blended", false, 85 )]
		public static void ApplyTemplateLegacyParticlesAlphaBlended()
		{
			AmplifyShaderEditorWindow.CreateConfirmationTemplateShader( "0b6a9f8b4f707c74ca64c0be8e590de0" );
		}
		[MenuItem( "Assets/Create/Amplify Shader/Legacy/Multi Pass Unlit", false, 85 )]
		public static void ApplyTemplateLegacyMultiPassUnlit()
		{
			AmplifyShaderEditorWindow.CreateConfirmationTemplateShader( "e1de45c0d41f68c41b2cc20c8b9c05ef" );
		}
		[MenuItem( "Assets/Create/Amplify Shader/Templates/Knife/Unlit Depth Mask", false, 85 )]
		public static void ApplyTemplateTemplatesKnifeUnlitDepthMask()
		{
			AmplifyShaderEditorWindow.CreateConfirmationTemplateShader( "a91b3c5c9591c734aa5ea3b3037f67fa" );
		}
		[MenuItem( "Assets/Create/Amplify Shader/Legacy/Lit", false, 85 )]
		public static void ApplyTemplateLegacyLit()
		{
			AmplifyShaderEditorWindow.CreateConfirmationTemplateShader( "ed95fe726fd7b4644bb42f4d1ddd2bcd" );
		}
		[MenuItem( "Assets/Create/Amplify Shader/Templates/Unlit2Pass", false, 85 )]
		public static void ApplyTemplateTemplatesUnlit2Pass()
		{
			AmplifyShaderEditorWindow.CreateConfirmationTemplateShader( "b02f00fb1c715d54f9815395771ea132" );
		}
		[MenuItem( "Assets/Create/Amplify Shader/Templates/Unlit2Pass233", false, 85 )]
		public static void ApplyTemplateTemplatesUnlit2Pass233()
		{
			AmplifyShaderEditorWindow.CreateConfirmationTemplateShader( "5686a323359186844997b4a85cff60d4" );
		}
		[MenuItem( "Assets/Create/Amplify Shader/Templates/TestUnlit2Pass", false, 85 )]
		public static void ApplyTemplateTemplatesTestUnlit2Pass()
		{
			AmplifyShaderEditorWindow.CreateConfirmationTemplateShader( "2bdd7dd7badf31e44ab3166ff7ba36f5" );
		}
	}
}
