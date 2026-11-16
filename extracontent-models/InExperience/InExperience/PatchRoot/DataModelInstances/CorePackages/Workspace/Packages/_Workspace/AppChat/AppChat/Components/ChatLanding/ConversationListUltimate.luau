local IXPService = game:GetService("IXPService")

local AppChat = script:FindFirstAncestor("AppChat")
local parent = AppChat.Parent

local SocialExperiments = require(parent.SocialExperiments)
local AppChatPerfExperimentation = SocialExperiments.AppChatPerfExperimentation
local RobloxAppEnums = require(parent.RobloxAppEnums)
local AppPage = RobloxAppEnums.AppPage
local ReactFocusNavigation = require(parent.ReactFocusNavigation)
local CoreGui = ReactFocusNavigation.EngineInterface.CoreGui
local Cryo = require(parent.Cryo)
local ReactFocusNavigation2 = require(parent.ReactFocusNavigation)
local FocusNavigationService = ReactFocusNavigation2.FocusNavigationService
local React = require(parent.React)
local ReactOtter = require(parent.ReactOtter)
local SharedFlags = require(parent.SharedFlags)
local AppCommonLib = require(parent.AppCommonLib)
local Signal = AppCommonLib.Signal
local SocialCarousel = require(parent.SocialCarousel)
local SocialExperiments2 = require(parent.SocialExperiments)
local Foundation = require(parent.Foundation)
local UltimateList = require(parent.UltimateList)
local View = Foundation.View
local useTokens = Foundation.Hooks.useTokens

local FFlagAppChatPerfTracking = require(AppChat.Flags.FFlagAppChatPerfTracking)
local AppChatPerfTracker = require(AppChat.Telemetry.AppChatPerfTracker)
local createScrollIntervalTracker = require(AppChat.Telemetry.createScrollIntervalTracker)

local Constants = SocialCarousel.Constants
local Enums = SocialCarousel.Enums

local SquadQuickStartExperimentation = SocialExperiments2.SquadQuickStartExperimentation

local ChatLandingModalContainer = require(script.Parent.ChatLandingModal.ChatLandingModalContainer)
local ConversationRow = require(script.Parent.ConversationRow)
local ConversationGroupsEntryContainer = require(script.Parent.ConversationGroupsEntryContainer)
local PartyQuickStartContainer = require(script.Parent.PartyQuickStartContainer)
local defineFastInt = game:DefineFastInt("AppChatChatLandingInitialFetchLimit", 5)
local FFlagAppIaScrollAway = SharedFlags.FFlagAppIaScrollAway
local FFlagFriendsChatConversationListShowScrollBar = SharedFlags.FFlagFriendsChatConversationListShowScrollBar

local defineFastInt2 = game:DefineFastInt("AppChatChatLandingInitialFetchMinimumConversations", 30)

local FFlagAppChatRemoveConversationListDividerIxpEnabled = require(AppChat.Flags.FFlagAppChatRemoveConversationListDividerIxpEnabled)

local FStringAppChatRemoveConversationListDividerIxpLayer = require(AppChat.Flags.FStringAppChatRemoveConversationListDividerIxpLayer)

local defineFastInt3 = game:DefineFastInt("AppChatPerfChatLandingPaginationOnStartReachedUnits", 1)

local defineFastInt4 = game:DefineFastInt("AppChatPerfChatLandingPaginationOnEndReachedUnits", 10)

local defineFastInt5 = game:DefineFastInt("AppChatConversationListScrollBarIdleHideMs", 1500)

local SocialExperiments3 = require(parent.SocialExperiments)
local PartyPageCarouselExperimentation = SocialExperiments3.PartyPageCarouselExperimentation

local Logger = require(script.Parent.Logger)
local v = Logger:new(script.Name)

local v2 = defineFastInt5 / 1000
local v3 = {
	dampingRatio = 1,
	frequency = 2,
	restingVelocityLimit = 0.1,
	restingPositionLimit = 0.1
}

