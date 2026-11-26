local HttpService = game:GetService("HttpService")

local urlBuilder = require("@game/CorePackages/Workspace/Packages/_Workspace/GraphQLServer/UrlBuilder").UrlBuilder
local urlBase = require("@game/CorePackages/Workspace/Packages/_Workspace/GraphQLServer/UrlBuilder").UrlBase
local Promise = require("@game/CorePackages/Workspace/Packages/_Workspace/GraphQLServer/Promise")
local graphQLError = require("@game/CorePackages/Workspace/Packages/_Workspace/GraphQLServer/GraphQL").GraphQLError
local response = require("@game/CorePackages/Workspace/Packages/_Workspace/GraphQLServer/Fetch").Response
local fetch = require("@game/CorePackages/Workspace/Packages/_Workspace/GraphQLServer/Fetch").fetch

require("@game/CorePackages/Workspace/Packages/_Workspace/GraphQLServer/LuauPolyfill")

require("@game/CorePackages/Workspace/Packages/_Workspace/GraphQLServer/GraphQLServer/graphql/generatedTypes")

local fFlagPlayerSearchEnableOnlineFrequents = require("@game/CorePackages/Workspace/Packages/_Workspace/GraphQLServer/SharedFlags").FFlagPlayerSearchEnableOnlineFrequents

local v5 = urlBuilder.new({
	base = urlBase.APIS,
	path = "profile-insights-api/v1/multiProfileInsights"
})

return {
	findProfileInsightsByUserIds = function(p2, value, p3, p4)
		local v6 = p4 or fetch
		return Promise.new(function(callback, callback2)
			local expect = v6(v5(), {
				body = HttpService:JSONEncode({
					userIds = p2,
					count = not p3 and (value or 2) or nil,
					rankingStrategy = p3
				}),
				method = "POST",
				headers = {
					["Content-Type"] = "application/json",
					Accept = "application/json"
				}
			}):catch(function()
				return response.error()
			end):expect()

			if not expect.ok then
				callback2(graphQLError.new(string.format(
					"Failed to fetch profile insights. Error code: %d",
					expect.status
				)))

				return
			end

			local expect2 = expect:json():catch(function(): nil
				return nil
			end):expect()

			if expect2 then
				callback(expect2.userInsights)
			else
				callback2(graphQLError.new(string.format(
					"Failed to decode HTTP response as JSON for profile insights: %s.",
					HttpService:JSONEncode(p2)
				)))
			end
		end)
	end,
	findProfileInsightsByUserIdsFeed = function(p2, value, p3, p4, p5)
		if not fFlagPlayerSearchEnableOnlineFrequents then
			p4 = nil
		end

		local v6 = p5 or fetch
		return (Promise.new(function(callback, callback2)
			local expect = v6(v5(), {
				body = HttpService:JSONEncode({
					userIds = p2,
					count = not p4 and (value or 2) or nil,
					rankingStrategy = p4
				}),
				method = "POST",
				headers = {
					["Content-Type"] = "application/json",
					Accept = "application/json"
				}
			}):catch(function()
				return response.error()
			end):expect()

			if not expect.ok then
				callback2(graphQLError.new(string.format(
					"Failed to fetch profile insights. Error code: %d",
					expect.status
				)))

				return
			end

			local expect2 = expect:json():catch(function(): nil
				return nil
			end):expect()

			if expect2 then
				callback(expect2.userInsights)
			else
				callback2(graphQLError.new(string.format(
					"Failed to decode HTTP response as JSON for profile insights: %s.",
					HttpService:JSONEncode(p2)
				)))
			end
		end):andThen(function(p6)
			return { pageId = p3, profileInsights = p6 }
		end))
	end
}
