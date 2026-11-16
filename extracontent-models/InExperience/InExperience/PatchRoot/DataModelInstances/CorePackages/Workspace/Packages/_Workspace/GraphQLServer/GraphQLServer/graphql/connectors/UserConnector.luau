local Players = game:GetService("Players")
local parent = script:FindFirstAncestor("GraphQLServer").Parent
require(parent.LuauPolyfill)

local UrlBuilder = require(parent.UrlBuilder)
local urlBuilder = UrlBuilder.UrlBuilder
local UrlBuilder2 = require(parent.UrlBuilder)
local UrlBase = UrlBuilder2.UrlBase
require(script.Parent.Parent.generatedTypes)

local Promise = require(parent.Promise)
local GraphQL = require(parent.GraphQL)
local GraphQLError = GraphQL.GraphQLError
local Fetch = require(parent.Fetch)
local fetch = Fetch.fetch

local Fetch2 = require(parent.Fetch)
local Response = Fetch2.Response

local v = urlBuilder.new({ base = UrlBase.new("users", 1), path = "users/{id}" })

local function findUserById(userId: string, p)
	local v2 = p or fetch
	return Promise.new(function(callback, callback2)
		local expect = v2(v({ id = userId }), { method = "GET" }):catch(function()
			return Response.error()
		end):expect()

		if not expect.ok then
			callback2(GraphQLError.new(string.format("Failed to find user matching id: %s.", userId)))
			return
		end

		local expect2 = expect:json():catch(function(): nil
			return nil
		end):expect()

		if expect2 then
			callback({ id = tostring(expect2.id), displayName = expect2.displayName })
		else
			callback2(GraphQLError.new(string.format(
				"Failed to decode HTTP response as JSON for user matching id: %s.",
				userId
			)))
		end
	end)
end

return {
	["findUserById"] = findUserById,
	findMe = function(p, p2)
		local v2 = p2 or Players.LocalPlayer

		if v2 then
			return findUserById(tostring(v2.UserId), p)
		end

		return Promise.reject(GraphQLError.new("LocalPlayer not found"))
	end
}
