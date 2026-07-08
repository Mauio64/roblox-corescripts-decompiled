local ParentParent = script.Parent.Parent
local SharedFlags = require(ParentParent.SharedFlags)
local UIBlox = SharedFlags.UIBlox

return {
	useFoundationButton = true,
	enableTooltipV2HoverControllerReRenderFix = UIBlox.GetFFlagUIBloxEnableTooltipV2HoverControllerReRenderFix(),
	enableTooltipV2BodyFontFix = UIBlox.GetFFlagUIBloxEnableTooltipV2BodyFontFix(),
	enableOpenTypeSupport = SharedFlags.GetFFlagLuaAppEnableOpenTypeSupport(),
	didMountUpdateFullPageModal = UIBlox.GetFFlagUIBloxDidMountUpdateFullPageModal(),
	useTokenizedShortcutBar = SharedFlags.FFlagEnableConsoleExpControls,
	disableTokenScaling = UIBlox.FFlagUIBloxDisableTokenScaling
}
