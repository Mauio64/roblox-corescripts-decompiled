local CorePackages = game:GetService("CorePackages")

local Rodux = require(CorePackages.Packages.Rodux)
local Cryo = require(CorePackages.Packages.Cryo)

local module = require("@luauforge/bundled/dWj")

return Rodux.createReducer({}, {
	[module.name] = function(p2, p3)
		local category = p3.category
		local mapped = Cryo.List.map(p3.items, function(data)
			return {
				id = tostring(data.id),
				type = tostring(data.itemType),
				productId = data.productId,
				encryptedAdTrackingData = data.encryptedAdTrackingData
			}
		end)

		return (Cryo.Dictionary.join(p2, { [category] = mapped }))
	end
})
