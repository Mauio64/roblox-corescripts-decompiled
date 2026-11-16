local url = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericAbuseReporting/Http").Url

return {
	blockUser = function(callback, p2)
		return callback(`{url.APIS_URL}user-blocking-api/v1/users/{p2}/block-user`, "POST")
	end,
	unblockUser = function(callback, p2)
		return callback(`{url.APIS_URL}user-blocking-api/v1/users/{p2}/unblock-user`, "POST")
	end,
	isBlockedUser = function(callback, p2)
		return callback(`{url.APIS_URL}user-blocking-api/v1/users/{p2}/is-blocked`, "GET")
	end
}