local function noop() end

local function isPartyQuickStartEnabled(props) -- 1 equivalent call inferred from this helper
	return props.isPartyQuickStartEnabled
end

local function getIsSquadEnabledForRows(props): boolean -- 1 equivalent call inferred from this helper
	return props.canAccessParty == true
end

local function getConversationRowListItems(itemList)
	local conversationRowListItems = {}

	for k, item in itemList do
		conversationRowListItems[k] = { id = tostring(item.id) }
	end

	return conversationRowListItems
end

local function getFirstId(list) -- 2 equivalent calls inferred from this helper
	return if list and list[1] then list[1].id else nil
end

local function getLastId(list) -- 1 equivalent call inferred from this helper
	if list and list[#list] then
		return list[#list].id
	end

	return nil
end

local function getAutoLoadNextRequestKey(itemList) -- 1 equivalent call inferred from this helper
	return `{#itemList}:{tostring(getFirstId(itemList))}:{tostring(getLastId(itemList))}` -- inferred equivalent call
end

local function getKey(p)
	return (tostring(p.id))
end

local function MeasuredChatLandingModal(p)
	local ref = React.useRef(nil)

	React.useEffect(function()
		local current = ref.current

		if current ~= nil then
			p.onHeightChanged(p.itemId, current.AbsoluteSize.Y)
		end
	end, { p.itemId, p.onHeightChanged })

	return React.createElement("Frame", {
		BackgroundTransparency = 1,
		Size = UDim2.new(1, 0, 0, 0),
		AutomaticSize = Enum.AutomaticSize.Y,
		ref = ref,
		[React.Change.AbsoluteSize] = function(p2)
			p.onHeightChanged(p.itemId, p2.AbsoluteSize.Y)
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
	local scrollViewPositionChangedSignal = React.useMemo(function()
		return Signal.new()
	end, {})
	local ref = React.useRef(nil)
	local ref2 = React.useRef(nil)
	local ref3, scrollBarImageTransparency, v4

	if FFlagFriendsChatConversationListShowScrollBar then
		ref3 = React.useRef(nil)
		scrollBarImageTransparency, v4 = ReactOtter.useAnimatedBinding(1)
	else
		ref3 = nil
		v4 = nil
	end

	local ref4 = React.useRef(nil)
	local ref5 = React.useRef(0)
	local current2 = React.useMemo(function()
		return getAutoLoadNextRequestKey(itemList) -- inferred equivalent call
	end, { itemList })
	local ref6 = React.useRef(nil)
	local ref7 = React.useRef(false)
	local state, setState = React.useState(Vector2.new(0, 0))
	local state2, setState2 = React.useState(nil)
	local v5 = useTokens()
	local state3, setState3 = React.useState({})
	local onHeightChanged = React.useCallback(function(p, p2)
		if p2 < 0 then
			return
		end

		setState3(function(p3)
			if p3[p] == p2 then
				return p3
			end

			return Cryo.Dictionary.join(p3, { [p] = p2 })
		end)
	end, {})
	local v6

	if props.loadNext == nil then
		v6 = false
	else
		v6 = not (props.isLoadingNext or props.oldestConversationIsFetched)
	end

	React.useEffect(function()
		if ref7.current and not props.isLoadingNext then
			ref6.current = nil
		end

		ref7.current = props.isLoadingNext == true
	end, { props.isLoadingNext })

	local v7 = React.useCallback(function(): boolean
		if not v6 or ref6.current == current2 then
			return false
		end

		ref6.current = current2
		props.loadNext()
		return true
	end, { v6, current2, props.loadNext })

	React.useEffect(function()
		AppChatPerfExperimentation.logExposure()

		if props.shouldLogHeaderEntryExposures ~= false then
			PartyPageCarouselExperimentation.logExposure()
			SquadQuickStartExperimentation.logExposure()

			if FFlagAppChatRemoveConversationListDividerIxpEnabled then
				IXPService:LogFlagLinkedUserLayerExposure(FStringAppChatRemoveConversationListDividerIxpLayer)
			end
		end
	end, {})

	React.useEffect(function()
		local v8 = FocusNavigationService.new(CoreGui)
		return function()
			v8:teardown()
		end
	end, {})
	local isSquadEnabledForRows = getIsSquadEnabledForRows(props) -- inferred equivalent call
	React.useEffect(function()
		local v8 = state2

		if v8 == nil then
			return nil
		end

		v8.Selectable = false

		if not FFlagAppChatPerfTracking then
			return nil
		end

		ref.current = createScrollIntervalTracker(AppChatPerfTracker.Events.ScrollConversationList, v8)
		return function()
			if ref.current then
				ref.current.cleanup()
				ref.current = nil
			end
		end
	end, { state2 })
	local partyQuickStartEnabled = isPartyQuickStartEnabled(props) -- inferred equivalent call
	local unifiedLogging = React.useMemo(function()
		local v8 = {
			appPage = AppPage.Chat,
			impressionTag = 0,
			scrollViewPositionChangedSignal = 0,
			sortId = 0,
			sortIndex = 1
		}
		local impressionTag

		if props.isInExperience then
			impressionTag = Constants.ANALYTICS.SRC.PARTY_PAGE_IN_EXP
		else
			impressionTag = Constants.ANALYTICS.SRC.PARTY_PAGE_UA
		end

		v8.impressionTag = impressionTag

		v8.scrollViewPositionChangedSignal = scrollViewPositionChangedSignal
		return v8
	end, { props.isInExperience, scrollViewPositionChangedSignal })

	local onActivated = React.useCallback(function(p)
		navigateToConversationFromUserId(p.id)
	end, { navigateToConversationFromUserId })

	local customTileList = React.useMemo(function()
		return {
			{
				tileGroup = Enums.TileGroup.StartSquad,
				onActivated = navigateToQuickStartSquadInviteFriends
			},
			{ tileGroup = Enums.TileGroup.FriendsList, onActivated = onActivated }
		}
	end, { navigateToQuickStartSquadInviteFriends, onActivated })

	local v8 = React.useMemo(function()
		local conversationRowListItems = getConversationRowListItems(itemList)
		local v8 = props.filterText == "" or props.filterText == nil
		local v9 = showHeaderEntries and v8

		if v9 and props.showGroupsLink then
			conversationRowListItems = Cryo.List.join({
				{ id = "ConversationGroupsEntryContainer", isGroupLink = true }
			}, conversationRowListItems)
		end

		if v9 and not PartyPageCarouselExperimentation.getPartyPageCarouselEnabled() and partyQuickStartEnabled then
			conversationRowListItems = Cryo.List.join({
				{ id = "PartyQuickStartContainer", isQuickStartLink = true }
			}, conversationRowListItems)
		end

		if v9 then
			if
				partyQuickStartEnabled
				and PartyPageCarouselExperimentation.getPartyPageCarouselEnabled()
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

		if FFlagAppIaScrollAway and (props.canvasTopPadding or 0) > 0 then
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
		partyQuickStartEnabled
	})

	local v9 = React.useMemo(function()
		local total = 0
		local values = {}

		for k, v9 in v8 do
			local height

			if v9.isChatLandingModal then
				height = state3[v9.id] or 200
			elseif FFlagAppIaScrollAway and v9.isCanvasTopPadding then
				height = v9.height
			else
				height = entryHeight
			end

			values[k] = Cryo.Dictionary.join(v9, { height = height, yOffset = total })

			total += height
		end

		return { items = values, contentHeight = total }
	end, { v8, entryHeight, state3 })

	React.useEffect(function()
		if v6 and ref5.current < defineFastInt and #itemList < defineFastInt2 then
			local current = ref5.current + 1

			if v7() then
				ref5.current = current
				v:info(
					"Loading more conversations because the list (count: {} out of {}) is not enough (attempt {} out of {})",
					#itemList,
					defineFastInt2,
					ref5.current,
					defineFastInt
				)
			end
		end
	end, { itemList, v6, v7 })

	React.useEffect(function()
		if v6 and v9.contentHeight > 0 and state.Y > 0 and v9.contentHeight <= state.Y and v7() then
			v:info("Not enough UltimateList content to fill the view, loading more conversations")
		end
	end, { v9.contentHeight, state.Y, v6, v7 })

	local onEndReached = React.useCallback(function()
		if v7() then
			v:debug("UltimateList onEndReached - Loading more conversations")
		end
	end, { v7 })

	local onStartReached = React.useCallback(function()
		if props.loadPrevious and not props.isLoadingPrevious then
			v:debug("UltimateList onStartReached - Loading previous conversations")
			props.loadPrevious()
		end
	end, { props.loadPrevious, props.isLoadingPrevious })

	local onAbsoluteWindowSizeChanged = React.useCallback(function(p)
		setState(p)
	end, {})
	local v10

	if FFlagFriendsChatConversationListShowScrollBar then
		v10 = React.useCallback(function()
			if ref3.current ~= nil then
				pcall(task.cancel, ref3.current)
				ref3.current = nil
			end

			v4(ReactOtter.instant(0))

			ref3.current = task.delay(v2, function()
				ref3.current = nil
				v4(ReactOtter.spring(1, v3))
			end)
		end, { v4 })

		React.useEffect(function()
			return function()
				if ref3.current ~= nil then
					pcall(task.cancel, ref3.current)
					ref3.current = nil
				end
			end
		end, {})
	else
		v10 = nil
	end

	local useCallback = React.useCallback
	local function fn(p)
		if FFlagAppChatPerfTracking and ref.current then
			ref.current.onScrollTick()
		end

		if FFlagFriendsChatConversationListShowScrollBar and props.showScrollbarOnScroll then
			v10()
		end

		scrollViewPositionChangedSignal:fire()

		if entryHeight * defineFastInt4 >= v9.contentHeight - state.Y - p then
			v7()
		end

		onScrollUpdate({ CanvasPosition = Vector2.new(0, p) })
	end

	local contentHeight = v9.contentHeight
	local y = state.Y
	local showScrollbarOnScroll

	if FFlagFriendsChatConversationListShowScrollBar then
		showScrollbarOnScroll = props.showScrollbarOnScroll
	end

	local v11

	if FFlagFriendsChatConversationListShowScrollBar then
		v11 = v10
	end

	local onScrollAxisChanged = useCallback(fn, {
		scrollViewPositionChangedSignal,
		onScrollUpdate,
		entryHeight,
		contentHeight,
		y,
		v7,
		showScrollbarOnScroll,
		v11
	})

	local scrollingFrameRef = React.useCallback(function(current)
		ref2.current = current
		setState2(current)
	end, {})
	local firstId = getFirstId(itemList) -- inferred equivalent call
	React.useEffect(function()
		local current = ref2.current

		if
			current ~= nil
			and firstId ~= nil
			and ref4.current ~= nil
			and ref4.current ~= firstId
			and current.CanvasPosition.Y <= 33
		then
			current.CanvasPosition = Vector2.new(0, 0)
		end

		ref4.current = firstId
	end, { firstId })

	local v12 = React.useCallback(function(props2)
		if props2.isChatLandingModal then
			return React.createElement(MeasuredChatLandingModal, {
				itemId = props2.id,
				onHeightChanged = onHeightChanged
			})
		end

		if props2.isGroupLink then
			return React.createElement(ConversationGroupsEntryContainer, {
				entryHeight = entryHeight
			})
		end

		if partyQuickStartEnabled and props2.isQuickStartLink then
			return React.createElement(PartyQuickStartContainer, { entryHeight = entryHeight })
		end

		if PartyPageCarouselExperimentation.getPartyPageCarouselEnabled() and props2.isSocialCarousel then
			local createElement = React.createElement
			local entry = SocialCarousel.Entry
			local v12 = {
				customTileList = customTileList,
				roduxKey = "ChatAppReducer",
				hideCarouselHeader = true,
				source = 0,
				unifiedLogging = 0
			}
			local source

			if props.isInExperience then
				source = Constants.ANALYTICS.SRC.PARTY_PAGE_IN_EXP
			else
				source = Constants.ANALYTICS.SRC.PARTY_PAGE_UA
			end

			v12.source = source

			v12.unifiedLogging = unifiedLogging
			return createElement(entry, v12)
		else
			if FFlagAppIaScrollAway and props2.isCanvasTopPadding then
				return React.createElement(View, {
					Size = UDim2.new(1, 0, 0, props2.height),
					backgroundStyle = v5.Color.None,
					BorderSizePixel = 0
				})
			end

			local createElement = React.createElement
			local v12 = {
				entryHeight = entryHeight,
				conversationId = props2.id,
				isSquadEnabled = isSquadEnabledForRows,
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
			local debugCellValue

			if props.isDebugEnabled then
				debugCellValue = tostring(props2.id)
			end

			v12.debugCellValue = debugCellValue
			return createElement(ConversationRow, v12)
		end
	end, {
		entryHeight,
		isSquadEnabledForRows,
		partyQuickStartEnabled,
		customTileList,
		props.isInExperience,
		unifiedLogging,
		props.onActivated,
		navigateToSquadLobby,
		fireConversationImpressionEvent,
		fireConversationClickedEvent,
		rowProps,
		props.isDebugEnabled,
		props.localUserId,
		props.isWideMode,
		onHeightChanged,
		v5
	})

	if #v8 == 0 then
		return React.createElement(View, {
			Size = size,
			backgroundStyle = v5.Color.None,
			BorderSizePixel = 0,
			LayoutOrder = layoutOrder
		})
	end

	local v13 = not (state.X > 0 or state.Y > 0) and {} or v9.items

	local rctScrollView = {
		Name = "RCTScrollView",
		BackgroundTransparency = 1,
		ScrollBarThickness = FFlagFriendsChatConversationListShowScrollBar and props.showScrollbarOnScroll and (props.scrollbarThickness or 8) or 0,
		ScrollBarImageColor3 = 0,
		ScrollBarImageTransparency = 0,
		BorderSizePixel = 0
	}
	local scrollBarImageColor

	if FFlagFriendsChatConversationListShowScrollBar and props.showScrollbarOnScroll then
		scrollBarImageColor = v5.Color.Content.Emphasis.Color3
	end

	rctScrollView.ScrollBarImageColor3 = scrollBarImageColor

	if not (FFlagFriendsChatConversationListShowScrollBar and props.showScrollbarOnScroll) then
		scrollBarImageTransparency = nil
	end

	rctScrollView.ScrollBarImageTransparency = scrollBarImageTransparency

	return React.createElement(
		View,
		{
			Size = size,
			backgroundStyle = v5.Color.None,
			BorderSizePixel = 0,
			LayoutOrder = layoutOrder
		},
		{
			scroller = React.createElement(UltimateList.Components.ScrollingFrame, {
				dataSource = UltimateList.DataSources.array(v13),
				dimensions = UltimateList.Dimensions.getter(function(p)
					return {
						size = UDim2.new(1, 0, 0, p.height),
						position = UDim2.fromOffset(0, p.yOffset)
					}
				end),
				renderer = UltimateList.Renderers.byState(v12),
				getKey = getKey,
				direction = "y",
				scrollingFrameRef = scrollingFrameRef,
				onAbsoluteWindowSizeChanged = onAbsoluteWindowSizeChanged,
				onScrollAxisChanged = onScrollAxisChanged,
				onStartReached = onStartReached,
				onEndReached = onEndReached,
				onStartReachedThreshold = entryHeight * defineFastInt3,
				onEndReachedThreshold = entryHeight * defineFastInt4,
				native = rctScrollView
			})
		}
	)
end

return React.memo(ConversationListUltimate)
