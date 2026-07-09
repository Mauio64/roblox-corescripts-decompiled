local AppChat = script:FindFirstAncestor("AppChat")
local AppChatParent = AppChat.Parent
local Cryo = require(AppChatParent.Cryo)
local React = require(AppChatParent.React)
local render = require(AppChatParent.Dev.ReactTestingLibrary).render
local benchmark = require(AppChatParent.Dev.JestBenchmark).benchmark
local BenchmarkUtils = require(AppChatParent.Dev.BenchmarkUtils)
local benchFile = BenchmarkUtils.benchFile
local mountComponentTimes = BenchmarkUtils.mountComponentTimes
local scrollComponentTimes = BenchmarkUtils.scrollComponentTimes
local ChatBubble = require(AppChat.Components.ChatConversation.Bubble.ChatBubble)
local wrapWithProviders = require(script.Parent.Utils.wrapWithProviders)

local function createBubbleProps(p1) -- line: 19
	-- upvalues: React (copy), Cryo (copy)
	local t1 = {
		contentWidth = 200,
		isIncoming = false,
		isRepliedTo = false,
		imageTransparency = 0,
		padding = 12,
		hasTail = true,
		imageColor = Color3.new(0.2, 0.4, 0.8),
		onAbsoluteSizeChanged = function() -- line: 28
		end,
		setContentWidth = function() -- line: 29
		end,
		handleEvent = function() -- line: 30
		end,
		containerChildren = {
			TextLabel = React.createElement("TextLabel", {
				Text = "Hello, this is a test message!",
				BackgroundTransparency = 1,
				Size = UDim2.new(0, 150, 0, 20)
			})
		}
	}

	if p1 then
		return (Cryo.Dictionary.join(t1, p1))
	end

	return t1
end

local v14 = React.createElement(ChatBubble, (createBubbleProps({
	isIncoming = true
})))
local v15 = React.createElement(ChatBubble, (createBubbleProps({
	isIncoming = false
})))
local v16 = React.createElement(ChatBubble, (createBubbleProps({
	hasTail = true
})))
local v17 = React.createElement(ChatBubble, (createBubbleProps({
	hasTail = false
})))
local v18 = wrapWithProviders(v14)
local v19 = wrapWithProviders(v15)

benchFile(script, function() -- line: 51
	-- upvalues: benchmark (copy), render (copy), wrapWithProviders (copy), v14 (copy), v15 (copy), v16 (copy), v17 (copy), mountComponentTimes (copy), v18 (copy), v19 (copy), scrollComponentTimes (copy)
	benchmark("Render incoming ChatBubble", function() -- line: 52
		-- upvalues: render (copy), wrapWithProviders (copy), v14 (copy)
		render(wrapWithProviders(v14)):unmount()
	end)
	benchmark("Render outgoing ChatBubble", function() -- line: 57
		-- upvalues: render (copy), wrapWithProviders (copy), v15 (copy)
		render(wrapWithProviders(v15)):unmount()
	end)
	benchmark("Render ChatBubble with tail", function() -- line: 62
		-- upvalues: render (copy), wrapWithProviders (copy), v16 (copy)
		render(wrapWithProviders(v16)):unmount()
	end)
	benchmark("Render ChatBubble without tail", function() -- line: 67
		-- upvalues: render (copy), wrapWithProviders (copy), v17 (copy)
		render(wrapWithProviders(v17)):unmount()
	end)
	mountComponentTimes(v18, "ChatBubble (incoming)", 50)
	mountComponentTimes(v19, "ChatBubble (outgoing)", 50)
	mountComponentTimes(v18, "ChatBubble (incoming)", 100)
	scrollComponentTimes(v18, "ChatBubble", 50)
	scrollComponentTimes(v18, "ChatBubble", 100)
end)
