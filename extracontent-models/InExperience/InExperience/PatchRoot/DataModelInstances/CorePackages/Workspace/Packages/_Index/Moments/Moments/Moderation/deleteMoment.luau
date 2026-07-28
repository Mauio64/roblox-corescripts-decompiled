local Moments = script:FindFirstAncestor("Moments")
local MomentsParent = Moments.Parent
local Http = require(MomentsParent.Http)
local HttpClient = require(MomentsParent.HttpClient)
local Promise = require(MomentsParent.Promise)
local SharedFlags = require(MomentsParent.SharedFlags)
local GetFFlagMomentsFixDelete = require(Moments.Flags.GetFFlagMomentsFixDelete)
local FFlagMomentsPassFeedItemIdToBackendApis = SharedFlags.FFlagMomentsPassFeedItemIdToBackendApis
local v9 = Http.Url.APIS_URL .. "content-captures-api/v2/moments/"
local v10 = Http.Url.APIS_URL .. "/posts-api/v1/content-posts/delete/"

local function deleteMoment(s1: string, p1, s2: string?) -- line: 29
	-- upvalues: FFlagMomentsPassFeedItemIdToBackendApis (copy), Promise (copy), GetFFlagMomentsFixDelete (copy), HttpClient (copy), v10 (copy), v9 (copy)
	if FFlagMomentsPassFeedItemIdToBackendApis then
		if s2 == nil or s2 == "" then
			return Promise.reject("feedItemId is required to delete a Moment")
		end

		s1 = "by-feed-item/" .. s2
	elseif not GetFFlagMomentsFixDelete() then
		return HttpClient.asPromise(HttpClient.fetch({
			method = "POST",
			analyticsKey = "moments.delete-moment",
			url = v10 .. s1,
			body = {},
			network = p1,
			decode = function(_) -- line: 44
				return {
					ok = true
				}
			end
		}))
	end

	return HttpClient.asPromise(HttpClient.fetch({
		method = "DELETE",
		analyticsKey = "moments.delete-moment",
		url = v9 .. s1,
		network = p1,
		decode = function(_) -- line: 55
			return {
				ok = true
			}
		end
	}))
end

return deleteMoment
