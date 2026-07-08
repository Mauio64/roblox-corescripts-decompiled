local Parent = script:FindFirstAncestor("Moments").Parent
local Http = require(Parent.Http)
local HttpClient = require(Parent.HttpClient)
local v4 = Http.Url.APIS_URL .. "content-captures-api/v1/moderate/report"

local function reportMoment(s1: string, p1) -- line: 15
	-- upvalues: HttpClient (copy), v4 (copy)
	return HttpClient.asPromise(HttpClient.fetch({
		method = "POST",
		analyticsKey = "moments.report-moment",
		url = v4,
		body = {
			momentId = s1
		},
		network = p1,
		decode = function(_) -- line: 22
			return {
				ok = true
			}
		end
	}))
end

return reportMoment
