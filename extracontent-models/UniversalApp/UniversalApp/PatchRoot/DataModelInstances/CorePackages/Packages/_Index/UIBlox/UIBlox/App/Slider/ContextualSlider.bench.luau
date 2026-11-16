local parent = script.Parent
local parent2 = parent.Parent.Parent
local parent3 = parent2.Parent

local React = require(parent3.React)
local ContextualSlider = require(parent.ContextualSlider)
local SystemSlider = require(parent.SystemSlider)

local JestGlobals = require(parent3.Dev.JestGlobals)
local describe = JestGlobals.describe

local benchmarks = require(parent2.Utility.benchmarks)
local mountComponentTimes = benchmarks.mountComponentTimes
local scrollComponentTimes = benchmarks.scrollComponentTimes

local element = React.createElement(ContextualSlider, {
	min = 0,
	max = 100,
	value = 0,
	onValueChanged = function() end
})

local element2 = React.createElement(SystemSlider, {
	min = 0,
	max = 100,
	value = 0,
	onValueChanged = function() end
})

describe("ContextualSlider", function()
	mountComponentTimes(element, 100, "ContextualSlider")
	scrollComponentTimes(element, 100, "ContextualSlider")
end)
describe("SystemSlider", function()
	mountComponentTimes(element2, 100, "SystemSlider")
	scrollComponentTimes(element2, 100, "SystemSlider")
end)
