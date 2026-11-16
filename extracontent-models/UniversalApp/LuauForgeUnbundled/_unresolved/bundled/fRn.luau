local module = require("@luauforge/bundled/fsq")

local logging = require("@game/CorePackages/Workspace/Packages/AppCommonLib").Logging
local module2 = require("@luauforge/bundled/fDL")
local userAgreementsCounterNames = require("@luauforge/bundled/fOd").UserAgreementsCounterNames

game:DefineFastInt("LuaFetchUpdatedUserAgreementsErrorsThrottling", 10000)

return function(callback, p2)
	local v5 = module.fromString("apis:user-agreements/v1/agreements-resolution-signup/Web")
	return callback(v5(), "GET"):andThen(function(p3)
		if p3.responseCode == 200 then
			return p3.responseBody
		end
	end, function(data)
		local httpError = tostring(data.HttpError)
		local isJSONValid = tostring(data.isJSONValid)
		logging.warn(string.format("Url: %s, Status: %s, isJSONValid: %s", v5, httpError, isJSONValid))
		module2(userAgreementsCounterNames.FetchAgreementsHttpRequestFailure, 1)

		if p2 ~= nil then
			local v6 = {
				url = v5,
				statusCode = data.StatusCode,
				errorMessage = data.Body
			}

			p2.InfluxDb:reportSeries(
				"FetchSignupUserAgreements",
				v6,
				game:GetFastInt("LuaFetchUpdatedUserAgreementsErrorsThrottling")
			)
		end
	end)
end
