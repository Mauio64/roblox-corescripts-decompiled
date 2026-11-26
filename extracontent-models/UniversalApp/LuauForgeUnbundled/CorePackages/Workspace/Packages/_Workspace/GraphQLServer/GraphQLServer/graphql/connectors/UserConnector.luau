local Players = game:GetService("Players")

require("@game/CorePackages/Workspace/Packages/_Workspace/GraphQLServer/LuauPolyfill")

local urlBuilder = require("@game/CorePackages/Workspace/Packages/_Workspace/GraphQLServer/UrlBuilder").UrlBuilder
local urlBase = require("@game/CorePackages/Workspace/Packages/_Workspace/GraphQLServer/UrlBuilder").UrlBase
require("@game/CorePackages/Workspace/Packages/_Workspace/GraphQLServer/GraphQLServer/graphql/generatedTypes")

local Promise = require("@game/CorePackages/Workspace/Packages/_Workspace/GraphQLServer/Promise")
local graphQLError = require("@game/CorePackages/Workspace/Packages/_Workspace/GraphQLServer/GraphQL").GraphQLError
local fetch = require("@game/CorePackages/Workspace/Packages/_Workspace/GraphQLServer/Fetch").fetch

local response = require("@game/CorePackages/Workspace/Packages/_Workspace/GraphQLServer/Fetch").Response

local v6 = urlBuilder.new({ base = urlBase.new("users", 1), path = "users/{id}" })

local function findUserById(p2, p3)
	local v7 = p3 or fetch
	return Promise.new(function(callback, callback2)
		local expect = v7(v6({ id = p2 }), { method = "GET" }):catch(function()
			return response.error()
		end):expect()

		if not expect.ok then
			callback2(graphQLError.new(string.format("Failed to find user matching id: %s.", p2)))
			return
		end

		local expect2 = expect:json():catch(function(): nil
			return nil
		end):expect()

		if expect2 then
			callback({ id = tostring(expect2.id), displayName = expect2.displayName })
		else
			callback2(graphQLError.new(string.format(
				"Failed to decode HTTP response as JSON for user matching id: %s.",
				p2
			)))
		end
	end)
end

return {
	["findUserById"] = findUserById,
	findMe = function(p2, p3)
		local v7 = p3 or Players.LocalPlayer

		if not v7 then
			return Promise.reject(graphQLError.new("LocalPlayer not found"))
		end

		local userId = v7.UserId
		return findUserById(tostring(userId), p2)
	end
}
