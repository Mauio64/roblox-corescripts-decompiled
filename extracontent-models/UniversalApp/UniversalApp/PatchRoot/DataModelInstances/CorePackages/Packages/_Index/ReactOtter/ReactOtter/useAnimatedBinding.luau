local parent = script.Parent.Parent
local React = require(parent.React)

require(parent.Otter)

local useMotor = require(script.Parent.useMotor)

local function useAnimatedBinding(p, p2)
	local v, v2 = React.useBinding(p)
	return v, (useMotor(p, v2, p2))
end

return useAnimatedBinding
