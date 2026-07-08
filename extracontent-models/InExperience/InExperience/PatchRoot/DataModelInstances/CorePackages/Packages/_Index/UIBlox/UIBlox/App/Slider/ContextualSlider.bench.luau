local scriptParent = script.Parent
local ParentParent = scriptParent.Parent.Parent
local ParentParentParent = ParentParent.Parent
local React = require(ParentParentParent.React)
local ContextualSlider = require(scriptParent.ContextualSlider)
local SystemSlider = require(scriptParent.SystemSlider)
local describe = require(ParentParentParent.Dev.JestGlobals).describe
local benchmarks = require(ParentParent.Utility.benchmarks)
local mountComponentTimes = benchmarks.mountComponentTimes
local scrollComponentTimes = benchmarks.scrollComponentTimes
local v11 = React.createElement(ContextualSlider, {
	min = 0,
	max = 100,
	value = 0,
	onValueChanged = function() -- line: 21
	end
})
local v12 = React.createElement(SystemSlider, {
	min = 0,
	max = 100,
	value = 0,
	onValueChanged = function() -- line: 27
	end
})

describe("ContextualSlider", function() -- line: 30
	-- upvalues: mountComponentTimes (copy), v11 (copy), scrollComponentTimes (copy)
	mountComponentTimes(v11, 100, "ContextualSlider")
	scrollComponentTimes(v11, 100, "ContextualSlider")
end)
describe("SystemSlider", function() -- line: 34
	-- upvalues: mountComponentTimes (copy), v12 (copy), scrollComponentTimes (copy)
	mountComponentTimes(v12, 100, "SystemSlider")
	scrollComponentTimes(v12, 100, "SystemSlider")
end)
