local SquadsCore = script:FindFirstAncestor("SquadsCore")
local SquadsCoreParent = SquadsCore.Parent
local SquadExternalContractContext = require(SquadsCore.Components.SquadExternalContractProvider.SquadExternalContractContext)
local SquadPromptType = require(SquadsCore.Enums.SquadPromptType)
local EventNames = require(SquadsCore.Analytics.EventNames)
local useCurrentSquadId = require(SquadsCore.Hooks.useCurrentSquadId)
local React = require(SquadsCoreParent.React)
local RobloxAppHooks = require(SquadsCoreParent.RobloxAppHooks)
local UIBlox = require(SquadsCoreParent.UIBlox)
local Cryo = require(SquadsCoreParent.Cryo)
local useDispatch = require(SquadsCoreParent.RoactUtils).Hooks.RoactRodux.useDispatch
local useLocalization = require(SquadsCoreParent.Localization).Hooks.useLocalization
local UniversalAppPolicy = require(SquadsCoreParent.UniversalAppPolicy)

require(SquadsCoreParent.ReactFocusNavigation)

local InputHandlers = require(SquadsCoreParent.InputHandlers)
local FocusNavigationUtils = require(SquadsCoreParent.FocusNavigationUtils)
local FocusNavigableSurfaceIdentifierEnum = FocusNavigationUtils.FocusNavigableSurfaceIdentifierEnum
local FocusNavigationEventNameEnum = FocusNavigationUtils.FocusNavigationEventNameEnum
local FocusRoot = FocusNavigationUtils.FocusRoot
local v19 = game:DefineFastFlag("EnableSquadPromptAnalytics", false)
local useScreenSize = RobloxAppHooks.useScreenSize
local ButtonType = UIBlox.App.Button.Enum.ButtonType
local InteractiveAlert = UIBlox.App.Dialog.Alert.InteractiveAlert
local t1 = {
	hideCancelButton = false,
	bodyTextLocalizationProps = nil
}

local function getFFlagRenameFriendsToConnectionsPartyLobby() -- line: 39
	-- upvalues: UniversalAppPolicy (copy)
	return UniversalAppPolicy.getAppFeaturePolicies().getRenameFriendsToConnections()
end

