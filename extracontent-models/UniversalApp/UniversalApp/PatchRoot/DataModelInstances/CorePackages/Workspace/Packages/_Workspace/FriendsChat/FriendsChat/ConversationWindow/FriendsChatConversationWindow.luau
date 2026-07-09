local Players = game:GetService("Players")
local Parent = script:FindFirstAncestor("FriendsChat").Parent
local React = require(Parent.React)
local Signals = require(Parent.Signals)
local SignalsReact = require(Parent.SignalsReact)
local ExpChatShared = require(Parent.ExpChatShared)
local GetConversationMessageListStore = require(Parent.AppChat.GetConversationMessageListStore)
local fetchMessagePage = require(Parent.AppChat.fetchMessagePage)
local useChatWindow = require(script.Parent.Parent.Bridge.useChatWindow)
local FFlagDebugFriendsChat = require(script.Parent.Parent.Flags.FFlagDebugFriendsChat)
local FStringDebugFriendsChatConversationId = require(script.Parent.Parent.Flags.FStringDebugFriendsChatConversationId)
local useMessagePool = require(Parent.ChatUIPrimitives).useMessagePool
local ExpChatConversationListAdapter = require(script.Parent.Parent.ConversationList.ExpChatConversationListAdapter)
local FriendsChatTextMessage = require(script.Parent.Parent.Message.FriendsChatTextMessage)
local FriendsChatConversationHeaderBar = require(script.Parent.Parent.HeaderBar.FriendsChatConversationHeaderBar)
local getFriendsChatHeaderProps = require(script.Parent.Parent.HeaderBar.getFriendsChatHeaderProps)
local FriendsChatInputBarHost = require(script.Parent.FriendsChatInputBarHost)
local v18 = ExpChatShared.Logger:new(script.Name)
local v19 = React.createElement("UIListLayout", {
	SortOrder = Enum.SortOrder.LayoutOrder
})

local function areArraysEqual(t1: {[any]: any}?, t2: {[any]: any}?) -- line: 91
	if t1 == t2 then
		return true
	end

	if t1 == nil or t2 == nil or #t1 ~= #t2 then
		return false
	end

	for v25, v26 in t1 do
		if v26 ~= t2[v25] then
			return false
		end
	end

	return true
end
local function areSelectedConversationHeaderFieldsEqual(t3: {[any]: any}?, t4: {[any]: any}?) -- line: 106
	if t3 == t4 then
		return true
	end

	if t3 == nil or t4 == nil then
		return false
	end

	local v29 = false

	if t3.source == t4.source then
		v29 = false

		if t3.title == t4.title then
			v29 = false

			if t3.titleForViewer == t4.titleForViewer then
				local participants = t3.participants
				local participants2 = t4.participants

				if participants == participants2 then
					return true
				end

				if participants == nil or participants2 == nil or #participants ~= #participants2 then
					return false
				end

				for v32, v33 in participants do
					if v33 ~= participants2[v32] then
						return false
					end
				end

				v29 = true
			end
		end
	end

	return v29
