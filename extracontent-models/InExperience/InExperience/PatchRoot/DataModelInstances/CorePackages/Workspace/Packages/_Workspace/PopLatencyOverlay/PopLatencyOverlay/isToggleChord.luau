local UserInputService = game:GetService("UserInputService")

return function(p, p2)
	local v = p2 or UserInputService

	if p.KeyCode ~= Enum.KeyCode.L then
		return false
	end

	local v2 = v:IsKeyDown(Enum.KeyCode.LeftShift) or v:IsKeyDown(Enum.KeyCode.RightShift)
	local v3 = v:IsKeyDown(Enum.KeyCode.LeftMeta)
		or v:IsKeyDown(Enum.KeyCode.RightMeta)
		or v:IsKeyDown(Enum.KeyCode.LeftControl)
		or v:IsKeyDown(Enum.KeyCode.RightControl)
	return v2 and v3
end
