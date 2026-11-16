local ContextActionService = game:GetService("ContextActionService")

local useEffect = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/React").useEffect

local v5 = {
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

return function(p2)
	useEffect(function()
		if p2 then
			ContextActionService:BindCoreActionAtPriority("AppChatDisableGameControls", function(p3, p4, p5)
				if p5.KeyCode == Enum.KeyCode.Escape then
					return Enum.ContextActionResult.Pass
				end

				return Enum.ContextActionResult.Sink
			end, false, Enum.ContextActionPriority.Low.Value, unpack(v5))
		end

		return function()
			if p2 then
				ContextActionService:UnbindCoreAction("AppChatDisableGameControls")
			end
		end
	end, { p2 })
end
