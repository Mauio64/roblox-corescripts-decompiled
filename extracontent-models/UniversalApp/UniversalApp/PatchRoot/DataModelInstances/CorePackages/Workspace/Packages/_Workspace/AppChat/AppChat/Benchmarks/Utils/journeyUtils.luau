local AppChat = script:FindFirstAncestor("AppChat")
local AppChatParent = AppChat.Parent
local React = require(AppChatParent.React)
local Rodux = require(AppChatParent.Rodux)
local EnumMessageTypes = require(AppChat.Components.ChatConversation.EnumMessageTypes)
local MessageModel = require(AppChat.Models.MessageModel)
local MockProviders = require(AppChat.Components.MockProviders)

local function secondsToMinutes(n1: number) -- line: 17
	return (math.floor(n1 / 60))
end
local function secondsToHours(n2: number) -- line: 21
	return (math.floor(n2 / 3600))
end
local function secondsToDays(n3: number) -- line: 25
	return (math.floor(n3 / 86400))
end
local function createMockSentDate(p1) -- line: 69
	local u20 = p1 or 0
	local v21 = os.time() - u20

	return {
		GetLongRelativeTime = function() -- line: 73
			-- upvalues: u20 (ref)
			if u20 < 60 then
				return "Just now"
			end

			if u20 < 3600 then
				return tostring((math.floor(u20 / 60))) .. " minutes ago"
			end

			if u20 < 86400 then
				return tostring((math.floor(u20 / 3600))) .. " hours ago"
			end

			return tostring((math.floor(u20 / 86400))) .. " days ago"
		end,
		GetShortRelativeTime = function() -- line: 84
			-- upvalues: u20 (ref)
			if u20 < 60 then
				return "now"
			end

			if u20 < 3600 then
				return tostring((math.floor(u20 / 60))) .. "m"
			end

			if u20 < 86400 then
				return tostring((math.floor(u20 / 3600))) .. "h"
			end

			return tostring((math.floor(u20 / 86400))) .. "d"
		end,
		GetUnixTimestamp = function() -- line: 95
			-- upvalues: v21 (copy)
			return v21
		end
	}
end
local function createMockMessage(n4: number, t1: {[any]: any}?) -- line: 101
	-- upvalues: EnumMessageTypes (copy), MessageModel (copy), createMockSentDate (copy)
	local v24 = t1 or {}
	local isIncoming = v24.isIncoming

	if isIncoming == nil then
		isIncoming = n4 % 2 == 0
	end

	local v26 = math.max(0, (100 - n4) * 60)

	return {
		failed = false,
		moderated = false,
		filteredForReceivers = false,
		messageId = "journey-msg-" .. tostring(n4),
		stable_key = "journey-msg-" .. tostring(n4),
		content = v24.content or "This is test message number " .. tostring(n4),
		messageType = v24.messageType or EnumMessageTypes.PlainText,
		senderType = v24.senderType or MessageModel.SenderTypes.User,
		isIncoming = isIncoming,
		isNewSender = n4 % 3 == 0,
		isLastMessageInMessageGroup = n4 % 3 == 2,
		showDateTime = n4 % 5 == 0,
		showDisplayName = n4 % 3 == 0,
		sent = v24.sent or createMockSentDate(v26),
		isSending = v24.isSending or false,
		read = v24.read ~= false,
		sender = v24.sender or {
			thumbnail = "",
			id = tostring(n4 % 5 + 1),
			displayName = "User " .. tostring(n4 % 5 + 1),
			shouldShowName = n4 % 3 == 0
		}
	}
end
local function createMockConversation(s1: string?, t2: {[any]: any}?) -- line: 145
	local v33 = t2 or {}

	return {
		id = s1 or "journey-conversation-1",
		title = v33.title or "Test Conversation",
		hasUnreadMessages = v33.hasUnreadMessages or false,
		hasGroupUp = v33.hasGroupUp or false,
		conversationType = v33.conversationType or "OneToOneConversation",
		lastMessage = v33.lastMessage or {
			content = "Last message content",
			sent = DateTime.now():ToIsoDate()
		},
		participants = v33.participants or {
			{
				id = "1",
				displayName = "Test User 1",
				thumbnail = ""
			},
			{
				id = "2",
				displayName = "Test User 2",
				thumbnail = ""
			}
		}
	}
