local VRService = game:GetService("VRService")

local useCallback = require("@luauforge/deferred/fUU").useCallback

local appLinking = require("@luauforge/deferred/fVB").AppLinking
local useRoactService = require("@luauforge/deferred/fVC").useRoactService

local module = require("@luauforge/deferred/fVD")
local usePreferredInput = module.usePreferredInput

local useDispatch = require("@luauforge/deferred/fVE").Hooks.RoactRodux.useDispatch
local navigateDown = require("@luauforge/deferred/fVx").Thunks.NavigateDown
local appPage = require("@luauforge/deferred/fVw").AppPage
local module2 = require("@luauforge/deferred/fVF")

local fFlagSignalsNavP3Dispatch = require("@luauforge/deferred/fVf").FFlagSignalsNavP3Dispatch

local navigationCommands = if fFlagSignalsNavP3Dispatch then require("@luauforge/deferred/fVz").NavigationCommands else nil

local module3 = require("@luauforge/deferred/fVG")

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
