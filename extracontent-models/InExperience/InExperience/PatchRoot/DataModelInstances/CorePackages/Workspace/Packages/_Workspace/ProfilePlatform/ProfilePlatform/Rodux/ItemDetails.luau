local ProfilePlatform = script:FindFirstAncestor("ProfilePlatform")
local ProfilePlatformParent = ProfilePlatform.Parent
local Rodux = require(ProfilePlatformParent.Rodux)
local Cryo = require(ProfilePlatformParent.Cryo)
local NetworkingCurrentlyWearing = require(ProfilePlatform.Networking.NetworkingCurrentlyWearing)
local AssetInfo = require(ProfilePlatform.Common.AssetInfo)

return Rodux.createReducer({}, {
	[NetworkingCurrentlyWearing.GetItemDetails.Succeeded.name] = function(p1, p2) -- line: 23
		-- upvalues: AssetInfo (copy), Cryo (copy)
		local t1 = {}

		for _, v11 in p2.responseBody.data do
			local v12 = AssetInfo.fromAsset(v11)

			t1[v12.id] = v12
		end

		return Cryo.Dictionary.join(p1, t1)
	end
})
