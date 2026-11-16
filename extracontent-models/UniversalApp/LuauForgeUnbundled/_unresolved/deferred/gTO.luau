local CorePackages = game:GetService("CorePackages")

local React = require(CorePackages.Packages.React)
local RoactGamepad = require(CorePackages.Packages.RoactGamepad)
local module = require("@luauforge/bundled/fTi")
local useNavigation = require("@game/CorePackages/Workspace/Packages/Navigation").useNavigation
local useSelector = require("@game/CorePackages/Workspace/Packages/RoactUtils").Hooks.RoactRodux.useSelector
local useDispatch = require("@game/CorePackages/Workspace/Packages/RoactUtils").Hooks.RoactRodux.useDispatch
local openInfoPeekView = require("@luauforge/bundled/fXq").OpenInfoPeekView
local isVRAppBuild = require("@game/CorePackages/Workspace/Packages/AppCommonLib").IsVRAppBuild
local avatarScreen = require("@game/CorePackages/Workspace/Packages/AvatarExperienceNavigation").Enums.AvatarScreen
local module2 = require("@luauforge/bundled/fuD")
local Foundation = require(CorePackages.Packages.Foundation)
local useTokens = Foundation.Hooks.useTokens
local getUseSelectorDeepEquals = require("@game/CorePackages/Workspace/Packages/AvatarExperienceCommon").Utils.getUseSelectorDeepEquals
local getFooterVisibilityFromItemFooters = require("@game/CorePackages/Workspace/Packages/AvatarExperienceCatalog").Utils.getFooterVisibilityFromItemFooters

local module3 = require("@luauforge/deferred/gPK")

local module4 = require("@luauforge/deferred/gTP")
local module5 = require("@luauforge/deferred/gPx")
local module6 = require("@luauforge/bundled/dwA")
local module7 = require("@luauforge/bundled/dME")
require("@luauforge/bundled/dMc")
local unifiedEventLogEnums = require("@game/CorePackages/Workspace/Packages/AvatarExperienceAnalytics").UnifiedEventLogEnums

local AvatarExperienceFlags = require("@game/CorePackages/Workspace/Packages/AvatarExperienceFlags")
local fFlagAXSponsoredItemsWidgetUnifiedLogging = AvatarExperienceFlags.FFlagAXSponsoredItemsWidgetUnifiedLogging
local fFlagAXCatalogRowFromListIndex = AvatarExperienceFlags.FFlagAXCatalogRowFromListIndex

local defineFastFlag = game:DefineFastFlag("AXFixSponsoredItemsWidgetRowFooters", false)

