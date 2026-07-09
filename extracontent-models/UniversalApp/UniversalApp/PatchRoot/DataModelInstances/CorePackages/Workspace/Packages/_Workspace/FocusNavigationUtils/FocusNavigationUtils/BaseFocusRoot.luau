local Parent = script:FindFirstAncestor("FocusNavigationUtils").Parent
local React = require(Parent.React)
local Cryo = require(Parent.Cryo)
local t1 = {
	BackgroundTransparency = 1,
	SelectionGroup = true,
	Size = UDim2.fromScale(1, 1)
}
local t2 = {
	SelectionBehaviorRight = Enum.SelectionBehavior.Stop,
	SelectionBehaviorLeft = Enum.SelectionBehavior.Stop,
	SelectionBehaviorDown = Enum.SelectionBehavior.Stop,
	SelectionBehaviorUp = Enum.SelectionBehavior.Stop
}

local function BaseFocusRoot(t3: {[any]: any}, p1) -- line: 26
	-- upvalues: Cryo (copy), t1 (copy), t2 (copy), React (copy)
	local v9 = Cryo.Dictionary.join(t1, t3.frameProps or {}, {
		ref = p1
	})

	if t3.isIsolated then
		v9 = Cryo.Dictionary.union(t2, v9)
	end

	return React.createElement("Frame", v9, t3.children)
end

return React.forwardRef(BaseFocusRoot)
