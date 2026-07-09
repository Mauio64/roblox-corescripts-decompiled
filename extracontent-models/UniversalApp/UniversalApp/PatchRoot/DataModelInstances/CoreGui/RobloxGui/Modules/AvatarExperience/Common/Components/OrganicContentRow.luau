local Modules = game:GetService("CoreGui").RobloxGui.Modules
local CorePackages = game:GetService("CorePackages")
local React = require(CorePackages.Packages.React)
local RoactGamepad = require(CorePackages.Packages.RoactGamepad)
local useNavigation = require(CorePackages.Workspace.Packages.Navigation).useNavigation
local useSelector = require(CorePackages.Workspace.Packages.RoactUtils).Hooks.RoactRodux.useSelector
local useDispatch = require(CorePackages.Workspace.Packages.RoactUtils).Hooks.RoactRodux.useDispatch
local getUseSelectorDeepEquals = require(CorePackages.Workspace.Packages.AvatarExperienceCommon).Utils.getUseSelectorDeepEquals
local AvatarExperienceUIKit = require(CorePackages.Workspace.Packages.AvatarExperienceUIKit)
local WidgetHeader = AvatarExperienceUIKit.WidgetComponents.WidgetHeader
local WidgetLayout = AvatarExperienceUIKit.WidgetComponents.WidgetLayout
local WidgetListItem = AvatarExperienceUIKit.WidgetComponents.WidgetListItem
local Grid = AvatarExperienceUIKit.GridComponents.Grid
local useTokens = require(CorePackages.Packages.Foundation).Hooks.useTokens
local AvatarExperienceFlags = require(CorePackages.Workspace.Packages.AvatarExperienceFlags)
local FFlagAXCatalogCategoriesStoreImprovePerf = AvatarExperienceFlags.FFlagAXCatalogCategoriesStoreImprovePerf
local FFlagAXSubscriptionRefetchEvictStores = AvatarExperienceFlags.FFlagAXSubscriptionRefetchEvictStores
local IxpUtils = require(CorePackages.Workspace.Packages.IxpUtils)
local Utils = require(Modules.AvatarExperience.Common.Utils)
local Constants = require(Modules.LuaApp.Constants)
local CatalogConstants = require(Modules.AvatarExperience.Catalog.CatalogConstants)
local CatalogItemCardContainer = require(Modules.AvatarExperience.Catalog.Components.ItemsList.CatalogItemCardContainer)

require(Modules.AvatarExperience.Common.Components.WidgetList.Types)

local getFooterVisibilityFromItemFooters = require(CorePackages.Workspace.Packages.AvatarExperienceCatalog).Utils.getFooterVisibilityFromItemFooters
local useCatalogCategoryImpressionsInfo = require(Modules.AvatarExperience.Catalog.Hooks.useCatalogCategoryImpressionsInfo)
local CatalogTilesLatencyTracker = require(Modules.AvatarExperience.Catalog.Actions.CatalogTilesLatencyTracker)
local GetFFlagEnableCatalogTileLoadingLatency = require(Modules.AvatarExperience.Flags.GetFFlagEnableCatalogTileLoadingLatency)
local AXCatalogPerfReduxReductionIXP = require(Modules.AvatarExperience.Experiments.AXCatalogPerfReduxReductionIXP)
local FFlagAXMigrateAXToGlobalAutofocus = require(CorePackages.Workspace.Packages.SharedFlags).FFlagAXMigrateAXToGlobalAutofocus

