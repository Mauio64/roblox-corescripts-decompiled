local function isPointInGuiObjectBounds(p, vector2: Vector2): boolean
	if not p then
		return false
	end

	local absolutePosition = p.AbsolutePosition
	local absoluteSize = p.AbsoluteSize
	local x = absolutePosition.X
	local y = absolutePosition.Y
	local v = absolutePosition.X + absoluteSize.X
	local v2 = absolutePosition.Y + absoluteSize.Y

	return x <= vector2.X and vector2.X <= v and y <= vector2.Y and vector2.Y <= v2
end

return isPointInGuiObjectBounds
