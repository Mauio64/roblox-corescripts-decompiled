local CoreGui = game:GetService("CoreGui")
local CorePackages = game:GetService("CorePackages")
local RunService = game:GetService("RunService")
local ContextActionService = game:GetService("ContextActionService")
local Modules = CoreGui.RobloxGui.Modules
local React = require(CorePackages.Packages.React)
local Roact = require(CorePackages.Packages.Roact)
local GamepadUtils = require(CorePackages.Workspace.Packages.InputUi).Gamepad.GamepadUtils

local function VRAvatarRotateHandler(t1: {[any]: any}) -- line: 24
	-- upvalues: RunService (copy), GamepadUtils (copy), ContextActionService (copy), React (copy), Roact (copy)
	local u11 = false

	local function rotate(_, _, p3) -- line: 27
		-- upvalues: u11 (ref), RunService (copy), GamepadUtils (copy), t1 (copy)
		if not u11 then
			u11 = true
			RunService:BindToRenderStep("VRAvatarEditorJoystickRotate", Enum.RenderPriority.Input.Value, function(p4) -- line: 33
				-- upvalues: GamepadUtils (copy), p3 (copy), t1 (copy)
				GamepadUtils.rotateAndZoom(p3, p4, t1.setAngularVelocityByPixels, t1.rotateByRadians)
			end)
		end

		return Enum.ContextActionResult.Pass
	end
	local function unbindRotate() -- line: 47
		-- upvalues: ContextActionService (copy), RunService (copy), u11 (ref)
		ContextActionService:UnbindCoreAction("RotateAvatarWithGamepadVR_R")
		ContextActionService:UnbindCoreAction("RotateAvatarWithGamepadVR_L")
		RunService:UnbindFromRenderStep("VRAvatarEditorJoystickRotate")
		u11 = false
	end
	local function bindRotate() -- line: 55
		-- upvalues: ContextActionService (copy), RunService (copy), u11 (ref), rotate (copy)
		ContextActionService:UnbindCoreAction("RotateAvatarWithGamepadVR_R")
		ContextActionService:UnbindCoreAction("RotateAvatarWithGamepadVR_L")
		RunService:UnbindFromRenderStep("VRAvatarEditorJoystickRotate")
		u11 = false
		ContextActionService:BindCoreAction("RotateAvatarWithGamepadVR_R", rotate, false, Enum.KeyCode.Thumbstick2)
		ContextActionService:BindCoreAction("RotateAvatarWithGamepadVR_L", rotate, false, Enum.KeyCode.Thumbstick1)
	end

	React.useEffect(function() -- line: 62
		-- upvalues: ContextActionService (copy), RunService (copy), u11 (ref)
		return function() -- line: 63
			-- upvalues: ContextActionService (copy), RunService (copy), u11 (ref)
			ContextActionService:UnbindCoreAction("RotateAvatarWithGamepadVR_R")
			ContextActionService:UnbindCoreAction("RotateAvatarWithGamepadVR_L")
			RunService:UnbindFromRenderStep("VRAvatarEditorJoystickRotate")
			u11 = false
		end
	end, {})

	return Roact.createElement("Frame", {
		Size = UDim2.new(1, 0, 1, 0),
		BackgroundTransparency = 1,
		[Roact.Event.MouseEnter] = bindRotate,
		[Roact.Event.MouseLeave] = unbindRotate
	})
end

return (require(Modules.AvatarExperience.Common.Context.wrapWithSceneInteractionCallbacks)(VRAvatarRotateHandler))
