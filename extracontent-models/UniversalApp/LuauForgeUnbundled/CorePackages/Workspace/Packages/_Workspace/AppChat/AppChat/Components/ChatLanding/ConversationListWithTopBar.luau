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
local ChatLandingTelemetryLayer = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Telemetry/Layers/ChatLandingTelemetryLayer")
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
local FFlagAppChatUseUltimateListConversationList = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Flags/FFlagAppChatUseUltimateListConversationList")
local FFlagAppChatConsoleFocusFixes = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Flags/FFlagAppChatConsoleFocusFixes")
local FFlagAppChatUseViewRecyclerConversationList = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Flags/FFlagAppChatUseViewRecyclerConversationList")

local extended = Roact.PureComponent:extend("ConversationListWithTopBar")
local shouldUseFoundationConversationRow = SignalsMigrationConfig.shouldUseFoundationConversationRow
local v5 = shouldUseFoundationConversationRow and FFlagAppChatUseUltimateListConversationList
local v6 = shouldUseFoundationConversationRow and FFlagAppChatUseViewRecyclerConversationList
local ConversationList = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Components/ChatLanding/ConversationList")
local SearchLoading = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Components/ChatLanding/SearchLoading")
local SearchNoResults = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Components/ChatLanding/SearchNoResults")
local flag = false
local conversationListUltimate = nil
local flag2 = false
local conversationListViewRecycler = nil

local function getConversationListUltimate()
	if flag then
		return conversationListUltimate
	end

	flag = true
	local success, result = pcall(function()
		return require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Components/ChatLanding/ConversationListUltimate")
	end)

	if success then
		conversationListUltimate = result
	end

	return conversationListUltimate
end

local function getConversationListViewRecycler()
	if flag2 then
		return conversationListViewRecycler
	end

	flag2 = true
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
		local v7 = {
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
		local v8 = if data then data.moderationType else nil
		v7.selectedConversationModerationType = v8
		local v9 = if data then data.userPendingStatus else nil
		v7.selectedConversationUserPendingStatus = v9
		v7.participantUserIds = self.formatParticipantIds(data.participants)
		v7.osaAcknowledgementStatus = data.osaAcknowledgementStatus
		v7.osaImpressionId = osaImpressionId
		emit(conversationClicked, v7)

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
		return withTelemetry(ChatLandingTelemetryLayer.Context)(function(p3)
			local v7 = data.props.filterText and data.props.filterText:match("%S")
			local v8

			if fFlagEnableStickyShortcutBarOnAllPlatforms then
				v8 = data.props.isShortcutBarVisible
			else
				v8 = false
			end

			local v9 = {
				Size = UDim2.fromScale(1, 1),
				itemList = v7 and data.state.filteredItemList or data.props.itemList,
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
			local v10 = if partyPageCarouselExperimentation.getPartyPageCarouselEnabled() or shouldUseFoundationConversationRow then data.props.isWideMode else nil
			v9.isWideMode = v10

			v9.filterText = data.props.filterText
			v9.onActivated = data.onActivated
			v9.entryHeight = data.props.entryHeight
			v9.navigateToSquadLobby = data.props.navigateToSquadLobby
			v9.isInExperience = data.props.isInExperience
			v9.localUserId = data.props.localUserId
			local v11 = if partyPageCarouselExperimentation.getPartyPageCarouselEnabled() then data.props.navigateToConversationFromUserId else nil
			v9.navigateToConversationFromUserId = v11

			local v12 = if partyPageCarouselExperimentation.getPartyPageCarouselEnabled() then data.props.navigateToQuickStartSquadInviteFriends else nil
			v9.navigateToQuickStartSquadInviteFriends = v12

			v9.shouldShowPhoneVerificationUpsell = data.props.shouldShowPhoneVerificationUpsell
			v9.shouldShowUnfilteredAccessFtux = data.props.shouldShowUnfilteredAccessFtux
			v9.shouldShowPartyUpsellFtux = data.props.shouldShowPartyUpsellFtux
			v9.dismissUnfilteredThreadsFtux = data.props.dismissUnfilteredThreadsFtux
			v9.showGroupsLink = data.props.showGroupsLink
			local v13 = if FFlagAppChatConsoleFocusFixes then data.props.listRef else nil
			v9.listRef = v13
			local v14 = if fFlagAppIaScrollAway then data.props.canvasTopPadding else nil
			v9.canvasTopPadding = v14
			v9.pageBackgroundTransparency = data.props.pageBackgroundTransparency

			local v15 = if FFlagAppChatConsoleFocusFixes and not data.props.isInExperience and not (fFlagEnableStickyShortcutBarOnAllPlatforms and v8) then data.props.deviceSafePadding.bottom else nil
			v9.canvasBottomPadding = v15

			local v16 = if FFlagAppChatConsoleFocusFixes then data.props.scrollEnabled else nil
			v9.scrollEnabled = v16
			v9.fireConversationImpressionEvent = data.fireConversationImpressionEvent(p3)
			v9.isPartyQuickStartEnabled = data.props.isPartyQuickStartEnabled
			v9.fireConversationClickedEvent = data.fireClickEvent

			if shouldUseFoundationConversationRow then
				v9.canAccessParty = data.props.canAccessParty
			end

			if v5 or v6 then
				v9.isLoadingNext = data.props.conversationsIsFetching
				v9.isLoadingPrevious = data.props.conversationsIsFetching
				v9.oldestConversationIsFetched = data.props.oldestConversationIsFetched
			end

			local v17 = ConversationList

			if v6 then
				if not flag2 then
					flag2 = true
					local success, result = pcall(function()
						return require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Components/ChatLanding/ConversationListViewRecycler")
					end)

					if success then
						conversationListViewRecycler = result
					end
				end

				v17 = conversationListViewRecycler or ConversationList
			elseif v5 then
				if not flag then
					flag = true
					local success, result = pcall(function()
						return require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Components/ChatLanding/ConversationListUltimate")
					end)

					if success then
						conversationListUltimate = result
					end
				end

				v17 = conversationListUltimate or ConversationList
			end

			local v18 = Roact.createElement(v17, v9)

			if
				data.props.isSearchActive
				and data.props.isSearchAwaitingResults
				and #data.props.itemList == 0
			then
				v18 = Roact.createElement(SearchLoading, {
					entryHeight = data.props.entryHeight,
					topPadding = data.props.canvasTopPadding
				})
			elseif
				data.props.isSearchActive
				and not data.props.isSearchAwaitingResults
				and #data.props.itemList == 0
				and data.props.oldestConversationIsFetched
			then
				v18 = Roact.createElement(SearchNoResults, {
					topPadding = data.props.canvasTopPadding
				})
			end

			local createElement = Roact.createElement

			local v21 = if FFlagAppChatConsoleFocusFixes and not data.props.isInExperience and not (fFlagEnableStickyShortcutBarOnAllPlatforms and v8) then UDim2.new(1, 0, 1, data.props.deviceSafePadding.bottom) else UDim2.new(1, 0, 1, 0)
			return createElement("Frame", { Size = v21, BackgroundTransparency = 1 }, {
				conversationList = v18
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
	local v7 = useSignalState(Display.GetDisplayStore().getDeviceSafePadding)
	local state, setState = React.useState(nil)
	local ref = React.useRef(nil)
	local v8 = Responsive.useLastInput() == Responsive.Input.Directional

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
	clone.deviceSafePadding = v7
	clone.listRef = ref
	clone.scrollEnabled = not v8 or state == nil or state.current == nil

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
