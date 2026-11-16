local CorePackages = game:GetService("CorePackages")
local isTenFootInterface = require("@game/CorePackages/Workspace/Packages/AppCommonLib").isTenFootInterface
local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")
local LocalizationService = game:GetService("LocalizationService")

local module = require("@luauforge/bundled/dCn")

local retrievalStatus = require("@game/CorePackages/Workspace/Packages/Http").Enum.RetrievalStatus
local getSafeAreaSize = require("@luauforge/bundled/fuE").getSafeAreaSize
local Cryo = require(CorePackages.Packages.Cryo)
local Dash = require(CorePackages.Packages.Dash)
local tutils = require(CorePackages.Packages.tutils)
local t = require(CorePackages.Packages.t)
local UIBlox = require(CorePackages.Packages.UIBlox)
local Foundation = require(CorePackages.Packages.Foundation)
local getTextSize = require("@game/CorePackages/Workspace/Packages/Style").GetTextSize
local foundationFontFaceMigration = Foundation.Utility.Flags.FoundationFontFaceMigration
local TextService = game:GetService("TextService")
local localization = require("@game/CorePackages/Workspace/Packages/RobloxAppLocales").Localization

local itemTileEnums = UIBlox.Tile.ItemTileEnums

require("@game/CorePackages/Workspace/Packages/AvatarExperienceCatalog")
local avatarScreen = require("@game/CorePackages/Workspace/Packages/AvatarExperienceNavigation").Enums.AvatarScreen
local AvatarExperienceFlags = require("@game/CorePackages/Workspace/Packages/AvatarExperienceFlags")
local selectors = require("@game/CorePackages/Workspace/Packages/_Workspace/RobloxAppToastsRodux/NavigationRodux").Selectors

local module3 = require("@luauforge/bundled/dOj")
local module4 = require("@luauforge/bundled/dMx")
local recommendationsType = require("@luauforge/bundled/dMd").Enums.RecommendationsType

local module5 = require("@luauforge/bundled/dPF")
local module6 = require("@luauforge/bundled/dME")
local module7 = require("@luauforge/bundled/dwA")
local memoize = require("@game/CorePackages/Workspace/Packages/AppCommonLib").memoize

local avatarScreenProperties = require("@game/CorePackages/Workspace/Packages/AvatarExperienceNavigation").AvatarRoute.AvatarScreenProperties
local deviceOrientationMode = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePromptLite/RobloxAppEnums").DeviceOrientationMode
local module8 = require("@luauforge/bundled/dOi")
local module9 = require("@luauforge/bundled/dMq")
local module10 = require("@luauforge/bundled/dMp")
local module11 = require("@luauforge/bundled/dMo")
require("@luauforge/bundled/dHL")
require("@luauforge/bundled/dHK")
local fFlagUseNavigationSelectors = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagUseNavigationSelectors

local fFlagSignalsNavP3gAvatarExperience = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagSignalsNavP3gAvatarExperience
local getLegacyNavigationStore = require("@game/CorePackages/Workspace/Packages/_Workspace/RobloxAppToastsRodux/NavigationRodux").GetLegacyNavigationStore
local Signals = require(CorePackages.Packages.Signals)
local createComputed = Signals.createComputed
local module12 = require("@luauforge/bundled/dMB")
local module13 = require("@luauforge/bundled/fuG")

local module14 = require("@luauforge/bundled/fuJ")

local module15 = require("@luauforge/bundled/fuL")
local module16 = require("@luauforge/bundled/dRQ")
require("@luauforge/bundled/dTN")
require("@luauforge/bundled/dSt")
local inventoryItemAvailability = require("@luauforge/bundled/fuM").Enums.InventoryItemAvailability

local module17 = require("@luauforge/bundled/dOo")
require("@luauforge/bundled/dMc")
local AvatarExperienceCommon = require("@game/CorePackages/Workspace/Packages/AvatarExperienceCommon")
local fullView = AvatarExperienceCommon.Enums.FullView
local switchTab = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePromptLite/RobloxAppEnums").SwitchTab
local tenFootInterface = isTenFootInterface()

local defineFastString = game:DefineFastString(
	"AXLookWidgetContentType",
	"SearchToLooksWidget,SearchToCommunityLooksWidget,SearchToAvatarLooksWidget,PersonalizedAvatarLooksWidget,SortsPersonalizedAvatarLooksWidget,MySharedAvatarsWidget"
)

local defineFastString2 = game:DefineFastString(
	"AXAvatarWidgetContentType",
	"SearchToAvatarLooksWidget,PersonalizedAvatarLooksWidget,SortsPersonalizedAvatarLooksWidget,MySharedAvatarsWidget"
)

local defineFastString3 = game:DefineFastString("AXTallBundleWidgetContentType", "AdvancedBodiesWidget")
local fFlagAXTallTilesForAdvancedBodiesWidget = AvatarExperienceFlags.FFlagAXTallTilesForAdvancedBodiesWidget

local fFlagAXSlotsInventoryLoadableGridView = require("@game/CorePackages/Workspace/Packages/AvatarExperienceFlags").FFlagAXSlotsInventoryLoadableGridView

local defineFastFlag = game:DefineFastFlag("AXFixMinMaxPriceFilterError", false)
local module19 = require("@luauforge/bundled/dOr")

local module20 = require("@luauforge/bundled/dOs")
local fFlagAXMigrateAllTabToSduiDev = AvatarExperienceFlags.FFlagAXMigrateAllTabToSduiDev
local fFlagAXRemoveTimedOptionsSalesTypeEnumCheck = AvatarExperienceFlags.FFlagAXRemoveTimedOptionsSalesTypeEnumCheck
local fFlagAXEditorSubcategoryFilters = AvatarExperienceFlags.FFlagAXEditorSubcategoryFilters
local SharedFlags = require("@game/CorePackages/Workspace/Packages/SharedFlags")
local fFlagAvatarJointUpgradeInUA = SharedFlags.FFlagAvatarJointUpgradeInUA
local fFlagAXFavoritesManagerSdui = SharedFlags.FFlagAXFavoritesManagerSdui
local fFlagEnableSplitPane = SharedFlags.FFlagEnableSplitPane

local v5 = if fFlagEnableSplitPane then require("@luauforge/bundled/fuN") else nil

local fFlagAXAddHDCatalogTab = AvatarExperienceFlags.FFlagAXAddHDCatalogTab
local fFlagAXCatalogSpecialFeaturesFilter = AvatarExperienceFlags.FFlagAXCatalogSpecialFeaturesFilter
local fFlagAXAvatarTabLooksYouMayAlsoLike = AvatarExperienceFlags.FFlagAXAvatarTabLooksYouMayAlsoLike
local fFlagAXOutfitPageRevamp = AvatarExperienceFlags.FFlagAXOutfitPageRevamp

local module22 = require("@luauforge/bundled/dPG")

local getFavoritesSelectedCameraCategoryInfo = require("@luauforge/bundled/dPP").System.getFavoritesSelectedCameraCategoryInfo

local v6 = fFlagAXTallTilesForAdvancedBodiesWidget and {} or nil

local v7 = string.split(defineFastString, ",") or {}
local mapped = Cryo.List.map(v7, function(value)
	return value:match("^%s*(.*)%s*$")
end)

local v8 = string.split(defineFastString2, ",") or {}
local mapped2 = Cryo.List.map(v8, function(value)
	return value:match("^%s*(.*)%s*$")
end)

