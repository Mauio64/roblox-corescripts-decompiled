local CorePackages = game:GetService("CorePackages")

local React = require(CorePackages.Packages.React)
local RoactGamepad = require(CorePackages.Packages.RoactGamepad)
local module = require("@luauforge/bundled/gxM")
local useNavigation = require("@game/CorePackages/Workspace/Packages/Navigation").useNavigation
local useSelector = require("@game/CorePackages/Workspace/Packages/RoactUtils").Hooks.RoactRodux.useSelector
local useDispatch = require("@game/CorePackages/Workspace/Packages/RoactUtils").Hooks.RoactRodux.useDispatch
local openInfoPeekView = require("@luauforge/bundled/gCm").OpenInfoPeekView
local isVRAppBuild = require("@game/CorePackages/Workspace/Packages/AppCommonLib").IsVRAppBuild
local avatarScreen = require("@game/CorePackages/Workspace/Packages/AvatarExperienceNavigation").Enums.AvatarScreen
local module2 = require("@luauforge/bundled/fCe")
local Foundation = require(CorePackages.Packages.Foundation)
local useTokens = Foundation.Hooks.useTokens
local getUseSelectorDeepEquals = require("@game/CorePackages/Workspace/Packages/AvatarExperienceCommon").Utils.getUseSelectorDeepEquals
local getFooterVisibilityFromItemFooters = require("@game/CorePackages/Workspace/Packages/AvatarExperienceCatalog").Utils.getFooterVisibilityFromItemFooters

local module3 = require("@luauforge/deferred/hbN")

local module4 = require("@luauforge/deferred/hfX")
local module5 = require("@luauforge/deferred/hbA")
local module6 = require("@luauforge/bundled/dzD")
local module7 = require("@luauforge/bundled/dPU")
require("@luauforge/bundled/dPs")
local unifiedEventLogEnums = require("@game/CorePackages/Workspace/Packages/AvatarExperienceAnalytics").UnifiedEventLogEnums

local AvatarExperienceFlags = require("@game/CorePackages/Workspace/Packages/AvatarExperienceFlags")
local fFlagAXSponsoredItemsWidgetUnifiedLogging = AvatarExperienceFlags.FFlagAXSponsoredItemsWidgetUnifiedLogging
local fFlagAXCatalogRowFromListIndex = AvatarExperienceFlags.FFlagAXCatalogRowFromListIndex

