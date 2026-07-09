local AuthCommon = script:FindFirstAncestor("AuthCommon")
local TwoStepErrorCodes = require(AuthCommon.Enums.TwoStepErrorCodes)

local function getTwoStepLoginErrorKey(n1: number?) -- line: 9
	-- upvalues: TwoStepErrorCodes (copy)
	if n1 == TwoStepErrorCodes.IllegalChildAccountLinking then
		return "Authentication.Login.LinkIllegalChildAccountLinking"
	end

	return "Authentication.Login.Response.SomethingWentWrong"
end

return getTwoStepLoginErrorKey
