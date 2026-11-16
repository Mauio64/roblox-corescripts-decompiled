local parent = script:FindFirstAncestor("FocusNavigationUtils").Parent

local React = require(parent.React)
local Cryo = require(parent.Cryo)

local v = { Size = UDim2.fromScale(1, 1), BackgroundTransparency = 1, SelectionGroup = true }

local v2 = {
	SelectionBehaviorRight = Enum.SelectionBehavior.Stop,
	SelectionBehaviorLeft = Enum.SelectionBehavior.Stop,
	SelectionBehaviorDown = Enum.SelectionBehavior.Stop,
	SelectionBehaviorUp = Enum.SelectionBehavior.Stop
}

local function BaseFocusRoot(props, ref)
	local joined = Cryo.Dictionary.join(v, props.frameProps or {}, { ref = ref })

	if props.isIsolated then
		joined = Cryo.Dictionary.union(v2, joined)
	end

	return React.createElement("Frame", joined, props.children)
end

return React.forwardRef(BaseFocusRoot)
