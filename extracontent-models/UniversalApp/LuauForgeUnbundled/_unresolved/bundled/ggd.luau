local module = require("@luauforge/bundled/ciD")
local httpCanceller = require("@game/CorePackages/Workspace/Packages/Http").NetworkLayers.HttpCanceller
local performFetch = require("@game/CorePackages/Workspace/Packages/Http").PerformFetch
local module2 = require("@luauforge/bundled/gge")

local getFFlagIsSquadEnabled = require("@game/CorePackages/Workspace/Packages/SharedFlags").GetFFlagIsSquadEnabled

local fFlagLuaAppUseAppHttpStore = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagLuaAppUseAppHttpStore

local v5 = if fFlagLuaAppUseAppHttpStore then require("@luauforge/bundled/ggg") else nil

return function()
	return function(object)
		if getFFlagIsSquadEnabled() then
			module2()
		end

		object:dispatch(module())
		httpCanceller.cancel()

		local v6 = fFlagLuaAppUseAppHttpStore and v5.Instance.get()

		if v6 then
			v6.cancelAll()
		end

		performFetch.ClearOutstandingPromiseStatus()
	end
end
