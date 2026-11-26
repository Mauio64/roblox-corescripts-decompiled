local CorePackages = game:GetService("CorePackages")

local React = require(CorePackages.Packages.React)
local RoactGamepad = require(CorePackages.Packages.RoactGamepad)
local useNavigation = require("@game/CorePackages/Workspace/Packages/Navigation").useNavigation
local useSelector = require("@game/CorePackages/Workspace/Packages/RoactUtils").Hooks.RoactRodux.useSelector
local useDispatch = require("@game/CorePackages/Workspace/Packages/RoactUtils").Hooks.RoactRodux.useDispatch
local getUseSelectorDeepEquals = require("@game/CorePackages/Workspace/Packages/AvatarExperienceCommon").Utils.getUseSelectorDeepEquals
local module = require("@luauforge/deferred/gPt")
local widgetHeader = module.WidgetComponents.WidgetHeader
local widgetLayout = module.WidgetComponents.WidgetLayout
local widgetListItem = module.WidgetComponents.WidgetListItem
local grid = module.GridComponents.Grid
local Foundation = require(CorePackages.Packages.Foundation)
local useTokens = Foundation.Hooks.useTokens
local AvatarExperienceFlags = require("@game/CorePackages/Workspace/Packages/AvatarExperienceFlags")
local fFlagAXCatalogCategoriesStoreImprovePerf = AvatarExperienceFlags.FFlagAXCatalogCategoriesStoreImprovePerf
local fFlagAXSubscriptionRefetchEvictStores = AvatarExperienceFlags.FFlagAXSubscriptionRefetchEvictStores

local module3 = require("@luauforge/bundled/dPR")

local module4 = require("@luauforge/bundled/fCe")
local module5 = require("@luauforge/bundled/dzD")
local module6 = require("@luauforge/bundled/dPU")
local module7 = require("@luauforge/deferred/hbA")
require("@luauforge/deferred/hfO")
local getFooterVisibilityFromItemFooters = require("@game/CorePackages/Workspace/Packages/AvatarExperienceCatalog").Utils.getFooterVisibilityFromItemFooters

local module8 = require("@luauforge/deferred/hbN")

local module9 = require("@luauforge/bundled/dWq")
local module10 = require("@luauforge/bundled/dWr")