return (React.forwardRef(function(props, p2)
	local v5

	if defineFastFlag then
		local v7

		if props.widgetConfiguration and props.widgetConfiguration.defaultItemGroupTemplate then
			v7 = props.widgetConfiguration.defaultItemGroupTemplate.itemFooters
		end

		v5 = getFooterVisibilityFromItemFooters(v7)
	else
		v5 = nil
	end

	local v6 = useTokens()
	local v7 = RoactGamepad.useRefCache()
	local v8 = useSelector(function(p3)
		return p3.Search.SearchesInCatalog[props.searchUuid]
	end, getUseSelectorDeepEquals())
	local v9 = useNavigation()
	local itemsPerRow = props.itemsPerRow
	local v10

	if fFlagAXCatalogRowFromListIndex then
		v10 = props.listRowIndex or props.rowIndex
	else
		v10 = props.rowIndex
	end

	local key = v9.state.key
	local v11 = module6.ImpressionsEvents.AvatarItems .. (not key and "" or string.gsub(key, "[-{}]", ""))

	local keyword = v8 and v8.keyword
	local v12 = module7.AnalyticsContext.Catalog

	if props.fromSearch then
		v12 = module7.AnalyticsContext.CatalogSearch
	end

	local v13 = module({
		sponsored = "Feature.GamePage.Label.Sponsored",
		sponsoredDisclosure = "Feature.GamePage.Label.SponsoredDisclosure",
		gotIt = "Feature.Avatar.Action.GotIt"
	})

	local v14 = useDispatch()
	local function fn(p3, p4)
		v9.navigate(avatarScreen.GenericPrompt, {
			titleText = p3,
			bodyText = p4,
			buttonText = v13.gotIt
		})
	end
	local v15 = React.useCallback(function()
		if v14 and v13.sponsoredDisclosure then
			if isVRAppBuild() and fn then
				local sponsored = v13.sponsored
				local sponsoredDisclosure = v13.sponsoredDisclosure
				v9.navigate(avatarScreen.GenericPrompt, {
					titleText = sponsored,
					bodyText = sponsoredDisclosure,
					buttonText = v13.gotIt
				})
			else
				v14(openInfoPeekView(v13.sponsored, v13.sponsoredDisclosure))
			end
		end
	end, { v14, v13.sponsored, v13.sponsoredDisclosure })

	local v16 = module3(props.fromSearch)
	local impressionsCategory = v16.impressionsCategory
	local impressionsSubcategory = v16.impressionsSubcategory
	local impressionsTaxonomyId = v16.impressionsTaxonomyId

	local creatorNameTileFooterEnabled = module2.getCreatorNameTileFooterEnabled(props.widgetConfiguration)
	local v17

	if fFlagAXSponsoredItemsWidgetUnifiedLogging then
		local v18 = useSelector(function(p3)
			return p3.AvatarExperience.Catalog.SponsoredItems[module7.SponsoredItemsCategoryRecommended]
		end)

		v17 = React.useMemo(function()
			local ids = {}

			for i = 1, math.min(v18 and #v18 or 0, itemsPerRow) do
				table.insert(ids, (tostring(v18[i].id)))
			end

			return ids
		end, { v18, itemsPerRow })
	else
		v17 = nil
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
				local v18 = {
					Size = UDim2.fromScale(1, 0),
					AutomaticSize = Enum.AutomaticSize.Y,
					BackgroundTransparency = 1,
					ref = v7[index],
					NextSelectionRight = 0,
					NextSelectionLeft = 0,
					onFocusGained = 0
				}
				local v19 = if index < itemsPerRow then v7[index + 1] else nil
				v18.NextSelectionRight = v19
				local v20 = if index > 1 then v7[index - 1] else nil
				v18.NextSelectionLeft = v20
				function v18.onFocusGained()
					if props.gamepadNavigationFocusPos:getValue().Y ~= props.rowIndex then
						return
					end

					props.setGamepadNavigationFocusPos(Vector2.new(index, props.rowIndex))
				end

				local createElement2 = React.createElement
				local v23 = {
					analyticsContext = v12,
					analyticsItemCountPerPage = module7.PageFetchLimit,
					index = index,
					itemType = item.type,
					itemId = item.id,
					adTrackingData = item.encryptedAdTrackingData,
					isSponsoredItem = true,
					itemDetailsPeekViewRefs = props.itemDetailsPeekViewRefs,
					resultsListRef = props.gridRef,
					impressionsTag = v11,
					impressionsSchema = "defaultItem",
					impressionsGroup = nil,
					impressionsSearch = keyword,
					impressionsId = item.id,
					impressionsCategory = impressionsCategory,
					impressionsSubcategory = impressionsSubcategory,
					impressionsTaxonomyId = impressionsTaxonomyId,
					creatorNameTileFooterEnabled = creatorNameTileFooterEnabled,
					isCreatorNameVisible = 0,
					isTitleVisible = 0,
					isPriceVisible = 0,
					gridInformation = 0,
					isOrganic = 0,
					widgetAnalyticsInfo = 0
				}

				local v24 = if defineFastFlag then v5.isCreatorNameVisible else nil
				v23.isCreatorNameVisible = v24

				local v25 = if defineFastFlag then v5.isTitleVisible else nil
				v23.isTitleVisible = v25

				local v26 = if defineFastFlag then v5.isPriceVisible else nil
				v23.isPriceVisible = v26

				local v28 = if fFlagAXCatalogRowFromListIndex then v10 else props.rowIndex
				v23.gridInformation = {
					gridPositionRow = v28,
					gridPositionColumn = index
				}

				v23.isOrganic = not fFlagAXSponsoredItemsWidgetUnifiedLogging
				local v29

				if fFlagAXSponsoredItemsWidgetUnifiedLogging then
					v29 = {
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

					local v30 = if fFlagAXCatalogRowFromListIndex then v10 else props.rowIndex
					v29.widgetPosition = v30

					local v31 = if fFlagAXCatalogRowFromListIndex then (v10 - 1) * itemsPerRow else (props.rowIndex - 1) * itemsPerRow
					v29.widgetAbsPosition = v31

					v29.widgetItemIds = v17
					v29.itemId = tostring(item.id)
					v29.itemType = item.type
					v29.itemPosition = index

					local v32 = if fFlagAXCatalogRowFromListIndex then v10 else props.rowIndex
					v29.gridPositionRow = v32

					v29.gridPositionColumn = index
					v29.uiTreatmentType = unifiedEventLogEnums.WidgetUiTreatment.ITEM_GROUP
				end

				v23.widgetAnalyticsInfo = v29
				return createElement(frame, v18, {
					CatalogItemCard = createElement2(module5, v23)
				})
			end,
			sponsoredGridRef = p2,
			scrollingFrameRef = props.scrollingFrameRef,
			requestImpressionsSignal = props.requestImpressionsSignal,
			NextSelectionUp = props.NextSelectionUp,
			NextSelectionDown = props.NextSelectionDown,
			NextSelectionRight = props.NextSelectionRight,
			onFocusGained = props.onFocusGained,
			onActivateTooltipCallback = v15
		}),
		ManualPaddingFrame = React.createElement("Frame", {
			Size = UDim2.new(1, 0, 0, v6.Gap.Large),
			BackgroundTransparency = 1,
			LayoutOrder = 2
		})
	})
end))
