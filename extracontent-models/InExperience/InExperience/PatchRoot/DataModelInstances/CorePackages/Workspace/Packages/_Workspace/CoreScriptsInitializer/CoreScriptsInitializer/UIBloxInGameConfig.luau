local parent = script.Parent.Parent

local SharedFlags = require(parent.SharedFlags)
local UIBlox = SharedFlags.UIBlox

return {
	useFoundationButton = true,
	enableTooltipV2HoverControllerReRenderFix = UIBlox.GetFFlagUIBloxEnableTooltipV2HoverControllerReRenderFix(),
	enableTooltipV2BodyFontFix = UIBlox.GetFFlagUIBloxEnableTooltipV2BodyFontFix(),
	enableOpenTypeSupport = SharedFlags.GetFFlagLuaAppEnableOpenTypeSupport(),
	didMountUpdateFullPageModal = true,
	useFoundationToastButtonSizing = UIBlox.FFlagUIBloxToastFoundationButtonSizing,
	useTokenizedShortcutBar = SharedFlags.FFlagEnableConsoleExpControls,
	disableTokenScaling = UIBlox.FFlagUIBloxDisableTokenScaling
}
