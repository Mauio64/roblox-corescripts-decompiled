local module = require("@luauforge/bundled/g")
local module2 = require("@luauforge/bundled/l")

return {
	useFoundationButton = module.GetFFlagUIBloxUseFoundationButton(),
	setZIndexOnGridCells = true,
	passRowAndColumnDataToItemInGridView = game:DefineFastFlag("UIBloxUseGridInfoForTile", false),
	responsiveGridDisplayLinesNonNil = true,
	enableTooltipV2HoverControllerReRenderFix = module.GetFFlagUIBloxEnableTooltipV2HoverControllerReRenderFix(),
	enableTooltipV2BodyFontFix = module.GetFFlagUIBloxEnableTooltipV2BodyFontFix(),
	enableOpenTypeSupport = module2(),
	didMountUpdateFullPageModal = true,
	useTokenizedShortcutBar = module.FFlagUIBloxAppShortcutBarUseTokens,
	enableScalingForSomeEdpIcons = true,
	enableShortcutCustomization = true,
	enableActionBarButtonOverride = module.FFlagUIBloxEnableActionBarButtonOverride,
	fixCoplayFooterConditionalHooks = module.FFlagUIBloxFixCoplayFooterConditionalHooks,
	disableTokenScaling = module.FFlagUIBloxDisableTokenScaling,
	removeStackedNavigationTabIconLabelSpacing = module.FFlagUIBloxRemoveStackedNavigationTabIconLabelSpacing,
	useFoundationToastButtonSizing = module.FFlagUIBloxToastFoundationButtonSizing,
	addFoundationNavigationTabIcon = module.FFlagUIBloxAddFoundationNavigationTabIcon,
	addNavigationTabTooltipAndTruncation = module.FFlagUIBloxAddNavigationTabTooltipAndTruncation
}
