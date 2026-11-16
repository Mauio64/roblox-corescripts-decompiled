local parent = script:FindFirstAncestor("GenericAbuseReporting").Parent
local HttpService = game:GetService("HttpService")

local Http = require(parent.Http)
local Url = Http.Url

return function(callback, p)
	local success, result = pcall(function()
		return HttpService:JSONEncode(p)
	end)

	if not success then
		warn("Failed to encode v1 report body")
	end

	return callback(Url.APIS_URL .. "abuse-reporting/v1/abuse-report", "POST", { postBody = result })
end
