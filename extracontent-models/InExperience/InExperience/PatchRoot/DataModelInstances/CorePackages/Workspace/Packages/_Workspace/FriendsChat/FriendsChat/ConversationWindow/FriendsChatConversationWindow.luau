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
local v25 = ExpChatShared.Logger:new(script.Name)
local v26 = React.createElement("UIListLayout", {
	SortOrder = Enum.SortOrder.LayoutOrder
})

local function areArraysEqual(t1: {[any]: any}?, t2: {[any]: any}?) -- line: 94
	if t1 == t2 then
		return true
	end

	if t1 == nil or t2 == nil or #t1 ~= #t2 then
		return false
	end

	for v32, v33 in t1 do
		if v33 ~= t2[v32] then
			return false
		end
	end

	return true
end
local function areSelectedConversationHeaderFieldsEqual(t3: {[any]: any}?, t4: {[any]: any}?) -- line: 109
	if t3 == t4 then
		return true
	end

	if t3 == nil or t4 == nil then
		return false
	end

	local v36 = false

	if t3.source == t4.source then
		v36 = false

		if t3.title == t4.title then
			v36 = false

			if t3.titleForViewer == t4.titleForViewer then
				local participants = t3.participants
				local participants2 = t4.participants

				if participants == participants2 then
					return true
				end

				if participants == nil or participants2 == nil or #participants ~= #participants2 then
					return false
				end

				for v39, v40 in participants do
					if v40 ~= participants2[v39] then
						return false
					end
				end

				v36 = true
			end
		end
	end

	return v36
