local module = require("@luauforge/deferred/hNw")

local v5 = {
	"Feature.AccountSecurityPrompt.Message.Error.PasswordValidation.WeakPassword",
	"Feature.AccountSecurityPrompt.Message.Error.PasswordValidation.ShortPassword",
	"Feature.AccountSecurityPrompt.Message.Error.PasswordValidation.PasswordSameAsUsername",
	"Feature.AccountSecurityPrompt.Message.Error.PasswordValidation.ForbiddenPassword",
	"Feature.AccountSecurityPrompt.Message.Error.PasswordValidation.DumbStrings"
}

local v6 = {}

for k, v7 in pairs(v5) do
	v6[v7] = v7
end

return {
	localizationKeys = v6,
	validator = function(p2, p3, p4)
		return function(p5)
			return module(p2, p4, p5):andThen(function(p6)
				local v7 = v5[p6 and p6.responseBody and p6.responseBody.code]

				if v7 == nil then
					return nil
				end

				return p3[v7]
			end):catch(function(p6): nil
				return nil
			end)
		end
	end
}
