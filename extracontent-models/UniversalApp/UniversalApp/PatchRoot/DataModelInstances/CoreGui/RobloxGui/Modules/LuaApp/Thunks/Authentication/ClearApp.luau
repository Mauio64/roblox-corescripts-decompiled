local CoreGui = game:GetService("CoreGui")
local CorePackages = game:GetService("CorePackages")
local Modules = CoreGui.RobloxGui.Modules
local ClearUserSpecificData = require(Modules.LuaApp.Actions.ClearUserSpecificData)
local HttpCanceller = require(CorePackages.Workspace.Packages.Http).NetworkLayers.HttpCanceller
local PerformFetch = require(CorePackages.Workspace.Packages.Http).PerformFetch
local clearSquadStorage = require(CorePackages.Workspace.Packages.SquadsCore.clearSquadStorage)
local HttpStore = nil
local GetFFlagIsSquadEnabled = require(CorePackages.Workspace.Packages.SharedFlags).GetFFlagIsSquadEnabled
local FFlagLuaAppUseAppHttpStore = require(CorePackages.Workspace.Packages.SharedFlags).FFlagLuaAppUseAppHttpStore

if FFlagLuaAppUseAppHttpStore then
	HttpStore = require(CorePackages.Workspace.Packages.HttpStore)
end

return function() -- line: 17
	-- upvalues: GetFFlagIsSquadEnabled (copy), clearSquadStorage (copy), ClearUserSpecificData (copy), HttpCanceller (copy), FFlagLuaAppUseAppHttpStore (copy), HttpStore (ref), PerformFetch (copy)
	return function(p1) -- line: 18
		-- upvalues: GetFFlagIsSquadEnabled (copy), clearSquadStorage (copy), ClearUserSpecificData (copy), HttpCanceller (copy), FFlagLuaAppUseAppHttpStore (copy), HttpStore (ref), PerformFetch (copy)
		if GetFFlagIsSquadEnabled() then
			clearSquadStorage()
		end

		p1:dispatch(ClearUserSpecificData())
		HttpCanceller.cancel()

		if FFlagLuaAppUseAppHttpStore then
			local v12 = HttpStore.Instance.get()

			if v12 then
				v12.cancelAll()
			end
		end

		PerformFetch.ClearOutstandingPromiseStatus()
	end
end
