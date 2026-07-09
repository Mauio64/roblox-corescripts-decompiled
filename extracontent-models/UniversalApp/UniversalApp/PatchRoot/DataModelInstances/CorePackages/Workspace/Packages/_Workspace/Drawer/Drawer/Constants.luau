local v1 = game:DefineFastInt("DrawerSwipeVelocityThreshold", 400)
local v2 = game:DefineFastInt("DrawerSwipeThresholdPercent", 30)

return {
	SWIPE_OPEN_EDGE_THRESHOLD = 20,
	SCRIM_TRANSPARENCY = 0.35,
	DRAWER_VELOCITY_THRESHOLD = v1,
	DRAWER_SWIPE_THRESHOLD_PERCENT = v2 / 100,
	DRAWER_ANIM_SETTINGS = {
		duration = 0.3,
		startingValue = nil,
		easingStyle = {
			0.2,
			0,
			0,
			1
		}
	}
}
