local AuthCommon = script:FindFirstAncestor("AuthCommon")
local LoginErrorCodes = require(AuthCommon.Enums.LoginErrorCodes)

local function isNonTerminalLoginError(p1, t1: {[any]: any}?) -- line: 28
	-- upvalues: LoginErrorCodes (copy)
	if typeof(p1) ~= "table" then
		return false
	end

	local v6 = t1 or {}
	local errorCode = p1.errorCode

	if errorCode == LoginErrorCodes.Captcha then
		return true
	end

	if errorCode == LoginErrorCodes.SecurityQuestions then
		return v6.securityQuestionsEnabled ~= false and (p1.securityQuestionsData ~= nil and p1.securityQuestionsCallback ~= nil)
	end

	if errorCode == LoginErrorCodes.MultipleUsersPerCredential then
		if v6.accountSelectorEnabled == false or p1.usersData == nil then
			return false
		end

		if v6.accountSelectorRequiresCredentials then
			return v6.credentialValue ~= nil and v6.password ~= nil
		end

		return true
	end

	if errorCode == LoginErrorCodes.EmptyAccountSwitchBlobRequired or errorCode == LoginErrorCodes.ParentEmptyAccountSwitchBlobRequired then
		return v6.accountSwitchEnabled == true
	end

	return false
end

return isNonTerminalLoginError
