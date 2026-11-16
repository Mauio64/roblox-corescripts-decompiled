local module = require("@luauforge/bundled/hBs")
local userActivationSignupPageState = module.Enums.UserActivationSignupPageState
require("@luauforge/bundled/hBr")
local module2 = require("@luauforge/bundled/hCf")

local module3 = require("@luauforge/bundled/hCg")
local module4 = require("@luauforge/bundled/hCs")
local module5 = require("@luauforge/bundled/hCE")
local module6 = require("@luauforge/bundled/hCF")

local module7 = require("@luauforge/bundled/hCM")

local module8 = require("@luauforge/bundled/hCG")
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
