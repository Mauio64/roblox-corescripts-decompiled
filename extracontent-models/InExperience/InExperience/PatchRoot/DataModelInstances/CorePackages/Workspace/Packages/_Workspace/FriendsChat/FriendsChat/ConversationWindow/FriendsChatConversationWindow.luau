local Players = game:GetService("Players")
local FriendsChat = script:FindFirstAncestor("FriendsChat")
local FriendsChatParent = FriendsChat.Parent
local React = require(FriendsChatParent.React)
local Signals = require(FriendsChatParent.Signals)
local SignalsReact = require(FriendsChatParent.SignalsReact)
local ExpChatShared = require(FriendsChatParent.ExpChatShared)
local Localization = require(FriendsChatParent.Localization)
local LocalizationRoactContext = Localization.LocalizationRoactContext
local localizeStrings = Localization.localizeStrings
local ConversationChannels = require(FriendsChatParent.AppChat.ConversationChannels)
local GetConversationMessageListStore = require(FriendsChatParent.AppChat.GetConversationMessageListStore)
local fetchMessagePage = require(FriendsChatParent.AppChat.fetchMessagePage)
local useChatWindow = require(script.Parent.Parent.Bridge.useChatWindow)
local useMessageDisplayStore = require(script.Parent.Parent.Message.MessageDisplayStore.useMessageDisplayStore)
local FFlagDebugFriendsChat = require(script.Parent.Parent.Flags.FFlagDebugFriendsChat)
local FStringDebugFriendsChatConversationId = require(script.Parent.Parent.Flags.FStringDebugFriendsChatConversationId)
local useMessagePool = require(FriendsChatParent.ChatUIPrimitives).useMessagePool
local useInterpolatedClientSettings = require(FriendsChatParent.ExpChatIntegration.useInterpolatedClientSettings)
local useChatWindowSettings = require(FriendsChatParent.ExpChatIntegration.useChatWindowSettings)
local ExpChatConversationListAdapter = require(script.Parent.Parent.ConversationList.ExpChatConversationListAdapter)
local FriendsChatTextMessage = require(script.Parent.Parent.Message.FriendsChatTextMessage)
local FriendsChatConversationHeaderBar = require(script.Parent.Parent.HeaderBar.FriendsChatConversationHeaderBar)
local getFriendsChatHeaderProps = require(script.Parent.Parent.HeaderBar.getFriendsChatHeaderProps)
local FriendsChatInputBarHost = require(script.Parent.FriendsChatInputBarHost)
local getMessageFadeSequence = require(script.Parent.getMessageFadeSequence)
local LayoutConstants = require(FriendsChat.LayoutConstants)
local useFriendsChatConversationTelemetry = require(script.Parent.Parent.Telemetry.ChatConversation.useFriendsChatConversationTelemetry)
local v29 = ExpChatShared.Logger:new(script.Name)
local v30 = React.createElement("UIListLayout", {
	SortOrder = Enum.SortOrder.LayoutOrder
})

local function toConversationModerationType(s1: string?) -- line: 99
	-- upvalues: ConversationChannels (copy)
	if s1 == ConversationChannels.ModerationType.TrustedComms or (s1 == ConversationChannels.ModerationType.Moderated or s1 == ConversationChannels.ModerationType.Invalid or s1 == ConversationChannels.ModerationType.UnknownType) then
		return s1
	end

	return nil
end
local function resolveFade(n1: number, p1) -- line: 113
	if type(p1) == "number" then
		return n1 + p1 * (1 - n1)
	end

	if p1 ~= nil then
		return p1:map(function(n2: number) -- line: 117
			-- upvalues: n1 (copy)
			return n1 + n2 * (1 - n1)
		end)
	end

	return n1
end
local function getHeaderOverlapPadding(p2) -- line: 124
	return p2:map(function(n3: number) -- line: 125
		return UDim.new(0, -n3)
	end)
end
local function getHeaderVisibleHeight(p3, p4) -- line: 130
	-- upvalues: React (copy)
	if type(p4) == "number" then
		local v46 = 1 - math.clamp(p4, 0, 1)

		return p3:map(function(n4: number) -- line: 133
			-- upvalues: v46 (copy)
			return n4 * v46
		end)
	end

	if p4 ~= nil then
		return React.joinBindings({
			height = p3,
			fade = p4
		}):map(function(t1: {[any]: any}) -- line: 140
			return t1.height * (1 - math.clamp(t1.fade, 0, 1))
		end)
	end

	return p3
