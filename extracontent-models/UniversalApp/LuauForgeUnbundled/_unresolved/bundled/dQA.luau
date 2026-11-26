local CorePackages = game:GetService("CorePackages")

local Rodux = require(CorePackages.Packages.Rodux)

local module = require("@luauforge/bundled/dQB")

local CollectibleResellableInstances = require("@game/CoreGui/RobloxGui/Modules/InspectAndBuy/Reducers/CollectibleResellableInstances")

local module3 = require("@luauforge/bundled/dQK")
local module4 = require("@luauforge/bundled/dQN")

return Rodux.combineReducers({
	CollectiblesItemInfo = module,
	CollectiblesResellableInstances = CollectibleResellableInstances,
	CollectiblesMarketplaceResaleParameters = module3,
	CollectiblesResellersInstances = module4
})
