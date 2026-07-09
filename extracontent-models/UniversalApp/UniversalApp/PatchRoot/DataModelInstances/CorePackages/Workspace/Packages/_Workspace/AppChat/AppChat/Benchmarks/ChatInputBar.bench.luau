local AppChat = script:FindFirstAncestor("AppChat")
local AppChatParent = AppChat.Parent
local Cryo = require(AppChatParent.Cryo)
local React = require(AppChatParent.React)
local ReactTestingLibrary = require(AppChatParent.Dev.ReactTestingLibrary)
local render = ReactTestingLibrary.render
local act = ReactTestingLibrary.act
local benchmark = require(AppChatParent.Dev.JestBenchmark).benchmark
local BenchmarkUtils = require(AppChatParent.Dev.BenchmarkUtils)
local benchFile = BenchmarkUtils.benchFile
local mountComponentTimes = BenchmarkUtils.mountComponentTimes
local measureFPS = BenchmarkUtils.measureFPS
local ChatInputBar = require(AppChat.Components.ChatConversation.ChatInputBar)
local wrapWithProviders = require(script.Parent.Utils.wrapWithProviders)
local UserInputService = game:GetService("UserInputService")

local function createInputBarProps(t1: {[any]: any}?) -- line: 24
	-- upvalues: UserInputService (copy), Cryo (copy)
	local t2 = {
		initialInputText = "",
		placeholderText = "Write a message",
		inputBarDisabledText = "Chat Disabled",
		inputBoxRef = nil,
		inputBarRef = nil,
		LayoutOrder = 0,
		maxCharacterLength = 160,
		maxKeystrokeDataLength = 200,
		messageListRef = nil,
		isDisabled = false,
		disabledEndTimestampDisplay = nil,
		textChangedFallback = true,
		moreMenuEnabled = false,
		userInputService = UserInputService,
		onHeightChanged = function() -- line: 36
		end,
		onPositionChanged = function() -- line: 37
		end,
		onFocusLost = function() -- line: 38
		end,
		onSendBtnClicked = function() -- line: 41
		end,
		onSendChat = function() -- line: 42
		end,
		onTextChanged = function() -- line: 43
		end,
		onDisabledInputBarActivated = function() -- line: 44
		end,
		eventLoggingFunc = function() -- line: 45
		end
	}

	if t1 then
		return (Cryo.Dictionary.join(t2, t1))
	end

	return t2
end

local v17 = React.createElement(ChatInputBar, (createInputBarProps()))
local v18 = React.createElement(ChatInputBar, (createInputBarProps({
	initialInputText = "Hello, this is a test message!"
})))
local v19 = React.createElement(ChatInputBar, (createInputBarProps({
	isDisabled = true,
	disabledEndTimestampDisplay = os.time() + 300
})))
local v20 = React.createElement(ChatInputBar, (createInputBarProps({
	moreMenuEnabled = true
})))
local v21 = wrapWithProviders(v17)

benchFile(script, function() -- line: 76
	-- upvalues: benchmark (copy), render (copy), wrapWithProviders (copy), v17 (copy), v18 (copy), v19 (copy), v20 (copy), createInputBarProps (copy), React (copy), ChatInputBar (copy), act (copy), mountComponentTimes (copy), v21 (copy), measureFPS (copy)
	benchmark("Render empty ChatInputBar", function() -- line: 77
		-- upvalues: render (copy), wrapWithProviders (copy), v17 (copy)
		render(wrapWithProviders(v17)):unmount()
	end)
	benchmark("Render ChatInputBar with initial text", function() -- line: 82
		-- upvalues: render (copy), wrapWithProviders (copy), v18 (copy)
		render(wrapWithProviders(v18)):unmount()
	end)
	benchmark("Render disabled ChatInputBar", function() -- line: 87
		-- upvalues: render (copy), wrapWithProviders (copy), v19 (copy)
		render(wrapWithProviders(v19)):unmount()
	end)
	benchmark("Render ChatInputBar with more menu enabled", function() -- line: 92
		-- upvalues: render (copy), wrapWithProviders (copy), v20 (copy)
		render(wrapWithProviders(v20)):unmount()
	end)
	benchmark("Re-render ChatInputBar with text changes", function() -- line: 97
		-- upvalues: createInputBarProps (copy), render (copy), wrapWithProviders (copy), React (copy), ChatInputBar (copy), act (copy)
		local v24 = createInputBarProps()
		local v25 = render(wrapWithProviders(React.createElement(ChatInputBar, v24)))

		for _, v in ipairs({
			"H",
			"He",
			"Hel",
			"Hell",
			"Hello",
			"Hello!"
		}) do
			act(function() -- line: 111
				-- upvalues: createInputBarProps (copy), v (copy), v25 (copy), wrapWithProviders (copy), React (copy), ChatInputBar (copy)
				local v35 = createInputBarProps({
					initialInputText = v
				})

				v25:rerender(wrapWithProviders(React.createElement(ChatInputBar, v35)))
			end)
		end

		v25:unmount()
	end)
	benchmark("Re-render ChatInputBar with long message", function() -- line: 120
		-- upvalues: createInputBarProps (copy), render (copy), wrapWithProviders (copy), React (copy), ChatInputBar (copy), act (copy)
		local v28 = createInputBarProps()
		local v29 = render(wrapWithProviders(React.createElement(ChatInputBar, v28)))
		local v30 = string.rep("a", 160)

		act(function() -- line: 126
			-- upvalues: createInputBarProps (copy), v30 (copy), v29 (copy), wrapWithProviders (copy), React (copy), ChatInputBar (copy)
			local v36 = createInputBarProps({
				initialInputText = v30
			})

			v29:rerender(wrapWithProviders(React.createElement(ChatInputBar, v36)))
		end)
		v29:unmount()
	end)
	mountComponentTimes(v21, "ChatInputBar", 25)
	mountComponentTimes(v21, "ChatInputBar", 50)
	benchmark("ChatInputBar FPS (empty)", function(p1) -- line: 137
		-- upvalues: render (copy), wrapWithProviders (copy), v17 (copy), measureFPS (copy)
		local v32 = render(wrapWithProviders(v17))

		measureFPS(p1, 0.3)
		v32:unmount()
	end)
	benchmark("ChatInputBar FPS (with text)", function(p2) -- line: 143
		-- upvalues: render (copy), wrapWithProviders (copy), v18 (copy), measureFPS (copy)
		local v34 = render(wrapWithProviders(v18))

		measureFPS(p2, 0.3)
		v34:unmount()
	end)
end)
