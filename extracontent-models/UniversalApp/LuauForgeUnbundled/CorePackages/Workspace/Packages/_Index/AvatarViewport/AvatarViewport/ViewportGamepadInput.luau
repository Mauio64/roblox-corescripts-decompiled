local Constants = require("@game/CorePackages/Workspace/Packages/_Index/AvatarViewport/AvatarViewport/Constants")

local GetFIntAvatarViewportGamepadYawDegreesPerSecond = require("@game/CorePackages/Workspace/Packages/_Index/AvatarViewport/AvatarViewport/Flags/GetFIntAvatarViewportGamepadYawDegreesPerSecond")

local GetFIntAvatarViewportGamepadZoomGestureSpeedPerSecond = require("@game/CorePackages/Workspace/Packages/_Index/AvatarViewport/AvatarViewport/Flags/GetFIntAvatarViewportGamepadZoomGestureSpeedPerSecond")

return {
	getThumbstickAxis = function(data, p2)
		if data.Magnitude < p2 then
			return 0
		end

		local v5 = math.abs(math.cos((math.atan2(data.Y, data.X))) * p2)
		return math.max(math.abs(data.X) - v5, 0) / (1 - v5) * math.sign(data.X)
	end,
	getThumbstickAxisY = function(data, p2)
		if data.Magnitude < p2 then
			return 0
		end

		local v5 = math.abs(math.sin((math.atan2(data.Y, data.X))) * p2)
		return math.max(math.abs(data.Y) - v5, 0) / (1 - v5) * math.sign(data.Y)
	end,
	computeYawDeltaDegrees = function(data, p2, p3, p4)
		local v5

		if data.Magnitude < p4 then
			v5 = 0
		else
			local v6 = math.abs(math.cos((math.atan2(data.Y, data.X))) * p4)
			v5 = math.max(math.abs(data.X) - v6, 0) / (1 - v6) * math.sign(data.X)
		end

		if v5 == 0 then
			return 0
		end

		return -v5 * p3 * p2
	end,
	computeZoomGestureDelta = function(data, p2, p3, p4, p5)
		local v5

		if data.Magnitude < p4 then
			v5 = 0
		else
			local v6 = math.abs(math.sin((math.atan2(data.Y, data.X))) * p4)
			v5 = math.max(math.abs(data.Y) - v6, 0) / (1 - v6) * math.sign(data.Y)
		end

		if math.abs(v5) < p5 then
			return 0
		end

		return v5 * p3 * p2
	end,
	isRotating = function(data, p2): boolean
		local v5

		if data.Magnitude < p2 then
			v5 = 0
		else
			local v6 = math.abs(math.cos((math.atan2(data.Y, data.X))) * p2)
			v5 = math.max(math.abs(data.X) - v6, 0) / (1 - v6) * math.sign(data.X)
		end

		return v5 ~= 0
	end,
	defaultDeadzone = Constants.GamepadThumbstickDeadzone,
	getDefaultYawSpeedDegPerSecond = GetFIntAvatarViewportGamepadYawDegreesPerSecond,
	getDefaultZoomGestureSpeedPerSecond = GetFIntAvatarViewportGamepadZoomGestureSpeedPerSecond,
	defaultZoomAxisThreshold = Constants.GamepadZoomAxisThreshold
}
