local ProfilePlatform = script:FindFirstAncestor("ProfilePlatform")
local parent = ProfilePlatform.Parent
local Rodux = require(parent.Rodux)
local Cryo = require(parent.Cryo)
local NetworkingCurrentlyWearing = require(ProfilePlatform.Networking.NetworkingCurrentlyWearing)
local AssetInfo = require(ProfilePlatform.Common.AssetInfo)

return Rodux.createReducer({}, {
	[NetworkingCurrentlyWearing.GetItemDetails.Succeeded.name] = function(p, p2)
		local v = {}

		for _, v2 in p2.responseBody.data do
			local v3 = AssetInfo.fromAsset(v2)
			v[v3.id] = v3
		end

		return Cryo.Dictionary.join(p, v)
	end
})
