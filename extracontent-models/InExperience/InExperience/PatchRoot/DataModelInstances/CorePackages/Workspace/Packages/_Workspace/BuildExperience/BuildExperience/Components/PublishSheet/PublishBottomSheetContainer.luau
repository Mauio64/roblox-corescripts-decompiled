local BuildExperience = script:FindFirstAncestor("BuildExperience")
local parent = BuildExperience.Parent

require(parent.DataHydration)
local React = require(parent.React)
local Localization = require(parent.Localization)
local useLocalization = Localization.Hooks.useLocalization
local LocalizationStrings = require(BuildExperience.LocalizationStrings)

local PublishBottomSheet = require(script.Parent.PublishBottomSheet)
local GameInfoUtils = require(BuildExperience.utils.GameInfoUtils)

local function getEnrichedTarget(target, gameInfo, loading: string)
	local v

	if GameInfoUtils.isGameInfoReady(gameInfo) then
		v = gameInfo
	end

	local creator

	if v then
		creator = v.creator
	end

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
	local placeId = target.placeId

	if not placeId then
		if v then
			placeId = tonumber(v.rootPlaceId)
		else
			placeId = nil
		end
	end

	enrichedTarget.placeId = placeId
	enrichedTarget.sessionId = target.sessionId
	enrichedTarget.experienceName = GameInfoUtils.getGameInfoName(gameInfo)

	if creator and creator.name ~= "" then
		loading = creator.name
	end

	enrichedTarget.creatorName = loading
	enrichedTarget.gameIcon = target.gameIcon
	local isCreatorVerified

	if creator then
		isCreatorVerified = creator.hasVerifiedBadge == true
	else
		isCreatorVerified = false
	end

	enrichedTarget.isCreatorVerified = isCreatorVerified
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
