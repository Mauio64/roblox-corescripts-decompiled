local ProfileQRCode = script:FindFirstAncestor("ProfileQRCode")
local parent = ProfileQRCode.Parent
local Rodux = require(parent.Rodux)
local createOrGetProfileShareUrl = require(ProfileQRCode.Networking.createOrGetProfileShareUrl)

return Rodux.createReducer({}, {
	[createOrGetProfileShareUrl.Succeeded.name] = function(_, p)
		return p.responseBody
	end
})
