local DataHydration = script:FindFirstAncestor("DataHydration")
local parent = DataHydration.Parent

local HttpClient = require(parent.HttpClient)
local Http = require(parent.Http)
local UrlBuilder = require(parent.UrlBuilder)

require(script.Parent.Parent.FriendsRequestsStoreTypes)

local SharedFlags = require(parent.SharedFlags)
local FFlagAddFriendsSessionId = SharedFlags.FFlagAddFriendsSessionId
local FFlagFriendsRequestsRemoveRedundantParams = require(DataHydration.Flags.FFlagFriendsRequestsRemoveRedundantParams)

local fetch = HttpClient.fetch
local asPromise = HttpClient.asPromise

return function(cursor: string?, limit: number?, sessionId: string?)
	local addQueryString = UrlBuilder.UrlBuilder.addQueryString
	local formatted = `{Http.Url.FRIEND_URL}/my/friends/requests`
	local v = {
		sortOrder = not FFlagFriendsRequestsRemoveRedundantParams and "Desc" or nil,
		fetchMutualFriends = not FFlagFriendsRequestsRemoveRedundantParams and "true" or nil,
		limit = limit,
		cursor = cursor,
		uprankUnseen = "true",
		sessionId = nil
	}

	if not FFlagAddFriendsSessionId then
		sessionId = nil
	end

	v.sessionId = sessionId
	return asPromise((fetch({
		method = "GET",
		url = addQueryString(formatted, v),
		analyticsKey = "friends.get-friend-requests",
		decode = function(p)
			return p
		end
	})))
end
