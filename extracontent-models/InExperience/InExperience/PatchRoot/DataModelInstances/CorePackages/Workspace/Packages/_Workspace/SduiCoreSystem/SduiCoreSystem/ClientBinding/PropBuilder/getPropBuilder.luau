local SduiCoreSystem = script:FindFirstAncestor("SduiCoreSystem")

local parent = SduiCoreSystem.Parent

local buildDefaultProp = require(SduiCoreSystem.ClientBinding.PropBuilder.buildDefaultProp)
local buildStringProp = require(SduiCoreSystem.ClientBinding.PropBuilder.buildStringProp)
local buildTableProp = require(SduiCoreSystem.ClientBinding.PropBuilder.buildTableProp)
local buildRepeatedProp = require(SduiCoreSystem.ClientBinding.PropBuilder.buildRepeatedProp)
local buildContainerProp = require(SduiCoreSystem.ClientBinding.PropBuilder.buildContainerProp)
local buildNestedComponentProp = require(SduiCoreSystem.ClientBinding.PropBuilder.buildNestedComponentProp)
local buildLazyNestedComponentProp = require(SduiCoreSystem.ClientBinding.PropBuilder.buildLazyNestedComponentProp)

local buildLazyNestedComponentListProp = require(SduiCoreSystem.ClientBinding.PropBuilder.buildLazyNestedComponentListProp)
local buildNestedComponentListProp = require(SduiCoreSystem.ClientBinding.PropBuilder.buildNestedComponentListProp)
local buildActionProp = require(SduiCoreSystem.ClientBinding.PropBuilder.buildActionProp)
local SduiParsers = require(SduiCoreSystem.SduiParsers)
require(SduiCoreSystem.ClientBinding.SduiClientBindingTypes)
local SduiClientBindingParsers = require(SduiCoreSystem.ClientBinding.PropBuilder.SduiClientBindingParsers)
local ProtoVariableMapper = require(SduiCoreSystem.ClientBinding.ProtoVariableMapper)

local SharedFlags = require(parent.SharedFlags)
local FFlagSduiMarketplaceCatalogCategorySupport = SharedFlags.FFlagSduiMarketplaceCatalogCategorySupport
local SharedFlags2 = require(parent.SharedFlags)
local FFlagSduiMarketplaceCatalogSortSupport = SharedFlags2.FFlagSduiMarketplaceCatalogSortSupport
local SharedFlags3 = require(parent.SharedFlags)
local FFlagSduiCatalogItemCard = SharedFlags3.FFlagSduiCatalogItemCard
local SharedFlags4 = require(parent.SharedFlags)
local FFlagSduiSheetComponent = SharedFlags4.FFlagSduiSheetComponent
local SharedFlags5 = require(parent.SharedFlags)
local FFlagSduiSystemBannerComponent = SharedFlags5.FFlagSduiSystemBannerComponent
local SharedFlags6 = require(parent.SharedFlags)
local FFlagSduiBannerContextComponent = SharedFlags6.FFlagSduiBannerContextComponent
local SharedFlags7 = require(parent.SharedFlags)
local FFlagSduiParseProtoGradientFields = SharedFlags7.FFlagSduiParseProtoGradientFields
local SharedFlags8 = require(parent.SharedFlags)
local FFlagLuaAppSduiHomePageSupport = SharedFlags8.FFlagLuaAppSduiHomePageSupport
local SharedFlags9 = require(parent.SharedFlags)
local FFlagSduiExperimentalComponent = SharedFlags9.FFlagSduiExperimentalComponent
local SharedFlags10 = require(parent.SharedFlags)
local FFlagSduiListComponents = SharedFlags10.FFlagSduiListComponents

local function applyParser(callback, callback2) -- 28 equivalent calls inferred from this helper
	return function(p, p2, p3, p4, p5, p6)
		local v, v2 = callback(p, p2, p3, p4, p5, p6, callback2)

		return v, v2
	end
end

local function createEngineEnumProtoBuilder(p, p2: string)
	local function fn(p3)
		local engineEnumParser = SduiParsers.getEngineEnumParser(p)
		return ProtoVariableMapper.mapProtoEngineEnumToLua(p3, p2, engineEnumParser)
	end

	return applyParser(buildDefaultProp, fn) -- inferred equivalent call
end

