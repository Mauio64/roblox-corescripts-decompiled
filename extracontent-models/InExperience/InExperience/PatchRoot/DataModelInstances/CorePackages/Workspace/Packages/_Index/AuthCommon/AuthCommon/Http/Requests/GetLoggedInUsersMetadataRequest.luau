local parent = script:FindFirstAncestor("AuthCommon").Parent

local HttpService = game:GetService("HttpService")

local UrlBuilder = require(parent.UrlBuilder)
local urlBuilder = UrlBuilder.UrlBuilder

return function(callback, encrypted_users_data_blob)
	local v = urlBuilder.fromString("apis:account-switcher/v1/getLoggedInUsersMetadata")
	local jsonEncode = HttpService:JSONEncode({
		encrypted_users_data_blob = encrypted_users_data_blob,
		remove_invalid_active_user = false
	})

	return callback(v(), "POST", { postBody = jsonEncode })
end
