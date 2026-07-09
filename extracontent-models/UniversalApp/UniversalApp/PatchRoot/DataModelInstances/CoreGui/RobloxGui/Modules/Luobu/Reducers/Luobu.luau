local Modules = game:GetService("CoreGui").RobloxGui.Modules
local CorePackages = game:GetService("CorePackages")
local Rodux = require(CorePackages.Packages.Rodux)
local TencentAuthInfo = require(Modules.Luobu.Reducers.TencentAuthInfo)
local TencentNotice = require(Modules.Luobu.Reducers.TencentNotice)
local TencentNoticeReadStatus = require(Modules.Luobu.Reducers.TencentNoticeReadStatus)
local MSDKAuth = require(Modules.Luobu.Reducers.MSDKAuth)
local SignUp = require(Modules.Luobu.Reducers.SignUp)

return Rodux.combineReducers({
	TencentAuthInfo = TencentAuthInfo,
	TencentNotice = TencentNotice,
	TencentNoticeReadStatus = TencentNoticeReadStatus,
	MSDKAuth = MSDKAuth,
	SignUp = SignUp
})
