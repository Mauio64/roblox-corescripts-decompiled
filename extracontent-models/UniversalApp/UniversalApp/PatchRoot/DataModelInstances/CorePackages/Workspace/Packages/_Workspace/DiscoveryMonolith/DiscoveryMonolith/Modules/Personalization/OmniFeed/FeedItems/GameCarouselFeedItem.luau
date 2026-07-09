local DiscoveryMonolith = script:FindFirstAncestor("DiscoveryMonolith")
local DiscoveryMonolithParent = DiscoveryMonolith.Parent
local Roact = require(DiscoveryMonolithParent.Roact)
local RoactRodux = require(DiscoveryMonolithParent.RoactRodux)
local t = require(DiscoveryMonolithParent.t)

require(DiscoveryMonolithParent.GameTile)

local DiscoveryTypes = require(DiscoveryMonolithParent.DiscoveryTypes)
local GameSortGroups = DiscoveryTypes.GameSortGroups
local OmniFeedConstants = DiscoveryTypes.OmniFeedConstants
local FormFactor = require(DiscoveryMonolithParent.FormFactor).Enums.FormFactor
local AppPage = require(DiscoveryMonolithParent.RobloxAppEnums).AppPage
local mutedError = require(DiscoveryMonolithParent.Loggers).mutedError
local parseBooleanString = require(DiscoveryMonolithParent.DiscoveryUtils).parseBooleanString
local Modules = DiscoveryMonolith.Modules
local GameCollectionCarousel = require(Modules.Personalization.Games.GameCollectionCarousel)
local OmniFeedProps = require(Modules.Personalization.OmniFeed.OmniFeedProps)
local FFlagLuaAppHeaderButtonText = require(DiscoveryMonolithParent.SharedFlags).FFlagLuaAppHeaderButtonText
local FFlagLuaAppGameCarouselAmpUpsellAction = require(DiscoveryMonolithParent.SharedFlags).FFlagLuaAppGameCarouselAmpUpsellAction
local FFlagSearchOmniAutocompletePage = require(DiscoveryMonolithParent.SharedFlags).FFlagSearchOmniAutocompletePage
local FIntLuaAppDelayImpressionsMaxUpdates = require(DiscoveryMonolithParent.SharedFlags).FIntLuaAppDelayImpressionsMaxUpdates
local v20 = game:DefineFastFlag("LuaAppForceLowResMural", false)
local FIntSearchLandingPageSideMargin = require(Modules.Personalization.Search.FIntSearchLandingPageSideMargin)
local FFlagLuaAppCompositionAlways = require(DiscoveryMonolithParent.SharedFlags).FFlagLuaAppCompositionAlways
local FFlagLuaAppHomeFirstTileThumbnailLoadedMilestone = require(DiscoveryMonolithParent.SharedFlags).FFlagLuaAppHomeFirstTileThumbnailLoadedMilestone
local FFlagLuaAppHomeTouchAutoplay = require(DiscoveryMonolithParent.SharedFlags).FFlagLuaAppHomeTouchAutoplay
local FFlagLuaAppUsePrevalidatedVideoGamePlayability = require(DiscoveryMonolithParent.SharedFlags).FFlagLuaAppUsePrevalidatedVideoGamePlayability
local GAME_CAROUSEL_SIDE_COMPACT_PADDING = DiscoveryTypes.Constants.GAME_CAROUSEL_SIDE_COMPACT_PADDING
local GAME_CAROUSEL_SIDE_WIDE_PADDING = DiscoveryTypes.Constants.GAME_CAROUSEL_SIDE_WIDE_PADDING
local v28 = Roact.PureComponent:extend("GameCarouselFeedItem")

v28.validateProps = t.strictInterface({
	[OmniFeedProps.key] = OmniFeedProps.interface,
	sortIndex = t.number,
	isOmni = t.boolean,
	topicLayoutData = t.optional(t.table),
	formFactor = t.string,
	sortName = t.string
})

