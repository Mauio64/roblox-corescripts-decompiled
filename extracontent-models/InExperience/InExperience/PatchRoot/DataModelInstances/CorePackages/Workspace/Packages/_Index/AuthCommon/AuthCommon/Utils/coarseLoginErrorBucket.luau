local AuthCommon = script:FindFirstAncestor("AuthCommon")
local parent = AuthCommon.Parent

local LoginErrorCodes = require(AuthCommon.Enums.LoginErrorCodes)
local Http = require(parent.Http)
local StatusCodes = Http.StatusCodes

local v = {
	[LoginErrorCodes.IncorrectCValueOrPassword] = "invalidCredentials",
	[LoginErrorCodes.MultipleUsersPerCredential] = "invalidCredentials",
	[LoginErrorCodes.AccountLocked] = "passwordReset",
	[LoginErrorCodes.CTypeNotSupported] = "badRequest",
	[LoginErrorCodes.CValueAndPasswordRequired] = "badRequest",
	[LoginErrorCodes.SecurityQuestions] = "securityQuestions"
}

local v2 = {
	[StatusCodes.TOO_MANY_REQUESTS] = "throttled",
	[StatusCodes.REQUEST_TIMEOUT] = "timeout",
	[StatusCodes.BAD_REQUEST] = "badRequest",
	[StatusCodes.NOT_FOUND] = "notFound",
	[StatusCodes.INTERNAL_SERVER_ERROR] = "serverError"
}

local function coarseLoginErrorBucket(data)
	if typeof(data) ~= "table" then
		return "unknown"
	end

	local v3 = v[data.errorCode]

	if v3 then
		return v3
	end

	if data.HttpError == Enum.HttpError.OK then
		return v2[data.StatusCode] or "unknown"
	end

	return "unknown"
end

return coarseLoginErrorBucket
