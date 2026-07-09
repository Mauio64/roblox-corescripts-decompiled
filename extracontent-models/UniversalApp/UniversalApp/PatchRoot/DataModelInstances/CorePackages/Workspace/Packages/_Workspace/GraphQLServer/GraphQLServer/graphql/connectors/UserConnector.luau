local Players = game:GetService("Players")
local Parent = script:FindFirstAncestor("GraphQLServer").Parent

require(Parent.LuauPolyfill)

local UrlBuilder = require(Parent.UrlBuilder).UrlBuilder
local UrlBase = require(Parent.UrlBuilder).UrlBase

require(script.Parent.Parent.generatedTypes)

local Promise = require(Parent.Promise)
local GraphQLError = require(Parent.GraphQL).GraphQLError
local fetch = require(Parent.Fetch).fetch
local Response = require(Parent.Fetch).Response
local t1 = {}
local v10 = UrlBuilder.new({
	path = "users/{id}",
	base = UrlBase.new("users", 1)
})

local function findUserById(s1: string, p1) -- line: 23
	-- upvalues: fetch (copy), Promise (copy), v10 (copy), Response (copy), GraphQLError (copy)
	local v14 = p1 or fetch

	return Promise.new(function(resolve, reject) -- line: 25
		-- upvalues: v10 (copy), s1 (copy), v14 (copy), Response (copy), GraphQLError (copy)
		local v21 = v10({
			id = s1
		})
		local v22 = v14(v21, {
			method = "GET"
		}):catch(function() -- line: 33
			-- upvalues: Response (copy)
			return Response.error()
		end):expect()

		if not v22.ok then
			reject(GraphQLError.new(string.format("Failed to find user matching id: %s.", s1)))

			return
		end

		local v23 = v22:json():catch(function() -- line: 45
			return nil
		end):expect()

		if not v23 then
			reject(GraphQLError.new(string.format("Failed to decode HTTP response as JSON for user matching id: %s.", s1)))

			return
		end

		resolve({
			id = tostring(v23.id),
			displayName = v23.displayName
		})
	end)
end

t1.findUserById = findUserById

function t1.findMe(p2, p3) -- line: 66
	-- upvalues: Players (copy), Promise (copy), GraphQLError (copy), findUserById (copy)
	local v17 = p3 or Players.LocalPlayer

	if not v17 then
		return Promise.reject(GraphQLError.new("LocalPlayer not found"))
	end

	local UserId = v17.UserId

	return findUserById(tostring(UserId), p2)
end

return t1
