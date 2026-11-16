local HttpService = game:GetService("HttpService")

local object = require("@game/CorePackages/Workspace/Packages/_Workspace/GraphQLServer/LuauPolyfill").Object

local Promise = require("@game/CorePackages/Workspace/Packages/_Workspace/GraphQLServer/Promise")
local v5 = {}
local Fetch = require("@game/CorePackages/Workspace/Packages/_Workspace/GraphQLServer/Fetch")
local fetch = Fetch.fetch
local response = Fetch.Response

local graphQLError = require("@game/CorePackages/Workspace/Packages/_Workspace/GraphQLServer/GraphQL").GraphQLError
local urlBuilder = require("@game/CorePackages/Workspace/Packages/_Workspace/GraphQLServer/UrlBuilder").UrlBuilder
local buildOmniRecommendationsRequest = require("@game/CorePackages/Workspace/Packages/_Workspace/GraphQLServer/GraphQLServer/graphql/connectors/OmniFeed/buildOmniRecommendationsRequest")

require("@game/CorePackages/Workspace/Packages/_Workspace/GraphQLServer/GraphQLServer/graphql/generatedTypes")

local v6 = urlBuilder.fromString("apis:discovery-api/omni-recommendation-metadata")

function v5.findOmniFeedBySessionId(data, p2)
	local v7 = buildOmniRecommendationsRequest(p2 or fetch)

	return Promise.new(function(callback, callback2): nil
		local expect = v7(data.pageType, data.sessionId, data.nextPageToken, data.supportedTreatmentTypes):catch(function()
			return response.error()
		end):expect()

		if not expect.ok then
			callback2(graphQLError.new(string.format(
				"Failed to fetch omni recommendations. Error code: %d",
				expect.status
			)))

			return nil
		end

		local expect2 = expect:json():catch(function(): nil
			return nil
		end):expect()

		if not expect2 then
			callback2(graphQLError.new("Failed to decode HTTP response as JSON for omni-recommendation fetch"))
		end

		callback(object.assign({
			omniSessionId = data.sessionId,
			pageType = data.pageType
		}, expect2))

		return nil
	end)
end

function v5.fetchMoreOmniRecommendationMetadata(data, p2)
	local v7 = p2 or fetch
	return Promise.new(function(callback, callback2)
		local expect = v7(v6(), {
			body = HttpService:JSONEncode({
				sessionId = data.sessionId,
				contents = data.recommendations
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
				"Failed to fetch additional metadata for topicId: %s",
				data.topicId
			)))
			return
		end

		local expect2 = expect:json():catch(function(): nil
			return nil
		end):expect()

		if expect2 then
			callback(object.assign(expect2, {
				topicId = data.topicId,
				recommendations = data.recommendations
			}))
		else
			callback2(graphQLError.new(string.format(
				"Failed to decode HTTP response as JSON for topicId: %s",
				data.topicId
			)))
		end
	end)
end
return v5
