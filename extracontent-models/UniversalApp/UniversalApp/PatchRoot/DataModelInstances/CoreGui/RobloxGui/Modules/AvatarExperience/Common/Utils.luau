local CoreGui = game:GetService("CoreGui")
local CorePackages = game:GetService("CorePackages")
local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")
local GuiService = game:GetService("GuiService")
local LocalizationService = game:GetService("LocalizationService")
local Modules = CoreGui.RobloxGui.Modules
local mutedError = require(Modules.LuaApp.mutedError)
local RetrievalStatus = require(CorePackages.Workspace.Packages.Http).Enum.RetrievalStatus
local getSafeAreaSize = require(CorePackages.Workspace.Packages.InputUi).getSafeAreaSize
local Cryo = require(CorePackages.Packages.Cryo)
local Dash = require(CorePackages.Packages.Dash)
local tutils = require(CorePackages.Packages.tutils)
local t = require(CorePackages.Packages.t)
local UIBlox = require(CorePackages.Packages.UIBlox)
local TextService = game:GetService("TextService")
local Localization = require(CorePackages.Workspace.Packages.RobloxAppLocales).Localization
local ItemTileEnums = UIBlox.Tile.ItemTileEnums

require(CorePackages.Workspace.Packages.AvatarExperienceCatalog)

local AvatarScreen = require(CorePackages.Workspace.Packages.AvatarExperienceNavigation).Enums.AvatarScreen
local AvatarExperienceFlags = require(CorePackages.Workspace.Packages.AvatarExperienceFlags)
local Selectors = require(CorePackages.Workspace.Packages.NavigationRodux).Selectors
local GetAvatarEditorCategories = require(Modules.AvatarExperience.AvatarEditor.GetAvatarEditorCategories)
local Constants = require(Modules.AvatarExperience.Common.Constants)
local Constants2 = require(Modules.AvatarExperience.AvatarEditor.Constants)
local FFlagAXCustomizeMakeupSupport = AvatarExperienceFlags.FFlagAXCustomizeMakeupSupport
local GetCatalogCategoriesFromStore = require(Modules.AvatarExperience.Catalog.GetCatalogCategoriesFromStore)
local CatalogConstants = require(Modules.AvatarExperience.Catalog.CatalogConstants)
local Constants3 = require(Modules.LuaApp.Constants)
local memoize = require(CorePackages.Workspace.Packages.AppCommonLib).memoize
local AvatarScreenProperties = require(CorePackages.Workspace.Packages.AvatarExperienceNavigation).AvatarRoute.AvatarScreenProperties
local DeviceOrientationMode = require(CorePackages.Workspace.Packages.RobloxAppEnums).DeviceOrientationMode
local GetAvatarEditorStructure = require(Modules.AvatarExperience.AvatarEditor.GetAvatarEditorStructure)
local SortType = require(Modules.AvatarExperience.Common.Enum.SortType)
local SalesTypeFilter = require(Modules.AvatarExperience.Common.Enum.SalesTypeFilter)
local UnavailableItemFilter = require(Modules.AvatarExperience.Common.Enum.UnavailableItemFilter)

require(Modules.AvatarExperience.Common.Reducers.OutfitTryOn)
require(Modules.AvatarExperience.Common.AvatarExperienceState)

local FFlagUseNavigationSelectors = require(CorePackages.Workspace.Packages.SharedFlags).FFlagUseNavigationSelectors
local IxpUtils = require(CorePackages.Workspace.Packages.IxpUtils)
local Constants4 = require(Modules.AvatarExperience.AccessoryAdjustment.Constants)
local UniversalAppCameraIXPTest = require(Modules.AvatarExperience.Flags.UniversalAppCameraIXPTest)
local FilterUtils = require(Modules.AvatarExperience.Catalog.Components.Filters.FilterUtils)
local CatalogUtils = require(Modules.AvatarExperience.Catalog.CatalogUtils)

require(Modules.AvatarExperience.Catalog.SearchTypes)
require(Modules.AvatarExperience.Catalog.Reducers.SortAndFilters)
require(CorePackages.Workspace.Packages.AvatarExperienceRodux)

local InventoryItemAvailability = require(CorePackages.Workspace.Packages.AvatarExperienceSlotBasedEditor).Enums.InventoryItemAvailability
local getEmotesCategory = require(Modules.AvatarExperience.Common.getEmotesCategory)

require(Modules.AvatarExperience.Common.Types)

local FullView = require(CorePackages.Workspace.Packages.AvatarExperienceCommon).Enums.FullView
local SwitchTab = require(CorePackages.Workspace.Packages.RobloxAppEnums).SwitchTab
local v46 = GuiService:IsTenFootInterface()
local v47 = game:DefineFastString("AXLookWidgetContentType", "SearchToLooksWidget,SearchToCommunityLooksWidget,SearchToAvatarLooksWidget,PersonalizedAvatarLooksWidget,SortsPersonalizedAvatarLooksWidget,MySharedAvatarsWidget")
local v48 = game:DefineFastString("AXAvatarWidgetContentType", "SearchToAvatarLooksWidget,PersonalizedAvatarLooksWidget,SortsPersonalizedAvatarLooksWidget,MySharedAvatarsWidget")
local v49 = game:DefineFastString("AXTallBundleWidgetContentType", "AdvancedBodiesWidget")
local FFlagAXTallTilesForAdvancedBodiesWidget = AvatarExperienceFlags.FFlagAXTallTilesForAdvancedBodiesWidget
local FFlagAXSlotsInventoryLoadableGridView = require(CorePackages.Workspace.Packages.AvatarExperienceFlags).FFlagAXSlotsInventoryLoadableGridView
local FFlagAXRootSlotBasedEditorFlag = require(CorePackages.Workspace.Packages.AvatarExperienceFlags).FFlagAXRootSlotBasedEditorFlag
local v53 = game:DefineFastFlag("AXFixMinMaxPriceFilterError", false)
local GetFFlagAXExtractEmotesCategory = require(Modules.AvatarExperience.Flags.GetFFlagAXExtractEmotesCategory)
local GetFFlagAXEnableRecommendationTypeAllInCustomize = require(Modules.AvatarExperience.Flags.GetFFlagAXEnableRecommendationTypeAllInCustomize)
local FFlagAXMutedErrorLoggingForCategorySelection = AvatarExperienceFlags.FFlagAXMutedErrorLoggingForCategorySelection
local FFlagAXRemoveTimedOptionsSalesTypeEnumCheck = AvatarExperienceFlags.FFlagAXRemoveTimedOptionsSalesTypeEnumCheck
local FFlagAXEditorSubcategoryFilters = AvatarExperienceFlags.FFlagAXEditorSubcategoryFilters
local FFlagAvatarJointUpgradeInUA = require(CorePackages.Workspace.Packages.SharedFlags).FFlagAvatarJointUpgradeInUA
local FFlagAXFixCatalogSearchZoom = AvatarExperienceFlags.FFlagAXFixCatalogSearchZoom
local FFlagAXAddHDCatalogTab = AvatarExperienceFlags.FFlagAXAddHDCatalogTab
local FFlagAXAvatarTabLooksYouMayAlsoLike = AvatarExperienceFlags.FFlagAXAvatarTabLooksYouMayAlsoLike
local FFlagEnableLeftNavOnConsole = require(CorePackages.Workspace.Packages.SharedFlags).FFlagEnableLeftNavOnConsole
local GetCatalogCategoriesStore = require(Modules.AvatarExperience.Catalog.Stores.GetCatalogCategoriesStore)
local u65 = if not FFlagAXTallTilesForAdvancedBodiesWidget then nil else {}
local v66 = string.split(v47, ",") or {}
local u67 = Cryo.List.map(v66, function(p1) -- line: 132
	return p1:match("^%s*(.*)%s*$")
end)
local v68 = string.split(v48, ",") or {}
local u69 = Cryo.List.map(v68, function(p2) -- line: 139
	return p2:match("^%s*(.*)%s*$")
end)

if FFlagAXTallTilesForAdvancedBodiesWidget then
	local v70 = string.split(v49, ",") or {}

	u65 = Cryo.List.map(v70, function(p3) -- line: 146
		return p3:match("^%s*(.*)%s*$")
	end)
end

