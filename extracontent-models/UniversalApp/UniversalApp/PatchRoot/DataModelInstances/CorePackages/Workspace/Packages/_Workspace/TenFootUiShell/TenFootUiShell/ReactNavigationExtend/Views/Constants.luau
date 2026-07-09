local Parent = script:FindFirstAncestor("TenFootUiShell").Parent

require(Parent.ReactOtter)

local v2 = require(Parent.Responsive).getVirtualResolutionScale() or 1
local v3 = 1920 / v2
local v4 = 1080 / v2
local v5 = 144 / v2
local v6 = 98 / v2
local v7 = v5 / v4
local v8 = v6 / v4
local v9 = v4 - v5
local v10 = 1 - v7
local t1 = {
	stiffness = 150,
	damping = 20,
	mass = 1
}
local t2 = {
	stiffness = 710,
	damping = 40,
	mass = 1
}

return {
	DEFAULT_SCREEN_DISTANCE_TO_CAMERA = 6,
	DEFAULT_BACKGROUND_DISTANCE_TO_CAMERA = 50,
	Z_DIRECTION_ZOOM_FACTOR = 0.1,
	ADORNEE_DEPTH = 0.01,
	CANVAS_SIZE = Vector2.new(v3, v4),
	TOP_BAR_HEIGHT_RATIO = v7,
	TOP_BAR_CANVAS_SIZE = Vector2.new(v3, v5),
	DEFAULT_CANVAS_SIZE = Vector2.new(v3, v4),
	FULLSCREEN_CANVAS_SIZE = Vector2.new(v3, v4),
	CONTROLLER_BAR_HEIGHT_RATIO = v8,
	CONTROLLER_BAR_CANVAS_SIZE = Vector2.new(v3, v6),
	PAGE_CONTENT_CANVAS_HEIGHT = v9,
	PAGE_CONTENT_HEIGHT_RATIO = v10,
	X_DIRECTION_ANIMATION_SPRING_CONFIG = t1,
	Z_DIRECTION_ANIMATION_SPRING_CONFIG = t2
}
