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
local ExpChatConversationListAdapter = require(script.Parent.Parent.ConversationList.ExpChatConversationListAdapter)
local FriendsChatTextMessage = require(script.Parent.Parent.Message.FriendsChatTextMessage)
local FriendsChatConversationHeaderBar = require(script.Parent.Parent.HeaderBar.FriendsChatConversationHeaderBar)
local getFriendsChatHeaderProps = require(script.Parent.Parent.HeaderBar.getFriendsChatHeaderProps)
local FriendsChatInputBarHost = require(script.Parent.FriendsChatInputBarHost)
local LayoutConstants = require(FriendsChat.LayoutConstants)
local useFriendsChatConversationTelemetry = require(script.Parent.Parent.Telemetry.ChatConversation.useFriendsChatConversationTelemetry)
local v26 = ExpChatShared.Logger:new(script.Name)
local v27 = React.createElement("UIListLayout", {
	SortOrder = Enum.SortOrder.LayoutOrder
})

local function toConversationModerationType(s1: string?) -- line: 96
	-- upvalues: ConversationChannels (copy)
	if s1 == ConversationChannels.ModerationType.TrustedComms or (s1 == ConversationChannels.ModerationType.Moderated or s1 == ConversationChannels.ModerationType.Invalid or s1 == ConversationChannels.ModerationType.UnknownType) then
		return s1
	end

	return nil
end
local function areArraysEqual(t1: {[any]: any}?, t2: {[any]: any}?) -- line: 108
	if t1 == t2 then
		return true
	end

	if t1 == nil or t2 == nil or #t1 ~= #t2 then
		return false
	end

	for v35, v36 in t1 do
		if v36 ~= t2[v35] then
			return false
		end
	end

	return true
end
local function areSelectedConversationHeaderFieldsEqual(t3: {[any]: any}?, t4: {[any]: any}?) -- line: 123
	if t3 == t4 then
		return true
	end

	if t3 == nil or t4 == nil then
		return false
	end

	local v39 = false

	if t3.source == t4.source then
		v39 = false

		if t3.title == t4.title then
			v39 = false

			if t3.titleForViewer == t4.titleForViewer then
				local participants = t3.participants
				local participants2 = t4.participants
				local g44

				if participants == participants2 then
					v39 = true
				elseif participants == nil or participants2 == nil or #participants ~= #participants2 then
					v39 = false
				else
					g44 = nil

					for v42, v43 in participants do
						if v43 ~= participants2[v42] then
							v39 = false
							g44 = true
						end

						if g44 then
							break
						end
					end

					if not g44 then
						v39 = true
					end
				end

				g44 = false

				if v39 then
					v39 = t3.moderationType == t4.moderationType
				end
			end
		end
	end

	return v39