local t1 = {
	PageType = Constants.PageType.Other,
	RecommendationsType = Constants2.RecommendationsType.None
}
local t2 = {
	CanAnimateCameraBasedMood = true,
	PageType = Constants.PageType.Other,
	RecommendationsType = Constants2.RecommendationsType.None
}
local t3 = {}
local t4 = {}
local t5 = {}
local v76 = memoize(function(t6: {[any]: any}, n1: number, n2: number?) -- line: 192
	-- upvalues: Cryo (copy), Constants (copy)
	local v103 = t6[n1]

	if v103.Subcategories and n2 then
		local v104 = v103.Subcategories[n2]

		if v104 then
			local v105 = Cryo.Dictionary.join(v103, v104)

			v105.AssetTypeIdStrings = v104.AssetTypeIdStrings
			v105.BundleTypes = v104.BundleTypes
			v105.CategoryFilter = v104.CategoryFilter
			v105.Subcategories = v104.Subcategories

			return v105
		end
	end

	if v103.PageType == Constants.PageType.Emotes then
		return Cryo.Dictionary.join(v103, {
			EmoteSlot = n2
		})
	end

	return v103
end)
local v77 = memoize(function(t7: {[any]: any}, s1: string, s2: string?) -- line: 235
	-- upvalues: CatalogUtils (copy), FFlagAXMutedErrorLoggingForCategorySelection (copy), mutedError (copy), Cryo (copy), Constants (copy)
	local v109 = CatalogUtils.extractCategoryById(s1, t7)

	if FFlagAXMutedErrorLoggingForCategorySelection and v109 == nil then
		mutedError("[buildCategoryInfoById] Category not found for categoryId: " .. tostring(s1) .. " and subcategoryId: " .. tostring(s2))
	end

	if v109.Subcategories and s2 then
		local Subcategories = v109.Subcategories
		local v111 = CatalogUtils.extractSubcategoryById(s2, Subcategories)

		if v111 then
			local v112 = Cryo.Dictionary.join(v109, v111)

			v112.AssetTypeIdStrings = v111.AssetTypeIdStrings
			v112.BundleTypes = v111.BundleTypes
			v112.CategoryFilter = v111.CategoryFilter
			v112.Subcategories = v111.Subcategories
			v112.SubcategoriesMap = v111.SubcategoriesMap

			return v112
		end
	end

	if v109.PageType == Constants.PageType.Emotes then
		return Cryo.Dictionary.join(v109, {
			EmoteSlot = s2
		})
	end

	return v109
end)

local function categoryKey(t8: {[any]: any}, n3: number, n4: number?) -- line: 286
	return string.format("%s.%s.%s", tostring(t8), tostring(n3), (tostring(n4)))
end
local function categoryKeyV2(p4, s3: string, s4: string?) -- line: 292
	return string.format("%s.%s.%s", tostring(p4), tostring(s3), (tostring(s4)))
end

t3.getCategoryInfo = memoize(function(t9: {[any]: any}, n5: number, n6: number?) -- line: 306
	-- upvalues: t4 (copy), v76 (copy)
	local v122 = string.format("%s.%s.%s", tostring(t9), tostring(n5), (tostring(n6)))
	local v123 = t4[v122]

	if v123 == nil then
		v123 = v76(t9, n5, n6)
		t4[v122] = v123
	end

	return v123
end)
t3.getCategoryInfoById = memoize(function(t10: {[any]: any}, s5: string, s6: string?) -- line: 322
	-- upvalues: t5 (copy), v77 (copy)
	local v127 = string.format("%s.%s.%s", tostring(t10), tostring(s5), (tostring(s6)))
	local v128 = t5[v127]

	if v128 == nil then
		v128 = v77(t10, s5, s6)
		t5[v127] = v128
	end

	return v128
end)
t3.getCatalogCategoryInfo = memoize(function(n7: number, n8: number?) -- line: 334
	-- upvalues: GetCatalogCategoriesFromStore (copy), t3 (copy)
	local v131 = GetCatalogCategoriesFromStore()

	return t3.getCategoryInfo(v131, n7, n8)
end)
t3.getCatalogCategoryInfoById = memoize(function(s7: string, s8: string?) -- line: 341
	-- upvalues: GetCatalogCategoriesFromStore (copy), t3 (copy)
	local v134 = GetCatalogCategoriesFromStore()

	return t3.getCategoryInfoById(v134, s7, s8)
end)
t3.getAvatarEditorCategoryInfo = memoize(function(n9: number, n10: number?) -- line: 348
	-- upvalues: GetAvatarEditorCategories (copy), t3 (copy)
	local v137 = GetAvatarEditorCategories()

	return (t3.getCategoryInfo(v137, n9, n10))
end)

local function getCatalogCardFooterHeight(p5) -- line: 359
	if p5 < 100 then
		return 30
	end

	if p5 < 148 then
		return 36
	end

	return 42
end

local v81 = memoize(function(p6, _, b1: boolean?) -- line: 369
	-- upvalues: Constants (copy)
	local v142 = if not b1 then Constants.ItemTileTitleMaxLines else Constants.CreatorNameItemTileTitleMaxLines
	local v143 = if not b1 then Constants.ItemTilePadding else Constants.CreatorNameItemTilePadding

	return function(p8) -- line: 377
		-- upvalues: v142 (copy), p6 (copy), v143 (copy), b1 (copy)
		local v468 = v142 * p6
		local v469 = v143 * 2
		local v470 = if not (p8 < 100) then not (p8 < 148) and 42 or 36 else 30

		if b1 then
			v470 *= 2
		end

		return p8 + v468 + v469 + v470
	end
end)
local v82 = memoize(function(p9, _, b2: boolean?) -- line: 392
	-- upvalues: Constants (copy)
	local v147 = if not b2 then Constants.ItemTileTitleMaxLines else Constants.CreatorNameItemTileTitleMaxLines
	local v148 = if not b2 then Constants.ItemTilePadding else Constants.CreatorNameItemTilePadding

	return function(p11) -- line: 400
		-- upvalues: Constants (copy), v147 (copy), p9 (copy), v148 (copy), b2 (copy)
		local v472 = p11 / Constants.ItemTileTallAspectRatio
		local v473 = v147 * p9
		local v474 = v148 * 2
		local v475 = if not (p11 < 100) then not (p11 < 148) and 42 or 36 else 30

		if b2 then
			v475 *= 2
		end

		return v472 + v473 + v474 + v475
	end
end)

function t3.isLooksWidget(s9: string?) -- line: 416
	-- upvalues: u67 (ref)
	return table.find(u67, s9) ~= nil
end
function t3.isTallBundleWidget(s10: string?) -- line: 430
	-- upvalues: FFlagAXTallTilesForAdvancedBodiesWidget (copy), u65 (ref)
	if not FFlagAXTallTilesForAdvancedBodiesWidget then
		return false
	end

	return table.find(u65, s10) ~= nil
end
function t3.isAvatarLooksWidget(s11: string?) -- line: 442
	-- upvalues: t3 (copy), u69 (ref)
	return t3.isLooksWidget(s11) and table.find(u69, s11) ~= nil
end

local v83 = memoize(function(n11: number, _: boolean?, b4: boolean?, b5: boolean?, b6: boolean?) -- line: 449
	-- upvalues: Constants (copy)
	return function(n12: number) -- line: 456
		-- upvalues: Constants (copy), b4 (copy), b5 (copy), b6 (copy), n11 (copy)
		local v477 = n12 / Constants.LookTileAspectRatio
		local v478 = b4 or b5

		if not b6 then
			v477 += 30
		elseif v478 then
			v477 += 30
		end

		if v478 then
			v477 += 4
		end

		if b4 then
			v477 += n11
		end

		if b5 then
			if b4 then
				v477 += 4
			end

			v477 += n11
		end

		return v477
	end
end)
local v84 = memoize(function(n13: number) -- line: 497
	-- upvalues: Constants (copy)
	return function(n14: number) -- line: 498
		-- upvalues: Constants (copy), n13 (copy)
		local v480 = Constants.ItemTileTitleMaxLines * n13
		local ItemTilePadding = Constants.ItemTilePadding

		return n14 + v480 + ItemTilePadding
	end
end)

local function squareItemHeightGetter(n15: number) -- line: 506
	return n15
end

