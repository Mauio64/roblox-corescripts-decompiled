local React = require("@game/CorePackages/Workspace/Packages/_Workspace/Squads/React")
local CrossExperienceVoice = require("@game/CorePackages/Workspace/Packages/_Workspace/Squads/CrossExperienceVoice")
local FocusNavigationUtils = require("@game/CorePackages/Workspace/Packages/_Workspace/Squads/FocusNavigationUtils")
local InputHandlers = require("@game/CorePackages/Workspace/Packages/_Workspace/Squads/InputHandlers")
require("@game/CorePackages/Workspace/Packages/_Workspace/Squads/ReactFocusNavigation")
local useLocalUserId = require("@game/CorePackages/Workspace/Packages/_Workspace/Squads/RobloxAppHooks").useLocalUserId

local dependencies = require("@game/CorePackages/Workspace/Packages/_Index/Squads/Squads/dependencies")
require("@game/CorePackages/Workspace/Packages/_Index/Squads/Squads/Common/ModelTypes")
local SquadPartySheetActionEnum = require("@game/CorePackages/Workspace/Packages/_Index/Squads/Squads/Enums/SquadPartySheetActionEnum")
local useSquadUserDropdownMenuButtons = require("@game/CorePackages/Workspace/Packages/_Index/Squads/Squads/Hooks/useSquadUserDropdownMenuButtons")

local EventNames = require("@game/CorePackages/Workspace/Packages/_Index/Squads/SquadsCore/EventNames")

local squadExternalContractContext = require("@game/CorePackages/Workspace/Packages/_Index/Squads/SquadsCore/SquadExternalContractProvider").SquadExternalContractContext
local squadPromptType = require("@game/CorePackages/Workspace/Packages/_Index/Squads/SquadsCore/Enums").SquadPromptType
local useCurrentSquadParentChannelId = require("@game/CorePackages/Workspace/Packages/_Index/Squads/SquadsCore/Hooks").useCurrentSquadParentChannelId

require("@game/CorePackages/Workspace/Packages/_Index/Squads/Squads/Components/SquadLobby/SquadLobbyUserOverflowMenu/SquadLobbyUserOverflowMenuView")

local useDispatch = dependencies.Hooks.useDispatch
local useLocalization = dependencies.Hooks.useLocalization
local useStore = dependencies.Hooks.useStore
local useBackgroundExperience = CrossExperienceVoice.Hooks.useBackgroundExperience
local useParticipants = CrossExperienceVoice.Hooks.useParticipants
local useVoiceStatus = CrossExperienceVoice.Hooks.useVoiceStatus
local useIsParticipantMutedLocally = CrossExperienceVoice.Hooks.useIsParticipantMutedLocally
local default = CrossExperienceVoice.CrossExperienceVoiceManager.default
local getFFlagEnableCrossExpVoice = dependencies.SharedFlags.GetFFlagEnableCrossExpVoice

local focusNavigableSurfaceIdentifierEnum = FocusNavigationUtils.FocusNavigableSurfaceIdentifierEnum
local focusNavigationEventNameEnum = FocusNavigationUtils.FocusNavigationEventNameEnum
local useFocusRoot = FocusNavigationUtils.useFocusRoot

local navigateBacks = {
	[Enum.KeyCode.ButtonB] = focusNavigationEventNameEnum.NavigateBack,
	[Enum.KeyCode.Escape] = focusNavigationEventNameEnum.NavigateBack
}

local v5 = {
	"MuteVoiceButton",
	"ReportButton",
	"RemoveUserButton",
	"VoiceIneligibleButton"
}

