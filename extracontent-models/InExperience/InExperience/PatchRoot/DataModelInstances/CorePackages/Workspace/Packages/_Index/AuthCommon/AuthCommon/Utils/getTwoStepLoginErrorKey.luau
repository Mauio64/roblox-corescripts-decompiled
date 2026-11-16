local AuthCommon = script:FindFirstAncestor("AuthCommon")

local TwoStepErrorCodes = require(AuthCommon.Enums.TwoStepErrorCodes)

local function getTwoStepLoginErrorKey(p: number?): string
	if p == TwoStepErrorCodes.IllegalChildAccountLinking then
		return "Authentication.Login.LinkIllegalChildAccountLinking"
	end

	return "Authentication.Login.Response.SomethingWentWrong"
end

return getTwoStepLoginErrorKey
