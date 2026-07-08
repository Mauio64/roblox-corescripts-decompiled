local AppChat = script:FindFirstAncestor("AppChat")
local AppChatParent = AppChat.Parent
local HttpService = game:GetService("HttpService")
local Cryo = require(AppChatParent.Cryo)
local Roact = require(AppChatParent.Roact)
local RoactPaginator = require(AppChat.SocialLibraries).RoactPaginator
local searchFilterPredicate = require(AppChat.SocialLibraries).Utils.searchFilterPredicate
local memoize = require(AppChatParent.AppCommonLib).memoize
local withAnalytics = require(AppChat.LegacyAnalytics.withAnalytics)
local withTelemetry = require(AppChat.Telemetry.withTelemetry)
local FFlagAppChatPerfTracking = require(AppChat.Flags.FFlagAppChatPerfTracking)
local AppChatPerfTracker = require(AppChat.Telemetry.AppChatPerfTracker)
local ChatLanding = script:FindFirstAncestor("ChatLanding")
local ChatLandingTelemetryEvents = require(ChatLanding.ChatLandingTelemetryEvents)
local ChatLandingTelemetryLayer = require(AppChat.Telemetry.Layers.ChatLandingTelemetryLayer)
local FFlagAppIaScrollAway = require(AppChatParent.SharedFlags).FFlagAppIaScrollAway
local PartyPageCarouselExperimentation = require(AppChatParent.SocialExperiments).PartyPageCarouselExperimentation
local FFlagAppChatUseNewConversationRow = require(AppChat.Flags.FFlagAppChatUseNewConversationRow)
local FFlagAppChatConversationStore = require(AppChat.Flags.FFlagAppChatConversationStore)
local FFlagAppChatSignalsMessageStore = require(AppChat.Flags.FFlagAppChatSignalsMessageStore)
local FFlagAppChatUseUltimateListConversationList = require(AppChat.Flags.FFlagAppChatUseUltimateListConversationList)
local v22 = Roact.PureComponent:extend("ConversationListWithTopBar")
local v23 = FFlagAppChatUseNewConversationRow and (FFlagAppChatConversationStore and FFlagAppChatSignalsMessageStore)
local v24 = v23 and FFlagAppChatUseUltimateListConversationList
local ConversationList = require(script.Parent.ConversationList)
local u26 = false
local u27 = nil

local function getConversationListUltimate() -- line: 41
	-- upvalues: u26 (ref), u27 (ref)
	if u26 then
		return u27
	end

	u26 = true

	local ok, result = pcall(function() -- line: 47
		return require(script.Parent.ConversationListUltimate)
	end)

	if ok then
		u27 = result
	end

	return u27
end

v22.defaultProps = {
	filterText = nil,
	isDebugEnabled = false,
	topBarHeight = 0,
	entryHeight = 64,
	canAccessParty = false,
	isPartyQuickStartEnabled = false,
	itemList = {},
	navigateToSquadLobby = function() -- line: 61
	end,
	canvasTopPadding = if not FFlagAppIaScrollAway then nil else 0
}

function v22.getDerivedStateFromProps(p1) -- line: 69
	-- upvalues: Cryo (copy), searchFilterPredicate (copy)
	local filterText = p1.filterText
	local itemList = p1.itemList

	return {
		filteredItemList = Cryo.List.filterMap(itemList, function(p2) -- line: 74
			-- upvalues: searchFilterPredicate (copy), filterText (copy)
			local title = p2.title

			if searchFilterPredicate(filterText, title) then
				return p2
			end

			return nil
		end)
	}
