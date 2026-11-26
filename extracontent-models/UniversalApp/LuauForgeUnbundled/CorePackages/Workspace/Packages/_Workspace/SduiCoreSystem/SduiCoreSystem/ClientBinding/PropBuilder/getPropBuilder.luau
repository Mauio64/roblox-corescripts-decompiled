local buildDefaultProp = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiCoreSystem/SduiCoreSystem/ClientBinding/PropBuilder/buildDefaultProp")
local buildStringProp = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiCoreSystem/SduiCoreSystem/ClientBinding/PropBuilder/buildStringProp")
local buildTableProp = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiCoreSystem/SduiCoreSystem/ClientBinding/PropBuilder/buildTableProp")
local buildRepeatedProp = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiCoreSystem/SduiCoreSystem/ClientBinding/PropBuilder/buildRepeatedProp")
local buildContainerProp = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiCoreSystem/SduiCoreSystem/ClientBinding/PropBuilder/buildContainerProp")
local buildNestedComponentProp = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiCoreSystem/SduiCoreSystem/ClientBinding/PropBuilder/buildNestedComponentProp")
local buildLazyNestedComponentProp = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiCoreSystem/SduiCoreSystem/ClientBinding/PropBuilder/buildLazyNestedComponentProp")

local buildLazyNestedComponentListProp = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiCoreSystem/SduiCoreSystem/ClientBinding/PropBuilder/buildLazyNestedComponentListProp")
local buildNestedComponentListProp = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiCoreSystem/SduiCoreSystem/ClientBinding/PropBuilder/buildNestedComponentListProp")
local buildActionProp = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiCoreSystem/SduiCoreSystem/ClientBinding/PropBuilder/buildActionProp")
local SduiParsers = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiCoreSystem/SduiCoreSystem/SduiParsers")
require("@game/CorePackages/Workspace/Packages/_Workspace/SduiCoreSystem/SduiCoreSystem/ClientBinding/SduiClientBindingTypes")
local SduiClientBindingParsers = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiCoreSystem/SduiCoreSystem/ClientBinding/PropBuilder/SduiClientBindingParsers")
local ProtoVariableMapper = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiCoreSystem/SduiCoreSystem/ClientBinding/ProtoVariableMapper")

local fFlagSduiMarketplaceCatalogCategorySupport = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiCoreSystem/SharedFlags").FFlagSduiMarketplaceCatalogCategorySupport
local fFlagSduiMarketplaceCatalogSortSupport = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiCoreSystem/SharedFlags").FFlagSduiMarketplaceCatalogSortSupport
local fFlagSduiCatalogItemCard = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiCoreSystem/SharedFlags").FFlagSduiCatalogItemCard
local fFlagSduiSheetComponent = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiCoreSystem/SharedFlags").FFlagSduiSheetComponent
local fFlagSduiSystemBannerComponent = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiCoreSystem/SharedFlags").FFlagSduiSystemBannerComponent
local fFlagSduiBannerContextComponent = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiCoreSystem/SharedFlags").FFlagSduiBannerContextComponent
local fFlagLuaAppSduiHomePageSupport = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiCoreSystem/SharedFlags").FFlagLuaAppSduiHomePageSupport
local fFlagSduiExperimentalComponent = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiCoreSystem/SharedFlags").FFlagSduiExperimentalComponent
local fFlagSduiListComponents = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiCoreSystem/SharedFlags").FFlagSduiListComponents

local function applyParser(callback, p2)
	return function(p3, p4, p5, p6, p7, p8)
		local v5, v6 = callback(p3, p4, p5, p6, p7, p8, p2)

		return v5, v6
	end
end

local function createEngineEnumProtoBuilder(p2, p3)
	local v5 = buildDefaultProp
	local function fn(p4)
		local engineEnumParser = SduiParsers.getEngineEnumParser(p2)
		return ProtoVariableMapper.mapProtoEngineEnumToLua(p4, p3, engineEnumParser)
	end

	return function(p4, p5, p6, p7, p8, p9)
		local v6, v7 = v5(p4, p5, p6, p7, p8, p9, fn)

		return v6, v7
	end
