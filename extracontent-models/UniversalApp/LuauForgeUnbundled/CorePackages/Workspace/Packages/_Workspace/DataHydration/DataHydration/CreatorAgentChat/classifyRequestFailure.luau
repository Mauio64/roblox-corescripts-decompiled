local requestFailureKind = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/CreatorAgentChat/types").RequestFailureKind

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

				local v5 = tonumber((string.match(err, "^CAS HTTP (%d+)")))

				if v5 ~= nil then
					return { kind = requestFailureKind.Http, httpStatusCode = v5 }
				end
			end

			return { kind = requestFailureKind.Unknown }
		end

		if response.wasTransportFailure then
			return { kind = requestFailureKind.Transport }
		end

		if response.statusCode < 200 or response.statusCode >= 300 then
			return {
				kind = requestFailureKind.Http,
				httpStatusCode = response.statusCode
			}
		end

		return { kind = requestFailureKind.Unknown }
	else
		local v5 = { kind = requestFailureKind.RpcError, httpStatusCode = 0 }
		local v6 = if response ~= nil then response.statusCode else nil
		v5.httpStatusCode = v6
		return v5
	end
end

return classifyRequestFailure
