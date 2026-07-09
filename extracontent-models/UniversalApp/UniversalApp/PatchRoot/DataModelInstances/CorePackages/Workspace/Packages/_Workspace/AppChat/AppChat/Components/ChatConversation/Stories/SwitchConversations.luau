local AppChat = script:FindFirstAncestor("AppChat")
local AppChatParent = AppChat.Parent
local Roact = require(AppChatParent.Roact)
local ChatConversation = require(AppChat.Components.ChatConversation.ChatConversation)
local v5 = Roact.PureComponent:extend("Story")
local createMockMessages = require(AppChat.Tests.Utils.createMockMessages)

function v5.init(p1) -- line: 12
	-- upvalues: createMockMessages (copy)
	p1.conversation1 = {
		id = "CONVERSATION_ONE",
		itemList = createMockMessages({
			messageIdPrefix = "CONVERSATION_ONE",
			read = true
		}, 50)
	}
	p1.conversation2 = {
		id = "CONVERSATION_TWO",
		itemList = createMockMessages({
			messageIdPrefix = "CONVERSATION_TWO",
			read = true
		}, 40)
	}

	function p1.makeChatNotVisible() -- line: 22
		-- upvalues: p1 (copy)
		p1:setState({
			chatIsVisible = false
		})
	end
	function p1.switchConversations() -- line: 28
		-- upvalues: p1 (copy)
		p1:setState({
			conversation = p1.state.conversation.id == "CONVERSATION_ONE" and p1.conversation2 or p1.conversation1
		})
	end
	function p1.switchUnreadStatus() -- line: 35
		-- upvalues: p1 (copy)
		p1:setState({
			readingMessagesIsEnabled = not p1.state.readingMessagesIsEnabled
		})
	end

	p1.state = {
		conversation = p1.conversation1,
		readingMessagesIsEnabled = p1.props.initialReadingMessagesIsEnabled,
		chatIsVisible = p1.props.initialChatIsVisible or true
	}
end
function v5.render(p2) -- line: 48
	-- upvalues: Roact (copy), ChatConversation (copy)
	return Roact.createFragment({
		layout = Roact.createElement("UIListLayout", {
			FillDirection = Enum.FillDirection.Vertical,
			HorizontalAlignment = Enum.HorizontalAlignment.Center,
			VerticalAlignment = Enum.VerticalAlignment.Top
		}),
		chatConversation = Roact.createElement(ChatConversation, {
			itemList = p2.state.conversation.itemList,
			conversationId = p2.state.conversation.id,
			markConversationAsRead = p2.props.markConversationAsRead or function() -- line: 58
			end,
			readingMessagesIsEnabled = p2.state.readingMessagesIsEnabled,
			chatIsVisible = p2.state.chatIsVisible,
			replyingToMessageDispatch = p2.props.replyingToMessageDispatch or function() -- line: 61
			end
		}),
		makeChatNotVisibleButton = Roact.createElement("TextButton", {
			Size = UDim2.new(0, 120, 0, 50),
			Text = "Make Chat Not Visible",
			[Roact.Event.Activated] = p2.makeChatNotVisible
		}),
		switchConversationButton = Roact.createElement("TextButton", {
			Size = UDim2.new(0, 120, 0, 50),
			Text = "Switch Conversations",
			[Roact.Event.Activated] = p2.switchConversations
		}),
		toggleReadState = Roact.createElement("TextButton", {
			Size = UDim2.new(0, 120, 0, 50),
			Text = "Toggle UnreadStatus",
			[Roact.Event.Activated] = p2.switchUnreadStatus
		})
	})
end

return function(p3) -- line: 84
	-- upvalues: Roact (copy), v5 (copy)
	return Roact.createElement("Frame", {
		BackgroundTransparency = 0,
		BackgroundColor3 = Color3.fromRGB(244, 244, 244),
		Size = UDim2.new(0, 512, 0, 300)
	}, {
		ChatConversation = Roact.createElement(v5, p3)
	})
end
