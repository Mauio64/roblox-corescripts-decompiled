local SocialCarousel = script:FindFirstAncestor("SocialCarousel")
local SocialCarouselParent = SocialCarousel.Parent
local React = require(SocialCarouselParent.React)
local Cryo = require(SocialCarouselParent.Cryo)
local RoactUtils = require(SocialCarouselParent.RoactUtils)
local CollectionViews = require(SocialCarouselParent.CollectionViews)
local UnifiedLogging = require(SocialCarouselParent.UnifiedLogging)
local Impressions = require(SocialCarouselParent.Impressions)
local SharedFlags = require(SocialCarouselParent.SharedFlags)
local Tile = require(SocialCarousel.Common.Enums).Tile
local TopicContentsReducer = require(SocialCarouselParent.TopicContentsRodux).TopicContentsReducer
local useSelector = RoactUtils.Hooks.RoactRodux.useSelector
local useCollectionImpressionsSignal = CollectionViews.useCollectionImpressionsSignal
local ScreenSizeImpressionsTracker = Impressions.ScreenSizeImpressionsTracker
local FrameBoundsImpressionsTracker = Impressions.FrameBoundsImpressionsTracker
local ImpressionsTagUtility = Impressions.ImpressionsTagUtility
local SendItemImpressions = UnifiedLogging.SendItemImpressions
local FFlagLuaAppUseFrameBoundsImpressions = SharedFlags.FFlagLuaAppUseFrameBoundsImpressions

return function(p1, p2, t1: {[any]: any}?, p3, t2: {[any]: any}) -- line: 29
	-- upvalues: useCollectionImpressionsSignal (copy), React (copy), Cryo (copy), Tile (copy), SendItemImpressions (copy), useSelector (copy), TopicContentsReducer (copy), ImpressionsTagUtility (copy), FFlagLuaAppUseFrameBoundsImpressions (copy), FrameBoundsImpressionsTracker (copy), ScreenSizeImpressionsTracker (copy)
	if not p3 or (not p3.tiles or not t1) then
		return nil
	end

	local v24, v25 = useCollectionImpressionsSignal(t1.scrollViewPositionChangedSignal)
	local v26 = React.useCallback(function(p4) -- line: 44
		-- upvalues: Cryo (copy), p3 (copy), Tile (copy), SendItemImpressions (copy), p2 (copy), p1 (copy), t1 (copy)
		local v31 = Cryo.Dictionary.map(p3.tiles, function(p5) -- line: 45
			-- upvalues: Cryo (copy), Tile (copy)
			return Cryo.Dictionary.join(p5, {
				isFriend = p5.tileType == Tile.Friend
			})
		end)

		SendItemImpressions.sendFromFriendsCarousel(p2, p1, p4, v31, t1.appPage, t1.sortIndex, t1.sortId, t1.impressionTag)
	end, {
		p2,
		p1,
		p3.tiles,
		t1.appPage,
		t1.sortIndex,
		t1.sortId,
		t1.impressionTag
	})
	local v27 = useSelector(function(p6) -- line: 71
		-- upvalues: t1 (copy), TopicContentsReducer (copy)
		if t1.sortId then
			return p6.Personalization and (p6.Personalization[TopicContentsReducer.key] and (p6.Personalization[TopicContentsReducer.key][t1.sortId] and p6.Personalization[TopicContentsReducer.key][t1.sortId].updatedTimestamp))
		end

		return nil
	end)

	React.useEffect(function() -- line: 82
		-- upvalues: v27 (copy), t2 (copy)
		if v27 then
			t2.current = v27
		end
	end, { v27 })

	local v28 = React.useCallback(function(p7, p8) -- line: 88
		-- upvalues: ImpressionsTagUtility (copy), t1 (copy)
		ImpressionsTagUtility.AddTag(p7, t1.impressionTag, p8)

		return function() -- line: 91
			-- upvalues: ImpressionsTagUtility (copy), p7 (copy), t1 (copy), p8 (copy)
			ImpressionsTagUtility.RemoveTag(p7, t1.impressionTag, p8)
		end
	end, { t1.impressionTag })
	local v29 = React.useCallback(function(p9) -- line: 99
		-- upvalues: React (copy), FFlagLuaAppUseFrameBoundsImpressions (copy), FrameBoundsImpressionsTracker (copy), ScreenSizeImpressionsTracker (copy), t1 (copy), v24 (copy), v26 (copy), t2 (copy)
		return React.createElement(if not FFlagLuaAppUseFrameBoundsImpressions then ScreenSizeImpressionsTracker else FrameBoundsImpressionsTracker, {
			pageContext = t1.appPage,
			parentRef = p9,
			impressionsTag = t1.impressionTag,
			scrollViewPositionChangedSignal = v24,
			sendImpressions = v26,
			dataUpdatedTimestamp = t2.current
		})
	end, {
		t1.impressionTag,
		v24,
		t1.appPage,
		v26
	})

	return {
		onCollectionViewabilityChanged = v25,
		tagTileForImpressions = v28,
		renderImpressionsTrackerComponent = v29
	}
end
