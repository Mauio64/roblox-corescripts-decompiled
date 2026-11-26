local v5 = {
	BAD_REQUEST = 400,
	UNAUTHORIZED = 401,
	FORBIDDEN = 403,
	NOT_FOUND = 404,
	INTERNAL_SERVER_ERROR = 500,
	BAD_GATEWAY = 502,
	SERVICE_UNAVAILABLE = 503
}

local v6 = {
	TIMEOUT = "timeout",
	AUTHENTICATION = "authentication",
	PERMISSION = "permission",
	VALIDATION = "validation",
	SERVER_ERROR = "server_error",
	NETWORK = "network",
	UNKNOWN = "unknown"
}

local v7 = {
	[v6.TIMEOUT] = "Request timed out. Please try again.",
	[v6.AUTHENTICATION] = "Authentication failed. Please log in again.",
	[v6.PERMISSION] = "You don't have permission to update this profile.",
	[v6.VALIDATION] = "Invalid request. Please check your input.",
	[v6.SERVER_ERROR] = "Server error. Please try again later.",
	[v6.NETWORK] = "Network error. Please check your connection and try again.",
	[v6.UNKNOWN] = "An unexpected error occurred. Please try again."
}

local v8 = {
	SAVE_BACKGROUND = "Failed to save background",
	LOAD_BACKGROUND = "Failed to load background",
	UPDATE_PROFILE = "Failed to update profile"
}

local function getErrorType(value)
	if typeof(value) == "table" then
		if value.message and string.find(string.lower(value.message), "timeout") then
			return v6.TIMEOUT
		end

		local statusCode = value.StatusCode or value.statusCode

		if statusCode then
			if statusCode == v5.UNAUTHORIZED then
				return v6.AUTHENTICATION
			end

			if statusCode == v5.FORBIDDEN then
				return v6.PERMISSION
			end

			if statusCode == v5.BAD_REQUEST then
				return v6.VALIDATION
			end

			if v5.INTERNAL_SERVER_ERROR <= statusCode then
				return v6.SERVER_ERROR
			end
		end
	elseif typeof(value) == "string" then
		if string.find(string.lower(value), "timeout") then
			return v6.TIMEOUT
		end

		if
			string.find(string.lower(value), "network")
			or string.find(string.lower(value), "connection")
		then
			return v6.NETWORK
		end
	end

	return v6.UNKNOWN
end

return {
	HttpStatusCode = v5,
	ErrorType = v6,
	ERROR_MESSAGES = v7,
	DEFAULT_ERROR_MESSAGES = v8,
	getErrorType = getErrorType,
	getErrorMessage = function(self, p3)
		local v9 = v7[getErrorType(self)]

		if p3 and v8[p3] then
			return v9 or v8[p3]
		end

		return v9 or v8.SAVE_BACKGROUND
	end
}
