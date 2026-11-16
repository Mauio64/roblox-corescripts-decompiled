local parent = script.Parent.Parent

local Cryo = require(parent.Cryo)
local Roact = require(parent.Roact)

local FitFrameOnAxis = require(script.Parent.FitFrameOnAxis)
local isRoact17 = require(script.Parent.isRoact17)

return Roact.forwardRef(function(options, p)
	local v = options or {}
	local height = v.height

	local v2 = isRoact17() and "forwardedRef" or Roact.Ref
	local joined = Cryo.Dictionary.join(v, {
		axis = FitFrameOnAxis.Axis.Horizontal,
		minimumSize = UDim2.new(UDim.new(0, 0), height),
		[v2] = p,
		height = Cryo.None
	})

	return Roact.createElement(FitFrameOnAxis, joined)
end)
