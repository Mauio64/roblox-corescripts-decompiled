local HttpService = game:GetService("HttpService")

local userAgreementErrorCodes = require("@luauforge/bundled/fOd").UserAgreementErrorCodes
local Url = require("@game/CoreGui/RobloxGui/Modules/InGameMenu/Network/Url")
local logging = require("@game/CorePackages/Workspace/Packages/AppCommonLib").Logging

return function(callback, list, callback2)
	local v5 = Url.APIS_URL .. "user-agreements/v1/acceptances"
	local v6 = {}

	for i, item in ipairs(list) do
		table.insert(v6, { agreementId = item.id })
	end

	return callback(v5, "POST", {
		postBody = HttpService:JSONEncode({ acceptances = v6 })
	}):andThen(function(p2)
		logging.warn(string.format("Url: %s, responseCode: %s", v5, (tostring(p2.responseCode))))

		if p2.responseCode == 200 then
			local responseBody = p2.responseBody

			if responseBody.results and not (#responseBody.results <= 0) then
				local v7 = userAgreementErrorCodes.NoError

				for i, result in ipairs(responseBody.results) do
					if not (result.errorCode ~= userAgreementErrorCodes.NoError and result.errorCode ~= userAgreementErrorCodes.ItemAlreadyExists) then
						continue
					end

					logging.warn(string.format(
						"errorCode: %s, agreementId: %s, message: %s",
						tostring(result.errorCode),
						result.agreementId,
						result.message
					))

					if v7 == userAgreementErrorCodes.NoError then
						v7 = result.errorCode
					end

					if result.errorCode == userAgreementErrorCodes.InvalidState then
						v7 = userAgreementErrorCodes.InvalidState
					end
				end

				if callback2 then
					callback2(v7)
				end
			elseif callback2 then
				callback2(userAgreementErrorCodes.NoError)
			end
		elseif callback2 then
			callback2(userAgreementErrorCodes.Exception)
		end
	end, function(p2)
		local httpError = tostring(p2.HttpError)
		local isJSONValid = tostring(p2.isJSONValid)
		logging.warn(string.format("Url: %s, Status: %s, isJSONValid: %s", v5, httpError, isJSONValid))

		if callback2 then
			callback2(userAgreementErrorCodes.Exception)
		end
	end)
end