end

local v5 = {}
v5.StringProp = buildStringProp
v5.BoolProp = buildDefaultProp
v5.FloatProp = buildDefaultProp
v5.DoubleProp = buildDefaultProp
v5.Int32Prop = buildDefaultProp
v5.Int64Prop = buildDefaultProp
local parseStruct = SduiClientBindingParsers.parseStruct

function v5.StructProp(p2, p3, p4, p5, p6, p7)
	local v6, v7 = buildDefaultProp(p2, p3, p4, p5, p6, p7, parseStruct)

	return v6, v7
end
local parseImageStringProp_ = SduiParsers.parseImageStringProp_

function v5.ImageStringProp(p2, p3, p4, p5, p6, p7)
	local v6, v7 = buildStringProp(p2, p3, p4, p5, p6, p7, parseImageStringProp_)

	return v6, v7
end
local parseImageSetOrImageProp_ = SduiParsers.parseImageSetOrImageProp_

function v5.ImageSetProp(p2, p3, p4, p5, p6, p7)
	local v6, v7 = buildStringProp(p2, p3, p4, p5, p6, p7, parseImageSetOrImageProp_)

	return v6, v7
end
local parseColorPropLegacy = SduiClientBindingParsers.parseColorPropLegacy

function v5.ColorProp(p2, p3, p4, p5, p6, p7)
	local v6, v7 = buildDefaultProp(p2, p3, p4, p5, p6, p7, parseColorPropLegacy)

	return v6, v7
end
local parseColor3 = SduiClientBindingParsers.parseColor3

function v5.Color3Prop(p2, p3, p4, p5, p6, p7)
	local v6, v7 = buildDefaultProp(p2, p3, p4, p5, p6, p7, parseColor3)

	return v6, v7
end
v5.TypographyProp = buildDefaultProp
v5.TypographyFontProp = buildDefaultProp
local parseUDim = SduiClientBindingParsers.parseUDim

function v5.UDimProp(p2, p3, p4, p5, p6, p7)
	local v6, v7 = buildDefaultProp(p2, p3, p4, p5, p6, p7, parseUDim)

	return v6, v7
end
local parseUDim2 = SduiClientBindingParsers.parseUDim2

function v5.UDim2Prop(p2, p3, p4, p5, p6, p7)
	local v6, v7 = buildDefaultProp(p2, p3, p4, p5, p6, p7, parseUDim2)

	return v6, v7
end
local parseVector2Prop_ = SduiParsers.parseVector2Prop_

function v5.Vector2Prop(p2, p3, p4, p5, p6, p7)
	local v6, v7 = buildDefaultProp(p2, p3, p4, p5, p6, p7, parseVector2Prop_)

	return v6, v7
end
v5.NestedComponentProp = buildNestedComponentProp
v5.LazyNestedComponentProp = buildLazyNestedComponentProp
v5.NestedComponentListProp = buildNestedComponentListProp
v5.LazyNestedComponentListProp = buildLazyNestedComponentListProp
local parseStringArray = SduiClientBindingParsers.parseStringArray

function v5.StringArrayProp(p2, p3, p4, p5, p6, p7)
	local v6, v7 = buildDefaultProp(p2, p3, p4, p5, p6, p7, parseStringArray)

	return v6, v7
end
local parseIconProp_ = SduiParsers.parseIconProp_

function v5.IconProp(p2, p3, p4, p5, p6, p7)
	local v6, v7 = buildDefaultProp(p2, p3, p4, p5, p6, p7, parseIconProp_)

	return v6, v7
end
local parseGradient = SduiClientBindingParsers.parseGradient

function v5.GradientProp(p2, p3, p4, p5, p6, p7)
	local v6, v7 = buildDefaultProp(p2, p3, p4, p5, p6, p7, parseGradient)

	return v6, v7
end
local parseArrayOfStruct = SduiClientBindingParsers.parseArrayOfStruct