function v28.render(p1) -- line: 54
	-- upvalues: OmniFeedProps (copy), OmniFeedConstants (copy), FFlagLuaAppGameCarouselAmpUpsellAction (copy), mutedError (copy), v20 (copy), FFlagLuaAppHeaderButtonText (copy), parseBooleanString (copy), FFlagLuaAppUsePrevalidatedVideoGamePlayability (copy), FFlagLuaAppCompositionAlways (copy), AppPage (copy), FormFactor (copy), GAME_CAROUSEL_SIDE_COMPACT_PADDING (copy), GAME_CAROUSEL_SIDE_WIDE_PADDING (copy), Roact (copy), GameCollectionCarousel (copy), FFlagSearchOmniAutocompletePage (copy), FIntSearchLandingPageSideMargin (copy), FIntLuaAppDelayImpressionsMaxUpdates (copy), FFlagLuaAppHomeFirstTileThumbnailLoadedMilestone (copy), FFlagLuaAppHomeTouchAutoplay (copy)
	local sortIndex = p1.props.sortIndex
	local sortName = p1.props.sortName
	local formFactor = p1.props.formFactor
	local scrollViewPositionChangedSignal = p1.props[OmniFeedProps.key].scrollViewPositionChangedSignal
	local appPage = p1.props[OmniFeedProps.key].appPage
	local feedItemStartRow = p1.props[OmniFeedProps.key].feedItemStartRow
	local v36 = nil
	local v37 = nil
	local v38 = nil
	local v39 = nil
	local v40 = nil
	local v41 = nil
	local v42 = nil
	local v43 = nil
	local s1 = "Narrow"

	if p1.props.topicLayoutData then
		v38 = p1.props.topicLayoutData[OmniFeedConstants.TopicLayoutDataKeys.ComponentType]

		if v38 then
			if v38 == OmniFeedConstants.ComponentTypeDataKeys.EventTile then
				s1 = "Event"
			elseif v38 == OmniFeedConstants.ComponentTypeDataKeys.GridTile then
				s1 = "Wide"
			end

			v36 = s1 == "Wide" or s1 == "Event"
		end

		v39 = p1.props.topicLayoutData[OmniFeedConstants.TopicLayoutDataKeys.LinkPath]
		v40 = p1.props.topicLayoutData[OmniFeedConstants.TopicLayoutDataKeys.SubtitleLinkPath]

		if FFlagLuaAppGameCarouselAmpUpsellAction then
			v41 = p1.props.topicLayoutData[OmniFeedConstants.TopicLayoutDataKeys.AmpUpsellFeatureName]
			v42 = p1.props.topicLayoutData[OmniFeedConstants.TopicLayoutDataKeys.AmpUpsellNamespace]
		end

		v37 = p1.props.topicLayoutData[OmniFeedConstants.TopicLayoutDataKeys.PlayerCountStyle]
		v43 = p1.props.topicLayoutData[OmniFeedConstants.TopicLayoutDataKeys.PlayButtonStyle]
	end

	local v45 = nil

	if p1.props.topicLayoutData then
		local v46 = p1.props.topicLayoutData[OmniFeedConstants.TopicLayoutDataKeys.IsSponsoredFooterAllowed]

		v45 = v46 ~= nil and v46 == "true"
	end

	local v47 = nil

	if p1.props.topicLayoutData then
		local v48 = p1.props.topicLayoutData[OmniFeedConstants.TopicLayoutDataKeys.HideSeeAll]

		v47 = v48 ~= nil and v48 == "true"
	end

	local v49 = if not p1.props.topicLayoutData then nil else p1.props.topicLayoutData[OmniFeedConstants.TopicLayoutDataKeys.InfoText]
	local num = nil

	if p1.props.topicLayoutData then
		local v51 = p1.props.topicLayoutData[OmniFeedConstants.TopicLayoutDataKeys.EndTimestamp]

		if v51 then
			num = tonumber(v51)

			if num == nil then
				mutedError(string.format("Unable to convert `endTimestamp` to number with value: %s", v51))
			end
		end
	end

	local v52 = nil

	if p1.props.topicLayoutData then
		v52 = p1.props.topicLayoutData[OmniFeedConstants.TopicLayoutDataKeys.CountdownString]

		if v52 ~= nil and v52 ~= "" and (not v52:find("{hours}") or not v52:find("{minutes}")) then
			mutedError(string.format("Invalid `countdownString` missing placeholder strings {hours} or {minutes}: %s", v52))
			v52 = nil
		end
	end

	local v53 = nil

	if p1.props.topicLayoutData then
		local v54 = p1.props.topicLayoutData[OmniFeedConstants.TopicLayoutDataKeys.BackgroundImageAssetId]

		if v54 and v54 ~= "" then
			v53 = if not v20 then `rbxthumb://type=Asset&id={ v54 }&w=768&h=432` else `rbxthumb://type=Asset&id={ v54 }&w=384&h=216`
		end
	end

	local v55 = nil

	if FFlagLuaAppHeaderButtonText and p1.props.topicLayoutData then
		v55 = p1.props.topicLayoutData[OmniFeedConstants.TopicLayoutDataKeys.HeaderButtonText]
	end

	local v56 = nil
	local v57 = nil
	local v58 = nil
	local v59 = nil

	if p1.props.topicLayoutData then
		v56 = parseBooleanString(p1.props.topicLayoutData[OmniFeedConstants.TopicLayoutDataKeys.HideTileMetadata])
		v57 = parseBooleanString(p1.props.topicLayoutData[OmniFeedConstants.TopicLayoutDataKeys.HideTileTitle])
		v58 = parseBooleanString(p1.props.topicLayoutData[OmniFeedConstants.TopicLayoutDataKeys.ContainedTile])

		if FFlagLuaAppUsePrevalidatedVideoGamePlayability then
			v59 = parseBooleanString(p1.props.topicLayoutData[OmniFeedConstants.TopicLayoutDataKeys.HasPrevalidatedVideoGamePlayability])
		end
	end

	local v60 = not not FFlagLuaAppCompositionAlways or p1.props[OmniFeedProps.key].appCompositionEnabled
	local v61 = appPage == AppPage.Games or appPage == AppPage.Home
	local v62 = if formFactor ~= FormFactor.COMPACT then GAME_CAROUSEL_SIDE_WIDE_PADDING else GAME_CAROUSEL_SIDE_COMPACT_PADDING

	return Roact.createElement(GameCollectionCarousel, {
		gameSortId = sortName,
		sortIndex = sortIndex,
		pageContext = appPage,
		scrollViewPositionChangedSignal = scrollViewPositionChangedSignal,
		friendFooterEnabled = true,
		isHoverSupportEnabled = v61 or appPage == AppPage.Games and v36,
		gridSupportAllowed = v61,
		useGridTiles = v36,
		playerCountStyle = v37,
		isSponsoredFooterAllowed = v45,
		componentType = v38,
		linkPath = v39,
		subtitleLinkPath = v40,
		ampUpsellFeatureName = if not FFlagLuaAppGameCarouselAmpUpsellAction then nil else v41,
		ampUpsellNamespace = if not FFlagLuaAppGameCarouselAmpUpsellAction then nil else v42,
		refreshFeed = if not FFlagLuaAppGameCarouselAmpUpsellAction then nil else p1.props[OmniFeedProps.key].refreshFeed,
		hideSeeAll = v47,
		gameTileLayoutType = s1,
		infoText = v49,
		endTimestamp = num,
		countdownString = v52,
		startRow = feedItemStartRow,
		playButtonStyle = v43,
		sideMargin = if not v60 then v62 else nil,
		appCompositionEnabled = v60,
		backgroundMuralUrl = v53,
		headerButtonText = if not FFlagLuaAppHeaderButtonText then nil else v55,
		shouldHideTileMetadata = v56,
		shouldHideTileTitle = v57,
		containedTile = v58,
		shouldUseFrameBoundsForImpressions = if not FFlagSearchOmniAutocompletePage then nil else appPage == AppPage.SearchLandingPage,
		layoutOverrides = if not v60 then if not FFlagSearchOmniAutocompletePage then nil else if appPage ~= AppPage.SearchLandingPage then nil else {
			sideMargin = if formFactor ~= FormFactor.COMPACT then FIntSearchLandingPageSideMargin else GAME_CAROUSEL_SIDE_COMPACT_PADDING
		} else nil,
		numUpdatesToDelayImpressions = FIntLuaAppDelayImpressionsMaxUpdates,
		selectionOrderBase = p1.props[OmniFeedProps.key].selectionOrderBase,
		defaultContainerSize = p1.props[OmniFeedProps.key].defaultContainerSize,
		onTileImageLoaded = if not FFlagLuaAppHomeFirstTileThumbnailLoadedMilestone then nil else p1.props[OmniFeedProps.key].onTileImageLoaded,
		hasPrevalidatedVideoGamePlayability = if not FFlagLuaAppUsePrevalidatedVideoGamePlayability then nil else v59,
		videoPlaybackContext = if not FFlagLuaAppHomeTouchAutoplay then nil else p1.props[OmniFeedProps.key].videoPlaybackContext
	})
