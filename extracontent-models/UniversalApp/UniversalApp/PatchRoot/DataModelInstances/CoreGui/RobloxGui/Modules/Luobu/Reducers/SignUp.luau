local Modules = game:GetService("CoreGui").RobloxGui.Modules
local CorePackages = game:GetService("CorePackages")
local Cryo = require(CorePackages.Packages.Cryo)
local Rodux = require(CorePackages.Packages.Rodux)
local SetSignUpInProgress = require(Modules.Luobu.Actions.SetSignUpInProgress)
local SetSignUpInfo = require(Modules.Luobu.Actions.SetSignUpInfo)
local SetAgreedUserAgreements = require(Modules.Luobu.Actions.SetAgreedUserAgreements)

return Rodux.createReducer({
	signUpInProgress = false,
	prefilledDisplayName = "",
	signUpVoucher = "",
	authMethod = "",
	channelId = -1,
	agreedUserAgreements = {}
}, {
	[SetSignUpInProgress.name] = function(p1, t1: {[any]: any}) -- line: 17
		-- upvalues: Cryo (copy)
		return Cryo.Dictionary.join(p1, {
			signUpInProgress = t1.signUpInProgress
		})
	end,
	[SetSignUpInfo.name] = function(p2, t2: {[any]: any}) -- line: 22
		-- upvalues: Cryo (copy)
		return Cryo.Dictionary.join(p2, {
			prefilledDisplayName = t2.prefilledDisplayName,
			signUpVoucher = t2.signUpVoucher,
			authMethod = t2.authMethod,
			channelId = t2.channelId
		})
	end,
	[SetAgreedUserAgreements.name] = function(p3, t3: {[any]: any}) -- line: 30
		-- upvalues: Cryo (copy)
		return Cryo.Dictionary.join(p3, {
			agreedUserAgreements = t3.agreedUserAgreements
		})
	end
})
