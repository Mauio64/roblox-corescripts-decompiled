local ChatUIPrimitives = script:FindFirstAncestor("ChatUIPrimitives")
local parent = ChatUIPrimitives.Parent
local React = require(parent.React)
local Foundation = require(parent.Foundation)

local ReactTestingLibrary = require(parent.Dev.ReactTestingLibrary)
local render = ReactTestingLibrary.render

local BenchmarkUtils = require(parent.Dev.BenchmarkUtils)
local benchFile = BenchmarkUtils.benchFile
local benchmarkWarm = BenchmarkUtils.benchmarkWarm
local benchmarkInstanceCount = BenchmarkUtils.benchmarkInstanceCount

local ChatInputBarView = require(ChatUIPrimitives.Components.ChatInputBar.ChatInputBarView)

local element = React.createElement(Foundation.FoundationProvider, nil, React.createElement(ChatInputBarView, {
	onSend = function(_: string) end,
	canLocalUserChat = true,
	placeholderText = "Write a message",
	autocomplete = { commands = nil, emojis = true }
}))

benchFile(script, function()
	benchmarkWarm("Render ChatInputBarView (emoji autocomplete)", function()
		render(element):unmount()
	end)

	benchmarkInstanceCount("Mount ChatInputBarView (emoji autocomplete)", element)
end)
