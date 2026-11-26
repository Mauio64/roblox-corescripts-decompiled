local VRService = game:GetService("VRService")

local useCallback = require("@luauforge/deferred/gzS").useCallback

local appLinking = require("@luauforge/deferred/gAz").AppLinking
local useRoactService = require("@luauforge/deferred/gAA").useRoactService

local module = require("@luauforge/deferred/gAB")
local usePreferredInput = module.usePreferredInput

local useDispatch = require("@luauforge/deferred/gAC").Hooks.RoactRodux.useDispatch
local navigateDown = require("@luauforge/deferred/gAv").Thunks.NavigateDown
local appPage = require("@luauforge/deferred/gAu").AppPage
local module2 = require("@luauforge/deferred/gAD")

local fFlagSignalsNavP3Dispatch = require("@luauforge/deferred/gAd").FFlagSignalsNavP3Dispatch

local navigationCommands = if fFlagSignalsNavP3Dispatch then require("@luauforge/deferred/gAx").NavigationCommands else nil

local module3 = require("@luauforge/deferred/gAE")

local function useOpenLink(p2, p3)
	local v5 = useDispatch()
	local v6 = useRoactService(appLinking)
	local v7 = usePreferredInput() == module.Input.Directional
	local v8 = if module3 then module2(p2, p3) else nil

	return (useCallback(function()
		if v7 or VRService.VREnabled then
			v6:openURL(p2)
			return
		end

		if module3 and v8 then
			v8()
			return
		end

		local v9 = {
			name = appPage.GenericWebPage,
			detail = p2,
			extraProps = { title = p3 }
		}

		if fFlagSignalsNavP3Dispatch then
			navigationCommands.down(navigationCommands.fromLegacyPage(v9))
		else
			v5(navigateDown(v9))
		end
	end, { p2, p3, v5, v7, v6, v8 }))
end

return useOpenLink
