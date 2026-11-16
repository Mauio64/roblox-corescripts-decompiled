local MessageGroupShape = require(script.Parent.MessageGroupShape)

local Direction = MessageGroupShape.Direction
local Position = MessageGroupShape.Position

local function getGroupCornerRadii(p, p2: number)
	if p.position == Position.Only then
		return { topLeft = p2, topRight = p2, bottomLeft = p2, bottomRight = p2 }
	end

	local v = p.position ~= Position.First and 0 or p2
	local v2 = p.position ~= Position.Last and 0 or p2

	if p.direction == Direction.Incoming then
		return { topLeft = v, topRight = p2, bottomLeft = v2, bottomRight = p2 }
	end

	return { topLeft = p2, topRight = v, bottomLeft = p2, bottomRight = v2 }
end

return getGroupCornerRadii
