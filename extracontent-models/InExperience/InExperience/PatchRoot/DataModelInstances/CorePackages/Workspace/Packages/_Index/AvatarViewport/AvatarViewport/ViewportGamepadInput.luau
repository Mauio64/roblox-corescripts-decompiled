local AvatarViewport = script:FindFirstAncestor("AvatarViewport")
local Constants = require(AvatarViewport.Constants)

local GetFIntAvatarViewportGamepadYawDegreesPerSecond = require(AvatarViewport.Flags.GetFIntAvatarViewportGamepadYawDegreesPerSecond)

local GetFIntAvatarViewportGamepadZoomGestureSpeedPerSecond = require(AvatarViewport.Flags.GetFIntAvatarViewportGamepadZoomGestureSpeedPerSecond)

local function getThumbstickAxis(vector2: Vector2, p: number) -- 2 equivalent calls inferred from this helper
	if vector2.Magnitude < p then
		return 0
	end

	local v = math.abs(math.cos((math.atan2(vector2.Y, vector2.X))) * p)
	return math.max(math.abs(vector2.X) - v, 0) / (1 - v) * math.sign(vector2.X)
end

local function getThumbstickAxisY(vector2: Vector2, p: number) -- 1 equivalent call inferred from this helper
	if vector2.Magnitude < p then
		return 0
	end

	local v = math.abs(math.sin((math.atan2(vector2.Y, vector2.X))) * p)
	return math.max(math.abs(vector2.Y) - v, 0) / (1 - v) * math.sign(vector2.Y)
end

local ViewportGamepadInput = {}
ViewportGamepadInput.getThumbstickAxis = getThumbstickAxis
ViewportGamepadInput.getThumbstickAxisY = getThumbstickAxisY

function ViewportGamepadInput.computeYawDeltaDegrees(vector2: Vector2, p: number, p2: number, p3: number)
	local thumbstickAxis = getThumbstickAxis(vector2, p3) -- inferred equivalent call

	if thumbstickAxis == 0 then
		return 0
	end

	return -thumbstickAxis * p2 * p
end

function ViewportGamepadInput.computeZoomGestureDelta(vector2: Vector2, p: number, p2: number, p3: number, p4: number)
	local thumbstickAxisY = getThumbstickAxisY(vector2, p3) -- inferred equivalent call

	if math.abs(thumbstickAxisY) < p4 then
		return 0
	end

	return thumbstickAxisY * p2 * p
end

function ViewportGamepadInput.isRotating(vector2: Vector2, p: number): boolean
	return getThumbstickAxis(vector2, p) ~= 0 -- inferred equivalent call
end

ViewportGamepadInput.defaultDeadzone = Constants.GamepadThumbstickDeadzone
ViewportGamepadInput.getDefaultYawSpeedDegPerSecond = GetFIntAvatarViewportGamepadYawDegreesPerSecond
ViewportGamepadInput.getDefaultZoomGestureSpeedPerSecond = GetFIntAvatarViewportGamepadZoomGestureSpeedPerSecond
ViewportGamepadInput.defaultZoomAxisThreshold = Constants.GamepadZoomAxisThreshold
return ViewportGamepadInput
