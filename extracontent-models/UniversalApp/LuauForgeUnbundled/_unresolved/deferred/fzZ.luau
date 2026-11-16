local CorePackages = game:GetService("CorePackages")
local HttpService = game:GetService("HttpService")

local Promise = require(CorePackages.Packages.Promise)
local module = require("@luauforge/deferred/fAa")

local makeOmniRecommendationsRequest = require("@luauforge/deferred/fAb").MakeOmniRecommendationsRequest

local function httpClientNetworkImpl(p2, p3, p4)
	local v5 = if p4 and p4.postBody then HttpService:JSONDecode(p4.postBody) else nil
	local fetched = module.fetch({
		method = p3,
		url = p2,
		analyticsKey = "launch-destination.recent-games",
		body = v5,
		decode = function(p5)
			return p5
		end
	})

	return module.asPromise(fetched):andThen(function(p5)
		return { responseBody = p5 }
	end)
end

local v5 = { MAX_RECENT_GAMES = 5 }

function v5.fetch()
	local success, result = pcall(function()
		return makeOmniRecommendationsRequest(httpClientNetworkImpl, "Home", "0", nil, nil, nil, {
			(tostring(100000003))
		})
	end)

	if success then
		return result:andThen(function(p2)
			local responseBody = p2.responseBody
			local sorts = responseBody and responseBody.sorts
			local Game = responseBody and responseBody.contentMetadata and responseBody.contentMetadata.Game

			if not (sorts and Game) then
				return Promise.resolve({})
			end

			local recommendationList = nil

			for k, sort in sorts do
				if sort.topicId == 100000003 then
					recommendationList = sort.recommendationList
					break
				end
			end

			if not recommendationList then
				return Promise.resolve({})
			end

			local v7 = {}

			for k, recommendation in recommendationList do
				if #v7 >= 5 then
					break
				end

				local contentId = recommendation.contentId
				local v8 = contentId and Game[tostring(contentId)]

				if v8 and v8.rootPlaceId and v8.name then
					table.insert(v7, {
						placeId = tostring(v8.rootPlaceId),
						name = v8.name
					})
				end
			end

			return Promise.resolve(v7)
		end)
	end

	return Promise.reject(result)
end

return v5