local v = {}
v.StringProp = buildStringProp
v.BoolProp = buildDefaultProp
v.FloatProp = buildDefaultProp
v.DoubleProp = buildDefaultProp
v.Int32Prop = buildDefaultProp
v.Int64Prop = buildDefaultProp
v.StructProp = applyParser(buildDefaultProp, SduiClientBindingParsers.parseStruct) -- inferred equivalent call
v.ImageStringProp = applyParser(buildStringProp, SduiParsers.parseImageStringProp_) -- inferred equivalent call
v.ImageSetProp = applyParser(buildStringProp, SduiParsers.parseImageSetOrImageProp_) -- inferred equivalent call
v.ColorProp = applyParser(buildDefaultProp, SduiClientBindingParsers.parseColorPropLegacy) -- inferred equivalent call
v.Color3Prop = applyParser(buildDefaultProp, SduiClientBindingParsers.parseColor3) -- inferred equivalent call
v.TypographyProp = buildDefaultProp
v.TypographyFontProp = buildDefaultProp
v.UDimProp = applyParser(buildDefaultProp, SduiClientBindingParsers.parseUDim) -- inferred equivalent call
v.UDim2Prop = applyParser(buildDefaultProp, SduiClientBindingParsers.parseUDim2) -- inferred equivalent call
v.Vector2Prop = applyParser(buildDefaultProp, SduiParsers.parseVector2Prop_) -- inferred equivalent call
v.NestedComponentProp = buildNestedComponentProp
v.LazyNestedComponentProp = buildLazyNestedComponentProp
v.NestedComponentListProp = buildNestedComponentListProp
v.LazyNestedComponentListProp = buildLazyNestedComponentListProp
v.StringArrayProp = applyParser(buildDefaultProp, SduiClientBindingParsers.parseStringArray) -- inferred equivalent call
v.IconProp = applyParser(buildDefaultProp, SduiParsers.parseIconProp_) -- inferred equivalent call
local v2

if FFlagSduiParseProtoGradientFields then
	v2 = SduiClientBindingParsers.parseGradient
else
	v2 = SduiParsers.parseGradientProp_
end

v.GradientProp = applyParser(buildDefaultProp, v2) -- inferred equivalent call

v.ArrayOfStructProp = applyParser(buildDefaultProp, SduiClientBindingParsers.parseArrayOfStruct) -- inferred equivalent call
local arrayOfFloatProp

if FFlagSduiSheetComponent then
	arrayOfFloatProp = buildRepeatedProp
end

v.ArrayOfFloatProp = arrayOfFloatProp
local arrayOfPymkItemDataProp

if FFlagLuaAppSduiHomePageSupport then
	arrayOfPymkItemDataProp = applyParser(buildDefaultProp, SduiClientBindingParsers.parsePymkItems) -- inferred equivalent call
end

v.ArrayOfPymkItemDataProp = arrayOfPymkItemDataProp

v.ActionProp = buildActionProp
v.TableProp = buildTableProp

v.ContainerProp = buildContainerProp
v.ArrayOfMenuItemProp = buildRepeatedProp
v.MenuItemProp = buildTableProp
v.MenuItem = buildTableProp
v.GenericShareLinkData = buildTableProp
v.ShareLinkFetchData = buildTableProp
v.ExperienceShareLinkPayload = buildTableProp
v.EventShareLinkPayload = buildTableProp
v.MediaGallerySchema_MediaItemArrayProp = buildRepeatedProp
local arrayOfSystemBannerActionsProp

if FFlagSduiSystemBannerComponent then
	arrayOfSystemBannerActionsProp = buildRepeatedProp
end

v.ArrayOfSystemBannerActionsProp = arrayOfSystemBannerActionsProp
local systemBannerActionProp

if FFlagSduiSystemBannerComponent then
	systemBannerActionProp = buildTableProp
end

v.SystemBannerActionProp = systemBannerActionProp
local foundationInternalNoticeLinkProp

if FFlagSduiBannerContextComponent then
	foundationInternalNoticeLinkProp = buildTableProp
end

v.FoundationInternalNoticeLinkProp = foundationInternalNoticeLinkProp
local foundationInternalNoticeLink

if FFlagSduiBannerContextComponent then
	foundationInternalNoticeLink = buildTableProp
end

v.FoundationInternalNoticeLink = foundationInternalNoticeLink
v.FoundationIconConfigProp = buildTableProp
v.HoldActionConfigProp = buildTableProp
v.HoldActionConfig = buildTableProp
v.OpenPurchasePromptAction_ProductPayload = buildTableProp
v.OpenPurchasePromptAction_DisplayInfo = buildTableProp
v.OpenPurchasePromptAction_PurchaseOptions = buildTableProp
v.OpenPurchasePromptAction_PurchaseAnalyticsMetadata = buildTableProp
local arrayOfCatalogCategoryMenuItemProp

if FFlagSduiMarketplaceCatalogCategorySupport then
	arrayOfCatalogCategoryMenuItemProp = buildRepeatedProp
end

v.ArrayOfCatalogCategoryMenuItemProp = arrayOfCatalogCategoryMenuItemProp
local catalogCategoryMenuItem