local v86 = memoize(function(n16: number?) -- line: 510
	-- upvalues: squareItemHeightGetter (copy), FFlagAXSlotsInventoryLoadableGridView (copy), Constants (copy), FFlagAXRootSlotBasedEditorFlag (copy)
	if n16 == nil then
		return squareItemHeightGetter
	end

	return function(n17: number) -- line: 514
		-- upvalues: FFlagAXSlotsInventoryLoadableGridView (copy), Constants (copy), n16 (copy), FFlagAXRootSlotBasedEditorFlag (copy)
		local v483 = if not FFlagAXSlotsInventoryLoadableGridView then Constants.ItemTileTitleMaxLines * n16 else Constants.EditorItemTileTitleMaxLines * n16
		local v484 = if not FFlagAXRootSlotBasedEditorFlag then Constants.ItemTilePadding * 2 else Constants.ItemTilePadding

		return n17 + v483 + v484
	end
end)

local function splitKeywords(s12: string?) -- line: 528
	if s12 then
		return string.split(s12, " ")
	end

	return {}
end

function t3.mergeKeywordsAndTopics(s13: string?, s14: string?) -- line: 548
	local v163 = if not s13 then {} else string.split(s13, " ")

	for _, v165 in if not s14 then {} else string.split(s14, " ") do
		if #v165 > 0 and not table.find(v163, v165) then
			table.insert(v163, v165)
		end
	end

	return table.concat(v163, " ")
end

t3.GetCategoryIdsFromNavKey = memoize(function(p12, p13) -- line: 568
	-- upvalues: GetCatalogCategoriesFromStore (copy)
	for _, v169 in (GetCatalogCategoriesFromStore()) do
		if not v169.NavigationKey then
			continue
		end

		local Id = v169.Id

		if p12 == v169.NavigationKey then
			if v169.Subcategories and p13 then
				for _, v172 in v169.Subcategories do
					if p13 == v172.NavigationKey then
						return Id, v172.Id
					end
				end
			end

			return Id, nil
		end
	end

	return nil, nil
end)
t3.GetAvatarEditorCategoryIdsFromNavKey = memoize(function(s15: string) -- line: 592
	-- upvalues: GetAvatarEditorCategories (copy), FFlagAXEditorSubcategoryFilters (copy)
	for v174, v175 in (GetAvatarEditorCategories()) do
		if s15 == v175.NavigationKey then
			return v174, nil, nil
		end

		if v175.Subcategories then
			for v176, v177 in v175.Subcategories do
				if s15 == v177.NavigationKey then
					return v174, v176, nil
				end

				if FFlagAXEditorSubcategoryFilters and v177.SubcategoryFilters then
					for v178, v179 in v177.SubcategoryFilters do
						if s15 == v179.NavigationKey then
							return v174, v176, v178
						end
					end
				end
			end
		end
	end

	return nil, nil, nil
end)

function t3.GridItemHeightGetter(p14, ...) -- line: 617
	-- upvalues: Constants (copy), v86 (copy), squareItemHeightGetter (copy), v84 (copy), v83 (copy), v81 (copy), v82 (copy)
	if p14 == Constants.ItemTileType.AvatarEditorTile then
		return v86(...)
	end

	if p14 == Constants.ItemTileType.BodyColorButton then
		return squareItemHeightGetter
	end

	if p14 == Constants.ItemTileType.BundleItemTile then
		return v84(...)
	end

	if p14 == Constants.ItemTileType.BundleItemTileNoText then
		return squareItemHeightGetter
	end

	if p14 == Constants.ItemTileType.LookItemTile then
		return v83(...)
	end

	if p14 == Constants.ItemTileType.CatalogItemTile then
		return v81(...)
	end

	if p14 == Constants.ItemTileType.TallCatalogItemTile then
		return v82(...)
	end

	warn("Unknown itemType " .. tostring(p14) .. " in AvatarExperienceUtils.GridItemHeightGetter")

	return squareItemHeightGetter
end
function t3.GridItemHeightGetterWithOptions(t11: {[any]: any}) -- line: 649
	-- upvalues: Constants (copy), v86 (copy), squareItemHeightGetter (copy), v84 (copy), v83 (copy), v81 (copy), v82 (copy)
	local itemTileType = t11.itemTileType

	if itemTileType == Constants.ItemTileType.AvatarEditorTile then
		return v86(t11.fontHeight)
	end

	if itemTileType == Constants.ItemTileType.BodyColorButton then
		return squareItemHeightGetter
	end

	if itemTileType == Constants.ItemTileType.BundleItemTile and t11.fontHeight then
		return v84(t11.fontHeight)
	end

	if itemTileType == Constants.ItemTileType.BundleItemTileNoText then
		return squareItemHeightGetter
	end

	if itemTileType == Constants.ItemTileType.LookItemTile and t11.fontHeight then
		return v83(t11.fontHeight, t11.hideItemName, t11.itemCreatorNamesEnabled, t11.itemPriceEnabled, t11.isWidgetFocused)
	end

	if itemTileType == Constants.ItemTileType.CatalogItemTile then
		return v81(t11.fontHeight, nil, t11.itemCreatorNamesEnabled)
	end

	if itemTileType == Constants.ItemTileType.TallCatalogItemTile then
		return v82(t11.fontHeight, nil, t11.itemCreatorNamesEnabled)
	end

	warn("Unknown itemType " .. tostring(itemTileType) .. " in AvatarExperienceUtils.GridItemHeightGetterWithOptions")

	return squareItemHeightGetter
end
function t3.isAvatarBackground(p15) -- line: 678
	-- upvalues: AvatarScreen (copy)
	return p15 == AvatarScreen.AvatarBackground
