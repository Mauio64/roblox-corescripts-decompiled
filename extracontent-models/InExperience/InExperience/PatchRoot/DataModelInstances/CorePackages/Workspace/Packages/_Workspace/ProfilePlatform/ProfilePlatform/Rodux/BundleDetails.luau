local ProfilePlatform = script:FindFirstAncestor("ProfilePlatform")
local ProfilePlatformParent = ProfilePlatform.Parent
local Rodux = require(ProfilePlatformParent.Rodux)
local Cryo = require(ProfilePlatformParent.Cryo)
local NetworkingCatalog = require(ProfilePlatform.Networking.NetworkingCatalog)
local AssetInfo = require(ProfilePlatform.Common.AssetInfo)
local Enums = require(ProfilePlatform.Common.Enums)

return Rodux.createReducer({}, {
	[NetworkingCatalog.GetItemAndBundleDetails.Succeeded.name] = function(p1, p2) -- line: 23
		-- upvalues: Enums (copy), AssetInfo (copy), Cryo (copy)
		local t1 = {}

		for _, v12 in p2.responseBody.data do
			if v12.itemType == Enums.ItemTypes.Bundle then
				local v13 = AssetInfo.fromAsset(v12)

				t1[v13.id] = v13
			end
		end

		return Cryo.Dictionary.union(p1, t1)
	end
})
