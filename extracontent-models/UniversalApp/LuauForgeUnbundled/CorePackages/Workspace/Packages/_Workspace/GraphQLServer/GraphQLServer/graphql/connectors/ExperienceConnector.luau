require("@game/CorePackages/Workspace/Packages/_Workspace/GraphQLServer/LuauPolyfill")

require("@game/CorePackages/Workspace/Packages/_Workspace/GraphQLServer/GraphQLServer/graphql/generatedTypes")

local Promise = require("@game/CorePackages/Workspace/Packages/_Workspace/GraphQLServer/Promise")
local graphQLError = require("@game/CorePackages/Workspace/Packages/_Workspace/GraphQLServer/GraphQL").GraphQLError
local Fetch = require("@game/CorePackages/Workspace/Packages/_Workspace/GraphQLServer/Fetch")
local fetch = Fetch.fetch

local response = Fetch.Response
local urlBuilder = require("@game/CorePackages/Workspace/Packages/_Workspace/GraphQLServer/UrlBuilder").UrlBuilder
local urlBase = require("@game/CorePackages/Workspace/Packages/_Workspace/GraphQLServer/UrlBuilder").UrlBase

local v6 = urlBuilder.fromString("games:games?universeIds={universeIds}")
local v7 = urlBuilder.new({
	base = urlBase.new("games", 2),
	path = "games/{universeId}/media"
})
return {
	findExperienceDetailsByUniverseId = function(p2, p3)
		local v8 = p3 or fetch
		return Promise.new(function(callback, callback2)
			local expect = v8(v6({ universeIds = p2 }), { method = "GET" }):catch(function()
				return response.error()
			end):expect()

			if not expect.ok then
				callback2(graphQLError.new(string.format(
					"Failed to find experience for universeId: %s.",
					p2
				)))
				return
			end

			local expect2 = expect:json():catch(function(): nil
				return nil
			end):expect()

			if expect2 then
				callback(expect2.data[1])
			else
				callback2(graphQLError.new(string.format(
					"Failed to decode HTTP response as JSON for experience with universeId: %s.",
					p2
				)))
			end
		end)
	end,
	findExperienceMediaByUniverseId = function(p2, p3)
		local v8 = p3 or fetch
		return Promise.new(function(callback, callback2)
			local expect = v8(v7({ universeId = p2 }), { method = "GET" }):catch(function()
				return response.error()
			end):expect()

			if not expect.ok then
				callback2(graphQLError.new(string.format(
					"Failed to find experience media for universeId: %s.",
					p2
				)))
				return
			end

			local expect2 = expect:json():catch(function(): nil
				return nil
			end):expect()

			if expect2 then
				callback(expect2.data)
			else
				callback2(graphQLError.new(string.format(
					"Failed to decode HTTP response as JSON for experience media for universeId: %s.",
					p2
				)))
			end
		end)
	end
}
