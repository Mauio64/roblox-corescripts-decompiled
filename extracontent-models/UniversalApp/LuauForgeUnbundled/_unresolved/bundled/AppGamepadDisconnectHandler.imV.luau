local module = require("@luauforge/bundled/imW")
local setCentralOverlay = require("@luauforge/bundled/imX").Actions.SetCentralOverlay
local centralOverlayType = require("@luauforge/bundled/imY").CentralOverlayType
local useDispatch = require("@luauforge/bundled/imZ").Hooks.RoactRodux.useDispatch
local useRoactService = require("@luauforge/bundled/ina").useRoactService
local appEventIngestService = require("@luauforge/bundled/inb").AppEventIngestService
local useGamepadDisconnectOverlayEffect = require("@luauforge/bundled/inc").Gamepad.useGamepadDisconnectOverlayEffect

local function AppGamepadDisconnectHandler(): nil
	local v5 = useDispatch()
	useGamepadDisconnectOverlayEffect(module.useCallback(function()
		v5(setCentralOverlay(centralOverlayType.GamepadDisconnected))
	end, { v5 }), module.useCallback(function()
		v5(setCentralOverlay())
	end, { v5 }), useRoactService(appEventIngestService), "InApp")
	return nil
end

return AppGamepadDisconnectHandler
