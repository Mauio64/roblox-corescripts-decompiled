local LoginErrorCodes = require("@game/CorePackages/Workspace/Packages/_Index/AuthCommon/AuthCommon/Enums/LoginErrorCodes")
local isNonTerminalLoginError = require("@game/CorePackages/Workspace/Packages/_Index/AuthCommon/AuthCommon/Utils/isNonTerminalLoginError")

local function fillGenericLoginErrorKey(state, p2)
	if
		typeof(state) ~= "table"
		or state.errorKey ~= nil
		or state.errorCode == LoginErrorCodes.AccountLocked
		or isNonTerminalLoginError(state, p2)
	then
		return state
	end

	state.errorKey = "Authentication.Login.Response.SomethingWentWrong"
	return state
end

return fillGenericLoginErrorKey
