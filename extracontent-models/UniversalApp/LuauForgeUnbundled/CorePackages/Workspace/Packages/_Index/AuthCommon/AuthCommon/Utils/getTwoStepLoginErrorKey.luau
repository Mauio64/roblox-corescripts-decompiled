local TwoStepErrorCodes = require("@game/CorePackages/Workspace/Packages/_Index/AuthCommon/AuthCommon/Enums/TwoStepErrorCodes")

local function getTwoStepLoginErrorKey(p2): string
	if p2 == TwoStepErrorCodes.IllegalChildAccountLinking then
		return "Authentication.Login.LinkIllegalChildAccountLinking"
	end

	return "Authentication.Login.Response.SomethingWentWrong"
end

return getTwoStepLoginErrorKey