return (React.forwardRef(function(t1: {[any]: any}, p1) -- line: 102
	-- upvalues: RoactGamepad (copy), useNavigation (copy), useSelector (copy), getUseSelectorDeepEquals (copy), useDispatch (copy), FFlagAXMigrateAXToGlobalAutofocus (copy), Constants (copy), FFlagAXCatalogCategoriesStoreImprovePerf (copy), useCatalogCategoryImpressionsInfo (copy), CatalogConstants (copy), AXCatalogPerfReduxReductionIXP (copy), IxpUtils (copy), GetFFlagEnableCatalogTileLoadingLatency (copy), React (copy), CatalogTilesLatencyTracker (copy), Utils (copy), getFooterVisibilityFromItemFooters (copy), useTokens (copy), CatalogItemCardContainer (copy), FFlagAXSubscriptionRefetchEvictStores (copy), Grid (copy), WidgetListItem (copy), WidgetLayout (copy), WidgetHeader (copy)
	local v31 = RoactGamepad.useRefCache()
	local v32 = useNavigation()
	local v33 = useSelector(function(p2) -- line: 105
		-- upvalues: t1 (copy)
		return p2.Search.SearchesInCatalog[t1.searchUuid]
	end, getUseSelectorDeepEquals())
	local v34 = useDispatch()
	local v35 = if not FFlagAXMigrateAXToGlobalAutofocus then RoactGamepad.useFocusController() else nil
	local entryRowIndex = t1.entryRowIndex
	local v37 = useSelector(function(p3) -- line: 113
		return p3.AvatarExperience.Common.Widgets.HydratedWidgetData.Look
	end, getUseSelectorDeepEquals())
	local row = t1.row
	local itemsPerRow = t1.itemsPerRow
	local key = v32.state.key
	local v41 = Constants.ImpressionsEvents.AvatarItems .. (not key and "" or string.gsub(key, "[-{}]", ""))
	local v42 = v33 and v33.keyword
	local v43 = if not FFlagAXCatalogCategoriesStoreImprovePerf then useCatalogCategoryImpressionsInfo(t1.fromSearch) else useCatalogCategoryImpressionsInfo(t1.fromSearch, t1.selectedCategory, t1.selectedSubcategory, t1.selectedCategoryInfo)
	local impressionsCategory = v43.impressionsCategory
	local impressionsSubcategory = v43.impressionsSubcategory
	local impressionsTaxonomyId = v43.impressionsTaxonomyId
	local Catalog = CatalogConstants.AnalyticsContext.Catalog

	if t1.fromSearch then
		Catalog = CatalogConstants.AnalyticsContext.CatalogSearch
	end

	local v48 = if not AXCatalogPerfReduxReductionIXP.isEnabled() then nil else IxpUtils.readTestVariable(AXCatalogPerfReduxReductionIXP.EnabledForUser)
	local v49 = if not GetFFlagEnableCatalogTileLoadingLatency() then nil else React.useCallback(function(p4) -- line: 149
		-- upvalues: v48 (copy), t1 (copy), v34 (copy), CatalogTilesLatencyTracker (copy)
		if p4 then
			if v48 and t1.onThumbnailLoaded then
				t1.onThumbnailLoaded(t1.searchUuid, p4)

				return
			end

			v34(CatalogTilesLatencyTracker.AppendThumbnail(t1.searchUuid, p4))
		end
	end, {
		t1.searchUuid,
		if not v48 then nil else t1.onThumbnailLoaded
	})
	local v50 = Utils.getCreatorNameTileFooterEnabled(t1.widgetConfiguration)
	local v51 = getFooterVisibilityFromItemFooters(if not t1.template then nil else t1.template.itemFooters)
	local v52 = useTokens()
	local v53 = React.useCallback(function(p5) -- line: 173
		-- upvalues: t1 (copy)
		if t1.gamepadNavigationFocusPos:getValue().Y ~= t1.entryRowIndex then
			return
		end

		t1.setGamepadNavigationFocusPos(Vector2.new(p5, t1.entryRowIndex))

		if t1.onFocusGained then
			t1.onFocusGained()
		end
	end, {
		t1.gamepadNavigationFocusPos,
		t1.setGamepadNavigationFocusPos,
		t1.entryRowIndex,
		t1.onFocusGained
	})
	local v54 = React.useCallback(function(t2: {[any]: any}) -- line: 190
		-- upvalues: React (copy), RoactGamepad (copy), v31 (copy), itemsPerRow (copy), v53 (copy), CatalogItemCardContainer (copy), Catalog (ref), CatalogConstants (copy), entryRowIndex (copy), t1 (copy), v41 (copy), v42 (copy), impressionsCategory (ref), impressionsSubcategory (ref), impressionsTaxonomyId (ref), v50 (copy), v49 (copy), v51 (copy), FFlagAXSubscriptionRefetchEvictStores (copy), v37 (copy)
		local index = t2.index
		local item = t2.item

		return React.createElement(RoactGamepad.Focusable.Frame, {
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			Size = UDim2.fromScale(1, 0),
			AutomaticSize = Enum.AutomaticSize.Y,
			ref = v31[index],
			NextSelectionRight = if not (index < itemsPerRow) then nil else v31[index + 1],
			NextSelectionLeft = if not (index > 1) then nil else v31[index - 1],
			onFocusGained = function() -- line: 201
				-- upvalues: v53 (copy), index (copy)
				v53(index)
			end
		}, {
			CatalogItemCard = React.createElement(CatalogItemCardContainer, {
				isSponsoredItem = false,
				impressionsSchema = "defaultItem",
				impressionsGroup = nil,
				isOrganic = true,
				analyticsContext = Catalog,
				analyticsItemCountPerPage = CatalogConstants.PageFetchLimit,
				index = (entryRowIndex - 1) * itemsPerRow + index,
				itemType = item.type,
				itemId = item.id,
				adTrackingData = item.encryptedAdTrackingData,
				cardStyle = t1.cardStyle,
				itemDetailsPeekViewRefs = t1.itemDetailsPeekViewRefs,
				resultsListRef = t1.gridRef,
				impressionsTag = v41,
				impressionsSearch = v42,
				impressionsCategory = impressionsCategory,
				impressionsSubcategory = impressionsSubcategory,
				impressionsTaxonomyId = impressionsTaxonomyId,
				impressionsId = item.id,
				gridInformation = {
					gridPositionRow = t1.catalogRowIndex,
					gridPositionColumn = index
				},
				thumbailAspectRatio = t1.thumbnailAspectRatio,
				thumbnailScaleType = t1.thumbnailScaleType,
				thumbnailSize = if item.type ~= "Look" then t1.thumbnailSize else "w=300&h=450",
				creatorNameTileFooterEnabled = v50,
				onThumbnailLoaded = v49,
				isCreatorNameVisible = v51.isCreatorNameVisible,
				isTitleVisible = v51.isTitleVisible,
				isPriceVisible = v51.isPriceVisible,
				lookData = if item.type ~= "Look" then nil else if not FFlagAXSubscriptionRefetchEvictStores then v37[tostring(item.id)] else if not v37 then nil else v37[tostring(item.id)]
			})
		})
	end, {
		itemsPerRow,
		v53,
		Catalog,
		entryRowIndex,
		t1.cardStyle,
		t1.itemDetailsPeekViewRefs,
		t1.gridRef,
		v41,
		v42,
		impressionsCategory,
		impressionsSubcategory,
		"defaultItem",
		nil,
		t1.thumbnailAspectRatio,
		t1.thumbnailScaleType,
		t1.thumbnailSize,
		v50,
		v49,
		v37
	})
	local v55 = React.createElement(Grid, {
		itemsPerRow = itemsPerRow,
		getItemId = function(p6) -- line: 276
			return p6.id
		end,
		gapHorizontal = v52.Gap.Medium,
		gapVertical = v52.Gap.Large,
		Size = UDim2.fromScale(1, 0),
		AutomaticSize = Enum.AutomaticSize.Y,
		items = row,
		renderItem = v54
	})

	return React.createElement(WidgetListItem, {
		horizontalMargin = 0,
		ref = p1,
		NextSelectionUp = t1.NextSelectionUp,
		NextSelectionDown = t1.NextSelectionDown,
		NextSelectionRight = t1.NextSelectionRight,
		onFocusGained = not FFlagAXMigrateAXToGlobalAutofocus and function() -- line: 293
			-- upvalues: t1 (copy), v31 (copy), row (copy), v35 (copy)
			t1.setGamepadNavigationFocusPos(Vector2.new(t1.gamepadNavigationFocusPos:getValue().X, t1.entryRowIndex))

			local v64 = v31[math.min(t1.gamepadNavigationFocusPos:getValue().X, #row)]

			v35.moveFocusTo(v64)
		end or nil,
		padding = t1.padding
	}, {
		Widget = React.createElement(WidgetLayout, {
			headerSlot = if not t1.descriptionKey and not t1.titleKey then nil else React.createElement(WidgetHeader, {
				LayoutOrder = 1,
				descriptionText = t1.descriptionText,
				descriptionKey = t1.descriptionKey,
				titleKey = t1.titleKey,
				titleText = t1.titleText
			}),
			contentSlot = v55
		})
	})
end))
