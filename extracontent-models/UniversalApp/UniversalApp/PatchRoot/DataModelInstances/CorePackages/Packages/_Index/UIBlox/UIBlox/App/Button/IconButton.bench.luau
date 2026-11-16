local parent = script.Parent
local parent2 = parent.Parent.Parent
local parent3 = parent2.Parent

local React = require(parent3.React)
local IconButton = require(parent.IconButton)

local JestGlobals = require(parent3.Dev.JestGlobals)
local describe = JestGlobals.describe

local benchmarks = require(parent2.Utility.benchmarks)
local mountComponentTimes = benchmarks.mountComponentTimes
local scrollComponentTimes = benchmarks.scrollComponentTimes

local element = React.createElement(IconButton, {
	onActivated = function() end,
	icon = "rbxassetid://7173696656978"
})

describe("IconButton", function()
	mountComponentTimes(element, 1000, "IconButton")
	scrollComponentTimes(element, 1000, "IconButton")
end)