end
function t3.isAvatarExperienceRoute(p16) -- line: 682
	-- upvalues: FFlagUseNavigationSelectors (copy), Selectors (copy), AvatarScreen (copy), SwitchTab (copy)
	for _, v186 in if not FFlagUseNavigationSelectors then p16.Navigation.history[#p16.Navigation.history] else Selectors.selectCurrentLegacyRoute(p16) do
		if v186.name == AvatarScreen.AvatarExperienceRoot or v186.name == SwitchTab.AvatarExperienceTab then
			return true
		end
	end

	return false
end
function t3.isRouteInAvatarEditor(p17) -- line: 697
	-- upvalues: AvatarScreen (copy)
	return p17.opaque.name == AvatarScreen.AvatarEditor
end
function t3.didLeaveAvatarEditor(p18, p19) -- line: 706
	-- upvalues: t3 (copy)
	if t3.isRouteInAvatarEditor(p19) and not t3.isRouteInAvatarEditor(p18) then
		return true
	end

	return false
end
function t3.getIsSceneFullViewFromState(p20, p21) -- line: 715
	-- upvalues: FullView (copy)
	local name = p21.opaque.name

	return p20.AvatarExperience.Common.FullView[name] == FullView.SceneFullView
end
function t3.getAvatarEditorCategoryInfoFromState(p22) -- line: 720
	-- upvalues: t3 (copy)
	local category = p22.AvatarExperience.AvatarEditor.Categories.category
	local subcategory = p22.AvatarExperience.AvatarEditor.Categories.subcategory

	return t3.getAvatarEditorCategoryInfo(category, subcategory)
end
function t3.getAvatarEditorSubcategoryFilterFromState(p23) -- line: 728
	-- upvalues: t3 (copy)
	local v197 = t3.getAvatarEditorCategoryInfoFromState(p23)

	if v197.SubcategoryFilters then
		local subcategoryFilter = p23.AvatarExperience.AvatarEditor.Categories.subcategoryFilter

		return v197.SubcategoryFilters[subcategoryFilter]
	end

	return nil
end
function t3.getSelectedAccessoryDescription(p24, p25) -- line: 739
	local v201 = tonumber(p25) or 0

	for _, child in p24:GetChildren() do
		if child:IsA("AccessoryDescription") and v201 == child.AssetId then
			return child
		end
	end

	return nil
end
function t3.getAccessoryAdjustmentCategoryInfo(p26) -- line: 754
	-- upvalues: t3 (copy), Constants4 (copy)
	local v205 = p26.AvatarExperience.AccessoryAdjustment.SelectedAccessory or ""
	local CurrentCharacter = p26.AvatarExperience.AvatarScene.Character.CurrentCharacter

	assert(CurrentCharacter, "assert currentCharacter exists")

	local Humanoid = CurrentCharacter:FindFirstChild("Humanoid")

	assert(Humanoid, "assert humanoid exists")

	local HumanoidDescription = Humanoid:FindFirstChild("HumanoidDescription")

	assert(HumanoidDescription, "assert currentCharacter exists")

	local v209 = t3.getSelectedAccessoryDescription(HumanoidDescription, v205)

	if not v209 then
		return
	end

	assert(v209, "assert accessoryDescription exists")

	return Constants4.CameraCategories[v209.AccessoryType]
end
function t3.getCategoryInfoFromState(p27, p28) -- line: 781
	-- upvalues: AvatarScreen (copy), t3 (copy), GetCatalogCategoriesStore (copy), FFlagAXFixCatalogSearchZoom (copy), GetFFlagAXExtractEmotesCategory (copy), getEmotesCategory (copy), GetAvatarEditorStructure (copy), Constants (copy), t1 (copy), IxpUtils (copy), UniversalAppCameraIXPTest (copy), t2 (copy), FFlagAXCustomizeMakeupSupport (copy)
	local name = p28.opaque.name

	if name == AvatarScreen.AvatarEditor then
		return t3.getAvatarEditorCategoryInfoFromState(p27)
	end

	if name == AvatarScreen.Catalog then
		return (GetCatalogCategoriesStore.getCatalogSelectionStore().selectedCategoryInfo(false))
	end

	if FFlagAXFixCatalogSearchZoom and name == AvatarScreen.CatalogSearch then
		return GetCatalogCategoriesStore.getCatalogSearchSelectionStore().selectedCategoryInfo(false)
	end

	if name == AvatarScreen.ProfilePictureEditorEmotes then
		if GetFFlagAXExtractEmotesCategory() then
			return (getEmotesCategory())
		end

		local v213 = GetAvatarEditorStructure().AssetTypeToCategorySubcategory[Constants.AssetTypeIdStrings.EmoteAnimation]
		local category = v213.category
		local subcategory = v213.subcategory

		return t3.getAvatarEditorCategoryInfo(category, subcategory)
	end

	if name == AvatarScreen.AdjustAccessoryView then
		local v216 = t3.getAccessoryAdjustmentCategoryInfo(p27)

		if v216 then
			return v216
		end

		return t1
	end

	if IxpUtils.readTestVariable(UniversalAppCameraIXPTest.EnabledForUser) and name == AvatarScreen.CatalogSearch then
		return t2
	end

	if name == AvatarScreen.HeadRefinement then
		return Constants.HeadRefinementCameraCategory
	end

	if FFlagAXCustomizeMakeupSupport and name == AvatarScreen.LayeredMakeupSort then
		return Constants.LayeredMakeupCameraCategory
	end

	return t1
end

local t12 = {
	"Torso",
	"RightArm",
	"LeftArm",
	"LeftLeg",
	"RightLeg"
}

function t3.routeIsProfilePictureEditor(p29) -- line: 840
	-- upvalues: AvatarScreen (copy)
	return p29.opaque.name == AvatarScreen.ProfilePictureEditorEmotes or (p29.opaque.name == AvatarScreen.ProfilePictureEditorCamera or p29.opaque.name == AvatarScreen.ProfilePictureEditorFinal)
end
function t3.routeIsPPEStaticImagePage(p30) -- line: 850
	-- upvalues: AvatarScreen (copy)
	return p30.opaque.name == AvatarScreen.ProfilePictureEditorCamera or p30.opaque.name == AvatarScreen.ProfilePictureEditorFinal
end
function t3.isFullyQualifiedCostume(p31) -- line: 855
	-- upvalues: t12 (copy)
	for _, v221 in t12 do
		if p31[v221] == "" or p31[v221] == 0 then
			return false
		end
	end

	return true
end
function t3.shouldShowGradientForScrollingFrame(p32) -- line: 864
	local AbsoluteSize = p32.AbsoluteSize
	local CanvasSize = p32.CanvasSize
	local CanvasPosition = p32.CanvasPosition

	return AbsoluteSize.X < CanvasSize.X.Offset, CanvasPosition.X > 20, CanvasPosition.X + AbsoluteSize.X < CanvasSize.X.Offset - 20
end
function t3.Round(n18: number, n19: number?) -- line: 877
	local v228 = n19 or 1

	return math.floor((n18 + v228 / 2) / v228) * v228
end
function t3.isFetchingDoneOrFailed(p33, p34) -- line: 882
	-- upvalues: RetrievalStatus (copy)
	local v231 = p33 == RetrievalStatus.Done or p33 == RetrievalStatus.Failed
	local v232 = p34 == RetrievalStatus.Done or p34 == RetrievalStatus.Failed

	return not v231 and v232
end
function t3.getDeviceType() -- line: 890
	-- upvalues: UserInputService (copy), Constants (copy)
	local Platform = UserInputService:GetPlatform()

	if Platform == Enum.Platform.Android then
		return Constants.DeviceType.Android
	end

	if Platform == Enum.Platform.IOS then
		return Constants.DeviceType.IOS
	end

	return Constants.DeviceType.Other
end
function t3.getUserOutfitIdFromBundle(p35) -- line: 902
	-- upvalues: Constants (copy)
	for _, v236 in p35.items do
		if v236.type == Constants.ItemType.Outfit then
			return v236.id
		end
	end

	return nil
end
function t3.getUserOutfitIdsFromBundle(p36) -- line: 913
	-- upvalues: Constants (copy)
	local t13 = {}

	if p36.items then
		for _, v240 in p36.items do
			if v240.type == Constants.ItemType.Outfit then
				table.insert(t13, v240.id)
			end
		end
	end

	return t13
end

t3.getBundleInfo = memoize(function(p37, s16: string?) -- line: 928
	if s16 == nil then
		return nil
	end

	local v243 = p37[s16]

	if not v243 then
		return nil
	end

	if v243.receivedCatalogData then
		return v243
	end

	return nil
end)

function t3.getBundleInfoFromState(p38, s17: string?) -- line: 944
	-- upvalues: t3 (copy)
	local BundleInfos = p38.AvatarExperience.Common.BundleInfos

	return t3.getBundleInfo(BundleInfos, s17)
end
function t3.getOutfitInfoFromBundleIdNoState(p39, p40) -- line: 952
	-- upvalues: t3 (copy), tutils (copy), Cryo (copy)
	if not p39 then
		return nil
	end

	assert(p39, "contentId is not nil: silences type checker")

	local v249 = t3.getUserOutfitIdsFromBundle(p39)

	if #v249 < 1 then
		return nil
	end

	local v250 = nil

	for _, v252 in v249 do
		local v253 = p40[v252]

		if not v253 then
			return nil
		end

		if not v250 then
			v250 = tutils.deepCopy(v253)
		else
			v250.assets = Cryo.Dictionary.join(v250.assets, v253.assets)
		end
	end

	return v250
end
function t3.getOutfitInfoFromBundleId(p41, s18: string?) -- line: 987
	-- upvalues: t3 (copy)
	local v256 = t3.getBundleInfoFromState(p41, s18)
	local OutfitInfos = p41.AvatarExperience.AvatarEditor.OutfitInfos

	return t3.getOutfitInfoFromBundleIdNoState(v256, OutfitInfos)
end
function t3.getAllCategoriesStr(p42) -- line: 994
	local s19 = ""
	local n20 = 1

	while true do
		local v261 = "level" .. n20

		if not p42[v261] then
			break
		end

		if n20 ~= 1 then
			s19 ..= "|"
		end

		s19 ..= p42[v261]
		n20 += 1
	end

	return s19
end
function t3.isAnimationAssetType(p43) -- line: 1016
	-- upvalues: Constants (copy)
	return p43 == Constants.AssetTypeIdStrings.ClimbAnimation or (p43 == Constants.AssetTypeIdStrings.FallAnimation or (p43 == Constants.AssetTypeIdStrings.IdleAnimation or (p43 == Constants.AssetTypeIdStrings.JumpAnimation or (p43 == Constants.AssetTypeIdStrings.RunAnimation or (p43 == Constants.AssetTypeIdStrings.SwimAnimation or p43 == Constants.AssetTypeIdStrings.WalkAnimation)))))
end
function t3.getNumElementsWithKeyField(p44) -- line: 1026
	local n21 = 0

	if p44 then
		for _, v266 in p44 do
			if typeof(v266) == "table" and v266.key then
				n21 += 1
			end
		end
	end

	return n21
end
function t3.lerp(n22: number, n23: number, n24: number) -- line: 1038
	return (n23 - n22) * n24 + n22
end
function t3.getTopBarHeightAvatarScene(p45) -- line: 1042
	-- upvalues: FFlagEnableLeftNavOnConsole (copy), v46 (copy), DeviceOrientationMode (copy), Constants3 (copy)
	if not p45.TopBar then
		return 0
	end

	if FFlagEnableLeftNavOnConsole and v46 then
		return 96
	end

	if p45.DeviceOrientation == DeviceOrientationMode.Landscape then
		return p45.TopBar.statusBarHeight + Constants3.NAV_BAR_SIZE
	end

	return p45.TopBar.topBarHeight
end
function t3.tableToCamelCaseKeys(p46) -- line: 1059
	-- upvalues: t3 (copy)
	local t14 = {}

	for v273, v274 in p46 do
		local v275 = v273

		if typeof(v273) == "string" then
			v275 = string.lower((string.sub(v273, 1, 1))) .. string.sub(v273, 2)
		end

		local v276 = v274

		if typeof(v274) == "table" then
			v276 = t3.tableToCamelCaseKeys(v274)
		end

		t14[v275] = v276
	end

	return t14
end
function t3.AssetTypeIdStringToEnumValue(p47) -- line: 1080
	-- upvalues: Constants (copy)
	local v278 = Constants.AssetTypeIdStringToName[p47]

	return Enum.AvatarAssetType[v278]
end
function t3.bundleIdToEnum(p48) -- line: 1085
	-- upvalues: Constants (copy)
	local v280 = Constants.BundleTypeIdStringToName[p48]

	return Enum.BundleType[v280]
end
function t3.getSearchKey(p49, s20: string) -- line: 1090
	-- upvalues: FilterUtils (copy), Constants (copy)
	local v283 = FilterUtils.selectSortAndFiltersKey(p49)

	return Constants.SearchCatalogKey .. s20 .. "." .. v283
end

local function v89(p50) -- line: 1095
	-- upvalues: t (copy)
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
	})(p50))
