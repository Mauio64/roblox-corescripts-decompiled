local CoreGui = game:GetService("CoreGui")
local CorePackages = game:GetService("CorePackages")
local Modules = CoreGui.RobloxGui.Modules
local Rodux = require(CorePackages.Packages.Rodux)
local Cryo = require(CorePackages.Packages.Cryo)
local SetSponsoredItems = require(Modules.AvatarExperience.Catalog.Actions.SetSponsoredItems)

return Rodux.createReducer({}, {
	[SetSponsoredItems.name] = function(t1: {[any]: any}, p1) -- line: 29
		-- upvalues: Cryo (copy)
		local category = p1.category
		local v10 = Cryo.List.map(p1.items, function(p2) -- line: 31
			return {
				id = tostring(p2.id),
				type = tostring(p2.itemType),
				productId = p2.productId,
				encryptedAdTrackingData = p2.encryptedAdTrackingData
			}
		end)

		return (Cryo.Dictionary.join(t1, {
			[category] = v10
		}))
	end
})
