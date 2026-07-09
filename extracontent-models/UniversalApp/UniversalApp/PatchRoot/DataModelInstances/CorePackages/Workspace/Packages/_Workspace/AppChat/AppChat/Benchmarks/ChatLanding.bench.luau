local AppChat = script:FindFirstAncestor("AppChat")
local AppChatParent = AppChat.Parent
local React = require(AppChatParent.React)
local describe = require(AppChatParent.Dev.JestGlobals).describe
local render = require(AppChatParent.Dev.ReactTestingLibrary).render
local benchmark = require(AppChatParent.Dev.JestBenchmark).benchmark
local BenchmarkUtils = require(AppChatParent.Dev.BenchmarkUtils)
local benchFile = BenchmarkUtils.benchFile
local mountComponentTimes = BenchmarkUtils.mountComponentTimes
local scrollComponentTimes = BenchmarkUtils.scrollComponentTimes
local createMockConversation = require(script.Parent.Utils.journeyUtils).createMockConversation
local wrapWithProviders = require(script.Parent.Utils.wrapWithProviders)
local ConversationEntry = require(AppChat.Components.ChatLanding.ConversationEntry)

local function createMockConversationForIndex(n1: number) -- line: 26
	-- upvalues: createMockConversation (copy)
	return createMockConversation("conversation-" .. tostring(n1), {
		title = "Conversation " .. tostring(n1),
		hasUnreadMessages = n1 % 3 == 0
	})
end
local function createTestWrapper(p1) -- line: 33
	-- upvalues: wrapWithProviders (copy), React (copy)
	return wrapWithProviders(React.createElement("Frame", {
		BackgroundTransparency = 1,
		Size = UDim2.fromScale(1, 1)
	}, p1))
end
local function createConversationEntry(p2) -- line: 40
	-- upvalues: React (copy), ConversationEntry (copy)
	return React.createElement(ConversationEntry, {
		entryHeight = 64,
		boldTitle = true,
		conversation = p2,
		onActivated = function() -- line: 43
		end,
		fireImpressionEvent = function() -- line: 44
		end,
		fireClickEvent = function() -- line: 45
		end
	})
end

local v17 = createConversationEntry((createMockConversation("conversation-" .. tostring(1), {
	hasUnreadMessages = false,
	title = "Conversation " .. tostring(1)
})))
local v18 = wrapWithProviders(v17)

benchFile(script, function() -- line: 55
	-- upvalues: describe (copy), benchmark (copy), render (copy), createTestWrapper (copy), v17 (copy), createMockConversation (copy), createConversationEntry (copy), mountComponentTimes (copy), v18 (copy), scrollComponentTimes (copy), createMockConversationForIndex (copy)
	describe("ConversationEntry", function() -- line: 56
		-- upvalues: benchmark (copy), render (copy), createTestWrapper (copy), v17 (copy), createMockConversation (copy), createConversationEntry (copy), mountComponentTimes (copy), v18 (copy), scrollComponentTimes (copy)
		benchmark("Render single ConversationEntry", function() -- line: 57
			-- upvalues: render (copy), createTestWrapper (copy), v17 (copy)
			render(createTestWrapper({
				Entry = v17
			})):unmount()
		end)
		benchmark("Render ConversationEntry with unread messages", function() -- line: 64
			-- upvalues: createMockConversation (copy), render (copy), createTestWrapper (copy), createConversationEntry (copy)
			local v22 = createMockConversation("conversation-" .. tostring(3), {
				hasUnreadMessages = true,
				title = "Conversation " .. tostring(3)
			})

			render(createTestWrapper({
				Entry = createConversationEntry(v22)
			})):unmount()
		end)
		mountComponentTimes(v18, "ConversationEntry", 25)
		mountComponentTimes(v18, "ConversationEntry", 50)
		mountComponentTimes(v18, "ConversationEntry", 100)
		scrollComponentTimes(v18, "ConversationEntry", 25)
		scrollComponentTimes(v18, "ConversationEntry", 50)
	end)
	describe("ConversationList simulation", function() -- line: 80
		-- upvalues: benchmark (copy), createConversationEntry (copy), createMockConversationForIndex (copy), render (copy), createTestWrapper (copy)
		benchmark("Render list of 10 conversations", function() -- line: 81
			-- upvalues: createConversationEntry (copy), createMockConversationForIndex (copy), render (copy), createTestWrapper (copy)
			local t1 = {}

			for i = 1, 10 do
				t1["entry" .. i] = createConversationEntry(createMockConversationForIndex(i))
			end

			render(createTestWrapper(t1)):unmount()
		end)
		benchmark("Render list of 25 conversations", function() -- line: 90
			-- upvalues: createConversationEntry (copy), createMockConversationForIndex (copy), render (copy), createTestWrapper (copy)
			local t2 = {}

			for i = 1, 25 do
				t2["entry" .. i] = createConversationEntry(createMockConversationForIndex(i))
			end

			render(createTestWrapper(t2)):unmount()
		end)
		benchmark("Render list of 50 conversations", function() -- line: 99
			-- upvalues: createConversationEntry (copy), createMockConversationForIndex (copy), render (copy), createTestWrapper (copy)
			local t3 = {}

			for i = 1, 50 do
				t3["entry" .. i] = createConversationEntry(createMockConversationForIndex(i))
			end

			render(createTestWrapper(t3)):unmount()
		end)
	end)
end)
