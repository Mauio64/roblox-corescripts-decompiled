local AuthCommon = script:FindFirstAncestor("AuthCommon")

local LoginErrorCodes = require(AuthCommon.Enums.LoginErrorCodes)

local function isNonTerminalLoginError(data, options): boolean
	if typeof(data) ~= "table" then
		return false
	end

	local v = options or {}
	local errorCode = data.errorCode

	if errorCode == LoginErrorCodes.Captcha then
		return true
	end

	if errorCode == LoginErrorCodes.SecurityQuestions then
		return v.securityQuestionsEnabled ~= false
			and data.securityQuestionsData ~= nil
			and data.securityQuestionsCallback ~= nil
	elseif errorCode == LoginErrorCodes.MultipleUsersPerCredential then
		if v.accountSelectorEnabled == false or data.usersData == nil then
			return false
		end

		return not v.accountSelectorRequiresCredentials or v.credentialValue ~= nil and v.password ~= nil
	elseif
		errorCode == LoginErrorCodes.EmptyAccountSwitchBlobRequired
		or errorCode == LoginErrorCodes.ParentEmptyAccountSwitchBlobRequired
	then
		return v.accountSwitchEnabled == true
	else
		return false
	end
end

return isNonTerminalLoginError
