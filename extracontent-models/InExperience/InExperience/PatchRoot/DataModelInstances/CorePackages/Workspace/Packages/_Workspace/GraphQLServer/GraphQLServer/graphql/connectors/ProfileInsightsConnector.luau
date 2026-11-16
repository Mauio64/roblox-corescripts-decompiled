local parent = script:FindFirstAncestor("GraphQLServer").Parent
local HttpService = game:GetService("HttpService")

local UrlBuilder = require(parent.UrlBuilder)
local urlBuilder = UrlBuilder.UrlBuilder
local UrlBuilder2 = require(parent.UrlBuilder)
local UrlBase = UrlBuilder2.UrlBase
local Promise = require(parent.Promise)
local GraphQL = require(parent.GraphQL)
local GraphQLError = GraphQL.GraphQLError
local Fetch = require(parent.Fetch)
local Response = Fetch.Response
local Fetch2 = require(parent.Fetch)
local fetch = Fetch2.fetch

require(parent.LuauPolyfill)

require(script.Parent.Parent.generatedTypes)

local SharedFlags = require(parent.SharedFlags)
local FFlagPlayerSearchEnableOnlineFrequents = SharedFlags.FFlagPlayerSearchEnableOnlineFrequents

local v = urlBuilder.new({
	base = UrlBase.APIS,
	path = "profile-insights-api/v1/multiProfileInsights"
})
local ProfileInsightsConnector = {}

function ProfileInsightsConnector.findProfileInsightsByUserIds(userIds, value: number?, rankingStrategy: string?, p)
	local v2 = p or fetch
	return Promise.new(function(callback, callback2)
		local expect = v2(v(), {
			body = HttpService:JSONEncode({
				userIds = userIds,
				count = not rankingStrategy and (value or 2) or nil,
				rankingStrategy = rankingStrategy
			}),
			method = "POST",
			headers = { ["Content-Type"] = "application/json", Accept = "application/json" }
		}):catch(function()
			return Response.error()
		end):expect()

		if not expect.ok then
			callback2(GraphQLError.new(string.format("Failed to fetch profile insights. Error code: %d", expect.status)))

			return
		end

		local expect2 = expect:json():catch(function(): nil
			return nil
		end):expect()

		if expect2 then
			callback(expect2.userInsights)
		else
			callback2(GraphQLError.new(string.format(
				"Failed to decode HTTP response as JSON for profile insights: %s.",
				HttpService:JSONEncode(userIds)
			)))
		end
	end)
end

function ProfileInsightsConnector.findProfileInsightsByUserIdsFeed(userIds, value: number?, pageId: string?, rankingStrategy: string?, p)
	if not FFlagPlayerSearchEnableOnlineFrequents then
		rankingStrategy = nil
	end

	local v2 = p or fetch
	return (Promise.new(function(callback, callback2)
		local expect = v2(v(), {
			body = HttpService:JSONEncode({
				userIds = userIds,
				count = not rankingStrategy and (value or 2) or nil,
				rankingStrategy = rankingStrategy
			}),
			method = "POST",
			headers = { ["Content-Type"] = "application/json", Accept = "application/json" }
		}):catch(function()
			return Response.error()
		end):expect()

		if not expect.ok then
			callback2(GraphQLError.new(string.format("Failed to fetch profile insights. Error code: %d", expect.status)))

			return
		end

		local expect2 = expect:json():catch(function(): nil
			return nil
		end):expect()

		if expect2 then
			callback(expect2.userInsights)
		else
			callback2(GraphQLError.new(string.format(
				"Failed to decode HTTP response as JSON for profile insights: %s.",
				HttpService:JSONEncode(userIds)
			)))
		end
	end):andThen(function(profileInsights)
		return { pageId = pageId, profileInsights = profileInsights }
	end))
end

return ProfileInsightsConnector