end
local function v90(p51) -- line: 1110
	-- upvalues: t (copy)
	assert(t.strictInterface({
		CatalogSort = t.optional(t.string),
		CatalogSortAggregation = t.optional(t.string),
		PriceRange = t.strictInterface({
			maxPrice = t.number,
			minPrice = t.number
		}),
		SelectedTopics = t.optional(t.array(t.string)),
		SalesTypeFilter = t.optional(t.string),
		CreatorFilter = t.optional(t.string),
		UnavailableItemFilter = t.optional(t.string),
		WearTimeFilter = t.optional(t.string)
	})(p51))
end
local function v91(p52, t15: {[any]: any}?, t16: {[any]: any}?) -- line: 1136
	-- upvalues: Cryo (copy), t3 (copy)
	if t15 ~= nil and #t15 > 0 then
		p52.AssetTypes = Cryo.List.map(t15, function(p53) -- line: 1138
			-- upvalues: t3 (copy)
			return t3.AssetTypeIdStringToEnumValue(p53)
		end)
	end

	if t16 ~= nil and #t16 > 0 then
		p52.BundleTypes = Cryo.List.map(t16, function(p54) -- line: 1145
			-- upvalues: t3 (copy)
			return t3.bundleIdToEnum(p54)
		end)
	end
end
local function hasSortOrFilters(p55) -- line: 1152
	-- upvalues: CatalogConstants (copy)
	return p55.SortType ~= Enum.CatalogSortType.Relevance or (p55.CreatorName ~= "" or (p55.SalesTypeFilter ~= Enum.SalesTypeFilter.All or (p55.SearchKeyword ~= "" or (p55.MinPrice > CatalogConstants.MinPriceFilter or (p55.MaxPrice < CatalogConstants.MaxPriceFilter or p55.IncludeOffSale)))))
end

function t3.getSearchParamsAsQueryParams(p56, p57) -- line: 1162
	-- upvalues: FFlagAXAddHDCatalogTab (copy), CatalogConstants (copy)
	local t17 = {
		keyword = p56.SearchKeyword or "",
		limit = p56.Limit
	}

	if FFlagAXAddHDCatalogTab then
		if p57 and p57.CategoryFilter and (CatalogConstants.CategoryFilters[p57.CategoryFilter] == nil or p56.CategoryFilter ~= Enum.CatalogCategoryFilter.None) then
			t17.categoryFilter = p57.CategoryFilter
		end
	elseif p56.CategoryFilter ~= Enum.CatalogCategoryFilter.None and (p56.SortType == Enum.CatalogSortType.Relevance and (p56.CreatorName == "" and (p56.SalesTypeFilter == Enum.SalesTypeFilter.All and (p56.SearchKeyword == "" and (not (p56.MinPrice > CatalogConstants.MinPriceFilter) and (not (p56.MaxPrice < CatalogConstants.MaxPriceFilter) and not p56.IncludeOffSale)))))) then
		t17.categoryFilter = tostring(p56.CategoryFilter.Name)
	end

	t17.sortType = CatalogConstants.SortTypeAPIMap[tostring(p56.SortType.Name)]

	if p56.CreatorName and p56.CreatorName ~= "" then
		t17.creatorName = p56.CreatorName
	end

	if p57 and p57.TaxonomyUuid then
		t17.taxonomy = tostring(p57.TaxonomyUuid)
	else
		if p56.BundleTypes and #p56.BundleTypes > 0 then
			local t18 = {}

			for _, v295 in p56.BundleTypes do
				table.insert(t18, v295.Value)
			end

			t17.bundleTypeIds = t18
		end

		if p56.AssetTypes and #p56.AssetTypes > 0 then
			local t19 = {}

			for _, v298 in p56.AssetTypes do
				table.insert(t19, v298.Value)
			end

			t17.assetTypeIds = t19
		end
	end

	t17.includeNotForSale = p56.IncludeOffSale
	t17.creatorType = "All"

	if p56.MinPrice and p56.MinPrice > CatalogConstants.MinPriceFilter then
		t17.minPrice = p56.MinPrice
	end

	if p56.MaxPrice and p56.MaxPrice < CatalogConstants.MaxPriceFilter then
		t17.maxPrice = p56.MaxPrice
	end

	if p56.SalesTypeFilter and p56.SalesTypeFilter ~= Enum.SalesTypeFilter.All then
		t17.salesTypeFilter = tostring(p56.SalesTypeFilter.Name)
	end

	if p56.SortAggregation and (p56.SortType == Enum.CatalogSortType.MostFavorited or p56.SortType == Enum.CatalogSortType.Bestselling) then
		t17.sortAggregation = tostring(p56.SortAggregation.Name)
	end

	return t17