end
local function FriendsChatConversationWindow(t5: {[any]: any}) -- line: 122
	-- upvalues: useChatWindow (copy), FFlagDebugFriendsChat (copy), FStringDebugFriendsChatConversationId (copy), Players (copy), ExpChatConversationListAdapter (copy), React (copy), Signals (copy), areSelectedConversationHeaderFieldsEqual (copy), SignalsReact (copy), getFriendsChatHeaderProps (copy), GetConversationMessageListStore (copy), FriendsChatTextMessage (copy), useMessagePool (copy), v19 (copy), fetchMessagePage (copy), v18 (copy), FriendsChatConversationHeaderBar (copy), FriendsChatInputBarHost (copy)
	local v35 = useChatWindow()
	local u36 = t5.conversationId or ""

	if u36 == "" and FFlagDebugFriendsChat then
		u36 = FStringDebugFriendsChatConversationId
	end

	local v37 = u36 ~= ""
	local LocalPlayer = Players.LocalPlayer
	local v39 = not LocalPlayer and 0 or LocalPlayer.UserId
	local v40 = ExpChatConversationListAdapter.getConversationStore()
	local v41 = React.useMemo(function() -- line: 137
		-- upvalues: Signals (copy), v37 (copy), v40 (copy), u36 (ref), areSelectedConversationHeaderFieldsEqual (copy)
		return Signals.createComputed(function(p1) -- line: 138
			-- upvalues: v37 (copy), v40 (copy), u36 (ref)
			if not v37 then
				return nil
			end

			local v56 = v40.getConversation(u36, p1)

			if v56 == nil then
				return nil
			end

			return {
				source = v56.source,
				title = v56.title,
				titleForViewer = v56.titleForViewer,
				participants = v56.participants
			}
		end, areSelectedConversationHeaderFieldsEqual)
	end, {
		v40,
		u36,
		v37
	})
	local v42 = SignalsReact.useSignalState(v41)
	local v43 = React.useMemo(function() -- line: 155
		-- upvalues: v42 (copy), getFriendsChatHeaderProps (copy), v39 (copy)
		if v42 == nil then
			return nil
		end

		return getFriendsChatHeaderProps(v42, v39)
	end, {
		v42,
		v39
	})
	local v44 = v42 ~= nil and v42.source == ExpChatConversationListAdapter.ConversationSource.Friends
	local v45 = v37 and not v44

	React.useEffect(function() -- line: 165
		-- upvalues: v37 (copy), ExpChatConversationListAdapter (copy), u36 (ref)
		if v37 then
			ExpChatConversationListAdapter.markConversationRead(u36)
		end
	end, {
		u36,
		v37
	})

	local v46 = React.useMemo(function() -- line: 176
		-- upvalues: v45 (copy), GetConversationMessageListStore (copy), u36 (ref)
		if not v45 then
			return function() -- line: 178
				return {}
			end
		end

		return function(p2) -- line: 182
			-- upvalues: GetConversationMessageListStore (copy), u36 (ref)
			local v58 = GetConversationMessageListStore(p2).getOrderedIds(u36, p2)
			local v59 = math.min(#v58, 50)
			local t6 = table.create(v59)

			for i = 1, v59 do
				t6[v59 - i + 1] = v58[i]
			end

			return t6
		end
	end, {
		u36,
		v45
	})
	local v47 = React.useCallback(function(p3) -- line: 199
		-- upvalues: React (copy), FriendsChatTextMessage (copy), t5 (copy)
		return React.createElement(FriendsChatTextMessage, {
			getMessageId = p3.getMessageId,
			getLayoutOrder = p3.getLayoutOrder,
			chatWindowSettings = t5.chatWindowSettings,
			textTransparency = t5.textTransparency,
			isSpatialUIEnabled = t5.isSpatialUIEnabled
		})
	end, {
		t5.chatWindowSettings,
		t5.textTransparency,
		t5.isSpatialUIEnabled
	})
	local v48 = useMessagePool({
		maxSlots = 50,
		messageIdsSignal = v46,
		createSlotElement = v47
	})
	local v49 = React.useMemo(function() -- line: 218
		-- upvalues: Signals (copy), v48 (copy), v19 (copy)
		return Signals.createComputed(function(p4) -- line: 219
			-- upvalues: v48 (copy), v19 (copy)
			local v63 = table.clone(v48(p4))

			v63["$layout"] = v19

			return v63
		end)
	end, { v48 })

	React.useEffect(function() -- line: 227
		-- upvalues: v45 (copy), fetchMessagePage (copy), u36 (ref), v18 (copy)
		if not v45 then
			return
		end

		local u54 = false

		fetchMessagePage(u36, nil):catch(function(p5) -- line: 242
			-- upvalues: u54 (ref), v18 (copy), u36 (ref)
			if u54 then
				return
			end

			v18:warning(`Failed to fetch conversation messages for { u36 }: { tostring(p5) }`)
		end)

		return function() -- line: 249
			-- upvalues: u54 (ref)
			u54 = true
		end
	end, {
		u36,
		v45
	})

	local v50 = t5.parentLayoutOrder or 1
	local v51 = React.useCallback(function() -- line: 262
		-- upvalues: v18 (copy)
		v18:warning("resetTargetChannel called on FriendsChatConversationWindow; not supported")
	end, {})
	local v52 = React.useCallback(function() -- line: 265
		-- upvalues: v18 (copy)
		v18:warning("activateWhisperMode called on FriendsChatConversationWindow; not supported")
	end, {})

	return React.createElement(React.Fragment, nil, {
		friendsChatHeaderWindow = React.createElement("Frame", {
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			LayoutOrder = v50,
			Size = UDim2.new(1, 0, 1, 8)
		}, {
			layout = React.createElement("UIListLayout", {
				FillDirection = Enum.FillDirection.Vertical,
				SortOrder = Enum.SortOrder.LayoutOrder
			}),
			header = React.createElement(FriendsChatConversationHeaderBar, {
				layoutOrder = 1,
				localUserId = v39,
				participantUserIds = if not v43 then nil else v43.participantUserIds,
				titleText = if not v43 then nil else v43.titleText,
				chatWindowSettings = t5.chatWindowSettings,
				transparencyValue = t5.transparencyValue,
				onHovered = t5.onHovered,
				onUnhovered = t5.onUnhovered,
				onBack = t5.onBack
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
				window = React.createElement(v35, {
					disableLineReporting = true,
					size = UDim2.fromScale(1, 1),
					isChannelBarVisible = t5.isChannelBarVisible,
					scrollResetKey = "FriendsChat:" .. u36,
					messageComponentsSignal = v49,
					chatWindowSettings = t5.chatWindowSettings,
					transparencyValue = t5.transparencyValue,
					textTransparency = t5.textTransparency,
					isSpatialUIEnabled = t5.isSpatialUIEnabled,
					onHovered = t5.onHovered,
					onUnhovered = t5.onUnhovered,
					onAbsoluteSizeChanged = t5.onAbsoluteSizeChanged,
					onAbsolutePositionChanged = t5.onAbsolutePositionChanged,
					resetTargetChannel = v51,
					activateWhisperMode = v52
				})
			})
		}),
		friendsChatInput = React.createElement(FriendsChatInputBarHost, {
			LayoutOrder = v50 + 1,
			conversationId = u36,
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
