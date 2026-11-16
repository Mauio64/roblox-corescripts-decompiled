local SharedFlags = require("@game/CorePackages/Workspace/Packages/_Workspace/VrCompatibility/SharedFlags")

local getFIntMaquettesAppPanelDistanceMultiplierPercentage = SharedFlags.GetFIntMaquettesAppPanelDistanceMultiplierPercentage
local v5 = SharedFlags.GetFFlagEnableVRChartsTab() and 1 or 0.8

local v6 = getFIntMaquettesAppPanelDistanceMultiplierPercentage() / 100

return {
	MainScreenResolution = Vector2.new(1120, 900),
	MainScreenSize = Vector2.new(3.15, 2.7) * v6,
	MainScreenCurvature = 0,
	MainScreenPosition = Vector3.new(0, 4.8, -4 * v6),
	AppSystemBarPosition = Vector3.new(-2.35 * v6 * 0.7 + -0.4, 4.8, -3.15 * v6 + -1.28),
	AppSystemBarSize = Vector2.new(0.495, v5 * 2.7) * v6,
	AppSystemBarResolution = Vector2.new(64, v5 * 360),
	CentralOverlayPosition = Vector3.new(0, 4.8, -3.5 * v6),
	ToastSize = Vector2.new(2.5, 1.5),
	ToastPosition = Vector3.new(0, 3.3, -2.8),
	ToastResolution = Vector2.new(650, 382),
	ToastCurvature = 50,
	DefaultCameraPosition = Vector3.new(0, 4.8, 0),
	FTUX = { UniverseId = "4510252459", PlaceId = "12887241816" },
	ROUNDED_CORNER_RADIUS = 15,
	PositionLockedPanelName = "PositionLocked"
}
