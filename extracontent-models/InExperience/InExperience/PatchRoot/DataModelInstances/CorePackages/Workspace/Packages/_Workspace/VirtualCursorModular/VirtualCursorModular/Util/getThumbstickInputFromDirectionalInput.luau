local parent = script.Parent.Parent

game:GetService("GuiService")
require(parent.Properties)

local function getThumbstickInputFromDirectionalInput(p, p2: number)
	local zero = Vector2.zero

	if p == Enum.KeyCode.ButtonUp then
		return (Vector2.new(0, p2))
	end

	if p == Enum.KeyCode.ButtonDown then
		return (Vector2.new(0, -p2))
	end

	if p == Enum.KeyCode.ButtonLeft then
		return (Vector2.new(-p2, 0))
	end

	if p == Enum.KeyCode.ButtonRight then
		return (Vector2.new(p2, 0))
	end

	return zero
end

return getThumbstickInputFromDirectionalInput