if FFlagSduiMarketplaceCatalogCategorySupport then
	catalogCategoryMenuItem = buildTableProp
end

v.CatalogCategoryMenuItem = catalogCategoryMenuItem
local arrayOfCategoryMenuButtonProp

if FFlagSduiMarketplaceCatalogCategorySupport then
	arrayOfCategoryMenuButtonProp = buildRepeatedProp
end

v.ArrayOfCategoryMenuButtonProp = arrayOfCategoryMenuButtonProp
local categoryMenuButtonProp

if FFlagSduiMarketplaceCatalogCategorySupport then
	categoryMenuButtonProp = buildTableProp
end

v.CategoryMenuButtonProp = categoryMenuButtonProp
local categoryMenuButton

if FFlagSduiMarketplaceCatalogCategorySupport then
	categoryMenuButton = buildTableProp
end

v.CategoryMenuButton = categoryMenuButton
local arrayOfCatalogCategoryMenuTooltipInfoProp

if FFlagSduiMarketplaceCatalogCategorySupport then
	arrayOfCatalogCategoryMenuTooltipInfoProp = buildRepeatedProp
end

v.ArrayOfCatalogCategoryMenuTooltipInfoProp = arrayOfCatalogCategoryMenuTooltipInfoProp
local catalogCategoryMenuTooltipInfoProp

if FFlagSduiMarketplaceCatalogCategorySupport then
	catalogCategoryMenuTooltipInfoProp = buildTableProp
end

v.CatalogCategoryMenuTooltipInfoProp = catalogCategoryMenuTooltipInfoProp
local catalogCategoryMenuTooltipInfo

if FFlagSduiMarketplaceCatalogCategorySupport then
	catalogCategoryMenuTooltipInfo = buildTableProp
end

v.CatalogCategoryMenuTooltipInfo = catalogCategoryMenuTooltipInfo
local arrayOfTooltipInfoActionsProp

if FFlagSduiMarketplaceCatalogCategorySupport then
	arrayOfTooltipInfoActionsProp = buildRepeatedProp
end

v.ArrayOfTooltipInfoActionsProp = arrayOfTooltipInfoActionsProp
local tooltipInfoActionPropsProp

if FFlagSduiMarketplaceCatalogCategorySupport then
	tooltipInfoActionPropsProp = buildTableProp
end

v.TooltipInfoActionPropsProp = tooltipInfoActionPropsProp
local tooltipInfoActionProps

if FFlagSduiMarketplaceCatalogCategorySupport then
	tooltipInfoActionProps = buildTableProp
end

v.TooltipInfoActionProps = tooltipInfoActionProps
local arrayOfCatalogSortContentProp

if FFlagSduiMarketplaceCatalogSortSupport then
	arrayOfCatalogSortContentProp = buildRepeatedProp
end

v.ArrayOfCatalogSortContentProp = arrayOfCatalogSortContentProp
local arrayOfItemFooterProp

if FFlagSduiMarketplaceCatalogSortSupport then
	arrayOfItemFooterProp = buildRepeatedProp
end

v.ArrayOfItemFooterProp = arrayOfItemFooterProp
local cardStyleProp

if FFlagSduiMarketplaceCatalogSortSupport or FFlagSduiCatalogItemCard then
	cardStyleProp = buildTableProp
end

v.CardStyleProp = cardStyleProp

v.AnalyticsDataField = buildDefaultProp

local AutomaticSize = Enum.AutomaticSize
local v3 = "AUTOMATIC_SIZE_"
local function fn(p)
	local engineEnumParser = SduiParsers.getEngineEnumParser(AutomaticSize)
	return ProtoVariableMapper.mapProtoEngineEnumToLua(p, v3, engineEnumParser)
end

v.AutomaticSizeProp = applyParser(buildDefaultProp, fn) -- inferred equivalent call
local TextTruncate = Enum.TextTruncate
local v4 = "TEXT_TRUNCATE_"
local function fn2(p)
	local engineEnumParser = SduiParsers.getEngineEnumParser(TextTruncate)
	return ProtoVariableMapper.mapProtoEngineEnumToLua(p, v4, engineEnumParser)
end

v.TextTruncateProp = applyParser(buildDefaultProp, fn2) -- inferred equivalent call
local TextXAlignment = Enum.TextXAlignment
local v5 = "TEXT_X_ALIGNMENT_"
local function fn3(p)
	local engineEnumParser = SduiParsers.getEngineEnumParser(TextXAlignment)
	return ProtoVariableMapper.mapProtoEngineEnumToLua(p, v5, engineEnumParser)
end

