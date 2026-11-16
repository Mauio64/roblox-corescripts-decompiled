local SquadExternalContractContext = require("@game/CorePackages/Workspace/Packages/_Workspace/SquadsCore/SquadsCore/Components/SquadExternalContractProvider/SquadExternalContractContext")
local SquadPromptType = require("@game/CorePackages/Workspace/Packages/_Workspace/SquadsCore/SquadsCore/Enums/SquadPromptType")
local EventNames = require("@game/CorePackages/Workspace/Packages/_Workspace/SquadsCore/SquadsCore/Analytics/EventNames")
local useCurrentSquadId = require("@game/CorePackages/Workspace/Packages/_Workspace/SquadsCore/SquadsCore/Hooks/useCurrentSquadId")

local React = require("@game/CorePackages/Workspace/Packages/_Workspace/SquadsCore/React")
local RobloxAppHooks = require("@game/CorePackages/Workspace/Packages/_Workspace/SquadsCore/RobloxAppHooks")
local UIBlox = require("@game/CorePackages/Workspace/Packages/_Workspace/SquadsCore/UIBlox")
local Cryo = require("@game/CorePackages/Workspace/Packages/_Workspace/SquadsCore/Cryo")
local useDispatch = require("@game/CorePackages/Workspace/Packages/_Workspace/SquadsCore/RoactUtils").Hooks.RoactRodux.useDispatch
local useLocalization = require("@game/CorePackages/Workspace/Packages/_Workspace/SquadsCore/Localization").Hooks.useLocalization
local UniversalAppPolicy = require("@game/CorePackages/Workspace/Packages/_Workspace/SquadsCore/UniversalAppPolicy")

require("@game/CorePackages/Workspace/Packages/_Workspace/SquadsCore/ReactFocusNavigation")
local InputHandlers = require("@game/CorePackages/Workspace/Packages/_Workspace/SquadsCore/InputHandlers")
local FocusNavigationUtils = require("@game/CorePackages/Workspace/Packages/_Workspace/SquadsCore/FocusNavigationUtils")
local focusNavigableSurfaceIdentifierEnum = FocusNavigationUtils.FocusNavigableSurfaceIdentifierEnum
local focusNavigationEventNameEnum = FocusNavigationUtils.FocusNavigationEventNameEnum
local focusRoot = FocusNavigationUtils.FocusRoot
local defineFastFlag = game:DefineFastFlag("EnableSquadPromptAnalytics", false)

local useScreenSize = RobloxAppHooks.useScreenSize

local buttonType = UIBlox.App.Button.Enum.ButtonType
local interactiveAlert = UIBlox.App.Dialog.Alert.InteractiveAlert

local v5 = { hideCancelButton = false, bodyTextLocalizationProps = nil }

local function getFFlagRenameFriendsToConnectionsPartyLobby()
	return UniversalAppPolicy.getAppFeaturePolicies().getRenameFriendsToConnections()
end

