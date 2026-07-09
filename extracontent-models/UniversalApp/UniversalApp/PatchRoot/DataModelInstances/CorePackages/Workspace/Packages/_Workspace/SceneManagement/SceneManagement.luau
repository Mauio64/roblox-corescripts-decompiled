local Lighting = require(script.Lighting)
local BackgroundScene = require(script.BackgroundScene)
local useCameraFacingGeometry = require(script.hooks.useCameraFacingGeometry)

return {
	["jest.config"] = script["jest.config"],
	SurfaceGuiWithAdornee = require(script.SurfaceGuiWithAdornee),
	Lighting = Lighting,
	BackgroundScene = BackgroundScene,
	useCameraFacingGeometry = useCameraFacingGeometry
}