end
local function FriendsChatConversationWindow(t5: {[any]: any}) -- line: 140
	-- upvalues: useChatWindow (copy), FFlagDebugFriendsChat (copy), FStringDebugFriendsChatConversationId (copy), Players (copy), ExpChatConversationListAdapter (copy), React (copy), Signals (copy), ConversationChannels (copy), areSelectedConversationHeaderFieldsEqual (copy), SignalsReact (copy), getFriendsChatHeaderProps (copy), GetConversationMessageListStore (copy), LocalizationRoactContext (copy), localizeStrings (copy), useMessageDisplayStore (copy), FriendsChatTextMessage (copy), useMessagePool (copy), v27 (copy), fetchMessagePage (copy), v26 (copy), useFriendsChatConversationTelemetry (copy), LayoutConstants (copy), FriendsChatConversationHeaderBar (copy), FriendsChatInputBarHost (copy)
	local v46 = useChatWindow()
	local u47 = t5.conversationId or ""

	if u47 == "" and FFlagDebugFriendsChat then
		u47 = FStringDebugFriendsChatConversationId
	end

	local v48 = u47 ~= ""
	local LocalPlayer = Players.LocalPlayer
	local v50 = not LocalPlayer and 0 or LocalPlayer.UserId
	local v51 = ExpChatConversationListAdapter.getConversationStore()
	local v52 = React.useMemo(function() -- line: 155
		-- upvalues: Signals (copy), v48 (copy), v51 (copy), u47 (ref), ConversationChannels (copy), areSelectedConversationHeaderFieldsEqual (copy)
		return Signals.createComputed(function(p1) -- line: 156
			-- upvalues: v48 (copy), v51 (copy), u47 (ref), ConversationChannels (copy)
			if not v48 then
				return nil
			end

			local v79 = v51.getConversation(u47, p1)

			if v79 == nil then
				return nil
			end

			local t6 = {
				source = v79.source,
				title = v79.title,
				titleForViewer = v79.titleForViewer,
				participants = v79.participants
			}
			local moderationType = v79.moderationType

			t6.moderationType = if moderationType ~= ConversationChannels.ModerationType.TrustedComms and (moderationType ~= ConversationChannels.ModerationType.Moderated and (moderationType ~= ConversationChannels.ModerationType.Invalid and moderationType ~= ConversationChannels.ModerationType.UnknownType)) then nil else moderationType

			return t6
		end, areSelectedConversationHeaderFieldsEqual)
	end, {
		v51,
		u47,
		v48
	})
	local v53 = SignalsReact.useSignalState(v52)
	local v54 = React.useMemo(function() -- line: 174
		-- upvalues: v53 (copy), getFriendsChatHeaderProps (copy), v50 (copy)
		if v53 == nil then
			return nil
		end

		return getFriendsChatHeaderProps(v53, v50)
	end, {
		v53,
		v50
	})
	local v55 = ExpChatConversationListAdapter.isFriendPlaceholder(u47)
	local v56 = v48 and not v55
	local v57 = v48 and not v55

	React.useEffect(function() -- line: 184
		-- upvalues: v48 (copy), ExpChatConversationListAdapter (copy), u47 (ref)
		if v48 then
			ExpChatConversationListAdapter.markConversationRead(u47)
		end
	end, {
		u47,
		v48
	})

	local v58 = React.useMemo(function() -- line: 195
		-- upvalues: v57 (copy), GetConversationMessageListStore (copy), u47 (ref)
		if not v57 then
			return function() -- line: 197
				return {}
			end
		end

		return function(p2) -- line: 201
			-- upvalues: GetConversationMessageListStore (copy), u47 (ref)
			return GetConversationMessageListStore(p2).getOrderedIds(u47, p2)
		end
	end, {
		u47,
		v57
	})
	local v59 = React.useContext(LocalizationRoactContext)
	local v60 = React.useCallback(function(p3) -- line: 208
		-- upvalues: v59 (copy), localizeStrings (copy)
		if v59 == nil then
			return ""
		end

		local ok, result = pcall(function() -- line: 212
			-- upvalues: localizeStrings (copy), v59 (copy), p3 (copy)
			return localizeStrings(v59, {
				value = p3
			}).value
		end)

		if ok and typeof(result) == "string" then
			return result
		end

		return ""
	end, { v59 })
	local v61 = useMessageDisplayStore(v58, u47, v60)
	local v62 = React.useCallback(function(p4) -- line: 226
		-- upvalues: React (copy), FriendsChatTextMessage (copy), v61 (copy), t5 (copy)
		return React.createElement(FriendsChatTextMessage, {
			getDisplayId = p4.getMessageId,
			getDisplayFromId = v61.getDisplayFromId,
			getLayoutOrder = p4.getLayoutOrder,
			chatWindowSettings = t5.chatWindowSettings,
			textTransparency = t5.textTransparency,
			isSpatialUIEnabled = t5.isSpatialUIEnabled
		})
	end, {
		v61,
		t5.chatWindowSettings,
		t5.textTransparency,
		t5.isSpatialUIEnabled
	})
	local v63 = useMessagePool({
		maxSlots = 50,
		messageIdsSignal = v61.getDisplayIds,
		createSlotElement = v62
	})
	local v64 = React.useMemo(function() -- line: 246
		-- upvalues: Signals (copy), v63 (copy), v27 (copy)
		return Signals.createComputed(function(p5) -- line: 247
			-- upvalues: v63 (copy), v27 (copy)
			local v84 = table.clone(v63(p5))

			v84["$layout"] = v27

			return v84
		end)
	end, { v63 })

	React.useEffect(function() -- line: 255
		-- upvalues: v57 (copy), fetchMessagePage (copy), u47 (ref), v26 (copy)
		if not v57 then
			return
		end

		local u77 = false

		fetchMessagePage(u47, nil):catch(function(p6) -- line: 270
			-- upvalues: u77 (ref), v26 (copy), u47 (ref)
			if u77 then
				return
			end

			v26:warning(`Failed to fetch conversation messages for { u47 }: { tostring(p6) }`)
		end)

		return function() -- line: 277
			-- upvalues: u77 (ref)
			u77 = true
		end
	end, {
		u47,
		v57
	})

	local v65 = React.useCallback(function() -- line: 286
		-- upvalues: v48 (copy), GetConversationMessageListStore (copy), u47 (ref)
		if not v48 then
			return 0
		end

		return #GetConversationMessageListStore(false).getOrderedIds(u47, false)
	end, {
		u47,
		v48
	})
	local v66 = useFriendsChatConversationTelemetry({
		conversationId = u47,
		getLoadedMessageCount = v65
	})
	local v67 = t5.parentLayoutOrder or 1
	local v68 = React.useCallback(function() -- line: 306
		-- upvalues: v26 (copy)
		v26:warning("resetTargetChannel called on FriendsChatConversationWindow; not supported")
	end, {})
	local v69 = React.useCallback(function() -- line: 309
		-- upvalues: v26 (copy)
		v26:warning("activateWhisperMode called on FriendsChatConversationWindow; not supported")
	end, {})
	local onOpenDetails = t5.onOpenDetails
	local fireInfoButtonClicked = v66.fireInfoButtonClicked
	local v72 = React.useCallback(function() -- line: 314
		-- upvalues: fireInfoButtonClicked (copy), onOpenDetails (copy), u47 (ref)
		fireInfoButtonClicked()
		onOpenDetails(u47)
	end, {
		fireInfoButtonClicked,
		onOpenDetails,
		u47
	})

	return React.createElement(React.Fragment, nil, {
		friendsChatHeaderWindow = React.createElement("Frame", {
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			LayoutOrder = v67,
			Size = UDim2.new(1, 0, 1, LayoutConstants.PanelTopSpacerHeight)
		}, {
			layout = React.createElement("UIListLayout", {
				FillDirection = Enum.FillDirection.Vertical,
				SortOrder = Enum.SortOrder.LayoutOrder
			}),
			header = React.createElement(FriendsChatConversationHeaderBar, {
				layoutOrder = 1,
				localUserId = v50,
				participantUserIds = if not v54 then nil else v54.participantUserIds,
				titleText = if not v54 then nil else v54.titleText,
				chatWindowSettings = t5.chatWindowSettings,
				transparencyValue = t5.transparencyValue,
				onHovered = t5.onHovered,
				onUnhovered = t5.onUnhovered,
				onBack = t5.onBack,
				onActivated = if not t5.onOpenDetails or not v56 then nil else v72
			}),
			windowSlot = React.createElement("Frame", {
				LayoutOrder = 2,
				BackgroundTransparency = 1,
				BorderSizePixel = 0,
				Size = UDim2.fromScale(1, 0)
			}, {
				flex = React.createElement("UIFlexItem", {
					FlexMode = Enum.UIFlexMode.Fill
				}),
				window = React.createElement(v46, {
					disableLineReporting = true,
					size = UDim2.fromScale(1, 1),
					isChannelBarVisible = t5.isChannelBarVisible,
					scrollResetKey = "FriendsChat:" .. u47,
					messageComponentsSignal = v64,
					chatWindowSettings = t5.chatWindowSettings,
					transparencyValue = t5.transparencyValue,
					textTransparency = t5.textTransparency,
					isSpatialUIEnabled = t5.isSpatialUIEnabled,
					onHovered = t5.onHovered,
					onUnhovered = t5.onUnhovered,
					onAbsoluteSizeChanged = t5.onAbsoluteSizeChanged,
					onAbsolutePositionChanged = t5.onAbsolutePositionChanged,
					resetTargetChannel = v68,
					activateWhisperMode = v69
				})
			})
		}),
		friendsChatInput = React.createElement(FriendsChatInputBarHost, {
			LayoutOrder = v67 + 1,
			conversationId = u47,
			conversationModerationType = if not v53 then nil else v53.moderationType,
			onFriendPlaceholderConversationCreated = t5.onFriendPlaceholderConversationCreated,
			chatWindowSettings = t5.chatWindowSettings,
			transparencyValue = t5.transparencyValue,
			isSpatialUIEnabled = t5.isSpatialUIEnabled,
			onHovered = t5.onHovered,
			onUnhovered = t5.onUnhovered
		})
	})
end

return FriendsChatConversationWindow
