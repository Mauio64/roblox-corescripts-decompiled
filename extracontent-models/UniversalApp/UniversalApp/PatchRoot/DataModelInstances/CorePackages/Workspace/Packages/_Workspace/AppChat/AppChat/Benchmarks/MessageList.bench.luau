local AppChat = script:FindFirstAncestor("AppChat")
local AppChatParent = AppChat.Parent
local React = require(AppChatParent.React)
local render = require(AppChatParent.Dev.ReactTestingLibrary).render
local benchmark = require(AppChatParent.Dev.JestBenchmark).benchmark
local BenchmarkUtils = require(AppChatParent.Dev.BenchmarkUtils)
local benchFile = BenchmarkUtils.benchFile
local measureFPS = BenchmarkUtils.measureFPS
local wrapWithProviders = require(script.Parent.Utils.wrapWithProviders)
local createMockMessages = require(script.Parent.Utils.journeyUtils).createMockMessages
local MessageList = require(AppChat.Components.ChatConversation.MessageList)
local t1 = {
	ChatAppReducer = {
		Presence = {
			byUserId = {}
		}
	}
}

local function createMessageListProps(p1) -- line: 26
	-- upvalues: createMockMessages (copy)
	return {
		conversationId = "test-conversation",
		itemList = createMockMessages(p1),
		loadNext = function() -- line: 30
		end,
		markAsRead = function() -- line: 31
		end,
		onDetailsOpened = function() -- line: 32
		end,
		openGameDetailsPage = function() -- line: 33
		end,
		openViewProfile = function() -- line: 34
		end,
		closeKeyboard = function() -- line: 35
		end
	}
end
local function createTestWrapper(p2) -- line: 39
	-- upvalues: wrapWithProviders (copy), React (copy), t1 (copy)
	return wrapWithProviders(React.createElement("Frame", {
		BackgroundTransparency = 1,
		Size = UDim2.fromOffset(400, 600)
	}, p2), {
		rodux = {
			state = t1
		}
	})
end

benchFile(script, function() -- line: 51
	-- upvalues: benchmark (copy), render (copy), createTestWrapper (copy), React (copy), MessageList (copy), createMessageListProps (copy), measureFPS (copy)
	benchmark("Render MessageList with 10 messages", function() -- line: 52
		-- upvalues: render (copy), createTestWrapper (copy), React (copy), MessageList (copy), createMessageListProps (copy)
		render(createTestWrapper({
			List = React.createElement(MessageList, (createMessageListProps(10)))
		})):unmount()
	end)
	benchmark("Render MessageList with 25 messages", function() -- line: 59
		-- upvalues: render (copy), createTestWrapper (copy), React (copy), MessageList (copy), createMessageListProps (copy)
		render(createTestWrapper({
			List = React.createElement(MessageList, (createMessageListProps(25)))
		})):unmount()
	end)
	benchmark("Render MessageList with 50 messages", function() -- line: 66
		-- upvalues: render (copy), createTestWrapper (copy), React (copy), MessageList (copy), createMessageListProps (copy)
		render(createTestWrapper({
			List = React.createElement(MessageList, (createMessageListProps(50)))
		})):unmount()
	end)
	benchmark("Render MessageList with 100 messages", function() -- line: 73
		-- upvalues: render (copy), createTestWrapper (copy), React (copy), MessageList (copy), createMessageListProps (copy)
		render(createTestWrapper({
			List = React.createElement(MessageList, (createMessageListProps(100)))
		})):unmount()
	end)
	benchmark("MessageList FPS with 50 messages", function(p3) -- line: 80
		-- upvalues: render (copy), createTestWrapper (copy), React (copy), MessageList (copy), createMessageListProps (copy), measureFPS (copy)
		local v18 = render(createTestWrapper({
			List = React.createElement(MessageList, (createMessageListProps(50)))
		}))

		measureFPS(p3, 0.3)
		v18:unmount()
	end)
	benchmark("MessageList FPS with 100 messages", function(p4) -- line: 88
		-- upvalues: render (copy), createTestWrapper (copy), React (copy), MessageList (copy), createMessageListProps (copy), measureFPS (copy)
		local v20 = render(createTestWrapper({
			List = React.createElement(MessageList, (createMessageListProps(100)))
		}))

		measureFPS(p4, 0.3)
		v20:unmount()
	end)
end)
