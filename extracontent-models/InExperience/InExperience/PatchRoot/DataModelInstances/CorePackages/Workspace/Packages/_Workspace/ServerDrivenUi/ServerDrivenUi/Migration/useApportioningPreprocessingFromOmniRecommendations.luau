local ServerDrivenUi = script:FindFirstAncestor("ServerDrivenUi")
local parent = ServerDrivenUi.Parent
local React = require(parent.React)
local tutils = require(parent.tutils)
local RoactUtils = require(parent.RoactUtils)
local CollectionViews = require(parent.CollectionViews)
local GameTile = require(parent.GameTile)
local GameTileLayoutType = GameTile.GameTileTypes.GameTileLayoutType
local TopicContentsRodux = require(parent.TopicContentsRodux)
local TopicContentsReducer = TopicContentsRodux.TopicContentsReducer
local DiscoveryTypes = require(parent.DiscoveryTypes)

local useSelector = RoactUtils.Hooks.RoactRodux.useSelector
local getGameTileCollectionItemSize = GameTile.getGameTileCollectionItemSize
local OmniFeedTypes = DiscoveryTypes.OmniFeedTypes
local OmniFeedConstants = DiscoveryTypes.OmniFeedConstants

local getSduiFeedStore = require(ServerDrivenUi.DataStore.getSduiFeedStore)
local ApportioningPreprocessingHelpers = require(ServerDrivenUi.DataStore.ApportioningPreprocessingHelpers)

local SharedFlags = require(parent.SharedFlags)
local FFlagLuaAppUseEffectInSignalPreprocessing = SharedFlags.FFlagLuaAppUseEffectInSignalPreprocessing

local SharedFlags2 = require(parent.SharedFlags)
local FFlagLuaAppAddRequestIdToRfySignalApportioning = SharedFlags2.FFlagLuaAppAddRequestIdToRfySignalApportioning
local SharedFlags3 = require(parent.SharedFlags)
local FFlagLuaAppCompositionAlways = SharedFlags3.FFlagLuaAppCompositionAlways

local getMainCollectionLayoutStore = CollectionViews.getMainCollectionLayoutStore

local function useApportioningPreprocessingFromOmniRecommendations(p: string, p2, flag: boolean?)
	local v = FFlagLuaAppCompositionAlways or flag

	local v2 = useSelector(function(p3)
		local omniRecommendation = p3.OmniRecommendations[p]

		if omniRecommendation then
			return omniRecommendation.sorts
		end

		return {}
	end, tutils.shallowEqual)
	local v3

	if FFlagLuaAppAddRequestIdToRfySignalApportioning then
		v3 = useSelector(function(p3)
			local omniRecommendation = p3.OmniRecommendations[p]

			if omniRecommendation then
				return omniRecommendation.recommendationsId
			end

			return nil
		end)
	else
		v3 = nil
	end

	local v4 = useSelector(function(p3)
		return p3.Personalization[TopicContentsReducer.key]
	end)
	local v5

	if FFlagLuaAppUseEffectInSignalPreprocessing then
		v5 = React.useEffect
	else
		v5 = React.useLayoutEffect
	end

	local function fn()
		local sduiFeedStore = getSduiFeedStore(p)
		local apportioningData = {}
		local v6

		if v then
			v6 = getMainCollectionLayoutStore(false).getNumItemsForAllCategories(false)
		end

		for k, v7 in v2 do
			local topicId = v7.topicId

			if not (topicId and v7.treatmentType == OmniFeedTypes.HomeGameGrid) then
				continue
			end

			local v8 = GameTileLayoutType.Narrow

			if v7.topicLayoutData then
				local v9 = v7.topicLayoutData[OmniFeedConstants.TopicLayoutDataKeys.ComponentType]

				if v9 then
					if v9 == OmniFeedConstants.ComponentTypeDataKeys.EventTile then
						v8 = GameTileLayoutType.Event
					elseif v9 == OmniFeedConstants.ComponentTypeDataKeys.GridTile then
						v8 = GameTileLayoutType.Wide
					end
				end
			end

			local gameTileCollectionItemSize = getGameTileCollectionItemSize(v8)
			local v9

			if v then
				v9 = v6[gameTileCollectionItemSize]
			else
				v9 = p2[gameTileCollectionItemSize](false).numColumns
			end

			local numberOfRows = v7.numberOfRows or 99999
			local v10 = v9 * (numberOfRows == -1 and 99999 or numberOfRows)

			ApportioningPreprocessingHelpers.addToApportioningData(apportioningData, topicId, v10, k)
		end

		ApportioningPreprocessingHelpers.populateStartingItemIndices(apportioningData)

		for k, v7 in apportioningData do
			local v8

			if k then
				v8 = v4 and v4[k] or nil
			end

			v7.items = v8 and v8.entries or {}
		end

		local updateData = sduiFeedStore.updateData
		local v7

		if FFlagLuaAppAddRequestIdToRfySignalApportioning then
			v7 = v3
		end

		updateData({ apportioningData = apportioningData }, v7)

		return function() end
	end

	local v6

	if not FFlagLuaAppCompositionAlways then
		v6 = p2
	end

	local v7

	if FFlagLuaAppAddRequestIdToRfySignalApportioning then
		v7 = v3
	end

	v5(fn, { v2, v4, v6, p, v7, v })
end

return useApportioningPreprocessingFromOmniRecommendations
