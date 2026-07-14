local AuthCommon = script:FindFirstAncestor("AuthCommon")
local AuthCommonParent = AuthCommon.Parent
local LoginErrorCodes = require(AuthCommon.Enums.LoginErrorCodes)
local StatusCodes = require(AuthCommonParent.Http).StatusCodes
local t1 = {
	[LoginErrorCodes.IncorrectCValueOrPassword] = "invalidCredentials",
	[LoginErrorCodes.MultipleUsersPerCredential] = "invalidCredentials",
	[LoginErrorCodes.AccountLocked] = "passwordReset",
	[LoginErrorCodes.CTypeNotSupported] = "badRequest",
	[LoginErrorCodes.CValueAndPasswordRequired] = "badRequest",
	[LoginErrorCodes.SecurityQuestions] = "securityQuestions"
}
local t2 = {
	[StatusCodes.TOO_MANY_REQUESTS] = "throttled",
	[StatusCodes.REQUEST_TIMEOUT] = "timeout",
	[StatusCodes.BAD_REQUEST] = "badRequest",
	[StatusCodes.NOT_FOUND] = "notFound",
	[StatusCodes.INTERNAL_SERVER_ERROR] = "serverError"
}

local function coarseLoginErrorBucket(p1) -- line: 25
	-- upvalues: t1 (copy), t2 (copy)
	if typeof(p1) ~= "table" then
		return "unknown"
	end

	local v9 = t1[p1.errorCode]

	if v9 then
		return v9
	end

	if p1.HttpError == Enum.HttpError.OK then
		return t2[p1.StatusCode] or "unknown"
	end

	return "unknown"
end

return coarseLoginErrorBucket
