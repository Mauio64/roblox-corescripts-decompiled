local ParentParent = script.Parent.Parent
local SharedFlags = require(ParentParent.SharedFlags)
local GetFIntMaquettesAppPanelDistanceMultiplierPercentage = SharedFlags.GetFIntMaquettesAppPanelDistanceMultiplierPercentage
local FFlagLuaAppForceVrAppPanelWidthRollout = SharedFlags.FFlagLuaAppForceVrAppPanelWidthRollout
local v5 = not SharedFlags.GetFFlagEnableVRChartsTab() and 0.8 or 1
local v6 = GetFIntMaquettesAppPanelDistanceMultiplierPercentage() / 100

return {
	ToastPosition = Vector3.new(0, 3.299999952316284, -2.799999952316284),
	ToastCurvature = 50,
	DefaultCameraPosition = Vector3.new(0, 4.800000190734863, 0),
	ROUNDED_CORNER_RADIUS = 15,
	PositionLockedPanelName = "PositionLocked",
	MainScreenResolution = if not FFlagLuaAppForceVrAppPanelWidthRollout then Vector2.new(1600, 900) else Vector2.new(1120, 900),
	MainScreenSize = if not FFlagLuaAppForceVrAppPanelWidthRollout then Vector2.new(4.5, 2.7) * v6 else Vector2.new(3.15, 2.7) * v6,
	MainScreenCurvature = not FFlagLuaAppForceVrAppPanelWidthRollout and 70 or 0,
	MainScreenPosition = Vector3.new(0, 4.8, -4 * v6),
	AppSystemBarPosition = if not FFlagLuaAppForceVrAppPanelWidthRollout then Vector3.new(-2.35 * v6, 4.8, -3.15 * v6) else Vector3.new(-2.35 * v6 * 0.7 + -0.4, 4.8, -3.15 * v6 + -1.28),
	AppSystemBarSize = if not FFlagLuaAppForceVrAppPanelWidthRollout then Vector2.new(0.495, 2.7) * v6 else Vector2.new(0.495, v5 * 2.7) * v6,
	AppSystemBarResolution = if not FFlagLuaAppForceVrAppPanelWidthRollout then Vector2.new(64, 360) else Vector2.new(64, v5 * 360),
	CentralOverlayPosition = Vector3.new(0, 4.8, -3.5 * v6),
	ToastSize = Vector2.new(2.5, 1.5),
	ToastResolution = Vector2.new(650, 382),
	FTUX = {
		UniverseId = "4510252459",
		PlaceId = "12887241816"
	}
}
