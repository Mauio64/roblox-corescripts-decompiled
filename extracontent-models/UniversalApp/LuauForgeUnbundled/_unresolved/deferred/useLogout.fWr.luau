local module = require("@luauforge/deferred/fUZ")

local EVENT_TYPES = require("@luauforge/deferred/fUP").Constants.EVENT_TYPES

local useCallback = require("@luauforge/deferred/fUU").useCallback
local useDispatch = require("@luauforge/deferred/fVE").Hooks.RoactRodux.useDispatch
local useRoactService = require("@luauforge/deferred/fVC").useRoactService
local roactNetworking = require("@luauforge/deferred/fVB").RoactNetworking
local appGuiService = require("@luauforge/deferred/fVB").AppGuiService

local module2 = require("@luauforge/deferred/fVD")
local usePreferredInput = module2.usePreferredInput

local logoutReasonNames = require("@luauforge/deferred/fWs").Enums.LogoutReasonNames
local consoleDisconnect = require("@luauforge/deferred/fWs").Thunks.ConsoleDisconnect

local function useLogout(callback, callback2)
	local v5 = useDispatch()
	local v6 = useRoactService(roactNetworking)
	local v7 = useRoactService(appGuiService)
	local v8 = usePreferredInput() == module2.Input.Directional

	return (useCallback(function()
		callback(true)
		module({ eventType = EVENT_TYPES.LogoutClicked })

		if v8 then
			v5(consoleDisconnect(v6, v7, callback2))
		else
			v5(callback2(v6, v7, logoutReasonNames.Moderation))
		end
	end, { v5, v6, v7, callback2, v8, callback }))
end

return useLogout
