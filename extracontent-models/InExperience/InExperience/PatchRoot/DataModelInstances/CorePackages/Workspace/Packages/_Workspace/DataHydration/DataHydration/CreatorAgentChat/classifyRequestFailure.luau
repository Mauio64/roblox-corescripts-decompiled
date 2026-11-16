local types = require(script.Parent.types)

local requestFailureKind = types.RequestFailureKind

local function classifyRequestFailure(data)
	if data.status == "pending" then
		return { kind = requestFailureKind.Timeout }
	end

	local response = data.response

	if data.errorCode == nil then
		if response == nil then
			local err = data.error

			if err ~= nil then
				if string.sub(err, 1, 16) == "transport error:" then
					return { kind = requestFailureKind.Transport }
				end

				local httpStatusCode = tonumber((string.match(err, "^CAS HTTP (%d+)")))

				if httpStatusCode ~= nil then
					return { kind = requestFailureKind.Http, httpStatusCode = httpStatusCode }
				end
			end

			return { kind = requestFailureKind.Unknown }
		end

		if response.wasTransportFailure then
			return { kind = requestFailureKind.Transport }
		end

		if response.statusCode < 200 or response.statusCode >= 300 then
			return { kind = requestFailureKind.Http, httpStatusCode = response.statusCode }
		end

		return { kind = requestFailureKind.Unknown }
	else
		local v = { kind = requestFailureKind.RpcError, httpStatusCode = 0 }
		local httpStatusCode

		if response ~= nil then
			httpStatusCode = response.statusCode
		end

		v.httpStatusCode = httpStatusCode
		return v
	end
end

return classifyRequestFailure