return (React.forwardRef(function(props, p2)
	local v5 = RoactGamepad.useRefCache()
	local v6 = useNavigation()
	local v7 = useSelector(function(p3)
		return p3.Search.SearchesInCatalog[props.searchUuid]
	end, getUseSelectorDeepEquals())
	local v8 = useDispatch()
	local entryRowIndex = props.entryRowIndex

	local v9 = useSelector(function(p3)
		return p3.AvatarExperience.Common.Widgets.HydratedWidgetData.Look
	end, getUseSelectorDeepEquals())

	local row = props.row
	local itemsPerRow = props.itemsPerRow

	local key = v6.state.key
	local v10 = module5.ImpressionsEvents.AvatarItems .. (not key and "" or string.gsub(key, "[-{}]", ""))

	local keyword = v7 and v7.keyword
	local v11

	if fFlagAXCatalogCategoriesStoreImprovePerf then
		v11 = module8(
			props.fromSearch,
			props.selectedCategory,
			props.selectedSubcategory,
			props.selectedCategoryInfo
		)
	else
		v11 = module8(props.fromSearch)
	end

	local impressionsCategory = v11.impressionsCategory
	local impressionsSubcategory = v11.impressionsSubcategory
	local impressionsTaxonomyId = v11.impressionsTaxonomyId

	local v12 = module6.AnalyticsContext.Catalog

	if props.fromSearch then
		v12 = module6.AnalyticsContext.CatalogSearch
	end

	local v13 = if module10.isEnabled() then module3.readTestVariable(module10.EnabledForUser) else nil

	local useCallback = React.useCallback
	local function fn(p3)
		if p3 then
			if v13 and props.onThumbnailLoaded then
				props.onThumbnailLoaded(props.searchUuid, p3)
			else
				v8(module9.AppendThumbnail(props.searchUuid, p3))
			end
		end
	end

	local searchUuid = props.searchUuid
	local v15 = if v13 then props.onThumbnailLoaded else nil
	local v16 = useCallback(fn, { searchUuid, v15 })

	local creatorNameTileFooterEnabled = module4.getCreatorNameTileFooterEnabled(props.widgetConfiguration)

	local v18 = if props.template then props.template.itemFooters else nil
	local v19 = getFooterVisibilityFromItemFooters(v18)

	local v20 = useTokens()
	local v21 = React.useCallback(function(p3)
		if props.gamepadNavigationFocusPos:getValue().Y ~= props.entryRowIndex then
			return
		end

		props.setGamepadNavigationFocusPos(Vector2.new(p3, props.entryRowIndex))

		if props.onFocusGained then
			props.onFocusGained()
		end
	end, {
		props.gamepadNavigationFocusPos,
		props.setGamepadNavigationFocusPos,
		props.entryRowIndex,
		props.onFocusGained
	})

	local v22 = React.useCallback(function(p3)
		local index = p3.index
		local item = p3.item
		local createElement = React.createElement
		local frame = RoactGamepad.Focusable.Frame
		local v23 = {
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			Size = UDim2.fromScale(1, 0),
			AutomaticSize = Enum.AutomaticSize.Y,
			ref = v5[index],
			NextSelectionRight = 0,
			NextSelectionLeft = 0,
			onFocusGained = 0
		}
		local v24 = if index < itemsPerRow then v5[index + 1] else nil
		v23.NextSelectionRight = v24
		local v25 = if index > 1 then v5[index - 1] else nil
		v23.NextSelectionLeft = v25
		function v23.onFocusGained()
			v21(index)
		end

		local createElement2 = React.createElement
		local v28 = {
			analyticsContext = v12,
			analyticsItemCountPerPage = module6.PageFetchLimit,
			index = (entryRowIndex - 1) * itemsPerRow + index,
			itemType = item.type,
			itemId = item.id,
			adTrackingData = item.encryptedAdTrackingData,
			isSponsoredItem = false,
			cardStyle = props.cardStyle,
			itemDetailsPeekViewRefs = props.itemDetailsPeekViewRefs,
			resultsListRef = props.gridRef,
			impressionsTag = v10,
			impressionsSchema = "defaultItem",
			impressionsGroup = nil,
			impressionsSearch = keyword,
			impressionsCategory = impressionsCategory,
			impressionsSubcategory = impressionsSubcategory,
			impressionsTaxonomyId = impressionsTaxonomyId,
			impressionsId = item.id,
			gridInformation = {
				gridPositionRow = props.catalogRowIndex,
				gridPositionColumn = index
			},
			thumbailAspectRatio = props.thumbnailAspectRatio,
			thumbnailScaleType = props.thumbnailScaleType,
			thumbnailSize = item.type == "Look" and "w=300&h=450" or props.thumbnailSize,
			creatorNameTileFooterEnabled = creatorNameTileFooterEnabled,
			onThumbnailLoaded = v16,
			isCreatorNameVisible = v19.isCreatorNameVisible,
			isTitleVisible = v19.isTitleVisible,
			isPriceVisible = v19.isPriceVisible,
			lookData = 0,
			isOrganic = true
		}
		local v29

		if item.type == "Look" then
			if fFlagAXSubscriptionRefetchEvictStores then
				if v9 then
					v29 = v9[tostring(item.id)]
				end
			else
				v29 = v9[tostring(item.id)]
			end
		end

		v28.lookData = v29
		return createElement(frame, v23, {
			CatalogItemCard = createElement2(module7, v28)
		})
	end, {
		itemsPerRow,
		v21,
		v12,
		entryRowIndex,
		props.cardStyle,
		props.itemDetailsPeekViewRefs,
		props.gridRef,
		v10,
		keyword,
		impressionsCategory,
		impressionsSubcategory,
		"defaultItem",
		nil,
		props.thumbnailAspectRatio,
		props.thumbnailScaleType,
		props.thumbnailSize,
		creatorNameTileFooterEnabled,
		v16,
		v9
	})

	local element = React.createElement(grid, {
		itemsPerRow = itemsPerRow,
		getItemId = function(p3)
			return p3.id
		end,
		gapHorizontal = v20.Gap.Medium,
		gapVertical = v20.Gap.Large,
		Size = UDim2.fromScale(1, 0),
		AutomaticSize = Enum.AutomaticSize.Y,
		items = row,
		renderItem = v22
	})

	local createElement = React.createElement
	local v24 = {
		ref = p2,
		NextSelectionUp = props.NextSelectionUp,
		NextSelectionDown = props.NextSelectionDown,
		NextSelectionRight = props.NextSelectionRight,
		padding = props.padding,
		horizontalMargin = 0
	}

	local createElement2 = React.createElement
	local v28 = if props.descriptionKey or props.titleKey then React.createElement(widgetHeader, {
		descriptionText = props.descriptionText,
		descriptionKey = props.descriptionKey,
		titleKey = props.titleKey,
		titleText = props.titleText,
		LayoutOrder = 1
	}) else nil
	return createElement(widgetListItem, v24, {
		Widget = createElement2(widgetLayout, {
			headerSlot = v28,
			contentSlot = element
		})
	})
end))