function v5.ArrayOfStructProp(p2, p3, p4, p5, p6, p7)
	local v6, v7 = buildDefaultProp(p2, p3, p4, p5, p6, p7, parseArrayOfStruct)

	return v6, v7
end
v5.ArrayOfFloatProp = if fFlagSduiSheetComponent then buildRepeatedProp else nil
local fn

if fFlagLuaAppSduiHomePageSupport then
	local parsePymkItems = SduiClientBindingParsers.parsePymkItems

	fn = function(p2, p3, p4, p5, p6, p7)
		local v7, v8 = buildDefaultProp(p2, p3, p4, p5, p6, p7, parsePymkItems)

		return v7, v8
	end
end

v5.ArrayOfPymkItemDataProp = fn

v5.ActionProp = buildActionProp
v5.TableProp = buildTableProp

v5.ContainerProp = buildContainerProp
v5.ArrayOfMenuItemProp = buildRepeatedProp
v5.MenuItemProp = buildTableProp
v5.MenuItem = buildTableProp
v5.GenericShareLinkData = buildTableProp
v5.ShareLinkFetchData = buildTableProp
v5.ExperienceShareLinkPayload = buildTableProp
v5.EventShareLinkPayload = buildTableProp
v5.MediaGallerySchema_MediaItemArrayProp = buildRepeatedProp
v5.ArrayOfSystemBannerActionsProp = if fFlagSduiSystemBannerComponent then buildRepeatedProp else nil
v5.SystemBannerActionProp = if fFlagSduiSystemBannerComponent then buildTableProp else nil
v5.FoundationInternalNoticeLinkProp = if fFlagSduiBannerContextComponent then buildTableProp else nil
v5.FoundationInternalNoticeLink = if fFlagSduiBannerContextComponent then buildTableProp else nil
v5.FoundationIconConfigProp = buildTableProp
v5.HoldActionConfigProp = buildTableProp
v5.HoldActionConfig = buildTableProp
v5.OpenPurchasePromptAction_ProductPayload = buildTableProp
v5.OpenPurchasePromptAction_DisplayInfo = buildTableProp
v5.OpenPurchasePromptAction_PurchaseOptions = buildTableProp
v5.OpenPurchasePromptAction_PurchaseAnalyticsMetadata = buildTableProp

v5.ArrayOfCatalogCategoryMenuItemProp = if fFlagSduiMarketplaceCatalogCategorySupport then buildRepeatedProp else nil

v5.CatalogCategoryMenuItem = if fFlagSduiMarketplaceCatalogCategorySupport then buildTableProp else nil
v5.ArrayOfCategoryMenuButtonProp = if fFlagSduiMarketplaceCatalogCategorySupport then buildRepeatedProp else nil

v5.CategoryMenuButtonProp = if fFlagSduiMarketplaceCatalogCategorySupport then buildTableProp else nil
v5.CategoryMenuButton = if fFlagSduiMarketplaceCatalogCategorySupport then buildTableProp else nil
v5.ArrayOfCatalogCategoryMenuTooltipInfoProp = if fFlagSduiMarketplaceCatalogCategorySupport then buildRepeatedProp else nil

v5.CatalogCategoryMenuTooltipInfoProp = if fFlagSduiMarketplaceCatalogCategorySupport then buildTableProp else nil

v5.CatalogCategoryMenuTooltipInfo = if fFlagSduiMarketplaceCatalogCategorySupport then buildTableProp else nil

v5.ArrayOfTooltipInfoActionsProp = if fFlagSduiMarketplaceCatalogCategorySupport then buildRepeatedProp else nil

v5.TooltipInfoActionPropsProp = if fFlagSduiMarketplaceCatalogCategorySupport then buildTableProp else nil
v5.TooltipInfoActionProps = if fFlagSduiMarketplaceCatalogCategorySupport then buildTableProp else nil
v5.ArrayOfCatalogSortContentProp = if fFlagSduiMarketplaceCatalogSortSupport then buildRepeatedProp else nil
v5.ArrayOfItemFooterProp = if fFlagSduiMarketplaceCatalogSortSupport then buildRepeatedProp else nil
local v24 = if fFlagSduiMarketplaceCatalogSortSupport or fFlagSduiCatalogItemCard then buildTableProp else nil
v5.CardStyleProp = v24

