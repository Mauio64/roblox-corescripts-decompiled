local resolveGameTileThumbnailUri = require("@luauforge/bundled/drl").resolveGameTileThumbnailUri
local module = require("@luauforge/bundled/dqn")
local gameCollectionItemType = module.GameCollectionItemTypes.GameCollectionItemType
local omniFeedConstants = module.OmniFeedConstants
local omniFeedTypes = module.OmniFeedTypes
local omniRecommendationsContentType = module.OmniRecommendationsContentType

local function isWideOrEventSort(p2): boolean
	local topicLayoutData = p2.topicLayoutData

	if not topicLayoutData then
		return false
	end

	local v5 = topicLayoutData[omniFeedConstants.TopicLayoutDataKeys.ComponentType]
	return v5 == omniFeedConstants.ComponentTypeDataKeys.EventTile
		or v5 == omniFeedConstants.ComponentTypeDataKeys.GridTile
end

local function isSduiSort(p2)
	local v5

	if p2.treatmentType == omniFeedTypes.ServerDrivenUi then
		v5 = true
	elseif omniFeedTypes.ServerDrivenUiV2 == nil then
		v5 = false
	else
		v5 = p2.treatmentType == omniFeedTypes.ServerDrivenUiV2
	end

	return v5
end

local function getThumbnailShape(sort, recommendation)
	local v5

	if sort.treatmentType == omniFeedTypes.ServerDrivenUi then
		v5 = true
	elseif omniFeedTypes.ServerDrivenUiV2 == nil then
		v5 = false
	else
		v5 = sort.treatmentType == omniFeedTypes.ServerDrivenUiV2
	end

	if v5 then
		return nil, nil
	end

	local topicLayoutData = sort.topicLayoutData
	local v6

	if topicLayoutData then
		local v7 = topicLayoutData[omniFeedConstants.TopicLayoutDataKeys.ComponentType]
		v6 = v7 == omniFeedConstants.ComponentTypeDataKeys.EventTile
			or v7 == omniFeedConstants.ComponentTypeDataKeys.GridTile
	else
		v6 = false
	end

	local componentType = recommendation.contentMetadata and recommendation.contentMetadata.ComponentType

	if componentType == gameCollectionItemType.TwoByOneTile then
		return true, true
	end

	if componentType == gameCollectionItemType.EmphasisTile then
		if v6 then
			return true, true
		end

		return nil, nil
	end

	if
		componentType == gameCollectionItemType.Blank
		or gameCollectionItemType.OneByTwoTile and componentType == gameCollectionItemType.OneByTwoTile
	then
		return nil, nil
	end

	return v6, false
end

local function collectHomeThumbnailUrls(p2, p3, p4)
	local gameTileThumbnailUris = {}
	local gameTileThumbnailUriSet = {}

	local maxEntries = p4.maxEntries
	local maxEntriesPerSort = p4.maxEntriesPerSort

	if maxEntries <= 0 or maxEntriesPerSort <= 0 or not (p2 and p2.sorts) then
		return gameTileThumbnailUris
	end

	if not p3 then
		return gameTileThumbnailUris
	end

	local count = 0

	for k, sort in p2.sorts do
		if not sort.recommendationList then
			continue
		end

		local v6

		if sort.treatmentType == omniFeedTypes.ServerDrivenUi then
			v6 = true
		elseif omniFeedTypes.ServerDrivenUiV2 == nil then
			v6 = false
		else
			v6 = sort.treatmentType == omniFeedTypes.ServerDrivenUiV2
		end

		if v6 then
			continue
		end

		local topicId = if sort.topicId then tostring(sort.topicId) else nil
		local count2 = 0

		for k2, recommendation in sort.recommendationList do
			if maxEntries <= count or maxEntriesPerSort <= count2 then
				break
			end

			if not (recommendation.contentType == omniRecommendationsContentType.Game and recommendation.contentId) then
				continue
			end

			local contentId = tostring(recommendation.contentId)
			local v7 = p3[contentId]

			if not v7 then
				continue
			end

			local thumbnailShape, v8 = getThumbnailShape(sort, recommendation)

			if thumbnailShape == nil then
				continue
			end

			local primaryWideImageAssetId = recommendation.contentMetadata
				and recommendation.contentMetadata.PrimaryWideImageAssetId
			local v9

			if primaryWideImageAssetId and primaryWideImageAssetId ~= "" then
				v9 = tostring(primaryWideImageAssetId)
			end

			local gameTileThumbnailUri = resolveGameTileThumbnailUri({
				universeId = contentId,
				placeId = v7.placeId,
				useGridTile = thumbnailShape,
				isEmphasized = v8,
				perEntryWideAssetId = v9,
				game = v7,
				topicId = topicId
			})

			if not gameTileThumbnailUri or gameTileThumbnailUriSet[gameTileThumbnailUri] then
				continue
			end

			table.insert(gameTileThumbnailUris, gameTileThumbnailUri)
			gameTileThumbnailUriSet[gameTileThumbnailUri] = true
			count += 1
			count2 += 1
		end

		if maxEntries <= count then
			break
		end
	end

	return gameTileThumbnailUris
end

return collectHomeThumbnailUrls
