local HttpService = game:GetService("HttpService")

local Promise = require("@game/CorePackages/Workspace/Packages/_Workspace/AuthCommon/Promise")
local url = require("@game/CorePackages/Workspace/Packages/_Workspace/AuthCommon/Http").Url

local function getChangePasswordUrl()
	return string.format("%sv2/user/passwords/change", url.AUTH_URL)
end

return function(callback, p2)
	local jsonEncode = HttpService:JSONEncode({
		currentPassword = nil,
		newPassword = p2
	})
	return callback(string.format("%sv2/user/passwords/change", url.AUTH_URL), "POST", {
		postBody = jsonEncode
	}):andThen(
		function(p3)
			return Promise.resolve(p3)
		end,
		function(p3)
			return Promise.reject(p3)
		end
	)
end
