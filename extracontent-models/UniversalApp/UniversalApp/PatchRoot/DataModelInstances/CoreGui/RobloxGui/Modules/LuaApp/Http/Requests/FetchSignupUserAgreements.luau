local Modules = game:GetService("CoreGui").RobloxGui.Modules
local CorePackages = game:GetService("CorePackages")
local UrlBuilder = require(Modules.LuaApp.Http.UrlBuilder)
local Logging = require(CorePackages.Workspace.Packages.AppCommonLib).Logging
local reportEphemeralCounter = require(Modules.LuaApp.Analytics.Events.reportEphemeralCounter)
local UserAgreementsCounterNames = require(CorePackages.Workspace.Packages.UserAgreements).UserAgreementsCounterNames

game:DefineFastInt("LuaFetchUpdatedUserAgreementsErrorsThrottling", 10000)

return function(p1, p2) -- line: 14
	-- upvalues: UrlBuilder (copy), Logging (copy), reportEphemeralCounter (copy), UserAgreementsCounterNames (copy)
	local v9 = UrlBuilder.fromString("apis:user-agreements/v1/agreements-resolution-signup/Web")

	return p1(v9(), "GET"):andThen(function(p3) -- line: 16
		if p3.responseCode ~= 200 then
			return
		end

		return p3.responseBody
	end, function(p4) -- line: 22
		-- upvalues: Logging (copy), v9 (copy), reportEphemeralCounter (copy), UserAgreementsCounterNames (copy), p2 (copy)
		local str = tostring(p4.HttpError)
		local str2 = tostring(p4.isJSONValid)

		Logging.warn(string.format("Url: %s, Status: %s, isJSONValid: %s", v9, str, str2))
		reportEphemeralCounter(UserAgreementsCounterNames.FetchAgreementsHttpRequestFailure, 1)

		if p2 ~= nil then
			local t1 = {
				url = v9,
				statusCode = p4.StatusCode,
				errorMessage = p4.Body
			}

			p2.InfluxDb:reportSeries(script.Name, t1, game:GetFastInt("LuaFetchUpdatedUserAgreementsErrorsThrottling"))
		end
	end)
end