end
local function FriendsChatConversationWindow(t5: {[any]: any}) -- line: 125
	-- upvalues: useChatWindow (copy), FFlagDebugFriendsChat (copy), FStringDebugFriendsChatConversationId (copy), Players (copy), ExpChatConversationListAdapter (copy), React (copy), Signals (copy), areSelectedConversationHeaderFieldsEqual (copy), SignalsReact (copy), getFriendsChatHeaderProps (copy), GetConversationMessageListStore (copy), LocalizationRoactContext (copy), localizeStrings (copy), useMessageDisplayStore (copy), FriendsChatTextMessage (copy), useMessagePool (copy), v26 (copy), fetchMessagePage (copy), v25 (copy), useFriendsChatConversationTelemetry (copy), LayoutConstants (copy), FriendsChatConversationHeaderBar (copy), FriendsChatInputBarHost (copy)
	local v42 = useChatWindow()
	local u43 = t5.conversationId or ""

	if u43 == "" and FFlagDebugFriendsChat then
		u43 = FStringDebugFriendsChatConversationId
	end

	local v44 = u43 ~= ""
	local LocalPlayer = Players.LocalPlayer
	local v46 = not LocalPlayer and 0 or LocalPlayer.UserId
	local v47 = ExpChatConversationListAdapter.getConversationStore()
	local v48 = React.useMemo(function() -- line: 140
		-- upvalues: Signals (copy), v44 (copy), v47 (copy), u43 (ref), areSelectedConversationHeaderFieldsEqual (copy)
		return Signals.createComputed(function(p1) -- line: 141
			-- upvalues: v44 (copy), v47 (copy), u43 (ref)
			if not v44 then
				return nil
			end

			local v76 = v47.getConversation(u43, p1)

			if v76 == nil then
				return nil
			end

			return {
				source = v76.source,
				title = v76.title,
				titleForViewer = v76.titleForViewer,
				participants = v76.participants
			}
		end, areSelectedConversationHeaderFieldsEqual)
	end, {
		v47,
		u43,
		v44
	})
	local v49 = SignalsReact.useSignalState(v48)
	local v50 = React.useMemo(function() -- line: 158
		-- upvalues: v49 (copy), getFriendsChatHeaderProps (copy), v46 (copy)
		if v49 == nil then
			return nil
		end

		return getFriendsChatHeaderProps(v49, v46)
	end, {
		v49,
		v46
	})
	local v51 = v49 ~= nil and v49.source == ExpChatConversationListAdapter.ConversationSource.Friends
	local v52 = v49 == nil and string.sub(u43, 1, 8) == "friends:"
	local v53 = v44 and (not v51 and not v52)
	local v54 = v44 and not v51

	React.useEffect(function() -- line: 171
		-- upvalues: v44 (copy), ExpChatConversationListAdapter (copy), u43 (ref)
		if v44 then
			ExpChatConversationListAdapter.markConversationRead(u43)
		end
	end, {
		u43,
		v44
	})

	local v55 = React.useMemo(function() -- line: 182
		-- upvalues: v54 (copy), GetConversationMessageListStore (copy), u43 (ref)
		if not v54 then
			return function() -- line: 184
				return {}
			end
		end

		return function(p2) -- line: 188
			-- upvalues: GetConversationMessageListStore (copy), u43 (ref)
			return GetConversationMessageListStore(p2).getOrderedIds(u43, p2)
		end
	end, {
		u43,
		v54
	})
	local v56 = React.useContext(LocalizationRoactContext)
	local v57 = React.useCallback(function(p3) -- line: 195
		-- upvalues: v56 (copy), localizeStrings (copy)
		if v56 == nil then
			return ""
		end

		local ok, result = pcall(function() -- line: 199
			-- upvalues: localizeStrings (copy), v56 (copy), p3 (copy)
			return localizeStrings(v56, {
				value = p3
			}).value
		end)

		if ok and typeof(result) == "string" then
			return result
		end

		return ""
	end, { v56 })
	local v58 = useMessageDisplayStore(v55, u43, v57)
	local v59 = React.useCallback(function(p4) -- line: 213
		-- upvalues: React (copy), FriendsChatTextMessage (copy), v58 (copy), t5 (copy)
		return React.createElement(FriendsChatTextMessage, {
			getDisplayId = p4.getMessageId,
			getDisplayFromId = v58.getDisplayFromId,
			getLayoutOrder = p4.getLayoutOrder,
			chatWindowSettings = t5.chatWindowSettings,
			textTransparency = t5.textTransparency,
			isSpatialUIEnabled = t5.isSpatialUIEnabled
		})
	end, {
		v58,
		t5.chatWindowSettings,
		t5.textTransparency,
		t5.isSpatialUIEnabled
	})
	local v60 = useMessagePool({
		maxSlots = 50,
		messageIdsSignal = v58.getDisplayIds,
		createSlotElement = v59
	})
	local v61 = React.useMemo(function() -- line: 233
		-- upvalues: Signals (copy), v60 (copy), v26 (copy)
		return Signals.createComputed(function(p5) -- line: 234
			-- upvalues: v60 (copy), v26 (copy)
			local v79 = table.clone(v60(p5))

			v79["$layout"] = v26

			return v79
		end)
	end, { v60 })

	React.useEffect(function() -- line: 242
		-- upvalues: v54 (copy), fetchMessagePage (copy), u43 (ref), v25 (copy)
		if not v54 then
			return
		end

		local u74 = false

		fetchMessagePage(u43, nil):catch(function(p6) -- line: 257
			-- upvalues: u74 (ref), v25 (copy), u43 (ref)
			if u74 then
				return
			end

			v25:warning(`Failed to fetch conversation messages for { u43 }: { tostring(p6) }`)
		end)

		return function() -- line: 264
			-- upvalues: u74 (ref)
			u74 = true
		end
	end, {
		u43,
		v54
	})

	local v62 = React.useCallback(function() -- line: 273
		-- upvalues: v44 (copy), GetConversationMessageListStore (copy), u43 (ref)
		if not v44 then
			return 0
		end

		return #GetConversationMessageListStore(false).getOrderedIds(u43, false)
	end, {
		u43,
		v44
	})
	local v63 = useFriendsChatConversationTelemetry({
		conversationId = u43,
		getLoadedMessageCount = v62
	})
	local v64 = t5.parentLayoutOrder or 1
	local v65 = React.useCallback(function() -- line: 293
		-- upvalues: v25 (copy)
		v25:warning("resetTargetChannel called on FriendsChatConversationWindow; not supported")
	end, {})
	local v66 = React.useCallback(function() -- line: 296
		-- upvalues: v25 (copy)
		v25:warning("activateWhisperMode called on FriendsChatConversationWindow; not supported")
	end, {})
	local onOpenDetails = t5.onOpenDetails
	local fireInfoButtonClicked = v63.fireInfoButtonClicked
	local v69 = React.useCallback(function() -- line: 301
		-- upvalues: fireInfoButtonClicked (copy), onOpenDetails (copy), u43 (ref)
		fireInfoButtonClicked()
		onOpenDetails(u43)
	end, {
		fireInfoButtonClicked,
		onOpenDetails,
		u43
	})

	return React.createElement(React.Fragment, nil, {
		friendsChatHeaderWindow = React.createElement("Frame", {
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			LayoutOrder = v64,
			Size = UDim2.new(1, 0, 1, LayoutConstants.PanelTopSpacerHeight)
		}, {
			layout = React.createElement("UIListLayout", {
				FillDirection = Enum.FillDirection.Vertical,
				SortOrder = Enum.SortOrder.LayoutOrder
			}),
			header = React.createElement(FriendsChatConversationHeaderBar, {
				layoutOrder = 1,
				localUserId = v46,
				participantUserIds = if not v50 then nil else v50.participantUserIds,
				titleText = if not v50 then nil else v50.titleText,
				chatWindowSettings = t5.chatWindowSettings,
				transparencyValue = t5.transparencyValue,
				onHovered = t5.onHovered,
				onUnhovered = t5.onUnhovered,
				onBack = t5.onBack,
				onActivated = if not t5.onOpenDetails or not v53 then nil else v69
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
				window = React.createElement(v42, {
					disableLineReporting = true,
					size = UDim2.fromScale(1, 1),
					isChannelBarVisible = t5.isChannelBarVisible,
					scrollResetKey = "FriendsChat:" .. u43,
					messageComponentsSignal = v61,
					chatWindowSettings = t5.chatWindowSettings,
					transparencyValue = t5.transparencyValue,
					textTransparency = t5.textTransparency,
					isSpatialUIEnabled = t5.isSpatialUIEnabled,
					onHovered = t5.onHovered,
					onUnhovered = t5.onUnhovered,
					onAbsoluteSizeChanged = t5.onAbsoluteSizeChanged,
					onAbsolutePositionChanged = t5.onAbsolutePositionChanged,
					resetTargetChannel = v65,
					activateWhisperMode = v66
				})
			})
		}),
		friendsChatInput = React.createElement(FriendsChatInputBarHost, {
			LayoutOrder = v64 + 1,
			conversationId = u43,
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
