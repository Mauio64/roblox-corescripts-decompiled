local Rodux = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfileQRCode/Rodux")
local configuredUsers = require("@game/CorePackages/Workspace/Packages/_Index/ProfileQRCode/ProfileQRCode/Rodux/configuredUsers")
local configuredRoduxNetworking = require("@game/CorePackages/Workspace/Packages/_Index/ProfileQRCode/ProfileQRCode/Networking/configuredRoduxNetworking")
local ShareUrlReducer = require("@game/CorePackages/Workspace/Packages/_Index/ProfileQRCode/ProfileQRCode/Rodux/ShareUrlReducer")

local FFlagProfileQrCodeDeprecateUserRedux = require("@game/CorePackages/Workspace/Packages/_Index/ProfileQRCode/ProfileQRCode/Flags/FFlagProfileQrCodeDeprecateUserRedux")

return function()
	local combineReducers = Rodux.combineReducers
	local v6 = if not FFlagProfileQrCodeDeprecateUserRedux then configuredUsers() else nil
	return combineReducers({
		Users = v6,
		NetworkStatus = configuredRoduxNetworking.installReducer(),
		ShareUrl = ShareUrlReducer
	})
end
