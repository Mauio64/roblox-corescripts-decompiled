local parent = script.Parent.Parent
local SharedFlags = require(parent.SharedFlags)

local GetFIntMaquettesAppPanelDistanceMultiplierPercentage = SharedFlags.GetFIntMaquettesAppPanelDistanceMultiplierPercentage
local v = SharedFlags.GetFFlagEnableVRChartsTab() and 1 or 0.8

local v2 = GetFIntMaquettesAppPanelDistanceMultiplierPercentage() / 100

return {
	MainScreenResolution = Vector2.new(1120, 900),
	MainScreenSize = Vector2.new(3.15, 2.7) * v2,
	MainScreenCurvature = 0,
	MainScreenPosition = Vector3.new(0, 4.8, -4 * v2),
	AppSystemBarPosition = Vector3.new(-2.35 * v2 * 0.7 + -0.4, 4.8, -3.15 * v2 + -1.28),
	AppSystemBarSize = Vector2.new(0.495, v * 2.7) * v2,
	AppSystemBarResolution = Vector2.new(64, v * 360),
	CentralOverlayPosition = Vector3.new(0, 4.8, -3.5 * v2),
	ToastSize = Vector2.new(2.5, 1.5),
	ToastPosition = Vector3.new(0, 3.3, -2.8),
	ToastResolution = Vector2.new(650, 382),
	ToastCurvature = 50,
	DefaultCameraPosition = Vector3.new(0, 4.8, 0),
	FTUX = { UniverseId = "4510252459", PlaceId = "12887241816" },
	ROUNDED_CORNER_RADIUS = 15,
	PositionLockedPanelName = "PositionLocked"
}
