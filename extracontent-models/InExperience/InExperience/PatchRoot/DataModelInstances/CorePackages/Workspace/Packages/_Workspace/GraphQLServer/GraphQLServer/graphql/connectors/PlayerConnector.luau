local Parent = script:FindFirstAncestor("GraphQLServer").Parent

require(Parent.LuauPolyfill)

local Promise = require(Parent.Promise)
local GraphQLError = require(Parent.GraphQL).GraphQLError
local fetch = require(Parent.Fetch).fetch
local UrlBuilder = require(Parent.UrlBuilder).UrlBuilder
local UrlBase = require(Parent.UrlBuilder).UrlBase
local t1 = {}
local v8 = UrlBuilder.new({
	path = "users/avatar-headshot",
	base = UrlBase.new("thumbnails", 1),
	query = {
		userIds = "{userIds}",
		size = "48x48",
		format = "Png",
		isCircular = "true"
	}
})

function t1.findAvatarHeadshotById(s1: string, p1) -- line: 25
	-- upvalues: fetch (copy), Promise (copy), v8 (copy), GraphQLError (copy)
	local v11 = p1 or fetch

	return Promise.new(function(resolve, reject) -- line: 28
		-- upvalues: v8 (copy), s1 (copy), v11 (copy), GraphQLError (copy)
		local v14 = v8({
			userIds = s1
		})
		local v15 = v11(v14, {
			method = "GET"
		}):expect()

		if not v15.ok then
			reject(GraphQLError.new(string.format("Http error occurred while trying to fetch avatarHeadshot for user %s.", s1)))

			return
		end

		local v16 = v15:json():catch(function() -- line: 48
			return nil
		end):expect()

		if not v16 then
			reject(GraphQLError.new(string.format("Failed to parse avatarHeadshot HttpResponse for user %s.", s1)))

			return
		end

		resolve(v16.data[1].imageUrl)
	end)
end

return t1
