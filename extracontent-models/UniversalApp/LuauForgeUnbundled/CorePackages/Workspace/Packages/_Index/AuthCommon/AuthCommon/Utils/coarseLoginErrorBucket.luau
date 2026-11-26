local LoginErrorCodes = require("@game/CorePackages/Workspace/Packages/_Index/AuthCommon/AuthCommon/Enums/LoginErrorCodes")
local statusCodes = require("@game/CorePackages/Workspace/Packages/_Workspace/AuthCommon/Http").StatusCodes

local v5 = {
	[LoginErrorCodes.IncorrectCValueOrPassword] = "invalidCredentials",
	[LoginErrorCodes.MultipleUsersPerCredential] = "invalidCredentials",
	[LoginErrorCodes.AccountLocked] = "passwordReset",
	[LoginErrorCodes.CTypeNotSupported] = "badRequest",
	[LoginErrorCodes.CValueAndPasswordRequired] = "badRequest",
	[LoginErrorCodes.SecurityQuestions] = "securityQuestions"
}

local v6 = {
	[statusCodes.TOO_MANY_REQUESTS] = "throttled",
	[statusCodes.REQUEST_TIMEOUT] = "timeout",
	[statusCodes.BAD_REQUEST] = "badRequest",
	[statusCodes.NOT_FOUND] = "notFound",
	[statusCodes.INTERNAL_SERVER_ERROR] = "serverError"
}

local function coarseLoginErrorBucket(data)
	if typeof(data) ~= "table" then
		return "unknown"
	end

	local v7 = v5[data.errorCode]

	if v7 then
		return v7
	end

	if data.HttpError == Enum.HttpError.OK then
		return v6[data.StatusCode] or "unknown"
	end

	return "unknown"
end

return coarseLoginErrorBucket
