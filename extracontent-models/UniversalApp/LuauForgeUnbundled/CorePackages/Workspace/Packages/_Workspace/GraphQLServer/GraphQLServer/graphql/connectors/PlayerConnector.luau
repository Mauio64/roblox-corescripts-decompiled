require("@game/CorePackages/Workspace/Packages/_Workspace/GraphQLServer/LuauPolyfill")

local Promise = require("@game/CorePackages/Workspace/Packages/_Workspace/GraphQLServer/Promise")
local graphQLError = require("@game/CorePackages/Workspace/Packages/_Workspace/GraphQLServer/GraphQL").GraphQLError
local fetch = require("@game/CorePackages/Workspace/Packages/_Workspace/GraphQLServer/Fetch").fetch
local urlBuilder = require("@game/CorePackages/Workspace/Packages/_Workspace/GraphQLServer/UrlBuilder").UrlBuilder
local urlBase = require("@game/CorePackages/Workspace/Packages/_Workspace/GraphQLServer/UrlBuilder").UrlBase

local v6 = urlBuilder.new({
	base = urlBase.new("thumbnails", 1),
	path = "users/avatar-headshot",
	query = {
		userIds = "{userIds}",
		size = "48x48",
		format = "Png",
		isCircular = "true"
	}
})
return {
	findAvatarHeadshotById = function(p2, p3)
		local v7 = p3 or fetch
		return Promise.new(function(callback, callback2)
			local expect = v7(v6({ userIds = p2 }), { method = "GET" }):expect()

			if not expect.ok then
				callback2(graphQLError.new(string.format(
					"Http error occurred while trying to fetch avatarHeadshot for user %s.",
					p2
				)))

				return
			end

			local expect2 = expect:json():catch(function(): nil
				return nil
			end):expect()

			if expect2 then
				callback(expect2.data[1].imageUrl)
			else
				callback2(graphQLError.new(string.format(
					"Failed to parse avatarHeadshot HttpResponse for user %s.",
					p2
				)))
			end
		end)
	end
}
