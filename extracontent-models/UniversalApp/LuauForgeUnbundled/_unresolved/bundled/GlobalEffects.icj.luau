local module = require("@luauforge/bundled/ick")
local setCentralOverlay = require("@luauforge/bundled/icl").Actions.SetCentralOverlay
local useDispatch = require("@luauforge/bundled/icm").Hooks.RoactRodux.useDispatch
local useRoactService = require("@luauforge/bundled/icn").useRoactService
local centralOverlayType = require("@luauforge/bundled/ico").CentralOverlayType
local module2 = require("@luauforge/bundled/icp")
local module3 = require("@luauforge/bundled/icr")
local useGamepadDisconnectOverlayEffect = require("@luauforge/bundled/icu").Gamepad.useGamepadDisconnectOverlayEffect

local fFlagMoveGamepadDisconnectHandlerToUniversalApp = require("@luauforge/bundled/icv").FFlagMoveGamepadDisconnectHandlerToUniversalApp
local appEventIngestService = require("@luauforge/bundled/icw").AppEventIngestService

local fFlagMoveForceThemeToThemeChangeEventReceiver = require("@luauforge/bundled/icv").FFlagMoveForceThemeToThemeChangeEventReceiver
local defineFastFlag = game:DefineFastFlag("CleanupTenFootUiCursorEffect", false)

local function useAppGamepadDisconnectListener()
	local v5 = useDispatch()

	local v6 = module.useCallback(function()
		v5(setCentralOverlay())
	end, { v5 })

	useGamepadDisconnectOverlayEffect(module.useCallback(function()
		v5(setCentralOverlay(centralOverlayType.GamepadDisconnected))
	end, { v5 }), v6, useRoactService(appEventIngestService), "InApp")
end

local function GlobalEffects(p2)
	if not fFlagMoveForceThemeToThemeChangeEventReceiver then
		module3()
	end

	if not defineFastFlag then
		module2()
	end

	if not fFlagMoveGamepadDisconnectHandlerToUniversalApp then
		useAppGamepadDisconnectListener()
	end

	return module.createElement(module.Fragment, nil, p2.children)
end

return GlobalEffects
