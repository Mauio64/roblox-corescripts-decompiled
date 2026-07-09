local Modules = game:GetService("CoreGui").RobloxGui.Modules
local HttpService = game:GetService("HttpService")
local CorePackages = game:GetService("CorePackages")
local UserAgreementErrorCodes = require(CorePackages.Workspace.Packages.UserAgreements).UserAgreementErrorCodes
local Url = require(Modules.LuaApp.Http.Url)
local Logging = require(CorePackages.Workspace.Packages.AppCommonLib).Logging

return function(p1, p2, p3) -- line: 10
	-- upvalues: Url (copy), HttpService (copy), Logging (copy), UserAgreementErrorCodes (copy)
	local v10 = Url.APIS_URL .. "user-agreements/v1/acceptances"
	local t1 = {}

	for _, v in ipairs(p2) do
		table.insert(t1, {
			agreementId = v.id
		})
	end

	return p1(v10, "POST", {
		postBody = HttpService:JSONEncode({
			acceptances = t1
		})
	}):andThen(function(p4) -- line: 18
		-- upvalues: Logging (copy), v10 (copy), p3 (copy), UserAgreementErrorCodes (copy)
		Logging.warn(string.format("Url: %s, responseCode: %s", v10, (tostring(p4.responseCode))))

		if p4.responseCode ~= 200 then
			if p3 then
				p3(UserAgreementErrorCodes.Exception)
			end

			return
		end

		local responseBody = p4.responseBody

		if not responseBody.results or #responseBody.results <= 0 then
			if p3 then
				p3(UserAgreementErrorCodes.NoError)
			end

			return
		end

		local NoError = UserAgreementErrorCodes.NoError

		for _, v in ipairs(responseBody.results) do
			if v.errorCode ~= UserAgreementErrorCodes.NoError and v.errorCode ~= UserAgreementErrorCodes.ItemAlreadyExists then
				Logging.warn(string.format("errorCode: %s, agreementId: %s, message: %s", tostring(v.errorCode), v.agreementId, v.message))

				if NoError == UserAgreementErrorCodes.NoError then
					NoError = v.errorCode
				end

				if v.errorCode == UserAgreementErrorCodes.InvalidState then
					NoError = UserAgreementErrorCodes.InvalidState
				end
			end
		end

		if p3 then
			p3(NoError)
		end
	end, function(p5) -- line: 62
		-- upvalues: Logging (copy), v10 (copy), p3 (copy), UserAgreementErrorCodes (copy)
		local str = tostring(p5.HttpError)
		local str2 = tostring(p5.isJSONValid)

		Logging.warn(string.format("Url: %s, Status: %s, isJSONValid: %s", v10, str, str2))

		if p3 then
			p3(UserAgreementErrorCodes.Exception)
		end
	end)
end
