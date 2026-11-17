local BuildExperience = script:FindFirstAncestor("BuildExperience")
local parent = BuildExperience.Parent

require(parent.DataHydration)
local React = require(parent.React)

local PublishBottomSheetContainer = require(script.Parent.PublishBottomSheetContainer)
local VersionHistoryContainer = require(BuildExperience.Components.VersionHistory.VersionHistoryContainer)
local BuildOverflowMenuScreens = require(BuildExperience.Components.BuildPillMenu.BuildOverflowMenuScreens)
local GameInfoUtils = require(BuildExperience.utils.GameInfoUtils)
local FFlagBuildExperiencePageImpressions = require(BuildExperience.Flags.FFlagBuildExperiencePageImpressions)
local useBuildPageImpression = require(BuildExperience.Telemetry.useBuildPageImpression)

local Screens = BuildOverflowMenuScreens.Screens

local function resolvePlaceId(target, p) -- 1 equivalent call inferred from this helper
	if target.placeId ~= nil then
		return target.placeId
	end

	if GameInfoUtils.isGameInfoReady(p) then
		return (tonumber(p.rootPlaceId))
	end

	return nil
end

local function PublishSheetController(props)
	local state, setState = React.useState(false)
	local navigateToSubPage = props.navigateToSubPage
	local onClose = props.onClose
	local target = props.target

	local gameInfo = GameInfoUtils.useGameInfo(target.universeId)
	local placeId = resolvePlaceId(target, gameInfo) -- inferred equivalent call
	local target2 = React.useMemo(function()
		return {
			universeId = target.universeId,
			placeId = placeId,
			sessionId = target.sessionId,
			experienceName = target.experienceName,
			gameIcon = target.gameIcon,
			isNewGameTarget = target.isNewGameTarget
		}
	end, {
		target.universeId,
		placeId,
		target.sessionId,
		target.experienceName,
		target.gameIcon,
		target.isNewGameTarget
	})

	if FFlagBuildExperiencePageImpressions then
		useBuildPageImpression("publish", target2, props.isOpen)
		useBuildPageImpression("version-history", target2, state and placeId ~= nil)
	end

	local titleDescriptionReady = GameInfoUtils.isTitleDescriptionReady(gameInfo)
	local onOpenTitleDescriptionPage = React.useCallback(function()
		if not titleDescriptionReady then
			return
		end

		onClose()
		navigateToSubPage(Screens.BuildTitleDescription, target2)
	end, { onClose, navigateToSubPage, titleDescriptionReady, target2 })

	local onOpenMediaSelectionPage = React.useCallback(function()
		onClose()
		navigateToSubPage(Screens.BuildMediaSelection, target2)
	end, { onClose, navigateToSubPage, target2 })

	local onOpenVersionTitleDescriptionPage = React.useCallback(function()
		if placeId == nil then
			return
		end

		onClose()
		navigateToSubPage(Screens.BuildVersionTitleDescription, target2)
	end, { onClose, navigateToSubPage, placeId, target2 })

	local onOpenVersionHistory = React.useCallback(function()
		if placeId == nil then
			return
		end

		onClose()
		setState(true)
	end, { onClose, placeId })

	local onClose2 = React.useCallback(function()
		setState(false)
	end, {})

	local createElement = React.createElement
	local fragment = React.Fragment
	local publishSheet

	if props.isOpen then
		publishSheet = React.createElement(PublishBottomSheetContainer, {
			isOpen = true,
			target = target2,
			gameInfo = gameInfo,
			onClose = onClose,
			onOpenTitleDescriptionPage = onOpenTitleDescriptionPage,
			onOpenMediaSelectionPage = onOpenMediaSelectionPage,
			onOpenVersionTitleDescriptionPage = onOpenVersionTitleDescriptionPage,
			onOpenVersionHistory = onOpenVersionHistory,
			showPreviewButton = props.showPreviewButton
		})
	end

	local versionHistory

	if state and placeId ~= nil then
		versionHistory = React.createElement(VersionHistoryContainer, {
			placeId = placeId,
			isOpen = true,
			onClose = onClose2,
			testId = "build-publish-version-history"
		})
	end

	return createElement(fragment, nil, {
		PublishSheet = publishSheet,
		VersionHistory = versionHistory
	})
end

return PublishSheetController
