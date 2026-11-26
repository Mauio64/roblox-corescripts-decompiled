local CorePackages = game:GetService("CorePackages")
local isTenFootInterface = require("@game/CorePackages/Workspace/Packages/AppCommonLib").isTenFootInterface
local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")
local LocalizationService = game:GetService("LocalizationService")

local module = require("@luauforge/bundled/dFs")

local retrievalStatus = require("@game/CorePackages/Workspace/Packages/Http").Enum.RetrievalStatus
local getSafeAreaSize = require("@luauforge/bundled/fCf").getSafeAreaSize
local Cryo = require(CorePackages.Packages.Cryo)
local Dash = require(CorePackages.Packages.Dash)
local tutils = require(CorePackages.Packages.tutils)
local t = require(CorePackages.Packages.t)
local UIBlox = require(CorePackages.Packages.UIBlox)
local getTextSize = require("@game/CorePackages/Workspace/Packages/Style").GetTextSize
local localization = require("@game/CorePackages/Workspace/Packages/RobloxAppLocales").Localization

local itemTileEnums = UIBlox.Tile.ItemTileEnums

require("@game/CorePackages/Workspace/Packages/AvatarExperienceCatalog")
local avatarScreen = require("@game/CorePackages/Workspace/Packages/AvatarExperienceNavigation").Enums.AvatarScreen
local AvatarExperienceFlags = require("@game/CorePackages/Workspace/Packages/AvatarExperienceFlags")
local selectors = require("@game/CorePackages/Workspace/Packages/_Workspace/RobloxAppToastsRodux/NavigationRodux").Selectors

local module3 = require("@luauforge/bundled/dRz")
local module4 = require("@luauforge/bundled/dPN")
local module5 = require("@luauforge/bundled/dPt")
local recommendationsType = module5.Enums.RecommendationsType
local focusType = module5.Enums.FocusType
local cameraZoomRadius = module5.Constants.CameraZoomRadius

local module6 = require("@luauforge/bundled/dSV")
local module7 = require("@luauforge/bundled/dPU")
local module8 = require("@luauforge/bundled/dzD")
local memoize = require("@game/CorePackages/Workspace/Packages/AppCommonLib").memoize

local avatarScreenProperties = require("@game/CorePackages/Workspace/Packages/AvatarExperienceNavigation").AvatarRoute.AvatarScreenProperties
local deviceOrientationMode = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePromptLite/RobloxAppEnums").DeviceOrientationMode
local module9 = require("@luauforge/bundled/dRy")
local module10 = require("@luauforge/bundled/dPG")
local module11 = require("@luauforge/bundled/dPF")
local module12 = require("@luauforge/bundled/dPE")
require("@luauforge/bundled/dKU")
require("@luauforge/bundled/dKT")
local fFlagUseNavigationSelectors = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagUseNavigationSelectors

local fFlagSignalsNavP3gAvatarExperience = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagSignalsNavP3gAvatarExperience
local getLegacyNavigationStore = require("@game/CorePackages/Workspace/Packages/_Workspace/RobloxAppToastsRodux/NavigationRodux").GetLegacyNavigationStore
local Signals = require(CorePackages.Packages.Signals)
local createComputed = Signals.createComputed
local module13 = require("@luauforge/bundled/dPR")
local module14 = require("@luauforge/bundled/fCh")

local module15 = require("@luauforge/bundled/fCk")

local module16 = require("@luauforge/bundled/fCm")
local module17 = require("@luauforge/bundled/dVl")
require("@luauforge/bundled/dXi")
require("@luauforge/bundled/dVO")
local inventoryItemAvailability = require("@luauforge/bundled/fCn").Enums.InventoryItemAvailability

local module18 = require("@luauforge/bundled/dRE")
require("@luauforge/bundled/dPs")
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
local module20 = require("@luauforge/bundled/dRH")

local module21 = require("@luauforge/bundled/dRI")
local fFlagAXMigrateAllTabToSduiDev = AvatarExperienceFlags.FFlagAXMigrateAllTabToSduiDev
local fFlagAXRemoveTimedOptionsSalesTypeEnumCheck = AvatarExperienceFlags.FFlagAXRemoveTimedOptionsSalesTypeEnumCheck
local fFlagAXEditorSubcategoryFilters = AvatarExperienceFlags.FFlagAXEditorSubcategoryFilters
local SharedFlags = require("@game/CorePackages/Workspace/Packages/SharedFlags")
local fFlagAvatarJointUpgradeInUA = SharedFlags.FFlagAvatarJointUpgradeInUA
local fFlagAXFavoritesManagerSdui = SharedFlags.FFlagAXFavoritesManagerSdui
local fFlagEnableSplitPane = SharedFlags.FFlagEnableSplitPane

local v5 = if fFlagEnableSplitPane then require("@luauforge/bundled/fCo") else nil

local fFlagAXAddHDCatalogTab = AvatarExperienceFlags.FFlagAXAddHDCatalogTab
local fFlagAXCatalogSpecialFeaturesFilter = AvatarExperienceFlags.FFlagAXCatalogSpecialFeaturesFilter
local fFlagAXAvatarTabLooksYouMayAlsoLike = AvatarExperienceFlags.FFlagAXAvatarTabLooksYouMayAlsoLike
local fFlagAXOutfitPageRevamp = AvatarExperienceFlags.FFlagAXOutfitPageRevamp
local fFlagAXPhotoboothMomentsPage = AvatarExperienceFlags.FFlagAXPhotoboothMomentsPage
local fFlagAXPhotoboothMomentsStableCamera = AvatarExperienceFlags.FFlagAXPhotoboothMomentsStableCamera

local module23 = require("@luauforge/bundled/dSW")

local getFavoritesSelectedCameraCategoryInfo = require("@luauforge/bundled/dTf").System.getFavoritesSelectedCameraCategoryInfo

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
	CameraFocus = focusType.Waist,
	CameraZoomRadius = cameraZoomRadius.Special.PhotoboothMoments
}