end
function t3.getSearchParams(p58, p59, b7: boolean?) -- line: 1257
	-- upvalues: v89 (copy), v90 (copy), v91 (copy), CatalogConstants (copy), v53 (copy), UnavailableItemFilter (copy), SalesTypeFilter (copy), FFlagAXRemoveTimedOptionsSalesTypeEnumCheck (copy), mutedError (copy), SortType (copy)
	v89(p58)
	v90(p59)

	local catalogSearchParams = CatalogSearchParams.new()
	local searchKeyword = nil

	if p58.searchKeyword then
		searchKeyword = p58.searchKeyword
	end

	catalogSearchParams.AssetTypes = {}
	catalogSearchParams.BundleTypes = {}
	catalogSearchParams.IncludeOffSale = false

	local v304 = false
	local SelectedTopics = p59.SelectedTopics

	if SelectedTopics and #SelectedTopics > 0 then
		v304 = true

		local v306 = table.concat(SelectedTopics, " ")

		if searchKeyword == nil then
			searchKeyword = v306
		else
			if #searchKeyword > 0 then
				searchKeyword ..= " "
			end

			searchKeyword ..= v306
		end
	end

	if searchKeyword then
		catalogSearchParams.SearchKeyword = searchKeyword
	end

	local n25 = 120

	if not searchKeyword and b7 then
		n25 = 30
	end

	catalogSearchParams.Limit = n25

	if p58.categoryInfo == nil then
		catalogSearchParams.CategoryFilter = Enum.CatalogCategoryFilter.None
		v91(catalogSearchParams, {}, {})
	else
		local CategoryFilter = p58.categoryInfo.CategoryFilter
		local v309 = CatalogConstants.CategoryFilters[CategoryFilter]

		if v309 == nil or v304 then
			catalogSearchParams.CategoryFilter = Enum.CatalogCategoryFilter.None
		else
			catalogSearchParams.CategoryFilter = v309
		end

		local AssetTypeIdStrings = p58.categoryInfo.AssetTypeIdStrings
		local BundleTypes = p58.categoryInfo.BundleTypes

		v91(catalogSearchParams, AssetTypeIdStrings, BundleTypes)
	end

	local minPrice = p59.PriceRange.minPrice
	local maxPrice = p59.PriceRange.maxPrice

	if v53 and minPrice and maxPrice and maxPrice < minPrice then
		local v314 = minPrice

		minPrice = maxPrice
		maxPrice = v314
	end

	if minPrice > CatalogConstants.MinPriceFilter then
		catalogSearchParams.MinPrice = minPrice
	end

	if maxPrice < CatalogConstants.MaxPriceFilter then
		catalogSearchParams.MaxPrice = maxPrice
	end

	local CatalogSort = p59.CatalogSort

	catalogSearchParams.SortType = Enum.CatalogSortType[CatalogSort]

	if p59.UnavailableItemFilter ~= UnavailableItemFilter.Hide then
		catalogSearchParams.IncludeOffSale = true
	end

	local SalesTypeFilter2 = p59.SalesTypeFilter

	if SalesTypeFilter2 ~= SalesTypeFilter.All then
		if not FFlagAXRemoveTimedOptionsSalesTypeEnumCheck then
			local ok = pcall(function() -- line: 1351
				local _ = Enum.SalesTypeFilter.TimedOptions
			end)

			if SalesTypeFilter2 == SalesTypeFilter.TimedOptions and not ok then
				mutedError("Referenced TimeOptions sales type but enum value is not present")
			else
				catalogSearchParams.SalesTypeFilter = Enum.SalesTypeFilter[SalesTypeFilter2]
			end
		else
			catalogSearchParams.SalesTypeFilter = Enum.SalesTypeFilter[SalesTypeFilter2]
		end
	end

	local CreatorFilter = p59.CreatorFilter

	if CreatorFilter ~= nil and CreatorFilter ~= "" then
		catalogSearchParams.CreatorName = CreatorFilter
	end

	if CatalogSort == SortType.MostFavorited or CatalogSort == SortType.Bestselling then
		catalogSearchParams.SortAggregation = Enum.CatalogSortAggregation[p59.CatalogSortAggregation]
	end

	if catalogSearchParams.SortType ~= Enum.CatalogSortType.Relevance or (catalogSearchParams.CreatorName ~= "" or (catalogSearchParams.SalesTypeFilter ~= Enum.SalesTypeFilter.All or (catalogSearchParams.SearchKeyword ~= "" or (catalogSearchParams.MinPrice > CatalogConstants.MinPriceFilter or (catalogSearchParams.MaxPrice < CatalogConstants.MaxPriceFilter or catalogSearchParams.IncludeOffSale))))) then
		catalogSearchParams.CategoryFilter = Enum.CatalogCategoryFilter.None
	end

	return catalogSearchParams
end
function t3.getWebAssetModelFromEquippedAssets(p60) -- line: 1397
	-- upvalues: Constants (copy)
	local t20 = {}

	for v321, v322 in p60 do
		local v323 = Constants.LayeredAssetTypes[v321] ~= nil

		for v324, v325 in v322 do
			table.insert(t20, {
				id = v324,
				meta = v323 and v325 or nil
			})
		end
	end

	return t20
end
function t3.createHumanoidDescriptionAccessoryInfo(p61, p62, p63) -- line: 1419
	-- upvalues: Constants (copy)
	local num = tonumber(p62)

	assert(num ~= nil, "assetIdAsNumber is not nil. Silence type checker.")

	return {
		AssetId = num,
		Order = p63.order,
		AccessoryType = p63.type or Constants.AssetTypeIdToAccessoryTypeEnum[p61],
		IsLayered = p63.isLayered,
		Position = p63.position,
		Rotation = p63.rotation,
		Scale = p63.scale
	}
end
function t3.createDefaultHumanoidDescriptionAccessoryInfo(p64, p65) -- line: 1441
	-- upvalues: mutedError (copy), Constants (copy)
	local num = tonumber(p65)

	if num == nil then
		mutedError("Called AvatarExperienceUtils.createDefaultHumanoidDescriptionAccessoryInfo with assetId that does not convert to string.")
		num = 0
	end

	assert(num, "assetIdAsNumber is non-nil: Silence type checker")

	return {
		AssetId = num,
		Order = Constants.LayeredClothingOrder[p64],
		AccessoryType = Constants.AssetTypeIdToAccessoryTypeEnum[p64],
		IsLayered = Constants.LayeredAssetTypes[p64] ~= nil
	}
end
function t3.getNewFullViewEnum(p66) -- line: 1466
	-- upvalues: FullView (copy)
	if p66 == FullView.None then
		return FullView.UIFullView
	end

	return FullView.None
end
function t3.getPartCFrame(p67, s21: string) -- line: 1474
	-- upvalues: Constants (copy)
	if p67 and p67:FindFirstChild(s21) then
		return p67[s21].CFrame
	end

	return CFrame.new(Constants.DefaultRigPosition)
end
function t3.getAttachmentCFrame(p68, s22: string, s23: string) -- line: 1482
	-- upvalues: FFlagAvatarJointUpgradeInUA (copy)
	if p68 and p68:FindFirstChild(s22) then
		local v339 = p68[s22]
		local v340 = if not FFlagAvatarJointUpgradeInUA then v339:FindFirstChild(s23) else nil

		if FFlagAvatarJointUpgradeInUA then
			for _, descendant in v339:GetDescendants() do
				if descendant:IsA("Attachment") and s23 == descendant.Name then
					v340 = descendant

					break
				end
			end
		end

		if v340 then
			if FFlagAvatarJointUpgradeInUA then
				return v340.WorldCFrame
			end

			return v339.CFrame * v340.CFrame
		end
	end

	return nil
end
function t3.getRecursiveAttachmentCFrame(p69) -- line: 1506
	local p69CFrame = p69.CFrame
	local p69Parent = p69.Parent

	while p69Parent and p69Parent:IsA("Bone") do
		p69CFrame = p69Parent.CFrame * p69CFrame
		p69Parent = p69Parent.Parent
	end

	return p69CFrame
end
function t3.isLCCategory(p70) -- line: 1521
	-- upvalues: Constants (copy)
	if p70 and p70.AssetTypeIdStrings then
		for _, v348 in p70.AssetTypeIdStrings do
			if Constants.LayeredAssetTypes[v348] ~= nil then
				if Constants.LayeredAssetTypes[v348] == Enum.AccessoryType.Hair then
					return false
				end

				return true
			end
		end
	end

	return false
end
function t3.isShoeBundle(p71) -- line: 1547
	-- upvalues: Constants (copy)
	return p71.bundleType == Constants.BundleTypeIdStrings.Shoes or p71.bundleType == Enum.BundleType.Shoes.Name
end
function t3.isBundleOrLCAsset(p72, p73) -- line: 1559
	-- upvalues: Constants (copy)
	local v352 = p72 == Constants.ItemType.Bundle

	return p72 == Constants.ItemType.Asset and Constants.LayeredAssetTypes[p73] ~= nil or v352
end
function t3.isBoundingBoxVectorSane(p74) -- line: 1571
	return p74.X <= 50000 and (p74.X >= -50000 and (p74.Y <= 50000 and (p74.Y >= -50000 and (p74.Z <= 50000 and p74.Z >= -50000))))
end
function t3.isBoundingBoxCFrameSane(p75) -- line: 1585
	-- upvalues: t3 (copy)
	return t3.isBoundingBoxVectorSane(p75.Position) and t3.isBoundingBoxVectorSane(p75.LookVector)
