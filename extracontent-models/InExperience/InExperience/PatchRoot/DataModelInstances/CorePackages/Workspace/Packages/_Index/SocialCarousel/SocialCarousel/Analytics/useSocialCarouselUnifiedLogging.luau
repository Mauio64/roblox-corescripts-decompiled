local SocialCarousel = script:FindFirstAncestor("SocialCarousel")
local parent = SocialCarousel.Parent
local React = require(parent.React)
local Cryo = require(parent.Cryo)
local RoactUtils = require(parent.RoactUtils)
local CollectionViews = require(parent.CollectionViews)
local UnifiedLogging = require(parent.UnifiedLogging)
local Impressions = require(parent.Impressions)
local SharedFlags = require(parent.SharedFlags)

local Enums = require(SocialCarousel.Common.Enums)
local Tile = Enums.Tile
local TopicContentsRodux = require(parent.TopicContentsRodux)
local TopicContentsReducer = TopicContentsRodux.TopicContentsReducer
local useSelector = RoactUtils.Hooks.RoactRodux.useSelector
local useCollectionImpressionsSignal = CollectionViews.useCollectionImpressionsSignal
local ScreenSizeImpressionsTracker = Impressions.ScreenSizeImpressionsTracker
local FrameBoundsImpressionsTracker = Impressions.FrameBoundsImpressionsTracker
local ImpressionsTagUtility = Impressions.ImpressionsTagUtility
local SendItemImpressions = UnifiedLogging.SendItemImpressions

local FFlagLuaAppHomeFriendsRemoveItemImpressions = SharedFlags.FFlagLuaAppHomeFriendsRemoveItemImpressions
local FFlagLuaAppUseFrameBoundsImpressions = SharedFlags.FFlagLuaAppUseFrameBoundsImpressions

return function(p, p2, data, p3, p4)
	if not (p3 and p3.tiles and data) then
		return nil
	end

	local scrollViewPositionChangedSignal, onCollectionViewabilityChanged = useCollectionImpressionsSignal(data.scrollViewPositionChangedSignal)

	local useCallback = React.useCallback
	local function fn(p5)
		if FFlagLuaAppHomeFriendsRemoveItemImpressions and data.skipItemImpressionsLog then
			return
		end

		local mapped = Cryo.Dictionary.map(p3.tiles, function(p6)
			return Cryo.Dictionary.join(p6, {
				isFriend = p6.tileType == Tile.Friend
			})
		end)

		SendItemImpressions.sendFromFriendsCarousel(
			p2,
			p,
			p5,
			mapped,
			data.appPage,
			data.sortIndex,
			data.sortId,
			data.impressionTag
		)
	end

	local tiles = p3.tiles
	local appPage = data.appPage
	local sortIndex = data.sortIndex
	local sortId = data.sortId
	local impressionTag = data.impressionTag
	local v

	if FFlagLuaAppHomeFriendsRemoveItemImpressions then
		v = data.skipItemImpressionsLog
	end

	local sendImpressions = useCallback(fn, {
		p2,
		p,
		tiles,
		appPage,
		sortIndex,
		sortId,
		impressionTag,
		v
	})

	local current = useSelector(function(p5)
		if data.sortId then
			return p5.Personalization
				and p5.Personalization[TopicContentsReducer.key]
				and p5.Personalization[TopicContentsReducer.key][data.sortId]
				and p5.Personalization[TopicContentsReducer.key][data.sortId].updatedTimestamp
		end

		return nil
	end)

	React.useEffect(function()
		if current then
			p4.current = current
		end
	end, { current })

	return {
		onCollectionViewabilityChanged = onCollectionViewabilityChanged,
		tagTileForImpressions = React.useCallback(function(p5, p6)
			ImpressionsTagUtility.AddTag(p5, data.impressionTag, p6)

			return function()
				ImpressionsTagUtility.RemoveTag(p5, data.impressionTag, p6)
			end
		end, { data.impressionTag }),
		renderImpressionsTrackerComponent = React.useCallback(function(parentRef)
			local createElement = React.createElement
			local v2

			if FFlagLuaAppUseFrameBoundsImpressions then
				v2 = FrameBoundsImpressionsTracker
			else
				v2 = ScreenSizeImpressionsTracker
			end

			return createElement(v2, {
				pageContext = data.appPage,
				parentRef = parentRef,
				impressionsTag = data.impressionTag,
				scrollViewPositionChangedSignal = scrollViewPositionChangedSignal,
				sendImpressions = sendImpressions,
				dataUpdatedTimestamp = p4.current
			})
		end, { data.impressionTag, scrollViewPositionChangedSignal, data.appPage, sendImpressions })
	}
end
