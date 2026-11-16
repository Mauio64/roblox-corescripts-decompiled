local Squads = script:FindFirstAncestor("Squads")
local parent = Squads.Parent
local React = require(parent.React)
local CrossExperienceVoice = require(parent.CrossExperienceVoice)
local FocusNavigationUtils = require(parent.FocusNavigationUtils)
local InputHandlers = require(parent.InputHandlers)
require(parent.ReactFocusNavigation)
local RobloxAppHooks = require(parent.RobloxAppHooks)
local useLocalUserId = RobloxAppHooks.useLocalUserId

local dependencies = require(Squads.dependencies)
require(Squads.Common.ModelTypes)
local SquadPartySheetActionEnum = require(Squads.Enums.SquadPartySheetActionEnum)
local useSquadUserDropdownMenuButtons = require(Squads.Hooks.useSquadUserDropdownMenuButtons)

local EventNames = require(parent.SquadsCore.EventNames)

local SquadExternalContractProvider = require(parent.SquadsCore.SquadExternalContractProvider)
local SquadExternalContractContext = SquadExternalContractProvider.SquadExternalContractContext
local Enums = require(parent.SquadsCore.Enums)
local SquadPromptType = Enums.SquadPromptType
local Hooks = require(parent.SquadsCore.Hooks)
local useCurrentSquadParentChannelId = Hooks.useCurrentSquadParentChannelId

require(script.Parent.SquadLobbyUserOverflowMenuView)

local useDispatch = dependencies.Hooks.useDispatch
local useLocalization = dependencies.Hooks.useLocalization
local useStore = dependencies.Hooks.useStore
local useBackgroundExperience = CrossExperienceVoice.Hooks.useBackgroundExperience
local useParticipants = CrossExperienceVoice.Hooks.useParticipants
local useVoiceStatus = CrossExperienceVoice.Hooks.useVoiceStatus
local useIsParticipantMutedLocally = CrossExperienceVoice.Hooks.useIsParticipantMutedLocally
local default = CrossExperienceVoice.CrossExperienceVoiceManager.default
local getFFlagEnableCrossExpVoice = dependencies.SharedFlags.GetFFlagEnableCrossExpVoice

local FocusNavigableSurfaceIdentifierEnum = FocusNavigationUtils.FocusNavigableSurfaceIdentifierEnum
local FocusNavigationEventNameEnum = FocusNavigationUtils.FocusNavigationEventNameEnum
local useFocusRoot = FocusNavigationUtils.useFocusRoot

local navigateBacks = {
	[Enum.KeyCode.ButtonB] = FocusNavigationEventNameEnum.NavigateBack,
	[Enum.KeyCode.Escape] = FocusNavigationEventNameEnum.NavigateBack
}

local v = { "MuteVoiceButton", "ReportButton", "RemoveUserButton", "VoiceIneligibleButton" }

