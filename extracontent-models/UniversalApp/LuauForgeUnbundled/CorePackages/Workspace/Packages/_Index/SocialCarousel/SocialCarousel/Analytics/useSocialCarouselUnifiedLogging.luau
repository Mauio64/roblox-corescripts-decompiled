local React = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialCarousel/React")
local Cryo = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialCarousel/Cryo")
local RoactUtils = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialCarousel/RoactUtils")
local CollectionViews = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialCarousel/CollectionViews")
local UnifiedLogging = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialCarousel/UnifiedLogging")
local Impressions = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialCarousel/Impressions")
local SharedFlags = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialCarousel/SharedFlags")

local tile = require("@game/CorePackages/Workspace/Packages/_Index/SocialCarousel/SocialCarousel/Common/Enums").Tile
local topicContentsReducer = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialCarousel/TopicContentsRodux").TopicContentsReducer
local useSelector = RoactUtils.Hooks.RoactRodux.useSelector
local useCollectionImpressionsSignal = CollectionViews.useCollectionImpressionsSignal
local screenSizeImpressionsTracker = Impressions.ScreenSizeImpressionsTracker
local frameBoundsImpressionsTracker = Impressions.FrameBoundsImpressionsTracker
local impressionsTagUtility = Impressions.ImpressionsTagUtility
local sendItemImpressions = UnifiedLogging.SendItemImpressions

local fFlagLuaAppHomeFriendsRemoveItemImpressions = SharedFlags.FFlagLuaAppHomeFriendsRemoveItemImpressions
local fFlagLuaAppUseFrameBoundsImpressions = SharedFlags.FFlagLuaAppUseFrameBoundsImpressions

return function(p2, p3, data, p4, p5)
	if not (p4 and p4.tiles and data) then
		return nil
	end

	local v5, v6 = useCollectionImpressionsSignal(data.scrollViewPositionChangedSignal)

	local useCallback = React.useCallback
	local function fn(p6)
		if fFlagLuaAppHomeFriendsRemoveItemImpressions and data.skipItemImpressionsLog then
			return
		end

		local mapped = Cryo.Dictionary.map(p4.tiles, function(p7)
			return Cryo.Dictionary.join(p7, {
				isFriend = p7.tileType == tile.Friend
			})
		end)

		sendItemImpressions.sendFromFriendsCarousel(
			p3,
			p2,
			p6,
			mapped,
			data.appPage,
			data.sortIndex,
			data.sortId,
			data.impressionTag
		)
	end

	local tiles = p4.tiles
	local appPage = data.appPage
	local sortIndex = data.sortIndex
	local sortId = data.sortId
	local impressionTag = data.impressionTag
	local v8 = if fFlagLuaAppHomeFriendsRemoveItemImpressions then data.skipItemImpressionsLog else nil
	local v9 = useCallback(fn, {
		p3,
		p2,
		tiles,
		appPage,
		sortIndex,
		sortId,
		impressionTag,
		v8
	})

	local v10 = useSelector(function(p6)
		if data.sortId then
			return p6.Personalization
				and p6.Personalization[topicContentsReducer.key]
				and p6.Personalization[topicContentsReducer.key][data.sortId]
				and p6.Personalization[topicContentsReducer.key][data.sortId].updatedTimestamp
		end

		return nil
	end)

	React.useEffect(function()
		if v10 then
			p5.current = v10
		end
	end, { v10 })

	return {
		onCollectionViewabilityChanged = v6,
		tagTileForImpressions = React.useCallback(function(p6, p7)
			impressionsTagUtility.AddTag(p6, data.impressionTag, p7)

			return function()
				impressionsTagUtility.RemoveTag(p6, data.impressionTag, p7)
			end
		end, { data.impressionTag }),
		renderImpressionsTrackerComponent = React.useCallback(function(p6)
			return React.createElement(
				if fFlagLuaAppUseFrameBoundsImpressions then frameBoundsImpressionsTracker else screenSizeImpressionsTracker,
				{
					pageContext = data.appPage,
					parentRef = p6,
					impressionsTag = data.impressionTag,
					scrollViewPositionChangedSignal = v5,
					sendImpressions = v9,
					dataUpdatedTimestamp = p5.current
				}
			)
		end, { data.impressionTag, v5, data.appPage, v9 })
	}
end
