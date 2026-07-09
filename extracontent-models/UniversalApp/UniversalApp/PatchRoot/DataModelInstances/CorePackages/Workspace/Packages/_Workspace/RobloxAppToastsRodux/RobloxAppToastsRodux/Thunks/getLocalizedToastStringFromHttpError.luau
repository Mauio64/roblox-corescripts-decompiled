local Parent = script:FindFirstAncestor("RobloxAppToastsRodux").Parent
local StatusCodes = require(Parent.Http).StatusCodes
local t1 = {
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

local function getLocalizedToastStringFromHttpError(p1, p2) -- line: 30
	-- upvalues: t1 (copy)
	if p1 == Enum.HttpError.DnsResolve or (p1 == Enum.HttpError.ConnectFail or p1 == Enum.HttpError.NetFail or p1 == Enum.HttpError.SslConnectFail) then
		return "Feature.Toast.NetworkingError.UnableToConnect"
	end

	if p1 == Enum.HttpError.TimedOut then
		return "Feature.Toast.NetworkingError.Timeout"
	end

	if p1 == Enum.HttpError.Aborted then
		return nil
	end

	if p1 == Enum.HttpError.OK and p2 ~= nil and t1[p2] ~= nil then
		return t1[p2]
	end

	return "Feature.Toast.NetworkingError.SomethingIsWrong"
end

return getLocalizedToastStringFromHttpError
