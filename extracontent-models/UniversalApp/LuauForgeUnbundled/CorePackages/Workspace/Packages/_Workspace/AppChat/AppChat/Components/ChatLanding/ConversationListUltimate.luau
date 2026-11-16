local IXPService = game:GetService("IXPService")

local appChatPerfExperimentation = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/SocialExperiments").AppChatPerfExperimentation
local appPage = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/RobloxAppEnums").AppPage
local coreGui = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/ReactFocusNavigation").EngineInterface.CoreGui
local Cryo = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/Cryo")
local focusNavigationService = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/ReactFocusNavigation").FocusNavigationService
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/React")
local ReactOtter = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/ReactOtter")
local SharedFlags = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/SharedFlags")
local signal = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppCommonLib").Signal
local SocialCarousel = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/SocialCarousel")
local SocialExperiments = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/SocialExperiments")
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/Foundation")
local UltimateList = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/UltimateList")
local view = Foundation.View
local useTokens = Foundation.Hooks.useTokens

local FFlagAppChatPerfTracking = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Flags/FFlagAppChatPerfTracking")
local AppChatPerfTracker = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Telemetry/AppChatPerfTracker")
local createScrollIntervalTracker = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Telemetry/createScrollIntervalTracker")

local constants = SocialCarousel.Constants
local enums = SocialCarousel.Enums

local squadQuickStartExperimentation = SocialExperiments.SquadQuickStartExperimentation

local ChatLandingModalContainer = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Components/ChatLanding/ChatLandingModal/ChatLandingModalContainer")
local ConversationRow = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Components/ChatLanding/ConversationRow")
local ConversationGroupsEntryContainer = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Components/ChatLanding/ConversationGroupsEntryContainer")
local PartyQuickStartContainer = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Components/ChatLanding/PartyQuickStartContainer")
local defineFastInt = game:DefineFastInt("AppChatChatLandingInitialFetchLimit", 5)
local fFlagAppIaScrollAway = SharedFlags.FFlagAppIaScrollAway
local fFlagFriendsChatConversationListShowScrollBar = SharedFlags.FFlagFriendsChatConversationListShowScrollBar

local defineFastInt2 = game:DefineFastInt("AppChatChatLandingInitialFetchMinimumConversations", 30)

local FFlagAppChatRemoveConversationListDividerIxpEnabled = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Flags/FFlagAppChatRemoveConversationListDividerIxpEnabled")

local FStringAppChatRemoveConversationListDividerIxpLayer = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Flags/FStringAppChatRemoveConversationListDividerIxpLayer")

local defineFastInt3 = game:DefineFastInt("AppChatPerfChatLandingPaginationOnStartReachedUnits", 1)

local defineFastInt4 = game:DefineFastInt("AppChatPerfChatLandingPaginationOnEndReachedUnits", 10)

local defineFastInt5 = game:DefineFastInt("AppChatConversationListScrollBarIdleHideMs", 1500)

local partyPageCarouselExperimentation = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/SocialExperiments").PartyPageCarouselExperimentation

local v5 = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Components/ChatLanding/Logger"):new("ConversationListUltimate")

local v6 = defineFastInt5 / 1000
local v7 = {
	dampingRatio = 1,
	frequency = 2,
	restingVelocityLimit = 0.1,
	restingPositionLimit = 0.1
}

local function noop() end

local function isPartyQuickStartEnabled(p2)
	return p2.isPartyQuickStartEnabled
end

local function getIsSquadEnabledForRows(p2): boolean
	return p2.canAccessParty == true
end

local function getConversationRowListItems(itemList)
	local conversationRowListItems = {}

	for k, item in itemList do
		conversationRowListItems[k] = { id = tostring(item.id) }
	end

	return conversationRowListItems
end

local function getFirstId(list)
	if list and list[1] then
		return list[1].id
	end

	return nil
end

