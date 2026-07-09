local UserInputService = game:GetService("UserInputService")

if not game:GetService("RunService"):IsStudio() then
	return function(_) -- line: 6
	end
end

return function(p2) -- line: 9
	-- upvalues: UserInputService (copy)
	UserInputService.InputEnded:Connect(function(input) -- line: 10
		-- upvalues: p2 (copy)
		local v5 = input.UserInputType == Enum.UserInputType.Keyboard
		local v6 = input:isModifierKeyDown(Enum.ModifierKey.Shift)

		if v5 and (v6 and input.KeyCode == Enum.KeyCode.Backspace) then
			p2()
		end
	end)
end
