local function isInputInsideObject(vector3: Vector3, p): boolean
	if not p then
		return false
	end

	local absolutePosition = p.AbsolutePosition
	local absoluteSize = p.AbsoluteSize
	local rect = Rect.new(absolutePosition, absolutePosition + absoluteSize)

	return vector3.X >= rect.Min.X and vector3.Y >= rect.Min.Y and vector3.X <= rect.Max.X and vector3.Y <= rect.Max.Y
end

return isInputInsideObject
