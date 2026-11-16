local RunService = game:GetService("RunService")
local ContextActionService = game:GetService("ContextActionService")
local parent = script.Parent
local parent2 = parent.Parent.Parent.Parent
local React = require(parent2.React)
local Roact = require(parent2.Roact)

local ReactUtils = require(parent2.ReactUtils)
local EventConnection = ReactUtils.EventConnection

local LuauPolyfill = require(parent2.LuauPolyfill)
local Object = LuauPolyfill.Object
require(parent.Constants)

local v = { VRService = game:GetService("VRService"), UpdateEvent = RunService.Heartbeat }

local function setLaserPointerModeBasedOnUserCFrame(ref, vrService)
	if
		vrService:GetUserCFrameEnabled(Enum.UserCFrame.RightHand)
		and vrService:GetUserCFrameEnabled(Enum.UserCFrame.LeftHand)
	then
		ref.current:setMode(ref.current.Mode.DualPointer)
	elseif
		vrService:GetUserCFrameEnabled(Enum.UserCFrame.RightHand)
		or vrService:GetUserCFrameEnabled(Enum.UserCFrame.LeftHand)
	then
		ref.current:setMode(ref.current.Mode.Pointer)
	else
		ref.current:setMode(ref.current.Mode.Disabled)
	end
end

local function PointerOverlay(p)
	local v2 = Object.assign({}, v, p)

	local laserPointer = v2.LaserPointer
	local vrControllerModel = v2.VRControllerModel
	local vrService = v2.VRService

	local ref = React.useRef(nil)
	local ref2 = React.useRef(nil)
	local ref3 = React.useRef(nil)

	local success, result = pcall(function()
		return vrService:GetPropertyChangedSignal("VRSessionState")
	end)

	local callback = React.useCallback(function()
		if not ref.current then
			ref.current = laserPointer.new()
			setLaserPointerModeBasedOnUserCFrame(ref, vrService)
			ref.current:setEnableAmbidexterousPointer(true)
			ref2.current = vrControllerModel.new(Enum.UserCFrame.LeftHand)
			ref3.current = vrControllerModel.new(Enum.UserCFrame.RightHand)
		end

		ref2.current:setEnabled(vrService.VREnabled)
		ref3.current:setEnabled(vrService.VREnabled)

		if vrService.VREnabled then
			ContextActionService:BindActivate(
				Enum.UserInputType.Gamepad1,
				Enum.KeyCode.ButtonA,
				Enum.KeyCode.ButtonX,
				Enum.KeyCode.ButtonR2,
				Enum.KeyCode.ButtonL2
			)
		end
	end, { ref2, ref3, ref, laserPointer, vrControllerModel })

	local v3 = React.useCallback(function()
		if ref2.current then
			ref2.current:setEnabled(false)
		end

		if ref3.current then
			ref3.current:setEnabled(false)
		end

		if ref.current then
			ref.current:disableComponent()
		end

		ContextActionService:UnbindActivate(Enum.UserInputType.Gamepad1, Enum.KeyCode.ButtonA)
		ContextActionService:UnbindActivate(Enum.UserInputType.Gamepad1, Enum.KeyCode.ButtonR2)
	end, { ref2, ref3, ref, laserPointer, vrControllerModel })

	local callback2 = React.useCallback(function()
		local v4 = vrService.VRSessionState ~= Enum.VRSessionState.Idle
			and vrService.VRSessionState ~= Enum.VRSessionState.Visible

		if ref.current then
			if v4 then
				setLaserPointerModeBasedOnUserCFrame(ref, vrService)
			else
				ref.current:setMode(ref.current.Mode.Disabled)
			end
		end

		if ref2.current then
			ref2.current:setEnabled(v4)
		end

		if ref3.current then
			ref3.current:setEnabled(v4)
		end
	end, { ref2, ref3, ref, laserPointer, vrControllerModel })

	local callback3 = React.useCallback(function()
		setLaserPointerModeBasedOnUserCFrame(ref, vrService)
	end, { ref })

	React.useEffect(function()
		if vrService.VREnabled then
			callback()
		end

		return v3
	end, {})

	local createElement = React.createElement
	local portal = Roact.Portal
	local v4 = { target = workspace }

	local v5 = {
		UserCFrameChangedConnection = React.createElement(EventConnection, {
			event = v2.UpdateEvent,
			callback = function()
				if ref.current then
					ref.current:update()
				end

				if ref2.current then
					ref2.current:update()
				end

				if ref3.current then
					ref3.current:update()
				end
			end
		}),
		VREnabledConnection = React.createElement(EventConnection, {
			event = vrService:GetPropertyChangedSignal("VREnabled"),
			callback = callback
		}),
		VRUserCFrameEnabledConnection = React.createElement(EventConnection, {
			event = vrService.UserCFrameEnabled,
			callback = callback3
		}),
		VRSessionStateConnection = 0
	}
	local vrSessionStateConnection

	if success then
		vrSessionStateConnection = React.createElement(EventConnection, {
			event = result,
			callback = callback2
		})
	end

	v5.VRSessionStateConnection = vrSessionStateConnection
	return createElement(portal, v4, v5)
end

return PointerOverlay
