local function isInputInsideObject(vector3: Vector3, p1) -- line: 1
	if not p1 then
		return false
	end

	local AbsolutePosition = p1.AbsolutePosition
	local AbsoluteSize = p1.AbsoluteSize
	local rect = Rect.new(AbsolutePosition, AbsolutePosition + AbsoluteSize)

	return vector3.X >= rect.Min.X and (vector3.Y >= rect.Min.Y and (vector3.X <= rect.Max.X and vector3.Y <= rect.Max.Y))
end

return isInputInsideObject