end
local function createMockRoduxState(t3: {[any]: any}?) -- line: 191
	local v40 = t3 or {}

	return {
		AppChat = {
			conversations = v40.conversations or {},
			messages = v40.messages or {},
			users = v40.users or {},
			currentConversationId = v40.currentConversationId
		},
		LocalUserId = v40.localUserId or "123456"
	}
end
local function createMockStore(t4: {[any]: any}?) -- line: 204
	-- upvalues: createMockRoduxState (copy), Rodux (copy)
	local v42 = createMockRoduxState(t4)

	return Rodux.Store.new(function(p2, p3) -- line: 206
		-- upvalues: v42 (copy)
		if p3.type == "@@INIT" then
			return v42
		end

		return p2 or v42
	end, v42, { Rodux.thunkMiddleware })
end

return {
	createMockSentDate = createMockSentDate,
	createMockMessage = createMockMessage,
	createMockMessages = function(n5: number, t5: {[any]: any}?) -- line: 137
		-- upvalues: createMockMessage (copy)
		local t6 = {}

		for i = 1, n5 do
			table.insert(t6, (createMockMessage(i, t5)))
		end

		return t6
	end,
	createMockConversation = createMockConversation,
	createMockConversations = function(n6: number, t7: {[any]: any}?) -- line: 172
		-- upvalues: createMockConversation (copy)
		local v36 = t7 or {}
		local t8 = {}

		for i = 1, n6 do
			table.insert(t8, (createMockConversation("conversation-" .. tostring(i), {
				title = v36.title or "Conversation " .. tostring(i),
				hasUnreadMessages = if v36.hasUnreadMessages == nil then i % 3 == 0 else v36.hasUnreadMessages,
				hasGroupUp = v36.hasGroupUp,
				conversationType = v36.conversationType,
				lastMessage = v36.lastMessage,
				participants = v36.participants
			})))
		end

		return t8
	end,
	createMockRoduxState = createMockRoduxState,
	createMockStore = createMockStore,
	wrapWithJourneyProviders = function(p4, t9: {[any]: any}?) -- line: 214
		-- upvalues: React (copy), MockProviders (copy), createMockStore (copy)
		local v45 = t9 or {}

		return React.createElement(MockProviders, {
			withLayerCollector = true,
			rodux = {
				store = v45.store or createMockStore(v45.state)
			},
			themeName = v45.themeName or "Dark"
		}, {
			ScreenGui = React.createElement("ScreenGui", {}, {
				Frame = React.createElement("Frame", {
					BackgroundTransparency = 1,
					Size = v45.size or UDim2.fromOffset(400, 700)
				}, {
					Content = p4
				})
			})
		})
	end,
	simulateTyping = function(p5, s2: string, t10: {[any]: any}?) -- line: 234
		local v49 = (t10 or {}).delay or 0.01

		for i = 1, #s2 do
			local v51 = string.sub(s2, i, i)

			p5.Text = p5.Text .. v51

			if v49 > 0 then
				task.wait(v49)
			end
		end
	end,
	simulateScroll = function(p6, t11: {[any]: any}?) -- line: 247
		local v54 = t11 or {}
		local v55 = v54.duration or 0.5
		local v56 = v54.distance or 1000
		local CanvasPositionY = p6.CanvasPosition.Y
		local v58 = CanvasPositionY + v56
		local elapsed = os.clock()

		while v55 > os.clock() - elapsed do
			local v60 = (os.clock() - elapsed) / v55
			local v61 = CanvasPositionY + (v58 - CanvasPositionY) * v60

			p6.CanvasPosition = Vector2.new(0, v61)
			task.wait()
		end

		p6.CanvasPosition = Vector2.new(0, v58)
	end,
	waitForCondition = function(p7: ((...any) -> ...any), t12: {[any]: any}?) -- line: 267
		local v64 = t12 or {}
		local v65 = v64.timeout or 5
		local v66 = v64.interval or 0.1
		local elapsed = os.clock()

		while v65 > os.clock() - elapsed do
			if p7() then
				return true
			end

			task.wait(v66)
		end

		return false
	end
}
