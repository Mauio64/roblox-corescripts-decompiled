local HttpService = game:GetService("HttpService")

local Cryo = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/Cryo")
local Roact = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/Roact")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/React")
local roactPaginator = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/SocialLibraries").RoactPaginator
local searchFilterPredicate = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/SocialLibraries").Utils.searchFilterPredicate
local memoize = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppCommonLib").memoize

local withAnalytics = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/LegacyAnalytics/withAnalytics")
local withTelemetry = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Telemetry/withTelemetry")

local FFlagAppChatPerfTracking = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Flags/FFlagAppChatPerfTracking")
local AppChatPerfTracker = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Telemetry/AppChatPerfTracker")

local ChatLandingTelemetryEvents = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Components/ChatLanding/ChatLandingTelemetryEvents")
local ChatConversationTelemetryLayer = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Telemetry/Layers/ChatConversationTelemetryLayer")
local Display = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/Display")
local useSignalState = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/SignalsReact").useSignalState
local Responsive = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/Responsive")
local useAnimateScrollViewToSelection = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppBlox").useAnimateScrollViewToSelection

local SharedFlags = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/SharedFlags")
local fFlagAppIaScrollAway = SharedFlags.FFlagAppIaScrollAway
local fFlagEnableStickyShortcutBarOnAllPlatforms = SharedFlags.FFlagEnableStickyShortcutBarOnAllPlatforms
local getShortcutBarStatusStore

if fFlagEnableStickyShortcutBarOnAllPlatforms then
	getShortcutBarStatusStore = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppShortcutBar").GetShortcutBarStatusStore
else
	getShortcutBarStatusStore = nil
end

local partyPageCarouselExperimentation = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/SocialExperiments").PartyPageCarouselExperimentation

local SignalsMigrationConfig = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Flags/SignalsMigrationConfig")
local FFlagAppChatConsoleFocusFixes = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Flags/FFlagAppChatConsoleFocusFixes")
local FFlagAppChatKeepConversationListScrollOnVR = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Flags/FFlagAppChatKeepConversationListScrollOnVR")
local FFlagAppChatUseViewRecyclerConversationList = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Flags/FFlagAppChatUseViewRecyclerConversationList")

local extended = Roact.PureComponent:extend("ConversationListWithTopBar")
local shouldUseFoundationConversationRow = SignalsMigrationConfig.shouldUseFoundationConversationRow
local v5 = shouldUseFoundationConversationRow and FFlagAppChatUseViewRecyclerConversationList
local ConversationList = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Components/ChatLanding/ConversationList")
local SearchLoading = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Components/ChatLanding/SearchLoading")
local SearchNoResults = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Components/ChatLanding/SearchNoResults")
local flag = false
local conversationListViewRecycler = nil

local function getConversationListViewRecycler()
	if flag then
		return conversationListViewRecycler
	end

	flag = true
	local success, result = pcall(function()
		return require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Components/ChatLanding/ConversationListViewRecycler")
	end)

	if success then
		conversationListViewRecycler = result
	end

	return conversationListViewRecycler
end

extended.defaultProps = {
	filterText = nil,
	isDebugEnabled = false,
	itemList = {},
	navigateToSquadLobby = function() end,
	topBarHeight = 0,
	entryHeight = 64,
	canvasTopPadding = fFlagAppIaScrollAway and 0 or nil,
	canAccessParty = false,
	isPartyQuickStartEnabled = false,
	isSearchActive = false
}

function extended.getDerivedStateFromProps(data)
	local filterText = data.filterText
	local itemList = data.itemList

	if data.isSearchActive then
		return { filteredItemList = itemList }
	end

	return {
		filteredItemList = Cryo.List.filterMap(itemList, function(p2)
			if searchFilterPredicate(filterText, p2.title) then
				return p2
			end

			return nil
		end)
	}
end

