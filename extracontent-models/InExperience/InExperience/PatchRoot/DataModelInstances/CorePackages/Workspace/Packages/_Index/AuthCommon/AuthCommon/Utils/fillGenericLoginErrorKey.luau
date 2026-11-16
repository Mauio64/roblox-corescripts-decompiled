local AuthCommon = script:FindFirstAncestor("AuthCommon")

local LoginErrorCodes = require(AuthCommon.Enums.LoginErrorCodes)
local isNonTerminalLoginError = require(script.Parent.isNonTerminalLoginError)

local function fillGenericLoginErrorKey(state, p)
	if
		typeof(state) ~= "table"
		or state.errorKey ~= nil
		or state.errorCode == LoginErrorCodes.AccountLocked
		or isNonTerminalLoginError(state, p)
	then
		return state
	end

	state.errorKey = "Authentication.Login.Response.SomethingWentWrong"
	return state
end

return fillGenericLoginErrorKey
