local CoreGui = game:GetService("CoreGui")
local CorePackages = game:GetService("CorePackages")
local Modules = CoreGui.RobloxGui.Modules
local Rodux = require(CorePackages.Packages.Rodux)
local Cryo = require(CorePackages.Packages.Cryo)
local SetCatalogMetadata = require(Modules.AvatarExperience.Catalog.Actions.SetCatalogMetadata)
local t1 = {
	obtainedCatalogMetadata = false
}

return Rodux.createReducer(t1, {
	[SetCatalogMetadata.name] = function(_, p2) -- line: 25
		-- upvalues: Cryo (copy)
		return Cryo.Dictionary.join({
			obtainedCatalogMetadata = true
		}, p2.metadata)
	end
})
