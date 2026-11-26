local FocusNavigationUtils = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/FocusNavigationUtils")
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/Foundation")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/React")
local UniverseConfiguration = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/DataHydration/UniverseConfiguration")
local useLocalization = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/Localization").Hooks.useLocalization
local LocalizationStrings = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/LocalizationStrings")

local ArchiveGameDialog = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Components/GameConfigurations/ArchiveGameDialog")
require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Chat/chatTypes")
local ExperienceShareOverlays = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Components/ShareAudience/ExperienceShareOverlays")
require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Stores/GetBuildOverflowMenuStore/createBuildOverflowMenuStore")
local useArchiveGameFlow = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/utils/useArchiveGameFlow")
local useClosableFocusRoot = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/utils/useClosableFocusRoot")
local useExperienceShareFlow = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/utils/useExperienceShareFlow")
local useGamePermissions = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/useGamePermissions")
local FFlagBuildExperiencePrivateInvites = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Flags/FFlagBuildExperiencePrivateInvites")
local FFlagBuildCheckGamePermissions = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Flags/FFlagBuildCheckGamePermissions")
local FFlagBuildExperienceHomeTelemetry = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Flags/FFlagBuildExperienceHomeTelemetry")
local sendBuildExperienceEvent = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Telemetry/sendBuildExperienceEvent")

local focusNavigableSurfaceIdentifierEnum = FocusNavigationUtils.FocusNavigableSurfaceIdentifierEnum
local menu = Foundation.Menu
local useScaledValue = Foundation.Hooks.useScaledValue
local inputSize = Foundation.Enums.InputSize
local popoverAlign = Foundation.Enums.PopoverAlign
local popoverSide = Foundation.Enums.PopoverSide
local privacyType = UniverseConfiguration.PrivacyType

local function getTelemetryGranularity(data)
	return {
		universeId = data.universeId,
		placeId = data.placeId,
		conversationId = data.sessionId
	}
end

local function ExperienceRowActionsMenu(props)
	local v5 = useLocalization({
		archiveGame = LocalizationStrings.GAME_CONFIGURATION_ARCHIVE_GAME,
		publish = LocalizationStrings.BUILD_MENU_PUBLISH,
		settings = LocalizationStrings.BUILD_MENU_SETTINGS,
		share = LocalizationStrings.BUILD_MENU_SHARE
	})

	local archiveGame = v5.archiveGame
	local publish = v5.publish
	local settings2 = v5.settings
	local share = v5.share
	local v6 = useScaledValue(216)
	local target = props.target

	local universeId = if target ~= nil then target.universeId else nil
	local v8 = if target ~= nil then target.placeId else nil
	local v9 = useExperienceShareFlow(universeId, v8)

	local v10 = useArchiveGameFlow({ context = "games_list" })
	local v11, v12

	if FFlagBuildCheckGamePermissions then
		local v15 = if target ~= nil then target.universeId else nil
		local v16 = useGamePermissions({ universeId = v15 })

		v11 = v16.canPublish
		v12 = v16.canEdit
	else
		v11 = true
		v12 = true
	end

	local v13 = v9.audience == nil or v9.audience == privacyType.Private and not FFlagBuildExperiencePrivateInvites

	local v14 = React.useMemo(function()
		return { current = props.anchor }
	end, { props.anchor })

	local v15 = React.useMemo(function()
		return {
			{
				id = "publish",
				text = publish,
				isDisabled = not v11
			},
			{ id = "share", text = share, isDisabled = v13 },
			{
				id = "settings",
				text = settings2,
				isDisabled = not v12
			},
			{
				id = "archive-game",
				text = archiveGame,
				isDisabled = not v12
			}
		}
	end, { archiveGame, v12, v11, v13, publish, settings2, share })

	local onClose = props.onClose
	local onOpenConfigurationPage = props.onOpenConfigurationPage
	local onShare = v9.onShare
	local requestArchive = v10.requestArchive
	local v16 = React.useCallback(function(p2)
		onClose()

		if target == nil then
			return
		end

		if FFlagBuildExperienceHomeTelemetry then
			local v17 = target
			sendBuildExperienceEvent(
				"MY_CREATIONS_MENU_ITEM_CLICK",
				{
					universeId = v17.universeId,
					placeId = v17.placeId,
					conversationId = v17.sessionId
				},
				{ item = tostring(p2) }
			)
		end

		if p2 == "publish" then
			onOpenConfigurationPage("publish", target)
		elseif p2 == "share" then
			onShare()
		elseif p2 == "settings" then
			onOpenConfigurationPage("settings", target)
		elseif p2 == "archive-game" and target.universeId ~= nil then
			requestArchive(target.universeId)
		end
	end, { onClose, onOpenConfigurationPage, onShare, requestArchive, target })

	local v17 = props.isOpen

	if v17 then
		v17 = not (target == nil) and props.anchor ~= nil
	end

	if FFlagBuildExperienceHomeTelemetry then
		React.useEffect(function()
			if v17 and target ~= nil then
				local v18 = target
				sendBuildExperienceEvent("MY_CREATIONS_MENU_OPEN", {
					universeId = v18.universeId,
					placeId = v18.placeId,
					conversationId = v18.sessionId
				})
			end
		end, { v17, target })
	end

	local v18 = useClosableFocusRoot({
		surfaceIdentifier = focusNavigableSurfaceIdentifierEnum.ContextualMenu,
		isOpen = v17,
		onClose = onClose
	})

	local createElement = React.createElement
	local fragment = React.Fragment
	local createElement2 = React.createElement
	local v21 = {
		ref = v18,
		isOpen = v17,
		items = v15,
		anchorRef = v14,
		side = popoverSide.Bottom,
		align = 0,
		size = 0,
		width = 0,
		onActivated = 0,
		onPressedOutside = 0,
		testId = "ExperienceRowActionsMenu"
	}
	local v22 = if props.isAtPointer then popoverAlign.Start else popoverAlign.End
	v21.align = v22
	v21.size = inputSize.Large
	v21.width = UDim.new(0, v6)
	v21.onActivated = v16
	v21.onPressedOutside = onClose
	return createElement(fragment, nil, {
		Menu = createElement2(menu, v21),
		ShareOverlays = React.createElement(ExperienceShareOverlays, {
			activeDialog = v9.activeDialog,
			hasShareError = v9.hasShareError,
			onCancel = v9.onCancelDialog,
			onConfirmFriends = v9.onConfirmFriends,
			onConfirmPlaytesters = v9.onConfirmPlaytesters
		}),
		ArchiveDialog = React.createElement(ArchiveGameDialog, {
			isOpen = v10.isOpen,
			onArchive = v10.confirm,
			onCancel = v10.cancel
		})
	})
end

return ExperienceRowActionsMenu
