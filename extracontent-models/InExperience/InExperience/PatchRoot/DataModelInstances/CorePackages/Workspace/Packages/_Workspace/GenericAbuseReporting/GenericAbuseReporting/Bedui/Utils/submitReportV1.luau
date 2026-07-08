local Parent = script:FindFirstAncestor("GenericAbuseReporting").Parent
local HttpService = game:GetService("HttpService")
local Url = require(Parent.Http).Url

return function(p1, p2) -- line: 10
	-- upvalues: HttpService (copy), Url (copy)
	local ok, result = pcall(function() -- line: 11
		-- upvalues: HttpService (copy), p2 (copy)
		return HttpService:JSONEncode(p2)
	end)

	if not ok then
		warn("Failed to encode v1 report body")
	end

	return p1(Url.APIS_URL .. "abuse-reporting/v1/abuse-report", "POST", {
		postBody = result
	})
end
