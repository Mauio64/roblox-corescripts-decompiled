local scriptParent = script.Parent
local ParentParent = scriptParent.Parent.Parent
local ParentParentParent = ParentParent.Parent
local React = require(ParentParentParent.React)
local Button = require(scriptParent.Button)
local describe = require(ParentParentParent.Dev.JestGlobals).describe
local benchmarks = require(ParentParent.Utility.benchmarks)
local mountComponentTimes = benchmarks.mountComponentTimes
local scrollComponentTimes = benchmarks.scrollComponentTimes
local v10 = React.createElement(Button, {
	text = "Button",
	onActivated = function() -- line: 17
	end
})

describe("Button", function() -- line: 21
	-- upvalues: mountComponentTimes (copy), v10 (copy), scrollComponentTimes (copy)
	mountComponentTimes(v10, 100, "Button")
	scrollComponentTimes(v10, 100, "Button")
end)