if fFlagAXTallTilesForAdvancedBodiesWidget then
	local v9 = string.split(defineFastString3, ",") or {}
	v6 = Cryo.List.map(v9, function(value)
		return value:match("^%s*(.*)%s*$")
	end)
end

local v9 = {
	PageType = module4.PageType.Other,
	RecommendationsType = recommendationsType.None
}
local v10

if fFlagAXFavoritesManagerSdui then
	v10 = createComputed(function(p2)
		local selectedCameraCategoryInfo = getFavoritesSelectedCameraCategoryInfo.selectedCameraCategoryInfo(p2)

		if selectedCameraCategoryInfo == nil then
			return v9
		end

		return {
			PageType = module4.PageType.Other,
			RecommendationsType = recommendationsType.None,
			CameraFocus = selectedCameraCategoryInfo.CameraFocus,
			CameraZoomRadius = selectedCameraCategoryInfo.CameraZoomRadius,
			CanAnimateCameraBasedMood = selectedCameraCategoryInfo.CanAnimateCameraBasedMood
		}
	end)
else
	v10 = nil
end

local v11 = {
	PageType = module4.PageType.Other,
	RecommendationsType = recommendationsType.None,
	CanAnimateCameraBasedMood = true
}

local v12 = {}

local v13 = {}
local v14 = {}

local v15 = memoize(function(p2, p3, p4)
	local v16 = p2[p3]
	local v17 = v16.Subcategories and p4 and v16.Subcategories[p4]

	if v17 then
		local joined = Cryo.Dictionary.join(v16, v17)

		joined.AssetTypeIdStrings = v17.AssetTypeIdStrings
		joined.BundleTypes = v17.BundleTypes

		joined.CategoryFilter = v17.CategoryFilter

		joined.Subcategories = v17.Subcategories
		return joined
	elseif v16.PageType == module4.PageType.Emotes then
		return Cryo.Dictionary.join(v16, { EmoteSlot = p4 })
	else
		return v16
	end
end)

local v16 = memoize(function(p2, p3, p4)
	local categoryById = module16.extractCategoryById(p3, p2)

	if fFlagAXMigrateAllTabToSduiDev and categoryById == nil then
		return nil
	end

	if categoryById == nil then
		module("[buildCategoryInfoById] Category not found for categoryId: " .. tostring(p3) .. " and subcategoryId: " .. tostring(p4))
	end

	if categoryById.Subcategories and p4 then
		local subcategories = categoryById.Subcategories
		local subcategoryById = module16.extractSubcategoryById(p4, subcategories)

		if subcategoryById then
			local joined = Cryo.Dictionary.join(categoryById, subcategoryById)

			joined.AssetTypeIdStrings = subcategoryById.AssetTypeIdStrings
			joined.BundleTypes = subcategoryById.BundleTypes
			joined.CategoryFilter = subcategoryById.CategoryFilter

			joined.Subcategories = subcategoryById.Subcategories

			joined.SubcategoriesMap = subcategoryById.SubcategoriesMap

			return joined
		end
	end

	if categoryById.PageType == module4.PageType.Emotes then
		return Cryo.Dictionary.join(categoryById, { EmoteSlot = p4 })
	end

	return categoryById
end)

local function categoryKey(p2, p3, p4)
	return string.format("%s.%s.%s", tostring(p2), tostring(p3), (tostring(p4)))
end

local function categoryKeyV2(p2, p3, p4)
	return string.format("%s.%s.%s", tostring(p2), tostring(p3), (tostring(p4)))
end

v12.getCategoryInfo = memoize(function(p2, p3, p4)
	local v17 = string.format("%s.%s.%s", tostring(p2), tostring(p3), (tostring(p4)))

	local v18 = v13[v17]

	if v18 == nil then
		v18 = v15(p2, p3, p4)
		v13[v17] = v18
	end

	return v18
end)

v12.getCategoryInfoById = memoize(function(p2, p3, p4)
	local v17 = string.format("%s.%s.%s", tostring(p2), tostring(p3), (tostring(p4)))

	local v18 = v14[v17]

	if v18 == nil then
		v18 = v16(p2, p3, p4)
		v14[v17] = v18
	end

	return v18
end)

v12.getCatalogCategoryInfo = memoize(function(p2, p3)
	local v17 = module5()
	return v12.getCategoryInfo(v17, p2, p3)
end)

local function getCatalogCategoryInfoById(p2, p3)
	local v17 = module5()
	return v12.getCategoryInfoById(v17, p2, p3)
end

if not fFlagAXMigrateAllTabToSduiDev then
	getCatalogCategoryInfoById = memoize(function(p2, p3)
		local v17 = module5()
		return v12.getCategoryInfoById(v17, p2, p3)
	end)
end

v12.getCatalogCategoryInfoById = getCatalogCategoryInfoById

v12.getAvatarEditorCategoryInfo = memoize(function(p2, p3)
	local v17 = module3()

	return (v12.getCategoryInfo(v17, p2, p3))
end)

local function getCatalogCardFooterHeight(p2): number
	if p2 < 100 then
		return 30
	end

	if p2 < 148 then
		return 36
	end

	return 42
end

local v17 = memoize(function(p2, p3, p4)
	local v18 = if p4 then module4.CreatorNameItemTileTitleMaxLines else module4.ItemTileTitleMaxLines

	local v19 = if p4 then module4.CreatorNameItemTilePadding else module4.ItemTilePadding

	return function(p5)
		local v20 = v18 * p2
		local v21 = v19 * 2
		local v22 = p5 < 100 and 30 or p5 < 148 and 36 or 42

		if p4 then
			v22 *= 2
		end

		return p5 + v20 + v21 + v22
	end
end)

local v18 = memoize(function(p2, p3, p4)
	local v19 = if p4 then module4.CreatorNameItemTileTitleMaxLines else module4.ItemTileTitleMaxLines

	local v20 = if p4 then module4.CreatorNameItemTilePadding else module4.ItemTilePadding
	return function(p5)
		local v21 = p5 / module4.ItemTileTallAspectRatio
		local v22 = v19 * p2
		local v23 = v20 * 2
		local v24 = p5 < 100 and 30 or p5 < 148 and 36 or 42

		if p4 then
			v24 *= 2
		end

		return v21 + v22 + v23 + v24
	end
end)

function v12.isLooksWidget(p2): boolean
	return table.find(mapped, p2) ~= nil
end

function v12.isTallBundleWidget(p2): boolean
	if fFlagAXTallTilesForAdvancedBodiesWidget then
		return table.find(v6, p2) ~= nil
	end

	return false
end

function v12.isAvatarLooksWidget(p2)
	return v12.isLooksWidget(p2) and table.find(mapped2, p2) ~= nil
end

local v19 = memoize(function(p2, p3, p4, p5, p6)
	return function(p7)
		local v20 = p7 / module4.LookTileAspectRatio
		local v21 = p4 or p5

		if p6 then
			if v21 then
				v20 += 30
			end
		else
			v20 += 30
		end

		if v21 then
			v20 += 4
		end

		if p4 then
			v20 += p2
		end

		if p5 then
			if p4 then
				v20 += 4
			end

			v20 += p2
		end

		return v20
	end
end)

local v20 = memoize(function(p2)
	return function(p3)
		local v21 = module4.ItemTileTitleMaxLines * p2
		local itemTilePadding = module4.ItemTilePadding
		return p3 + v21 + itemTilePadding
	end
end)