local function useSquadLobbyUserOverflowMenuViewModel(data)
	local userId = data.userId
	local state, setState = React.useState(false)

	local v6 = React.useContext(squadExternalContractContext)
	local v7 = useDispatch()
	local v8 = useStore()
	local v9 = useLocalUserId()
	local v10 = useVoiceStatus()
	local v11 = useCurrentSquadParentChannelId() or ""
	local v12 = useSquadUserDropdownMenuButtons(userId, data.isInExperience)
	local v13 = useIsParticipantMutedLocally(tonumber(userId) or -1)

	local v14 = useLocalization({
		removeFromGroup = "Feature.Chat.Action.RemoveFromGroup",
		reportUser = "Feature.Chat.Action.ReportUser",
		muteVoice = "Feature.Chat.Action.MuteVoice",
		unmuteVoice = "Feature.Chat.Action.UnmuteVoice",
		voiceIneligible = "Feature.Squads.Label.UserDropdownMenuVoiceErrorUserIneligible"
	})
	local v15, voiceChannelId, voiceSessionId

	if getFFlagEnableCrossExpVoice() then
		local v16 = useBackgroundExperience()
		local v17 = useParticipants() or {}
		v15 = React.useMemo(function()
			local userIds = {}

			for k, v18 in pairs(v17) do
				table.insert(userIds, v18.userId)
			end

			return userIds
		end, { v17 })
		voiceChannelId = if v16 then v16.voiceChannelId else nil
		voiceSessionId = if v16 then v16.voiceSessionId else nil
	else
		voiceChannelId = nil
		voiceSessionId = nil
		v15 = {}
	end

	local v16 = React.useCallback(function()
		setState(false)
	end, {})

	local v17 = React.useCallback(function()
		setState(function(p2): boolean
			return not p2
		end)
	end, {})

	local v18 = React.useCallback(function()
		v6.fireSquadAnalytics(EventNames.PartySheetAction, {
			parentChannelId = v11,
			actionType = SquadPartySheetActionEnum.RemoveUserDropDownButtonClicked,
			voiceStatus = v10
		})

		v6.setSquadPrompt(v8, {
			promptType = squadPromptType.RemoveFromChat,
			onConfirm = function()
				if userId == "" or v11 == "" then
					return nil
				end

				v6.fireSquadAnalytics(EventNames.PartySheetAction, {
					parentChannelId = v11,
					actionType = SquadPartySheetActionEnum.RemoveUserDialogButtonClicked,
					voiceStatus = v10
				})

				return v6.removeUserFromParentChannel(v7, v11, userId)
			end
		})
	end, { v6, v8, v7, v11, userId, v10 })

	local v19 = React.useCallback(function()
		data.openSquadVoiceAbuseReport({
			submitterUserId = tostring(v9),
			abuserUserId = userId,
			reportBeginTimestampMs = workspace:GetServerTimeNow() * 1000,
			voiceChannelId = voiceChannelId,
			voiceSessionId = voiceSessionId,
			voiceUserIds = v15,
			voiceUserCount = #v15
		})
	end, {
		data.openSquadVoiceAbuseReport,
		v9,
		userId,
		voiceChannelId,
		voiceSessionId,
		v15
	})

	local v20 = React.useCallback(function()
		local v21 = tonumber(userId)

		if not v21 then
			return
		end

		if v13 then
			default:unmuteVoiceParticipant(v21)
		else
			default:muteVoiceParticipant(v21)
		end
	end, { userId, v13 })

	local v21 = React.useMemo(function()
		local function closeThen(callback)
			return function()
				v16()
				callback()
			end
		end

		local v24 = if v13 then v14.unmuteVoice else v14.muteVoice
		local v25 = v20

		local v26 = { id = "ReportButton", text = v14.reportUser, onActivated = 0 }
		local v27 = v19

		function v26.onActivated()
			v16()
			v27()
		end

		local v22 = {
			MuteVoiceButton = {
				id = "MuteVoiceButton",
				text = v24,
				onActivated = function()
					v16()
					v25()
				end
			},
			ReportButton = v26,
			RemoveUserButton = 0,
			VoiceIneligibleButton = 0
		}

		local v28 = {
			id = "RemoveUserButton",
			text = v14.removeFromGroup,
			onActivated = 0
		}
		local v29 = v18

		function v28.onActivated()
			v16()
			v29()
		end

		v22.RemoveUserButton = v28

		v22.VoiceIneligibleButton = {
			id = "VoiceIneligibleButton",
			text = v14.voiceIneligible,
			isDisabled = true
		}

		local result = {}

		for k, v30 in v5 do
			if table.find(v12, v30) then
				table.insert(result, v22[v30])
			end
		end

		return result
	end, { v12, v14, v13, v16, v18, v19, v20 })

	local v22 = React.useMemo(function()
		return {
			[focusNavigationEventNameEnum.NavigateBack] = {
				handler = InputHandlers.onRelease(function(object)
					v16()
					object:cancel()
				end)
			}
		}
	end, { v16 })

	return {
		isOpen = state,
		items = v21,
		onTriggerActivated = v17,
		onClose = v16,
		menuRef = useFocusRoot({
			surfaceIdentifier = focusNavigableSurfaceIdentifierEnum.ContextualMenu,
			isFocusable = state,
			isAutoFocusRoot = true,
			shouldRestoreFocus = false,
			eventMap = navigateBacks,
			eventHandlers = v22
		}),
		testId = `--social-squad-lobby-user-card-{userId}--overflow`
	}
end

return useSquadLobbyUserOverflowMenuViewModel
