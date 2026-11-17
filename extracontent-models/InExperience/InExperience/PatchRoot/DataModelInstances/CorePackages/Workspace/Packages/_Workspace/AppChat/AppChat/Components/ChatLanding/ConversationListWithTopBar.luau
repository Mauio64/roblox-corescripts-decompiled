local AppChat = script:FindFirstAncestor("AppChat")
local parent = AppChat.Parent
local HttpService = game:GetService("HttpService")

local Cryo = require(parent.Cryo)
local Roact = require(parent.Roact)
local React = require(parent.React)
local SocialLibraries = require(AppChat.SocialLibraries)
local RoactPaginator = SocialLibraries.RoactPaginator
local SocialLibraries2 = require(AppChat.SocialLibraries)
local searchFilterPredicate = SocialLibraries2.Utils.searchFilterPredicate
local AppCommonLib = require(parent.AppCommonLib)
local memoize = AppCommonLib.memoize

local withAnalytics = require(AppChat.LegacyAnalytics.withAnalytics)
local withTelemetry = require(AppChat.Telemetry.withTelemetry)

local FFlagAppChatPerfTracking = require(AppChat.Flags.FFlagAppChatPerfTracking)
local AppChatPerfTracker = require(AppChat.Telemetry.AppChatPerfTracker)

local ChatLanding = script:FindFirstAncestor("ChatLanding")
local ChatLandingTelemetryEvents = require(ChatLanding.ChatLandingTelemetryEvents)
local ChatLandingTelemetryLayer = require(AppChat.Telemetry.Layers.ChatLandingTelemetryLayer)
local Display = require(parent.Display)
local SignalsReact = require(parent.SignalsReact)
local useSignalState = SignalsReact.useSignalState
local Responsive = require(parent.Responsive)
local AppBlox = require(parent.AppBlox)
local useAnimateScrollViewToSelection = AppBlox.useAnimateScrollViewToSelection

local SharedFlags = require(parent.SharedFlags)
local FFlagAppIaScrollAway = SharedFlags.FFlagAppIaScrollAway
local FFlagEnableStickyShortcutBarOnAllPlatforms = SharedFlags.FFlagEnableStickyShortcutBarOnAllPlatforms
local getShortcutBarStatusStore

if FFlagEnableStickyShortcutBarOnAllPlatforms then
	local AppShortcutBar = require(parent.AppShortcutBar)
	getShortcutBarStatusStore = AppShortcutBar.GetShortcutBarStatusStore
else
	getShortcutBarStatusStore = nil
end

local SocialExperiments = require(parent.SocialExperiments)
local PartyPageCarouselExperimentation = SocialExperiments.PartyPageCarouselExperimentation

local SignalsMigrationConfig = require(AppChat.Flags.SignalsMigrationConfig)
local FFlagAppChatConsoleFocusFixes = require(AppChat.Flags.FFlagAppChatConsoleFocusFixes)
local FFlagAppChatKeepConversationListScrollOnVR = require(AppChat.Flags.FFlagAppChatKeepConversationListScrollOnVR)
local FFlagAppChatUseViewRecyclerConversationList = require(AppChat.Flags.FFlagAppChatUseViewRecyclerConversationList)

local extended = Roact.PureComponent:extend("ConversationListWithTopBar")
local shouldUseFoundationConversationRow = SignalsMigrationConfig.shouldUseFoundationConversationRow
local v = shouldUseFoundationConversationRow and FFlagAppChatUseViewRecyclerConversationList
local ConversationList = require(script.Parent.ConversationList)
local SearchLoading = require(script.Parent.SearchLoading)
local SearchNoResults = require(script.Parent.SearchNoResults)
local flag = false
local conversationListViewRecycler = nil

local function getConversationListViewRecycler()
	if flag then
		return conversationListViewRecycler
	end

	flag = true
	local success, result = pcall(function()
		return require(script.Parent.ConversationListViewRecycler)
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
	canvasTopPadding = FFlagAppIaScrollAway and 0 or nil,
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
		filteredItemList = Cryo.List.filterMap(itemList, function(p)
			if searchFilterPredicate(filterText, p.title) then
				return p
			end

			return nil
		end)
	}
end

