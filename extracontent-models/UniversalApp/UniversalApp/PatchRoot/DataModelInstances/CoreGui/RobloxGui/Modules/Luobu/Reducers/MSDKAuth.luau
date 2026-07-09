local Modules = game:GetService("CoreGui").RobloxGui.Modules
local CorePackages = game:GetService("CorePackages")
local Cryo = require(CorePackages.Packages.Cryo)
local Rodux = require(CorePackages.Packages.Rodux)
local SetMSDKLoginErrMessageKey = require(Modules.Luobu.Actions.SetMSDKLoginErrMessageKey)
local SetTokenAuthErrMessageKey = require(Modules.Luobu.Actions.SetTokenAuthErrMessageKey)
local SetMSDKLoginInProgress = require(Modules.Luobu.Actions.SetMSDKLoginInProgress)
local SetMSDKLoginOpenId = require(Modules.Luobu.Actions.SetMSDKLoginOpenId)

return Rodux.createReducer({
	MSDKLoginErrMessageKey = nil,
	tokenAuthErrMessageKey = nil,
	loginInProgress = false,
	openId = ""
}, {
	[SetMSDKLoginErrMessageKey.name] = function(p1, t1: {[any]: any}) -- line: 16
		-- upvalues: Cryo (copy)
		return Cryo.Dictionary.join(p1, {
			MSDKLoginErrMessageKey = t1.errMessageKey
		})
	end,
	[SetTokenAuthErrMessageKey.name] = function(p2, t2: {[any]: any}) -- line: 21
		-- upvalues: Cryo (copy)
		return Cryo.Dictionary.join(p2, {
			tokenAuthErrMessageKey = t2.errMessageKey
		})
	end,
	[SetMSDKLoginInProgress.name] = function(p3, t3: {[any]: any}) -- line: 26
		-- upvalues: Cryo (copy)
		return Cryo.Dictionary.join(p3, {
			loginInProgress = t3.loginInProgress
		})
	end,
	[SetMSDKLoginOpenId.name] = function(p4, t4: {[any]: any}) -- line: 31
		-- upvalues: Cryo (copy)
		return Cryo.Dictionary.join(p4, {
			openId = t4.openId
		})
	end
})
