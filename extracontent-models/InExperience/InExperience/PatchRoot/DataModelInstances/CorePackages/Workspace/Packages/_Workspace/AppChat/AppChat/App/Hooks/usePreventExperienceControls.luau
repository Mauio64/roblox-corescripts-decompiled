local ContextActionService = game:GetService("ContextActionService")
local Parent = script:FindFirstAncestor("AppChat").Parent
local useEffect = require(Parent.React).useEffect
local t1 = {
	Enum.PlayerActions.CharacterForward,
	Enum.PlayerActions.CharacterBackward,
	Enum.PlayerActions.CharacterLeft,
	Enum.PlayerActions.CharacterRight,
	Enum.PlayerActions.CharacterJump,
	Enum.KeyCode.LeftShift,
	Enum.KeyCode.RightShift,
	Enum.KeyCode.Tab,
	Enum.UserInputType.Gamepad1,
	Enum.UserInputType.Gamepad2,
	Enum.UserInputType.Gamepad3,
	Enum.UserInputType.Gamepad4,
	Enum.UserInputType.Touch,
	Enum.UserInputType.Keyboard,
	Enum.UserInputType.MouseButton1,
	Enum.UserInputType.MouseButton2
}

return function(b1: boolean) -- line: 31
	-- upvalues: useEffect (copy), ContextActionService (copy), t1 (copy)
	useEffect(function() -- line: 32
		-- upvalues: b1 (copy), ContextActionService (copy), t1 (copy)
		if b1 then
			ContextActionService:BindCoreActionAtPriority("AppChatDisableGameControls", function(_, _, p3) -- line: 34
				if p3.KeyCode == Enum.KeyCode.Escape then
					return Enum.ContextActionResult.Pass
				end

				return Enum.ContextActionResult.Sink
			end, false, Enum.ContextActionPriority.Low.Value, unpack(t1))
		end

		return function() -- line: 43
			-- upvalues: b1 (copy), ContextActionService (copy)
			if b1 then
				ContextActionService:UnbindCoreAction("AppChatDisableGameControls")
			end
		end
	end, { b1 })
end
