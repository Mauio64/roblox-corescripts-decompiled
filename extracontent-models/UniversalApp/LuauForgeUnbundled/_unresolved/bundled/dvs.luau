local module = require("@luauforge/bundled/drf")
local module2 = require("@luauforge/bundled/drg")
local module3 = require("@luauforge/bundled/drj")
require("@luauforge/bundled/drl")
local module4 = require("@luauforge/bundled/dqn")
local gameSortGroups = module4.GameSortGroups
local omniFeedConstants = module4.OmniFeedConstants
local formFactor = require("@luauforge/bundled/dso").Enums.FormFactor
local appPage = require("@luauforge/bundled/drn").AppPage
local mutedError = require("@luauforge/bundled/dru").mutedError
local parseBooleanString = require("@luauforge/bundled/dqK").parseBooleanString

local module5 = require("@luauforge/bundled/dvb")
local module6 = require("@luauforge/bundled/dvt")

local fFlagLuaAppHeaderButtonText = require("@luauforge/bundled/dqB").FFlagLuaAppHeaderButtonText
local fIntLuaAppDelayImpressionsMaxUpdates = require("@luauforge/bundled/dqB").FIntLuaAppDelayImpressionsMaxUpdates

local defineFastFlag = game:DefineFastFlag("LuaAppForceLowResMural", false)
local module7 = require("@luauforge/bundled/dvu")

local fFlagLuaAppCompositionAlways = require("@luauforge/bundled/dqB").FFlagLuaAppCompositionAlways

local fFlagLuaAppUsePrevalidatedVideoGamePlayability = require("@luauforge/bundled/dqB").FFlagLuaAppUsePrevalidatedVideoGamePlayability
local fFlagLuaAppContinueSortInstantPlay = require("@luauforge/bundled/dqB").FFlagLuaAppContinueSortInstantPlay

local GAME_CAROUSEL_SIDE_COMPACT_PADDING = module4.Constants.GAME_CAROUSEL_SIDE_COMPACT_PADDING
local GAME_CAROUSEL_SIDE_WIDE_PADDING = module4.Constants.GAME_CAROUSEL_SIDE_WIDE_PADDING

local extended = module.PureComponent:extend("GameCarouselFeedItem")

extended.validateProps = module3.strictInterface({
	[module6.key] = module6.interface,
	sortIndex = module3.number,
	isOmni = module3.boolean,
	topicLayoutData = module3.optional(module3.table),
	formFactor = module3.string,
	sortName = module3.string
})

