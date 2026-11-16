local parent = script.Parent.Parent

local Cryo = require(parent.Cryo)
local Roact = require(parent.Roact)

local FitFrameOnAxis = require(script.Parent.FitFrameOnAxis)
local isRoact17 = require(script.Parent.isRoact17)

return Roact.forwardRef(function(options, p)
	local v = options or {}
	local width = v.width

	local v2 = isRoact17() and "forwardedRef" or Roact.Ref
	local joined = Cryo.Dictionary.join(v, {
		axis = FitFrameOnAxis.Axis.Vertical,
		minimumSize = UDim2.new(width, UDim.new(0, 0)),
		[v2] = p,
		width = Cryo.None
	})

	return Roact.createElement(FitFrameOnAxis, joined)
end)
