require(script.Parent.Parent.groupMessages)
require(script.Parent.Types)

local function getBubbleCornerRadii(p, p2, p3: number)
	local v = not p.isFirst and 0 or p3
	local v2 = not p.isLast and 0 or p3

	if p2 == "left" then
		return { topLeft = v, topRight = p3, bottomLeft = v2, bottomRight = p3 }
	end

	return { topLeft = p3, topRight = v, bottomLeft = p3, bottomRight = v2 }
end

return getBubbleCornerRadii