end
local function getContentTopPadding(p5, p6, p7) -- line: 147
	-- upvalues: React (copy)
	return React.joinBindings({
		height = p5,
		visibleHeight = p6,
		canvasY = p7
	}):map(function(t2: {[any]: any}) -- line: 156
		local v122 = math.max(t2.height - t2.canvasY, 0)
		local v123 = math.min(t2.height - t2.visibleHeight, v122)

		return t2.height - v123
	end)
end
local function getHeaderInteractable(p8) -- line: 163
	if type(p8) == "number" then
		return p8 < 1
	end

	if p8 ~= nil then
		return p8:map(function(n5: number) -- line: 167
			return n5 < 1
		end)
	end

	return true
end
local function areArraysEqual(t3: {[any]: any}?, t4: {[any]: any}?) -- line: 174
	if t3 == t4 then
		return true
	end

	if t3 == nil or t4 == nil or #t3 ~= #t4 then
		return false
	end

	for v53, v54 in t3 do
		if v54 ~= t4[v53] then
			return false
		end
	end

	return true
end
local function areSelectedConversationHeaderFieldsEqual(t5: {[any]: any}?, t6: {[any]: any}?) -- line: 189
	if t5 == t6 then
		return true
	end

	if t5 == nil or t6 == nil then
		return false
	end

	local v57 = false

	if t5.source == t6.source then
		v57 = false

		if t5.title == t6.title then
			v57 = false

			if t5.titleForViewer == t6.titleForViewer then
				local participants = t5.participants
				local participants2 = t6.participants
				local g62

				if participants == participants2 then
					v57 = true
				elseif participants == nil or participants2 == nil or #participants ~= #participants2 then
					v57 = false
				else
					g62 = nil

					for v60, v61 in participants do
						if v61 ~= participants2[v60] then
							v57 = false
							g62 = true
						end

						if g62 then
							break
						end
					end

					if not g62 then
						v57 = true
					end
				end

				g62 = false

				if v57 then
					v57 = t5.moderationType == t6.moderationType
				end
			end
		end
	end

	return v57
