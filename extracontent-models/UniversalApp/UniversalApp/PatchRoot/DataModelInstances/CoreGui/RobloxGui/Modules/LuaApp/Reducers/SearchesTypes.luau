local CoreGui = game:GetService("CoreGui")
local CorePackages = game:GetService("CorePackages")
local Modules = CoreGui.RobloxGui.Modules
local Rodux = require(CorePackages.Packages.Rodux)
local Cryo = require(CorePackages.Packages.Cryo)
local SetSearchType = require(Modules.LuaApp.Actions.SetSearchType)

return Rodux.createReducer({}, {
	[SetSearchType.name] = function(p1, p2) -- line: 13
		-- upvalues: Cryo (copy)
		return Cryo.Dictionary.join(p1, {
			[p2.searchUuid] = p2.searchType
		})
	end
})
