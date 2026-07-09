local CorePackages = game:GetService("CorePackages")
local React = require(CorePackages.Packages.React)
local useSelector = require(CorePackages.Workspace.Packages.RoactUtils).Hooks.RoactRodux.useSelector
local Responsive = require(CorePackages.Workspace.Packages.Responsive)
local BreakpointConfig = Responsive.BreakpointConfig
local ScreenSizeImpressionsTracker = require(CorePackages.Workspace.Packages.Impressions).ScreenSizeImpressionsTracker
local AppPage = require(CorePackages.Workspace.Packages.RobloxAppEnums).AppPage
local SearchTypes = require(CorePackages.Workspace.Packages.RobloxAppEnums).SearchTypes
local SignalsReact = require(CorePackages.Packages.SignalsReact)
local CollectionViews = require(CorePackages.Workspace.Packages.CollectionViews)
local CollectionItemSize = CollectionViews.CollectionViewTypes.CollectionItemSize
local usePageSideMargin = CollectionViews.usePageSideMargin
local Modules = require(CorePackages.Workspace.Packages.DiscoveryMonolith).Modules
local OmniFeedProps = Modules.Personalization.OmniFeed.OmniFeedProps
local SearchSelectionTypeHeader = Modules.LuaApp.Components.Search.SearchTypeSelection.SearchSelectionTypeHeader
local useUpdateFeedItemRenderedRows = Modules.Personalization.OmniFeed.DataStore.useUpdateFeedItemRenderedRows
local Modules2 = game:GetService("CoreGui").RobloxGui.Modules
local api = require(Modules2.LuaApp.Components.UserSearch.api)
local Analytics = api.Analytics.Analytics
local fireImpressionEvent = api.Analytics.fireImpressionEvent
local PlayerGridWithUserSearchHydrationLayerWrapper = require(Modules2.LuaApp.Components.UserSearch.Players.PlayerGridWithUserSearchHydrationLayerWrapper)
local FFlagLuaAppLayoutParamsInContext = require(CorePackages.Workspace.Packages.SharedFlags).FFlagLuaAppLayoutParamsInContext
local FFlagLuaAppCompositionAlways = require(CorePackages.Workspace.Packages.SharedFlags).FFlagLuaAppCompositionAlways
local FFlagLuaAppSearchPeopleUnifiedSchemaFields = require(CorePackages.Workspace.Packages.SharedFlags).FFlagLuaAppSearchPeopleUnifiedSchemaFields
local v25 = game:DefineFastFlag("LuaAppUserSearchGridReactiveContainer", false)

