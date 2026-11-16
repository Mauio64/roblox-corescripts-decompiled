local parent = script:FindFirstAncestor("RobloxAppToastsRodux").Parent
local Http = require(parent.Http)
local StatusCodes = Http.StatusCodes

local v = {
	[StatusCodes.BAD_REQUEST] = "Feature.Toast.NetworkingError.SomethingIsWrong",
	[StatusCodes.UNAUTHORIZED] = "Feature.Toast.NetworkingError.Unauthorized",
	[StatusCodes.FORBIDDEN] = "Feature.Toast.NetworkingError.Forbidden",
	[StatusCodes.NOT_FOUND] = "Feature.Toast.NetworkingError.NotFound",
	[StatusCodes.REQUEST_TIMEOUT] = "Feature.Toast.NetworkingError.Timeout",
	[StatusCodes.TOO_MANY_REQUESTS] = "Feature.Toast.NetworkingError.TooManyRequests",
	[StatusCodes.INTERNAL_SERVER_ERROR] = "Feature.Toast.NetworkingError.SomethingIsWrong",
	[StatusCodes.NOT_IMPLEMENTED] = "Feature.Toast.NetworkingError.SomethingIsWrong",
	[StatusCodes.BAD_GATEWAY] = "Feature.Toast.NetworkingError.SomethingIsWrong",
	[StatusCodes.SERVICE_UNAVAILABLE] = "Feature.Toast.NetworkingError.ServiceUnavailable",
	[StatusCodes.GATEWAY_TIMEOUT] = "Feature.Toast.NetworkingError.Timeout"
}

local function getLocalizedToastStringFromHttpError(p, p2)
	if
		p == Enum.HttpError.DnsResolve
		or p == Enum.HttpError.ConnectFail
		or p == Enum.HttpError.NetFail
		or p == Enum.HttpError.SslConnectFail
	then
		return "Feature.Toast.NetworkingError.UnableToConnect"
	end

	if p == Enum.HttpError.TimedOut then
		return "Feature.Toast.NetworkingError.Timeout"
	end

	if p == Enum.HttpError.Aborted then
		return nil
	end

	if p == Enum.HttpError.OK and p2 ~= nil and v[p2] ~= nil then
		return v[p2]
	end

	return "Feature.Toast.NetworkingError.SomethingIsWrong"
end

return getLocalizedToastStringFromHttpError