return function(p2)
	local joined = Cryo.Dictionary.join(v5, p2)
	local v6 = React.useContext(SquadExternalContractContext)

	local v7 = useDispatch()
	local v8 = useCurrentSquadId() or ""
	local v9 = if joined.screenSize then joined.screenSize else useScreenSize()

	local v10 = React.useCallback(function(p3)
		v6.fireSquadAnalytics(EventNames.SquadPromptResponded, {
			promptType = joined.promptType,
			squadId = v8 or "",
			responseType = p3
		})
	end, { joined.promptType, v8, v6.fireSquadAnalytics })

	local v11 = React.useCallback(function()
		if defineFastFlag then
			v10("cancel")
		end

		v7(v6.closeSquadPrompt())

		if joined.onCancel then
			joined.onCancel()
		end
	end, { v7, joined.onCancel, v6.closeSquadPrompt, v10 })

	local v12 = React.useCallback(function()
		if defineFastFlag then
			v10("confirm")
		end

		v7(v6.closeSquadPrompt())

		if joined.onConfirm then
			joined.onConfirm()
		end
	end, { v7, joined.onConfirm, v6.closeSquadPrompt, v10 })

	local v13 = React.useCallback(function(p3)
		local v14 = "CommonUI.Controls.Action.Cancel"
		local bodyTextLocalizationProps, v15, v16

		if p3 == SquadPromptType.AlreadyJoined then
			bodyTextLocalizationProps = "Feature.Squads.Description.AlreadyJoined"
			v15 = "Feature.Squads.Label.Error"
			v16 = "Feature.Squads.Action.Ok"
		elseif p3 == SquadPromptType.ConfirmInviteToSquad then
			v15 = UniversalAppPolicy.getAppFeaturePolicies().getRenameFriendsToConnections()
				and "Feature.Squads.Label.InviteConnectionsConfirmation"
				or "Feature.Squads.Label.InviteFriendsConfirmation"
			bodyTextLocalizationProps = UniversalAppPolicy.getAppFeaturePolicies().getRenameFriendsToConnections()
				and "Feature.Squads.Description.InviteConnectionsToParty"
				or "Feature.Squads.Description.InviteFriendsToParty"
			v16 = "Feature.Squads.Action.Yes"
		elseif p3 == SquadPromptType.AddFriends then
			bodyTextLocalizationProps = "Feature.Squads.Description.AddFriends"
			v15 = "Feature.Squads.Label.AddFriends"
			v16 = "Feature.Squads.Action.Ok"
		elseif p3 == SquadPromptType.FailedToJoin then
			bodyTextLocalizationProps = "Feature.Squads.Description.FailedToJoin"
			v15 = "Feature.Squads.Label.FailedToJoin"
			v16 = "Feature.Squads.Action.Join"
		elseif p3 == SquadPromptType.JoinAnotherSquad then
			bodyTextLocalizationProps = "Feature.Squads.Description.JoinAnotherParty"
			v15 = "Feature.Squads.Label.JoinAnotherParty"
			v16 = "Feature.Squads.Action.Switch"
		elseif p3 == SquadPromptType.SquadEnded then
			bodyTextLocalizationProps = "Feature.Squads.Description.PartyEnded"
			v15 = "Feature.Squads.Label.PartyEnded"
			v16 = "Feature.Squads.Action.Start"
		elseif p3 == SquadPromptType.SquadFull then
			bodyTextLocalizationProps = "Feature.Squads.Description.PartyFull"
			v15 = "Feature.Squads.Label.PartyFull"
			v16 = "Feature.Squads.Action.Join"
		elseif p3 == SquadPromptType.InvitedToExperience then
			bodyTextLocalizationProps = "Feature.Squads.Description.InvitedToExperience"
			v15 = "Feature.Squads.Label.InvitedToExperience"
			v16 = "Feature.Squads.Action.Retry"
		elseif p3 == SquadPromptType.RemoveFromChat then
			bodyTextLocalizationProps = "Feature.Squads.Description.RemoveFromChat"
			v15 = "Feature.Squads.Label.RemoveFromChat"
			v16 = "Feature.Squads.Action.Remove"
		elseif p3 == SquadPromptType.RemoveFromParty then
			bodyTextLocalizationProps = "Feature.Squads.Description.RemoveFromParty"
			v15 = "Feature.Squads.Label.RemoveFromParty"
			v16 = "Feature.Squads.Action.Ok"
		elseif p3 == SquadPromptType.JoinWithLowMemory then
			bodyTextLocalizationProps = "Feature.Squads.Description.JoinWithLowMemory"
			v15 = "Feature.Squads.Label.LowMemory"
			v16 = "Feature.Squads.Action.ContinueWithoutVoice"
			v14 = "Feature.Squads.Action.ConnectToVoice"
		elseif p3 == SquadPromptType.ConnectVoiceWithLowMemory then
			bodyTextLocalizationProps = "Feature.Squads.Description.ConnectVoiceWithLowMemory"
			v15 = "Feature.Squads.Label.LowMemory"
			v16 = "Feature.Squads.Action.ContinueWithoutVoice"
			v14 = "Feature.Squads.Action.ConnectToVoice"
		elseif p3 == SquadPromptType.DisconnectVoiceDueToLowMemory then
			bodyTextLocalizationProps = "Feature.Squads.Description.DisconnectVoiceDueToLowMemory"
			v15 = "Feature.Squads.Label.LowMemory"
			v16 = "Feature.Squads.Action.DisconnectFromVoice"
			v14 = "Feature.Chat.Action.Continue"
		elseif p3 == SquadPromptType.ParticipantChatDisabled then
			bodyTextLocalizationProps = "Feature.Chat.Toast.Error.InvalidUserSelected"
			v15 = "Feature.Squads.Label.Error"
			v16 = "Feature.Squads.Action.Ok"
		elseif p3 == SquadPromptType.EuVoiceConsentPrompt then
			bodyTextLocalizationProps = "Feature.Squads.Description.VoiceRecordedDisclosure"
			v15 = "Feature.Squads.Label.VoiceRecordedTitle"
			v16 = "Feature.Chat.Action.Continue"
			v14 = "Feature.Squads.Action.JoinWithoutVoice"
		elseif p3 == SquadPromptType.ConfirmDeleteScheduledSquad then
			bodyTextLocalizationProps = "Feature.Squads.Description.DeleteScheduledSquad"
			v15 = "Feature.Squads.Label.DeleteScheduledParty"
			v16 = "CommonUI.Controls.Action.Yes"
		else
			if p3 == SquadPromptType.ScheduledSquadConflict then
				bodyTextLocalizationProps = "Feature.Squads.Description.ScheduledPartyAlreadyExists"
			elseif p3 == SquadPromptType.CannotExpandToGroupChatActiveParty then
				bodyTextLocalizationProps = "Feature.Squads.Description.OneOnOneExpandedChatFeaturesActivePartyError"
			else
				bodyTextLocalizationProps = "Feature.Squads.Description.PleaseTryAgain"
			end

			v15 = "Feature.Squads.Label.PartyOperationFailed"
			v16 = "Feature.Squads.Action.Ok"
		end

		if joined.bodyTextLocalizationProps then
			bodyTextLocalizationProps = { bodyTextLocalizationProps }

			for k, bodyTextLocalizationProp in pairs(joined.bodyTextLocalizationProps) do
				bodyTextLocalizationProps[k] = bodyTextLocalizationProp
			end
		end

		return {
			title = v15,
			bodyText = bodyTextLocalizationProps,
			confirmText = v16,
			cancelButtonText = v14
		}
	end, {})

	local v14 = React.useMemo(function()
		return v13(joined.promptType)
	end, { joined.promptType })

	local v15 = useLocalization({
		title = v14.title,
		bodyText = v14.bodyText,
		confirmText = v14.confirmText,
		cancelButtonText = v14.cancelButtonText
	})

	local v16 = React.useCallback(function()
		local v17 = {}

		if not joined.hideCancelButton then
			table.insert(v17, {
				props = { onActivated = v11, text = v15.cancelButtonText }
			})
		end

		table.insert(v17, {
			buttonType = buttonType.PrimarySystem,
			props = { onActivated = v12, text = v15.confirmText }
		})

		return v17
	end, { v15.cancelButtonText, v15.confirmText, joined.hideCancelButton, v12, v11 })

	local v17 = React.useMemo(function()
		local v18 = {}
		v18[focusNavigationEventNameEnum.NavigateBack] = {
			handler = InputHandlers.onRelease(function(object)
				v11()
				object:cancel()
			end)
		}

		return v18
	end, { v11 })

	return React.createElement(
		focusRoot,
		{
			eventHandlers = v17,
			isAutoFocusRoot = true,
			isIsolated = true,
			surfaceIdentifier = focusNavigableSurfaceIdentifierEnum.PopUp
		},
		{ React.createElement(interactiveAlert, {
				screenSize = v9,
				title = v15.title,
				bodyText = v15.bodyText,
				buttonStackInfo = { buttons = v16() }
			}) }
	)
end