local function squareItemHeightGetter(p2)
	return p2
end

local v21 = memoize(function(p2)
	if p2 == nil then
		return squareItemHeightGetter
	end

	return function(p3)
		local v22

		if fFlagAXSlotsInventoryLoadableGridView then
			v22 = module4.EditorItemTileTitleMaxLines * p2
		else
			v22 = module4.ItemTileTitleMaxLines * p2
		end

		local itemTilePadding = module4.ItemTilePadding

		return p3 + v22 + itemTilePadding
	end
end)

local function splitKeywords(value)
	if value then
		return string.split(value, " ")
	end

	return {}
end

function v12.mergeKeywordsAndTopics(value, value2)
	local v22 = not value and {} or string.split(value, " ")

	for k, v23 in not value2 and {} or string.split(value2, " ") do
		if not (#v23 > 0) or table.find(v22, v23) then
			continue
		end

		table.insert(v22, v23)
	end

	return table.concat(v22, " ")
end

v12.GetAvatarEditorCategoryIdsFromNavKey = memoize(function(p2)
	local v22 = module3()

	for k, v23 in v22 do
		if v23.NavigationKey == p2 then
			return k, nil, nil
		end

		if not v23.Subcategories then
			continue
		end

		for k2, subcategory in v23.Subcategories do
			if subcategory.NavigationKey == p2 then
				return k, k2, nil
			end

			if not (fFlagAXEditorSubcategoryFilters and subcategory.SubcategoryFilters) then
				continue
			end

			for k3, subcategoryFilter in subcategory.SubcategoryFilters do
				if subcategoryFilter.NavigationKey == p2 then
					return k, k2, k3
				end
			end
		end
	end

	return nil, nil, nil
end)

function v12.GridItemHeightGetter(p2, ...)
	if p2 == module4.ItemTileType.AvatarEditorTile then
		return v21(...)
	end

	if p2 == module4.ItemTileType.BodyColorButton then
		return squareItemHeightGetter
	end

	if p2 == module4.ItemTileType.BundleItemTile then
		return v20(...)
	end

	if p2 == module4.ItemTileType.BundleItemTileNoText then
		return squareItemHeightGetter
	end

	if p2 == module4.ItemTileType.LookItemTile then
		return v19(...)
	end

	if p2 == module4.ItemTileType.CatalogItemTile then
		return v17(...)
	end

	if p2 == module4.ItemTileType.TallCatalogItemTile then
		return v18(...)
	end

	warn("Unknown itemType " .. tostring(p2) .. " in AvatarExperienceUtils.GridItemHeightGetter")
	return squareItemHeightGetter
end

function v12.GridItemHeightGetterWithOptions(data)
	local itemTileType = data.itemTileType

	if itemTileType == module4.ItemTileType.AvatarEditorTile then
		return v21(data.fontHeight)
	end

	if itemTileType == module4.ItemTileType.BodyColorButton then
		return squareItemHeightGetter
	end

	if itemTileType == module4.ItemTileType.BundleItemTile and data.fontHeight then
		return v20(data.fontHeight)
	end

	if itemTileType == module4.ItemTileType.BundleItemTileNoText then
		return squareItemHeightGetter
	end

	if itemTileType == module4.ItemTileType.LookItemTile and data.fontHeight then
		return v19(
			data.fontHeight,
			data.hideItemName,
			data.itemCreatorNamesEnabled,
			data.itemPriceEnabled,
			data.isWidgetFocused
		)
	end

	if itemTileType == module4.ItemTileType.CatalogItemTile then
		return v17(data.fontHeight, nil, data.itemCreatorNamesEnabled)
	end

	if itemTileType == module4.ItemTileType.TallCatalogItemTile then
		return v18(data.fontHeight, nil, data.itemCreatorNamesEnabled)
	end

	warn("Unknown itemType " .. tostring(itemTileType) .. " in AvatarExperienceUtils.GridItemHeightGetterWithOptions")
	return squareItemHeightGetter
end

function v12.isAvatarBackground(p2): boolean
	return p2 == avatarScreen.AvatarBackground
end

function v12.isAvatarExperienceRoute(p2): boolean
	local v22

	if fFlagUseNavigationSelectors then
		v22 = selectors.selectCurrentLegacyRoute(p2)
	else
		v22 = p2.Navigation.history[#p2.Navigation.history]
	end

	for k, v23 in v22 do
		if v23.name == avatarScreen.AvatarExperienceRoot or v23.name == switchTab.AvatarExperienceTab then
			return true
		end
	end

	return false
end

local isAvatarExperienceRoute

if fFlagSignalsNavP3gAvatarExperience then
	isAvatarExperienceRoute = createComputed(function(p2): boolean
		local currentLegacyRoute = getLegacyNavigationStore(false).getCurrentLegacyRoute(p2)

		for k, v22 in currentLegacyRoute do
			if
				v22.name == avatarScreen.AvatarExperienceRoot
				or v22.name == switchTab.AvatarExperienceTab
			then
				return true
			end
		end

		return false
	end)
else
	isAvatarExperienceRoute = nil
end

function v12.getIsAvatarExperienceRoute()
	return isAvatarExperienceRoute
end

function v12.isRouteInAvatarEditor(p2): boolean
	return p2.opaque.name == avatarScreen.AvatarEditor
end

function v12.didLeaveAvatarEditor(p2, p3): boolean
	if v12.isRouteInAvatarEditor(p3) and not v12.isRouteInAvatarEditor(p2) then
		return true
	end

	return false
end

function v12.getIsSceneFullViewFromState(p2, p3): boolean
	local name = p3.opaque.name
	return p2.AvatarExperience.Common.FullView[name] == fullView.SceneFullView
end

function v12.getAvatarEditorCategoryInfoFromState(p2)
	local category = p2.AvatarExperience.AvatarEditor.Categories.category
	local subcategory = p2.AvatarExperience.AvatarEditor.Categories.subcategory
	return v12.getAvatarEditorCategoryInfo(category, subcategory)
end

function v12.getAvatarEditorSubcategoryFilterFromState(p2)
	local avatarEditorCategoryInfoFromState = v12.getAvatarEditorCategoryInfoFromState(p2)

	if not avatarEditorCategoryInfoFromState.SubcategoryFilters then
		return nil
	end

	local subcategoryFilter = p2.AvatarExperience.AvatarEditor.Categories.subcategoryFilter
	return avatarEditorCategoryInfoFromState.SubcategoryFilters[subcategoryFilter]
end

function v12.getSelectedAccessoryDescription(instance, p2)
	local v22 = tonumber(p2) or 0

	for i, accessoryDescription in instance:GetChildren() do
		if accessoryDescription:IsA("AccessoryDescription") and accessoryDescription.AssetId == v22 then
			return accessoryDescription
		end
	end

	return nil
end

function v12.getAccessoryAdjustmentCategoryInfo(p2)
	local selectedAccessory = p2.AvatarExperience.AccessoryAdjustment.SelectedAccessory or ""
	local currentCharacter = p2.AvatarExperience.AvatarScene.Character.CurrentCharacter
	assert(currentCharacter, "assert currentCharacter exists")
	local humanoid = currentCharacter:FindFirstChild("Humanoid")
	assert(humanoid, "assert humanoid exists")
	local humanoidDescription = humanoid:FindFirstChild("HumanoidDescription")
	assert(humanoidDescription, "assert currentCharacter exists")

	local selectedAccessoryDescription = v12.getSelectedAccessoryDescription(
		humanoidDescription,
		selectedAccessory
	)

	if not selectedAccessoryDescription then
		return
	end

	assert(selectedAccessoryDescription, "assert accessoryDescription exists")
	return module13.CameraCategories[selectedAccessoryDescription.AccessoryType]
end

function v12.getCategoryInfoFromState(p2, p3)
	local name = p3.opaque.name

	if name == avatarScreen.AvatarEditor then
		return v12.getAvatarEditorCategoryInfoFromState(p2)
	end

	if name == avatarScreen.Catalog then
		return (module22.getCatalogSelectionStore().selectedCategoryInfo(false))
	end

	if name == avatarScreen.CatalogSearch then
		return module22.getCatalogSearchSelectionStore().selectedCategoryInfo(false)
	end

	if name == avatarScreen.ProfilePictureEditorEmotes then
		if module19() then
			return module17()
		end

		local v22 = module8().AssetTypeToCategorySubcategory[module4.AssetTypeIdStrings.EmoteAnimation]
		local category = v22.category
		local subcategory = v22.subcategory
		return v12.getAvatarEditorCategoryInfo(category, subcategory)
	elseif name == avatarScreen.AdjustAccessoryView then
		local accessoryAdjustmentCategoryInfo = v12.getAccessoryAdjustmentCategoryInfo(p2)

		if accessoryAdjustmentCategoryInfo then
			return accessoryAdjustmentCategoryInfo
		end

		return v9
	else
		if module12.readTestVariable(module14.EnabledForUser) and name == avatarScreen.CatalogSearch then
			return v11
		end

		if name == avatarScreen.HeadRefinement then
			return module4.HeadRefinementCameraCategory
		end

		if name == avatarScreen.LayeredMakeupSort then
			return module4.LayeredMakeupCameraCategory
		end

		if fFlagAXFavoritesManagerSdui and name == avatarScreen.FavoritesSaved then
			return v10(false)
		end

		return v9
	end
end

local v22 = { "Torso", "RightArm", "LeftArm", "LeftLeg", "RightLeg" }

function v12.routeIsProfilePictureEditor(p2): boolean
	return p2.opaque.name == avatarScreen.ProfilePictureEditorEmotes
		or p2.opaque.name == avatarScreen.ProfilePictureEditorCamera
		or p2.opaque.name == avatarScreen.ProfilePictureEditorFinal
end

function v12.routeIsPPEStaticImagePage(p2): boolean
	return p2.opaque.name == avatarScreen.ProfilePictureEditorCamera
		or p2.opaque.name == avatarScreen.ProfilePictureEditorFinal
end

function v12.isFullyQualifiedCostume(p2): boolean
	for k, v23 in v22 do
		if p2[v23] == "" or p2[v23] == 0 then
			return false
		end
	end

	return true
end

function v12.shouldShowGradientForScrollingFrame(data): (boolean, boolean, boolean)
	local absoluteSize = data.AbsoluteSize
	local canvasSize = data.CanvasSize
	local canvasPosition = data.CanvasPosition

	return
		absoluteSize.X < canvasSize.X.Offset,
		canvasPosition.X > 20,
		canvasPosition.X + absoluteSize.X < canvasSize.X.Offset - 20
end

function v12.Round(p2, value)
	local v23 = value or 1
	return math.floor((p2 + v23 / 2) / v23) * v23
end

function v12.isFetchingDoneOrFailed(p2, p3)
	local v23 = p2 == retrievalStatus.Done or p2 == retrievalStatus.Failed
	local v24 = p3 == retrievalStatus.Done or p3 == retrievalStatus.Failed
	return not v23 and v24
end

function v12.getDeviceType()
	local platform = UserInputService:GetPlatform()

	if platform == Enum.Platform.Android then
		return module4.DeviceType.Android
	end

	if platform == Enum.Platform.IOS then
		return module4.DeviceType.IOS
	end

	return module4.DeviceType.Other
end

function v12.getUserOutfitIdFromBundle(p2)
	for k, item in p2.items do
		if item.type == module4.ItemType.Outfit then
			return item.id
		end
	end

	return nil
end

function v12.getUserOutfitIdsFromBundle(p2)
	local ids = {}

	if p2.items then
		for k, item in p2.items do
			if item.type == module4.ItemType.Outfit then
				table.insert(ids, item.id)
			end
		end
	end

	return ids
end

v12.getBundleInfo = memoize(function(p2, p3)
	if p3 == nil then
		return nil
	end

	local v23 = p2[p3]

	if not v23 then
		return nil
	end

	if v23.receivedCatalogData then
		return v23
	end

	return nil
end)

function v12.getBundleInfoFromState(p2, p3)
	local bundleInfos = p2.AvatarExperience.Common.BundleInfos
	return v12.getBundleInfo(bundleInfos, p3)
end

function v12.getOutfitInfoFromBundleIdNoState(p2, p3)
	if not p2 then
		return nil
	end

	assert(p2, "contentId is not nil: silences type checker")
	local userOutfitIdsFromBundle = v12.getUserOutfitIdsFromBundle(p2)

	if #userOutfitIdsFromBundle < 1 then
		return nil
	end

	local copy = nil

	for k, v23 in userOutfitIdsFromBundle do
		local v24 = p3[v23]

		if not v24 then
			return nil
		end

		if copy then
			copy.assets = Cryo.Dictionary.join(copy.assets, v24.assets)
		else
			copy = tutils.deepCopy(v24)
		end
	end

	return copy
end

function v12.getOutfitInfoFromBundleId(p2, p3)
	local bundleInfoFromState = v12.getBundleInfoFromState(p2, p3)
	local outfitInfos = p2.AvatarExperience.AvatarEditor.OutfitInfos

	return v12.getOutfitInfoFromBundleIdNoState(bundleInfoFromState, outfitInfos)
end

function v12.getAllCategoriesStr(p2)
	local v23 = 1
	local allCategoriesStr = ""

	while true do
		local v24 = "level" .. v23

		if not p2[v24] then
			return allCategoriesStr
		end

		if v23 ~= 1 then
			allCategoriesStr ..= "|"
		end

		allCategoriesStr ..= p2[v24]

		v23 += 1
	end
end

function v12.isAnimationAssetType(p2): boolean
	return p2 == module4.AssetTypeIdStrings.ClimbAnimation
		or p2 == module4.AssetTypeIdStrings.FallAnimation
		or p2 == module4.AssetTypeIdStrings.IdleAnimation
		or p2 == module4.AssetTypeIdStrings.JumpAnimation
		or p2 == module4.AssetTypeIdStrings.RunAnimation
		or p2 == module4.AssetTypeIdStrings.SwimAnimation
		or p2 == module4.AssetTypeIdStrings.WalkAnimation
end

function v12.getNumElementsWithKeyField(items)
	local count = 0

	if items then
		for k, item in items do
			if typeof(item) == "table" and item.key then
				count += 1
			end
		end
	end

	return count
end

function v12.lerp(p2, p3, p4)
	return (p3 - p2) * p4 + p2
end

function v12.getTopBarHeightAvatarScene(p2)
	if not p2.TopBar then
		return 0
	end

	if tenFootInterface then
		return 96
	end

	if p2.DeviceOrientation == deviceOrientationMode.Landscape then
		return p2.TopBar.statusBarHeight + module7.NAV_BAR_SIZE
	end

	return p2.TopBar.topBarHeight
end

function v12.tableToCamelCaseKeys(items)
	local result = {}

	for k, item in items do
		if typeof(k) == "string" then
			k = string.lower((string.sub(k, 1, 1))) .. string.sub(k, 2)
		end

		if typeof(item) == "table" then
			item = v12.tableToCamelCaseKeys(item)
		end

		result[k] = item
	end

	return result
end

function v12.AssetTypeIdStringToEnumValue(p2)
	local v23 = module4.AssetTypeIdStringToName[p2]
	return Enum.AvatarAssetType[v23]
end

function v12.bundleIdToEnum(p2)
	local v23 = module4.BundleTypeIdStringToName[p2]
	return Enum.BundleType[v23]
end

function v12.getSearchKey(p2, p3)
	local sortAndFiltersKey = module15.selectSortAndFiltersKey(p2)
	return module4.SearchCatalogKey .. p3 .. "." .. sortAndFiltersKey
end

local function fn(p2)
	assert(t.strictInterface({
		searchUuid = t.union(t.number, t.string),
		searchKeyword = t.optional(t.string),
		recordSearchTime = t.optional(t.boolean),
		categoryInfo = t.optional(t.table),
		minPrice = t.optional(t.number),
		maxPrice = t.optional(t.number),
		catalogSort = t.optional(t.string),
		categoryFilter = t.optional(t.enum(Enum.CatalogCategoryFilter)),
		topics = t.optional(t.array(t.string))
	})(p2))
end

local function fn2(data)
	local strictInterface = t.strictInterface
	local v23 = {
		CatalogSort = t.optional(t.string),
		CatalogSortAggregation = t.optional(t.string),
		PriceRange = t.strictInterface({ maxPrice = t.number, minPrice = t.number }),
		SelectedTopics = t.optional(t.array(t.string)),
		SalesTypeFilter = t.optional(t.string),
		CreatorFilter = t.optional(t.string),
		UnavailableItemFilter = t.optional(t.string),
		WearTimeFilter = t.optional(t.string),
		SpecialFeaturesFilter = 0
	}
	local v24 = if fFlagAXCatalogSpecialFeaturesFilter then t.optional(t.array(t.string)) else nil
	v23.SpecialFeaturesFilter = v24
	assert(strictInterface(v23)(data))
end

local function fn3(catalogSearchParams, list, list2)
	if list ~= nil and #list > 0 then
		catalogSearchParams.AssetTypes = Cryo.List.map(list, function(p2)
			return v12.AssetTypeIdStringToEnumValue(p2)
		end)
	end

	if list2 ~= nil and #list2 > 0 then
		catalogSearchParams.BundleTypes = Cryo.List.map(list2, function(p2)
			return v12.bundleIdToEnum(p2)
		end)
	end
end

local function hasSortOrFilters(data)
	return data.SortType ~= Enum.CatalogSortType.Relevance
		or (data.CreatorName ~= "" or (data.SalesTypeFilter ~= Enum.SalesTypeFilter.All or (data.SearchKeyword ~= "" or (data.MinPrice > module6.MinPriceFilter or (data.MaxPrice < module6.MaxPriceFilter or data.IncludeOffSale)))))
end

function v12.getSearchParamsAsQueryParams(data, p2)
	local searchParamsAsQueryParams = {}

	searchParamsAsQueryParams.keyword = data.SearchKeyword or ""

	searchParamsAsQueryParams.limit = data.Limit

	if fFlagAXAddHDCatalogTab then
		if
			p2
			and p2.CategoryFilter
			and (module6.CategoryFilters[p2.CategoryFilter] == nil or data.CategoryFilter ~= Enum.CatalogCategoryFilter.None)
		then
			searchParamsAsQueryParams.categoryFilter = p2.CategoryFilter
		end
	elseif
		data.CategoryFilter ~= Enum.CatalogCategoryFilter.None
		and data.SortType == Enum.CatalogSortType.Relevance
		and data.CreatorName == ""
		and data.SalesTypeFilter == Enum.SalesTypeFilter.All
		and data.SearchKeyword == ""
		and not (data.MinPrice > module6.MinPriceFilter or data.MaxPrice < module6.MaxPriceFilter)
		and not data.IncludeOffSale
	then
		searchParamsAsQueryParams.categoryFilter = tostring(data.CategoryFilter.Name)
	end

	searchParamsAsQueryParams.sortType = module6.SortTypeAPIMap[tostring(data.SortType.Name)]

	if data.CreatorName and data.CreatorName ~= "" then
		searchParamsAsQueryParams.creatorName = data.CreatorName
	end

	if p2 and p2.TaxonomyUuid then
		searchParamsAsQueryParams.taxonomy = tostring(p2.TaxonomyUuid)
	else
		if data.BundleTypes and #data.BundleTypes > 0 then
			local v23 = {}

			for k, bundleType in data.BundleTypes do
				table.insert(v23, bundleType.Value)
			end

			searchParamsAsQueryParams.bundleTypeIds = v23
		end

		if data.AssetTypes and #data.AssetTypes > 0 then
			local v23 = {}

			for k, assetType in data.AssetTypes do
				table.insert(v23, assetType.Value)
			end

			searchParamsAsQueryParams.assetTypeIds = v23
		end
	end

	searchParamsAsQueryParams.includeNotForSale = data.IncludeOffSale

	searchParamsAsQueryParams.creatorType = "All"

	if data.MinPrice and data.MinPrice > module6.MinPriceFilter then
		searchParamsAsQueryParams.minPrice = data.MinPrice
	end

	if data.MaxPrice and data.MaxPrice < module6.MaxPriceFilter then
		searchParamsAsQueryParams.maxPrice = data.MaxPrice
	end

	if data.SalesTypeFilter and data.SalesTypeFilter ~= Enum.SalesTypeFilter.All then
		searchParamsAsQueryParams.salesTypeFilter = tostring(data.SalesTypeFilter.Name)
	end

	if
		data.SortAggregation
		and (data.SortType == Enum.CatalogSortType.MostFavorited or data.SortType == Enum.CatalogSortType.Bestselling)
	then
		searchParamsAsQueryParams.sortAggregation = tostring(data.SortAggregation.Name)
	end

	return searchParamsAsQueryParams
end

function v12.getSearchParams(p2, data, p3)
	fn(p2)
	fn2(data)
	local catalogSearchParams = CatalogSearchParams.new()

	local v23 = if p2.searchKeyword then p2.searchKeyword else nil

	catalogSearchParams.AssetTypes = {}
	catalogSearchParams.BundleTypes = {}
	catalogSearchParams.IncludeOffSale = false

	local selectedTopics = data.SelectedTopics
	local v24

	if selectedTopics and #selectedTopics > 0 then
		v24 = true
		local joined = table.concat(selectedTopics, " ")

		if v23 == nil then
			v23 = joined
		else
			if #v23 > 0 then
				v23 ..= " "
			end

			v23 ..= joined
		end
	else
		v24 = false
	end

	if v23 then
		catalogSearchParams.SearchKeyword = v23
	end

	catalogSearchParams.Limit = (v23 or not p3) and 120 or 30

	if p2.categoryInfo == nil then
		catalogSearchParams.CategoryFilter = Enum.CatalogCategoryFilter.None
		fn3(catalogSearchParams, {}, {})
	else
		local categoryFilter = p2.categoryInfo.CategoryFilter
		local categoryFilter2 = module6.CategoryFilters[categoryFilter]

		if categoryFilter2 == nil or v24 then
			catalogSearchParams.CategoryFilter = Enum.CatalogCategoryFilter.None
		else
			catalogSearchParams.CategoryFilter = categoryFilter2
		end

		fn3(catalogSearchParams, p2.categoryInfo.AssetTypeIdStrings, p2.categoryInfo.BundleTypes)
	end

	local v25 = data.PriceRange.minPrice
	local v26 = data.PriceRange.maxPrice

	if defineFastFlag and v25 and v26 and v26 < v25 then
		v26, v25 = v25, v26
	end

	if module6.MinPriceFilter < v25 then
		catalogSearchParams.MinPrice = v25
	end

	if v26 < module6.MaxPriceFilter then
		catalogSearchParams.MaxPrice = v26
	end

	local catalogSort = data.CatalogSort
	catalogSearchParams.SortType = Enum.CatalogSortType[catalogSort]

	if data.UnavailableItemFilter ~= module11.Hide then
		catalogSearchParams.IncludeOffSale = true
	end

	local salesTypeFilter = data.SalesTypeFilter

	if salesTypeFilter ~= module10.All then
		if fFlagAXRemoveTimedOptionsSalesTypeEnumCheck then
			catalogSearchParams.SalesTypeFilter = Enum.SalesTypeFilter[salesTypeFilter]
		else
			local v27 = pcall(function()
				local timedOptions = Enum.SalesTypeFilter.TimedOptions
			end)

			if salesTypeFilter == module10.TimedOptions and not v27 then
				module("Referenced TimeOptions sales type but enum value is not present")
			else
				catalogSearchParams.SalesTypeFilter = Enum.SalesTypeFilter[salesTypeFilter]
			end
		end
	end

	local creatorFilter = data.CreatorFilter

	if creatorFilter ~= nil and creatorFilter ~= "" then
		catalogSearchParams.CreatorName = creatorFilter
	end

	if catalogSort == module9.MostFavorited or catalogSort == module9.Bestselling then
		catalogSearchParams.SortAggregation = Enum.CatalogSortAggregation[data.CatalogSortAggregation]
	end

	if
		catalogSearchParams.SortType ~= Enum.CatalogSortType.Relevance
		or catalogSearchParams.CreatorName ~= ""
		or catalogSearchParams.SalesTypeFilter ~= Enum.SalesTypeFilter.All
		or catalogSearchParams.SearchKeyword ~= ""
		or catalogSearchParams.MinPrice > module6.MinPriceFilter
		or catalogSearchParams.MaxPrice < module6.MaxPriceFilter
		or catalogSearchParams.IncludeOffSale
	then
		catalogSearchParams.CategoryFilter = Enum.CatalogCategoryFilter.None
	end

	if fFlagAXCatalogSpecialFeaturesFilter then
		local specialFeaturesFilter = data.SpecialFeaturesFilter

		if specialFeaturesFilter and #specialFeaturesFilter > 0 then
			catalogSearchParams.CategoryFilter = Enum.CatalogCategoryFilter.None
		end
	end

	return catalogSearchParams
end

function v12.getWebAssetModelFromEquippedAssets(items)
	local webAssetModel = {}

	for k, item in items do
		local v23 = module4.LayeredAssetTypes[k] ~= nil

		for k2, v24 in item do
			table.insert(webAssetModel, {
				id = k2,
				meta = v23 and v24 or nil
			})
		end
	end

	return webAssetModel
end

function v12.createHumanoidDescriptionAccessoryInfo(p2, p3, data)
	if fFlagAXOutfitPageRevamp then
		return AvatarExperienceCommon.Utils.createHumanoidDescriptionAccessoryInfo(p2, p3, data)
	end

	local v23 = tonumber(p3)
	assert(v23 ~= nil, "assetIdAsNumber is not nil. Silence type checker.")
	return {
		AssetId = v23,
		Order = data.order,
		AccessoryType = data.type or module4.AssetTypeIdToAccessoryTypeEnum[p2],
		IsLayered = data.isLayered,
		Position = data.position,
		Rotation = data.rotation,
		Scale = data.scale
	}
end

function v12.createDefaultHumanoidDescriptionAccessoryInfo(p2, p3)
	local v23 = tonumber(p3)

	if v23 == nil then
		module("Called AvatarExperienceUtils.createDefaultHumanoidDescriptionAccessoryInfo with assetId that does not convert to string.")
		v23 = 0
	end

	assert(v23, "assetIdAsNumber is non-nil: Silence type checker")
	return {
		AssetId = v23,
		Order = module4.LayeredClothingOrder[p2],
		AccessoryType = module4.AssetTypeIdToAccessoryTypeEnum[p2],
		IsLayered = module4.LayeredAssetTypes[p2] ~= nil
	}
end

function v12.getNewFullViewEnum(p2)
	if p2 == fullView.None then
		return fullView.UIFullView
	end

	return fullView.None
end

function v12.getPartCFrame(instance, childName)
	if instance and instance:FindFirstChild(childName) then
		return instance[childName].CFrame
	end

	return CFrame.new(module4.DefaultRigPosition)
end

function v12.getAttachmentCFrame(instance, childName, childName2)
	if not (instance and instance:FindFirstChild(childName)) then
		return nil
	end

	local folder = instance[childName]

	local v23 = if not fFlagAvatarJointUpgradeInUA then folder:FindFirstChild(childName2) else nil

	if fFlagAvatarJointUpgradeInUA then
		for i, attachment in folder:GetDescendants() do
			if attachment:IsA("Attachment") and attachment.Name == childName2 then
				v23 = attachment
				break
			end
		end
	end

	if v23 then
		if fFlagAvatarJointUpgradeInUA then
			return v23.WorldCFrame
		end

		return folder.CFrame * v23.CFrame
	end

	return nil
end

function v12.getRecursiveAttachmentCFrame(instance)
	local cframe = instance.CFrame
	local parent = instance.Parent

	while parent and parent:IsA("Bone") do
		cframe = parent.CFrame * cframe
		parent = parent.Parent
	end

	return cframe
end

function v12.isLCCategory(p2): boolean
	if p2 and p2.AssetTypeIdStrings then
		for k, assetTypeIdString in p2.AssetTypeIdStrings do
			if module4.LayeredAssetTypes[assetTypeIdString] ~= nil then
				return module4.LayeredAssetTypes[assetTypeIdString] ~= Enum.AccessoryType.Hair
			end
		end
	end

	return false
end

function v12.isBundleOrLCAsset(p2, p3)
	local v23 = p2 == module4.ItemType.Bundle
	return p2 == module4.ItemType.Asset and module4.LayeredAssetTypes[p3] ~= nil or v23
end

function v12.isBoundingBoxVectorSane(data): boolean
	return data.X <= 50000
		and data.X >= -50000
		and data.Y <= 50000
		and data.Y >= -50000
		and data.Z <= 50000
		and data.Z >= -50000
end

function v12.isBoundingBoxCFrameSane(p2)
	return v12.isBoundingBoxVectorSane(p2.Position) and v12.isBoundingBoxVectorSane(p2.LookVector)
end

function v12.getAssetIdsWithGeometryFromHumanoidDescription(object)
	if object == nil then
		return {}
	end

	local accessories = object:GetAccessories(true)
	local result = {}

	for k, accessory in accessories do
		if accessory.AssetId then
			table.insert(result, accessory.AssetId)
		end
	end

	if object.Torso then
		table.insert(result, object.Torso)
	end

	if object.RightLeg then
		table.insert(result, object.RightLeg)
	end

	if object.RightArm then
		table.insert(result, object.RightArm)
	end

	if object.LeftLeg then
		table.insert(result, object.LeftLeg)
	end

	if object.LeftArm then
		table.insert(result, object.LeftArm)
	end

	if object.Head then
		table.insert(result, object.Head)
	end

	return result
end

function v12.calculateNewAssetIdsWithGeometry(p2, p3)
	if not (p2 and p3) then
		return {}
	end

	local assetIdsWithGeometryFromHumanoidDescription = v12.getAssetIdsWithGeometryFromHumanoidDescription(p2)
	local assetIdsWithGeometryFromHumanoidDescription2 = v12.getAssetIdsWithGeometryFromHumanoidDescription(p3)

	local set = Cryo.List.toSet(assetIdsWithGeometryFromHumanoidDescription)

	return (Cryo.List.filter(assetIdsWithGeometryFromHumanoidDescription2, function(p4): boolean
		return set[p4] == nil
	end))
end

function v12.getItemIconTypeFromOutfit(p2)
	local v23 = p2.outfitType == module4.OutfitTypes.DynamicHead
	local containsDynamicHead = p2.containsDynamicHead

	if v23 or containsDynamicHead then
		return itemTileEnums.ItemIconType.DynamicHead
	end

	return nil
end

function v12.getItemStatusStyleFromOutfit(p2)
	local moderationStatus = p2.moderationStatus

	if moderationStatus == Enum.ModerationStatus.ReviewedRejected then
		return itemTileEnums.StatusStyle.AlertIcon
	end

	if moderationStatus == Enum.ModerationStatus.NotReviewed then
		return itemTileEnums.StatusStyle.PendingIcon
	end

	return nil
end

function v12.isModerationPendingOrRejected(p2): boolean
	return p2 == Enum.ModerationStatus.NotReviewed or p2 == Enum.ModerationStatus.ReviewedRejected
end

function v12.getMessageTypeFromModerationStatus(p2): nil | string
	if not p2 then
		return nil
	end

	if p2 == Enum.ModerationStatus.NotReviewed then
		return "UnavailableItems"
	end

	if p2 == Enum.ModerationStatus.ReviewedRejected then
		return "ItemDidNotMeetRobloxCommunityStandards"
	end

	return nil
end

function v12.getModerationStatusFromAvailabilityStatus(p2)
	if not p2 then
		return nil
	end

	return ({
		[inventoryItemAvailability.Invalid] = Enum.ModerationStatus.Invalid,
		[inventoryItemAvailability.Available] = Enum.ModerationStatus.ReviewedApproved,
		[inventoryItemAvailability.Unavailable] = Enum.ModerationStatus.ReviewedRejected,
		[inventoryItemAvailability.Revoked] = Enum.ModerationStatus.NotApplicable,
		[inventoryItemAvailability.PartiallyAvailableWithUnavailableSubitems] = Enum.ModerationStatus.NotApplicable,
		[inventoryItemAvailability.PartiallyAvailableWithExpiredSubitems] = Enum.ModerationStatus.NotApplicable,
		[inventoryItemAvailability.Expired] = Enum.ModerationStatus.NotApplicable,
		[inventoryItemAvailability.PendingReview] = Enum.ModerationStatus.NotReviewed
	})[p2]
end

function v12.assetTypeIdIsAnimationOrEmote(p2): boolean
	if p2 then
		return module4.AssetTypeIdToCategory[p2] == module4.AssetCategories.Animation
	end

	return false
end

local v23 = memoize(function(p2)
	local v24 = p2 and p2[module4.AssetTypeIdStrings.MoodAnimation]
	return v24 and next(v24)
end)

function v12.getEquippedMoodAssetId(p2)
	return v23(p2.AvatarExperience.AvatarEditor.Character.EquippedAssets)
end

function v12.getAssetIdForPPEPose(p2)
	local avatarExperience = p2.AvatarExperience

	for k, tryOnItem in p2.AvatarExperience.AvatarScene.OutfitTryOn.TryOnItems do
		if
			tryOnItem.itemType == module4.ItemType.Asset
			and v12.assetTypeIdIsAnimationOrEmote(tryOnItem.itemSubType)
		then
			return tryOnItem.itemId
		end
	end

	if avatarExperience.ProfilePictureEditor.ProfilePictureParams.emoteAssetId then
		return avatarExperience.ProfilePictureEditor.ProfilePictureParams.emoteAssetId
	end

	return nil
end

local v24 = memoize(function(p2)
	return p2 and p2[module4.AssetTypeIdStrings.Gear] and next(p2[module4.AssetTypeIdStrings.Gear])
end)

function v12.getEquippedToolId(p2)
	return v24(p2.AvatarExperience.AvatarEditor.Character.EquippedAssets)
end

function v12.getNextPageCursorKey(p2, p3, value)
	if p3 then
		return p2 .. (value or "")
	end

	return p2
end

function v12.getPerformFetchKey(p2, p3, value)
	if p3 then
		return module4.OutfitsKey .. p2 .. (value or "")
	end

	return module4.UserInventoryKey .. p2
end

function v12.getCurrentScreenIgnoreItemDetails(p2)
	local name = p2.current.name

	if
		name == avatarScreen.ItemDetails
		or name == avatarScreen.LookDetails
		or name == avatarScreen.OutfitDetails
	then
		name = p2.opaque.name
	end

	return name
end

function v12.getLargestPossibleOneLineTextSize(p2, p3, p4, p5)
	local v25 = p5 - 1

	local vector2 = Vector2.new(v25, 100000)

	while p3 > 1 do
		local v26

		if foundationFontFaceMigration then
			v26 = getTextSize(p2, p3, p4.Font, vector2, { addTemporaryPadding = false })
		else
			v26 = TextService:GetTextSize(p2, p3, p4.Font, vector2)
		end

		if v26.Y <= p3 + 1 then
			return Vector2.new(math.ceil(v26.X), (math.ceil(v26.Y))), p3
		end

		p3 -= 1
	end

	return nil, nil
end

function v12.selectSceneSize(data)
	local globalGuiInset = data.GlobalGuiInset
	local v25 = data.DeviceOrientation == deviceOrientationMode.Portrait
	local screenSize = data.ScreenSize

	local offset = getSafeAreaSize(screenSize, globalGuiInset).Y.Offset
	local bottom = globalGuiInset.bottom

	local v26 = screenSize.Y - bottom
	local v27 = offset * module4.PortraitSceneHeight
	v26 = v25 and v27 or v26
	local x = screenSize.X
	local v28 = if fFlagEnableSplitPane then v5.getLandscapeSceneWidth() else module4.LandscapeSceneWidth
	local v29 = x * v28
	v29 = v25 and screenSize.X or v29

	return v26, v29
end

v12.getColor3Difference = memoize(function(data, data2)
	return (math.sqrt((data.R - data2.R) * (data.R - data2.R) + (data.G - data2.G) * (data.G - data2.G) + (data.B - data2.B) * (data.B - data2.B)))
end)

v12.bodyColorToBodyColor3 = memoize(function(p2)
	if p2 then
		return BrickColor.new(p2).Color
	end

	return nil
end)

v12.bodyPartForSkinColoringIdToBodyColorId = {
	headColor3 = "headColorId",
	torsoColor3 = "torsoColorId",
	rightArmColor3 = "rightArmColorId",
	rightLegColor3 = "rightLegColorId",
	leftArmColor3 = "leftArmColorId",
	leftLegColor3 = "leftLegColorId"
}

v12.bodyColorIdToBodyPartForSkinColoringId = {}

for k, bodyColorId in pairs(v12.bodyPartForSkinColoringIdToBodyColorId) do
	v12.bodyColorIdToBodyPartForSkinColoringId[bodyColorId] = k
end

v12.convertBodyColor3sToHexes = memoize(function(items)
	local result = {}

	for k, item in pairs(items) do
		result[k] = item:ToHex()
	end

	return result
end)

v12.convertBodyColor3HexesToColor3s = memoize(function(items)
	local colors = {}

	for k, item in pairs(items) do
		colors[k] = Color3.fromHex(item)
	end

	return colors
end)

function v12.isAvatarSceneButtonsVisible(p2, p3, p4, p5, p6)
	local v25 = (avatarScreenProperties[p2.opaque.name] or {}).refinementButtonVisible and not p4 and not p5

	if p6 then
		return v25 and p6.state.key == p2.opaque.key
	end

	return v25 and p3
end

function v12.isUserCameraEligible(): boolean
	local VideoCaptureService = game:GetService("VideoCaptureService")
	local cameraDevices = VideoCaptureService:GetCameraDevices()
	local empty = Cryo.isEmpty(cameraDevices)
	assert(Players ~= nil, "Players should always be defined")

	return not (empty or tenFootInterface)
end

function v12.getUserId(p2)
	if p2.LocalUserId then
		return p2.LocalUserId
	end

	if p2.RobloxUser and p2.RobloxUser.rbxuid then
		return (tostring(p2.RobloxUser.rbxuid))
	end

	return nil
end

function v12.isItemSelectable(p2): boolean
	if p2 == nil then
		return false
	end

	local noPriceStatus = p2.noPriceStatus

	if noPriceStatus == nil or noPriceStatus == "Free" then
		return true
	end

	if noPriceStatus == "Unavailable" then
		return false
	end

	return p2.quantityOwned > 0
end

function v12.isTryingOnClassicFace(p2)
	return Dash.some(p2, function(p3): boolean
		return p3.itemType == "Asset" and p3.itemSubType == module4.AssetTypeIdStrings.Face
	end)
end

function v12.isTryingOnDynamicHead(p2)
	return Dash.some(p2, function(p3): boolean
		return p3.itemType == "Bundle" and p3.itemSubType == module4.BundleTypeIdStrings.DynamicHead
	end)
end

v12.getRecommendedAssetTypeIdStringFromCategoryInfo = memoize(function(p2)
	if p2.RecommendedAssetTypeIdString then
		return p2.RecommendedAssetTypeIdString
	end

	if p2.AssetTypeIdStrings and #p2.AssetTypeIdStrings == 1 then
		return p2.AssetTypeIdStrings[1]
	end

	return nil
end)

v12.getRecommendedKey = memoize(function(p2)
	if p2.RecommendationsType == recommendationsType.Asset then
		local recommendedAssetTypeIdStringFromCategoryInfo = v12.getRecommendedAssetTypeIdStringFromCategoryInfo(p2)

		if recommendedAssetTypeIdStringFromCategoryInfo then
			return recommendedAssetTypeIdStringFromCategoryInfo
		end

		module("called getRecommendedKey with a category with no assetTypeIdString")

		return module4.AssetTypeIdStrings.Hat
	end

	if p2.RecommendationsType == recommendationsType.BodyParts then
		return recommendationsType.BodyParts
	end

	if
		fFlagAXAvatarTabLooksYouMayAlsoLike
		and p2.RecommendationsType == recommendationsType.AvatarLooks
	then
		return recommendationsType.AvatarLooks
	end

	if p2.RecommendationsType == recommendationsType.AvatarAnimations then
		return recommendationsType.AvatarAnimations
	end

	if p2.RecommendationsType == recommendationsType.Shoes then
		return recommendationsType.Shoes
	end

	if p2.RecommendationsType == recommendationsType.DynamicHeads then
		return recommendationsType.DynamicHeads
	end

	if module20() and p2.RecommendationsType == recommendationsType.All then
		return recommendationsType.All
	end

	return recommendationsType.None
end)

v12.getCategoryInfoByName = memoize(function(items, p2, p3)
	local v25 = nil
	local v26 = nil

	for k, item in items do
		if item.Name == p2 then
			if p3 and item.Subcategories then
				v26 = k

				for k2, subcategory in item.Subcategories do
					if subcategory.Name == p3 then
						v25 = k2
						break
					end
				end

				assert(v25 ~= nil, "Could not find subcategory with name " .. p3)
			else
				v26 = k
			end

			break
		end
	end

	assert(v26 ~= nil, "Could not find category with name  " .. p2)

	return (v12.getCategoryInfo(items, v26, v25))
end)

v12.getAssetIdFromContent = memoize(function(value)
	if value == nil then
		return nil
	end

	assert(value, "contentId is not nil: silences type checker")

	local v25 = string.match(value, ".*?id=([0-9]+)")

	if v25 then
		return v25
	end

	return string.match(value, "rbxassetid://([0-9]+)")
end)

v12.sortOutfitTryOnItemsByRecency = memoize(function(items, p2)
	local result = {}

	for k, item in items do
		table.insert(result, item)
	end

	table.sort(result, function(a, b): boolean
		if a.itemRecency and b.itemRecency then
			if p2 then
				return a.itemRecency > b.itemRecency
			end

			return a.itemRecency < b.itemRecency
		end

		return false
	end)

	return result
end)

function v12.fuzzyEq(p2, p3, value): boolean
	return (value or 0.001) > math.abs(p2 - p3)
end

function v12.getCreatorNameTileFooterEnabled(p2)
	return p2 and p2.customizedDataMap and p2.customizedDataMap.creatorNameTileFooterEnabled == "true"
end

function v12.translateString(p2, p3)
	local robloxLocaleId = LocalizationService.RobloxLocaleId
	local v25 = localization.new(robloxLocaleId)
	v25:SetLocale(robloxLocaleId)

	local success, result = pcall(function()
		return v25:Format(p2, p3)
	end)

	if success then
		return result
	end

	module("Failed to translate string with key: " .. p2)
	return ""
end

function v12.resolveEditorCategory(p2)
	local v25 = module3()

	for k, v26 in v25 do
		if v26.Id == p2 then
			return v26.Category, nil
		end

		if not v26.Subcategories then
			continue
		end

		for k2, subcategory in v26.Subcategories do
			if subcategory.Id == p2 then
				return v26.Category, subcategory.Subcategory
			end
		end
	end

	return nil, nil
end

function v12.resolveHumanoidRigType(p2)
	if p2 == module4.AvatarType.R6 then
		return Enum.HumanoidRigType.R6
	end

	if p2 == module4.AvatarType.R15 then
		return Enum.HumanoidRigType.R15
	end

	return nil
end

return v12