end
function t3.getAssetIdsWithGeometryFromHumanoidDescription(p76) -- line: 1595
	if p76 == nil then
		return {}
	end

	local t21 = {}

	for _, v358 in (p76:GetAccessories(true)) do
		if v358.AssetId then
			table.insert(t21, v358.AssetId)
		end
	end

	if p76.Torso then
		table.insert(t21, p76.Torso)
	end

	if p76.RightLeg then
		table.insert(t21, p76.RightLeg)
	end

	if p76.RightArm then
		table.insert(t21, p76.RightArm)
	end

	if p76.LeftLeg then
		table.insert(t21, p76.LeftLeg)
	end

	if p76.LeftArm then
		table.insert(t21, p76.LeftArm)
	end

	if p76.Head then
		table.insert(t21, p76.Head)
	end

	return t21
end
function t3.calculateNewAssetIdsWithGeometry(p77, p78) -- line: 1633
	-- upvalues: t3 (copy), Cryo (copy)
	if not p77 or not p78 then
		return {}
	end

	local v361 = t3.getAssetIdsWithGeometryFromHumanoidDescription(p77)
	local v362 = t3.getAssetIdsWithGeometryFromHumanoidDescription(p78)
	local v363 = Cryo.List.toSet(v361)

	return (Cryo.List.filter(v362, function(p79) -- line: 1644
		-- upvalues: v363 (copy)
		return v363[p79] == nil
	end))
end
function t3.getItemIconTypeFromOutfit(p80) -- line: 1650
	-- upvalues: Constants (copy), ItemTileEnums (copy)
	local v365 = p80.outfitType == Constants.OutfitTypes.DynamicHead
	local containsDynamicHead = p80.containsDynamicHead

	if v365 or containsDynamicHead then
		return ItemTileEnums.ItemIconType.DynamicHead
	end

	return nil
end
function t3.getItemStatusStyleFromOutfit(p81) -- line: 1661
	-- upvalues: ItemTileEnums (copy)
	local moderationStatus = p81.moderationStatus

	if moderationStatus == Enum.ModerationStatus.ReviewedRejected then
		return ItemTileEnums.StatusStyle.AlertIcon
	end

	if moderationStatus == Enum.ModerationStatus.NotReviewed then
		return ItemTileEnums.StatusStyle.PendingIcon
	end

	return nil
end
function t3.isModerationPendingOrRejected(p82) -- line: 1672
	return p82 == Enum.ModerationStatus.NotReviewed or p82 == Enum.ModerationStatus.ReviewedRejected
end
function t3.getMessageTypeFromModerationStatus(p83) -- line: 1677
	if not p83 then
		return nil
	end

	if p83 == Enum.ModerationStatus.NotReviewed then
		return "UnavailableItems"
	end

	if p83 == Enum.ModerationStatus.ReviewedRejected then
		return "ItemDidNotMeetRobloxCommunityStandards"
	end

	return nil
end
function t3.getModerationStatusFromAvailabilityStatus(p84) -- line: 1692
	-- upvalues: InventoryItemAvailability (copy)
	if not p84 then
		return nil
	end

	return ({
		[InventoryItemAvailability.Invalid] = Enum.ModerationStatus.Invalid,
		[InventoryItemAvailability.Available] = Enum.ModerationStatus.ReviewedApproved,
		[InventoryItemAvailability.Unavailable] = Enum.ModerationStatus.ReviewedRejected,
		[InventoryItemAvailability.Revoked] = Enum.ModerationStatus.NotApplicable,
		[InventoryItemAvailability.PartiallyAvailableWithUnavailableSubitems] = Enum.ModerationStatus.NotApplicable,
		[InventoryItemAvailability.PartiallyAvailableWithExpiredSubitems] = Enum.ModerationStatus.NotApplicable,
		[InventoryItemAvailability.Expired] = Enum.ModerationStatus.NotApplicable,
		[InventoryItemAvailability.PendingReview] = Enum.ModerationStatus.NotReviewed
	})[p84]
end
function t3.assetTypeIdIsAnimationOrEmote(p85) -- line: 1711
	-- upvalues: Constants (copy)
	if not p85 then
		return false
	end

	return Constants.AssetTypeIdToCategory[p85] == Constants.AssetCategories.Animation
end

local v93 = memoize(function(p86) -- line: 1721
	-- upvalues: Constants (copy)
	local v374 = p86 and p86[Constants.AssetTypeIdStrings.MoodAnimation]

	return v374 and next(v374)
end)

function t3.getEquippedMoodAssetId(p87) -- line: 1728
	-- upvalues: v93 (copy)
	local EquippedAssets = p87.AvatarExperience.AvatarEditor.Character.EquippedAssets

	return v93(EquippedAssets)
end
function t3.getAssetIdForPPEPose(p88) -- line: 1733
	-- upvalues: Constants (copy), t3 (copy)
	local AvatarExperience = p88.AvatarExperience

	for _, v380 in p88.AvatarExperience.AvatarScene.OutfitTryOn.TryOnItems do
		if v380.itemType == Constants.ItemType.Asset and t3.assetTypeIdIsAnimationOrEmote(v380.itemSubType) then
			return v380.itemId
		end
	end

	if AvatarExperience.ProfilePictureEditor.ProfilePictureParams.emoteAssetId then
		return AvatarExperience.ProfilePictureEditor.ProfilePictureParams.emoteAssetId
	end

	return nil
end

local v94 = memoize(function(p89) -- line: 1754
	-- upvalues: Constants (copy)
	return p89 and (p89[Constants.AssetTypeIdStrings.Gear] and next(p89[Constants.AssetTypeIdStrings.Gear]))
end)

function t3.getEquippedToolId(p90) -- line: 1761
	-- upvalues: v94 (copy)
	local EquippedAssets = p90.AvatarExperience.AvatarEditor.Character.EquippedAssets

	return v94(EquippedAssets)
end
function t3.getNextPageCursorKey(s24: string, b8: boolean, p91) -- line: 1770
	if b8 then
		return s24 .. (p91 or "")
	end

	return s24
end
function t3.getPerformFetchKey(s25: string, b9: boolean, p92) -- line: 1786
	-- upvalues: Constants (copy)
	if b9 then
		return Constants.OutfitsKey .. s25 .. (p92 or "")
	end

	return Constants.UserInventoryKey .. s25
end
function t3.getCurrentScreenIgnoreItemDetails(p93) -- line: 1802
	-- upvalues: AvatarScreen (copy)
	local name = p93.current.name

	if name == AvatarScreen.ItemDetails or (name == AvatarScreen.LookDetails or name == AvatarScreen.OutfitDetails) then
		name = p93.opaque.name
	end

	return name
end
function t3.getLargestPossibleOneLineTextSize(p94, p95, p96, n26: number) -- line: 1821
	-- upvalues: TextService (copy)
	local v396 = n26 - 1
	local vector2 = Vector2.new(v396, 100000)

	while p95 > 1 do
		local TextSize = TextService:GetTextSize(p94, p95, p96.Font, vector2)

		if TextSize.Y <= p95 + 1 then
			return Vector2.new(math.ceil(TextSize.X), (math.ceil(TextSize.Y))), p95
		end

		p95 -= 1
	end

	return nil, nil
end
function t3.selectSceneSize(p97) -- line: 1857
	-- upvalues: DeviceOrientationMode (copy), getSafeAreaSize (copy), Constants (copy)
	local GlobalGuiInset = p97.GlobalGuiInset
	local v401 = p97.DeviceOrientation == DeviceOrientationMode.Portrait
	local ScreenSize = p97.ScreenSize
	local YOffset = getSafeAreaSize(ScreenSize, GlobalGuiInset).Y.Offset
	local bottom = GlobalGuiInset.bottom
	local v405 = ScreenSize.Y - bottom
	local v406 = YOffset * Constants.PortraitSceneHeight
	local v407 = v401 and v406 or v405
	local v408 = ScreenSize.X * Constants.LandscapeSceneWidth

	return v407, v401 and ScreenSize.X or v408
end

t3.getColor3Difference = memoize(function(color3: Color3, color3_2: Color3) -- line: 1877
	return (math.sqrt((color3.R - color3_2.R) * (color3.R - color3_2.R) + (color3.G - color3_2.G) * (color3.G - color3_2.G) + (color3.B - color3_2.B) * (color3.B - color3_2.B)))
end)
t3.bodyColorToBodyColor3 = memoize(function(n27: number?) -- line: 1881
	if n27 then
		return BrickColor.new(n27).Color
	end

	return nil
end)
t3.bodyPartForSkinColoringIdToBodyColorId = {
	headColor3 = "headColorId",
	torsoColor3 = "torsoColorId",
	rightArmColor3 = "rightArmColorId",
	rightLegColor3 = "rightLegColorId",
	leftArmColor3 = "leftArmColorId",
	leftLegColor3 = "leftLegColorId"
}
t3.bodyColorIdToBodyPartForSkinColoringId = {}

