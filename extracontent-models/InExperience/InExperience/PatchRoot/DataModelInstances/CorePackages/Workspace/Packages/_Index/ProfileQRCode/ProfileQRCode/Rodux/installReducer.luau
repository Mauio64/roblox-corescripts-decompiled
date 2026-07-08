local ProfileQRCode = script:FindFirstAncestor("ProfileQRCode")
local ProfileQRCodeParent = ProfileQRCode.Parent
local Rodux = require(ProfileQRCodeParent.Rodux)
local configuredUsers = require(script.Parent.configuredUsers)
local configuredRoduxNetworking = require(ProfileQRCode.Networking.configuredRoduxNetworking)
local ShareUrlReducer = require(script.Parent.ShareUrlReducer)

return function() -- line: 14
	-- upvalues: Rodux (copy), configuredUsers (copy), configuredRoduxNetworking (copy), ShareUrlReducer (copy)
	return Rodux.combineReducers({
		Users = configuredUsers(),
		NetworkStatus = configuredRoduxNetworking.installReducer(),
		ShareUrl = ShareUrlReducer
	})
end
