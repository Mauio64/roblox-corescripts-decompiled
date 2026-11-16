local React = require("@game/CorePackages/Workspace/Packages/_Workspace/FocusNavigationUtils/React")
local Cryo = require("@game/CorePackages/Workspace/Packages/_Workspace/FocusNavigationUtils/Cryo")

local v5 = {
	Size = UDim2.fromScale(1, 1),
	BackgroundTransparency = 1,
	SelectionGroup = true
}

local v6 = {
	SelectionBehaviorRight = Enum.SelectionBehavior.Stop,
	SelectionBehaviorLeft = Enum.SelectionBehavior.Stop,
	SelectionBehaviorDown = Enum.SelectionBehavior.Stop,
	SelectionBehaviorUp = Enum.SelectionBehavior.Stop
}

local function BaseFocusRoot(props, p2)
	local joined = Cryo.Dictionary.join(v5, props.frameProps or {}, { ref = p2 })

	if props.isIsolated then
		joined = Cryo.Dictionary.union(v6, joined)
	end

	return React.createElement("Frame", joined, props.children)
end

return React.forwardRef(BaseFocusRoot)
