local SharedFlags = require("@game/CorePackages/Workspace/Packages/_Workspace/CoreScriptsInitializer/SharedFlags")
local uiBlox = SharedFlags.UIBlox

return {
	useFoundationButton = true,
	enableTooltipV2HoverControllerReRenderFix = uiBlox.GetFFlagUIBloxEnableTooltipV2HoverControllerReRenderFix(),
	enableTooltipV2BodyFontFix = uiBlox.GetFFlagUIBloxEnableTooltipV2BodyFontFix(),
	enableOpenTypeSupport = SharedFlags.GetFFlagLuaAppEnableOpenTypeSupport(),
	didMountUpdateFullPageModal = true,
	useFoundationToastButtonSizing = uiBlox.FFlagUIBloxToastFoundationButtonSizing,
	useTokenizedShortcutBar = SharedFlags.FFlagEnableConsoleExpControls,
	disableTokenScaling = uiBlox.FFlagUIBloxDisableTokenScaling
}
