local ProfilePlatform = script:FindFirstAncestor("ProfilePlatform")
local parent = ProfilePlatform.Parent
local Rodux = require(parent.Rodux)
local Cryo = require(parent.Cryo)
local NetworkingCatalog = require(ProfilePlatform.Networking.NetworkingCatalog)
local AssetInfo = require(ProfilePlatform.Common.AssetInfo)
local Enums = require(ProfilePlatform.Common.Enums)

return Rodux.createReducer({}, {
	[NetworkingCatalog.GetItemAndBundleDetails.Succeeded.name] = function(p, p2)
		local v = {}

		for _, v2 in p2.responseBody.data do
			if v2.itemType ~= Enums.ItemTypes.Bundle then
				continue
			end

			local v3 = AssetInfo.fromAsset(v2)
			v[v3.id] = v3
		end

		return Cryo.Dictionary.union(p, v)
	end
})
