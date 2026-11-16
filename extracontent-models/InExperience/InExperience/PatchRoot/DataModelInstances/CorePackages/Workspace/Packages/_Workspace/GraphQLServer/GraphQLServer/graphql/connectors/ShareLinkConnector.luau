local HttpService = game:GetService("HttpService")
local parent = script:FindFirstAncestor("GraphQLServer").Parent

require(parent.LuauPolyfill)
local UrlBuilder = require(parent.UrlBuilder)
local Promise = require(parent.Promise)
local Fetch = require(parent.Fetch)

local urlBuilder = UrlBuilder.UrlBuilder
local UrlBase = UrlBuilder.UrlBase

local GraphQL = require(parent.GraphQL)
local GraphQLError = GraphQL.GraphQLError
local fetch = Fetch.fetch

local Response = Fetch.Response
require(script.Parent.Parent.generatedTypes)

local v = urlBuilder.new({ base = UrlBase.APIS, path = "sharelinks/v1/get-or-create-link" })()

return {
	fetchShareLink = function(p, p2)
		local v2 = p2 or fetch
		local jsonEncode = HttpService:JSONEncode(p.data)

		local jsonEncode2 = HttpService:JSONEncode({ linkType = p.linkType, data = jsonEncode })

		return Promise.new(function(callback, callback2)
			local expect = v2(v, {
				body = jsonEncode2,
				method = "POST",
				headers = { ["Content-Type"] = "application/json", Accept = "application/json" }
			}):catch(function(p3)
				local v3 = Response.error()
				v3.statusText = p3.message
				return v3
			end):expect()

			if expect.ok then
				local expect2 = expect:json():catch(function(): nil
					return nil
				end):expect()

				if expect then
					callback(expect2)
				else
					callback2(GraphQLError.new(`Failed to decode HTTP response as JSON for share link matching type: {type}`))
				end
			else
				print(expect.statusText .. " " .. expect.status)
				callback2(GraphQLError.new(expect.statusText, nil, nil, nil, nil, {
					extensions = { status = expect.status, statusText = expect.statusText }
				}))
			end
		end)
	end
}
