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
local v24 = ExpChatShared.Logger:new(script.Name)
local v25 = React.createElement("UIListLayout", {
	SortOrder = Enum.SortOrder.LayoutOrder
})

local function areArraysEqual(t1: {[any]: any}?, t2: {[any]: any}?) -- line: 92
	if t1 == t2 then
		return true
	end

	if t1 == nil or t2 == nil or #t1 ~= #t2 then
		return false
	end

	for v31, v32 in t1 do
		if v32 ~= t2[v31] then
			return false
		end
	end

	return true
end
local function areSelectedConversationHeaderFieldsEqual(t3: {[any]: any}?, t4: {[any]: any}?) -- line: 107
	if t3 == t4 then
		return true
	end

	if t3 == nil or t4 == nil then
		return false
	end

	local v35 = false

	if t3.source == t4.source then
		v35 = false

		if t3.title == t4.title then
			v35 = false

			if t3.titleForViewer == t4.titleForViewer then
				local participants = t3.participants
				local participants2 = t4.participants

				if participants == participants2 then
					return true
				end

				if participants == nil or participants2 == nil or #participants ~= #participants2 then
					return false
				end

				for v38, v39 in participants do
					if v39 ~= participants2[v38] then
						return false
					end
				end

				v35 = true
			end
		end
	end

	return v35
