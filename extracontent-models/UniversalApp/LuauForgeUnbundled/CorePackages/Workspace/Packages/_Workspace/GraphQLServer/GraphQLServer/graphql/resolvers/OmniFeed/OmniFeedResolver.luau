local array = require("@game/CorePackages/Workspace/Packages/_Workspace/GraphQLServer/LuauPolyfill").Array

local OmniFeedConnector = require("@game/CorePackages/Workspace/Packages/_Workspace/GraphQLServer/GraphQLServer/graphql/connectors/OmniFeed/OmniFeedConnector")

local findOmniFeedBySessionId = OmniFeedConnector.findOmniFeedBySessionId
local fetchMoreOmniRecommendationMetadata = OmniFeedConnector.fetchMoreOmniRecommendationMetadata

require("@game/CorePackages/Workspace/Packages/_Workspace/GraphQLServer/GraphQLServer/graphql/generatedTypes")
return {
	default = {
		OmniFeedItem = {
			experiences = function(p2)
				if not (p2.metadata and p2.metadata.Game and p2.recommendations) then
					return nil
				end

				local Game = p2.metadata.Game
				local result = {}

				for k, recommendation in p2.recommendations do
					if not recommendation.contentId then
						continue
					end

					local v6 = Game[tostring(recommendation.contentId)]
					local contentMetadata = recommendation.contentMetadata
					local encryptedAdTrackingData

					if contentMetadata and contentMetadata.EncryptedAdTrackingData then
						encryptedAdTrackingData = contentMetadata.EncryptedAdTrackingData
					end

					if not (v6 and v6.universeId) then
						continue
					end

					local v8 = if v6.rootPlaceId then tostring(v6.rootPlaceId) else nil
					local v7 = {
						placeId = v8,
						name = v6.name,
						universeId = tostring(v6.universeId),
						totalUpVotes = v6.totalUpVotes,
						totalDownVotes = v6.totalDownVotes,
						playerCount = v6.playerCount,
						under9 = 0,
						under13 = 0,
						adId = 0,
						isSponsored = 0
					}
					local v9 = if v6.under9 then v6.under9 else false
					v7.under9 = v9
					local v10 = if v6.under13 then v6.under13 else false
					v7.under13 = v10
					v7.adId = encryptedAdTrackingData or ""
					v7.isSponsored = encryptedAdTrackingData ~= nil and encryptedAdTrackingData ~= ""
					table.insert(result, v7)
				end

				return result
			end
		},
		OmniFeedMetadata = {
			GameJSON = function(p2)
				return p2.Game
			end,
			CatalogAssetJSON = function(p2)
				return p2.CatalogAsset
			end,
			CatalogBundleJSON = function(p2)
				return p2.CatalogBundle
			end,
			RecommendedFriendJSON = function(p2)
				return p2.RecommendedFriend
			end
		},
		OmniFeed = {
			metadata = function(p2)
				return p2.contentMetadata
			end,
			sortsExpirationTime = function(p2)
				if p2.sortsRefreshInterval then
					return math.floor((tick())) + p2.sortsRefreshInterval
				end

				return nil
			end,
			recommendationsId = function(p2)
				return p2.requestId
			end,
			globalLayoutData = function(p2)
				return p2.globalLayoutData
			end,
			sorts = function(p2)
				if p2.sorts then
					return (array.map(p2.sorts, function(data)
						return {
							topic = data.topic,
							topicId = data.topicId,
							treatmentType = data.treatmentType,
							recommendations = data.recommendationList,
							metadata = p2.contentMetadata
						}
					end))
				end

				return nil
			end
		},
		OmniFeedItemWithMetadata = {
			metadata = function(p2)
				return p2.contentMetadata
			end,
			sort = function(data)
				return {
					topicId = data.topicId,
					metadata = data.contentMetadata,
					recommendations = data.recommendations
				}
			end
		},
		Query = {
			omniFeed = function(p2, p3, p4)
				return findOmniFeedBySessionId(p3, p4.fetchImpl)
			end,
			refreshOmniFeedItem = function(p2, p3, p4)
				return fetchMoreOmniRecommendationMetadata(p3, p4.fetchImpl)
			end
		}
	}
}
