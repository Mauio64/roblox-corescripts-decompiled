local useCallback = require("@luauforge/deferred/gXk").useCallback
local useDispatch = require("@luauforge/deferred/gXx").Hooks.RoactRodux.useDispatch
local useRoactService = require("@luauforge/deferred/gXy").useRoactService
local roactNetworking = require("@luauforge/deferred/gXz").RoactNetworking
local appGuiService = require("@luauforge/deferred/gXz").AppGuiService

local module = require("@luauforge/deferred/gXA")
local usePreferredInput = module.usePreferredInput

local logoutReasonNames = require("@luauforge/deferred/gXB").Enums.LogoutReasonNames
local consoleDisconnect = require("@luauforge/deferred/gXB").Thunks.ConsoleDisconnect

local function useLogout(callback)
	local v5 = useDispatch()
	local v6 = useRoactService(roactNetworking)
	local v7 = useRoactService(appGuiService)
	local v8 = usePreferredInput() == module.Input.Directional

	return (useCallback(function()
		if v8 then
			v5(consoleDisconnect(v6, v7, callback))
		else
			v5(callback(v6, v7, logoutReasonNames.AccountLock))
		end
	end, { v5, v6, v7, callback, v8 }))
end

return useLogout
