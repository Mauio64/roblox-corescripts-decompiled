local HttpService = game:GetService("HttpService")

local url = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericAbuseReporting/Http").Url

return function(callback, p2)
	local success, result = pcall(function()
		return HttpService:JSONEncode(p2)
	end)

	if not success then
		warn("Failed to encode v1 report body")
	end

	return callback(url.APIS_URL .. "abuse-reporting/v1/abuse-report", "POST", {
		postBody = result
	})
end