v5.AnalyticsDataField = buildDefaultProp

local automaticSize = Enum.AutomaticSize
local v25 = "AUTOMATIC_SIZE_"
local function fn2(p2)
	local engineEnumParser = SduiParsers.getEngineEnumParser(automaticSize)
	return ProtoVariableMapper.mapProtoEngineEnumToLua(p2, v25, engineEnumParser)
end

function v5.AutomaticSizeProp(p2, p3, p4, p5, p6, p7)
	local v26, v27 = buildDefaultProp(p2, p3, p4, p5, p6, p7, fn2)

	return v26, v27
end
local textTruncate = Enum.TextTruncate
local v26 = "TEXT_TRUNCATE_"
local function fn3(p2)
	local engineEnumParser = SduiParsers.getEngineEnumParser(textTruncate)
	return ProtoVariableMapper.mapProtoEngineEnumToLua(p2, v26, engineEnumParser)
end

function v5.TextTruncateProp(p2, p3, p4, p5, p6, p7)
	local v27, v28 = buildDefaultProp(p2, p3, p4, p5, p6, p7, fn3)

	return v27, v28
end
local textXAlignment = Enum.TextXAlignment
local v27 = "TEXT_X_ALIGNMENT_"
local function fn4(p2)
	local engineEnumParser = SduiParsers.getEngineEnumParser(textXAlignment)
	return ProtoVariableMapper.mapProtoEngineEnumToLua(p2, v27, engineEnumParser)
end

function v5.TextXAlignmentProp(p2, p3, p4, p5, p6, p7)
	local v28, v29 = buildDefaultProp(p2, p3, p4, p5, p6, p7, fn4)

	return v28, v29
end
local textYAlignment = Enum.TextYAlignment
local v28 = "TEXT_Y_ALIGNMENT_"
local function fn5(p2)
	local engineEnumParser = SduiParsers.getEngineEnumParser(textYAlignment)
	return ProtoVariableMapper.mapProtoEngineEnumToLua(p2, v28, engineEnumParser)
end

function v5.TextYAlignmentProp(p2, p3, p4, p5, p6, p7)
	local v29, v30 = buildDefaultProp(p2, p3, p4, p5, p6, p7, fn5)

	return v29, v30
end
local uiFlexMode = Enum.UIFlexMode
local v29 = "UI_FLEX_MODE_"
local function fn6(p2)
	local engineEnumParser = SduiParsers.getEngineEnumParser(uiFlexMode)
	return ProtoVariableMapper.mapProtoEngineEnumToLua(p2, v29, engineEnumParser)
end

function v5.UIFlexModeProp(p2, p3, p4, p5, p6, p7)
	local v30, v31 = buildDefaultProp(p2, p3, p4, p5, p6, p7, fn6)

	return v30, v31
end
local scaleType = Enum.ScaleType
local v30 = "SCALE_TYPE_"
local function fn7(p2)
	local engineEnumParser = SduiParsers.getEngineEnumParser(scaleType)
	return ProtoVariableMapper.mapProtoEngineEnumToLua(p2, v30, engineEnumParser)
end

function v5.ScaleTypeProp(p2, p3, p4, p5, p6, p7)
	local v31, v32 = buildDefaultProp(p2, p3, p4, p5, p6, p7, fn7)

	return v31, v32
end
local resamplerMode = Enum.ResamplerMode
local v31 = "RESAMPLER_MODE_"
local function fn8(p2)
	local engineEnumParser = SduiParsers.getEngineEnumParser(resamplerMode)
	return ProtoVariableMapper.mapProtoEngineEnumToLua(p2, v31, engineEnumParser)
end