for k, v in pairs(t3.bodyPartForSkinColoringIdToBodyColorId) do
	t3.bodyColorIdToBodyPartForSkinColoringId[v] = k
end

t3.convertBodyColor3sToHexes = memoize(function(p98) -- line: 1914
	local t22 = {}

	for k, v in pairs(p98) do
		t22[k] = v:ToHex()
	end

	return t22
end)
t3.convertBodyColor3HexesToColor3s = memoize(function(p99) -- line: 1932
	local t23 = {}

	for k, v in pairs(p99) do
		t23[k] = Color3.fromHex(v)
	end

	return t23
end)

function t3.isAvatarSceneButtonsVisible(p100, b10: boolean, b11: boolean, b12: boolean, p101) -- line: 1941
	-- upvalues: AvatarScreenProperties (copy)
	local v425 = (AvatarScreenProperties[p100.opaque.name] or {}).refinementButtonVisible and (not b11 and not b12)

	if p101 then
		return v425 and p101.state.key == p100.opaque.key
	end

	return v425 and b10
end
function t3.isUserCameraEligible() -- line: 1964
	-- upvalues: Cryo (copy), Players (copy), v46 (copy)
	local CameraDevices = game:GetService("VideoCaptureService"):GetCameraDevices()
	local v427 = Cryo.isEmpty(CameraDevices)

	assert(Players ~= nil, "Players should always be defined")

	return not (v427 or v46)
end
function t3.getUserId(p102) -- line: 1973
	if p102.LocalUserId then
		return p102.LocalUserId
	end

	if p102.RobloxUser and p102.RobloxUser.rbxuid then
		return (tostring(p102.RobloxUser.rbxuid))
	end

	return nil
end
function t3.isItemSelectable(p103) -- line: 1985
	if p103 == nil then
		return false
	end

	local noPriceStatus = p103.noPriceStatus

	if noPriceStatus == nil or noPriceStatus == "Free" then
		return true
	end

	if noPriceStatus == "Unavailable" then
		return false
	end

	if p103.quantityOwned > 0 then
		return true
	end

	return false
end
function t3.isTryingOnClassicFace(p104) -- line: 2003
	-- upvalues: Dash (copy), Constants (copy)
	return Dash.some(p104, function(p105) -- line: 2004
		-- upvalues: Constants (copy)
		return p105.itemType == "Asset" and p105.itemSubType == Constants.AssetTypeIdStrings.Face
	end)
end
function t3.isTryingOnDynamicHead(p106) -- line: 2009
	-- upvalues: Dash (copy), Constants (copy)
	return Dash.some(p106, function(p107) -- line: 2010
		-- upvalues: Constants (copy)
		return p107.itemType == "Bundle" and p107.itemSubType == Constants.BundleTypeIdStrings.DynamicHead
	end)
end

t3.getRecommendedAssetTypeIdStringFromCategoryInfo = memoize(function(p108) -- line: 2020
	if p108.RecommendedAssetTypeIdString then
		return p108.RecommendedAssetTypeIdString
	end

	if p108.AssetTypeIdStrings and #p108.AssetTypeIdStrings == 1 then
		return p108.AssetTypeIdStrings[1]
	end

	return nil
end)
t3.getRecommendedKey = memoize(function(p109) -- line: 2034
	-- upvalues: Constants2 (copy), t3 (copy), mutedError (copy), Constants (copy), FFlagAXAvatarTabLooksYouMayAlsoLike (copy), GetFFlagAXEnableRecommendationTypeAllInCustomize (copy)
	if p109.RecommendationsType == Constants2.RecommendationsType.Asset then
		local v435 = t3.getRecommendedAssetTypeIdStringFromCategoryInfo(p109)

		if not v435 then
			mutedError("called getRecommendedKey with a category with no assetTypeIdString")

			return Constants.AssetTypeIdStrings.Hat
		end

		return v435
	end

	if p109.RecommendationsType == Constants2.RecommendationsType.BodyParts then
		return Constants2.RecommendationsType.BodyParts
	end

	if FFlagAXAvatarTabLooksYouMayAlsoLike and p109.RecommendationsType == Constants2.RecommendationsType.AvatarLooks then
		return Constants2.RecommendationsType.AvatarLooks
	end

	if p109.RecommendationsType == Constants2.RecommendationsType.AvatarAnimations then
		return Constants2.RecommendationsType.AvatarAnimations
	end

	if p109.RecommendationsType == Constants2.RecommendationsType.Shoes then
		return Constants2.RecommendationsType.Shoes
	end

	if p109.RecommendationsType == Constants2.RecommendationsType.DynamicHeads then
		return Constants2.RecommendationsType.DynamicHeads
	end

	if GetFFlagAXEnableRecommendationTypeAllInCustomize() and p109.RecommendationsType == Constants2.RecommendationsType.All then
		return Constants2.RecommendationsType.All
	end

	return Constants2.RecommendationsType.None
end)
t3.getCategoryInfoByName = memoize(function(t24: {[any]: any}, s26: string, s27: string?) -- line: 2072
	-- upvalues: t3 (copy)
	local v439 = nil
	local v440 = nil

	for v441, v442 in t24 do
		if s26 == v442.Name then
			v439 = v441

			if not s27 or not v442.Subcategories then
				break
			end

			for v443, v444 in v442.Subcategories do
				if s27 == v444.Name then
					v440 = v443

					break
				end
			end

			assert(v440 ~= nil, "Could not find subcategory with name " .. s27)

			break
		end
	end

	assert(v439 ~= nil, "Could not find category with name  " .. s26)

	return (t3.getCategoryInfo(t24, v439, v440))
end)
t3.getAssetIdFromContent = memoize(function(s28: string?) -- line: 2101
	if s28 == nil then
		return nil
	end

	assert(s28, "contentId is not nil: silences type checker")

	local match = string.match(s28, ".*?id=([0-9]+)")

	if match then
		return match
	end

	return string.match(s28, "rbxassetid://([0-9]+)")
end)
t3.sortOutfitTryOnItemsByRecency = memoize(function(p110, b13: boolean) -- line: 2116
	local t25 = {}

	for _, v451 in p110 do
		table.insert(t25, v451)
	end

	table.sort(t25, function(p111, p112) -- line: 2123
		-- upvalues: b13 (copy)
		if p111.itemRecency and p112.itemRecency then
			if b13 then
				return p111.itemRecency > p112.itemRecency
			end

			return p111.itemRecency < p112.itemRecency
		end

		return false
	end)

	return t25
end)

function t3.fuzzyEq(n28: number, n29: number, n30: number?) -- line: 2138
	return (n30 or 0.001) > math.abs(n28 - n29)
end
function t3.getCreatorNameTileFooterEnabled(p113) -- line: 2143
	return p113 and (p113.customizedDataMap and p113.customizedDataMap.creatorNameTileFooterEnabled == "true")
end
function t3.translateString(s29: string, t26: {[any]: any}?) -- line: 2157
	-- upvalues: LocalizationService (copy), Localization (copy), mutedError (copy)
	local RobloxLocaleId = LocalizationService.RobloxLocaleId
	local v459 = Localization.new(RobloxLocaleId)

	v459:SetLocale(RobloxLocaleId)

	local ok, result = pcall(function() -- line: 2162
		-- upvalues: v459 (copy), s29 (copy), t26 (copy)
		return v459:Format(s29, t26)
	end)

	if ok then
		return result
	end

	mutedError("Failed to translate string with key: " .. s29)

	return ""
end
function t3.resolveEditorCategory(s30: string) -- line: 2180
	-- upvalues: GetAvatarEditorCategories (copy)
	for _, v464 in (GetAvatarEditorCategories()) do
		if s30 == v464.Id then
			return v464.Category, nil
		end

		if v464.Subcategories then
			for _, v466 in v464.Subcategories do
				if s30 == v466.Id then
					return v464.Category, v466.Subcategory
				end
			end
		end
	end

	return nil, nil
end

return t3
