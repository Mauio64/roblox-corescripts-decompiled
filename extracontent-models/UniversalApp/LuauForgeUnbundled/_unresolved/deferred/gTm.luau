local CorePackages = game:GetService("CorePackages")
local RunService = game:GetService("RunService")
local ContextActionService = game:GetService("ContextActionService")

local React = require(CorePackages.Packages.React)
local Roact = require(CorePackages.Packages.Roact)
local gamepadUtils = require("@luauforge/bundled/fCf").Gamepad.GamepadUtils

local function VRAvatarRotateHandler(p2)
	local v5 = false

	local function rotate(p3, p4, p5)
		if not v5 then
			v5 = true
			RunService:BindToRenderStep(
				"VRAvatarEditorJoystickRotate",
				Enum.RenderPriority.Input.Value,
				function(p6)
					gamepadUtils.rotateAndZoom(p5, p6, p2.setAngularVelocityByPixels, p2.rotateByRadians)
				end
			)
		end

		return Enum.ContextActionResult.Pass
	end

	local function unbindRotate()
		ContextActionService:UnbindCoreAction("RotateAvatarWithGamepadVR_R")
		ContextActionService:UnbindCoreAction("RotateAvatarWithGamepadVR_L")

		RunService:UnbindFromRenderStep("VRAvatarEditorJoystickRotate")
		v5 = false
	end

	local function bindRotate()
		ContextActionService:UnbindCoreAction("RotateAvatarWithGamepadVR_R")
		ContextActionService:UnbindCoreAction("RotateAvatarWithGamepadVR_L")

		RunService:UnbindFromRenderStep("VRAvatarEditorJoystickRotate")
		v5 = false

		ContextActionService:BindCoreAction(
			"RotateAvatarWithGamepadVR_R",
			rotate,
			false,
			Enum.KeyCode.Thumbstick2
		)
		ContextActionService:BindCoreAction(
			"RotateAvatarWithGamepadVR_L",
			rotate,
			false,
			Enum.KeyCode.Thumbstick1
		)
	end

	React.useEffect(function()
		return function()
			ContextActionService:UnbindCoreAction("RotateAvatarWithGamepadVR_R")
			ContextActionService:UnbindCoreAction("RotateAvatarWithGamepadVR_L")

			RunService:UnbindFromRenderStep("VRAvatarEditorJoystickRotate")
			v5 = false
		end
	end, {})

	return Roact.createElement("Frame", {
		Size = UDim2.new(1, 0, 1, 0),
		BackgroundTransparency = 1,
		[Roact.Event.MouseEnter] = bindRotate,
		[Roact.Event.MouseLeave] = unbindRotate
	})
end

return (require("@luauforge/bundled/gTk")(VRAvatarRotateHandler))
