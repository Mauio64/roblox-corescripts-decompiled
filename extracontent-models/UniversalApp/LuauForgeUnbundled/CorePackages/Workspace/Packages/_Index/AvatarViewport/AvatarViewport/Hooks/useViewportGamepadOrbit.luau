local ContextActionService = game:GetService("ContextActionService")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

local React = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarViewport/React")

local Constants = require("@game/CorePackages/Workspace/Packages/_Index/AvatarViewport/AvatarViewport/Constants")
local ViewportGamepadInput = require("@game/CorePackages/Workspace/Packages/_Index/AvatarViewport/AvatarViewport/ViewportGamepadInput")

local function useViewportGamepadOrbit(data)
	local v5 = data.enabled == nil or data.enabled
	local actionName = data.actionName or Constants.GamepadOrbitActionName
	local thumbstickDeadzone = data.thumbstickDeadzone or ViewportGamepadInput.defaultDeadzone
	local yawSpeedDegPerSecond = data.yawSpeedDegPerSecond or ViewportGamepadInput.getDefaultYawSpeedDegPerSecond()
	local zoomGestureSpeedPerSecond = data.zoomGestureSpeedPerSecond
		or ViewportGamepadInput.getDefaultZoomGestureSpeedPerSecond()
	local zoomAxisThreshold = data.zoomAxisThreshold or ViewportGamepadInput.defaultZoomAxisThreshold
	local thumbstickKeyCode = data.thumbstickKeyCode or Enum.KeyCode.Thumbstick2

	local ref = React.useRef(false)
	local ref2 = React.useRef(false)
	local ref3 = React.useRef(data.applyYawDelta)
	local ref4 = React.useRef(data.applyZoomGesture)
	local ref5 = React.useRef(data.onOrbitEnded)
	ref3.current = data.applyYawDelta
	ref4.current = data.applyZoomGesture
	ref5.current = data.onOrbitEnded

	React.useEffect(function()
		if not (v5 and UserInputService.GamepadEnabled) then
			return
		end

		local v6 = Vector2.zero

		ContextActionService:UnbindCoreAction(actionName)
		ContextActionService:BindCoreAction(actionName, function(p2, p3, p4)
			if p3 == Enum.UserInputState.Change then
				v6 = Vector2.new(p4.Position.X, p4.Position.Y)
				ref.current = ViewportGamepadInput.isRotating(v6, thumbstickDeadzone)

				if ref.current then
					ref2.current = true
				elseif zoomAxisThreshold < math.abs(v6.Y) then
					ref2.current = true
				end
			elseif p3 == Enum.UserInputState.End or p3 == Enum.UserInputState.Cancel then
				v6 = Vector2.zero
				ref.current = false

				if ref2.current and ref5.current then
					ref5.current()
				end

				ref2.current = false
			end

			return Enum.ContextActionResult.Sink
		end, false, thumbstickKeyCode)

		local renderSteppedConnection = RunService.RenderStepped:Connect(function(dt)
			local yawDeltaDegrees = ViewportGamepadInput.computeYawDeltaDegrees(
				v6,
				dt,
				yawSpeedDegPerSecond,
				thumbstickDeadzone
			)

			if yawDeltaDegrees ~= 0 and ref3.current then
				ref3.current(yawDeltaDegrees)
			end

			local zoomGestureDelta = ViewportGamepadInput.computeZoomGestureDelta(
				v6,
				dt,
				zoomGestureSpeedPerSecond,
				thumbstickDeadzone,
				zoomAxisThreshold
			)

			if zoomGestureDelta ~= 0 and ref4.current then
				ref4.current(zoomGestureDelta)
			end
		end)

		return function()
			ContextActionService:UnbindCoreAction(actionName)
			renderSteppedConnection:Disconnect()
			v6 = Vector2.zero
			ref.current = false
			ref2.current = false
		end
	end, {
		v5,
		actionName,
		thumbstickDeadzone,
		yawSpeedDegPerSecond,
		zoomGestureSpeedPerSecond,
		zoomAxisThreshold,
		thumbstickKeyCode
	})
end

return useViewportGamepadOrbit
