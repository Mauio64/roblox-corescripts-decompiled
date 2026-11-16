local GraphQLServer = script:FindFirstAncestor("GraphQLServer")

require(GraphQLServer.Parent.LuauPolyfill)

require(GraphQLServer.graphql.generatedTypes)

local Promise = require(GraphQLServer.Parent.Promise)
local GraphQL = require(GraphQLServer.Parent.GraphQL)
local GraphQLError = GraphQL.GraphQLError
local Fetch = require(GraphQLServer.Parent.Fetch)
local fetch = Fetch.fetch

local Response = Fetch.Response
local UrlBuilder = require(GraphQLServer.Parent.UrlBuilder)
local urlBuilder = UrlBuilder.UrlBuilder
local UrlBuilder2 = require(GraphQLServer.Parent.UrlBuilder)
local UrlBase = UrlBuilder2.UrlBase

local v = urlBuilder.fromString("games:games?universeIds={universeIds}")
local v2 = urlBuilder.new({ base = UrlBase.new("games", 2), path = "games/{universeId}/media" })
local ExperienceConnector = {}

function ExperienceConnector.findExperienceDetailsByUniverseId(universeIds: string, p)
	local v3 = p or fetch
	return Promise.new(function(callback, callback2)
		local expect = v3(v({ universeIds = universeIds }), { method = "GET" }):catch(function()
			return Response.error()
		end):expect()

		if not expect.ok then
			callback2(GraphQLError.new(string.format("Failed to find experience for universeId: %s.", universeIds)))
			return
		end

		local expect2 = expect:json():catch(function(): nil
			return nil
		end):expect()

		if expect2 then
			callback(expect2.data[1])
		else
			callback2(GraphQLError.new(string.format(
				"Failed to decode HTTP response as JSON for experience with universeId: %s.",
				universeIds
			)))
		end
	end)
end

function ExperienceConnector.findExperienceMediaByUniverseId(universeId: string, p)
	local v3 = p or fetch
	return Promise.new(function(callback, callback2)
		local expect = v3(v2({ universeId = universeId }), { method = "GET" }):catch(function()
			return Response.error()
		end):expect()

		if not expect.ok then
			callback2(GraphQLError.new(string.format("Failed to find experience media for universeId: %s.", universeId)))
			return
		end

		local expect2 = expect:json():catch(function(): nil
			return nil
		end):expect()

		if expect2 then
			callback(expect2.data)
		else
			callback2(GraphQLError.new(string.format(
				"Failed to decode HTTP response as JSON for experience media for universeId: %s.",
				universeId
			)))
		end
	end)
end

return ExperienceConnector
