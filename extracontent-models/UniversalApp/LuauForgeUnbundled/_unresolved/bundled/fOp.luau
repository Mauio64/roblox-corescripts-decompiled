local url = require("@luauforge/bundled/fOq").Url
local logger = require("@luauforge/bundled/fOr").Logger
local v5 = logger.new(logger, "UserAgreements")

local module = require("@luauforge/bundled/fOs")

game:DefineFastInt("LuaFetchUpdatedUserAgreementsErrorsThrottling", 10000)

return function(callback, p2)
	local v6 = url.APIS_URL .. "user-agreements/v1/agreements-resolution/Web"
	return callback(v6, "GET"):andThen(function(p3)
		if p3.responseCode == 200 then
			return p3.responseBody
		end
	end, function(data)
		v5:warning(string.format(
			"Url: %s, Status: %s, isJSONValid: %s",
			v6,
			tostring(data.HttpError),
			(tostring(data.isJSONValid))
		))

		if p2 then
			p2.Diag:reportCounter(module.FetchAgreementsHttpRequestFailure, 1)
			p2.InfluxDb:reportSeries(
				"FetchUpdatedUserAgreements",
				{ url = v6, statusCode = data.StatusCode, errorMessage = data.Body },
				game:GetFastInt("LuaFetchUpdatedUserAgreementsErrorsThrottling")
			)
		end
	end)
end