local function getLastId(list)
	if list and list[#list] then
		return list[#list].id
	end

	return nil
end

local function getAutoLoadNextRequestKey(list)
	local v9 = #list
	local v10 = if list and list[1] then list[1].id else nil

	local v11 = tostring(v10)
	local v12 = if list and list[#list] then list[#list].id else nil

	return `{v9}:{v11}:{tostring(v12)}`
end

local function getKey(p2)
	return (tostring(p2.id))
end

local function MeasuredChatLandingModal(p2)
	local ref = React.useRef(nil)

	React.useEffect(function()
		local current = ref.current

		if current ~= nil then
			p2.onHeightChanged(p2.itemId, current.AbsoluteSize.Y)
		end
	end, { p2.itemId, p2.onHeightChanged })

	return React.createElement("Frame", {
		BackgroundTransparency = 1,
		Size = UDim2.new(1, 0, 0, 0),
		AutomaticSize = Enum.AutomaticSize.Y,
		ref = ref,
		[React.Change.AbsoluteSize] = function(p3)
			p2.onHeightChanged(p2.itemId, p3.AbsoluteSize.Y)
		end
	}, {
		ChatLandingModal = React.createElement(ChatLandingModalContainer, {})
	})
end

local function ConversationListUltimate(props)
	local entryHeight = props.entryHeight or 64
	local itemList = props.itemList or {}
	local size = props.Size or UDim2.fromScale(1, 1)
	local layoutOrder = props.LayoutOrder or 1
	local onScrollUpdate = props.onScrollUpdate or noop
	local navigateToConversationFromUserId = props.navigateToConversationFromUserId or noop
	local navigateToQuickStartSquadInviteFriends = props.navigateToQuickStartSquadInviteFriends or noop
	local navigateToSquadLobby = props.navigateToSquadLobby or noop
	local fireConversationImpressionEvent = props.fireConversationImpressionEvent or noop
	local fireConversationClickedEvent = props.fireConversationClickedEvent or noop
	local showHeaderEntries = props.showHeaderEntries ~= false
	local rowProps = props.rowProps or {}
	local v8 = React.useMemo(function()
		return signal.new()
	end, {})
	local ref = React.useRef(nil)
	local ref2 = React.useRef(nil)
	local ref3, v9, v10

	if fFlagFriendsChatConversationListShowScrollBar then
		ref3 = React.useRef(nil)
		v9, v10 = ReactOtter.useAnimatedBinding(1)
	else
		ref3 = nil
		v10 = nil
	end

	local ref4 = React.useRef(nil)
	local ref5 = React.useRef(0)
	local v11 = React.useMemo(function()
		local v12 = itemList
		local v14 = #v12
		local v15 = if v12 and v12[1] then v12[1].id else nil

		local v16 = tostring(v15)
		local v17 = if v12 and v12[#v12] then v12[#v12].id else nil

		return `{v14}:{v16}:{tostring(v17)}`
	end, { itemList })
	local ref6 = React.useRef(nil)
	local ref7 = React.useRef(false)
	local state, setState = React.useState(Vector2.new(0, 0))
	local state2, setState2 = React.useState(nil)
	local v12 = useTokens()
	local state3, setState3 = React.useState({})
	local v13 = React.useCallback(function(p2, p3)
		if p3 < 0 then
			return
		end

		setState3(function(p4)
			if p4[p2] == p3 then
				return p4
			end

			return Cryo.Dictionary.join(p4, { [p2] = p3 })
		end)
	end, {})
	local v14

	if props.loadNext == nil then
		v14 = false
	else
		v14 = not (props.isLoadingNext or props.oldestConversationIsFetched)
	end

	React.useEffect(function()
		if ref7.current and not props.isLoadingNext then
			ref6.current = nil
		end

		ref7.current = props.isLoadingNext == true
	end, { props.isLoadingNext })

	local v15 = React.useCallback(function(): boolean
		if not v14 or ref6.current == v11 then
			return false
		end

		ref6.current = v11
		props.loadNext()
		return true
	end, { v14, v11, props.loadNext })

	React.useEffect(function()
		appChatPerfExperimentation.logExposure()

		if props.shouldLogHeaderEntryExposures ~= false then
			partyPageCarouselExperimentation.logExposure()
			squadQuickStartExperimentation.logExposure()

			if FFlagAppChatRemoveConversationListDividerIxpEnabled then
				IXPService:LogFlagLinkedUserLayerExposure(FStringAppChatRemoveConversationListDividerIxpLayer)
			end
		end
	end, {})

	React.useEffect(function()
		local v16 = focusNavigationService.new(coreGui)
		return function()
			v16:teardown()
		end
	end, {})
	local canAccessParty = props.canAccessParty == true

	React.useEffect(function()
		local v16 = state2

		if v16 == nil then
			return nil
		end

		v16.Selectable = false

		if not FFlagAppChatPerfTracking then
			return nil
		end

		ref.current = createScrollIntervalTracker(AppChatPerfTracker.Events.ScrollConversationList, v16)
		return function()
			if ref.current then
				ref.current.cleanup()
				ref.current = nil
			end
		end
	end, { state2 })
	local isPartyQuickStartEnabled2 = props.isPartyQuickStartEnabled

	local v16 = React.useMemo(function()
		local v17 = {
			appPage = appPage.Chat,
			impressionTag = 0,
			scrollViewPositionChangedSignal = 0,
			sortId = 0,
			sortIndex = 1
		}
		local v18 = if props.isInExperience then constants.ANALYTICS.SRC.PARTY_PAGE_IN_EXP else constants.ANALYTICS.SRC.PARTY_PAGE_UA
		v17.impressionTag = v18

		v17.scrollViewPositionChangedSignal = v8
		return v17
	end, { props.isInExperience, v8 })

	local v17 = React.useCallback(function(p2)
		navigateToConversationFromUserId(p2.id)
	end, { navigateToConversationFromUserId })

	local v18 = React.useMemo(function()
		return {
			{
				tileGroup = enums.TileGroup.StartSquad,
				onActivated = navigateToQuickStartSquadInviteFriends
			},
			{ tileGroup = enums.TileGroup.FriendsList, onActivated = v17 }
		}
	end, { navigateToQuickStartSquadInviteFriends, v17 })

	local v19 = React.useMemo(function()
		local conversationRowListItems = getConversationRowListItems(itemList)
		local v20 = props.filterText == "" or props.filterText == nil
		local v21 = showHeaderEntries and v20

		if v21 and props.showGroupsLink then
			conversationRowListItems = Cryo.List.join({
				{ id = "ConversationGroupsEntryContainer", isGroupLink = true }
			}, conversationRowListItems)
		end

		if
			v21
			and not partyPageCarouselExperimentation.getPartyPageCarouselEnabled()
			and isPartyQuickStartEnabled2
		then
			conversationRowListItems = Cryo.List.join({
				{ id = "PartyQuickStartContainer", isQuickStartLink = true }
			}, conversationRowListItems)
		end

		if v21 then
			if
				isPartyQuickStartEnabled2
				and partyPageCarouselExperimentation.getPartyPageCarouselEnabled()
				and (props.isWideMode or not props.isInExperience)
			then
				conversationRowListItems = Cryo.List.join({
					{ id = "SocialCarousel", isSocialCarousel = true }
				}, conversationRowListItems)
			end

			conversationRowListItems = Cryo.List.join({
				{ id = "UnfilteredThreadsFtux", isChatLandingModal = true }
			}, conversationRowListItems)
		end

		if fFlagAppIaScrollAway and (props.canvasTopPadding or 0) > 0 then
			conversationRowListItems = Cryo.List.join({
				{
					id = "CanvasTopPadding",
					isCanvasTopPadding = true,
					height = props.canvasTopPadding
				}
			}, conversationRowListItems)
		end

		return conversationRowListItems
	end, {
		itemList,
		props.filterText,
		props.showGroupsLink,
		props.isWideMode,
		props.isInExperience,
		props.canvasTopPadding,
		showHeaderEntries,
		isPartyQuickStartEnabled2
	})

	local v20 = React.useMemo(function()
		local total = 0
		local values = {}

		for k, v21 in v19 do
			local v22

			if v21.isChatLandingModal then
				v22 = state3[v21.id] or 200
			else
				v22 = if fFlagAppIaScrollAway and v21.isCanvasTopPadding then v21.height else entryHeight
			end

			values[k] = Cryo.Dictionary.join(v21, { height = v22, yOffset = total })

			total += v22
		end

		return { items = values, contentHeight = total }
	end, { v19, entryHeight, state3 })

	React.useEffect(function()
		if v14 and ref5.current < defineFastInt and #itemList < defineFastInt2 then
			local v21 = ref5.current + 1

			if v15() then
				ref5.current = v21
				v5:info(
					"Loading more conversations because the list (count: {} out of {}) is not enough (attempt {} out of {})",
					#itemList,
					defineFastInt2,
					ref5.current,
					defineFastInt
				)
			end
		end
	end, { itemList, v14, v15 })

	React.useEffect(function()
		if v14 and v20.contentHeight > 0 and state.Y > 0 and v20.contentHeight <= state.Y and v15() then
			v5:info("Not enough UltimateList content to fill the view, loading more conversations")
		end
	end, { v20.contentHeight, state.Y, v14, v15 })

	local v21 = React.useCallback(function()
		if v15() then
			v5:debug("UltimateList onEndReached - Loading more conversations")
		end
	end, { v15 })

	local v22 = React.useCallback(function()
		if props.loadPrevious and not props.isLoadingPrevious then
			v5:debug("UltimateList onStartReached - Loading previous conversations")
			props.loadPrevious()
		end
	end, { props.loadPrevious, props.isLoadingPrevious })

	local v23 = React.useCallback(function(p2)
		setState(p2)
	end, {})
	local v24

	if fFlagFriendsChatConversationListShowScrollBar then
		v24 = React.useCallback(function()
			if ref3.current ~= nil then
				pcall(task.cancel, ref3.current)
				ref3.current = nil
			end

			v10(ReactOtter.instant(0))

			ref3.current = task.delay(v6, function()
				ref3.current = nil
				v10(ReactOtter.spring(1, v7))
			end)
		end, { v10 })

		React.useEffect(function()
			return function()
				if ref3.current ~= nil then
					pcall(task.cancel, ref3.current)
					ref3.current = nil
				end
			end
		end, {})
	else
		v24 = nil
	end

	local useCallback = React.useCallback
	local function fn(p2)
		if FFlagAppChatPerfTracking and ref.current then
			ref.current.onScrollTick()
		end

		if fFlagFriendsChatConversationListShowScrollBar and props.showScrollbarOnScroll then
			v24()
		end

		v8:fire()

		if entryHeight * defineFastInt4 >= v20.contentHeight - state.Y - p2 then
			v15()
		end

		onScrollUpdate({ CanvasPosition = Vector2.new(0, p2) })
	end

	local contentHeight = v20.contentHeight
	local y = state.Y

	local showScrollbarOnScroll = if fFlagFriendsChatConversationListShowScrollBar then props.showScrollbarOnScroll else nil
	local v27 = useCallback(fn, {
		v8,
		onScrollUpdate,
		entryHeight,
		contentHeight,
		y,
		v15,
		showScrollbarOnScroll,
		if fFlagFriendsChatConversationListShowScrollBar then v24 else nil
	})

	local v28 = React.useCallback(function(current)
		ref2.current = current
		setState2(current)
	end, {})
	local id = if itemList and itemList[1] then itemList[1].id else nil

	React.useEffect(function()
		local current = ref2.current

		if
			current ~= nil
			and id ~= nil
			and ref4.current ~= nil
			and ref4.current ~= id
			and current.CanvasPosition.Y <= 33
		then
			current.CanvasPosition = Vector2.new(0, 0)
		end

		ref4.current = id
	end, { id })

	local v29 = React.useCallback(function(props2)
		if props2.isChatLandingModal then
			return React.createElement(MeasuredChatLandingModal, {
				itemId = props2.id,
				onHeightChanged = v13
			})
		end

		if props2.isGroupLink then
			return React.createElement(ConversationGroupsEntryContainer, { entryHeight = entryHeight })
		end

		if isPartyQuickStartEnabled2 and props2.isQuickStartLink then
			return React.createElement(PartyQuickStartContainer, { entryHeight = entryHeight })
		end

		if partyPageCarouselExperimentation.getPartyPageCarouselEnabled() and props2.isSocialCarousel then
			local createElement = React.createElement
			local entry = SocialCarousel.Entry
			local v30 = {
				customTileList = v18,
				roduxKey = "ChatAppReducer",
				hideCarouselHeader = true,
				source = 0,
				unifiedLogging = 0
			}

			local v31 = if props.isInExperience then constants.ANALYTICS.SRC.PARTY_PAGE_IN_EXP else constants.ANALYTICS.SRC.PARTY_PAGE_UA
			v30.source = v31

			v30.unifiedLogging = v16
			return createElement(entry, v30)
		else
			if fFlagAppIaScrollAway and props2.isCanvasTopPadding then
				return React.createElement(view, {
					Size = UDim2.new(1, 0, 0, props2.height),
					backgroundStyle = v12.Color.None,
					BorderSizePixel = 0
				})
			end

			local createElement = React.createElement
			local v31 = {
				entryHeight = entryHeight,
				conversationId = props2.id,
				isSquadEnabled = canAccessParty,
				isWideMode = props.isWideMode,
				onActivated = props.onActivated,
				onSquadJoinButtonActivated = navigateToSquadLobby,
				key = "ConversationEntry" .. tostring(props2.id),
				fireImpressionEvent = fireConversationImpressionEvent,
				fireClickEvent = fireConversationClickedEvent,
				showBackground = rowProps.showBackground,
				localUserId = props.localUserId,
				debugCellValue = 0
			}
			local v32 = if props.isDebugEnabled then tostring(props2.id) else nil
			v31.debugCellValue = v32
			return createElement(ConversationRow, v31)
		end
	end, {
		entryHeight,
		canAccessParty,
		isPartyQuickStartEnabled2,
		v18,
		props.isInExperience,
		v16,
		props.onActivated,
		navigateToSquadLobby,
		fireConversationImpressionEvent,
		fireConversationClickedEvent,
		rowProps,
		props.isDebugEnabled,
		props.localUserId,
		props.isWideMode,
		v13,
		v12
	})

	if #v19 == 0 then
		return React.createElement(view, {
			Size = size,
			backgroundStyle = v12.Color.None,
			BorderSizePixel = 0,
			LayoutOrder = layoutOrder
		})
	end

	local v30 = not (state.X > 0 or state.Y > 0) and {} or v20.items

	local rctScrollView = {
		Name = "RCTScrollView",
		BackgroundTransparency = 1,
		ScrollBarThickness = fFlagFriendsChatConversationListShowScrollBar and props.showScrollbarOnScroll and (props.scrollbarThickness or 8) or 0,
		ScrollBarImageColor3 = 0,
		ScrollBarImageTransparency = 0,
		BorderSizePixel = 0
	}

	local v31 = if fFlagFriendsChatConversationListShowScrollBar and props.showScrollbarOnScroll then v12.Color.Content.Emphasis.Color3 else nil
	rctScrollView.ScrollBarImageColor3 = v31

	if not (fFlagFriendsChatConversationListShowScrollBar and props.showScrollbarOnScroll) then
		v9 = nil
	end

	rctScrollView.ScrollBarImageTransparency = v9

	return React.createElement(
		view,
		{
			Size = size,
			backgroundStyle = v12.Color.None,
			BorderSizePixel = 0,
			LayoutOrder = layoutOrder
		},
		{
			scroller = React.createElement(UltimateList.Components.ScrollingFrame, {
				dataSource = UltimateList.DataSources.array(v30),
				dimensions = UltimateList.Dimensions.getter(function(p2)
					return {
						size = UDim2.new(1, 0, 0, p2.height),
						position = UDim2.fromOffset(0, p2.yOffset)
					}
				end),
				renderer = UltimateList.Renderers.byState(v29),
				getKey = getKey,
				direction = "y",
				scrollingFrameRef = v28,
				onAbsoluteWindowSizeChanged = v23,
				onScrollAxisChanged = v27,
				onStartReached = v22,
				onEndReached = v21,
				onStartReachedThreshold = entryHeight * defineFastInt3,
				onEndReachedThreshold = entryHeight * defineFastInt4,
				native = rctScrollView
			})
		}
	)
end

return React.memo(ConversationListUltimate)
