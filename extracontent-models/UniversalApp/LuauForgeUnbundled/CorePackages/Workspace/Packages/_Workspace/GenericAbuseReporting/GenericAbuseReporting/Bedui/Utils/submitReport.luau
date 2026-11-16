local HttpService = game:GetService("HttpService")

local url = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericAbuseReporting/Http").Url

local fFlagAddThumbnailSelectorReport = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericAbuseReporting/SharedFlags").FFlagAddThumbnailSelectorReport

return function(callback, p2)
	local v5 = { tags = {} }

	for k, v6 in fFlagAddThumbnailSelectorReport and p2 == nil and {} or p2 do
		if typeof(v6) ~= "table" then
			if fFlagAddThumbnailSelectorReport then
				v6 = tostring(v6):split(",")
			else
				v6 = { (tostring(v6)) }
			end
		end

		local v7 = {}

		for k2, v8 in v6 do
			table.insert(v7, { data = tostring(v8) })
		end

		v5.tags[k] = { valueList = v7 }
	end

	local success, result = pcall(function()
		return HttpService:JSONEncode(v5)
	end)

	if not success then
		warn("Failed to encode report data")
	end

	return callback(url.APIS_URL .. "abuse-reporting/v2/abuse-report", "POST", {
		postBody = result
	})
end
