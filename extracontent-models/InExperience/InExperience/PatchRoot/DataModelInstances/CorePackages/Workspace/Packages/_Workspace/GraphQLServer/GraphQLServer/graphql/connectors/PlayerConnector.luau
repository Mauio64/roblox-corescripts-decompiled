local parent = script:FindFirstAncestor("GraphQLServer").Parent
require(parent.LuauPolyfill)

local Promise = require(parent.Promise)
local GraphQL = require(parent.GraphQL)
local GraphQLError = GraphQL.GraphQLError
local Fetch = require(parent.Fetch)

local fetch = Fetch.fetch
local UrlBuilder = require(parent.UrlBuilder)
local urlBuilder = UrlBuilder.UrlBuilder
local UrlBuilder2 = require(parent.UrlBuilder)
local UrlBase = UrlBuilder2.UrlBase

local v = urlBuilder.new({
	base = UrlBase.new("thumbnails", 1),
	path = "users/avatar-headshot",
	query = { userIds = "{userIds}", size = "48x48", format = "Png", isCircular = "true" }
})
return {
	findAvatarHeadshotById = function(userIds: string, p)
		local v2 = p or fetch
		return Promise.new(function(callback, callback2)
			local expect = v2(v({ userIds = userIds }), { method = "GET" }):expect()

			if not expect.ok then
				callback2(GraphQLError.new(string.format(
					"Http error occurred while trying to fetch avatarHeadshot for user %s.",
					userIds
				)))

				return
			end

			local expect2 = expect:json():catch(function(): nil
				return nil
			end):expect()

			if expect2 then
				callback(expect2.data[1].imageUrl)
			else
				callback2(GraphQLError.new(string.format(
					"Failed to parse avatarHeadshot HttpResponse for user %s.",
					userIds
				)))
			end
		end)
	end
}
