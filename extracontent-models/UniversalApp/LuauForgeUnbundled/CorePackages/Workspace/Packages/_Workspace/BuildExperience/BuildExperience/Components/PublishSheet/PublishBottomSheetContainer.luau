require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/DataHydration")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/React")
local useLocalization = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/Localization").Hooks.useLocalization
local LocalizationStrings = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/LocalizationStrings")

local PublishBottomSheet = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Components/PublishSheet/PublishBottomSheet")
local GameInfoUtils = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/utils/GameInfoUtils")

local function getEnrichedTarget(target, gameInfo, loading)
	local v5 = if GameInfoUtils.isGameInfoReady(gameInfo) then gameInfo else nil
	local creator = if v5 then v5.creator else nil

	local enrichedTarget = {
		universeId = target.universeId,
		placeId = 0,
		sessionId = 0,
		experienceName = 0,
		creatorName = 0,
		gameIcon = 0,
		isCreatorVerified = 0,
		isNewGameTarget = 0
	}
	local v6 = target.placeId

	if not v6 then
		v6 = if v5 then tonumber(v5.rootPlaceId) else nil
	end

	enrichedTarget.placeId = v6
	enrichedTarget.sessionId = target.sessionId
	enrichedTarget.experienceName = GameInfoUtils.getGameInfoName(gameInfo)

	if creator and creator.name ~= "" then
		loading = creator.name
	end

	enrichedTarget.creatorName = loading
	enrichedTarget.gameIcon = target.gameIcon
	local v7 = if creator then creator.hasVerifiedBadge == true else false
	enrichedTarget.isCreatorVerified = v7
	enrichedTarget.isNewGameTarget = target.isNewGameTarget
	return enrichedTarget
end

local function PublishBottomSheetContainer(props)
	local loading = useLocalization({ loading = LocalizationStrings.BUILD_MENU_LOADING }).loading
	local enrichedTarget = getEnrichedTarget(props.target, props.gameInfo, loading)

	return React.createElement(PublishBottomSheet, {
		isOpen = props.isOpen,
		target = enrichedTarget,
		onClose = props.onClose,
		onOpenTitleDescriptionPage = props.onOpenTitleDescriptionPage,
		onOpenMediaSelectionPage = props.onOpenMediaSelectionPage,
		onOpenVersionTitleDescriptionPage = props.onOpenVersionTitleDescriptionPage,
		onOpenVersionHistory = props.onOpenVersionHistory,
		showPreviewButton = props.showPreviewButton,
		testId = props.testId
	})
end

return PublishBottomSheetContainer
