local GraphQLServer = script:FindFirstAncestor("GraphQLServer")

require(GraphQLServer.Parent.LuauPolyfill)
require(GraphQLServer.graphql.generatedTypes)

local Promise = require(GraphQLServer.Parent.Promise)
local GraphQLError = require(GraphQLServer.Parent.GraphQL).GraphQLError
local Fetch = require(GraphQLServer.Parent.Fetch)
local fetch = Fetch.fetch
local Response = Fetch.Response
local UrlBuilder = require(GraphQLServer.Parent.UrlBuilder).UrlBuilder
local UrlBase = require(GraphQLServer.Parent.UrlBuilder).UrlBase
local t1 = {}
local v10 = UrlBuilder.fromString("games:games?universeIds={universeIds}")
local v11 = UrlBuilder.new({
	path = "games/{universeId}/media",
	base = UrlBase.new("games", 2)
})

function t1.findExperienceDetailsByUniverseId(s1: string, p1) -- line: 27
	-- upvalues: fetch (copy), Promise (copy), v10 (copy), Response (copy), GraphQLError (copy)
	local v14 = p1 or fetch

	return Promise.new(function(resolve, reject) -- line: 30
		-- upvalues: v10 (copy), s1 (copy), v14 (copy), Response (copy), GraphQLError (copy)
		local v20 = v10({
			universeIds = s1
		})
		local v21 = v14(v20, {
			method = "GET"
		}):catch(function() -- line: 33
			-- upvalues: Response (copy)
			return Response.error()
		end):expect()

		if not v21.ok then
			reject(GraphQLError.new(string.format("Failed to find experience for universeId: %s.", s1)))

			return
		end

		local v22 = v21:json():catch(function() -- line: 44
			return nil
		end):expect()

		if not v22 then
			reject(GraphQLError.new(string.format("Failed to decode HTTP response as JSON for experience with universeId: %s.", s1)))

			return
		end

		resolve(v22.data[1])
	end)
end
function t1.findExperienceMediaByUniverseId(s2: string, p2) -- line: 67
	-- upvalues: fetch (copy), Promise (copy), v11 (copy), Response (copy), GraphQLError (copy)
	local v17 = p2 or fetch

	return Promise.new(function(resolve, reject) -- line: 70
		-- upvalues: v11 (copy), s2 (copy), v17 (copy), Response (copy), GraphQLError (copy)
		local v25 = v11({
			universeId = s2
		})
		local v26 = v17(v25, {
			method = "GET"
		}):catch(function() -- line: 73
			-- upvalues: Response (copy)
			return Response.error()
		end):expect()

		if not v26.ok then
			reject(GraphQLError.new(string.format("Failed to find experience media for universeId: %s.", s2)))

			return
		end

		local v27 = v26:json():catch(function() -- line: 84
			return nil
		end):expect()

		if not v27 then
			reject(GraphQLError.new(string.format("Failed to decode HTTP response as JSON for experience media for universeId: %s.", s2)))

			return
		end

		resolve(v27.data)
	end)
end

return t1