end
function v22.init(p3) -- line: 86
	-- upvalues: memoize (copy), RoactPaginator (copy), FFlagAppChatPerfTracking (copy), AppChatPerfTracker (copy), Cryo (copy), HttpService (copy), ChatLandingTelemetryEvents (copy)
	function p3.showErrorToast(p4) -- line: 87
		-- upvalues: p3 (copy)
		p3.props.navigateToToast({
			toastProps = {
				toastContent = {
					toastTitle = p4
				}
			}
		})
	end
	function p3.reportAnalytics(p5) -- line: 97
		-- upvalues: p3 (copy)
		if not p3.props.conversationsIsFetching and not p3.props.oldestConversationIsFetched then
			p5:userFetchedOlderConversations(p3.props.localUserId)
		end
	end

	p3.loadNext = memoize(function(p6) -- line: 104
		-- upvalues: p3 (copy), RoactPaginator (copy), FFlagAppChatPerfTracking (copy), AppChatPerfTracker (copy)
		return function(p7) -- line: 105
			-- upvalues: p3 (copy), RoactPaginator (copy), p6 (copy), FFlagAppChatPerfTracking (copy), AppChatPerfTracker (copy)
			if p3.props[RoactPaginator.loadNext] then
				p3.reportAnalytics(p6)

				if FFlagAppChatPerfTracking then
					AppChatPerfTracker.start(AppChatPerfTracker.Events.PaginationConversationList)
				end

				p3.props[RoactPaginator.loadNext](p7)
			end
		end
	end)
	p3.isFiltered = p3.props.filterText and p3.props.filterText:match("%S")
	p3.indexOfList = memoize(function(p8, p9) -- line: 118
		-- upvalues: Cryo (copy)
		local v47 = table.find(Cryo.List.map(p8, function(p10) -- line: 120
			return p10.id
		end), p9)

		if v47 then
			return v47
		end

		return 0
	end)

	function p3.formatParticipantIds(p11) -- line: 131
		-- upvalues: Cryo (copy), HttpService (copy)
		local v49 = Cryo.List.filterMap(p11 or {}, function(p12) -- line: 132
			if not p12.id then
				return nil
			end

			return (tonumber(p12.id))
		end)
		local ok, result = pcall(function() -- line: 139
			-- upvalues: HttpService (copy), v49 (copy)
			return HttpService:JSONEncode(v49)
		end)

		if ok then
			return result
		end

		return "[]"
	end
	function p3.fireClickEvent(p13, p14, p15) -- line: 145
		-- upvalues: ChatLandingTelemetryEvents (copy), p3 (copy)
		local id = p13.id

		p14.emit(ChatLandingTelemetryEvents.ConversationClicked, {
			isFiltered = p3.isFiltered ~= nil,
			conversationListCount = #p3.state.filteredItemList,
			selectedConversationId = id,
			selectedIndex = p3.indexOfList(p3.state.filteredItemList, id),
			hasUnreadMessages = p13.hasUnreadMessages,
			selectedConversationModerationType = if not p13 then nil else p13.moderationType,
			selectedConversationUserPendingStatus = if not p13 then nil else p13.userPendingStatus,
			participantUserIds = p3.formatParticipantIds(p13.participants),
			osaAcknowledgementStatus = p13.osaAcknowledgementStatus,
			osaImpressionId = p15
		})
		p14.emit(ChatLandingTelemetryEvents.ConversationClickedIndexStat, {
			statValue = p3.indexOfList(p3.state.filteredItemList, id) or 0
		})
	end

	p3.fireConversationImpressionEvent = memoize(function(p16) -- line: 164
		-- upvalues: ChatLandingTelemetryEvents (copy), p3 (copy)
		return function(p17) -- line: 165
			-- upvalues: p16 (copy), ChatLandingTelemetryEvents (copy), p3 (copy)
			local id = p17.id

			p16.emit(ChatLandingTelemetryEvents.ConversationCellRendered, {
				isFiltered = p3.isFiltered ~= nil,
				conversationListCount = #p3.state.filteredItemList,
				selectedConversationId = id,
				selectedIndex = p3.indexOfList(p3.state.filteredItemList, id),
				hasUnreadMessages = p17.hasUnreadMessages,
				selectedConversationModerationType = p17.moderationType,
				selectedConversationUserPendingStatus = p17.userPendingStatus,
				participantUserIds = p3.formatParticipantIds(p17.participants),
				osaAcknowledgementStatus = p17.osaAcknowledgementStatus
			})
			p16.emit(ChatLandingTelemetryEvents.ConversationCellRenderedIndexStat, {
				statValue = p3.indexOfList(p3.state.filteredItemList, id) or 0
			})
		end
	end)

	function p3.onActivated(p18) -- line: 185
		-- upvalues: FFlagAppChatPerfTracking (copy), AppChatPerfTracker (copy), p3 (copy)
		if FFlagAppChatPerfTracking then
			AppChatPerfTracker.start(AppChatPerfTracker.Events.ChatConversationTTI, {
				conversationId = tostring(p18.id)
			})
		end

		p3.props.navigateToConversation(p18.id)
	end
