local SquadsCore = script:FindFirstAncestor("SquadsCore")
local parent = SquadsCore.Parent

local SquadExternalContractContext = require(SquadsCore.Components.SquadExternalContractProvider.SquadExternalContractContext)
local SquadPromptType = require(SquadsCore.Enums.SquadPromptType)
local EventNames = require(SquadsCore.Analytics.EventNames)
local useCurrentSquadId = require(SquadsCore.Hooks.useCurrentSquadId)

local React = require(parent.React)
local RobloxAppHooks = require(parent.RobloxAppHooks)
local UIBlox = require(parent.UIBlox)
local Cryo = require(parent.Cryo)
local RoactUtils = require(parent.RoactUtils)
local useDispatch = RoactUtils.Hooks.RoactRodux.useDispatch
local Localization = require(parent.Localization)
local useLocalization = Localization.Hooks.useLocalization
local UniversalAppPolicy = require(parent.UniversalAppPolicy)

require(parent.ReactFocusNavigation)
local InputHandlers = require(parent.InputHandlers)
local FocusNavigationUtils = require(parent.FocusNavigationUtils)
local FocusNavigableSurfaceIdentifierEnum = FocusNavigationUtils.FocusNavigableSurfaceIdentifierEnum
local FocusNavigationEventNameEnum = FocusNavigationUtils.FocusNavigationEventNameEnum
local FocusRoot = FocusNavigationUtils.FocusRoot
local defineFastFlag = game:DefineFastFlag("EnableSquadPromptAnalytics", false)

local useScreenSize = RobloxAppHooks.useScreenSize

local ButtonType = UIBlox.App.Button.Enum.ButtonType
local InteractiveAlert = UIBlox.App.Dialog.Alert.InteractiveAlert

local v = { hideCancelButton = false, bodyTextLocalizationProps = nil }

local function getFFlagRenameFriendsToConnectionsPartyLobby() -- 2 equivalent calls inferred from this helper
	return UniversalAppPolicy.getAppFeaturePolicies().getRenameFriendsToConnections()
end

