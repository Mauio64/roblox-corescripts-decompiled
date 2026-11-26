local HttpClient = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/HttpClient")
local Http = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/Http")
local UrlBuilder = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/UrlBuilder")

require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/FriendsRequests/FriendsRequestsStoreTypes")

local fFlagAddFriendsSessionId = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/SharedFlags").FFlagAddFriendsSessionId
local FFlagFriendsRequestsRemoveRedundantParams = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/Flags/FFlagFriendsRequestsRemoveRedundantParams")

local fetch = HttpClient.fetch
local asPromise = HttpClient.asPromise

return function(p2, p3, sessionId)
	local addQueryString = UrlBuilder.UrlBuilder.addQueryString
	local formatted = `{module2.Url.FRIEND_URL}/my/friends/requests`
	local v5 = {
		sortOrder = not FFlagFriendsRequestsRemoveRedundantParams and "Desc" or nil,
		fetchMutualFriends = not FFlagFriendsRequestsRemoveRedundantParams and "true" or nil,
		limit = p3,
		cursor = p2,
		uprankUnseen = "true",
		sessionId = nil
	}

	if not fFlagAddFriendsSessionId then
		sessionId = nil
	end

	v5.sessionId = sessionId
	return asPromise((fetch({
		method = "GET",
		url = addQueryString(formatted, v5),
		analyticsKey = "friends.get-friend-requests",
		decode = function(p4)
			return p4
		end
	})))
end
