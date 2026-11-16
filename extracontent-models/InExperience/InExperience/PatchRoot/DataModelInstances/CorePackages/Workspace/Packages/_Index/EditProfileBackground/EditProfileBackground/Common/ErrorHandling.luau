local httpStatusCode = {
	BAD_REQUEST = 400,
	UNAUTHORIZED = 401,
	FORBIDDEN = 403,
	NOT_FOUND = 404,
	INTERNAL_SERVER_ERROR = 500,
	BAD_GATEWAY = 502,
	SERVICE_UNAVAILABLE = 503
}

local errorType = {
	TIMEOUT = "timeout",
	AUTHENTICATION = "authentication",
	PERMISSION = "permission",
	VALIDATION = "validation",
	SERVER_ERROR = "server_error",
	NETWORK = "network",
	UNKNOWN = "unknown"
}

local v = {
	[errorType.TIMEOUT] = "Request timed out. Please try again.",
	[errorType.AUTHENTICATION] = "Authentication failed. Please log in again.",
	[errorType.PERMISSION] = "You don't have permission to update this profile.",
	[errorType.VALIDATION] = "Invalid request. Please check your input.",
	[errorType.SERVER_ERROR] = "Server error. Please try again later.",
	[errorType.NETWORK] = "Network error. Please check your connection and try again.",
	[errorType.UNKNOWN] = "An unexpected error occurred. Please try again."
}

local v2 = {
	SAVE_BACKGROUND = "Failed to save background",
	LOAD_BACKGROUND = "Failed to load background",
	UPDATE_PROFILE = "Failed to update profile"
}

local function getErrorType(value)
	if typeof(value) == "table" then
		if value.message and string.find(string.lower(value.message), "timeout") then
			return errorType.TIMEOUT
		end

		local statusCode = value.StatusCode or value.statusCode

		if statusCode then
			if statusCode == httpStatusCode.UNAUTHORIZED then
				return errorType.AUTHENTICATION
			end

			if statusCode == httpStatusCode.FORBIDDEN then
				return errorType.PERMISSION
			end

			if statusCode == httpStatusCode.BAD_REQUEST then
				return errorType.VALIDATION
			end

			if httpStatusCode.INTERNAL_SERVER_ERROR <= statusCode then
				return errorType.SERVER_ERROR
			end
		end
	elseif typeof(value) == "string" then
		if string.find(string.lower(value), "timeout") then
			return errorType.TIMEOUT
		end

		if string.find(string.lower(value), "network") or string.find(string.lower(value), "connection") then
			return errorType.NETWORK
		end
	end

	return errorType.UNKNOWN
end

return {
	HttpStatusCode = httpStatusCode,
	ErrorType = errorType,
	ERROR_MESSAGES = v,
	DEFAULT_ERROR_MESSAGES = v2,
	getErrorType = getErrorType,
	getErrorMessage = function(p, p2)
		local v3 = v[getErrorType(p)]

		if p2 and v2[p2] then
			return v3 or v2[p2]
		end

		return v3 or v2.SAVE_BACKGROUND
	end
}
