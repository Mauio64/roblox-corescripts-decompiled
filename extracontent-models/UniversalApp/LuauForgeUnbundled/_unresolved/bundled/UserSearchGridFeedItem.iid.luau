local CorePackages = game:GetService("CorePackages")

local React = require(CorePackages.Packages.React)
local useSelector = require("@game/CorePackages/Workspace/Packages/RoactUtils").Hooks.RoactRodux.useSelector

local Responsive = require("@game/CorePackages/Workspace/Packages/Responsive")
local breakpointConfig = Responsive.BreakpointConfig
local screenSizeImpressionsTracker = require("@luauforge/bundled/edd").ScreenSizeImpressionsTracker
local appPage = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePromptLite/RobloxAppEnums").AppPage
local searchTypes = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePromptLite/RobloxAppEnums").SearchTypes
local SignalsReact = require(CorePackages.Packages.SignalsReact)
local module2 = require("@luauforge/bundled/edJ")
local collectionItemSize = module2.CollectionViewTypes.CollectionItemSize
local usePageSideMargin = module2.usePageSideMargin

local modules = require("@luauforge/bundled/dpZ").Modules
local omniFeedProps = modules.Personalization.OmniFeed.OmniFeedProps

local searchSelectionTypeHeader = modules.LuaApp.Components.Search.SearchTypeSelection.SearchSelectionTypeHeader
local useUpdateFeedItemRenderedRows = modules.Personalization.OmniFeed.DataStore.useUpdateFeedItemRenderedRows

local module3 = require("@luauforge/bundled/edF")
local analytics = module3.Analytics.Analytics

local fireImpressionEvent = module3.Analytics.fireImpressionEvent

local module4 = require("@luauforge/bundled/edE")

local fFlagLuaAppLayoutParamsInContext = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagLuaAppLayoutParamsInContext
local fFlagLuaAppCompositionAlways = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagLuaAppCompositionAlways

local fFlagLuaAppCompositionPlayerGrid = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagLuaAppCompositionPlayerGrid

local fFlagLuaAppSearchPeopleUnifiedSchemaFields = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagLuaAppSearchPeopleUnifiedSchemaFields
local defineFastFlag = game:DefineFastFlag("LuaAppUserSearchGridReactiveContainer", false)