function extended.render(p2)
	local sortIndex = p2.props.sortIndex
	local sortName = p2.props.sortName

	local formFactor2 = p2.props.formFactor
	local scrollViewPositionChangedSignal = p2.props[module6.key].scrollViewPositionChangedSignal
	local appPage2 = p2.props[module6.key].appPage
	local feedItemStartRow = p2.props[module6.key].feedItemStartRow

	local v5 = nil

	local v6 = "Narrow"
	local v7, v8, v9, v10, v11, v12, v13

	if p2.props.topicLayoutData then
		v7 = p2.props.topicLayoutData[omniFeedConstants.TopicLayoutDataKeys.ComponentType]

		if v7 then
			v6 = v7 == omniFeedConstants.ComponentTypeDataKeys.EventTile and "Event"
				or v7 == omniFeedConstants.ComponentTypeDataKeys.GridTile and "Wide"
				or v6

			v5 = v6 == "Wide" or v6 == "Event"
		end

		v8 = p2.props.topicLayoutData[omniFeedConstants.TopicLayoutDataKeys.LinkPath]
		v9 = p2.props.topicLayoutData[omniFeedConstants.TopicLayoutDataKeys.SubtitleLinkPath]
		v10 = p2.props.topicLayoutData[omniFeedConstants.TopicLayoutDataKeys.AmpUpsellFeatureName]
		v11 = p2.props.topicLayoutData[omniFeedConstants.TopicLayoutDataKeys.AmpUpsellNamespace]
		v12 = p2.props.topicLayoutData[omniFeedConstants.TopicLayoutDataKeys.PlayerCountStyle]
		v13 = p2.props.topicLayoutData[omniFeedConstants.TopicLayoutDataKeys.PlayButtonStyle]
	end

	local v14

	if p2.props.topicLayoutData then
		local v15 = p2.props.topicLayoutData[omniFeedConstants.TopicLayoutDataKeys.IsSponsoredFooterAllowed]
		v14 = not (v15 == nil) and v15 == "true"
	end

	local v15

	if p2.props.topicLayoutData then
		local v16 = p2.props.topicLayoutData[omniFeedConstants.TopicLayoutDataKeys.HideSeeAll]
		v15 = not (v16 == nil) and v16 == "true"
	end

	local v16

	if p2.props.topicLayoutData then
		v16 = p2.props.topicLayoutData[omniFeedConstants.TopicLayoutDataKeys.InfoText]
	end

	local v17 = nil

	if p2.props.topicLayoutData then
		local v18 = p2.props.topicLayoutData[omniFeedConstants.TopicLayoutDataKeys.EndTimestamp]

		if v18 then
			v17 = tonumber(v18)

			if v17 == nil then
				mutedError(string.format("Unable to convert `endTimestamp` to number with value: %s", v18))
			end
		end
	end

	local v18

	if p2.props.topicLayoutData then
		v18 = p2.props.topicLayoutData[omniFeedConstants.TopicLayoutDataKeys.CountdownString]

		if v18 ~= nil and v18 ~= "" and not (v18:find("{hours}") and v18:find("{minutes}")) then
			mutedError(string.format(
				"Invalid `countdownString` missing placeholder strings {hours} or {minutes}: %s",
				v18
			))
			v18 = nil
		end
	end

	local v19 = nil

	if p2.props.topicLayoutData then
		local v20 = p2.props.topicLayoutData[omniFeedConstants.TopicLayoutDataKeys.BackgroundImageAssetId]

		if v20 and v20 ~= "" then
			if defineFastFlag then
				v19 = `rbxthumb://type=Asset&id={v20}&w=384&h=216`
			else
				v19 = `rbxthumb://type=Asset&id={v20}&w=768&h=432`
			end
		end
	end

	local v20

	if fFlagLuaAppHeaderButtonText and p2.props.topicLayoutData then
		v20 = p2.props.topicLayoutData[omniFeedConstants.TopicLayoutDataKeys.HeaderButtonText]
	end

	local v21 = nil
	local v22 = nil
	local v23 = nil
	local v24, v25, v26

	if p2.props.topicLayoutData then
		v24 = parseBooleanString(p2.props.topicLayoutData[omniFeedConstants.TopicLayoutDataKeys.HideTileMetadata])

		v25 = parseBooleanString(p2.props.topicLayoutData[omniFeedConstants.TopicLayoutDataKeys.HideTileTitle])

		v26 = parseBooleanString(p2.props.topicLayoutData[omniFeedConstants.TopicLayoutDataKeys.ContainedTile])

		if fFlagLuaAppUsePrevalidatedVideoGamePlayability then
			v21 = parseBooleanString(p2.props.topicLayoutData[omniFeedConstants.TopicLayoutDataKeys.HasPrevalidatedVideoGamePlayability])
		end

		if fFlagLuaAppContinueSortInstantPlay then
			v22 = parseBooleanString(p2.props.topicLayoutData[omniFeedConstants.TopicLayoutDataKeys.EnableInstantPlay])

			v23 = p2.props.topicLayoutData[omniFeedConstants.TopicLayoutDataKeys.InstantPlayTreatment]
		end
	end

	local v27 = fFlagLuaAppCompositionAlways and true or p2.props[module6.key].appCompositionEnabled

	local v28 = appPage2 == appPage.Games or appPage2 == appPage.Home
	local v29

	if formFactor2 == formFactor.COMPACT then
		v29 = GAME_CAROUSEL_SIDE_COMPACT_PADDING
	else
		v29 = GAME_CAROUSEL_SIDE_WIDE_PADDING
	end

	local createElement = module.createElement

	local v32 = if v28 then v28 else appPage2 == appPage.Games and v5
	local v31 = {}
	v31.gameSortId = sortName
	v31.sortIndex = sortIndex
	v31.pageContext = appPage2
	v31.scrollViewPositionChangedSignal = scrollViewPositionChangedSignal
	v31.friendFooterEnabled = true
	v31.isHoverSupportEnabled = v32
	v31.gridSupportAllowed = v28
	v31.useGridTiles = v5
	v31.playerCountStyle = v12
	v31.isSponsoredFooterAllowed = v14
	v31.componentType = v7
	v31.linkPath = v8
	v31.subtitleLinkPath = v9
	v31.ampUpsellFeatureName = v10
	v31.ampUpsellNamespace = v11
	v31.refreshFeed = p2.props[module6.key].refreshFeed
	v31.hideSeeAll = v15
	v31.gameTileLayoutType = v6
	v31.infoText = v16
	v31.endTimestamp = v17
	v31.countdownString = v18
	v31.startRow = feedItemStartRow
	v31.playButtonStyle = v13

	if v27 then
		v29 = nil
	end

	v31.sideMargin = v29
	v31.appCompositionEnabled = v27
	v31.backgroundMuralUrl = v19

	if not fFlagLuaAppHeaderButtonText then
		v20 = nil
	end

	v31.headerButtonText = v20
	v31.shouldHideTileMetadata = v24
	v31.shouldHideTileTitle = v25
	v31.containedTile = v26
	v31.shouldUseFrameBoundsForImpressions = appPage2 == appPage.SearchLandingPage
	local v33

	if not (v27 or appPage2 ~= appPage.SearchLandingPage) then
		v33 = { sideMargin = 0 }
		local v34 = if formFactor2 == formFactor.COMPACT then GAME_CAROUSEL_SIDE_COMPACT_PADDING else module7
		v33.sideMargin = v34
	end

	v31.layoutOverrides = v33

	v31.numUpdatesToDelayImpressions = fIntLuaAppDelayImpressionsMaxUpdates
	v31.selectionOrderBase = p2.props[module6.key].selectionOrderBase
	v31.defaultContainerSize = p2.props[module6.key].defaultContainerSize

	if not fFlagLuaAppUsePrevalidatedVideoGamePlayability then
		v21 = nil
	end

	v31.hasPrevalidatedVideoGamePlayability = v21

	v31.videoPlaybackContext = p2.props[module6.key].videoPlaybackContext

	if not fFlagLuaAppContinueSortInstantPlay then
		v22 = nil
	end

	v31.enableInstantPlay = v22

	if not fFlagLuaAppContinueSortInstantPlay then
		v23 = nil
	end

	v31.instantPlayTreatment = v23
	return createElement(module5, v31)
end

return (module2.connect(function(data, p2)
	local appPage2 = p2[module6.key].appPage

	local v5 = nil

	if p2.isOmni then
		assert(appPage2 == appPage.Home, "Omni only on Home Page")
		local omniRecommendation = data.OmniRecommendations[appPage2]
		local v6 = (omniRecommendation and omniRecommendation.sorts or {})[p2.sortIndex]

		if v6 and v6.topicId then
			v5 = tostring(v6.topicId)
		end
	else
		local v6 = nil

		if appPage2 == appPage.Home then
			v6 = gameSortGroups.HomeGames
		elseif appPage2 == appPage.Games then
			v6 = gameSortGroups.Games
		elseif appPage2 == appPage.SearchLandingPage then
			v6 = gameSortGroups.SearchLandingPage
		else
			mutedError("Unsupported page for GameCarouselFeedItem data: " .. tostring(appPage2))
		end

		v5 = data.GameSortGroups[v6].sorts[p2.sortIndex]
	end

	return { sortName = v5, formFactor = data.FormFactor }
end)(extended))