local v12 = {
	PageType = module4.PageType.Other,
	RecommendationsType = recommendationsType.None,
	CanAnimateCameraBasedMood = true
}

local v13 = {}

local v14 = {}
local v15 = {}

local v16 = memoize(function(p2, p3, p4)
	local v17 = p2[p3]
	local v18 = v17.Subcategories and p4 and v17.Subcategories[p4]

	if v18 then
		local joined = Cryo.Dictionary.join(v17, v18)

		joined.AssetTypeIdStrings = v18.AssetTypeIdStrings
		joined.BundleTypes = v18.BundleTypes

		joined.CategoryFilter = v18.CategoryFilter

		joined.Subcategories = v18.Subcategories
		return joined
	elseif v17.PageType == module4.PageType.Emotes then
		return Cryo.Dictionary.join(v17, { EmoteSlot = p4 })
	else
		return v17
	end
end)

local v17 = memoize(function(p2, p3, p4)
	local categoryById = module17.extractCategoryById(p3, p2)

	if fFlagAXMigrateAllTabToSduiDev and categoryById == nil then
		return nil
	end

	if categoryById == nil then
		module("[buildCategoryInfoById] Category not found for categoryId: " .. tostring(p3) .. " and subcategoryId: " .. tostring(p4))
	end

	if categoryById.Subcategories and p4 then
		local subcategories = categoryById.Subcategories
		local subcategoryById = module17.extractSubcategoryById(p4, subcategories)

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

v13.getCategoryInfo = memoize(function(p2, p3, p4)
	local v18 = string.format("%s.%s.%s", tostring(p2), tostring(p3), (tostring(p4)))

	local v19 = v14[v18]

	if v19 == nil then
		v19 = v16(p2, p3, p4)
		v14[v18] = v19
	end

	return v19
end)

v13.getCategoryInfoById = memoize(function(p2, p3, p4)
	local v18 = string.format("%s.%s.%s", tostring(p2), tostring(p3), (tostring(p4)))

	local v19 = v15[v18]

	if v19 == nil then
		v19 = v17(p2, p3, p4)
		v15[v18] = v19
	end

	return v19
end)

v13.getCatalogCategoryInfo = memoize(function(p2, p3)
	local v18 = module6()
	return v13.getCategoryInfo(v18, p2, p3)
end)

local function getCatalogCategoryInfoById(p2, p3)
	local v18 = module6()
	return v13.getCategoryInfoById(v18, p2, p3)
end

if not fFlagAXMigrateAllTabToSduiDev then
	getCatalogCategoryInfoById = memoize(function(p2, p3)
		local v18 = module6()
		return v13.getCategoryInfoById(v18, p2, p3)
	end)
end

v13.getCatalogCategoryInfoById = getCatalogCategoryInfoById

v13.getAvatarEditorCategoryInfo = memoize(function(p2, p3)
	local v18 = module3()

	return (v13.getCategoryInfo(v18, p2, p3))
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

local v18 = memoize(function(p2, p3, p4)
	local v19 = if p4 then module4.CreatorNameItemTileTitleMaxLines else module4.ItemTileTitleMaxLines

	local v20 = if p4 then module4.CreatorNameItemTilePadding else module4.ItemTilePadding

	return function(p5)
		local v21 = v19 * p2
		local v22 = v20 * 2
		local v23 = p5 < 100 and 30 or p5 < 148 and 36 or 42

		if p4 then
			v23 *= 2
		end

		return p5 + v21 + v22 + v23
	end
end)

local v19 = memoize(function(p2, p3, p4)
	local v20 = if p4 then module4.CreatorNameItemTileTitleMaxLines else module4.ItemTileTitleMaxLines

	local v21 = if p4 then module4.CreatorNameItemTilePadding else module4.ItemTilePadding
	return function(p5)
		local v22 = p5 / module4.ItemTileTallAspectRatio
		local v23 = v20 * p2
		local v24 = v21 * 2
		local v25 = p5 < 100 and 30 or p5 < 148 and 36 or 42

		if p4 then
			v25 *= 2
		end

		return v22 + v23 + v24 + v25
	end
end)

function v13.isLooksWidget(p2): boolean
	return table.find(mapped, p2) ~= nil
end

function v13.isTallBundleWidget(p2): boolean
	if fFlagAXTallTilesForAdvancedBodiesWidget then
		return table.find(v6, p2) ~= nil
	end

	return false
end

function v13.isAvatarLooksWidget(p2)
	return v13.isLooksWidget(p2) and table.find(mapped2, p2) ~= nil
end

local v20 = memoize(function(p2, p3, p4, p5, p6)
	return function(p7)
		local v21 = p7 / module4.LookTileAspectRatio
		local v22 = p4 or p5

		if p6 then
			if v22 then
				v21 += 30
			end
		else
			v21 += 30
		end

		if v22 then
			v21 += 4
		end

		if p4 then
			v21 += p2
		end

		if p5 then
			if p4 then
				v21 += 4
			end

			v21 += p2
		end

		return v21
	end
end)

local v21 = memoize(function(p2)
	return function(p3)
		local v22 = module4.ItemTileTitleMaxLines * p2
		local itemTilePadding = module4.ItemTilePadding
		return p3 + v22 + itemTilePadding
	end
end)

local function squareItemHeightGetter(p2)
	return p2
end

local v22 = memoize(function(p2)
	if p2 == nil then
		return squareItemHeightGetter
	end

	return function(p3)
		local v23

		if fFlagAXSlotsInventoryLoadableGridView then
			v23 = module4.EditorItemTileTitleMaxLines * p2
		else
			v23 = module4.ItemTileTitleMaxLines * p2
		end

		local itemTilePadding = module4.ItemTilePadding

		return p3 + v23 + itemTilePadding
	end
end)

local function splitKeywords(value)
	if value then
		return string.split(value, " ")
	end

	return {}
end

function v13.mergeKeywordsAndTopics(value, value2)
	local v23 = not value and {} or string.split(value, " ")

	for k, v24 in not value2 and {} or string.split(value2, " ") do
		if not (#v24 > 0) or table.find(v23, v24) then
			continue
		end

		table.insert(v23, v24)
	end

	return table.concat(v23, " ")
end

v13.GetAvatarEditorCategoryIdsFromNavKey = memoize(function(p2)
	local v23 = module3()

	for k, v24 in v23 do
		if v24.NavigationKey == p2 then
			return k, nil, nil
		end

		if not v24.Subcategories then
			continue
		end

		for k2, subcategory in v24.Subcategories do
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

function v13.GridItemHeightGetter(p2, ...)
	if p2 == module4.ItemTileType.AvatarEditorTile then
		return v22(...)
	end

	if p2 == module4.ItemTileType.BodyColorButton then
		return squareItemHeightGetter
	end

	if p2 == module4.ItemTileType.BundleItemTile then
		return v21(...)
	end

	if p2 == module4.ItemTileType.BundleItemTileNoText then
		return squareItemHeightGetter
	end

	if p2 == module4.ItemTileType.LookItemTile then
		return v20(...)
	end

	if p2 == module4.ItemTileType.CatalogItemTile then
		return v18(...)
	end

	if p2 == module4.ItemTileType.TallCatalogItemTile then
		return v19(...)
	end

	warn("Unknown itemType " .. tostring(p2) .. " in AvatarExperienceUtils.GridItemHeightGetter")
	return squareItemHeightGetter
end

function v13.GridItemHeightGetterWithOptions(data)
	local itemTileType = data.itemTileType

	if itemTileType == module4.ItemTileType.AvatarEditorTile then
		return v22(data.fontHeight)
	end

	if itemTileType == module4.ItemTileType.BodyColorButton then
		return squareItemHeightGetter
	end

	if itemTileType == module4.ItemTileType.BundleItemTile and data.fontHeight then
		return v21(data.fontHeight)
	end

	if itemTileType == module4.ItemTileType.BundleItemTileNoText then
		return squareItemHeightGetter
	end

	if itemTileType == module4.ItemTileType.LookItemTile and data.fontHeight then
		return v20(
			data.fontHeight,
			data.hideItemName,
			data.itemCreatorNamesEnabled,
			data.itemPriceEnabled,
			data.isWidgetFocused
		)
	end

	if itemTileType == module4.ItemTileType.CatalogItemTile then
		return v18(data.fontHeight, nil, data.itemCreatorNamesEnabled)
	end

	if itemTileType == module4.ItemTileType.TallCatalogItemTile then
		return v19(data.fontHeight, nil, data.itemCreatorNamesEnabled)
	end

	warn("Unknown itemType " .. tostring(itemTileType) .. " in AvatarExperienceUtils.GridItemHeightGetterWithOptions")
	return squareItemHeightGetter
end

function v13.isAvatarBackground(p2): boolean
	return p2 == avatarScreen.AvatarBackground
end

function v13.isAvatarExperienceRoute(p2): boolean
	local v23

	if fFlagUseNavigationSelectors then
		v23 = selectors.selectCurrentLegacyRoute(p2)
	else
		v23 = p2.Navigation.history[#p2.Navigation.history]
	end

	for k, v24 in v23 do
		if v24.name == avatarScreen.AvatarExperienceRoot or v24.name == switchTab.AvatarExperienceTab then
			return true
		end
	end

	return false
end

local isAvatarExperienceRoute

if fFlagSignalsNavP3gAvatarExperience then
	isAvatarExperienceRoute = createComputed(function(p2): boolean
		local currentLegacyRoute = getLegacyNavigationStore(false).getCurrentLegacyRoute(p2)

		for k, v23 in currentLegacyRoute do
			if
				v23.name == avatarScreen.AvatarExperienceRoot
				or v23.name == switchTab.AvatarExperienceTab
			then
				return true
			end
		end

		return false
	end)
else
	isAvatarExperienceRoute = nil
end

function v13.getIsAvatarExperienceRoute()
	return isAvatarExperienceRoute
end

function v13.isRouteInAvatarEditor(p2): boolean
	return p2.opaque.name == avatarScreen.AvatarEditor
end

function v13.didLeaveAvatarEditor(p2, p3): boolean
	if v13.isRouteInAvatarEditor(p3) and not v13.isRouteInAvatarEditor(p2) then
		return true
	end

	return false
end

function v13.getIsSceneFullViewFromState(p2, p3): boolean
	local name = p3.opaque.name
	return p2.AvatarExperience.Common.FullView[name] == fullView.SceneFullView
end

function v13.getAvatarEditorCategoryInfoFromState(p2)
	local category = p2.AvatarExperience.AvatarEditor.Categories.category
	local subcategory = p2.AvatarExperience.AvatarEditor.Categories.subcategory
	return v13.getAvatarEditorCategoryInfo(category, subcategory)
end

function v13.getAvatarEditorSubcategoryFilterFromState(p2)
	local avatarEditorCategoryInfoFromState = v13.getAvatarEditorCategoryInfoFromState(p2)

	if not avatarEditorCategoryInfoFromState.SubcategoryFilters then
		return nil
	end

	local subcategoryFilter = p2.AvatarExperience.AvatarEditor.Categories.subcategoryFilter
	return avatarEditorCategoryInfoFromState.SubcategoryFilters[subcategoryFilter]
end

function v13.getSelectedAccessoryDescription(instance, p2)
	local v23 = tonumber(p2) or 0

	for i, accessoryDescription in instance:GetChildren() do
		if accessoryDescription:IsA("AccessoryDescription") and accessoryDescription.AssetId == v23 then
			return accessoryDescription
		end
	end

	return nil
end

function v13.getAccessoryAdjustmentCategoryInfo(p2)
	local selectedAccessory = p2.AvatarExperience.AccessoryAdjustment.SelectedAccessory or ""
	local currentCharacter = p2.AvatarExperience.AvatarScene.Character.CurrentCharacter
	assert(currentCharacter, "assert currentCharacter exists")
	local humanoid = currentCharacter:FindFirstChild("Humanoid")
	assert(humanoid, "assert humanoid exists")
	local humanoidDescription = humanoid:FindFirstChild("HumanoidDescription")
	assert(humanoidDescription, "assert currentCharacter exists")

	local selectedAccessoryDescription = v13.getSelectedAccessoryDescription(
		humanoidDescription,
		selectedAccessory
	)

	if not selectedAccessoryDescription then
		return
	end

	assert(selectedAccessoryDescription, "assert accessoryDescription exists")
	return module14.CameraCategories[selectedAccessoryDescription.AccessoryType]
end

function v13.getCategoryInfoFromState(p2, p3)
	local name = p3.opaque.name

	if name == avatarScreen.AvatarEditor then
		return v13.getAvatarEditorCategoryInfoFromState(p2)
	end

	if name == avatarScreen.Catalog then
		return (module23.getCatalogSelectionStore().selectedCategoryInfo(false))
	end

	if name == avatarScreen.CatalogSearch then
		return module23.getCatalogSearchSelectionStore().selectedCategoryInfo(false)
	end

	if name == avatarScreen.ProfilePictureEditorEmotes then
		if module20() then
			return module18()
		end

		local v23 = module9().AssetTypeToCategorySubcategory[module4.AssetTypeIdStrings.EmoteAnimation]
		local category = v23.category
		local subcategory = v23.subcategory
		return v13.getAvatarEditorCategoryInfo(category, subcategory)
	elseif name == avatarScreen.AdjustAccessoryView then
		local accessoryAdjustmentCategoryInfo = v13.getAccessoryAdjustmentCategoryInfo(p2)

		if accessoryAdjustmentCategoryInfo then
			return accessoryAdjustmentCategoryInfo
		end

		return v9
	else
		if module13.readTestVariable(module15.EnabledForUser) and name == avatarScreen.CatalogSearch then
			return v12
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

		if
			fFlagAXPhotoboothMomentsStableCamera
			and fFlagAXPhotoboothMomentsPage
			and name == avatarScreen.PhotoboothMomentsPage
		then
			return v11
		end

		return v9
	end
end

local v23 = { "Torso", "RightArm", "LeftArm", "LeftLeg", "RightLeg" }

function v13.routeIsProfilePictureEditor(p2): boolean
	return p2.opaque.name == avatarScreen.ProfilePictureEditorEmotes
		or p2.opaque.name == avatarScreen.ProfilePictureEditorCamera
		or p2.opaque.name == avatarScreen.ProfilePictureEditorFinal
end

function v13.routeIsPPEStaticImagePage(p2): boolean
	return p2.opaque.name == avatarScreen.ProfilePictureEditorCamera
		or p2.opaque.name == avatarScreen.ProfilePictureEditorFinal
end

function v13.isFullyQualifiedCostume(p2): boolean
	for k, v24 in v23 do
		if p2[v24] == "" or p2[v24] == 0 then
			return false
		end
	end

	return true
end

function v13.shouldShowGradientForScrollingFrame(data): (boolean, boolean, boolean)
	local absoluteSize = data.AbsoluteSize
	local canvasSize = data.CanvasSize
	local canvasPosition = data.CanvasPosition

	return
		absoluteSize.X < canvasSize.X.Offset,
		canvasPosition.X > 20,
		canvasPosition.X + absoluteSize.X < canvasSize.X.Offset - 20
end

function v13.Round(p2, value)
	local v24 = value or 1
	return math.floor((p2 + v24 / 2) / v24) * v24
end

function v13.isFetchingDoneOrFailed(p2, p3)
	local v24 = p2 == retrievalStatus.Done or p2 == retrievalStatus.Failed
	local v25 = p3 == retrievalStatus.Done or p3 == retrievalStatus.Failed
	return not v24 and v25
end

function v13.getDeviceType()
	local platform = UserInputService:GetPlatform()

	if platform == Enum.Platform.Android then
		return module4.DeviceType.Android
	end

	if platform == Enum.Platform.IOS then
		return module4.DeviceType.IOS
	end

	return module4.DeviceType.Other
end

function v13.getUserOutfitIdFromBundle(p2)
	for k, item in p2.items do
		if item.type == module4.ItemType.Outfit then
			return item.id
		end
	end

	return nil
end

function v13.getUserOutfitIdsFromBundle(p2)
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

v13.getBundleInfo = memoize(function(p2, p3)
	if p3 == nil then
		return nil
	end

	local v24 = p2[p3]

	if not v24 then
		return nil
	end

	if v24.receivedCatalogData then
		return v24
	end

	return nil
end)

function v13.getBundleInfoFromState(p2, p3)
	local bundleInfos = p2.AvatarExperience.Common.BundleInfos
	return v13.getBundleInfo(bundleInfos, p3)
end

function v13.getOutfitInfoFromBundleIdNoState(p2, p3)
	if not p2 then
		return nil
	end

	assert(p2, "contentId is not nil: silences type checker")
	local userOutfitIdsFromBundle = v13.getUserOutfitIdsFromBundle(p2)

	if #userOutfitIdsFromBundle < 1 then
		return nil
	end

	local copy = nil

	for k, v24 in userOutfitIdsFromBundle do
		local v25 = p3[v24]

		if not v25 then
			return nil
		end

		if copy then
			copy.assets = Cryo.Dictionary.join(copy.assets, v25.assets)
		else
			copy = tutils.deepCopy(v25)
		end
	end

	return copy
end

function v13.getOutfitInfoFromBundleId(p2, p3)
	local bundleInfoFromState = v13.getBundleInfoFromState(p2, p3)
	local outfitInfos = p2.AvatarExperience.AvatarEditor.OutfitInfos

	return v13.getOutfitInfoFromBundleIdNoState(bundleInfoFromState, outfitInfos)
end

function v13.getAllCategoriesStr(p2)
	local v24 = 1
	local allCategoriesStr = ""

	while true do
		local v25 = "level" .. v24

		if not p2[v25] then
			return allCategoriesStr
		end

		if v24 ~= 1 then
			allCategoriesStr ..= "|"
		end

		allCategoriesStr ..= p2[v25]

		v24 += 1
	end
end

function v13.isAnimationAssetType(p2): boolean
	return p2 == module4.AssetTypeIdStrings.ClimbAnimation
		or p2 == module4.AssetTypeIdStrings.FallAnimation
		or p2 == module4.AssetTypeIdStrings.IdleAnimation
		or p2 == module4.AssetTypeIdStrings.JumpAnimation
		or p2 == module4.AssetTypeIdStrings.RunAnimation
		or p2 == module4.AssetTypeIdStrings.SwimAnimation
		or p2 == module4.AssetTypeIdStrings.WalkAnimation
end

function v13.getNumElementsWithKeyField(items)
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

function v13.lerp(p2, p3, p4)
	return (p3 - p2) * p4 + p2
end

function v13.getTopBarHeightAvatarScene(p2)
	if not p2.TopBar then
		return 0
	end

	if tenFootInterface then
		return 96
	end

	if p2.DeviceOrientation == deviceOrientationMode.Landscape then
		return p2.TopBar.statusBarHeight + module8.NAV_BAR_SIZE
	end

	return p2.TopBar.topBarHeight
end

function v13.tableToCamelCaseKeys(items)
	local result = {}

	for k, item in items do
		if typeof(k) == "string" then
			k = string.lower((string.sub(k, 1, 1))) .. string.sub(k, 2)
		end

		if typeof(item) == "table" then
			item = v13.tableToCamelCaseKeys(item)
		end

		result[k] = item
	end

	return result
end

function v13.AssetTypeIdStringToEnumValue(p2)
	local v24 = module4.AssetTypeIdStringToName[p2]
	return Enum.AvatarAssetType[v24]
end

function v13.bundleIdToEnum(p2)
	local v24 = module4.BundleTypeIdStringToName[p2]
	return Enum.BundleType[v24]
end

function v13.getSearchKey(p2, p3)
	local sortAndFiltersKey = module16.selectSortAndFiltersKey(p2)
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
	local v24 = {
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
	local v25 = if fFlagAXCatalogSpecialFeaturesFilter then t.optional(t.array(t.string)) else nil
	v24.SpecialFeaturesFilter = v25
	assert(strictInterface(v24)(data))
end

local function fn3(catalogSearchParams, list, list2)
	if list ~= nil and #list > 0 then
		catalogSearchParams.AssetTypes = Cryo.List.map(list, function(p2)
			return v13.AssetTypeIdStringToEnumValue(p2)
		end)
	end

	if list2 ~= nil and #list2 > 0 then
		catalogSearchParams.BundleTypes = Cryo.List.map(list2, function(p2)
			return v13.bundleIdToEnum(p2)
		end)
	end
end

local function hasSortOrFilters(data)
	return data.SortType ~= Enum.CatalogSortType.Relevance
		or (data.CreatorName ~= "" or (data.SalesTypeFilter ~= Enum.SalesTypeFilter.All or (data.SearchKeyword ~= "" or (data.MinPrice > module7.MinPriceFilter or (data.MaxPrice < module7.MaxPriceFilter or data.IncludeOffSale)))))
end

function v13.getSearchParamsAsQueryParams(data, p2)
	local searchParamsAsQueryParams = {}

	searchParamsAsQueryParams.keyword = data.SearchKeyword or ""

	searchParamsAsQueryParams.limit = data.Limit

	if fFlagAXAddHDCatalogTab then
		if
			p2
			and p2.CategoryFilter
			and (module7.CategoryFilters[p2.CategoryFilter] == nil or data.CategoryFilter ~= Enum.CatalogCategoryFilter.None)
		then
			searchParamsAsQueryParams.categoryFilter = p2.CategoryFilter
		end
	elseif
		data.CategoryFilter ~= Enum.CatalogCategoryFilter.None
		and data.SortType == Enum.CatalogSortType.Relevance
		and data.CreatorName == ""
		and data.SalesTypeFilter == Enum.SalesTypeFilter.All
		and data.SearchKeyword == ""
		and not (data.MinPrice > module7.MinPriceFilter or data.MaxPrice < module7.MaxPriceFilter)
		and not data.IncludeOffSale
	then
		searchParamsAsQueryParams.categoryFilter = tostring(data.CategoryFilter.Name)
	end

	searchParamsAsQueryParams.sortType = module7.SortTypeAPIMap[tostring(data.SortType.Name)]

	if data.CreatorName and data.CreatorName ~= "" then
		searchParamsAsQueryParams.creatorName = data.CreatorName
	end

	if p2 and p2.TaxonomyUuid then
		searchParamsAsQueryParams.taxonomy = tostring(p2.TaxonomyUuid)
	else
		if data.BundleTypes and #data.BundleTypes > 0 then
			local v24 = {}

			for k, bundleType in data.BundleTypes do
				table.insert(v24, bundleType.Value)
			end

			searchParamsAsQueryParams.bundleTypeIds = v24
		end

		if data.AssetTypes and #data.AssetTypes > 0 then
			local v24 = {}

			for k, assetType in data.AssetTypes do
				table.insert(v24, assetType.Value)
			end

			searchParamsAsQueryParams.assetTypeIds = v24
		end
	end

	searchParamsAsQueryParams.includeNotForSale = data.IncludeOffSale

	searchParamsAsQueryParams.creatorType = "All"

	if data.MinPrice and data.MinPrice > module7.MinPriceFilter then
		searchParamsAsQueryParams.minPrice = data.MinPrice
	end

	if data.MaxPrice and data.MaxPrice < module7.MaxPriceFilter then
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

function v13.getSearchParams(p2, data, p3)
	fn(p2)
	fn2(data)
	local catalogSearchParams = CatalogSearchParams.new()

	local v24 = if p2.searchKeyword then p2.searchKeyword else nil

	catalogSearchParams.AssetTypes = {}
	catalogSearchParams.BundleTypes = {}
	catalogSearchParams.IncludeOffSale = false

	local selectedTopics = data.SelectedTopics
	local v25

	if selectedTopics and #selectedTopics > 0 then
		v25 = true
		local joined = table.concat(selectedTopics, " ")

		if v24 == nil then
			v24 = joined
		else
			if #v24 > 0 then
				v24 ..= " "
			end

			v24 ..= joined
		end
	else
		v25 = false
	end

	if v24 then
		catalogSearchParams.SearchKeyword = v24
	end

	catalogSearchParams.Limit = (v24 or not p3) and 120 or 30

	if p2.categoryInfo == nil then
		catalogSearchParams.CategoryFilter = Enum.CatalogCategoryFilter.None
		fn3(catalogSearchParams, {}, {})
	else
		local categoryFilter = p2.categoryInfo.CategoryFilter
		local categoryFilter2 = module7.CategoryFilters[categoryFilter]

		if categoryFilter2 == nil or v25 then
			catalogSearchParams.CategoryFilter = Enum.CatalogCategoryFilter.None
		else
			catalogSearchParams.CategoryFilter = categoryFilter2
		end

		fn3(catalogSearchParams, p2.categoryInfo.AssetTypeIdStrings, p2.categoryInfo.BundleTypes)
	end

	local v26 = data.PriceRange.minPrice
	local v27 = data.PriceRange.maxPrice

	if defineFastFlag and v26 and v27 and v27 < v26 then
		v27, v26 = v26, v27
	end

	if module7.MinPriceFilter < v26 then
		catalogSearchParams.MinPrice = v26
	end

	if v27 < module7.MaxPriceFilter then
		catalogSearchParams.MaxPrice = v27
	end

	local catalogSort = data.CatalogSort
	catalogSearchParams.SortType = Enum.CatalogSortType[catalogSort]

	if data.UnavailableItemFilter ~= module12.Hide then
		catalogSearchParams.IncludeOffSale = true
	end

	local salesTypeFilter = data.SalesTypeFilter

	if salesTypeFilter ~= module11.All then
		if fFlagAXRemoveTimedOptionsSalesTypeEnumCheck then
			catalogSearchParams.SalesTypeFilter = Enum.SalesTypeFilter[salesTypeFilter]
		else
			local v28 = pcall(function()
				local timedOptions = Enum.SalesTypeFilter.TimedOptions
			end)

			if salesTypeFilter == module11.TimedOptions and not v28 then
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

	if catalogSort == module10.MostFavorited or catalogSort == module10.Bestselling then
		catalogSearchParams.SortAggregation = Enum.CatalogSortAggregation[data.CatalogSortAggregation]
	end

	if
		catalogSearchParams.SortType ~= Enum.CatalogSortType.Relevance
		or catalogSearchParams.CreatorName ~= ""
		or catalogSearchParams.SalesTypeFilter ~= Enum.SalesTypeFilter.All
		or catalogSearchParams.SearchKeyword ~= ""
		or catalogSearchParams.MinPrice > module7.MinPriceFilter
		or catalogSearchParams.MaxPrice < module7.MaxPriceFilter
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

function v13.getWebAssetModelFromEquippedAssets(items)
	local webAssetModel = {}

	for k, item in items do
		local v24 = module4.LayeredAssetTypes[k] ~= nil

		for k2, v25 in item do
			table.insert(webAssetModel, {
				id = k2,
				meta = v24 and v25 or nil
			})
		end
	end

	return webAssetModel
end

function v13.createHumanoidDescriptionAccessoryInfo(p2, p3, data)
	if fFlagAXOutfitPageRevamp then
		return AvatarExperienceCommon.Utils.createHumanoidDescriptionAccessoryInfo(p2, p3, data)
	end

	local v24 = tonumber(p3)
	assert(v24 ~= nil, "assetIdAsNumber is not nil. Silence type checker.")
	return {
		AssetId = v24,
		Order = data.order,
		AccessoryType = data.type or module4.AssetTypeIdToAccessoryTypeEnum[p2],
		IsLayered = data.isLayered,
		Position = data.position,
		Rotation = data.rotation,
		Scale = data.scale
	}
end

function v13.createDefaultHumanoidDescriptionAccessoryInfo(p2, p3)
	local v24 = tonumber(p3)

	if v24 == nil then
		module("Called AvatarExperienceUtils.createDefaultHumanoidDescriptionAccessoryInfo with assetId that does not convert to string.")
		v24 = 0
	end

	assert(v24, "assetIdAsNumber is non-nil: Silence type checker")
	return {
		AssetId = v24,
		Order = module4.LayeredClothingOrder[p2],
		AccessoryType = module4.AssetTypeIdToAccessoryTypeEnum[p2],
		IsLayered = module4.LayeredAssetTypes[p2] ~= nil
	}
end

function v13.getNewFullViewEnum(p2)
	if p2 == fullView.None then
		return fullView.UIFullView
	end

	return fullView.None
end

function v13.getPartCFrame(instance, childName)
	if instance and instance:FindFirstChild(childName) then
		return instance[childName].CFrame
	end

	return CFrame.new(module4.DefaultRigPosition)
end

function v13.getAttachmentCFrame(instance, childName, childName2)
	if not (instance and instance:FindFirstChild(childName)) then
		return nil
	end

	local folder = instance[childName]

	local v24 = if not fFlagAvatarJointUpgradeInUA then folder:FindFirstChild(childName2) else nil

	if fFlagAvatarJointUpgradeInUA then
		for i, attachment in folder:GetDescendants() do
			if attachment:IsA("Attachment") and attachment.Name == childName2 then
				v24 = attachment
				break
			end
		end
	end

	if v24 then
		if fFlagAvatarJointUpgradeInUA then
			return v24.WorldCFrame
		end

		return folder.CFrame * v24.CFrame
	end

	return nil
end

function v13.getRecursiveAttachmentCFrame(instance)
	local cframe = instance.CFrame
	local parent = instance.Parent

	while parent and parent:IsA("Bone") do
		cframe = parent.CFrame * cframe
		parent = parent.Parent
	end

	return cframe
end

function v13.isLCCategory(p2): boolean
	if p2 and p2.AssetTypeIdStrings then
		for k, assetTypeIdString in p2.AssetTypeIdStrings do
			if module4.LayeredAssetTypes[assetTypeIdString] ~= nil then
				return module4.LayeredAssetTypes[assetTypeIdString] ~= Enum.AccessoryType.Hair
			end
		end
	end

	return false
end

function v13.isBundleOrLCAsset(p2, p3)
	local v24 = p2 == module4.ItemType.Bundle
	return p2 == module4.ItemType.Asset and module4.LayeredAssetTypes[p3] ~= nil or v24
end

function v13.isBoundingBoxVectorSane(data): boolean
	return data.X <= 50000
		and data.X >= -50000
		and data.Y <= 50000
		and data.Y >= -50000
		and data.Z <= 50000
		and data.Z >= -50000
end

function v13.isBoundingBoxCFrameSane(p2)
	return v13.isBoundingBoxVectorSane(p2.Position) and v13.isBoundingBoxVectorSane(p2.LookVector)
end

function v13.getAssetIdsWithGeometryFromHumanoidDescription(object)
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

function v13.calculateNewAssetIdsWithGeometry(p2, p3)
	if not (p2 and p3) then
		return {}
	end

	local assetIdsWithGeometryFromHumanoidDescription = v13.getAssetIdsWithGeometryFromHumanoidDescription(p2)
	local assetIdsWithGeometryFromHumanoidDescription2 = v13.getAssetIdsWithGeometryFromHumanoidDescription(p3)

	local set = Cryo.List.toSet(assetIdsWithGeometryFromHumanoidDescription)

	return (Cryo.List.filter(assetIdsWithGeometryFromHumanoidDescription2, function(p4): boolean
		return set[p4] == nil
	end))
end

function v13.getItemIconTypeFromOutfit(p2)
	local v24 = p2.outfitType == module4.OutfitTypes.DynamicHead
	local containsDynamicHead = p2.containsDynamicHead

	if v24 or containsDynamicHead then
		return itemTileEnums.ItemIconType.DynamicHead
	end

	return nil
end

function v13.getItemStatusStyleFromOutfit(p2)
	local moderationStatus = p2.moderationStatus

	if moderationStatus == Enum.ModerationStatus.ReviewedRejected then
		return itemTileEnums.StatusStyle.AlertIcon
	end

	if moderationStatus == Enum.ModerationStatus.NotReviewed then
		return itemTileEnums.StatusStyle.PendingIcon
	end

	return nil
end

function v13.isModerationPendingOrRejected(p2): boolean
	return p2 == Enum.ModerationStatus.NotReviewed or p2 == Enum.ModerationStatus.ReviewedRejected
end

function v13.getMessageTypeFromModerationStatus(p2): nil | string
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

function v13.getModerationStatusFromAvailabilityStatus(p2)
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

function v13.assetTypeIdIsAnimationOrEmote(p2): boolean
	if p2 then
		return module4.AssetTypeIdToCategory[p2] == module4.AssetCategories.Animation
	end

	return false
end

local v24 = memoize(function(p2)
	local v25 = p2 and p2[module4.AssetTypeIdStrings.MoodAnimation]
	return v25 and next(v25)
end)

function v13.getEquippedMoodAssetId(p2)
	return v24(p2.AvatarExperience.AvatarEditor.Character.EquippedAssets)
end

function v13.getAssetIdForPPEPose(p2)
	local avatarExperience = p2.AvatarExperience

	for k, tryOnItem in p2.AvatarExperience.AvatarScene.OutfitTryOn.TryOnItems do
		if
			tryOnItem.itemType == module4.ItemType.Asset
			and v13.assetTypeIdIsAnimationOrEmote(tryOnItem.itemSubType)
		then
			return tryOnItem.itemId
		end
	end

	if avatarExperience.ProfilePictureEditor.ProfilePictureParams.emoteAssetId then
		return avatarExperience.ProfilePictureEditor.ProfilePictureParams.emoteAssetId
	end

	return nil
end

local v25 = memoize(function(p2)
	return p2 and p2[module4.AssetTypeIdStrings.Gear] and next(p2[module4.AssetTypeIdStrings.Gear])
end)

function v13.getEquippedToolId(p2)
	return v25(p2.AvatarExperience.AvatarEditor.Character.EquippedAssets)
end

function v13.getNextPageCursorKey(p2, p3, value)
	if p3 then
		return p2 .. (value or "")
	end

	return p2
end

function v13.getPerformFetchKey(p2, p3, value)
	if p3 then
		return module4.OutfitsKey .. p2 .. (value or "")
	end

	return module4.UserInventoryKey .. p2
end

function v13.getCurrentScreenIgnoreItemDetails(p2)
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

function v13.getLargestPossibleOneLineTextSize(p2, p3, p4, p5)
	local v26 = p5 - 1

	local vector2 = Vector2.new(v26, 100000)

	while p3 > 1 do
		local textSize = getTextSize(p2, p3, p4.Font, vector2, {
			addTemporaryPadding = false
		})

		if textSize.Y <= p3 + 1 then
			return Vector2.new(math.ceil(textSize.X), (math.ceil(textSize.Y))), p3
		end

		p3 -= 1
	end

	return nil, nil
end

function v13.selectSceneSize(data)
	local globalGuiInset = data.GlobalGuiInset
	local v26 = data.DeviceOrientation == deviceOrientationMode.Portrait
	local screenSize = data.ScreenSize

	local offset = getSafeAreaSize(screenSize, globalGuiInset).Y.Offset
	local bottom = globalGuiInset.bottom

	local v27 = screenSize.Y - bottom
	local v28 = offset * module4.PortraitSceneHeight
	v27 = v26 and v28 or v27
	local x = screenSize.X
	local v29 = if fFlagEnableSplitPane then v5.getLandscapeSceneWidth() else module4.LandscapeSceneWidth
	local v30 = x * v29
	v30 = v26 and screenSize.X or v30

	return v27, v30
end

v13.getColor3Difference = memoize(function(data, data2)
	return (math.sqrt((data.R - data2.R) * (data.R - data2.R) + (data.G - data2.G) * (data.G - data2.G) + (data.B - data2.B) * (data.B - data2.B)))
end)

v13.bodyColorToBodyColor3 = memoize(function(p2)
	if p2 then
		return BrickColor.new(p2).Color
	end

	return nil
end)

v13.bodyPartForSkinColoringIdToBodyColorId = {
	headColor3 = "headColorId",
	torsoColor3 = "torsoColorId",
	rightArmColor3 = "rightArmColorId",
	rightLegColor3 = "rightLegColorId",
	leftArmColor3 = "leftArmColorId",
	leftLegColor3 = "leftLegColorId"
}

v13.bodyColorIdToBodyPartForSkinColoringId = {}

for k, bodyColorId in pairs(v13.bodyPartForSkinColoringIdToBodyColorId) do
	v13.bodyColorIdToBodyPartForSkinColoringId[bodyColorId] = k
end

v13.convertBodyColor3sToHexes = memoize(function(items)
	local result = {}

	for k, item in pairs(items) do
		result[k] = item:ToHex()
	end

	return result
end)

v13.convertBodyColor3HexesToColor3s = memoize(function(items)
	local colors = {}

	for k, item in pairs(items) do
		colors[k] = Color3.fromHex(item)
	end

	return colors
end)

function v13.isAvatarSceneButtonsVisible(p2, p3, p4, p5, p6)
	local v26 = (avatarScreenProperties[p2.opaque.name] or {}).refinementButtonVisible and not p4 and not p5

	if p6 then
		return v26 and p6.state.key == p2.opaque.key
	end

	return v26 and p3
end

function v13.isUserCameraEligible(): boolean
	local VideoCaptureService = game:GetService("VideoCaptureService")
	local cameraDevices = VideoCaptureService:GetCameraDevices()
	local empty = Cryo.isEmpty(cameraDevices)
	assert(Players ~= nil, "Players should always be defined")

	return not (empty or tenFootInterface)
end

function v13.getUserId(p2)
	if p2.LocalUserId then
		return p2.LocalUserId
	end

	if p2.RobloxUser and p2.RobloxUser.rbxuid then
		return (tostring(p2.RobloxUser.rbxuid))
	end

	return nil
end

function v13.isItemSelectable(p2): boolean
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

function v13.isTryingOnClassicFace(p2)
	return Dash.some(p2, function(p3): boolean
		return p3.itemType == "Asset" and p3.itemSubType == module4.AssetTypeIdStrings.Face
	end)
end

function v13.isTryingOnDynamicHead(p2)
	return Dash.some(p2, function(p3): boolean
		return p3.itemType == "Bundle" and p3.itemSubType == module4.BundleTypeIdStrings.DynamicHead
	end)
end

v13.getRecommendedAssetTypeIdStringFromCategoryInfo = memoize(function(p2)
	if p2.RecommendedAssetTypeIdString then
		return p2.RecommendedAssetTypeIdString
	end

	if p2.AssetTypeIdStrings and #p2.AssetTypeIdStrings == 1 then
		return p2.AssetTypeIdStrings[1]
	end

	return nil
end)

v13.getRecommendedKey = memoize(function(p2)
	if p2.RecommendationsType == recommendationsType.Asset then
		local recommendedAssetTypeIdStringFromCategoryInfo = v13.getRecommendedAssetTypeIdStringFromCategoryInfo(p2)

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

	if module21() and p2.RecommendationsType == recommendationsType.All then
		return recommendationsType.All
	end

	return recommendationsType.None
end)

v13.getCategoryInfoByName = memoize(function(items, p2, p3)
	local v26 = nil
	local v27 = nil

	for k, item in items do
		if item.Name == p2 then
			if p3 and item.Subcategories then
				v27 = k

				for k2, subcategory in item.Subcategories do
					if subcategory.Name == p3 then
						v26 = k2
						break
					end
				end

				assert(v26 ~= nil, "Could not find subcategory with name " .. p3)
			else
				v27 = k
			end

			break
		end
	end

	assert(v27 ~= nil, "Could not find category with name  " .. p2)

	return (v13.getCategoryInfo(items, v27, v26))
end)

v13.getAssetIdFromContent = memoize(function(value)
	if value == nil then
		return nil
	end

	assert(value, "contentId is not nil: silences type checker")

	local v26 = string.match(value, ".*?id=([0-9]+)")

	if v26 then
		return v26
	end

	return string.match(value, "rbxassetid://([0-9]+)")
end)

v13.sortOutfitTryOnItemsByRecency = memoize(function(items, p2)
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

function v13.fuzzyEq(p2, p3, value): boolean
	return (value or 0.001) > math.abs(p2 - p3)
end

function v13.getCreatorNameTileFooterEnabled(p2)
	return p2 and p2.customizedDataMap and p2.customizedDataMap.creatorNameTileFooterEnabled == "true"
end

function v13.translateString(p2, p3)
	local robloxLocaleId = LocalizationService.RobloxLocaleId
	local v26 = localization.new(robloxLocaleId)
	v26:SetLocale(robloxLocaleId)

	local success, result = pcall(function()
		return v26:Format(p2, p3)
	end)

	if success then
		return result
	end

	module("Failed to translate string with key: " .. p2)
	return ""
end

function v13.resolveEditorCategory(p2)
	local v26 = module3()

	for k, v27 in v26 do
		if v27.Id == p2 then
			return v27.Category, nil
		end

		if not v27.Subcategories then
			continue
		end

		for k2, subcategory in v27.Subcategories do
			if subcategory.Id == p2 then
				return v27.Category, subcategory.Subcategory
			end
		end
	end

	return nil, nil
end

function v13.resolveHumanoidRigType(p2)
	if p2 == module4.AvatarType.R6 then
		return Enum.HumanoidRigType.R6
	end

	if p2 == module4.AvatarType.R15 then
		return Enum.HumanoidRigType.R15
	end

	return nil
end

return v13
