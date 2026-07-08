local scriptParent = script.Parent
local ParentParent = scriptParent.Parent.Parent
local ParentParentParent = ParentParent.Parent
local Roact = require(ParentParentParent.Roact)
local Interactable = require(scriptParent.Interactable)
local describe = require(ParentParentParent.Dev.JestGlobals).describe
local benchmarks = require(ParentParent.Utility.benchmarks)
local mountComponentTimes = benchmarks.mountComponentTimes
local scrollComponentTimes = benchmarks.scrollComponentTimes
local v10 = Roact.createElement(Interactable, {
	onStateChanged = function() -- line: 17
	end
})

describe("Interactable", function() -- line: 20
	-- upvalues: mountComponentTimes (copy), v10 (copy), scrollComponentTimes (copy)
	mountComponentTimes(v10, 100, "Interactable")
	scrollComponentTimes(v10, 100, "Interactable")
end)