return function(p1) -- line: 43
	-- upvalues: Cryo (copy), t1 (copy), React (copy), SquadExternalContractContext (copy), useDispatch (copy), useCurrentSquadId (copy), useScreenSize (copy), EventNames (copy), v19 (copy), SquadPromptType (copy), UniversalAppPolicy (copy), useLocalization (copy), ButtonType (copy), FocusNavigationEventNameEnum (copy), InputHandlers (copy), FocusRoot (copy), FocusNavigableSurfaceIdentifierEnum (copy), InteractiveAlert (copy)
	local v26 = Cryo.Dictionary.join(t1, p1)
	local v27 = React.useContext(SquadExternalContractContext)
	local v28 = useDispatch()
	local v29 = useCurrentSquadId() or ""
	local v30 = if not v26.screenSize then useScreenSize() else v26.screenSize
	local v31 = React.useCallback(function(s1: string) -- line: 51
		-- upvalues: v27 (copy), EventNames (copy), v26 (copy), v29 (copy)
		v27.fireSquadAnalytics(EventNames.SquadPromptResponded, {
			promptType = v26.promptType,
			squadId = v29 or "",
			responseType = s1
		})
	end, {
		v26.promptType,
		v29,
		v27.fireSquadAnalytics
	})
	local v32 = React.useCallback(function() -- line: 59
		-- upvalues: v19 (copy), v31 (copy), v28 (copy), v27 (copy), v26 (copy)
		if v19 then
			v31("cancel")
		end

		v28(v27.closeSquadPrompt())

		if v26.onCancel then
			v26.onCancel()
		end
	end, {
		v28,
		v26.onCancel,
		v27.closeSquadPrompt,
		v31
	})
	local v33 = React.useCallback(function() -- line: 71
		-- upvalues: v19 (copy), v31 (copy), v28 (copy), v27 (copy), v26 (copy)
		if v19 then
			v31("confirm")
		end

		v28(v27.closeSquadPrompt())

		if v26.onConfirm then
			v26.onConfirm()
		end
	end, {
		v28,
		v26.onConfirm,
		v27.closeSquadPrompt,
		v31
	})
	local v34 = React.useCallback(function(p2) -- line: 83
		-- upvalues: SquadPromptType (copy), UniversalAppPolicy (copy), v26 (copy)
		local s2 = "CommonUI.Controls.Action.Cancel"
		local s3, s4, s5

		if p2 == SquadPromptType.AlreadyJoined then
			s3 = "Feature.Squads.Label.Error"
			s4 = "Feature.Squads.Description.AlreadyJoined"
			s5 = "Feature.Squads.Action.Ok"
		elseif p2 == SquadPromptType.ConfirmInviteToSquad then
			s3 = not UniversalAppPolicy.getAppFeaturePolicies().getRenameFriendsToConnections() and "Feature.Squads.Label.InviteFriendsConfirmation" or "Feature.Squads.Label.InviteConnectionsConfirmation"
			s4 = not UniversalAppPolicy.getAppFeaturePolicies().getRenameFriendsToConnections() and "Feature.Squads.Description.InviteFriendsToParty" or "Feature.Squads.Description.InviteConnectionsToParty"
			s5 = "Feature.Squads.Action.Yes"
		elseif p2 == SquadPromptType.AddFriends then
			s3 = "Feature.Squads.Label.AddFriends"
			s4 = "Feature.Squads.Description.AddFriends"
			s5 = "Feature.Squads.Action.Ok"
		elseif p2 == SquadPromptType.FailedToJoin then
			s3 = "Feature.Squads.Label.FailedToJoin"
			s4 = "Feature.Squads.Description.FailedToJoin"
			s5 = "Feature.Squads.Action.Join"
		elseif p2 == SquadPromptType.JoinAnotherSquad then
			s3 = "Feature.Squads.Label.JoinAnotherParty"
			s4 = "Feature.Squads.Description.JoinAnotherParty"
			s5 = "Feature.Squads.Action.Switch"
		elseif p2 == SquadPromptType.SquadEnded then
			s3 = "Feature.Squads.Label.PartyEnded"
			s4 = "Feature.Squads.Description.PartyEnded"
			s5 = "Feature.Squads.Action.Start"
		elseif p2 == SquadPromptType.SquadFull then
			s3 = "Feature.Squads.Label.PartyFull"
			s4 = "Feature.Squads.Description.PartyFull"
			s5 = "Feature.Squads.Action.Join"
		elseif p2 == SquadPromptType.InvitedToExperience then
			s3 = "Feature.Squads.Label.InvitedToExperience"
			s4 = "Feature.Squads.Description.InvitedToExperience"
			s5 = "Feature.Squads.Action.Retry"
		elseif p2 == SquadPromptType.RemoveFromChat then
			s3 = "Feature.Squads.Label.RemoveFromChat"
			s4 = "Feature.Squads.Description.RemoveFromChat"
			s5 = "Feature.Squads.Action.Remove"
		elseif p2 == SquadPromptType.RemoveFromParty then
			s3 = "Feature.Squads.Label.RemoveFromParty"
			s4 = "Feature.Squads.Description.RemoveFromParty"
			s5 = "Feature.Squads.Action.Ok"
		elseif p2 == SquadPromptType.JoinWithLowMemory then
			s3 = "Feature.Squads.Label.LowMemory"
			s4 = "Feature.Squads.Description.JoinWithLowMemory"
			s5 = "Feature.Squads.Action.ContinueWithoutVoice"
			s2 = "Feature.Squads.Action.ConnectToVoice"
		elseif p2 == SquadPromptType.ConnectVoiceWithLowMemory then
			s3 = "Feature.Squads.Label.LowMemory"
			s4 = "Feature.Squads.Description.ConnectVoiceWithLowMemory"
			s5 = "Feature.Squads.Action.ContinueWithoutVoice"
			s2 = "Feature.Squads.Action.ConnectToVoice"
		elseif p2 == SquadPromptType.DisconnectVoiceDueToLowMemory then
			s3 = "Feature.Squads.Label.LowMemory"
			s4 = "Feature.Squads.Description.DisconnectVoiceDueToLowMemory"
			s5 = "Feature.Squads.Action.DisconnectFromVoice"
			s2 = "Feature.Chat.Action.Continue"
		elseif p2 == SquadPromptType.ParticipantChatDisabled then
			s3 = "Feature.Squads.Label.Error"
			s4 = "Feature.Chat.Toast.Error.InvalidUserSelected"
			s5 = "Feature.Squads.Action.Ok"
		elseif p2 == SquadPromptType.EuVoiceConsentPrompt then
			s3 = "Feature.Squads.Label.VoiceRecordedTitle"
			s4 = "Feature.Squads.Description.VoiceRecordedDisclosure"
			s5 = "Feature.Chat.Action.Continue"
			s2 = "Feature.Squads.Action.JoinWithoutVoice"
		elseif p2 == SquadPromptType.ConfirmDeleteScheduledSquad then
			s3 = "Feature.Squads.Label.DeleteScheduledParty"
			s4 = "Feature.Squads.Description.DeleteScheduledSquad"
			s5 = "CommonUI.Controls.Action.Yes"
		elseif p2 == SquadPromptType.ScheduledSquadConflict then
			s3 = "Feature.Squads.Label.PartyOperationFailed"
			s4 = "Feature.Squads.Description.ScheduledPartyAlreadyExists"
			s5 = "Feature.Squads.Action.Ok"
		elseif p2 == SquadPromptType.CannotExpandToGroupChatActiveParty then
			s3 = "Feature.Squads.Label.PartyOperationFailed"
			s4 = "Feature.Squads.Description.OneOnOneExpandedChatFeaturesActivePartyError"
			s5 = "Feature.Squads.Action.Ok"
		else
			s3 = "Feature.Squads.Label.PartyOperationFailed"
			s4 = "Feature.Squads.Description.PleaseTryAgain"
			s5 = "Feature.Squads.Action.Ok"
		end

		if v26.bodyTextLocalizationProps then
			s4 = { s4 }

			for k, v in pairs(v26.bodyTextLocalizationProps) do
				s4[k] = v
			end
		end

		return {
			title = s3,
			bodyText = s4,
			confirmText = s5,
			cancelButtonText = s2
		}
	end, {})
	local v35 = React.useMemo(function() -- line: 184
		-- upvalues: v34 (copy), v26 (copy)
		return v34(v26.promptType)
	end, { v26.promptType })
	local v36 = useLocalization({
		title = v35.title,
		bodyText = v35.bodyText,
		confirmText = v35.confirmText,
		cancelButtonText = v35.cancelButtonText
	})
	local v37 = React.useCallback(function() -- line: 195
		-- upvalues: v26 (copy), v32 (copy), v36 (copy), ButtonType (copy), v33 (copy)
		local t2 = {}

		if not v26.hideCancelButton then
			table.insert(t2, {
				props = {
					onActivated = v32,
					text = v36.cancelButtonText
				}
			})
		end

		table.insert(t2, {
			buttonType = ButtonType.PrimarySystem,
			props = {
				onActivated = v33,
				text = v36.confirmText
			}
		})

		return t2
	end, {
		v36.cancelButtonText,
		v36.confirmText,
		v26.hideCancelButton,
		v33,
		v32
	})
	local v38 = React.useMemo(function() -- line: 223
		-- upvalues: FocusNavigationEventNameEnum (copy), InputHandlers (copy), v32 (copy)
		return {
			[FocusNavigationEventNameEnum.NavigateBack] = {
				handler = InputHandlers.onRelease(function(p3) -- line: 226
					-- upvalues: v32 (copy)
					v32()
					p3:cancel()
				end)
			}
		}
	end, { v32 })

	return (React.createElement(FocusRoot, {
		isAutoFocusRoot = true,
		isIsolated = true,
		eventHandlers = v38,
		surfaceIdentifier = FocusNavigableSurfaceIdentifierEnum.PopUp
	}, { React.createElement(InteractiveAlert, {
		screenSize = v30,
		title = v36.title,
		bodyText = v36.bodyText,
		buttonStackInfo = {
			buttons = v37()
		}
	}) }))
end
