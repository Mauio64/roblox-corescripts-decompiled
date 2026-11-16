local v5 = {
	SpeedAdjustmentTarget = 0.5,
	CursorRadius = 40,
	SelectionRadius = 40,
	MoveAssistRadius = 80,
	OcclusionRadiusScale = 0.7,
	MaxSpeedRelative = 0.7,
	ThumbstickDeadzone = 0.2,
	ScrollingRadius = 15,
	ScrollingSlowDown = 0.25,
	ScrollingSpeed = 1000,
	MoveAssistExpireTime = 0.5,
	MoveAssistMinInputMagnitude = 0.35
}

setmetatable(v5, {
	__index = function(p2, p3)
		error(string.format("%q is not a valid member of properties", (tostring(p3))), 2)
	end
})

return v5
