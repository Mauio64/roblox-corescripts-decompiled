local AppChat = script:FindFirstAncestor("AppChat")
local AppChatParent = AppChat.Parent
local React = require(AppChatParent.React)
local jest = require(AppChatParent.Dev.JestGlobals).jest

jest.mock(AppChatParent.SocialExperiments, function() -- line: 8
	-- upvalues: jest (copy), AppChatParent (copy)
	local v16 = jest.requireActual(AppChatParent.SocialExperiments)

	v16.ScheduledPartiesExperimentation = {
		getScheduledPartiesTooltipEnabled = function() -- line: 11
			return false
		end,
		logExposure = function() -- line: 14
		end
	}

	return v16
end)

local render = require(AppChatParent.Dev.ReactTestingLibrary).render
local benchmark = require(AppChatParent.Dev.JestBenchmark).benchmark
local BenchmarkUtils = require(AppChatParent.Dev.BenchmarkUtils)
local benchFile = BenchmarkUtils.benchFile
local measureFPS = BenchmarkUtils.measureFPS
local wrapWithProviders = require(script.Parent.Utils.wrapWithProviders)
local createMockMessages = require(script.Parent.Utils.journeyUtils).createMockMessages
local ChatConversation = require(AppChat.Components.ChatConversation.ChatConversation)
local t1 = {
	ChatAppReducer = {
		Presence = {
			byUserId = {}
		}
	}
}

local function createChatConversationProps(p1) -- line: 40
	-- upvalues: createMockMessages (copy)
	return {
		conversationId = "test-conversation-123",
		conversationTitle = "Test Conversation",
		topBarHeight = 48,
		wideMode = false,
		chatInputPlaceholder = "Say something...",
		itemList = createMockMessages(p1),
		getOlderMessages = function() -- line: 47
		end,
		sendMessage = function() -- line: 48
		end,
		navigateToToast = function() -- line: 49
		end,
		markConversationAsRead = function() -- line: 50
		end,
		postTypingStatus = function() -- line: 51
		end,
		navigateBack = function() -- line: 52
		end,
		openViewProfile = function() -- line: 53
		end,
		updateConversationTitle = function() -- line: 54
		end,
		openGameDetailsPage = function() -- line: 55
		end,
		navigateToScreen = function() -- line: 56
		end,
		navigateToSquadLobby = function() -- line: 57
		end,
		usersTyping = {}
	}
end
local function createTestWrapper(p2) -- line: 63
	-- upvalues: wrapWithProviders (copy), React (copy), t1 (copy)
	return wrapWithProviders(React.createElement("Frame", {
		BackgroundTransparency = 1,
		Size = UDim2.fromOffset(400, 700)
	}, p2), {
		rodux = {
			state = t1
		}
	})
end

benchFile(script, function() -- line: 75
	-- upvalues: benchmark (copy), render (copy), createTestWrapper (copy), React (copy), ChatConversation (copy), createChatConversationProps (copy), measureFPS (copy)
	benchmark("Render ChatConversation with 10 messages", function() -- line: 76
		-- upvalues: render (copy), createTestWrapper (copy), React (copy), ChatConversation (copy), createChatConversationProps (copy)
		render(createTestWrapper({
			Conversation = React.createElement(ChatConversation, (createChatConversationProps(10)))
		})):unmount()
	end)
	benchmark("Render ChatConversation with 25 messages", function() -- line: 83
		-- upvalues: render (copy), createTestWrapper (copy), React (copy), ChatConversation (copy), createChatConversationProps (copy)
		render(createTestWrapper({
			Conversation = React.createElement(ChatConversation, (createChatConversationProps(25)))
		})):unmount()
	end)
	benchmark("Render ChatConversation with 50 messages", function() -- line: 90
		-- upvalues: render (copy), createTestWrapper (copy), React (copy), ChatConversation (copy), createChatConversationProps (copy)
		render(createTestWrapper({
			Conversation = React.createElement(ChatConversation, (createChatConversationProps(50)))
		})):unmount()
	end)
	benchmark("Render ChatConversation wideMode with 25 messages", function() -- line: 97
		-- upvalues: createChatConversationProps (copy), render (copy), createTestWrapper (copy), React (copy), ChatConversation (copy)
		local v19 = createChatConversationProps(25)

		v19.wideMode = true
		render(createTestWrapper({
			Conversation = React.createElement(ChatConversation, v19)
		})):unmount()
	end)
	benchmark("ChatConversation FPS with 25 messages", function(p3) -- line: 106
		-- upvalues: render (copy), createTestWrapper (copy), React (copy), ChatConversation (copy), createChatConversationProps (copy), measureFPS (copy)
		local v21 = render(createTestWrapper({
			Conversation = React.createElement(ChatConversation, (createChatConversationProps(25)))
		}))

		measureFPS(p3, 0.3)
		v21:unmount()
	end)
	benchmark("ChatConversation FPS with 50 messages", function(p4) -- line: 114
		-- upvalues: render (copy), createTestWrapper (copy), React (copy), ChatConversation (copy), createChatConversationProps (copy), measureFPS (copy)
		local v23 = render(createTestWrapper({
			Conversation = React.createElement(ChatConversation, (createChatConversationProps(50)))
		}))

		measureFPS(p4, 0.3)
		v23:unmount()
	end)
end)
