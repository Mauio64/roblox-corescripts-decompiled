local RunService = game:GetService("RunService")
local ContextActionService = game:GetService("ContextActionService")
local scriptParent = script.Parent
local ParentParent = scriptParent.Parent.Parent.Parent
local React = require(ParentParent.React)
local Roact = require(ParentParent.Roact)
local EventConnection = require(ParentParent.ReactUtils).EventConnection
local Object = require(ParentParent.LuauPolyfill).Object

require(scriptParent.Constants)

local t1 = {
	VRService = game:GetService("VRService"),
	UpdateEvent = RunService.Heartbeat
}

local function setLaserPointerModeBasedOnUserCFrame(p1, p2) -- line: 45
	if p2:GetUserCFrameEnabled(Enum.UserCFrame.RightHand) and p2:GetUserCFrameEnabled(Enum.UserCFrame.LeftHand) then
		p1.current:setMode(p1.current.Mode.DualPointer)

		return
	end

	if not p2:GetUserCFrameEnabled(Enum.UserCFrame.RightHand) and not p2:GetUserCFrameEnabled(Enum.UserCFrame.LeftHand) then
		p1.current:setMode(p1.current.Mode.Disabled)

		return
	end

	p1.current:setMode(p1.current.Mode.Pointer)
end
local function PointerOverlay(t2: {[any]: any}) -- line: 61
	-- upvalues: Object (copy), t1 (copy), React (copy), setLaserPointerModeBasedOnUserCFrame (copy), ContextActionService (copy), Roact (copy), EventConnection (copy)
	local v15 = Object.assign({}, t1, t2)
	local LaserPointer = v15.LaserPointer
	local VRControllerModel = v15.VRControllerModel
	local VRService = v15.VRService
	local v19 = React.useRef(nil)
	local v20 = React.useRef(nil)
	local v21 = React.useRef(nil)
	local ok, result = pcall(function() -- line: 74
		-- upvalues: VRService (copy)
		return VRService:GetPropertyChangedSignal("VRSessionState")
	end)
	local v24 = React.useCallback(function() -- line: 78
		-- upvalues: v19 (copy), LaserPointer (copy), setLaserPointerModeBasedOnUserCFrame (copy), VRService (copy), v20 (copy), VRControllerModel (copy), v21 (copy), ContextActionService (copy)
		if not v19.current then
			v19.current = LaserPointer.new()
			setLaserPointerModeBasedOnUserCFrame(v19, VRService)
			v19.current:setEnableAmbidexterousPointer(true)
			v20.current = VRControllerModel.new(Enum.UserCFrame.LeftHand)
			v21.current = VRControllerModel.new(Enum.UserCFrame.RightHand)
		end

		v20.current:setEnabled(VRService.VREnabled)
		v21.current:setEnabled(VRService.VREnabled)

		if VRService.VREnabled then
			ContextActionService:BindActivate(Enum.UserInputType.Gamepad1, Enum.KeyCode.ButtonA, Enum.KeyCode.ButtonX, Enum.KeyCode.ButtonR2, Enum.KeyCode.ButtonL2)
		end
	end, {
		v20,
		v21,
		v19,
		LaserPointer,
		VRControllerModel
	})
	local u25 = React.useCallback(function() -- line: 101
		-- upvalues: v20 (copy), v21 (copy), v19 (copy), ContextActionService (copy)
		if v20.current then
			v20.current:setEnabled(false)
		end

		if v21.current then
			v21.current:setEnabled(false)
		end

		if v19.current then
			v19.current:disableComponent()
		end

		ContextActionService:UnbindActivate(Enum.UserInputType.Gamepad1, Enum.KeyCode.ButtonA)
		ContextActionService:UnbindActivate(Enum.UserInputType.Gamepad1, Enum.KeyCode.ButtonR2)
	end, {
		v20,
		v21,
		v19,
		LaserPointer,
		VRControllerModel
	})
	local v26 = React.useCallback(function() -- line: 115
		-- upvalues: VRService (copy), v19 (copy), setLaserPointerModeBasedOnUserCFrame (copy), v20 (copy), v21 (copy)
		local v28 = not (VRService.VRSessionState == Enum.VRSessionState.Idle or VRService.VRSessionState == Enum.VRSessionState.Visible)

		if v19.current then
			if v28 then
				setLaserPointerModeBasedOnUserCFrame(v19, VRService)
			else
				v19.current:setMode(v19.current.Mode.Disabled)
			end
		end

		if v20.current then
			v20.current:setEnabled(v28)
		end

		if v21.current then
			v21.current:setEnabled(v28)
		end
	end, {
		v20,
		v21,
		v19,
		LaserPointer,
		VRControllerModel
	})
	local v27 = React.useCallback(function() -- line: 135
		-- upvalues: setLaserPointerModeBasedOnUserCFrame (copy), v19 (copy), VRService (copy)
		setLaserPointerModeBasedOnUserCFrame(v19, VRService)
	end, { v19 })

	React.useEffect(function() -- line: 140
		-- upvalues: VRService (copy), v24 (copy), u25 (ref)
		if VRService.VREnabled then
			v24()
		end

		return u25
	end, {})

	return React.createElement(Roact.Portal, {
		target = workspace
	}, {
		UserCFrameChangedConnection = React.createElement(EventConnection, {
			event = v15.UpdateEvent,
			callback = function() -- line: 152
				-- upvalues: v19 (copy), v20 (copy), v21 (copy)
				if v19.current then
					v19.current:update()
				end

				if v20.current then
					v20.current:update()
				end

				if v21.current then
					v21.current:update()
				end
			end
		}),
		VREnabledConnection = React.createElement(EventConnection, {
			event = VRService:GetPropertyChangedSignal("VREnabled"),
			callback = v24
		}),
		VRUserCFrameEnabledConnection = React.createElement(EventConnection, {
			event = VRService.UserCFrameEnabled,
			callback = v27
		}),
		VRSessionStateConnection = if not ok then nil else React.createElement(EventConnection, {
			event = result,
			callback = v26
		})
	})
end

return PointerOverlay
