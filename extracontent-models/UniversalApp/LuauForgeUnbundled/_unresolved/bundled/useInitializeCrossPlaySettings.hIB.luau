local module = require("@luauforge/bundled/hIC")
local module2 = require("@luauforge/bundled/hHX")
local useSelector = require("@luauforge/bundled/hHZ").Hooks.RoactRodux.useSelector
local useSignalState = require("@luauforge/bundled/hID").useSignalState
local loginStatus = require("@luauforge/bundled/hIE").LoginStatus

local fFlagUseSignalsForAuthenticationStatus = require("@luauforge/bundled/hIF").FFlagUseSignalsForAuthenticationStatus
local getAuthenticationStatusStore

if fFlagUseSignalsForAuthenticationStatus then
	getAuthenticationStatusStore = require("@luauforge/bundled/hIG").GetAuthenticationStatusStore
else
	getAuthenticationStatusStore = nil
end

local module3 = require("@luauforge/bundled/hIa")
local ThirdPartyUserService = game:GetService("ThirdPartyUserService")
local useProperty = require("@luauforge/bundled/hIH").useProperty

local fFlagUseSignalsForStartup = require("@luauforge/bundled/hIF").FFlagUseSignalsForStartup

local getStartupStore = if fFlagUseSignalsForStartup then require("@luauforge/bundled/hII").GetStartupStore else nil

local function useInitializeCrossPlaySettings()
	local v5 = module3()

	local v6 = useSelector(function(p2)
		local v7 = {
			authenticationStatus = p2.AuthenticationStatus.status,
			preloading = 0
		}
		local v8 = if not fFlagUseSignalsForStartup then p2.Startup.Preloading else nil
		v7.preloading = v8
		return v7
	end)
	local v7

	if fFlagUseSignalsForAuthenticationStatus then
		v7 = useSignalState(getAuthenticationStatusStore(false).getStatus)
	else
		v7 = v6.authenticationStatus
	end

	local state, setState = module2.useState(false)
	local v8

	if fFlagUseSignalsForStartup then
		v8 = useSignalState(getStartupStore(false).getPreloading)
	else
		v8 = v6.preloading
	end

	local v9 = useProperty(ThirdPartyUserService, "HasActiveUser") and v7 == loginStatus.LOGGED_IN

	module2.useEffect(function()
		if v9 == state then
			return
		end

		if v9 and v8 then
			v5.fetch()
		elseif not v9 then
			v5.reset()
		end

		setState(v9)
	end, { v5, v9, state, v8 })

	module2.useEffect(function()
		local onBecomeActiveConnection = module.OnBecomeActive:connect(function()
			v5.fetch()
		end)

		return function()
			onBecomeActiveConnection:disconnect()
		end
	end, { v5 })
end

return useInitializeCrossPlaySettings
