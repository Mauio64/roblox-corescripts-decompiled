local statusCodes = require("@game/CorePackages/Workspace/Packages/_Workspace/RobloxAppToastsRodux/Http").StatusCodes

local v5 = {
	[statusCodes.BAD_REQUEST] = "Feature.Toast.NetworkingError.SomethingIsWrong",
	[statusCodes.UNAUTHORIZED] = "Feature.Toast.NetworkingError.Unauthorized",
	[statusCodes.FORBIDDEN] = "Feature.Toast.NetworkingError.Forbidden",
	[statusCodes.NOT_FOUND] = "Feature.Toast.NetworkingError.NotFound",
	[statusCodes.REQUEST_TIMEOUT] = "Feature.Toast.NetworkingError.Timeout",
	[statusCodes.TOO_MANY_REQUESTS] = "Feature.Toast.NetworkingError.TooManyRequests",
	[statusCodes.INTERNAL_SERVER_ERROR] = "Feature.Toast.NetworkingError.SomethingIsWrong",
	[statusCodes.NOT_IMPLEMENTED] = "Feature.Toast.NetworkingError.SomethingIsWrong",
	[statusCodes.BAD_GATEWAY] = "Feature.Toast.NetworkingError.SomethingIsWrong",
	[statusCodes.SERVICE_UNAVAILABLE] = "Feature.Toast.NetworkingError.ServiceUnavailable",
	[statusCodes.GATEWAY_TIMEOUT] = "Feature.Toast.NetworkingError.Timeout"
}

local function getLocalizedToastStringFromHttpError(p2, p3)
	if
		p2 == Enum.HttpError.DnsResolve
		or p2 == Enum.HttpError.ConnectFail
		or p2 == Enum.HttpError.NetFail
		or p2 == Enum.HttpError.SslConnectFail
	then
		return "Feature.Toast.NetworkingError.UnableToConnect"
	end

	if p2 == Enum.HttpError.TimedOut then
		return "Feature.Toast.NetworkingError.Timeout"
	end

	if p2 == Enum.HttpError.Aborted then
		return nil
	end

	if p2 == Enum.HttpError.OK and p3 ~= nil and v5[p3] ~= nil then
		return v5[p3]
	end

	return "Feature.Toast.NetworkingError.SomethingIsWrong"
end

return getLocalizedToastStringFromHttpError
