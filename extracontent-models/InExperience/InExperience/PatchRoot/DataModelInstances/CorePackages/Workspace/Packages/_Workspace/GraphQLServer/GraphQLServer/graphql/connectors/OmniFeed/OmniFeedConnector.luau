local HttpService = game:GetService("HttpService")
local parent = script:FindFirstAncestor("GraphQLServer").Parent
local LuauPolyfill = require(parent.LuauPolyfill)
local Object = LuauPolyfill.Object

local Promise = require(parent.Promise)
local OmniFeedConnector = {}
local Fetch = require(parent.Fetch)
local fetch = Fetch.fetch
local Response = Fetch.Response

local GraphQL = require(parent.GraphQL)
local GraphQLError = GraphQL.GraphQLError
local UrlBuilder = require(parent.UrlBuilder)
local urlBuilder = UrlBuilder.UrlBuilder
local buildOmniRecommendationsRequest = require(script.Parent.buildOmniRecommendationsRequest)

require(script.Parent.Parent.Parent.generatedTypes)

local v = urlBuilder.fromString("apis:discovery-api/omni-recommendation-metadata")

function OmniFeedConnector.findOmniFeedBySessionId(data, p)
	local omniRecommendationsRequest = buildOmniRecommendationsRequest(p or fetch)

	return Promise.new(function(callback, callback2): nil
		local expect = omniRecommendationsRequest(
			data.pageType,
			data.sessionId,
			data.nextPageToken,
			data.supportedTreatmentTypes
		):catch(function()
			return Response.error()
		end):expect()

		if not expect.ok then
			callback2(GraphQLError.new(string.format(
				"Failed to fetch omni recommendations. Error code: %d",
				expect.status
			)))

			return nil
		end

		local expect2 = expect:json():catch(function(): nil
			return nil
		end):expect()

		if not expect2 then
			callback2(GraphQLError.new("Failed to decode HTTP response as JSON for omni-recommendation fetch"))
		end

		callback(Object.assign({ omniSessionId = data.sessionId, pageType = data.pageType }, expect2))

		return nil
	end)
end

function OmniFeedConnector.fetchMoreOmniRecommendationMetadata(data, p)
	local v2 = p or fetch
	return Promise.new(function(callback, callback2)
		local expect = v2(v(), {
			body = HttpService:JSONEncode({
				sessionId = data.sessionId,
				contents = data.recommendations
			}),
			method = "POST",
			headers = { ["Content-Type"] = "application/json", Accept = "application/json" }
		}):catch(function()
			return Response.error()
		end):expect()

		if not expect.ok then
			callback2(GraphQLError.new(string.format(
				"Failed to fetch additional metadata for topicId: %s",
				data.topicId
			)))
			return
		end

		local expect2 = expect:json():catch(function(): nil
			return nil
		end):expect()

		if expect2 then
			callback(Object.assign(expect2, {
				topicId = data.topicId,
				recommendations = data.recommendations
			}))
		else
			callback2(GraphQLError.new(string.format(
				"Failed to decode HTTP response as JSON for topicId: %s",
				data.topicId
			)))
		end
	end)
end
return OmniFeedConnector
