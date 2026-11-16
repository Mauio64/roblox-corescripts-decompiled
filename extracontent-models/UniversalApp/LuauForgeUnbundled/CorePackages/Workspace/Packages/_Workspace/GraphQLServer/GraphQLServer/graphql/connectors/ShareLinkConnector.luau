local HttpService = game:GetService("HttpService")

require("@game/CorePackages/Workspace/Packages/_Workspace/GraphQLServer/LuauPolyfill")
local UrlBuilder = require("@game/CorePackages/Workspace/Packages/_Workspace/GraphQLServer/UrlBuilder")
local Promise = require("@game/CorePackages/Workspace/Packages/_Workspace/GraphQLServer/Promise")
local Fetch = require("@game/CorePackages/Workspace/Packages/_Workspace/GraphQLServer/Fetch")

local urlBuilder = UrlBuilder.UrlBuilder
local urlBase = UrlBuilder.UrlBase

local graphQLError = require("@game/CorePackages/Workspace/Packages/_Workspace/GraphQLServer/GraphQL").GraphQLError
local fetch = Fetch.fetch

local response = Fetch.Response
require("@game/CorePackages/Workspace/Packages/_Workspace/GraphQLServer/GraphQLServer/graphql/generatedTypes")

local v5 = urlBuilder.new({
	base = urlBase.APIS,
	path = "sharelinks/v1/get-or-create-link"
})()

return {
	fetchShareLink = function(p2, p3)
		local v6 = p3 or fetch
		local jsonEncode = HttpService:JSONEncode(p2.data)

		local jsonEncode2 = HttpService:JSONEncode({
			linkType = p2.linkType,
			data = jsonEncode
		})

		return Promise.new(function(callback, callback2)
			local expect = v6(v5, {
				body = jsonEncode2,
				method = "POST",
				headers = {
					["Content-Type"] = "application/json",
					Accept = "application/json"
				}
			}):catch(function(p4)
				local v7 = response.error()
				v7.statusText = p4.message
				return v7
			end):expect()

			if expect.ok then
				local expect2 = expect:json():catch(function(): nil
					return nil
				end):expect()

				if expect then
					callback(expect2)
				else
					callback2(graphQLError.new(`Failed to decode HTTP response as JSON for share link matching type: {type}`))
				end
			else
				print(expect.statusText .. " " .. expect.status)
				callback2(graphQLError.new(expect.statusText, nil, nil, nil, nil, {
					extensions = {
						status = expect.status,
						statusText = expect.statusText
					}
				}))
			end
		end)
	end
}