return (React.forwardRef(function(props, p2)
	local v6

	if props.widgetConfiguration and props.widgetConfiguration.defaultItemGroupTemplate then
		v6 = props.widgetConfiguration.defaultItemGroupTemplate.itemFooters
	end

	local v7 = getFooterVisibilityFromItemFooters(v6)

	local v8 = useTokens()
	local v9 = RoactGamepad.useRefCache()
	local v10 = useSelector(function(p3)
		return p3.Search.SearchesInCatalog[props.searchUuid]
	end, getUseSelectorDeepEquals())
	local v11 = useNavigation()
	local itemsPerRow = props.itemsPerRow
	local v12

	if fFlagAXCatalogRowFromListIndex then
		v12 = props.listRowIndex or props.rowIndex
	else
		v12 = props.rowIndex
	end

	local key = v11.state.key
	local v13 = module6.ImpressionsEvents.AvatarItems .. (not key and "" or string.gsub(key, "[-{}]", ""))

	local keyword = v10 and v10.keyword
	local v14 = module7.AnalyticsContext.Catalog

	if props.fromSearch then
		v14 = module7.AnalyticsContext.CatalogSearch
	end

	local v15 = module({
		sponsored = "Feature.GamePage.Label.Sponsored",
		sponsoredDisclosure = "Feature.GamePage.Label.SponsoredDisclosure",
		gotIt = "Feature.Avatar.Action.GotIt"
	})

	local v16 = useDispatch()
	local function fn(p3, p4)
		v11.navigate(avatarScreen.GenericPrompt, {
			titleText = p3,
			bodyText = p4,
			buttonText = v15.gotIt
		})
	end
	local v17 = React.useCallback(function()
		if v16 and v15.sponsoredDisclosure then
			if isVRAppBuild() and fn then
				local sponsored = v15.sponsored
				local sponsoredDisclosure = v15.sponsoredDisclosure
				v11.navigate(avatarScreen.GenericPrompt, {
					titleText = sponsored,
					bodyText = sponsoredDisclosure,
					buttonText = v15.gotIt
				})
			else
				v16(openInfoPeekView(v15.sponsored, v15.sponsoredDisclosure))
			end
		end
	end, { v16, v15.sponsored, v15.sponsoredDisclosure })

	local v18 = module3(props.fromSearch)
	local impressionsCategory = v18.impressionsCategory
	local impressionsSubcategory = v18.impressionsSubcategory
	local impressionsTaxonomyId = v18.impressionsTaxonomyId

	local creatorNameTileFooterEnabled = module2.getCreatorNameTileFooterEnabled(props.widgetConfiguration)
	local v19

	if fFlagAXSponsoredItemsWidgetUnifiedLogging then
		local v20 = useSelector(function(p3)
			return p3.AvatarExperience.Catalog.SponsoredItems[module7.SponsoredItemsCategoryRecommended]
		end)

		v19 = React.useMemo(function()
			local ids = {}

			for i = 1, math.min(v20 and #v20 or 0, itemsPerRow) do
				table.insert(ids, (tostring(v20[i].id)))
			end

			return ids
		end, { v20, itemsPerRow })
	else
		v19 = nil
	end

	return React.createElement(React.Fragment, nil, {
		UIListLayout = React.createElement("UIListLayout", {
			FillDirection = Enum.FillDirection.Vertical,
			SortOrder = Enum.SortOrder.LayoutOrder,
			HorizontalAlignment = Enum.HorizontalAlignment.Center
		}),
		SponsoredItems = React.createElement(module4, {
			LayoutOrder = 1,
			numItemsPerRow = itemsPerRow,
			renderItem = function(p3)
				local index = p3.index
				local item = p3.item
				local createElement = React.createElement
				local frame = RoactGamepad.Focusable.Frame
				local v20 = {
					Size = UDim2.fromScale(1, 0),
					AutomaticSize = Enum.AutomaticSize.Y,
					BackgroundTransparency = 1,
					ref = v9[index],
					NextSelectionRight = 0,
					NextSelectionLeft = 0,
					onFocusGained = 0
				}
				local v21 = if index < itemsPerRow then v9[index + 1] else nil
				v20.NextSelectionRight = v21
				local v22 = if index > 1 then v9[index - 1] else nil
				v20.NextSelectionLeft = v22
				function v20.onFocusGained()
					if props.gamepadNavigationFocusPos:getValue().Y ~= props.rowIndex then
						return
					end

					props.setGamepadNavigationFocusPos(Vector2.new(index, props.rowIndex))
				end

				local createElement2 = React.createElement
				local v25 = {
					analyticsContext = v14,
					analyticsItemCountPerPage = module7.PageFetchLimit,
					index = index,
					itemType = item.type,
					itemId = item.id,
					adTrackingData = item.encryptedAdTrackingData,
					isSponsoredItem = true,
					itemDetailsPeekViewRefs = props.itemDetailsPeekViewRefs,
					resultsListRef = props.gridRef,
					impressionsTag = v13,
					impressionsSchema = "defaultItem",
					impressionsGroup = nil,
					impressionsSearch = keyword,
					impressionsId = item.id,
					impressionsCategory = impressionsCategory,
					impressionsSubcategory = impressionsSubcategory,
					impressionsTaxonomyId = impressionsTaxonomyId,
					creatorNameTileFooterEnabled = creatorNameTileFooterEnabled,
					isCreatorNameVisible = v7.isCreatorNameVisible,
					isTitleVisible = v7.isTitleVisible,
					isPriceVisible = v7.isPriceVisible,
					gridInformation = 0,
					isOrganic = 0,
					widgetAnalyticsInfo = 0
				}

				local v27 = if fFlagAXCatalogRowFromListIndex then v12 else props.rowIndex
				v25.gridInformation = {
					gridPositionRow = v27,
					gridPositionColumn = index
				}

				v25.isOrganic = not fFlagAXSponsoredItemsWidgetUnifiedLogging
				local v28

				if fFlagAXSponsoredItemsWidgetUnifiedLogging then
					v28 = {
						requestId = props.searchUuid,
						widgetId = "SponsoredItemsWidget:" .. props.searchUuid,
						widgetType = "SponsoredItemsWidget",
						widgetPosition = 0,
						widgetAbsPosition = 0,
						widgetItemIds = 0,
						itemId = 0,
						itemType = 0,
						itemPosition = 0,
						gridPositionRow = 0,
						gridPositionColumn = 0,
						uiTreatmentType = 0
					}

					local v29 = if fFlagAXCatalogRowFromListIndex then v12 else props.rowIndex
					v28.widgetPosition = v29

					local v30 = if fFlagAXCatalogRowFromListIndex then (v12 - 1) * itemsPerRow else (props.rowIndex - 1) * itemsPerRow
					v28.widgetAbsPosition = v30

					v28.widgetItemIds = v19
					v28.itemId = tostring(item.id)
					v28.itemType = item.type
					v28.itemPosition = index

					local v31 = if fFlagAXCatalogRowFromListIndex then v12 else props.rowIndex
					v28.gridPositionRow = v31

					v28.gridPositionColumn = index
					v28.uiTreatmentType = unifiedEventLogEnums.WidgetUiTreatment.ITEM_GROUP
				end

				v25.widgetAnalyticsInfo = v28
				return createElement(frame, v20, {
					CatalogItemCard = createElement2(module5, v25)
				})
			end,
			sponsoredGridRef = p2,
			scrollingFrameRef = props.scrollingFrameRef,
			requestImpressionsSignal = props.requestImpressionsSignal,
			NextSelectionUp = props.NextSelectionUp,
			NextSelectionDown = props.NextSelectionDown,
			NextSelectionRight = props.NextSelectionRight,
			onFocusGained = props.onFocusGained,
			onActivateTooltipCallback = v17
		}),
		ManualPaddingFrame = React.createElement("Frame", {
			Size = UDim2.new(1, 0, 0, v8.Gap.Large),
			BackgroundTransparency = 1,
			LayoutOrder = 2
		})
	})
end))
