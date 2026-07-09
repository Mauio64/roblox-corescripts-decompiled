local ProfileQRCode = script:FindFirstAncestor("ProfileQRCode")
local ProfileQRCodeParent = ProfileQRCode.Parent
local Rodux = require(ProfileQRCodeParent.Rodux)
local createOrGetProfileShareUrl = require(ProfileQRCode.Networking.createOrGetProfileShareUrl)

return Rodux.createReducer({}, {
	[createOrGetProfileShareUrl.Succeeded.name] = function(_: {[any]: any}, t2: {[any]: any}) -- line: 14
		return t2.responseBody
	end
})
