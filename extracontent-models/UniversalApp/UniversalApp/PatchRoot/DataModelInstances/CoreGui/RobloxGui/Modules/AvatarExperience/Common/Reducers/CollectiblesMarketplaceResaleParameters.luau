local CorePackages = game:GetService("CorePackages")
local Modules = game:GetService("CoreGui").RobloxGui.Modules
local Cryo = require(CorePackages.Packages.Cryo)
local Rodux = require(CorePackages.Packages.Rodux)
local ArgCheck = require(CorePackages.Workspace.Packages.ArgCheck)
local SetCollectibleMarketplaceResaleParameters = require(Modules.AvatarExperience.Catalog.Actions.SetCollectibleMarketplaceResaleParameters)
local CollectibleMarketplaceResaleParametersInfo = require(Modules.AvatarExperience.Common.Models.CollectibleMarketplaceResaleParametersInfo)

return Rodux.createReducer({}, {
	[SetCollectibleMarketplaceResaleParameters.name] = function(p1, p2) -- line: 39
		-- upvalues: ArgCheck (copy), CollectibleMarketplaceResaleParametersInfo (copy), Cryo (copy)
		ArgCheck.isType(p2.collectibleItemId, "string", "collectibleItemId must be a string.")
		ArgCheck.isType(p2.resaleParametersInfo, "table", "resaleParametersInfo must be a table.")

		local collectibleItemId = p2.collectibleItemId
		local v11 = CollectibleMarketplaceResaleParametersInfo.fromGetCollectibleMarketplaceResaleParameters(p2.resaleParametersInfo, p2.itemSubTypeNameString)
		local v12 = p1[collectibleItemId]

		if v12 then
			local v13 = Cryo.Dictionary.join(v12, v11)

			return (Cryo.Dictionary.join(p1, {
				[collectibleItemId] = v13
			}))
		end

		return (Cryo.Dictionary.join(p1, {
			[collectibleItemId] = v11
		}))
	end
})
