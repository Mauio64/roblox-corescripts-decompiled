local CorePackages = game:GetService("CorePackages")
local Cryo = require(CorePackages.Packages.Cryo)
local Rodux = require(CorePackages.Packages.Rodux)
local module = require("@luauforge/bundled/fNS")
local module2 = require("@luauforge/bundled/fNV")
local module3 = require("@luauforge/bundled/fNW")
local module4 = require("@luauforge/bundled/fOQ")

return Rodux.createReducer(
	{
		MSDKLoginErrMessageKey = nil,
		tokenAuthErrMessageKey = nil,
		loginInProgress = false,
		openId = ""
	},
	{
		[module.name] = function(p2, p3)
			return Cryo.Dictionary.join(p2, {
				MSDKLoginErrMessageKey = p3.errMessageKey
			})
		end,
		[module2.name] = function(p2, p3)
			return Cryo.Dictionary.join(p2, {
				tokenAuthErrMessageKey = p3.errMessageKey
			})
		end,
		[module3.name] = function(p2, p3)
			return Cryo.Dictionary.join(p2, { loginInProgress = p3.loginInProgress })
		end,
		[module4.name] = function(p2, p3)
			return Cryo.Dictionary.join(p2, { openId = p3.openId })
		end
	}
)
