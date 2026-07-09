local ParentParent = script.Parent.Parent
local SharedFlags = require(ParentParent.SharedFlags)
local UIBlox = SharedFlags.UIBlox

return {
	responsiveGridDisplayLinesNonNil = true,
	enableScalingForSomeEdpIcons = true,
	useFoundationButton = UIBlox.GetFFlagUIBloxUseFoundationButton(),
	setZIndexOnGridCells = game:DefineFastFlag("UIBloxUseNewZindex", false),
	passRowAndColumnDataToItemInGridView = game:DefineFastFlag("UIBloxUseGridInfoForTile", false),
	enableTooltipV2HoverControllerReRenderFix = UIBlox.GetFFlagUIBloxEnableTooltipV2HoverControllerReRenderFix(),
	enableTooltipV2BodyFontFix = UIBlox.GetFFlagUIBloxEnableTooltipV2BodyFontFix(),
	enableOpenTypeSupport = SharedFlags.GetFFlagLuaAppEnableOpenTypeSupport(),
	didMountUpdateFullPageModal = UIBlox.GetFFlagUIBloxDidMountUpdateFullPageModal(),
	useTokenizedShortcutBar = UIBlox.FFlagUIBloxAppShortcutBarUseTokens,
	enableShortcutCustomization = SharedFlags.FFlagLuaAppEnableStickyShortcutBar or SharedFlags.FFlagGuacStickyShortcutBarEnabled,
	enableActionBarButtonOverride = UIBlox.FFlagUIBloxEnableActionBarButtonOverride,
	fixCoplayFooterConditionalHooks = UIBlox.FFlagUIBloxFixCoplayFooterConditionalHooks,
	disableTokenScaling = UIBlox.FFlagUIBloxDisableTokenScaling,
	removeStackedNavigationTabIconLabelSpacing = UIBlox.FFlagUIBloxRemoveStackedNavigationTabIconLabelSpacing
}
