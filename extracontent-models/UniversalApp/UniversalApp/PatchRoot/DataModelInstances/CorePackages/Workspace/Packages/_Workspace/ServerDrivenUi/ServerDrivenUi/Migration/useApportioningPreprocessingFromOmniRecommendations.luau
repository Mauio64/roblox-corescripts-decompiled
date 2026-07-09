local ServerDrivenUi = script:FindFirstAncestor("ServerDrivenUi")
local ServerDrivenUiParent = ServerDrivenUi.Parent
local React = require(ServerDrivenUiParent.React)
local tutils = require(ServerDrivenUiParent.tutils)
local RoactUtils = require(ServerDrivenUiParent.RoactUtils)
local CollectionViews = require(ServerDrivenUiParent.CollectionViews)
local GameTile = require(ServerDrivenUiParent.GameTile)
local GameTileLayoutType = GameTile.GameTileTypes.GameTileLayoutType
local TopicContentsReducer = require(ServerDrivenUiParent.TopicContentsRodux).TopicContentsReducer
local DiscoveryTypes = require(ServerDrivenUiParent.DiscoveryTypes)
local useSelector = RoactUtils.Hooks.RoactRodux.useSelector
local getGameTileCollectionItemSize = GameTile.getGameTileCollectionItemSize
local OmniFeedTypes = DiscoveryTypes.OmniFeedTypes
local OmniFeedConstants = DiscoveryTypes.OmniFeedConstants
local getSduiFeedStore = require(ServerDrivenUi.DataStore.getSduiFeedStore)
local ApportioningPreprocessingHelpers = require(ServerDrivenUi.DataStore.ApportioningPreprocessingHelpers)
local FFlagLuaAppUseEffectInSignalPreprocessing = require(ServerDrivenUiParent.SharedFlags).FFlagLuaAppUseEffectInSignalPreprocessing
local FFlagLuaAppAddRequestIdToRfySignalApportioning = require(ServerDrivenUiParent.SharedFlags).FFlagLuaAppAddRequestIdToRfySignalApportioning
local FFlagLuaAppCompositionAlways = require(ServerDrivenUiParent.SharedFlags).FFlagLuaAppCompositionAlways
local getMainCollectionLayoutStore = CollectionViews.getMainCollectionLayoutStore

local function useApportioningPreprocessingFromOmniRecommendations(s1: string, p1, b1: boolean?) -- line: 39
	-- upvalues: FFlagLuaAppCompositionAlways (copy), useSelector (copy), tutils (copy), FFlagLuaAppAddRequestIdToRfySignalApportioning (copy), TopicContentsReducer (copy), FFlagLuaAppUseEffectInSignalPreprocessing (copy), React (copy), getSduiFeedStore (copy), getMainCollectionLayoutStore (copy), OmniFeedTypes (copy), GameTileLayoutType (copy), OmniFeedConstants (copy), getGameTileCollectionItemSize (copy), ApportioningPreprocessingHelpers (copy)
	local v25 = FFlagLuaAppCompositionAlways or b1
	local v26 = useSelector(function(p2) -- line: 46
		-- upvalues: s1 (copy)
		local v30 = p2.OmniRecommendations[s1]

		if v30 then
			return v30.sorts
		end

		return {}
	end, tutils.shallowEqual)
	local u27 = nil

	if FFlagLuaAppAddRequestIdToRfySignalApportioning then
		u27 = useSelector(function(p3) -- line: 56
			-- upvalues: s1 (copy)
			local v32 = p3.OmniRecommendations[s1]

			if v32 then
				return v32.recommendationsId
			end

			return nil
		end)
	end

	local v28 = useSelector(function(p4) -- line: 65
		-- upvalues: TopicContentsReducer (copy)
		return p4.Personalization[TopicContentsReducer.key]
	end);

	((if not FFlagLuaAppUseEffectInSignalPreprocessing then React.useLayoutEffect else React.useEffect))(function() -- line: 73
		-- upvalues: getSduiFeedStore (copy), s1 (copy), v25 (copy), getMainCollectionLayoutStore (copy), v26 (copy), OmniFeedTypes (copy), GameTileLayoutType (copy), OmniFeedConstants (copy), getGameTileCollectionItemSize (copy), p1 (copy), ApportioningPreprocessingHelpers (copy), v28 (copy), FFlagLuaAppAddRequestIdToRfySignalApportioning (copy), u27 (ref)
		local v34 = getSduiFeedStore(s1)
		local t1 = {}
		local v36 = nil

		if v25 then
			v36 = getMainCollectionLayoutStore(false).getNumItemsForAllCategories(false)
		end

		for v37, v38 in v26 do
			local topicId = v38.topicId

			if topicId and v38.treatmentType == OmniFeedTypes.HomeGameGrid then
				local Narrow = GameTileLayoutType.Narrow

				if v38.topicLayoutData then
					local v41 = v38.topicLayoutData[OmniFeedConstants.TopicLayoutDataKeys.ComponentType]

					if v41 then
						if v41 == OmniFeedConstants.ComponentTypeDataKeys.EventTile then
							Narrow = GameTileLayoutType.Event
						elseif v41 == OmniFeedConstants.ComponentTypeDataKeys.GridTile then
							Narrow = GameTileLayoutType.Wide
						end
					end
				end

				local v42 = getGameTileCollectionItemSize(Narrow)
				local v43 = if not v25 then p1[v42](false).numColumns else v36[v42]
				local v44 = v38.numberOfRows or 99999

				if v44 == -1 then
					v44 = 99999
				end

				local v45 = v43 * v44

				ApportioningPreprocessingHelpers.addToApportioningData(t1, topicId, v45, v37)
			end
		end

		ApportioningPreprocessingHelpers.populateStartingItemIndices(t1)

		for v46, v47 in t1 do
			local v48 = nil

			if v46 then
				v48 = v28 and v28[v46] or nil
			end

			v47.items = v48 and v48.entries or {}
		end

		v34.updateData({
			apportioningData = t1
		}, if not FFlagLuaAppAddRequestIdToRfySignalApportioning then nil else u27)

		return function() -- line: 140
		end
	end, {
		v26,
		v28,
		if FFlagLuaAppCompositionAlways then nil else p1,
		s1,
		if not FFlagLuaAppAddRequestIdToRfySignalApportioning then nil else u27,
		v25
	})
end

return useApportioningPreprocessingFromOmniRecommendations
