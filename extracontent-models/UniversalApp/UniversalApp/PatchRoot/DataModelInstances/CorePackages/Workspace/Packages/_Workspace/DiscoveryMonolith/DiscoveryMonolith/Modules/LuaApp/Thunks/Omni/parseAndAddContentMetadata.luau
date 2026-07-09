local DiscoveryMonolith = script:FindFirstAncestor("DiscoveryMonolith")
local DiscoveryMonolithParent = DiscoveryMonolith.Parent
local DiscoveryTypes = require(DiscoveryMonolithParent.DiscoveryTypes)
local OmniRecommendationsContentType = DiscoveryTypes.OmniRecommendationsContentType
local GameInfoModel = require(DiscoveryMonolithParent.GameModels).GameInfoModel
local parseAndAddGameInfos = require(DiscoveryMonolithParent.GameInfosRodux).parseAndAddGameInfos
local mutedError = require(DiscoveryMonolithParent.Loggers).mutedError
local PYMKCarouselModel = require(DiscoveryMonolithParent.PYMKCarousel).PYMKCarouselModel
local OmniFeedConstants = DiscoveryTypes.OmniFeedConstants
local OmniFeedTypes = DiscoveryTypes.OmniFeedTypes
local Modules = DiscoveryMonolith.Modules
local GameCoPlay = require(Modules.LuaApp.Models.DiscoveryApi.GameCoPlay)
local CatalogAsset = require(Modules.LuaApp.Models.DiscoveryApi.CatalogAsset)
local CatalogBundle = require(Modules.LuaApp.Models.DiscoveryApi.CatalogBundle)
local AddContentMetadata = require(Modules.LuaApp.Actions.Games.AddContentMetadata)
local ApiFetchIconsForOmniData = require(Modules.LuaApp.Thunks.Games.ApiFetchIconsForOmniData)
local FFlagLuaAppReduceGameIconFetches = require(DiscoveryMonolithParent.SharedFlags).FFlagLuaAppReduceGameIconFetches
local t1 = {
	[OmniRecommendationsContentType.GameCoPlay] = GameCoPlay.fromJsonData,
	[OmniRecommendationsContentType.CatalogAsset] = CatalogAsset.fromJsonData,
	[OmniRecommendationsContentType.CatalogBundle] = CatalogBundle.fromJsonData,
	[OmniRecommendationsContentType.RecommendedFriend] = PYMKCarouselModel.fromJsonData
}

local function parseAndAddContentEntries(p1, p2, p3, p4, p5) -- line: 29
	-- upvalues: DiscoveryTypes (copy), parseAndAddGameInfos (copy), GameInfoModel (copy), FFlagLuaAppReduceGameIconFetches (copy), t1 (copy), mutedError (copy)
	for k, v in pairs(p3) do
		if not p4[k] then
			p4[k] = {}
		end

		if k == DiscoveryTypes.OmniRecommendationsContentType.Game then
			parseAndAddGameInfos(p1, p2, v, GameInfoModel.fromOmniApi, function(_, p7) -- line: 36
				-- upvalues: p4 (copy), k (copy)
				local universeId = p7.universeId

				p4[k][universeId] = p7
			end, if not FFlagLuaAppReduceGameIconFetches then nil else p5)
		else
			local v29 = t1[k]

			if v29 then
				for k2, v2 in pairs(v) do
					v29(v2):match(function(p8) -- line: 57
						-- upvalues: p4 (copy), k (copy), k2 (copy), mutedError (copy)
						if p4[k][k2] then
							mutedError(`Duplicate contentStringId { k2 } found for type { k }`)

							return
						end

						p4[k][k2] = p8
					end):matchError(function(p9) -- line: 64
						warn(p9)
					end)
				end
			end
		end
	end
end
local function isGameIconSort(p10) -- line: 72
	-- upvalues: OmniFeedTypes (copy), OmniFeedConstants (copy)
	if p10.treatmentType ~= OmniFeedTypes.Carousel and p10.treatmentType ~= OmniFeedTypes.HomeGameGrid then
		return false
	end

	local v33 = p10.topicLayoutData and p10.topicLayoutData[OmniFeedConstants.TopicLayoutDataKeys.ComponentType]

	if v33 == OmniFeedConstants.ComponentTypeDataKeys.EventTile or v33 == OmniFeedConstants.ComponentTypeDataKeys.GridTile then
		return false
	end

	return p10.recommendationList ~= nil
end
local function parseAndAddContentMetadata(p11, p12, p13) -- line: 88
	-- upvalues: FFlagLuaAppReduceGameIconFetches (copy), OmniFeedTypes (copy), OmniFeedConstants (copy), parseAndAddContentEntries (copy), AddContentMetadata (copy), ApiFetchIconsForOmniData (copy)
	if not p13 then
		return {}
	end

	if not p13.contentMetadata and not p13.contentMetadataByStringId then
		return {}
	end

	local v37 = nil

	if FFlagLuaAppReduceGameIconFetches and p13.sorts then
		local t2 = {}

		for _, v40 in p13.sorts do
			local v41

			if v40.treatmentType ~= OmniFeedTypes.Carousel and v40.treatmentType ~= OmniFeedTypes.HomeGameGrid then
				v41 = false
			else
				local v42 = v40.topicLayoutData and v40.topicLayoutData[OmniFeedConstants.TopicLayoutDataKeys.ComponentType]

				v41 = v42 ~= OmniFeedConstants.ComponentTypeDataKeys.EventTile and (v42 ~= OmniFeedConstants.ComponentTypeDataKeys.GridTile and v40.recommendationList ~= nil)
			end

			if v41 then
				for _, v44 in v40.recommendationList do
					if v44.contentType == "Game" then
						t2[tostring(v44.contentId)] = true
					end
				end
			end
		end

		function v37(p14) -- line: 109
			-- upvalues: t2 (copy)
			return t2[p14]
		end
	end

	local t3 = {}

	parseAndAddContentEntries(p11, p12, p13.contentMetadata, t3, if not FFlagLuaAppReduceGameIconFetches then nil else v37)

	if p13.contentMetadataByStringId then
		parseAndAddContentEntries(p11, p12, p13.contentMetadataByStringId, t3, if not FFlagLuaAppReduceGameIconFetches then nil else v37)
	end

	if next(t3) then
		p12:dispatch(AddContentMetadata(t3))
		p12:dispatch(ApiFetchIconsForOmniData(p11, t3))
	end

	return t3
end

return parseAndAddContentMetadata
