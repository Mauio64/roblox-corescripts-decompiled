local UserInputService = game:GetService("UserInputService")

return function(p2, p3)
	local v5 = p3 or UserInputService

	if p2.KeyCode ~= Enum.KeyCode.L then
		return false
	end

	local v6 = v5:IsKeyDown(Enum.KeyCode.LeftShift) or v5:IsKeyDown(Enum.KeyCode.RightShift)
	local v7 = v5:IsKeyDown(Enum.KeyCode.LeftMeta)
		or v5:IsKeyDown(Enum.KeyCode.RightMeta)
		or v5:IsKeyDown(Enum.KeyCode.LeftControl)
		or v5:IsKeyDown(Enum.KeyCode.RightControl)
	return v6 and v7
end
