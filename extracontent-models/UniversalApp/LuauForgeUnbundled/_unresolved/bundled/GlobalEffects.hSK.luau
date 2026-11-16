local module = require("@luauforge/bundled/hSL")
local setCentralOverlay = require("@luauforge/bundled/hSM").Actions.SetCentralOverlay
local useDispatch = require("@luauforge/bundled/hSN").Hooks.RoactRodux.useDispatch
local useRoactService = require("@luauforge/bundled/hSO").useRoactService
local centralOverlayType = require("@luauforge/bundled/hSP").CentralOverlayType
local module2 = require("@luauforge/bundled/hSQ")
local module3 = require("@luauforge/bundled/hSS")
local useGamepadDisconnectOverlayEffect = require("@luauforge/bundled/hSV").Gamepad.useGamepadDisconnectOverlayEffect

local fFlagMoveGamepadDisconnectHandlerToUniversalApp = require("@luauforge/bundled/hSW").FFlagMoveGamepadDisconnectHandlerToUniversalApp
local appEventIngestService = require("@luauforge/bundled/hSX").AppEventIngestService

local fFlagMoveForceThemeToThemeChangeEventReceiver = require("@luauforge/bundled/hSW").FFlagMoveForceThemeToThemeChangeEventReceiver
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