function v5.ResamplerModeProp(p2, p3, p4, p5, p6, p7)
	local v32, v33 = buildDefaultProp(p2, p3, p4, p5, p6, p7, fn8)

	return v32, v33
end
local sizeConstraint = Enum.SizeConstraint
local v32 = "SIZE_CONSTRAINT_"
local function fn9(p2)
	local engineEnumParser = SduiParsers.getEngineEnumParser(sizeConstraint)
	return ProtoVariableMapper.mapProtoEngineEnumToLua(p2, v32, engineEnumParser)
end

function v5.SizeConstraintProp(p2, p3, p4, p5, p6, p7)
	local v33, v34 = buildDefaultProp(p2, p3, p4, p5, p6, p7, fn9)

	return v33, v34
end
local selectionBehavior = Enum.SelectionBehavior
local v33 = "SELECTION_BEHAVIOR_"
local function fn10(p2)
	local engineEnumParser = SduiParsers.getEngineEnumParser(selectionBehavior)
	return ProtoVariableMapper.mapProtoEngineEnumToLua(p2, v33, engineEnumParser)
end

function v5.SelectionBehaviorProp(p2, p3, p4, p5, p6, p7)
	local v34, v35 = buildDefaultProp(p2, p3, p4, p5, p6, p7, fn10)

	return v34, v35
end
local keyCode = Enum.KeyCode
local v34 = "KEY_CODE_"
local function fn11(p2)
	local engineEnumParser = SduiParsers.getEngineEnumParser(keyCode)
	return ProtoVariableMapper.mapProtoEngineEnumToLua(p2, v34, engineEnumParser)
end

function v5.KeyCodeProp(p2, p3, p4, p5, p6, p7)
	local v35, v36 = buildDefaultProp(p2, p3, p4, p5, p6, p7, fn11)

	return v35, v36
end
local parseFocusNavActions = SduiClientBindingParsers.parseFocusNavActions

function v5.FocusNavActionsProp(p2, p3, p4, p5, p6, p7)
	local v35, v36 = buildTableProp(p2, p3, p4, p5, p6, p7, parseFocusNavActions)

	return v35, v36
end
v5.ColorStyleProp = buildDefaultProp
local parseUiScaledUDim2 = SduiClientBindingParsers.parseUiScaledUDim2

function v5.UiScaledUDim2Prop(p2, p3, p4, p5, p6, p7)
	local v35, v36 = buildDefaultProp(p2, p3, p4, p5, p6, p7, parseUiScaledUDim2)

	return v35, v36
end
local parseUiScaledUDim = SduiClientBindingParsers.parseUiScaledUDim

function v5.UiScaledUDimProp(p2, p3, p4, p5, p6, p7)
	local v35, v36 = buildDefaultProp(p2, p3, p4, p5, p6, p7, parseUiScaledUDim)

	return v35, v36
end
local parseUiScaledNumber = SduiClientBindingParsers.parseUiScaledNumber

function v5.UiScaledFloatProp(p2, p3, p4, p5, p6, p7)
	local v35, v36 = buildDefaultProp(p2, p3, p4, p5, p6, p7, parseUiScaledNumber)

	return v35, v36
end

v5.FillBehaviorProp = buildDefaultProp
v5.InputSizeProp = buildDefaultProp
v5.ListItemInputControlProp = if fFlagSduiListComponents then buildTableProp else nil
v5.LaunchExperienceAction_ExperienceJoinData = buildTableProp
v5.AvatarConfigProp = buildTableProp
v5.ArrayOfAvatarProp = buildRepeatedProp

local function getPropBuilder(p2, p3)
	if not p2 then
		error("Failed to find prop builder -- missing propDescriptorName")
	end

	local propBuilder = v5[p2]

	if propBuilder then
		return propBuilder
	end

	if fFlagSduiExperimentalComponent and p3 then
		error(`No prop builder registered under the name '{p2}'`)
	end

	warn(`Could not find propBuilder for propDescriptorName {p2}. Using default.`)
	propBuilder = buildDefaultProp

	return propBuilder
end

return getPropBuilder
