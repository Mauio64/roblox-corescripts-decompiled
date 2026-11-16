local parent = script:FindFirstAncestor("Moments").Parent

local Http = require(parent.Http)
local HttpClient = require(parent.HttpClient)
local Promise = require(parent.Promise)

local v = Http.Url.APIS_URL .. "content-captures-api/v2/moments/"

local function deleteMoment(p: string?, network)
	if p == nil or p == "" then
		return Promise.reject("feedItemId is required to delete a Moment")
	end

	local v2 = "by-feed-item/" .. p

	return HttpClient.asPromise(HttpClient.fetch({
		method = "DELETE",
		url = v .. v2,
		analyticsKey = "moments.delete-moment",
		network = network,
		decode = function(_)
			return { ok = true }
		end
	}))
end

return deleteMoment
