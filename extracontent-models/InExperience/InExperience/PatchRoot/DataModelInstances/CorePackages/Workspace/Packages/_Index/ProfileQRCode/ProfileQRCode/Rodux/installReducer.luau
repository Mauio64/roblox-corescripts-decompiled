local ProfileQRCode = script:FindFirstAncestor("ProfileQRCode")
local parent = ProfileQRCode.Parent
local Rodux = require(parent.Rodux)
local configuredUsers = require(script.Parent.configuredUsers)
local configuredRoduxNetworking = require(ProfileQRCode.Networking.configuredRoduxNetworking)
local ShareUrlReducer = require(script.Parent.ShareUrlReducer)

local FFlagProfileQrCodeDeprecateUserRedux = require(ProfileQRCode.Flags.FFlagProfileQrCodeDeprecateUserRedux)

return function()
	local combineReducers = Rodux.combineReducers
	local users

	if not FFlagProfileQrCodeDeprecateUserRedux then
		users = configuredUsers()
	end

	return combineReducers({
		Users = users,
		NetworkStatus = configuredRoduxNetworking.installReducer(),
		ShareUrl = ShareUrlReducer
	})
end
