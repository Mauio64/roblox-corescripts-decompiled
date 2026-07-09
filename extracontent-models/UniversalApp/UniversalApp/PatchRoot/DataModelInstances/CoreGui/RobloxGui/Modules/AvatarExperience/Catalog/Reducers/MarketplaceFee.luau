local CoreGui = game:GetService("CoreGui")
local CorePackages = game:GetService("CorePackages")
local Modules = CoreGui.RobloxGui.Modules
local Cryo = require(CorePackages.Packages.Cryo)
local MarketplaceFeeInfo = require(Modules.AvatarExperience.Common.Models.MarketplaceFeeInfo)
local Rodux = require(CorePackages.Packages.Rodux)
local SetMarketplaceFee = require(Modules.AvatarExperience.Catalog.Actions.SetMarketplaceFee)

return Rodux.createReducer({}, {
	[SetMarketplaceFee.name] = function(p1, p2) -- line: 18
		-- upvalues: MarketplaceFeeInfo (copy), Cryo (copy)
		local v10 = MarketplaceFeeInfo.fromGetResaleTaxRate(p2.marketplaceFeeInfo)

		return Cryo.Dictionary.join(p1, v10)
	end
})