local function UserSearchGridFeedItem(t1: {[any]: any}) -- line: 47
	-- upvalues: React (copy), FFlagLuaAppCompositionAlways (copy), OmniFeedProps (copy), useSelector (copy), FFlagLuaAppLayoutParamsInContext (copy), CollectionItemSize (copy), SignalsReact (copy), usePageSideMargin (copy), v25 (copy), FFlagLuaAppSearchPeopleUnifiedSchemaFields (copy), Analytics (copy), BreakpointConfig (copy), Responsive (copy), useUpdateFeedItemRenderedRows (copy), AppPage (copy), fireImpressionEvent (copy), SearchSelectionTypeHeader (copy), SearchTypes (copy), PlayerGridWithUserSearchHydrationLayerWrapper (copy), ScreenSizeImpressionsTracker (copy)
	local v28 = React.useRef(nil)
	local v29 = not not FFlagLuaAppCompositionAlways or t1[OmniFeedProps.key].appCompositionEnabled
	local v30 = useSelector(function(p1) -- line: 54
		-- upvalues: t1 (copy)
		return p1.UsersSearchResults[t1.searchUuid]
	end)
	local v31 = useSelector(function(p2) -- line: 58
		return p2.ScreenSize
	end)
	local v32

	if FFlagLuaAppCompositionAlways then
		v32 = nil
	elseif FFlagLuaAppLayoutParamsInContext then
		local sduiContext = t1[OmniFeedProps.key].sduiContext
		local XSmall = CollectionItemSize.XSmall
		local v35 = React.useCallback(function(p3) -- line: 70
			-- upvalues: sduiContext (copy), XSmall (copy)
			return sduiContext.getPageLayoutConfig(XSmall)(p3).sideMargin
		end, {
			XSmall,
			sduiContext.getPageLayoutConfig
		})

		v32 = SignalsReact.useSignalState(v35)
	else
		v32 = usePageSideMargin(t1[OmniFeedProps.key].verticalScrollingFrameRef.current)
	end

	local u36 = nil
	local v37

	if v25 then
		local v38

		v37, v38 = React.useState(nil)
		u36 = v38
	else
		v37 = v28 and (not not v28.current and v28.current.AbsoluteSize) or nil
	end

	local v39 = if not v29 then (not v37 or not (v37.X > 0)) and 0 or v37.X - 2 * v32 else (not v37 or not (v37.X > 0)) and 0 or v37.X
	local vector2 = Vector2.new(v39, v31.Y)
	local feedItemPosition = nil

	if FFlagLuaAppSearchPeopleUnifiedSchemaFields then
		feedItemPosition = t1[OmniFeedProps.key].feedItemPosition
	end

	local v42 = Analytics({
		infoForAllEvents = {
			userSearchSessionId = t1.searchUuid,
			sortPosition = if not FFlagLuaAppSearchPeopleUnifiedSchemaFields then nil else feedItemPosition,
			sortId = if not FFlagLuaAppSearchPeopleUnifiedSchemaFields then nil else t1.topicId,
			pageContext = if not FFlagLuaAppSearchPeopleUnifiedSchemaFields then nil else t1[OmniFeedProps.key].appPage
		}
	})
	local v43 = v31.X >= BreakpointConfig.getMinWidthFor(Responsive.Keys.Large)
	local v44 = v31.X < BreakpointConfig.getMinWidthFor(Responsive.Keys.Small)
	local v45 = if not v43 and not v44 then t1.topicLayoutData.numOfRows else 1

	if v45 < 0 then
		v45 = nil
	end

	local v46, v47 = React.useState(1)

	if not FFlagLuaAppSearchPeopleUnifiedSchemaFields then
		feedItemPosition = t1[OmniFeedProps.key].feedItemPosition
	end

	local v48 = (not v30 or not v30.entries) and 0 or #v30.entries
	local v49 = (not v48 or (not v46 or not (v46 > 0))) and 0 or math.ceil(v48 / v46)
	local v50 = if not not v45 and (not (v45 < 0) and not (v49 < v45)) then v45 else v49
	local feedItemStartRow = t1[OmniFeedProps.key].feedItemStartRow

	useUpdateFeedItemRenderedRows(AppPage.SearchPage, t1.searchUuid, feedItemPosition, v50)

	local v52 = React.useCallback(function(p4) -- line: 146
		-- upvalues: fireImpressionEvent (copy), v30 (copy), feedItemStartRow (copy), v46 (copy), v42 (copy)
		fireImpressionEvent({
			impressions = p4,
			entries = v30 and v30.entries or nil,
			startRowNumber = feedItemStartRow,
			itemsPerRow = v46
		}, v42.fireAnalyticsEvent)
	end, {
		v30,
		feedItemStartRow,
		v46,
		v42.fireAnalyticsEvent
	})

	return React.createElement("Frame", {
		Size = UDim2.new(1, 0, 1, 0),
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		ref = v28,
		[React.Change.AbsoluteSize] = if not v25 then nil else function(p5) -- line: 168
			-- upvalues: u36 (ref)
			u36(p5.AbsoluteSize)
		end
	}, {
		Layout = React.createElement("UIListLayout", {
			FillDirection = Enum.FillDirection.Vertical,
			HorizontalAlignment = Enum.HorizontalAlignment.Center,
			SortOrder = Enum.SortOrder.LayoutOrder,
			Padding = UDim.new(0, 16)
		}),
		UIPadding = if v29 then nil else React.createElement("UIPadding", {
			PaddingLeft = UDim.new(0, v32),
			PaddingRight = UDim.new(0, v32)
		}),
		Header = if not t1.topicLayoutData or not t1.topicLayoutData.showHeader then nil else React.createElement(SearchSelectionTypeHeader, {
			LayoutOrder = 1,
			selectionType = SearchTypes.Players
		}),
		HydrationWrapper = React.createElement(PlayerGridWithUserSearchHydrationLayerWrapper, {
			LayoutOrder = 2,
			shouldUseCompactTiles = true,
			impressionsTag = "USERSEARCH_FEEDITEM_IMPRESSIONS",
			subpage = "UserSearchFeedItem",
			horizontalAlignment = Enum.HorizontalAlignment.Left,
			windowSize = vector2,
			numberOfRowsToShow = v45,
			searchParameters = {
				searchKeyword = v30.keyword
			},
			entries = v30.entries,
			Analytics = v42,
			onItemsPerRowChanged = function(p6) -- line: 120
				-- upvalues: v47 (copy)
				v47(p6)
			end,
			startRowNumber = feedItemStartRow,
			itemsPerRow = v46
		}),
		ScreenSizeImpressionsDetector = React.createElement(ScreenSizeImpressionsTracker, {
			impressionsTag = "USERSEARCH_FEEDITEM_IMPRESSIONS",
			parentRef = v28,
			pageContext = AppPage.SearchPage,
			sendImpressions = v52,
			scrollViewPositionChangedSignal = t1[OmniFeedProps.key].scrollViewPositionChangedSignal
		})
	})
end

return UserSearchGridFeedItem