v.TextXAlignmentProp = applyParser(buildDefaultProp, fn3) -- inferred equivalent call
local TextYAlignment = Enum.TextYAlignment
local v6 = "TEXT_Y_ALIGNMENT_"
local function fn4(p)
	local engineEnumParser = SduiParsers.getEngineEnumParser(TextYAlignment)
	return ProtoVariableMapper.mapProtoEngineEnumToLua(p, v6, engineEnumParser)
end

v.TextYAlignmentProp = applyParser(buildDefaultProp, fn4) -- inferred equivalent call
local UIFlexMode = Enum.UIFlexMode
local v7 = "UI_FLEX_MODE_"
local function fn5(p)
	local engineEnumParser = SduiParsers.getEngineEnumParser(UIFlexMode)
	return ProtoVariableMapper.mapProtoEngineEnumToLua(p, v7, engineEnumParser)
end

v.UIFlexModeProp = applyParser(buildDefaultProp, fn5) -- inferred equivalent call
local ScaleType = Enum.ScaleType
local v8 = "SCALE_TYPE_"
local function fn6(p)
	local engineEnumParser = SduiParsers.getEngineEnumParser(ScaleType)
	return ProtoVariableMapper.mapProtoEngineEnumToLua(p, v8, engineEnumParser)
end

v.ScaleTypeProp = applyParser(buildDefaultProp, fn6) -- inferred equivalent call
local ResamplerMode = Enum.ResamplerMode
local v9 = "RESAMPLER_MODE_"
local function fn7(p)
	local engineEnumParser = SduiParsers.getEngineEnumParser(ResamplerMode)
	return ProtoVariableMapper.mapProtoEngineEnumToLua(p, v9, engineEnumParser)
end

v.ResamplerModeProp = applyParser(buildDefaultProp, fn7) -- inferred equivalent call
local SizeConstraint = Enum.SizeConstraint
local v10 = "SIZE_CONSTRAINT_"
local function fn8(p)
	local engineEnumParser = SduiParsers.getEngineEnumParser(SizeConstraint)
	return ProtoVariableMapper.mapProtoEngineEnumToLua(p, v10, engineEnumParser)
end

v.SizeConstraintProp = applyParser(buildDefaultProp, fn8) -- inferred equivalent call
local SelectionBehavior = Enum.SelectionBehavior
local v11 = "SELECTION_BEHAVIOR_"
local function fn9(p)
	local engineEnumParser = SduiParsers.getEngineEnumParser(SelectionBehavior)
	return ProtoVariableMapper.mapProtoEngineEnumToLua(p, v11, engineEnumParser)
end

v.SelectionBehaviorProp = applyParser(buildDefaultProp, fn9) -- inferred equivalent call
local KeyCode = Enum.KeyCode
local v12 = "KEY_CODE_"
local function fn10(p)
	local engineEnumParser = SduiParsers.getEngineEnumParser(KeyCode)
	return ProtoVariableMapper.mapProtoEngineEnumToLua(p, v12, engineEnumParser)
end

v.KeyCodeProp = applyParser(buildDefaultProp, fn10) -- inferred equivalent call
v.FocusNavActionsProp = applyParser(buildTableProp, SduiClientBindingParsers.parseFocusNavActions) -- inferred equivalent call
v.ColorStyleProp = buildDefaultProp
v.UiScaledUDim2Prop = applyParser(buildDefaultProp, SduiClientBindingParsers.parseUiScaledUDim2) -- inferred equivalent call
v.UiScaledUDimProp = applyParser(buildDefaultProp, SduiClientBindingParsers.parseUiScaledUDim) -- inferred equivalent call
v.UiScaledFloatProp = applyParser(buildDefaultProp, SduiClientBindingParsers.parseUiScaledNumber) -- inferred equivalent call

v.FillBehaviorProp = buildDefaultProp
v.InputSizeProp = buildDefaultProp
local listItemInputControlProp

if FFlagSduiListComponents then
	listItemInputControlProp = buildTableProp
end

v.ListItemInputControlProp = listItemInputControlProp
v.LaunchExperienceAction_ExperienceJoinData = buildTableProp
v.AvatarConfigProp = buildTableProp
v.ArrayOfAvatarProp = buildRepeatedProp

local function getPropBuilder(p: string, flag: boolean?)
	if not p then
		error("Failed to find prop builder -- missing propDescriptorName")
	end

	local propBuilder = v[p]

	if propBuilder then
		return propBuilder
	end

	if FFlagSduiExperimentalComponent and flag then
		error(`No prop builder registered under the name '{p}'`)
	end

	warn(`Could not find propBuilder for propDescriptorName {p}. Using default.`)
	propBuilder = buildDefaultProp

	return propBuilder
end

return getPropBuilder
