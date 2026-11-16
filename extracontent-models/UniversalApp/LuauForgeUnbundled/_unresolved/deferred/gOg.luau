local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

if RunService:IsStudio() then
	return function(callback)
		UserInputService.InputEnded:Connect(function(input)
			local v5 = input.UserInputType == Enum.UserInputType.Keyboard
			local modifierKeyDown = input:isModifierKeyDown(Enum.ModifierKey.Shift)

			if v5 and modifierKeyDown and input.KeyCode == Enum.KeyCode.Backspace then
				callback()
			end
		end)
	end
end

return function(p2) end
