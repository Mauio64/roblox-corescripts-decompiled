local parent = script:FindFirstAncestor("BuildExperience").Parent

local React = require(parent.React)

local AnimatedChipGroupView = require(script.Parent.AnimatedChipGroupView)
local useAnimatedChipGroupViewModel = require(script.Parent.useAnimatedChipGroupViewModel)

local function AnimatedChipGroupContainer(p)
	local v = useAnimatedChipGroupViewModel(p)
	return React.createElement(AnimatedChipGroupView, v)
end

return AnimatedChipGroupContainer