function extended:init()
	function self.showErrorToast(p2)
		self.props.navigateToToast({
			toastProps = {
				toastContent = { toastTitle = p2 }
			}
		})
	end

	function self.reportAnalytics(object)
		if not (self.props.conversationsIsFetching or self.props.oldestConversationIsFetched) then
			object:userFetchedOlderConversations(self.props.localUserId)
		end
	end

	self.loadNext = memoize(function(p2)
		return function(p3)
			if self.props[roactPaginator.loadNext] then
				self.reportAnalytics(p2)

				if FFlagAppChatPerfTracking then
					AppChatPerfTracker.start(AppChatPerfTracker.Events.PaginationConversationList)
				end

				self.props[roactPaginator.loadNext](p3)
			end
		end
	end)

	self.isFiltered = self.props.filterText and self.props.filterText:match("%S")

	self.indexOfList = memoize(function(p2, p3)
		local index = table.find(Cryo.List.map(p2, function(p4)
			return p4.id
		end), p3)

		if index then
			return index
		end

		return 0
	end)

	function self.formatParticipantIds(options)
		local filterMap = Cryo.List.filterMap(options or {}, function(p2)
			if p2.id then
				return (tonumber(p2.id))
			end

			return nil
		end)

		local success, result = pcall(function()
			return HttpService:JSONEncode(filterMap)
		end)

		if success then
			return result
		end

		return "[]"
	end

	function self.fireClickEvent(data, p2, osaImpressionId)
		local id = data.id
		local emit = p2.emit
		local conversationClicked = ChatLandingTelemetryEvents.ConversationClicked
		local v6 = {
			isFiltered = self.isFiltered ~= nil,
			conversationListCount = #self.state.filteredItemList,
			selectedConversationId = id,
			selectedIndex = self.indexOfList(self.state.filteredItemList, id),
			hasUnreadMessages = data.hasUnreadMessages,
			selectedConversationModerationType = 0,
			selectedConversationUserPendingStatus = 0,
			participantUserIds = 0,
			osaAcknowledgementStatus = 0,
			osaImpressionId = 0
		}
		local v7 = if data then data.moderationType else nil
		v6.selectedConversationModerationType = v7
		local v8 = if data then data.userPendingStatus else nil
		v6.selectedConversationUserPendingStatus = v8
		v6.participantUserIds = self.formatParticipantIds(data.participants)
		v6.osaAcknowledgementStatus = data.osaAcknowledgementStatus
		v6.osaImpressionId = osaImpressionId
		emit(conversationClicked, v6)

		p2.emit(ChatLandingTelemetryEvents.ConversationClickedIndexStat, {
			statValue = self.indexOfList(self.state.filteredItemList, id) or 0
		})
	end

	self.fireConversationImpressionEvent = memoize(function(p2)
		return function(data)
			local id = data.id

			p2.emit(ChatLandingTelemetryEvents.ConversationCellRendered, {
				isFiltered = self.isFiltered ~= nil,
				conversationListCount = #self.state.filteredItemList,
				selectedConversationId = id,
				selectedIndex = self.indexOfList(self.state.filteredItemList, id),
				hasUnreadMessages = data.hasUnreadMessages,
				selectedConversationModerationType = data.moderationType,
				selectedConversationUserPendingStatus = data.userPendingStatus,
				participantUserIds = self.formatParticipantIds(data.participants),
				osaAcknowledgementStatus = data.osaAcknowledgementStatus
			})

			p2.emit(ChatLandingTelemetryEvents.ConversationCellRenderedIndexStat, {
				statValue = self.indexOfList(self.state.filteredItemList, id) or 0
			})
		end
	end)

	function self.onActivated(p2)
		if FFlagAppChatPerfTracking then
			AppChatPerfTracker.start(AppChatPerfTracker.Events.ChatConversationTTI, {
				conversationId = tostring(p2.id)
			})
		end

		self.props.navigateToConversation(p2.id)
	end
end