local function useSquadLobbyUserOverflowMenuViewModel(data)
	local userId = data.userId
	local state, setState = React.useState(false)

	local v2 = React.useContext(SquadExternalContractContext)
	local v3 = useDispatch()
	local v4 = useStore()
	local v5 = useLocalUserId()
	local voiceStatus = useVoiceStatus()
	local parentChannelId = useCurrentSquadParentChannelId() or ""
	local v6 = useSquadUserDropdownMenuButtons(userId, data.isInExperience)
	local v7 = useIsParticipantMutedLocally(tonumber(userId) or -1)

	local v8 = useLocalization({
		removeFromGroup = "Feature.Chat.Action.RemoveFromGroup",
		reportUser = "Feature.Chat.Action.ReportUser",
		muteVoice = "Feature.Chat.Action.MuteVoice",
		unmuteVoice = "Feature.Chat.Action.UnmuteVoice",
		voiceIneligible = "Feature.Squads.Label.UserDropdownMenuVoiceErrorUserIneligible"
	})
	local voiceUserIds, voiceChannelId, voiceSessionId

	if getFFlagEnableCrossExpVoice() then
		local v9 = useBackgroundExperience()
		local v10 = useParticipants() or {}
		voiceUserIds = React.useMemo(function()
			local userIds = {}

			for _, v11 in pairs(v10) do
				table.insert(userIds, v11.userId)
			end

			return userIds
		end, { v10 })
		voiceChannelId = if v9 then v9.voiceChannelId else nil
		voiceSessionId = if v9 then v9.voiceSessionId else nil
	else
		voiceChannelId = nil
		voiceSessionId = nil
		voiceUserIds = {}
	end

	local onClose = React.useCallback(function()
		setState(false)
	end, {})

	local onTriggerActivated = React.useCallback(function()
		setState(function(p): boolean
			return not p
		end)
	end, {})

	local v9 = React.useCallback(function()
		v2.fireSquadAnalytics(EventNames.PartySheetAction, {
			parentChannelId = parentChannelId,
			actionType = SquadPartySheetActionEnum.RemoveUserDropDownButtonClicked,
			voiceStatus = voiceStatus
		})

		v2.setSquadPrompt(v4, {
			promptType = SquadPromptType.RemoveFromChat,
			onConfirm = function()
				if userId == "" or parentChannelId == "" then
					return nil
				end

				v2.fireSquadAnalytics(EventNames.PartySheetAction, {
					parentChannelId = parentChannelId,
					actionType = SquadPartySheetActionEnum.RemoveUserDialogButtonClicked,
					voiceStatus = voiceStatus
				})

				return v2.removeUserFromParentChannel(v3, parentChannelId, userId)
			end
		})
	end, { v2, v4, v3, parentChannelId, userId, voiceStatus })

	local v10 = React.useCallback(function()
		data.openSquadVoiceAbuseReport({
			submitterUserId = tostring(v5),
			abuserUserId = userId,
			reportBeginTimestampMs = workspace:GetServerTimeNow() * 1000,
			voiceChannelId = voiceChannelId,
			voiceSessionId = voiceSessionId,
			voiceUserIds = voiceUserIds,
			voiceUserCount = #voiceUserIds
		})
	end, {
		data.openSquadVoiceAbuseReport,
		v5,
		userId,
		voiceChannelId,
		voiceSessionId,
		voiceUserIds
	})

	local v11 = React.useCallback(function()
		local v11 = tonumber(userId)

		if not v11 then
			return
		end

		if v7 then
			default:unmuteVoiceParticipant(v11)
		else
			default:muteVoiceParticipant(v11)
		end
	end, { userId, v7 })

	local items = React.useMemo(function()
		local function closeThen(callback) -- 3 equivalent calls inferred from this helper
			return function()
				onClose()
				callback()
			end
		end

		local text = if v7 then v8.unmuteVoice else v8.muteVoice
		local v12 = {
			MuteVoiceButton = { id = "MuteVoiceButton", text = text, onActivated = closeThen(v11) }, -- inferred equivalent call
			ReportButton = {
				id = "ReportButton",
				text = v8.reportUser,
				onActivated = closeThen(v10) -- inferred equivalent call
			},
			RemoveUserButton = {
				id = "RemoveUserButton",
				text = v8.removeFromGroup,
				onActivated = closeThen(v9) -- inferred equivalent call
			},
			VoiceIneligibleButton = {
				id = "VoiceIneligibleButton",
				text = v8.voiceIneligible,
				isDisabled = true
			}
		}

		local result = {}

		for _, v13 in v do
			if table.find(v6, v13) then
				table.insert(result, v12[v13])
			end
		end

		return result
	end, { v6, v8, v7, onClose, v9, v10, v11 })

	local eventHandlers = React.useMemo(function()
		return {
			[FocusNavigationEventNameEnum.NavigateBack] = {
				handler = InputHandlers.onRelease(function(object)
					onClose()
					object:cancel()
				end)
			}
		}
	end, { onClose })

	return {
		isOpen = state,
		items = items,
		onTriggerActivated = onTriggerActivated,
		onClose = onClose,
		menuRef = useFocusRoot({
			surfaceIdentifier = FocusNavigableSurfaceIdentifierEnum.ContextualMenu,
			isFocusable = state,
			isAutoFocusRoot = true,
			shouldRestoreFocus = false,
			eventMap = navigateBacks,
			eventHandlers = eventHandlers
		}),
		testId = `--social-squad-lobby-user-card-{userId}--overflow`
	}
end

return useSquadLobbyUserOverflowMenuViewModel
