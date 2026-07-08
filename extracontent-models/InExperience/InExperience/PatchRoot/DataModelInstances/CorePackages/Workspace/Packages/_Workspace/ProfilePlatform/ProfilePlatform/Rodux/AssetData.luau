local ProfilePlatform = script:FindFirstAncestor("ProfilePlatform")
local ProfilePlatformParent = ProfilePlatform.Parent
local Rodux = require(ProfilePlatformParent.Rodux)
local Cryo = require(ProfilePlatformParent.Cryo)
local NetworkingAsset = require(ProfilePlatform.Networking.NetworkingAsset)

return Rodux.createReducer({}, {
	[NetworkingAsset.GetAssetDetails.Succeeded.name] = function(p1, p2) -- line: 27
		-- upvalues: Cryo (copy)
		local responseBody = p2.responseBody
		local str = tostring(responseBody.assetId)

		return Cryo.Dictionary.join(p1, {
			[str] = {
				assetId = responseBody.assetId,
				displayName = responseBody.displayName,
				assetType = responseBody.assetType
			}
		})
	end
})
