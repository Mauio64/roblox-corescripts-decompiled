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
local FFlagAppChatUseUltimateListConversationList = require(AppChat.Flags.FFlagAppChatUseUltimateListConversationList)
local FFlagAppChatConsoleFocusFixes = require(AppChat.Flags.FFlagAppChatConsoleFocusFixes)
local FFlagAppChatUseViewRecyclerConversationList = require(AppChat.Flags.FFlagAppChatUseViewRecyclerConversationList)

local extended = Roact.PureComponent:extend("ConversationListWithTopBar")
local shouldUseFoundationConversationRow = SignalsMigrationConfig.shouldUseFoundationConversationRow
local v = shouldUseFoundationConversationRow and FFlagAppChatUseUltimateListConversationList
local v2 = shouldUseFoundationConversationRow and FFlagAppChatUseViewRecyclerConversationList
local ConversationList = require(script.Parent.ConversationList)
local SearchLoading = require(script.Parent.SearchLoading)
local SearchNoResults = require(script.Parent.SearchNoResults)
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
		return require(script.Parent.ConversationListUltimate)
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
		local v3 = {
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

		v3.selectedConversationModerationType = selectedConversationModerationType
		local selectedConversationUserPendingStatus

		if data then
			selectedConversationUserPendingStatus = data.userPendingStatus
		end

		v3.selectedConversationUserPendingStatus = selectedConversationUserPendingStatus
		v3.participantUserIds = self.formatParticipantIds(data.participants)
		v3.osaAcknowledgementStatus = data.osaAcknowledgementStatus
		v3.osaImpressionId = osaImpressionId
		emit(conversationClicked, v3)

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
			local v3 = data.props.filterText and data.props.filterText:match("%S")
			local v4

			if FFlagEnableStickyShortcutBarOnAllPlatforms then
				v4 = data.props.isShortcutBarVisible
			else
				v4 = false
			end

			local v5 = {
				Size = UDim2.fromScale(1, 1),
				itemList = v3 and data.state.filteredItemList or data.props.itemList,
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

			v5.isWideMode = isWideMode

			v5.filterText = data.props.filterText
			v5.onActivated = data.onActivated
			v5.entryHeight = data.props.entryHeight
			v5.navigateToSquadLobby = data.props.navigateToSquadLobby
			v5.isInExperience = data.props.isInExperience
			v5.localUserId = data.props.localUserId
			local navigateToConversationFromUserId

			if PartyPageCarouselExperimentation.getPartyPageCarouselEnabled() then
				navigateToConversationFromUserId = data.props.navigateToConversationFromUserId
			end

			v5.navigateToConversationFromUserId = navigateToConversationFromUserId
			local navigateToQuickStartSquadInviteFriends

			if PartyPageCarouselExperimentation.getPartyPageCarouselEnabled() then
				navigateToQuickStartSquadInviteFriends = data.props.navigateToQuickStartSquadInviteFriends
			end

			v5.navigateToQuickStartSquadInviteFriends = navigateToQuickStartSquadInviteFriends

			v5.shouldShowPhoneVerificationUpsell = data.props.shouldShowPhoneVerificationUpsell
			v5.shouldShowUnfilteredAccessFtux = data.props.shouldShowUnfilteredAccessFtux
			v5.shouldShowPartyUpsellFtux = data.props.shouldShowPartyUpsellFtux
			v5.dismissUnfilteredThreadsFtux = data.props.dismissUnfilteredThreadsFtux
			v5.showGroupsLink = data.props.showGroupsLink
			local listRef

			if FFlagAppChatConsoleFocusFixes then
				listRef = data.props.listRef
			end

			v5.listRef = listRef
			local canvasTopPadding

			if FFlagAppIaScrollAway then
				canvasTopPadding = data.props.canvasTopPadding
			end

			v5.canvasTopPadding = canvasTopPadding
			v5.pageBackgroundTransparency = data.props.pageBackgroundTransparency
			local canvasBottomPadding

			if
				FFlagAppChatConsoleFocusFixes
				and not data.props.isInExperience
				and not (FFlagEnableStickyShortcutBarOnAllPlatforms and v4)
			then
				canvasBottomPadding = data.props.deviceSafePadding.bottom
			end

			v5.canvasBottomPadding = canvasBottomPadding
			local scrollEnabled

			if FFlagAppChatConsoleFocusFixes then
				scrollEnabled = data.props.scrollEnabled
			end

			v5.scrollEnabled = scrollEnabled
			v5.fireConversationImpressionEvent = data.fireConversationImpressionEvent(p2)
			v5.isPartyQuickStartEnabled = data.props.isPartyQuickStartEnabled
			v5.fireConversationClickedEvent = data.fireClickEvent

			if shouldUseFoundationConversationRow then
				v5.canAccessParty = data.props.canAccessParty
			end

			if v or v2 then
				v5.isLoadingNext = data.props.conversationsIsFetching
				v5.isLoadingPrevious = data.props.conversationsIsFetching
				v5.oldestConversationIsFetched = data.props.oldestConversationIsFetched
			end

			local v6 = ConversationList

			if v2 then
				if not flag2 then
					flag2 = true
					local success, result = pcall(function()
						return require(script.Parent.ConversationListViewRecycler)
					end)

					if success then
						conversationListViewRecycler = result
					end
				end

				v6 = conversationListViewRecycler or ConversationList
			elseif v then
				if not flag then
					flag = true
					local success, result = pcall(function()
						return require(script.Parent.ConversationListUltimate)
					end)

					if success then
						conversationListUltimate = result
					end
				end

				v6 = conversationListUltimate or ConversationList
			end

			local conversationList = Roact.createElement(v6, v5)

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
				and not (FFlagEnableStickyShortcutBarOnAllPlatforms and v4)
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
	local v3 = Responsive.useLastInput() == Responsive.Input.Directional

	React.useLayoutEffect(function()
		setState(ref.current and ref.current._listRef._scrollRef.getNativeScrollRef() and ref.current._listRef._scrollRef.getNativeScrollRef()._nativeRef)
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
	clone.scrollEnabled = not v3 or state == nil or state.current == nil

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
