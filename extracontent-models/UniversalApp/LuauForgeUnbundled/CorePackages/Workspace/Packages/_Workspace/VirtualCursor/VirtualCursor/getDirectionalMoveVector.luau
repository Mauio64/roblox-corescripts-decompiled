local function getDirectionForKeycode(k, item)
	if k == Enum.KeyCode.ButtonUp then
		return Vector2.new(0, -item)
	end

	if k == Enum.KeyCode.ButtonDown then
		return Vector2.new(0, item)
	end

	if k == Enum.KeyCode.ButtonLeft then
		return Vector2.new(-item, 0)
	end

	if k == Enum.KeyCode.ButtonRight then
		return Vector2.new(item, 0)
	end

	return Vector2.zero
end

local function getDirectionalMoveVector(items)
	local directionalMoveVector = Vector2.zero

	for k, item in items do
		directionalMoveVector += getDirectionForKeycode(k, item)
	end

	if directionalMoveVector.Magnitude > 1 then
		directionalMoveVector = directionalMoveVector.Unit
	end

	return directionalMoveVector
end

return getDirectionalMoveVector