end
function v22.render(p19) -- line: 195
	-- upvalues: withAnalytics (copy), withTelemetry (copy), ChatLandingTelemetryLayer (copy), PartyPageCarouselExperimentation (copy), v23 (copy), FFlagAppIaScrollAway (copy), v24 (copy), ConversationList (copy), u26 (ref), u27 (ref), Roact (copy)
	return withAnalytics(function(p20) -- line: 196
		-- upvalues: withTelemetry (copy), ChatLandingTelemetryLayer (copy), p19 (copy), PartyPageCarouselExperimentation (copy), v23 (copy), FFlagAppIaScrollAway (copy), v24 (copy), ConversationList (copy), u26 (ref), u27 (ref), Roact (copy)
		return withTelemetry(ChatLandingTelemetryLayer.Context)(function(p21) -- line: 197
			-- upvalues: p19 (copy), p20 (copy), PartyPageCarouselExperimentation (copy), v23 (copy), FFlagAppIaScrollAway (copy), v24 (copy), ConversationList (copy), u26 (ref), u27 (ref), Roact (copy)
			local v65 = p19.props.filterText and p19.props.filterText:match("%S")
			local t1 = {
				Size = UDim2.fromScale(1, 1),
				itemList = v65 and p19.state.filteredItemList or p19.props.itemList,
				loadNext = p19.loadNext(p20),
				isDebugEnabled = p19.props.isDebugEnabled,
				isWideMode = if not PartyPageCarouselExperimentation.getPartyPageCarouselEnabled() and not v23 then nil else p19.props.isWideMode,
				filterText = p19.props.filterText,
				onActivated = p19.onActivated,
				entryHeight = p19.props.entryHeight,
				navigateToSquadLobby = p19.props.navigateToSquadLobby,
				isInExperience = p19.props.isInExperience,
				localUserId = p19.props.localUserId,
				rowProps = {
					showBackground = not p19.props.isInExperience
				},
				navigateToConversationFromUserId = if not PartyPageCarouselExperimentation.getPartyPageCarouselEnabled() then nil else p19.props.navigateToConversationFromUserId,
				navigateToQuickStartSquadInviteFriends = if not PartyPageCarouselExperimentation.getPartyPageCarouselEnabled() then nil else p19.props.navigateToQuickStartSquadInviteFriends,
				shouldShowPhoneVerificationUpsell = p19.props.shouldShowPhoneVerificationUpsell,
				shouldShowUnfilteredAccessFtux = p19.props.shouldShowUnfilteredAccessFtux,
				shouldShowPartyUpsellFtux = p19.props.shouldShowPartyUpsellFtux,
				dismissUnfilteredThreadsFtux = p19.props.dismissUnfilteredThreadsFtux,
				showGroupsLink = p19.props.showGroupsLink,
				canvasTopPadding = if not FFlagAppIaScrollAway then nil else p19.props.canvasTopPadding,
				fireConversationImpressionEvent = p19.fireConversationImpressionEvent(p21),
				isPartyQuickStartEnabled = p19.props.isPartyQuickStartEnabled,
				fireConversationClickedEvent = p19.fireClickEvent
			}

			if v23 then
				t1.canAccessParty = p19.props.canAccessParty
			end

			if v24 then
				t1.isLoadingNext = p19.props.conversationsIsFetching
				t1.isLoadingPrevious = p19.props.conversationsIsFetching
				t1.oldestConversationIsFetched = p19.props.oldestConversationIsFetched
			end

			local v67 = ConversationList

			if v24 then
				if u26 then
					v67 = u27
				else
					u26 = true

					local ok, result = pcall(function() -- line: 47
						return require(script.Parent.ConversationListUltimate)
					end)

					if ok then
						u27 = result
					end

					v67 = u27
				end

				if not v67 then
					v67 = ConversationList
				end
			end

			local v70 = Roact.createElement(v67, t1)

			return Roact.createElement("Frame", {
				BackgroundTransparency = 1,
				Size = UDim2.new(1, 0, 1, 0)
			}, {
				conversationList = v70
			})
		end)
	end)
end
function v22.didMount(p22) -- line: 260
	p22.isMounted = true
end
function v22.didUpdate(p23, p24) -- line: 264
	-- upvalues: FFlagAppChatPerfTracking (copy), AppChatPerfTracker (copy)
	if FFlagAppChatPerfTracking and #p23.props.itemList > #p24.itemList then
		AppChatPerfTracker.finish(AppChatPerfTracker.Events.PaginationConversationList)
	end
end
function v22.willUnmount(p25) -- line: 270
	p25.isMounted = false
end

return v22