local function UserSearchGridFeedItem(data)
	local ref = React.useRef(nil)

	local v5 = fFlagLuaAppCompositionAlways and true or data[omniFeedProps.key].appCompositionEnabled

	local v6 = useSelector(function(p2)
		return p2.UsersSearchResults[data.searchUuid]
	end)

	local v7 = useSelector(function(p2)
		return p2.ScreenSize
	end)
	local v8

	if not fFlagLuaAppCompositionAlways then
		if fFlagLuaAppLayoutParamsInContext then
			local sduiContext = data[omniFeedProps.key].sduiContext

			local xSmall = collectionItemSize.XSmall
			local v9 = React.useCallback(function(p2)
				return sduiContext.getPageLayoutConfig(xSmall)(p2).sideMargin
			end, { xSmall, sduiContext.getPageLayoutConfig })
			v8 = SignalsReact.useSignalState(v9)
		else
			v8 = usePageSideMargin(data[omniFeedProps.key].verticalScrollingFrameRef.current)
		end
	end

	local setState = nil
	local state

	if defineFastFlag then
		state, setState = React.useState(nil)
	elseif ref and ref.current then
		state = ref.current.AbsoluteSize or nil
	end

	local v9

	if v5 then
		v9 = not (state and state.X > 0) and 0 or state.X
	else
		v9 = not (state and state.X > 0) and 0 or state.X - 2 * v8
	end

	local vector2 = Vector2.new(v9, v7.Y)
	local feedItemPosition

	if fFlagLuaAppSearchPeopleUnifiedSchemaFields then
		feedItemPosition = data[omniFeedProps.key].feedItemPosition
	end

	local v12 = {
		userSearchSessionId = data.searchUuid,
		sortPosition = if fFlagLuaAppSearchPeopleUnifiedSchemaFields then feedItemPosition else nil,
		sortId = 0,
		pageContext = 0
	}

	local v14 = if fFlagLuaAppSearchPeopleUnifiedSchemaFields then data.topicId else nil
	v12.sortId = v14
	local v15 = if fFlagLuaAppSearchPeopleUnifiedSchemaFields then data[omniFeedProps.key].appPage else nil
	v12.pageContext = v15
	local v16 = analytics({ infoForAllEvents = v12 })

	local v17 = v7.X >= breakpointConfig.getMinWidthFor(Responsive.Keys.Large)
	local v18 = v7.X < breakpointConfig.getMinWidthFor(Responsive.Keys.Small)
	local v19 = (v17 or v18) and 1 or data.topicLayoutData.numOfRows

	if v19 < 0 then
		v19 = nil
	end

	local state2, setState2 = React.useState(1)
	local function fn(p2)
		setState2(p2)
	end

	if not fFlagLuaAppSearchPeopleUnifiedSchemaFields then
		feedItemPosition = data[omniFeedProps.key].feedItemPosition
	end

	local v20 = v6 and v6.entries and #v6.entries or 0

	local v21 = not (v20 and state2 and state2 > 0) and 0 or math.ceil(v20 / state2)

	if v19 and not (v19 < 0 or v21 < v19) then
		v21 = v19
	end

	local feedItemStartRow = data[omniFeedProps.key].feedItemStartRow
	useUpdateFeedItemRenderedRows(appPage.SearchPage, data.searchUuid, feedItemPosition, v21)

	local v22 = React.useCallback(function(p2)
		fireImpressionEvent({
			impressions = p2,
			entries = v6 and v6.entries or nil,
			startRowNumber = feedItemStartRow,
			itemsPerRow = state2
		}, v16.fireAnalyticsEvent)
	end, { v6, feedItemStartRow, state2, v16.fireAnalyticsEvent })

	local createElement = React.createElement
	local v24 = {
		Size = UDim2.new(1, 0, 1, 0),
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		ref = ref,
		[React.Change.AbsoluteSize] = defineFastFlag and function(p2)
			setState(p2.AbsoluteSize)
		end or nil
	}

	local children = {
		Layout = React.createElement("UIListLayout", {
			FillDirection = Enum.FillDirection.Vertical,
			HorizontalAlignment = Enum.HorizontalAlignment.Center,
			SortOrder = Enum.SortOrder.LayoutOrder,
			Padding = UDim.new(0, 16)
		}),
		UIPadding = 0,
		Header = 0,
		HydrationWrapper = 0,
		ScreenSizeImpressionsDetector = 0
	}

	local v25 = if not v5 then React.createElement("UIPadding", {
		PaddingLeft = UDim.new(0, v8),
		PaddingRight = UDim.new(0, v8)
	}) else nil
	children.UIPadding = v25

	local v26 = if data.topicLayoutData and data.topicLayoutData.showHeader then React.createElement(searchSelectionTypeHeader, {
		LayoutOrder = 1,
		selectionType = searchTypes.Players
	}) else nil
	children.Header = v26

	local createElement2 = React.createElement
	local v28 = {
		LayoutOrder = 2,
		horizontalAlignment = Enum.HorizontalAlignment.Left,
		windowSize = vector2,
		numberOfRowsToShow = v19,
		shouldUseCompactTiles = true,
		appCompositionEnabled = 0,
		searchParameters = 0,
		entries = 0,
		Analytics = 0,
		impressionsTag = "USERSEARCH_FEEDITEM_IMPRESSIONS",
		subpage = "UserSearchFeedItem",
		onItemsPerRowChanged = 0,
		startRowNumber = 0,
		itemsPerRow = 0
	}

	if not fFlagLuaAppCompositionPlayerGrid then
		v5 = nil
	end

	v28.appCompositionEnabled = v5
	v28.searchParameters = { searchKeyword = v6.keyword }
	v28.entries = v6.entries
	v28.Analytics = v16

	v28.onItemsPerRowChanged = fn
	v28.startRowNumber = feedItemStartRow
	v28.itemsPerRow = state2
	children.HydrationWrapper = createElement2(module4, v28)

	children.ScreenSizeImpressionsDetector = React.createElement(screenSizeImpressionsTracker, {
		parentRef = ref,
		pageContext = appPage.SearchPage,
		impressionsTag = "USERSEARCH_FEEDITEM_IMPRESSIONS",
		sendImpressions = v22,
		scrollViewPositionChangedSignal = data[omniFeedProps.key].scrollViewPositionChangedSignal
	})
	return createElement("Frame", v24, children)
end

return UserSearchGridFeedItem
