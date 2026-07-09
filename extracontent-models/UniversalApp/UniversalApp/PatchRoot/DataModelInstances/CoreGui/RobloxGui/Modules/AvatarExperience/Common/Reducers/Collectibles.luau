local CorePackages = game:GetService("CorePackages")
local Modules = game:GetService("CoreGui").RobloxGui.Modules
local Rodux = require(CorePackages.Packages.Rodux)
local CollectiblesItemInfo = require(Modules.AvatarExperience.Common.Reducers.CollectiblesItemInfo)
local CollectiblesResellableInstances = require(Modules.AvatarExperience.Common.Reducers.CollectiblesResellableInstances)
local CollectiblesMarketplaceResaleParameters = require(Modules.AvatarExperience.Common.Reducers.CollectiblesMarketplaceResaleParameters)
local CollectiblesResellersInstances = require(Modules.AvatarExperience.Common.Reducers.CollectiblesResellersInstances)

return Rodux.combineReducers({
	CollectiblesItemInfo = CollectiblesItemInfo,
	CollectiblesResellableInstances = CollectiblesResellableInstances,
	CollectiblesMarketplaceResaleParameters = CollectiblesMarketplaceResaleParameters,
	CollectiblesResellersInstances = CollectiblesResellersInstances
})
