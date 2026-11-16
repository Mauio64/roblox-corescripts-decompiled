local module = require("@luauforge/bundled/iex")
local setCentralOverlay = require("@luauforge/bundled/iey").Actions.SetCentralOverlay
local centralOverlayType = require("@luauforge/bundled/iez").CentralOverlayType
local useDispatch = require("@luauforge/bundled/ieA").Hooks.RoactRodux.useDispatch
local useRoactService = require("@luauforge/bundled/ieB").useRoactService
local appEventIngestService = require("@luauforge/bundled/ieC").AppEventIngestService
local useGamepadDisconnectOverlayEffect = require("@luauforge/bundled/ieD").Gamepad.useGamepadDisconnectOverlayEffect

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
