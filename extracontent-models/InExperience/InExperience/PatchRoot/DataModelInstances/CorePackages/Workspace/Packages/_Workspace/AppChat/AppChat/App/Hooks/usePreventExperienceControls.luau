local ContextActionService = game:GetService("ContextActionService")

local parent = script:FindFirstAncestor("AppChat").Parent

local React = require(parent.React)
local useEffect = React.useEffect

local v = {
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

return function(flag: boolean)
	useEffect(function()
		if flag then
			ContextActionService:BindCoreActionAtPriority("AppChatDisableGameControls", function(_, _, p)
				if p.KeyCode == Enum.KeyCode.Escape then
					return Enum.ContextActionResult.Pass
				end

				return Enum.ContextActionResult.Sink
			end, false, Enum.ContextActionPriority.Low.Value, unpack(v))
		end

		return function()
			if flag then
				ContextActionService:UnbindCoreAction("AppChatDisableGameControls")
			end
		end
	end, { flag })
end
