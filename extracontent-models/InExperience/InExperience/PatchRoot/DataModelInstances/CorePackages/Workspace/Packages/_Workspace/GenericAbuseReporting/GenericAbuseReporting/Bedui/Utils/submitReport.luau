local parent = script:FindFirstAncestor("GenericAbuseReporting").Parent
local HttpService = game:GetService("HttpService")

local Http = require(parent.Http)
local Url = Http.Url

local SharedFlags = require(parent.SharedFlags)
local FFlagAddThumbnailSelectorReport = SharedFlags.FFlagAddThumbnailSelectorReport

return function(callback, p)
	local v = { tags = {} }

	for k, v2 in FFlagAddThumbnailSelectorReport and p == nil and {} or p do
		if typeof(v2) ~= "table" then
			if FFlagAddThumbnailSelectorReport then
				v2 = tostring(v2):split(",")
			else
				v2 = { (tostring(v2)) }
			end
		end

		local valueList = {}

		for _, v3 in v2 do
			table.insert(valueList, { data = tostring(v3) })
		end

		v.tags[k] = { valueList = valueList }
	end

	local success, result = pcall(function()
		return HttpService:JSONEncode(v)
	end)

	if not success then
		warn("Failed to encode report data")
	end

	return callback(Url.APIS_URL .. "abuse-reporting/v2/abuse-report", "POST", { postBody = result })
end
