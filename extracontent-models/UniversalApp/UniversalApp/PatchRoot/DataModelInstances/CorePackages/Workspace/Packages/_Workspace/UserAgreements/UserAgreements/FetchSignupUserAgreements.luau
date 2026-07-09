local Parent = script:FindFirstAncestor("UserAgreements").Parent
local Url = require(Parent.Http).Url
local v3 = require(Parent.Loggers).Logger:new("UserAgreements")
local UserAgreementsCounterNames = require(script.Parent.UserAgreementsCounterNames)

game:DefineFastInt("LuaFetchUpdatedUserAgreementsErrorsThrottling", 10000)

return function(p1, p2) -- line: 15
	-- upvalues: Url (copy), v3 (copy), UserAgreementsCounterNames (copy)
	local v7 = Url.APIS_URL .. "user-agreements/v1/agreements-resolution-signup/Web"

	return p1(v7, "GET"):andThen(function(p3) -- line: 17
		if p3.responseCode ~= 200 then
			return
		end

		return p3.responseBody
	end, function(p4) -- line: 23
		-- upvalues: v3 (copy), v7 (copy), p2 (copy), UserAgreementsCounterNames (copy)
		v3:warning(string.format("Url: %s, Status: %s, isJSONValid: %s", v7, tostring(p4.HttpError), (tostring(p4.isJSONValid))))

		if p2 then
			p2.Diag:reportCounter(UserAgreementsCounterNames.FetchAgreementsHttpRequestFailure, 1)
			p2.InfluxDb:reportSeries(script.Name, {
				url = v7,
				statusCode = p4.StatusCode,
				errorMessage = p4.Body
			}, game:GetFastInt("LuaFetchUpdatedUserAgreementsErrorsThrottling"))
		end
	end)
end
