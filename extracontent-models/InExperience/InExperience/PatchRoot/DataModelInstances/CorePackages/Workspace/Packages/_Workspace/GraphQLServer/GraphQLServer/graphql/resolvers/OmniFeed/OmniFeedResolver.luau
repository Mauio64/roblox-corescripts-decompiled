local parent = script:FindFirstAncestor("GraphQLServer").Parent
local LuauPolyfill = require(parent.LuauPolyfill)
local Array = LuauPolyfill.Array

local OmniFeedConnector = require(script.Parent.Parent.Parent.connectors.OmniFeed.OmniFeedConnector)

local findOmniFeedBySessionId = OmniFeedConnector.findOmniFeedBySessionId
local fetchMoreOmniRecommendationMetadata = OmniFeedConnector.fetchMoreOmniRecommendationMetadata

require(script.Parent.Parent.Parent.generatedTypes)
return {
	default = {
		OmniFeedItem = {
			experiences = function(p)
				if not (p.metadata and p.metadata.Game and p.recommendations) then
					return nil
				end

				local Game = p.metadata.Game
				local result = {}

				for _, recommendation in p.recommendations do
					if not recommendation.contentId then
						continue
					end

					local v = Game[tostring(recommendation.contentId)]
					local contentMetadata = recommendation.contentMetadata
					local encryptedAdTrackingData

					if contentMetadata and contentMetadata.EncryptedAdTrackingData then
						encryptedAdTrackingData = contentMetadata.EncryptedAdTrackingData
					end

					if not (v and v.universeId) then
						continue
					end

					local placeId

					if v.rootPlaceId then
						placeId = tostring(v.rootPlaceId)
					end

					local v2 = {
						placeId = placeId,
						name = v.name,
						universeId = tostring(v.universeId),
						totalUpVotes = v.totalUpVotes,
						totalDownVotes = v.totalDownVotes,
						playerCount = v.playerCount,
						under9 = 0,
						under13 = 0,
						adId = 0,
						isSponsored = 0
					}
					local under = if v.under9 then v.under9 else false
					v2.under9 = under
					local under2

					if v.under13 then
						under2 = v.under13
					else
						under2 = false
					end

					v2.under13 = under2
					v2.adId = encryptedAdTrackingData or ""
					v2.isSponsored = encryptedAdTrackingData ~= nil and encryptedAdTrackingData ~= ""
					table.insert(result, v2)
				end

				return result
			end
		},
		OmniFeedMetadata = {
			GameJSON = function(p)
				return p.Game
			end,
			CatalogAssetJSON = function(p)
				return p.CatalogAsset
			end,
			CatalogBundleJSON = function(p)
				return p.CatalogBundle
			end,
			RecommendedFriendJSON = function(p)
				return p.RecommendedFriend
			end
		},
		OmniFeed = {
			metadata = function(p)
				return p.contentMetadata
			end,
			sortsExpirationTime = function(p)
				if p.sortsRefreshInterval then
					return math.floor((tick())) + p.sortsRefreshInterval
				end

				return nil
			end,
			recommendationsId = function(p)
				return p.requestId
			end,
			globalLayoutData = function(p)
				return p.globalLayoutData
			end,
			sorts = function(p)
				if p.sorts then
					return (Array.map(p.sorts, function(data)
						return {
							topic = data.topic,
							topicId = data.topicId,
							treatmentType = data.treatmentType,
							recommendations = data.recommendationList,
							metadata = p.contentMetadata
						}
					end))
				end

				return nil
			end
		},
		OmniFeedItemWithMetadata = {
			metadata = function(p)
				return p.contentMetadata
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
			omniFeed = function(_, p, p2)
				return findOmniFeedBySessionId(p, p2.fetchImpl)
			end,
			refreshOmniFeedItem = function(_, p, p2)
				return fetchMoreOmniRecommendationMetadata(p, p2.fetchImpl)
			end
		}
	}
}