end
local function FriendsChatConversationWindow(t5: {[any]: any}) -- line: 123
	-- upvalues: useChatWindow (copy), FFlagDebugFriendsChat (copy), FStringDebugFriendsChatConversationId (copy), Players (copy), ExpChatConversationListAdapter (copy), React (copy), Signals (copy), areSelectedConversationHeaderFieldsEqual (copy), SignalsReact (copy), getFriendsChatHeaderProps (copy), GetConversationMessageListStore (copy), LocalizationRoactContext (copy), localizeStrings (copy), useMessageDisplayStore (copy), FriendsChatTextMessage (copy), useMessagePool (copy), v25 (copy), fetchMessagePage (copy), v24 (copy), LayoutConstants (copy), FriendsChatConversationHeaderBar (copy), FriendsChatInputBarHost (copy)
	local v41 = useChatWindow()
	local u42 = t5.conversationId or ""

	if u42 == "" and FFlagDebugFriendsChat then
		u42 = FStringDebugFriendsChatConversationId
	end

	local v43 = u42 ~= ""
	local LocalPlayer = Players.LocalPlayer
	local v45 = not LocalPlayer and 0 or LocalPlayer.UserId
	local v46 = ExpChatConversationListAdapter.getConversationStore()
	local v47 = React.useMemo(function() -- line: 138
		-- upvalues: Signals (copy), v43 (copy), v46 (copy), u42 (ref), areSelectedConversationHeaderFieldsEqual (copy)
		return Signals.createComputed(function(p1) -- line: 139
			-- upvalues: v43 (copy), v46 (copy), u42 (ref)
			if not v43 then
				return nil
			end

			local v72 = v46.getConversation(u42, p1)

			if v72 == nil then
				return nil
			end

			return {
				source = v72.source,
				title = v72.title,
				titleForViewer = v72.titleForViewer,
				participants = v72.participants
			}
		end, areSelectedConversationHeaderFieldsEqual)
	end, {
		v46,
		u42,
		v43
	})
	local v48 = SignalsReact.useSignalState(v47)
	local v49 = React.useMemo(function() -- line: 156
		-- upvalues: v48 (copy), getFriendsChatHeaderProps (copy), v45 (copy)
		if v48 == nil then
			return nil
		end

		return getFriendsChatHeaderProps(v48, v45)
	end, {
		v48,
		v45
	})
	local v50 = v48 ~= nil and v48.source == ExpChatConversationListAdapter.ConversationSource.Friends
	local v51 = v48 == nil and string.sub(u42, 1, 8) == "friends:"
	local v52 = v43 and (not v50 and not v51)
	local v53 = v43 and not v50

	React.useEffect(function() -- line: 169
		-- upvalues: v43 (copy), ExpChatConversationListAdapter (copy), u42 (ref)
		if v43 then
			ExpChatConversationListAdapter.markConversationRead(u42)
		end
	end, {
		u42,
		v43
	})

	local v54 = React.useMemo(function() -- line: 180
		-- upvalues: v53 (copy), GetConversationMessageListStore (copy), u42 (ref)
		if not v53 then
			return function() -- line: 182
				return {}
			end
		end

		return function(p2) -- line: 186
			-- upvalues: GetConversationMessageListStore (copy), u42 (ref)
			return GetConversationMessageListStore(p2).getOrderedIds(u42, p2)
		end
	end, {
		u42,
		v53
	})
	local v55 = React.useContext(LocalizationRoactContext)
	local v56 = React.useCallback(function(p3) -- line: 193
		-- upvalues: v55 (copy), localizeStrings (copy)
		if v55 == nil then
			return ""
		end

		local ok, result = pcall(function() -- line: 197
			-- upvalues: localizeStrings (copy), v55 (copy), p3 (copy)
			return localizeStrings(v55, {
				value = p3
			}).value
		end)

		if ok and typeof(result) == "string" then
			return result
		end

		return ""
	end, { v55 })
	local v57 = useMessageDisplayStore(v54, u42, v56)
	local v58 = React.useCallback(function(p4) -- line: 211
		-- upvalues: React (copy), FriendsChatTextMessage (copy), v57 (copy), t5 (copy)
		return React.createElement(FriendsChatTextMessage, {
			getDisplayId = p4.getMessageId,
			getDisplayFromId = v57.getDisplayFromId,
			getLayoutOrder = p4.getLayoutOrder,
			chatWindowSettings = t5.chatWindowSettings,
			textTransparency = t5.textTransparency,
			isSpatialUIEnabled = t5.isSpatialUIEnabled
		})
	end, {
		v57,
		t5.chatWindowSettings,
		t5.textTransparency,
		t5.isSpatialUIEnabled
	})
	local v59 = useMessagePool({
		maxSlots = 50,
		messageIdsSignal = v57.getDisplayIds,
		createSlotElement = v58
	})
	local v60 = React.useMemo(function() -- line: 231
		-- upvalues: Signals (copy), v59 (copy), v25 (copy)
		return Signals.createComputed(function(p5) -- line: 232
			-- upvalues: v59 (copy), v25 (copy)
			local v75 = table.clone(v59(p5))

			v75["$layout"] = v25

			return v75
		end)
	end, { v59 })

	React.useEffect(function() -- line: 240
		-- upvalues: v53 (copy), fetchMessagePage (copy), u42 (ref), v24 (copy)
		if not v53 then
			return
		end

		local u70 = false

		fetchMessagePage(u42, nil):catch(function(p6) -- line: 255
			-- upvalues: u70 (ref), v24 (copy), u42 (ref)
			if u70 then
				return
			end

			v24:warning(`Failed to fetch conversation messages for { u42 }: { tostring(p6) }`)
		end)

		return function() -- line: 262
			-- upvalues: u70 (ref)
			u70 = true
		end
	end, {
		u42,
		v53
	})

	local v61 = t5.parentLayoutOrder or 1
	local v62 = React.useCallback(function() -- line: 275
		-- upvalues: v24 (copy)
		v24:warning("resetTargetChannel called on FriendsChatConversationWindow; not supported")
	end, {})
	local v63 = React.useCallback(function() -- line: 278
		-- upvalues: v24 (copy)
		v24:warning("activateWhisperMode called on FriendsChatConversationWindow; not supported")
	end, {})
	local onOpenDetails = t5.onOpenDetails
	local v65 = React.useCallback(function() -- line: 282
		-- upvalues: onOpenDetails (copy), u42 (ref)
		onOpenDetails(u42)
	end, {
		onOpenDetails,
		u42
	})

	return React.createElement(React.Fragment, nil, {
		friendsChatHeaderWindow = React.createElement("Frame", {
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			LayoutOrder = v61,
			Size = UDim2.new(1, 0, 1, LayoutConstants.PanelTopSpacerHeight)
		}, {
			layout = React.createElement("UIListLayout", {
				FillDirection = Enum.FillDirection.Vertical,
				SortOrder = Enum.SortOrder.LayoutOrder
			}),
			header = React.createElement(FriendsChatConversationHeaderBar, {
				layoutOrder = 1,
				localUserId = v45,
				participantUserIds = if not v49 then nil else v49.participantUserIds,
				titleText = if not v49 then nil else v49.titleText,
				chatWindowSettings = t5.chatWindowSettings,
				transparencyValue = t5.transparencyValue,
				onHovered = t5.onHovered,
				onUnhovered = t5.onUnhovered,
				onBack = t5.onBack,
				onActivated = if not t5.onOpenDetails or not v52 then nil else v65
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
				window = React.createElement(v41, {
					disableLineReporting = true,
					size = UDim2.fromScale(1, 1),
					isChannelBarVisible = t5.isChannelBarVisible,
					scrollResetKey = "FriendsChat:" .. u42,
					messageComponentsSignal = v60,
					chatWindowSettings = t5.chatWindowSettings,
					transparencyValue = t5.transparencyValue,
					textTransparency = t5.textTransparency,
					isSpatialUIEnabled = t5.isSpatialUIEnabled,
					onHovered = t5.onHovered,
					onUnhovered = t5.onUnhovered,
					onAbsoluteSizeChanged = t5.onAbsoluteSizeChanged,
					onAbsolutePositionChanged = t5.onAbsolutePositionChanged,
					resetTargetChannel = v62,
					activateWhisperMode = v63
				})
			})
		}),
		friendsChatInput = React.createElement(FriendsChatInputBarHost, {
			LayoutOrder = v61 + 1,
			conversationId = u42,
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
