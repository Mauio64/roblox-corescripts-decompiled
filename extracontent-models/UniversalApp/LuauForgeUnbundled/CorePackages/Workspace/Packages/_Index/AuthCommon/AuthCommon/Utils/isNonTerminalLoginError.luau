local LoginErrorCodes = require("@game/CorePackages/Workspace/Packages/_Index/AuthCommon/AuthCommon/Enums/LoginErrorCodes")

local function isNonTerminalLoginError(data, options): boolean
	if typeof(data) ~= "table" then
		return false
	end

	local v5 = options or {}
	local errorCode = data.errorCode

	if errorCode == LoginErrorCodes.Captcha then
		return true
	end

	if errorCode == LoginErrorCodes.SecurityQuestions then
		return v5.securityQuestionsEnabled ~= false
			and data.securityQuestionsData ~= nil
			and data.securityQuestionsCallback ~= nil
	elseif errorCode == LoginErrorCodes.MultipleUsersPerCredential then
		if v5.accountSelectorEnabled == false or data.usersData == nil then
			return false
		end

		if not v5.accountSelectorRequiresCredentials then
			return true
		end

		return v5.credentialValue ~= nil and v5.password ~= nil
	elseif
		errorCode == LoginErrorCodes.EmptyAccountSwitchBlobRequired
		or errorCode == LoginErrorCodes.ParentEmptyAccountSwitchBlobRequired
	then
		return v5.accountSwitchEnabled == true
	else
		return false
	end
end

return isNonTerminalLoginError
