local SplitPaneEducationalTourVideoAssetIds = require("@game/CorePackages/Workspace/Packages/_Index/SplitPane/SplitPane/Flags/SplitPaneEducationalTourVideoAssetIds")

return {
	{
		videoAssetId = SplitPaneEducationalTourVideoAssetIds.step1Video,
		gamepadVideoAssetId = SplitPaneEducationalTourVideoAssetIds.step1GamepadVideo,
		collapsedVideoAssetId = SplitPaneEducationalTourVideoAssetIds.step1CollapsedVideo,
		collapsedGamepadVideoAssetId = SplitPaneEducationalTourVideoAssetIds.step1CollapsedGamepadVideo
	},
	{ videoAssetId = SplitPaneEducationalTourVideoAssetIds.step2Video, gamepadVideoAssetId = SplitPaneEducationalTourVideoAssetIds.step2GamepadVideo },
	{
		videoAssetId = SplitPaneEducationalTourVideoAssetIds.step3Video,
		gamepadVideoAssetId = SplitPaneEducationalTourVideoAssetIds.step3GamepadVideo,
		isFinal = true
	}
}
