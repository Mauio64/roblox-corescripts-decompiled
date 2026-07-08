local HttpService = game:GetService("HttpService")
local Parent = script:FindFirstAncestor("GraphQLServer").Parent
local Object = require(Parent.LuauPolyfill).Object
local Promise = require(Parent.Promise)
local t1 = {}
local Fetch = require(Parent.Fetch)
local fetch = Fetch.fetch
local Response = Fetch.Response
local GraphQLError = require(Parent.GraphQL).GraphQLError
local UrlBuilder = require(Parent.UrlBuilder).UrlBuilder
local buildOmniRecommendationsRequest = require(script.Parent.buildOmniRecommendationsRequest)

require(script.Parent.Parent.Parent.generatedTypes)

local v12 = UrlBuilder.fromString("apis:discovery-api/omni-recommendation-metadata")

function t1.findOmniFeedBySessionId(p1, p2) -- line: 52
	-- upvalues: fetch (copy), buildOmniRecommendationsRequest (copy), Promise (copy), Response (copy), GraphQLError (copy), Object (copy)
	local v15 = p2 or fetch
	local v16 = buildOmniRecommendationsRequest(v15)

	return Promise.new(function(resolve, reject) -- line: 59
		-- upvalues: v16 (copy), p1 (copy), Response (copy), GraphQLError (copy), Object (copy)
		local v22 = v16(p1.pageType, p1.sessionId, p1.nextPageToken, p1.supportedTreatmentTypes):catch(function() -- line: 65
			-- upvalues: Response (copy)
			return Response.error()
		end):expect()

		if not v22.ok then
			reject(GraphQLError.new(string.format("Failed to fetch omni recommendations. Error code: %d", v22.status)))

			return nil
		end

		local v23 = v22:json():catch(function() -- line: 80
			return nil
		end):expect()

		if not v23 then
			reject(GraphQLError.new("Failed to decode HTTP response as JSON for omni-recommendation fetch"))
		end

		resolve(Object.assign({
			omniSessionId = p1.sessionId,
			pageType = p1.pageType
		}, v23))

		return nil
	end)
end
function t1.fetchMoreOmniRecommendationMetadata(p3, p4) -- line: 100
	-- upvalues: fetch (copy), Promise (copy), v12 (copy), HttpService (copy), Response (copy), GraphQLError (copy), Object (copy)
	local v19 = p4 or fetch

	return Promise.new(function(resolve, reject) -- line: 103
		-- upvalues: v12 (copy), v19 (copy), HttpService (copy), p3 (copy), Response (copy), GraphQLError (copy), Object (copy)
		local v26 = v12()
		local v27 = v19(v26, {
			method = "POST",
			body = HttpService:JSONEncode({
				sessionId = p3.sessionId,
				contents = p3.recommendations
			}),
			headers = {
				["Content-Type"] = "application/json",
				Accept = "application/json"
			}
		}):catch(function() -- line: 117
			-- upvalues: Response (copy)
			return Response.error()
		end):expect()

		if not v27.ok then
			reject(GraphQLError.new(string.format("Failed to fetch additional metadata for topicId: %s", p3.topicId)))

			return
		end

		local v28 = v27:json():catch(function() -- line: 129
			return nil
		end):expect()

		if not v28 then
			reject(GraphQLError.new(string.format("Failed to decode HTTP response as JSON for topicId: %s", p3.topicId)))

			return
		end

		resolve(Object.assign(v28, {
			topicId = p3.topicId,
			recommendations = p3.recommendations
		}))
	end)
end

return t1
