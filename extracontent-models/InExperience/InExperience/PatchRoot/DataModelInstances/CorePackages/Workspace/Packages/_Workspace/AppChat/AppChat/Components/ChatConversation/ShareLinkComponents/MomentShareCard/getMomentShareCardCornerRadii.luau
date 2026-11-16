local getCornerRadii = require(script.Parent.Parent.getCornerRadii)

local function getMomentShareCardCornerRadii(flag: boolean?, flag2: boolean?, p: number)
	return getCornerRadii({
		topLeft = not (not flag and flag2),
		topRight = not not (flag or flag2)
	}, p)
end

return getMomentShareCardCornerRadii
