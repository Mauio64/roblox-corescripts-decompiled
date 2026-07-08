local ParentParent = script.Parent.Parent
local React = require(ParentParent.React)

require(ParentParent.Otter)

local useMotor = require(script.Parent.useMotor)

local function useAnimatedBinding(p1, p2) -- line: 12
	-- upvalues: React (copy), useMotor (copy)
	local v7, v8 = React.useBinding(p1)

	return v7, (useMotor(p1, v8, p2))
end

return useAnimatedBinding
