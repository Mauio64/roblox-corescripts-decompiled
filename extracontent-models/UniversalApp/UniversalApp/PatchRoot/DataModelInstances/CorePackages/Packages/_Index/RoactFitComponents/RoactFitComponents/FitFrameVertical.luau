local ParentParent = script.Parent.Parent
local Cryo = require(ParentParent.Cryo)
local Roact = require(ParentParent.Roact)
local FitFrameOnAxis = require(script.Parent.FitFrameOnAxis)
local isRoact17 = require(script.Parent.isRoact17)

return Roact.forwardRef(function(p1, p2) -- line: 10
	-- upvalues: isRoact17 (copy), Roact (copy), Cryo (copy), FitFrameOnAxis (copy)
	local v8 = p1 or {}
	local width = v8.width
	local v10 = if not isRoact17() then Roact.Ref else "forwardedRef"
	local v11 = Cryo.Dictionary.join(v8, {
		axis = FitFrameOnAxis.Axis.Vertical,
		minimumSize = UDim2.new(width, UDim.new(0, 0)),
		[v10] = p2,
		width = Cryo.None
	})

	return Roact.createElement(FitFrameOnAxis, v11)
end)
