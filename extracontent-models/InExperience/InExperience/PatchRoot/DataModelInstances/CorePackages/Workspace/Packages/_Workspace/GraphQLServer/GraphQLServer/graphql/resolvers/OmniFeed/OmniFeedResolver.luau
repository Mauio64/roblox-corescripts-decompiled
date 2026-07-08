local Parent = script:FindFirstAncestor("GraphQLServer").Parent
local Array = require(Parent.LuauPolyfill).Array
local t1 = {}
local OmniFeedConnector = require(script.Parent.Parent.Parent.connectors.OmniFeed.OmniFeedConnector)
local findOmniFeedBySessionId = OmniFeedConnector.findOmniFeedBySessionId
local fetchMoreOmniRecommendationMetadata = OmniFeedConnector.fetchMoreOmniRecommendationMetadata

require(script.Parent.Parent.Parent.generatedTypes)
t1.default = {
	OmniFeedItem = {
		experiences = function(t2: {[any]: any}) -- line: 35
			if not t2.metadata or (not t2.metadata.Game or not t2.recommendations) then
				return nil
			end

			local Game = t2.metadata.Game
			local t3 = {}

			for _, v11 in t2.recommendations do
				if v11.contentId then
					local v12 = Game[tostring(v11.contentId)]
					local contentMetadata = v11.contentMetadata
					local v14 = if not contentMetadata or not contentMetadata.EncryptedAdTrackingData then nil else contentMetadata.EncryptedAdTrackingData

					if v12 and v12.universeId then
						table.insert(t3, {
							placeId = if not v12.rootPlaceId then nil else tostring(v12.rootPlaceId),
							name = v12.name,
							universeId = tostring(v12.universeId),
							totalUpVotes = v12.totalUpVotes,
							totalDownVotes = v12.totalDownVotes,
							playerCount = v12.playerCount,
							under9 = not not v12.under9 and v12.under9,
							under13 = not not v12.under13 and v12.under13,
							adId = v14 or "",
							isSponsored = v14 ~= nil and v14 ~= ""
						})
					end
				end
			end

			return t3
		end
	},
	OmniFeedMetadata = {
		GameJSON = function(p1) -- line: 73
			return p1.Game
		end,
		CatalogAssetJSON = function(p2) -- line: 76
			return p2.CatalogAsset
		end,
		CatalogBundleJSON = function(p3) -- line: 79
			return p3.CatalogBundle
		end,
		RecommendedFriendJSON = function(p4) -- line: 82
			return p4.RecommendedFriend
		end
	},
	OmniFeed = {
		metadata = function(p5) -- line: 87
			return p5.contentMetadata
		end,
		sortsExpirationTime = function(p6) -- line: 90
			if not p6.sortsRefreshInterval then
				return nil
			end

			return math.floor((tick())) + p6.sortsRefreshInterval
		end,
		recommendationsId = function(p7) -- line: 96
			return p7.requestId
		end,
		globalLayoutData = function(p8) -- line: 99
			return p8.globalLayoutData
		end,
		sorts = function(p9) -- line: 102
			-- upvalues: Array (copy)
			if not p9.sorts then
				return nil
			end

			return (Array.map(p9.sorts, function(p10) -- line: 107
				-- upvalues: p9 (copy)
				return {
					topic = p10.topic,
					topicId = p10.topicId,
					treatmentType = p10.treatmentType,
					recommendations = p10.recommendationList,
					metadata = p9.contentMetadata
				}
			end))
		end
	},
	OmniFeedItemWithMetadata = {
		metadata = function(p11) -- line: 121
			return p11.contentMetadata
		end,
		sort = function(p12) -- line: 124
			return {
				topicId = p12.topicId,
				metadata = p12.contentMetadata,
				recommendations = p12.recommendations
			}
		end
	},
	Query = {
		omniFeed = function(_, p14, p15) -- line: 135
			-- upvalues: findOmniFeedBySessionId (copy)
			return findOmniFeedBySessionId(p14, p15.fetchImpl)
		end,
		refreshOmniFeedItem = function(_, p17, p18) -- line: 138
			-- upvalues: fetchMoreOmniRecommendationMetadata (copy)
			return fetchMoreOmniRecommendationMetadata(p17, p18.fetchImpl)
		end
	}
}

return t1