end
local function FriendsChatConversationWindow(t7: {[any]: any}) -- line: 206
	-- upvalues: useChatWindow (copy), useChatWindowSettings (copy), React (copy), useInterpolatedClientSettings (copy), FFlagDebugFriendsChat (copy), FStringDebugFriendsChatConversationId (copy), Players (copy), ExpChatConversationListAdapter (copy), Signals (copy), ConversationChannels (copy), areSelectedConversationHeaderFieldsEqual (copy), SignalsReact (copy), getFriendsChatHeaderProps (copy), GetConversationMessageListStore (copy), LocalizationRoactContext (copy), localizeStrings (copy), useMessageDisplayStore (copy), FriendsChatTextMessage (copy), useMessagePool (copy), v30 (copy), fetchMessagePage (copy), v29 (copy), useFriendsChatConversationTelemetry (copy), getHeaderOverlapPadding (copy), getHeaderVisibleHeight (copy), getContentTopPadding (copy), getMessageFadeSequence (copy), getHeaderInteractable (copy), FriendsChatConversationHeaderBar (copy), LayoutConstants (copy), FriendsChatInputBarHost (copy)
	local v64 = useChatWindow()
	local v65 = useChatWindowSettings()
	local v66 = React.useMemo(function() -- line: 211
		-- upvalues: v65 (copy)
		return {
			BackgroundColor3 = v65.ChatWindowBackgroundColor3,
			BackgroundTransparency = v65.ChatWindowBackgroundTransparency
		}
	end, { v65 })
	local v67 = t7.chatWindowSettings or v66
	local v68 = useInterpolatedClientSettings(v67)
	local u69 = t7.conversationId or ""

	if u69 == "" and FFlagDebugFriendsChat then
		u69 = FStringDebugFriendsChatConversationId
	end

	local v70 = u69 ~= ""
	local LocalPlayer = Players.LocalPlayer
	local v72 = not LocalPlayer and 0 or LocalPlayer.UserId
	local v73 = ExpChatConversationListAdapter.getConversationStore()
	local v74 = React.useMemo(function() -- line: 230
		-- upvalues: Signals (copy), v70 (copy), v73 (copy), u69 (ref), ConversationChannels (copy), areSelectedConversationHeaderFieldsEqual (copy)
		return Signals.createComputed(function(p9) -- line: 231
			-- upvalues: v70 (copy), v73 (copy), u69 (ref), ConversationChannels (copy)
			if not v70 then
				return nil
			end

			local v136 = v73.getConversation(u69, p9)

			if v136 == nil then
				return nil
			end

			local t8 = {
				source = v136.source,
				title = v136.title,
				titleForViewer = v136.titleForViewer,
				participants = v136.participants
			}
			local moderationType = v136.moderationType

			t8.moderationType = if moderationType ~= ConversationChannels.ModerationType.TrustedComms and (moderationType ~= ConversationChannels.ModerationType.Moderated and (moderationType ~= ConversationChannels.ModerationType.Invalid and moderationType ~= ConversationChannels.ModerationType.UnknownType)) then nil else moderationType

			return t8
		end, areSelectedConversationHeaderFieldsEqual)
	end, {
		v73,
		u69,
		v70
	})
	local v75 = SignalsReact.useSignalState(v74)
	local v76 = React.useMemo(function() -- line: 249
		-- upvalues: v75 (copy), getFriendsChatHeaderProps (copy), v72 (copy)
		if v75 == nil then
			return nil
		end

		return getFriendsChatHeaderProps(v75, v72)
	end, {
		v75,
		v72
	})
	local v77 = ExpChatConversationListAdapter.isFriendPlaceholder(u69)
	local v78 = v70 and not v77
	local v79 = v70 and not v77

	React.useEffect(function() -- line: 259
		-- upvalues: v70 (copy), ExpChatConversationListAdapter (copy), u69 (ref)
		if v70 then
			ExpChatConversationListAdapter.markConversationRead(u69)
		end
	end, {
		u69,
		v70
	})

	local v80 = React.useMemo(function() -- line: 270
		-- upvalues: v79 (copy), GetConversationMessageListStore (copy), u69 (ref)
		if not v79 then
			return function() -- line: 272
				return {}
			end
		end

		return function(p10) -- line: 276
			-- upvalues: GetConversationMessageListStore (copy), u69 (ref)
			return GetConversationMessageListStore(p10).getOrderedIds(u69, p10)
		end
	end, {
		u69,
		v79
	})
	local v81 = React.useContext(LocalizationRoactContext)
	local v82 = React.useCallback(function(p11) -- line: 283
		-- upvalues: v81 (copy), localizeStrings (copy)
		if v81 == nil then
			return ""
		end

		local ok, result = pcall(function() -- line: 287
			-- upvalues: localizeStrings (copy), v81 (copy), p11 (copy)
			return localizeStrings(v81, {
				value = p11
			}).value
		end)

		if ok and typeof(result) == "string" then
			return result
		end

		return ""
	end, { v81 })
	local v83 = useMessageDisplayStore(v80, u69)
	local v84 = React.useCallback(function(p12) -- line: 302
		-- upvalues: React (copy), FriendsChatTextMessage (copy), v83 (copy), t7 (copy), v82 (copy)
		return React.createElement(FriendsChatTextMessage, {
			getDisplayId = p12.getMessageId,
			getDisplayFromId = v83.getDisplayFromId,
			getLayoutOrder = p12.getLayoutOrder,
			chatWindowSettings = t7.chatWindowSettings,
			textTransparency = t7.textTransparency,
			isSpatialUIEnabled = t7.isSpatialUIEnabled,
			localize = v82
		})
	end, {
		v83,
		t7.chatWindowSettings,
		t7.textTransparency,
		t7.isSpatialUIEnabled,
		v82
	})
	local v85 = useMessagePool({
		maxSlots = 50,
		messageIdsSignal = v83.getDisplayIds,
		createSlotElement = v84
	})
	local v86 = React.useMemo(function() -- line: 325
		-- upvalues: Signals (copy), v85 (copy), v30 (copy)
		return Signals.createComputed(function(p13) -- line: 326
			-- upvalues: v85 (copy), v30 (copy)
			local v141 = table.clone(v85(p13))

			v141["$layout"] = v30

			return v141
		end)
	end, { v85 })

	React.useEffect(function() -- line: 334
		-- upvalues: v79 (copy), fetchMessagePage (copy), u69 (ref), v29 (copy)
		if not v79 then
			return
		end

		local u129 = false

		fetchMessagePage(u69, nil):catch(function(p14) -- line: 349
			-- upvalues: u129 (ref), v29 (copy), u69 (ref)
			if u129 then
				return
			end

			v29:warning(`Failed to fetch conversation messages for { u69 }: { tostring(p14) }`)
		end)

		return function() -- line: 356
			-- upvalues: u129 (ref)
			u129 = true
		end
	end, {
		u69,
		v79
	})

	local v87 = React.useCallback(function() -- line: 365
		-- upvalues: v70 (copy), GetConversationMessageListStore (copy), u69 (ref)
		if not v70 then
			return 0
		end

		return #GetConversationMessageListStore(false).getOrderedIds(u69, false)
	end, {
		u69,
		v70
	})
	local v88 = useFriendsChatConversationTelemetry({
		conversationId = u69,
		getLoadedMessageCount = v87
	})
	local v89 = t7.parentLayoutOrder or 1
	local v90 = React.useCallback(function() -- line: 385
		-- upvalues: v29 (copy)
		v29:warning("resetTargetChannel called on FriendsChatConversationWindow; not supported")
	end, {})
	local v91 = React.useCallback(function() -- line: 388
		-- upvalues: v29 (copy)
		v29:warning("activateWhisperMode called on FriendsChatConversationWindow; not supported")
	end, {})
	local onOpenDetails = t7.onOpenDetails
	local fireInfoButtonClicked = v88.fireInfoButtonClicked
	local v94 = React.useCallback(function() -- line: 393
		-- upvalues: fireInfoButtonClicked (copy), onOpenDetails (copy), u69 (ref)
		fireInfoButtonClicked()
		onOpenDetails(u69)
	end, {
		fireInfoButtonClicked,
		onOpenDetails,
		u69
	})
	local v95, v96 = React.useBinding(0)
	local v97, v98 = React.useBinding(0)
	local v99 = React.useCallback(function(p15) -- line: 401
		-- upvalues: v96 (copy)
		v96(p15.AbsoluteSize.Y)
	end, {})
	local v100 = React.useMemo(function() -- line: 404
		-- upvalues: getHeaderOverlapPadding (copy), v95 (copy)
		return getHeaderOverlapPadding(v95)
	end, { v95 })
	local v101 = React.useMemo(function() -- line: 407
		-- upvalues: getHeaderVisibleHeight (copy), v95 (copy), t7 (copy)
		return getHeaderVisibleHeight(v95, t7.transparencyValue)
	end, {
		v95,
		t7.transparencyValue
	})
	local v102 = React.useMemo(function() -- line: 410
		-- upvalues: getContentTopPadding (copy), v95 (copy), v101 (copy), v97 (copy)
		return getContentTopPadding(v95, v101, v97)
	end, {
		v95,
		v101,
		v97
	})
	local v103, v104 = React.useBinding(0)
	local v105 = React.useCallback(function(p16) -- line: 414
		-- upvalues: v104 (copy)
		v104(p16.AbsoluteSize.Y)
	end, {})
	local v106 = React.useMemo(function() -- line: 417
		-- upvalues: React (copy), v95 (copy), v101 (copy), v103 (copy), getMessageFadeSequence (copy)
		return React.joinBindings({
			headerHeight = v95,
			headerVisibleHeight = v101,
			viewportHeight = v103
		}):map(function(t9: {[any]: any}) -- line: 422
			-- upvalues: getMessageFadeSequence (copy)
			local v144 = not (t9.headerHeight > 0) and 0 or t9.headerVisibleHeight / t9.headerHeight

			return getMessageFadeSequence(t9.headerHeight, t9.viewportHeight, v144)
		end)
	end, {
		v95,
		v101,
		v103
	})
	local v107 = React.useMemo(function() -- line: 429
		-- upvalues: getHeaderInteractable (copy), t7 (copy)
		return getHeaderInteractable(t7.transparencyValue)
	end, { t7.transparencyValue })
	local v108 = React.useCallback(function(vector2: Vector2, n6: number) -- line: 432
		-- upvalues: v98 (copy)
		v98((math.clamp(vector2.Y, 0, n6)))
	end, {})

	React.useEffect(function() -- line: 435
		-- upvalues: v98 (copy)
		v98(0)
	end, { u69 })

	local v109 = React.createElement(FriendsChatConversationHeaderBar, {
		layoutOrder = 1,
		suppressBackground = true,
		zIndex = 2,
		localUserId = v72,
		participantUserIds = if not v76 then nil else v76.participantUserIds,
		titleText = if not v76 then nil else v76.titleText,
		chatWindowSettings = v67,
		transparencyValue = t7.transparencyValue,
		onHovered = t7.onHovered,
		onUnhovered = t7.onUnhovered,
		onBack = t7.onBack,
		onActivated = if not t7.onOpenDetails or not v78 then nil else v94,
		onAbsoluteSizeChanged = v99,
		interactable = v107
	})
	local createElement = React.createElement
	local Fragment = React.Fragment
	local t10 = {}
	local createElement2 = React.createElement
	local t11 = {
		Name = "FriendsChatHeaderWindow",
		BorderSizePixel = 0,
		LayoutOrder = v89,
		BackgroundColor3 = v68.BackgroundColor3 or (v68.BackgroundColor or v65.ChatWindowBackgroundColor3)
	}
	local BackgroundTransparency = v68.BackgroundTransparency
	local transparencyValue = t7.transparencyValue

	t11.BackgroundTransparency = if type(transparencyValue) ~= "number" then if transparencyValue == nil then BackgroundTransparency else transparencyValue:map(function(n7: number) -- line: 117
		-- upvalues: BackgroundTransparency (copy)
		return BackgroundTransparency + n7 * (1 - BackgroundTransparency)
	end) else BackgroundTransparency + transparencyValue * (1 - BackgroundTransparency)
	t11.Size = UDim2.new(1, 0, 1, LayoutConstants.PanelTopSpacerHeight)
	t10.friendsChatHeaderWindow = createElement2("Frame", t11, {
		layout = React.createElement("UIListLayout", {
			Name = "FriendsChatHeaderWindowLayout",
			FillDirection = Enum.FillDirection.Vertical,
			Padding = v100,
			SortOrder = Enum.SortOrder.LayoutOrder
		}),
		header = v109,
		windowSlot = React.createElement("Frame", {
			Name = "FriendsChatWindowSlot",
			LayoutOrder = 2,
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			ZIndex = 1,
			Size = UDim2.fromScale(1, 0)
		}, {
			flex = React.createElement("UIFlexItem", {
				FlexMode = Enum.UIFlexMode.Fill
			}),
			messageMask = React.createElement("CanvasGroup", {
				Name = "FriendsChatMessageMask",
				BackgroundTransparency = 1,
				BorderSizePixel = 0,
				ClipsDescendants = true,
				GroupTransparency = 0,
				Size = UDim2.fromScale(1, 1),
				[React.Change.AbsoluteSize] = v105
			}, {
				fade = React.createElement("UIGradient", {
					Rotation = 90,
					Transparency = v106
				}),
				window = React.createElement(v64, {
					suppressBackground = true,
					disableLineReporting = true,
					size = UDim2.fromScale(1, 1),
					isChannelBarVisible = t7.isChannelBarVisible,
					scrollResetKey = "FriendsChat:" .. u69,
					onCanvasPositionChanged = v108,
					contentTopPadding = v102,
					messageComponentsSignal = v86,
					chatWindowSettings = v67,
					transparencyValue = t7.transparencyValue,
					textTransparency = t7.textTransparency,
					isSpatialUIEnabled = t7.isSpatialUIEnabled,
					onHovered = t7.onHovered,
					onUnhovered = t7.onUnhovered,
					onAbsoluteSizeChanged = t7.onAbsoluteSizeChanged,
					onAbsolutePositionChanged = t7.onAbsolutePositionChanged,
					resetTargetChannel = v90,
					activateWhisperMode = v91
				})
			})
		})
	})
	t10.friendsChatInput = React.createElement(FriendsChatInputBarHost, {
		LayoutOrder = v89 + 1,
		conversationId = u69,
		conversationModerationType = if not v75 then nil else v75.moderationType,
		onFriendPlaceholderConversationCreated = t7.onFriendPlaceholderConversationCreated,
		chatWindowSettings = t7.chatWindowSettings,
		transparencyValue = t7.transparencyValue,
		isSpatialUIEnabled = t7.isSpatialUIEnabled,
		onHovered = t7.onHovered,
		onUnhovered = t7.onUnhovered
	})

	return createElement(Fragment, nil, t10)
end

return FriendsChatConversationWindow