function extended.render(data)
	return withAnalytics(function(p2)
		return withTelemetry(ChatConversationTelemetryLayer.Context)(function(p3)
			local v6 = data.props.filterText and data.props.filterText:match("%S")
			local v7

			if fFlagEnableStickyShortcutBarOnAllPlatforms then
				v7 = data.props.isShortcutBarVisible
			else
				v7 = false
			end

			local v8 = {
				Size = UDim2.fromScale(1, 1),
				itemList = v6 and data.state.filteredItemList or data.props.itemList,
				loadNext = data.loadNext(p2),
				isDebugEnabled = data.props.isDebugEnabled,
				isWideMode = 0,
				filterText = 0,
				onActivated = 0,
				entryHeight = 0,
				navigateToSquadLobby = 0,
				isInExperience = 0,
				localUserId = 0,
				navigateToConversationFromUserId = 0,
				navigateToQuickStartSquadInviteFriends = 0,
				shouldShowPhoneVerificationUpsell = 0,
				shouldShowUnfilteredAccessFtux = 0,
				shouldShowPartyUpsellFtux = 0,
				dismissUnfilteredThreadsFtux = 0,
				showGroupsLink = 0,
				listRef = 0,
				canvasTopPadding = 0,
				pageBackgroundTransparency = 0,
				canvasBottomPadding = 0,
				scrollEnabled = 0,
				fireConversationImpressionEvent = 0,
				isPartyQuickStartEnabled = 0,
				fireConversationClickedEvent = 0
			}
			local v9 = if partyPageCarouselExperimentation.getPartyPageCarouselEnabled() or shouldUseFoundationConversationRow then data.props.isWideMode else nil
			v8.isWideMode = v9

			v8.filterText = data.props.filterText
			v8.onActivated = data.onActivated
			v8.entryHeight = data.props.entryHeight
			v8.navigateToSquadLobby = data.props.navigateToSquadLobby
			v8.isInExperience = data.props.isInExperience
			v8.localUserId = data.props.localUserId
			local v10 = if partyPageCarouselExperimentation.getPartyPageCarouselEnabled() then data.props.navigateToConversationFromUserId else nil
			v8.navigateToConversationFromUserId = v10

			local v11 = if partyPageCarouselExperimentation.getPartyPageCarouselEnabled() then data.props.navigateToQuickStartSquadInviteFriends else nil
			v8.navigateToQuickStartSquadInviteFriends = v11

			v8.shouldShowPhoneVerificationUpsell = data.props.shouldShowPhoneVerificationUpsell
			v8.shouldShowUnfilteredAccessFtux = data.props.shouldShowUnfilteredAccessFtux
			v8.shouldShowPartyUpsellFtux = data.props.shouldShowPartyUpsellFtux
			v8.dismissUnfilteredThreadsFtux = data.props.dismissUnfilteredThreadsFtux
			v8.showGroupsLink = data.props.showGroupsLink
			local v12 = if FFlagAppChatConsoleFocusFixes then data.props.listRef else nil
			v8.listRef = v12
			local v13 = if fFlagAppIaScrollAway then data.props.canvasTopPadding else nil
			v8.canvasTopPadding = v13
			v8.pageBackgroundTransparency = data.props.pageBackgroundTransparency

			local v14 = if FFlagAppChatConsoleFocusFixes and not data.props.isInExperience and not (fFlagEnableStickyShortcutBarOnAllPlatforms and v7) then data.props.deviceSafePadding.bottom else nil
			v8.canvasBottomPadding = v14

			local v15 = if FFlagAppChatConsoleFocusFixes then data.props.scrollEnabled else nil
			v8.scrollEnabled = v15
			v8.fireConversationImpressionEvent = data.fireConversationImpressionEvent(p3)
			v8.isPartyQuickStartEnabled = data.props.isPartyQuickStartEnabled
			v8.fireConversationClickedEvent = data.fireClickEvent

			if shouldUseFoundationConversationRow then
				v8.canAccessParty = data.props.canAccessParty
			end

			if v5 then
				v8.isLoadingNext = data.props.conversationsIsFetching
				v8.isLoadingPrevious = data.props.conversationsIsFetching
				v8.oldestConversationIsFetched = data.props.oldestConversationIsFetched
			end

			local v16 = ConversationList

			if v5 then
				if not flag then
					flag = true
					local success, result = pcall(function()
						return require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Components/ChatLanding/ConversationListViewRecycler")
					end)

					if success then
						conversationListViewRecycler = result
					end
				end

				v16 = conversationListViewRecycler or ConversationList
			end

			local v17 = Roact.createElement(v16, v8)

			if
				data.props.isSearchActive
				and data.props.isSearchAwaitingResults
				and #data.props.itemList == 0
			then
				v17 = Roact.createElement(SearchLoading, {
					entryHeight = data.props.entryHeight,
					topPadding = data.props.canvasTopPadding
				})
			elseif
				data.props.isSearchActive
				and not data.props.isSearchAwaitingResults
				and #data.props.itemList == 0
				and data.props.oldestConversationIsFetched
			then
				v17 = Roact.createElement(SearchNoResults, {
					topPadding = data.props.canvasTopPadding
				})
			end

			local createElement = Roact.createElement

			local v20 = if FFlagAppChatConsoleFocusFixes and not data.props.isInExperience and not (fFlagEnableStickyShortcutBarOnAllPlatforms and v7) then UDim2.new(1, 0, 1, data.props.deviceSafePadding.bottom) else UDim2.new(1, 0, 1, 0)
			return createElement("Frame", { Size = v20, BackgroundTransparency = 1 }, {
				conversationList = v17
			})
		end)
	end)
end

function extended:didMount()
	self.isMounted = true
end

function extended.didUpdate(p2, p3)
	if FFlagAppChatPerfTracking and #p2.props.itemList > #p3.itemList then
		AppChatPerfTracker.finish(AppChatPerfTracker.Events.PaginationConversationList)
	end
end

function extended:willUnmount()
	self.isMounted = false
end

local function ConversationListWithTopBarFunctional(p2)
	local v6 = useSignalState(Display.GetDisplayStore().getDeviceSafePadding)
	local state, setState = React.useState(nil)
	local ref = React.useRef(nil)
	local v7 = Responsive.useLastInput() == Responsive.Input.Directional

	local v8 = if FFlagAppChatKeepConversationListScrollOnVR then Responsive.useIsSpatial() else false

	React.useLayoutEffect(function()
		local nativeRef = ref.current
			and ref.current._listRef._scrollRef.getNativeScrollRef()
			and ref.current._listRef._scrollRef.getNativeScrollRef()._nativeRef
		setState(nativeRef)
	end)

	useAnimateScrollViewToSelection(state, 0.2)
	local v9

	if fFlagEnableStickyShortcutBarOnAllPlatforms then
		v9 = useSignalState(getShortcutBarStatusStore(false).getShortcutBarVisible)
	else
		v9 = false
	end

	local clone = table.clone(p2)
	clone.deviceSafePadding = v6
	clone.listRef = ref
	clone.scrollEnabled = not v7 or state == nil or state.current == nil

	if v8 then
		clone.scrollEnabled = true
	end

	if not fFlagEnableStickyShortcutBarOnAllPlatforms then
		v9 = nil
	end

	clone.isShortcutBarVisible = v9

	return React.createElement(extended, clone)
end

if FFlagAppChatConsoleFocusFixes then
	return ConversationListWithTopBarFunctional
end

return extended
