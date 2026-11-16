local HttpService = game:GetService("HttpService")
local urlBuilder = require("@luauforge/bundled/fDq").UrlBuilder
local module = require("@luauforge/bundled/fDr")

return function(callback, p2, p3, p4)
	local v5 = urlBuilder.fromString(module.GetAccountsListAsPreviousAccountEntries)
	local v6 = {
		postBody = HttpService:JSONEncode({
			encrypted_users_data_blob = p2,
			remove_invalid_active_user = p3
		})
	}

	if p4 then
		if p4.maxRetryCount ~= nil then
			v6.maxRetryCount = p4.maxRetryCount
		end

		if p4.timeout ~= nil then
			v6.timeout = p4.timeout
		end
	end

	return callback(v5(), "POST", v6)
end
