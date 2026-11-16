require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/DataHydration")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/React")

local PublishBottomSheetContainer = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Components/PublishSheet/PublishBottomSheetContainer")
local VersionHistoryContainer = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Components/VersionHistory/VersionHistoryContainer")
local BuildOverflowMenuScreens = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Components/BuildPillMenu/BuildOverflowMenuScreens")
local GameInfoUtils = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/utils/GameInfoUtils")

local screens = BuildOverflowMenuScreens.Screens

local function resolvePlaceId(p2, p3)
	if p2.placeId ~= nil then
		return p2.placeId
	end

	if GameInfoUtils.isGameInfoReady(p3) then
		return (tonumber(p3.rootPlaceId))
	end

	return nil
end

local function PublishSheetController(props)
	local state, setState = React.useState(false)
	local navigateToSubPage = props.navigateToSubPage
	local onClose = props.onClose
	local target = props.target

	local v5 = GameInfoUtils.useGameInfo(target.universeId)
	local v6

	if target.placeId == nil then
		v6 = if GameInfoUtils.isGameInfoReady(v5) then tonumber(v5.rootPlaceId) else nil
	else
		v6 = target.placeId
	end

	local v7 = React.useMemo(function()
		return {
			universeId = target.universeId,
			placeId = v6,
			sessionId = target.sessionId,
			experienceName = target.experienceName,
			gameIcon = target.gameIcon,
			isNewGameTarget = target.isNewGameTarget
		}
	end, {
		target.universeId,
		v6,
		target.sessionId,
		target.experienceName,
		target.gameIcon,
		target.isNewGameTarget
	})

	local titleDescriptionReady = GameInfoUtils.isTitleDescriptionReady(v5)
	local v8 = React.useCallback(function()
		if not titleDescriptionReady then
			return
		end

		onClose()
		navigateToSubPage(screens.BuildTitleDescription, v7)
	end, { onClose, navigateToSubPage, titleDescriptionReady, v7 })

	local v9 = React.useCallback(function()
		onClose()
		navigateToSubPage(screens.BuildMediaSelection, v7)
	end, { onClose, navigateToSubPage, v7 })

	local v10 = React.useCallback(function()
		if v6 == nil then
			return
		end

		onClose()
		navigateToSubPage(screens.BuildVersionTitleDescription, v7)
	end, { onClose, navigateToSubPage, v6, v7 })

	local v11 = React.useCallback(function()
		if v6 == nil then
			return
		end

		onClose()
		setState(true)
	end, { onClose, v6 })

	local v12 = React.useCallback(function()
		setState(false)
	end, {})

	local createElement = React.createElement
	local fragment = React.Fragment
	local v15 = if props.isOpen then React.createElement(PublishBottomSheetContainer, {
		isOpen = true,
		target = v7,
		gameInfo = v5,
		onClose = onClose,
		onOpenTitleDescriptionPage = v8,
		onOpenMediaSelectionPage = v9,
		onOpenVersionTitleDescriptionPage = v10,
		onOpenVersionHistory = v11,
		showPreviewButton = props.showPreviewButton
	}) else nil

	local v16 = if state and v6 ~= nil then React.createElement(VersionHistoryContainer, {
		placeId = v6,
		isOpen = true,
		onClose = v12,
		testId = "build-publish-version-history"
	}) else nil
	return createElement(fragment, nil, { PublishSheet = v15, VersionHistory = v16 })
end

return PublishSheetController
