local Http = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/Http")
local HttpClient = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/HttpClient")
local Promise = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/Promise")

local v5 = Http.Url.APIS_URL .. "content-captures-api/v2/moments/"

local function deleteMoment(p2, p3)
	if p2 == nil or p2 == "" then
		return Promise.reject("feedItemId is required to delete a Moment")
	end

	local v6 = "by-feed-item/" .. p2

	return HttpClient.asPromise(HttpClient.fetch({
		method = "DELETE",
		url = v5 .. v6,
		analyticsKey = "moments.delete-moment",
		network = p3,
		decode = function(p4)
			return { ok = true }
		end
	}))
end

return deleteMoment
