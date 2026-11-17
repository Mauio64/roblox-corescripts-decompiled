local BuildExperience = script:FindFirstAncestor("BuildExperience")
local parent = BuildExperience.Parent

local FocusNavigationUtils = require(parent.FocusNavigationUtils)
local Foundation = require(parent.Foundation)
local React = require(parent.React)
local UniverseConfiguration = require(parent.DataHydration.UniverseConfiguration)
local Localization = require(parent.Localization)
local useLocalization = Localization.Hooks.useLocalization
local LocalizationStrings = require(BuildExperience.LocalizationStrings)

local ArchiveGameDialog = require(BuildExperience.Components.GameConfigurations.ArchiveGameDialog)
require(BuildExperience.Chat.chatTypes)
local ExperienceShareOverlays = require(BuildExperience.Components.ShareAudience.ExperienceShareOverlays)
require(BuildExperience.Stores.GetBuildOverflowMenuStore.createBuildOverflowMenuStore)
local useArchiveGameFlow = require(BuildExperience.utils.useArchiveGameFlow)
local useClosableFocusRoot = require(BuildExperience.utils.useClosableFocusRoot)
local useExperienceShareFlow = require(BuildExperience.utils.useExperienceShareFlow)
local useGamePermissions = require(BuildExperience.useGamePermissions)
local FFlagBuildExperiencePrivateInvites = require(BuildExperience.Flags.FFlagBuildExperiencePrivateInvites)
local FFlagBuildCheckGamePermissions = require(BuildExperience.Flags.FFlagBuildCheckGamePermissions)
local FFlagBuildExperienceHomeTelemetry = require(BuildExperience.Flags.FFlagBuildExperienceHomeTelemetry)
local sendBuildExperienceEvent = require(BuildExperience.Telemetry.sendBuildExperienceEvent)

local FocusNavigableSurfaceIdentifierEnum = FocusNavigationUtils.FocusNavigableSurfaceIdentifierEnum
local Menu = Foundation.Menu
local useScaledValue = Foundation.Hooks.useScaledValue
local InputSize = Foundation.Enums.InputSize
local PopoverAlign = Foundation.Enums.PopoverAlign
local PopoverSide = Foundation.Enums.PopoverSide
local PrivacyType = UniverseConfiguration.PrivacyType

local function getTelemetryGranularity(target) -- 2 equivalent calls inferred from this helper
	return {
		universeId = target.universeId,
		placeId = target.placeId,
		conversationId = target.sessionId
	}
end

local function ExperienceRowActionsMenu(props)
	local v = useLocalization({
		archiveGame = LocalizationStrings.GAME_CONFIGURATION_ARCHIVE_GAME,
		publish = LocalizationStrings.BUILD_MENU_PUBLISH,
		settings = LocalizationStrings.BUILD_MENU_SETTINGS,
		share = LocalizationStrings.BUILD_MENU_SHARE
	})

	local archiveGame = v.archiveGame
	local publish = v.publish
	local settings = v.settings
	local share = v.share
	local v2 = useScaledValue(216)
	local target = props.target
	local universeId

	if target ~= nil then
		universeId = target.universeId
	end

	local v3

	if target ~= nil then
		v3 = target.placeId
	end

	local v4 = useExperienceShareFlow(universeId, v3)

	local v5 = useArchiveGameFlow({ context = "games_list" })
	local v6, v7

	if FFlagBuildCheckGamePermissions then
		local universeId2

		if target ~= nil then
			universeId2 = target.universeId
		end

		local v8 = useGamePermissions({ universeId = universeId2 })

		v6 = v8.canPublish
		v7 = v8.canEdit
	else
		v6 = true
		v7 = true
	end

	local isDisabled

	if v4.audience == nil then
		isDisabled = true
	elseif v4.audience == PrivacyType.Private then
		isDisabled = not FFlagBuildExperiencePrivateInvites
	else
		isDisabled = false
	end

	local anchorRef = React.useMemo(function()
		return { current = props.anchor }
	end, { props.anchor })

	local items = React.useMemo(function()
		return {
			{
				id = "publish",
				text = publish,
				isDisabled = not v6
			},
			{ id = "share", text = share, isDisabled = isDisabled },
			{
				id = "settings",
				text = settings,
				isDisabled = not v7
			},
			{
				id = "archive-game",
				text = archiveGame,
				isDisabled = not v7
			}
		}
	end, { archiveGame, v7, v6, isDisabled, publish, settings, share })

	local onClose = props.onClose
	local onOpenConfigurationPage = props.onOpenConfigurationPage
	local onShare = v4.onShare
	local requestArchive = v5.requestArchive
	local onActivated = React.useCallback(function(p)
		onClose()

		if target == nil then
			return
		end

		if FFlagBuildExperienceHomeTelemetry then
			sendBuildExperienceEvent("MY_CREATIONS_MENU_ITEM_CLICK", getTelemetryGranularity(target), { -- inferred equivalent call
				item = tostring(p)
			})
		end

		if p == "publish" then
			onOpenConfigurationPage("publish", target)
		elseif p == "share" then
			onShare()
		elseif p == "settings" then
			onOpenConfigurationPage("settings", target)
		elseif p == "archive-game" and target.universeId ~= nil then
			requestArchive(target.universeId)
		end
	end, { onClose, onOpenConfigurationPage, onShare, requestArchive, target })

	local isOpen = props.isOpen

	if isOpen then
		if target == nil then
			isOpen = false
		else
			isOpen = props.anchor ~= nil
		end
	end

	if FFlagBuildExperienceHomeTelemetry then
		React.useEffect(function()
			if isOpen and target ~= nil then
				sendBuildExperienceEvent("MY_CREATIONS_MENU_OPEN", getTelemetryGranularity(target)) -- inferred equivalent call
			end
		end, { isOpen, target })
	end

	local ref = useClosableFocusRoot({
		surfaceIdentifier = FocusNavigableSurfaceIdentifierEnum.ContextualMenu,
		isOpen = isOpen,
		onClose = onClose
	})

	local createElement = React.createElement
	local fragment = React.Fragment
	local createElement2 = React.createElement
	local v8 = {
		ref = ref,
		isOpen = isOpen,
		items = items,
		anchorRef = anchorRef,
		side = PopoverSide.Bottom,
		align = 0,
		size = 0,
		width = 0,
		onActivated = 0,
		onPressedOutside = 0,
		testId = "ExperienceRowActionsMenu"
	}
	local align

	if props.isAtPointer then
		align = PopoverAlign.Start
	else
		align = PopoverAlign.End
	end

	v8.align = align
	v8.size = InputSize.Large
	v8.width = UDim.new(0, v2)
	v8.onActivated = onActivated
	v8.onPressedOutside = onClose
	return createElement(fragment, nil, {
		Menu = createElement2(Menu, v8),
		ShareOverlays = React.createElement(ExperienceShareOverlays, {
			activeDialog = v4.activeDialog,
			hasShareError = v4.hasShareError,
			onCancel = v4.onCancelDialog,
			onConfirmFriends = v4.onConfirmFriends,
			onConfirmPlaytesters = v4.onConfirmPlaytesters
		}),
		ArchiveDialog = React.createElement(ArchiveGameDialog, {
			isOpen = v5.isOpen,
			onArchive = v5.confirm,
			onCancel = v5.cancel
		})
	})
end

return ExperienceRowActionsMenu
