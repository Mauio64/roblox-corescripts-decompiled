local parent = script.Parent
local parent2 = parent.Parent.Parent
local parent3 = parent2.Parent

local React = require(parent3.React)
local Button = require(parent.Button)

local JestGlobals = require(parent3.Dev.JestGlobals)
local describe = JestGlobals.describe

local benchmarks = require(parent2.Utility.benchmarks)
local mountComponentTimes = benchmarks.mountComponentTimes
local scrollComponentTimes = benchmarks.scrollComponentTimes

local element = React.createElement(Button, {
	onActivated = function() end,
	text = "Button"
})

describe("Button", function()
	mountComponentTimes(element, 100, "Button")
	scrollComponentTimes(element, 100, "Button")
end)
