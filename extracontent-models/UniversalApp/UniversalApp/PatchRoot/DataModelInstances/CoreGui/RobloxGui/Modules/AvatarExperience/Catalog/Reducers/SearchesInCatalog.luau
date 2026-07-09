local CoreGui = game:GetService("CoreGui")
local CorePackages = game:GetService("CorePackages")
local Modules = CoreGui.RobloxGui.Modules
local Cryo = require(CorePackages.Packages.Cryo)
local Rodux = require(CorePackages.Packages.Rodux)
local AppendSearchInCatalog = require(Modules.AvatarExperience.Catalog.Actions.AppendSearchInCatalog)
local RemoveSearchInCatalog = require(Modules.AvatarExperience.Catalog.Actions.RemoveSearchInCatalog)
local SetSearchInCatalog = require(Modules.AvatarExperience.Catalog.Actions.SetSearchInCatalog)

return Rodux.createReducer({}, {
	[AppendSearchInCatalog.name] = function(p1, p2) -- line: 23
		-- upvalues: Cryo (copy)
		local v11 = p1[p2.searchUuid]

		if not v11 then
			return Cryo.Dictionary.join(p1, {
				[p2.searchUuid] = p2.searchInCatalog
			})
		end

		local items = v11.items
		local v13 = Cryo.List.join(items, p2.searchInCatalog.items)

		p2.searchInCatalog.items = v13

		return Cryo.Dictionary.join(p1, {
			[p2.searchUuid] = p2.searchInCatalog
		})
	end,
	[RemoveSearchInCatalog.name] = function(p3, p4) -- line: 40
		-- upvalues: Cryo (copy)
		return Cryo.Dictionary.join(p3, {
			[p4.searchUuid] = Cryo.None
		})
	end,
	[SetSearchInCatalog.name] = function(p5, p6) -- line: 46
		-- upvalues: Cryo (copy)
		return Cryo.Dictionary.join(p5, {
			[p6.searchUuid] = p6.searchInCatalog
		})
	end
})
