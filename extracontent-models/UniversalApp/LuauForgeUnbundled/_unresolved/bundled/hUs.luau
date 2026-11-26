local CorePackages = game:GetService("CorePackages")
local Cryo = require(CorePackages.Packages.Cryo)
local Rodux = require(CorePackages.Packages.Rodux)
local module = require("@luauforge/bundled/gyX")
local module2 = require("@luauforge/bundled/gtm")
local module3 = require("@luauforge/bundled/hUt")

return Rodux.createReducer({
	signUpInProgress = false,
	prefilledDisplayName = "",
	signUpVoucher = "",
	authMethod = "",
	channelId = -1,
	agreedUserAgreements = {}
}, {
	[module.name] = function(p2, p3)
		return Cryo.Dictionary.join(p2, { signUpInProgress = p3.signUpInProgress })
	end,
	[module2.name] = function(p2, data)
		return Cryo.Dictionary.join(p2, {
			prefilledDisplayName = data.prefilledDisplayName,
			signUpVoucher = data.signUpVoucher,
			authMethod = data.authMethod,
			channelId = data.channelId
		})
	end,
	[module3.name] = function(p2, p3)
		return Cryo.Dictionary.join(p2, {
			agreedUserAgreements = p3.agreedUserAgreements
		})
	end
})