end

return (RoactRodux.connect(function(p2, p3) -- line: 250
	-- upvalues: OmniFeedProps (copy), AppPage (copy), GameSortGroups (copy), FFlagSearchOmniAutocompletePage (copy), mutedError (copy)
	local appPage = p3[OmniFeedProps.key].appPage
	local str = nil

	if p3.isOmni then
		assert(appPage == AppPage.Home, "Omni only on Home Page")

		local v67 = p2.OmniRecommendations[appPage]
		local v68 = (v67 and v67.sorts or {})[p3.sortIndex]

		if v68 and v68.topicId then
			str = tostring(v68.topicId)
		end
	else
		local HomeGames = nil

		if appPage == AppPage.Home then
			HomeGames = GameSortGroups.HomeGames
		elseif appPage == AppPage.Games then
			HomeGames = GameSortGroups.Games
		elseif FFlagSearchOmniAutocompletePage and appPage == AppPage.SearchLandingPage then
			HomeGames = GameSortGroups.SearchLandingPage
		else
			mutedError("Unsupported page for GameCarouselFeedItem data: " .. tostring(appPage))
		end

		str = p2.GameSortGroups[HomeGames].sorts[p3.sortIndex]
	end

	return {
		sortName = str,
		formFactor = p2.FormFactor
	}
end)(v28))
