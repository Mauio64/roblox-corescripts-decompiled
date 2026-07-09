local t1 = {
	BAD_REQUEST = 400,
	UNAUTHORIZED = 401,
	FORBIDDEN = 403,
	NOT_FOUND = 404,
	INTERNAL_SERVER_ERROR = 500,
	BAD_GATEWAY = 502,
	SERVICE_UNAVAILABLE = 503
}
local t2 = {
	TIMEOUT = "timeout",
	AUTHENTICATION = "authentication",
	PERMISSION = "permission",
	VALIDATION = "validation",
	SERVER_ERROR = "server_error",
	NETWORK = "network",
	UNKNOWN = "unknown"
}
local t3 = {
	[t2.TIMEOUT] = "Request timed out. Please try again.",
	[t2.AUTHENTICATION] = "Authentication failed. Please log in again.",
	[t2.PERMISSION] = "You don't have permission to update this profile.",
	[t2.VALIDATION] = "Invalid request. Please check your input.",
	[t2.SERVER_ERROR] = "Server error. Please try again later.",
	[t2.NETWORK] = "Network error. Please check your connection and try again.",
	[t2.UNKNOWN] = "An unexpected error occurred. Please try again."
}
local t4 = {
	SAVE_BACKGROUND = "Failed to save background",
	LOAD_BACKGROUND = "Failed to load background",
	UPDATE_PROFILE = "Failed to update profile"
}

local function getErrorType(p1) -- line: 37
	-- upvalues: t2 (copy), t1 (copy)
	if typeof(p1) == "table" then
		if p1.message and string.find(string.lower(p1.message), "timeout") then
			return t2.TIMEOUT
		end

		local v7 = p1.StatusCode or p1.statusCode

		if v7 then
			if v7 == t1.UNAUTHORIZED then
				return t2.AUTHENTICATION
			end

			if v7 == t1.FORBIDDEN then
				return t2.PERMISSION
			end

			if v7 == t1.BAD_REQUEST then
				return t2.VALIDATION
			end

			if v7 >= t1.INTERNAL_SERVER_ERROR then
				return t2.SERVER_ERROR
			end
		end
	elseif typeof(p1) == "string" then
		if string.find(string.lower(p1), "timeout") then
			return t2.TIMEOUT
		end

		if string.find(string.lower(p1), "network") or string.find(string.lower(p1), "connection") then
			return t2.NETWORK
		end
	end

	return t2.UNKNOWN
end

return {
	HttpStatusCode = t1,
	ErrorType = t2,
	ERROR_MESSAGES = t3,
	DEFAULT_ERROR_MESSAGES = t4,
	getErrorType = getErrorType,
	getErrorMessage = function(p2, p3) -- line: 66
		-- upvalues: getErrorType (copy), t3 (copy), t4 (copy)
		local v10 = t3[getErrorType(p2)]

		if p3 and t4[p3] then
			return v10 or t4[p3]
		end

		return v10 or t4.SAVE_BACKGROUND
	end
}
