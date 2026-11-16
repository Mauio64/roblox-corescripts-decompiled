local module = require("@luauforge/bundled/dqn")
local omniRecommendationsContentType = module.OmniRecommendationsContentType
local gameInfoModel = require("@luauforge/bundled/dqf").GameInfoModel
local parseAndAddGameInfos = require("@luauforge/bundled/dqm").parseAndAddGameInfos
local mutedError = require("@luauforge/bundled/dru").mutedError
local pymkCarouselModel = require("@luauforge/bundled/drz").PYMKCarouselModel
local omniFeedConstants = module.OmniFeedConstants
local omniFeedTypes = module.OmniFeedTypes

local module2 = require("@luauforge/bundled/drA")
local module3 = require("@luauforge/bundled/drB")
local module4 = require("@luauforge/bundled/drC")
local module5 = require("@luauforge/bundled/dqN")
local module6 = require("@luauforge/bundled/drD")

local fromJsonDatas = {
	[omniRecommendationsContentType.GameCoPlay] = module2.fromJsonData,
	[omniRecommendationsContentType.CatalogAsset] = module3.fromJsonData,
	[omniRecommendationsContentType.CatalogBundle] = module4.fromJsonData,
	[omniRecommendationsContentType.RecommendedFriend] = pymkCarouselModel.fromJsonData
}

local function parseAndAddContentEntries(p2, object, items, p3, fn)
	for k, item in pairs(items) do
		if not p3[k] then
			p3[k] = {}
		end

		if k == module.OmniRecommendationsContentType.Game then
			parseAndAddGameInfos(p2, object, item, gameInfoModel.fromOmniApi, function(p4, p5)
				local universeId = p5.universeId
				p3[k][universeId] = p5
			end, fn)
		else
			local v5 = fromJsonDatas[k]

			if v5 then
				for k2, v6 in pairs(item) do
					local v7 = k2
					v5(v6):match(function(p4)
						if p3[k][v7] then
							mutedError(`Duplicate contentStringId {v7} found for type {k}`)
						else
							p3[k][v7] = p4
						end
					end):matchError(function(p4)
						warn(p4)
					end)
				end
			end
		end
	end
end

local function isGameIconSort(data): boolean
	if
		data.treatmentType ~= omniFeedTypes.Carousel
		and data.treatmentType ~= omniFeedTypes.HomeGameGrid
	then
		return false
	end

	local v5 = data.topicLayoutData
		and data.topicLayoutData[omniFeedConstants.TopicLayoutDataKeys.ComponentType]

	if
		v5 == omniFeedConstants.ComponentTypeDataKeys.EventTile
		or v5 == omniFeedConstants.ComponentTypeDataKeys.GridTile
	then
		return false
	end

	return data.recommendationList ~= nil
end

local function parseAndAddContentMetadata(p2, object, data)
	if not (data and (data.contentMetadata or data.contentMetadataByStringId)) then
		return {}
	end

	local fn

	if data.sorts then
		local contentIdSet = {}

		for k, sort in data.sorts do
			local v5

			if
				sort.treatmentType == omniFeedTypes.Carousel
				or sort.treatmentType == omniFeedTypes.HomeGameGrid
			then
				local v6 = sort.topicLayoutData
					and sort.topicLayoutData[omniFeedConstants.TopicLayoutDataKeys.ComponentType]

				if
					v6 == omniFeedConstants.ComponentTypeDataKeys.EventTile
					or v6 == omniFeedConstants.ComponentTypeDataKeys.GridTile
				then
					v5 = false
				else
					v5 = sort.recommendationList ~= nil
				end
			else
				v5 = false
			end

			if not v5 then
				continue
			end

			for k2, recommendation in sort.recommendationList do
				if recommendation.contentType == "Game" then
					contentIdSet[tostring(recommendation.contentId)] = true
				end
			end
		end

		fn = function(p3)
			return contentIdSet[p3]
		end
	end

	local v5 = {}
	parseAndAddContentEntries(p2, object, data.contentMetadata, v5, fn)

	if data.contentMetadataByStringId then
		parseAndAddContentEntries(p2, object, data.contentMetadataByStringId, v5, fn)
	end

	if next(v5) then
		object:dispatch(module5(v5))
		object:dispatch(module6(p2, v5))
	end

	return v5
end

return parseAndAddContentMetadata
