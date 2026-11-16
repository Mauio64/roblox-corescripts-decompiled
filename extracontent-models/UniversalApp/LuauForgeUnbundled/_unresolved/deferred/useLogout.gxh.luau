local useCallback = require("@luauforge/deferred/gwV").useCallback
local useDispatch = require("@luauforge/deferred/gxi").Hooks.RoactRodux.useDispatch
local useRoactService = require("@luauforge/deferred/gxj").useRoactService
local roactNetworking = require("@luauforge/deferred/gxk").RoactNetworking
local appGuiService = require("@luauforge/deferred/gxk").AppGuiService

local module = require("@luauforge/deferred/gxl")
local usePreferredInput = module.usePreferredInput

local logoutReasonNames = require("@luauforge/deferred/gxm").Enums.LogoutReasonNames
local consoleDisconnect = require("@luauforge/deferred/gxm").Thunks.ConsoleDisconnect

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