return function(p)
	local joined = Cryo.Dictionary.join(v, p)
	local v2 = React.useContext(SquadExternalContractContext)

	local v3 = useDispatch()
	local v4 = useCurrentSquadId() or ""
	local screenSize

	if joined.screenSize then
		screenSize = joined.screenSize
	else
		screenSize = useScreenSize()
	end

	local v5 = React.useCallback(function(responseType: string)
		v2.fireSquadAnalytics(EventNames.SquadPromptResponded, {
			promptType = joined.promptType,
			squadId = v4 or "",
			responseType = responseType
		})
	end, { joined.promptType, v4, v2.fireSquadAnalytics })

	local onActivated = React.useCallback(function()
		if defineFastFlag then
			v5("cancel")
		end

		v3(v2.closeSquadPrompt())

		if joined.onCancel then
			joined.onCancel()
		end
	end, { v3, joined.onCancel, v2.closeSquadPrompt, v5 })

	local onActivated2 = React.useCallback(function()
		if defineFastFlag then
			v5("confirm")
		end

		v3(v2.closeSquadPrompt())

		if joined.onConfirm then
			joined.onConfirm()
		end
	end, { v3, joined.onConfirm, v2.closeSquadPrompt, v5 })

	local v6 = React.useCallback(function(p2)
		local cancelButtonText = "CommonUI.Controls.Action.Cancel"
		local bodyTextLocalizationProps, title, confirmText

		if p2 == SquadPromptType.AlreadyJoined then
			bodyTextLocalizationProps = "Feature.Squads.Description.AlreadyJoined"
			title = "Feature.Squads.Label.Error"
			confirmText = "Feature.Squads.Action.Ok"
		elseif p2 == SquadPromptType.ConfirmInviteToSquad then
			title = getFFlagRenameFriendsToConnectionsPartyLobby() -- inferred equivalent call
				and "Feature.Squads.Label.InviteConnectionsConfirmation"
				or "Feature.Squads.Label.InviteFriendsConfirmation"
			bodyTextLocalizationProps = getFFlagRenameFriendsToConnectionsPartyLobby() -- inferred equivalent call
				and "Feature.Squads.Description.InviteConnectionsToParty"
				or "Feature.Squads.Description.InviteFriendsToParty"
			confirmText = "Feature.Squads.Action.Yes"
		elseif p2 == SquadPromptType.AddFriends then
			bodyTextLocalizationProps = "Feature.Squads.Description.AddFriends"
			title = "Feature.Squads.Label.AddFriends"
			confirmText = "Feature.Squads.Action.Ok"
		elseif p2 == SquadPromptType.FailedToJoin then
			bodyTextLocalizationProps = "Feature.Squads.Description.FailedToJoin"
			title = "Feature.Squads.Label.FailedToJoin"
			confirmText = "Feature.Squads.Action.Join"
		elseif p2 == SquadPromptType.JoinAnotherSquad then
			bodyTextLocalizationProps = "Feature.Squads.Description.JoinAnotherParty"
			title = "Feature.Squads.Label.JoinAnotherParty"
			confirmText = "Feature.Squads.Action.Switch"
		elseif p2 == SquadPromptType.SquadEnded then
			bodyTextLocalizationProps = "Feature.Squads.Description.PartyEnded"
			title = "Feature.Squads.Label.PartyEnded"
			confirmText = "Feature.Squads.Action.Start"
		elseif p2 == SquadPromptType.SquadFull then
			bodyTextLocalizationProps = "Feature.Squads.Description.PartyFull"
			title = "Feature.Squads.Label.PartyFull"
			confirmText = "Feature.Squads.Action.Join"
		elseif p2 == SquadPromptType.InvitedToExperience then
			bodyTextLocalizationProps = "Feature.Squads.Description.InvitedToExperience"
			title = "Feature.Squads.Label.InvitedToExperience"
			confirmText = "Feature.Squads.Action.Retry"
		elseif p2 == SquadPromptType.RemoveFromChat then
			bodyTextLocalizationProps = "Feature.Squads.Description.RemoveFromChat"
			title = "Feature.Squads.Label.RemoveFromChat"
			confirmText = "Feature.Squads.Action.Remove"
		elseif p2 == SquadPromptType.RemoveFromParty then
			bodyTextLocalizationProps = "Feature.Squads.Description.RemoveFromParty"
			title = "Feature.Squads.Label.RemoveFromParty"
			confirmText = "Feature.Squads.Action.Ok"
		elseif p2 == SquadPromptType.JoinWithLowMemory then
			bodyTextLocalizationProps = "Feature.Squads.Description.JoinWithLowMemory"
			title = "Feature.Squads.Label.LowMemory"
			confirmText = "Feature.Squads.Action.ContinueWithoutVoice"
			cancelButtonText = "Feature.Squads.Action.ConnectToVoice"
		elseif p2 == SquadPromptType.ConnectVoiceWithLowMemory then
			bodyTextLocalizationProps = "Feature.Squads.Description.ConnectVoiceWithLowMemory"
			title = "Feature.Squads.Label.LowMemory"
			confirmText = "Feature.Squads.Action.ContinueWithoutVoice"
			cancelButtonText = "Feature.Squads.Action.ConnectToVoice"
		elseif p2 == SquadPromptType.DisconnectVoiceDueToLowMemory then
			bodyTextLocalizationProps = "Feature.Squads.Description.DisconnectVoiceDueToLowMemory"
			title = "Feature.Squads.Label.LowMemory"
			confirmText = "Feature.Squads.Action.DisconnectFromVoice"
			cancelButtonText = "Feature.Chat.Action.Continue"
		elseif p2 == SquadPromptType.ParticipantChatDisabled then
			bodyTextLocalizationProps = "Feature.Chat.Toast.Error.InvalidUserSelected"
			title = "Feature.Squads.Label.Error"
			confirmText = "Feature.Squads.Action.Ok"
		elseif p2 == SquadPromptType.EuVoiceConsentPrompt then
			bodyTextLocalizationProps = "Feature.Squads.Description.VoiceRecordedDisclosure"
			title = "Feature.Squads.Label.VoiceRecordedTitle"
			confirmText = "Feature.Chat.Action.Continue"
			cancelButtonText = "Feature.Squads.Action.JoinWithoutVoice"
		elseif p2 == SquadPromptType.ConfirmDeleteScheduledSquad then
			bodyTextLocalizationProps = "Feature.Squads.Description.DeleteScheduledSquad"
			title = "Feature.Squads.Label.DeleteScheduledParty"
			confirmText = "CommonUI.Controls.Action.Yes"
		else
			if p2 == SquadPromptType.ScheduledSquadConflict then
				bodyTextLocalizationProps = "Feature.Squads.Description.ScheduledPartyAlreadyExists"
			elseif p2 == SquadPromptType.CannotExpandToGroupChatActiveParty then
				bodyTextLocalizationProps = "Feature.Squads.Description.OneOnOneExpandedChatFeaturesActivePartyError"
			else
				bodyTextLocalizationProps = "Feature.Squads.Description.PleaseTryAgain"
			end

			title = "Feature.Squads.Label.PartyOperationFailed"
			confirmText = "Feature.Squads.Action.Ok"
		end

		if joined.bodyTextLocalizationProps then
			bodyTextLocalizationProps = { bodyTextLocalizationProps }

			for k, bodyTextLocalizationProp in pairs(joined.bodyTextLocalizationProps) do
				bodyTextLocalizationProps[k] = bodyTextLocalizationProp
			end
		end

		return {
			title = title,
			bodyText = bodyTextLocalizationProps,
			confirmText = confirmText,
			cancelButtonText = cancelButtonText
		}
	end, {})

	local v7 = React.useMemo(function()
		return v6(joined.promptType)
	end, { joined.promptType })

	local v8 = useLocalization({
		title = v7.title,
		bodyText = v7.bodyText,
		confirmText = v7.confirmText,
		cancelButtonText = v7.cancelButtonText
	})

	local v9 = React.useCallback(function()
		local v9 = {}

		if not joined.hideCancelButton then
			table.insert(v9, {
				props = { onActivated = onActivated, text = v8.cancelButtonText }
			})
		end

		table.insert(v9, {
			buttonType = ButtonType.PrimarySystem,
			props = { onActivated = onActivated2, text = v8.confirmText }
		})

		return v9
	end, { v8.cancelButtonText, v8.confirmText, joined.hideCancelButton, onActivated2, onActivated })

	local eventHandlers = React.useMemo(function()
		local v10 = {}
		v10[FocusNavigationEventNameEnum.NavigateBack] = {
			handler = InputHandlers.onRelease(function(object)
				onActivated()
				object:cancel()
			end)
		}

		return v10
	end, { onActivated })

	return (React.createElement(
		FocusRoot,
		{
			eventHandlers = eventHandlers,
			isAutoFocusRoot = true,
			isIsolated = true,
			surfaceIdentifier = FocusNavigableSurfaceIdentifierEnum.PopUp
		},
		{ React.createElement(InteractiveAlert, {
				screenSize = screenSize,
				title = v8.title,
				bodyText = v8.bodyText,
				buttonStackInfo = { buttons = v9() }
			}) }
	))
end