function extended:init()
	function self.showErrorToast(toastTitle)
		self.props.navigateToToast({
			toastProps = {
				toastContent = { toastTitle = toastTitle }
			}
		})
	end

	function self.reportAnalytics(object)
		if not (self.props.conversationsIsFetching or self.props.oldestConversationIsFetched) then
			object:userFetchedOlderConversations(self.props.localUserId)
		end
	end

	self.loadNext = memoize(function(p)
		return function(p2)
			if self.props[RoactPaginator.loadNext] then
				self.reportAnalytics(p)

				if FFlagAppChatPerfTracking then
					AppChatPerfTracker.start(AppChatPerfTracker.Events.PaginationConversationList)
				end

				self.props[RoactPaginator.loadNext](p2)
			end
		end
	end)

	self.isFiltered = self.props.filterText and self.props.filterText:match("%S")

	self.indexOfList = memoize(function(p, p2)
		return table.find(Cryo.List.map(p, function(p3)
			return p3.id
		end), p2) or 0
	end)

	function self.formatParticipantIds(options)
		local filterMap = Cryo.List.filterMap(options or {}, function(p)
			if p.id then
				return (tonumber(p.id))
			end

			return nil
		end)

		local success, result = pcall(function()
			return HttpService:JSONEncode(filterMap)
		end)
		return if success then result else "[]"
	end

	function self.fireClickEvent(data, p, osaImpressionId)
		local id = data.id
		local emit = p.emit
		local conversationClicked = ChatLandingTelemetryEvents.ConversationClicked
		local v2 = {
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
		local selectedConversationModerationType

		if data then
			selectedConversationModerationType = data.moderationType
		end

		v2.selectedConversationModerationType = selectedConversationModerationType
		local selectedConversationUserPendingStatus

		if data then
			selectedConversationUserPendingStatus = data.userPendingStatus
		end

		v2.selectedConversationUserPendingStatus = selectedConversationUserPendingStatus
		v2.participantUserIds = self.formatParticipantIds(data.participants)
		v2.osaAcknowledgementStatus = data.osaAcknowledgementStatus
		v2.osaImpressionId = osaImpressionId
		emit(conversationClicked, v2)

		p.emit(ChatLandingTelemetryEvents.ConversationClickedIndexStat, {
			statValue = self.indexOfList(self.state.filteredItemList, id) or 0
		})
	end

	self.fireConversationImpressionEvent = memoize(function(p)
		return function(data)
			local id = data.id

			p.emit(ChatLandingTelemetryEvents.ConversationCellRendered, {
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

			p.emit(ChatLandingTelemetryEvents.ConversationCellRenderedIndexStat, {
				statValue = self.indexOfList(self.state.filteredItemList, id) or 0
			})
		end
	end)

	function self.onActivated(p)
		if FFlagAppChatPerfTracking then
			AppChatPerfTracker.start(AppChatPerfTracker.Events.ChatConversationTTI, {
				conversationId = tostring(p.id)
			})
		end

		self.props.navigateToConversation(p.id)
	end
end

function extended.render(data)
	return withAnalytics(function(p)
		return withTelemetry(ChatLandingTelemetryLayer.Context)(function(p2)
			local v2 = data.props.filterText and data.props.filterText:match("%S")
			local v3

			if FFlagEnableStickyShortcutBarOnAllPlatforms then
				v3 = data.props.isShortcutBarVisible
			else
				v3 = false
			end

			local v4 = {
				Size = UDim2.fromScale(1, 1),
				itemList = v2 and data.state.filteredItemList or data.props.itemList,
				loadNext = data.loadNext(p),
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
			local isWideMode

			if PartyPageCarouselExperimentation.getPartyPageCarouselEnabled() or shouldUseFoundationConversationRow then
				isWideMode = data.props.isWideMode
			end

			v4.isWideMode = isWideMode

			v4.filterText = data.props.filterText
			v4.onActivated = data.onActivated
			v4.entryHeight = data.props.entryHeight
			v4.navigateToSquadLobby = data.props.navigateToSquadLobby
			v4.isInExperience = data.props.isInExperience
			v4.localUserId = data.props.localUserId
			local navigateToConversationFromUserId

			if PartyPageCarouselExperimentation.getPartyPageCarouselEnabled() then
				navigateToConversationFromUserId = data.props.navigateToConversationFromUserId
			end

			v4.navigateToConversationFromUserId = navigateToConversationFromUserId
			local navigateToQuickStartSquadInviteFriends

			if PartyPageCarouselExperimentation.getPartyPageCarouselEnabled() then
				navigateToQuickStartSquadInviteFriends = data.props.navigateToQuickStartSquadInviteFriends
			end

			v4.navigateToQuickStartSquadInviteFriends = navigateToQuickStartSquadInviteFriends

			v4.shouldShowPhoneVerificationUpsell = data.props.shouldShowPhoneVerificationUpsell
			v4.shouldShowUnfilteredAccessFtux = data.props.shouldShowUnfilteredAccessFtux
			v4.shouldShowPartyUpsellFtux = data.props.shouldShowPartyUpsellFtux
			v4.dismissUnfilteredThreadsFtux = data.props.dismissUnfilteredThreadsFtux
			v4.showGroupsLink = data.props.showGroupsLink
			local listRef

			if FFlagAppChatConsoleFocusFixes then
				listRef = data.props.listRef
			end

			v4.listRef = listRef
			local canvasTopPadding

			if FFlagAppIaScrollAway then
				canvasTopPadding = data.props.canvasTopPadding
			end

			v4.canvasTopPadding = canvasTopPadding
			v4.pageBackgroundTransparency = data.props.pageBackgroundTransparency
			local canvasBottomPadding

			if
				FFlagAppChatConsoleFocusFixes
				and not data.props.isInExperience
				and not (FFlagEnableStickyShortcutBarOnAllPlatforms and v3)
			then
				canvasBottomPadding = data.props.deviceSafePadding.bottom
			end

			v4.canvasBottomPadding = canvasBottomPadding
			local scrollEnabled

			if FFlagAppChatConsoleFocusFixes then
				scrollEnabled = data.props.scrollEnabled
			end

			v4.scrollEnabled = scrollEnabled
			v4.fireConversationImpressionEvent = data.fireConversationImpressionEvent(p2)
			v4.isPartyQuickStartEnabled = data.props.isPartyQuickStartEnabled
			v4.fireConversationClickedEvent = data.fireClickEvent

			if shouldUseFoundationConversationRow then
				v4.canAccessParty = data.props.canAccessParty
			end

			if v then
				v4.isLoadingNext = data.props.conversationsIsFetching
				v4.isLoadingPrevious = data.props.conversationsIsFetching
				v4.oldestConversationIsFetched = data.props.oldestConversationIsFetched
			end

			local v5 = ConversationList

			if v then
				if not flag then
					flag = true
					local success, result = pcall(function()
						return require(script.Parent.ConversationListViewRecycler)
					end)

					if success then
						conversationListViewRecycler = result
					end
				end

				v5 = conversationListViewRecycler or ConversationList
			end

			local conversationList = Roact.createElement(v5, v4)

			if data.props.isSearchActive and data.props.isSearchAwaitingResults and #data.props.itemList == 0 then
				conversationList = Roact.createElement(SearchLoading, {
					entryHeight = data.props.entryHeight,
					topPadding = data.props.canvasTopPadding
				})
			elseif
				data.props.isSearchActive
				and not data.props.isSearchAwaitingResults
				and #data.props.itemList == 0
				and data.props.oldestConversationIsFetched
			then
				conversationList = Roact.createElement(SearchNoResults, {
					topPadding = data.props.canvasTopPadding
				})
			end

			local createElement = Roact.createElement
			local size

			if
				FFlagAppChatConsoleFocusFixes
				and not data.props.isInExperience
				and not (FFlagEnableStickyShortcutBarOnAllPlatforms and v3)
			then
				size = UDim2.new(1, 0, 1, data.props.deviceSafePadding.bottom)
			else
				size = UDim2.new(1, 0, 1, 0)
			end

			return createElement("Frame", { Size = size, BackgroundTransparency = 1 }, {
				conversationList = conversationList
			})
		end)
	end)
end

function extended:didMount()
	self.isMounted = true
end

function extended.didUpdate(p, p2)
	if FFlagAppChatPerfTracking and #p.props.itemList > #p2.itemList then
		AppChatPerfTracker.finish(AppChatPerfTracker.Events.PaginationConversationList)
	end
end

function extended:willUnmount()
	self.isMounted = false
end

local function ConversationListWithTopBarFunctional(p)
	local deviceSafePadding = useSignalState(Display.GetDisplayStore().getDeviceSafePadding)
	local state, setState = React.useState(nil)
	local ref = React.useRef(nil)
	local v2 = Responsive.useLastInput() == Responsive.Input.Directional
	local v3

	if FFlagAppChatKeepConversationListScrollOnVR then
		v3 = Responsive.useIsSpatial()
	else
		v3 = false
	end

	React.useLayoutEffect(function()
		local nativeRef = ref.current
			and ref.current._listRef._scrollRef.getNativeScrollRef()
			and ref.current._listRef._scrollRef.getNativeScrollRef()._nativeRef
		setState(nativeRef)
	end)

	useAnimateScrollViewToSelection(state, 0.2)
	local isShortcutBarVisible

	if FFlagEnableStickyShortcutBarOnAllPlatforms then
		isShortcutBarVisible = useSignalState(getShortcutBarStatusStore(false).getShortcutBarVisible)
	else
		isShortcutBarVisible = false
	end

	local clone = table.clone(p)
	clone.deviceSafePadding = deviceSafePadding
	clone.listRef = ref
	clone.scrollEnabled = not v2 or state == nil or state.current == nil

	if v3 then
		clone.scrollEnabled = true
	end

	if not FFlagEnableStickyShortcutBarOnAllPlatforms then
		isShortcutBarVisible = nil
	end

	clone.isShortcutBarVisible = isShortcutBarVisible

	return React.createElement(extended, clone)
end

if FFlagAppChatConsoleFocusFixes then
	return ConversationListWithTopBarFunctional
end

return extended
