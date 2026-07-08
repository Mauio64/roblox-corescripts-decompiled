local scriptParent = script.Parent
local ParentParent = scriptParent.Parent.Parent
local ParentParentParent = ParentParent.Parent
local React = require(ParentParentParent.React)
local IconButton = require(scriptParent.IconButton)
local describe = require(ParentParentParent.Dev.JestGlobals).describe
local benchmarks = require(ParentParent.Utility.benchmarks)
local mountComponentTimes = benchmarks.mountComponentTimes
local scrollComponentTimes = benchmarks.scrollComponentTimes
local v10 = React.createElement(IconButton, {
	icon = "rbxassetid://7173696656978",
	onActivated = function() -- line: 17
	end
})

describe("IconButton", function() -- line: 21
	-- upvalues: mountComponentTimes (copy), v10 (copy), scrollComponentTimes (copy)
	mountComponentTimes(v10, 1000, "IconButton")
	scrollComponentTimes(v10, 1000, "IconButton")
end)
