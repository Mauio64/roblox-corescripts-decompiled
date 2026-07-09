local Parent = script:FindFirstAncestor("GenericAbuseReporting").Parent
local HttpService = game:GetService("HttpService")
local Url = require(Parent.Http).Url
local FFlagAddThumbnailSelectorReport = require(Parent.SharedFlags).FFlagAddThumbnailSelectorReport

return function(p1, p2) -- line: 9
	-- upvalues: FFlagAddThumbnailSelectorReport (copy), HttpService (copy), Url (copy)
	if FFlagAddThumbnailSelectorReport and p2 == nil then
		p2 = {}
	end

	local t1 = {
		tags = {}
	}

	for v8, v9 in p2 do
		local v10 = v9

		if typeof(v10) ~= "table" then
			v10 = if not FFlagAddThumbnailSelectorReport then { (tostring(v10)) } else tostring(v10):split(",")
		end

		local t2 = {}

		for _, v13 in v10 do
			table.insert(t2, {
				data = tostring(v13)
			})
		end

		t1.tags[v8] = {
			valueList = t2
		}
	end

	local ok, result = pcall(function() -- line: 46
		-- upvalues: HttpService (copy), t1 (copy)
		return HttpService:JSONEncode(t1)
	end)

	if not ok then
		warn("Failed to encode report data")
	end

	return p1(Url.APIS_URL .. "abuse-reporting/v2/abuse-report", "POST", {
		postBody = result
	})
end
