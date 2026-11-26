local module = require("@luauforge/bundled/hMJ")
local userActivationSignupPageState = module.Enums.UserActivationSignupPageState
require("@luauforge/bundled/hMI")
local module2 = require("@luauforge/bundled/hNw")

local module3 = require("@luauforge/bundled/hNx")
local module4 = require("@luauforge/bundled/hNJ")
local module5 = require("@luauforge/bundled/hNV")
local module6 = require("@luauforge/bundled/hNW")

local module7 = require("@luauforge/bundled/hOd")

local module8 = require("@luauforge/bundled/hNX")
local namespace = module.Enums.Namespace

return function()
	local v6 = module3

	local v8 = module7

	local v10 = module4

	local v12 = module5

	local v14 = module6
	return {
		{
			[userActivationSignupPageState.EnterBirthday] = function(p2)
				local joined = module8.Dictionary.join(p2, {
					namespace = namespace.MultiPageSignup
				})

				return module2.createElement(v6, joined)
			end
		},
		{
			[userActivationSignupPageState.NonInteractiveStoreUserAgreements] = function(p2)
				local joined = module8.Dictionary.join(p2, {
					namespace = namespace.MultiPageSignup
				})

				return module2.createElement(v8, joined)
			end
		},
		{
			[userActivationSignupPageState.EnterUserIdentifier] = function(p2)
				local joined = module8.Dictionary.join(p2, {
					namespace = namespace.MultiPageSignup
				})

				return module2.createElement(v10, joined)
			end
		},
		{
			[userActivationSignupPageState.AddAuthMethod] = function(p2)
				local joined = module8.Dictionary.join(p2, {
					namespace = namespace.MultiPageSignup
				})

				return module2.createElement(v12, joined)
			end
		},
		{
			[userActivationSignupPageState.SelectGender] = function(p2)
				local joined = module8.Dictionary.join(p2, {
					namespace = namespace.MultiPageSignup
				})

				return module2.createElement(v14, joined)
			end
		}
	}
end
