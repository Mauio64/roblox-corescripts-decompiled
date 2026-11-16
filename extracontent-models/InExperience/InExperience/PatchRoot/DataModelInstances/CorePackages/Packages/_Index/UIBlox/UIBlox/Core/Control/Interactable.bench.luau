local parent = script.Parent
local parent2 = parent.Parent.Parent
local parent3 = parent2.Parent

local Roact = require(parent3.Roact)
local Interactable = require(parent.Interactable)

local JestGlobals = require(parent3.Dev.JestGlobals)
local describe = JestGlobals.describe

local benchmarks = require(parent2.Utility.benchmarks)
local mountComponentTimes = benchmarks.mountComponentTimes
local scrollComponentTimes = benchmarks.scrollComponentTimes

local element = Roact.createElement(Interactable, {
	onStateChanged = function() end
})

describe("Interactable", function()
	mountComponentTimes(element, 100, "Interactable")
	scrollComponentTimes(element, 100, "Interactable")
end)
