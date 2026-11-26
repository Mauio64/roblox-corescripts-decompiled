local dependencies = require("@game/CorePackages/Workspace/Packages/_Index/Squads/Squads/dependencies")

local CrossExperienceVoice = require("@game/CorePackages/Workspace/Packages/_Workspace/Squads/CrossExperienceVoice")
local ExperienceService = require("@game/CorePackages/Workspace/Packages/_Workspace/Squads/ExperienceService")
local FocusNavigationUtils = require("@game/CorePackages/Workspace/Packages/_Workspace/Squads/FocusNavigationUtils")
local InputHandlers = require("@game/CorePackages/Workspace/Packages/_Workspace/Squads/InputHandlers")
local UIBlox = require("@game/CorePackages/Workspace/Packages/_Workspace/Squads/UIBlox")
local useLocalUserId = require("@game/CorePackages/Workspace/Packages/_Workspace/Squads/RobloxAppHooks").useLocalUserId

local SquadPartySheetActionEnum = require("@game/CorePackages/Workspace/Packages/_Index/Squads/Squads/Enums/SquadPartySheetActionEnum")
require("@game/CorePackages/Workspace/Packages/_Index/Squads/Squads/Common/ModelTypes")
local cryo = dependencies.Cryo
local presenceType = dependencies.RoduxPresence.Enums.PresenceType
local react = dependencies.React
local sharedFlags = dependencies.SharedFlags

local fFlagSquadsPresenceStoreMigration = require("@game/CorePackages/Workspace/Packages/_Index/Squads/SquadsCore/Flags").FFlagSquadsPresenceStoreMigration
local useGetPresenceByUserId

if fFlagSquadsPresenceStoreMigration then
	useGetPresenceByUserId = require("@game/CorePackages/Workspace/Packages/_Workspace/Squads/FriendsCommon").Hooks.useGetPresenceByUserId
else
	useGetPresenceByUserId = nil
end

local presenceType2

if fFlagSquadsPresenceStoreMigration then
	presenceType2 = require("@game/CorePackages/Workspace/Packages/_Workspace/Squads/DataHydration").Presence.PresenceEnums.PresenceType
else
	presenceType2 = nil
end

local images = UIBlox.App.ImageSet.Images

local modalBottomSheet = UIBlox.ModalBottomSheet
local useDispatch = dependencies.Hooks.useDispatch
local useLocalization = dependencies.Hooks.useLocalization
local useStore = dependencies.Hooks.useStore
local useSelector = dependencies.Hooks.useSelector
local useBackgroundExperience = CrossExperienceVoice.Hooks.useBackgroundExperience
local useParticipants = CrossExperienceVoice.Hooks.useParticipants
local useVoiceStatus = CrossExperienceVoice.Hooks.useVoiceStatus
local useSquadUserDropdownMenuButtons = require("@game/CorePackages/Workspace/Packages/_Index/Squads/Squads/Hooks/useSquadUserDropdownMenuButtons")

local gameParams = ExperienceService.GameParams
local experienceService = ExperienceService.ExperienceService

local focusNavigableSurfaceIdentifierEnum = FocusNavigationUtils.FocusNavigableSurfaceIdentifierEnum
local focusNavigableSurfaceWrapper = FocusNavigationUtils.FocusNavigableSurfaceWrapper
local focusNavigationEventNameEnum = FocusNavigationUtils.FocusNavigationEventNameEnum

local EventNames = require("@game/CorePackages/Workspace/Packages/_Index/Squads/SquadsCore/EventNames")

local squadExternalContractContext = require("@game/CorePackages/Workspace/Packages/_Index/Squads/SquadsCore/SquadExternalContractProvider").SquadExternalContractContext
local squadLocationEnum = require("@game/CorePackages/Workspace/Packages/_Index/Squads/SquadsCore/Enums").SquadLocationEnum
local squadPromptType = require("@game/CorePackages/Workspace/Packages/_Index/Squads/SquadsCore/Enums").SquadPromptType

local getFFlagEnableCrossExpVoice = sharedFlags.GetFFlagEnableCrossExpVoice
local fFlagSquadLaunchExperienceMobileFix = sharedFlags.FFlagSquadLaunchExperienceMobileFix

local useIsParticipantMutedLocally = CrossExperienceVoice.Hooks.useIsParticipantMutedLocally
local default = CrossExperienceVoice.CrossExperienceVoiceManager.default

local iconscommonplay = images["icons/common/play"]
local iconsmenuprofile = images["icons/menu/profile"]
local iconsactionsfeedback = images["icons/actions/feedback"]
local iconsactionsleave = images["icons/actions/leave"]
local iconscontrolsheadphoneDeafen_small = images["icons/controls/headphoneDeafen_small"]
local iconscontrolsmicrophoneMute = images["icons/controls/microphoneMute"]
local iconscontrolsmicrophone = images["icons/controls/microphone"]

local v5 = {
	isInExperience = false,
	onDismiss = function() end,
	openViewProfile = function() end,
	openVoiceAbuseReport = function() end,
	parentChannelId = "",
	userId = ""
}

return function(p2)
	local union = cryo.Dictionary.union(v5, p2)

	local v6 = react.useContext(squadExternalContractContext)

	local v7 = useDispatch()
	local v8 = useLocalUserId()
	local v9 = useStore()
	local v10 = useVoiceStatus()
	local v11 = useSquadUserDropdownMenuButtons(union.userId, union.isInExperience)
	local v12 = useIsParticipantMutedLocally(tonumber(union.userId) or -1)

	local v13 = useLocalization({
		joinButtonText = "Common.VisitGame.Label.Play",
		viewProfileText = "Feature.Chat.Label.ViewProfile",
		reportUserText = "Feature.Chat.Action.ReportUser",
		removeFromGroupText = "Feature.Chat.Action.RemoveFromGroup",
		voiceIneligibleText = "Feature.Squads.Label.UserDropdownMenuVoiceErrorUserIneligible",
		muteVoiceButtonText = "Feature.Chat.Action.MuteVoice",
		unmuteVoiceButtonText = "Feature.Chat.Action.UnmuteVoice"
	})

	local v14 = react.useCallback(function()
		v6.fireSquadAnalytics(EventNames.PartySheetAction, {
			parentChannelId = union.parentChannelId,
			actionType = SquadPartySheetActionEnum.ViewProfileButtonClicked,
			voiceStatus = v10
		})

		union.openViewProfile()
	end, { union.parentChannelId, union.openViewProfile, v6.fireSquadAnalytics, v10 })

	local v15 = react.useCallback(function()
		v6.fireSquadAnalytics(EventNames.PartySheetAction, {
			parentChannelId = union.parentChannelId,
			actionType = SquadPartySheetActionEnum.RemoveUserDropDownButtonClicked,
			voiceStatus = v10
		})

		v6.setSquadPrompt(v9, {
			promptType = squadPromptType.RemoveFromChat,
			onConfirm = function()
				if union.userId == "" or union.parentChannelId == "" then
					return nil
				end

				v6.fireSquadAnalytics(EventNames.PartySheetAction, {
					parentChannelId = union.parentChannelId,
					actionType = SquadPartySheetActionEnum.RemoveUserDialogButtonClicked,
					voiceStatus = v10
				})

				return v6.removeUserFromParentChannel(v7, union.parentChannelId, union.userId)
			end
		})
	end, {
		v7,
		union.userId,
		union.parentChannelId,
		v6.fireSquadAnalytics,
		v6.setSquadPrompt,
		v6.removeUserFromParentChannel,
		v10
	})

	local v16 = nil
	local v17 = nil
	local v18, v19, v20

	if getFFlagEnableCrossExpVoice() then
		v16 = useBackgroundExperience()
		v17 = useParticipants() or {}
		v18 = react.useMemo(function()
			local userIds = {}

			for k, v21 in pairs(v17) do
				table.insert(userIds, v21.userId)
			end

			return userIds
		end, { v17 })
		v19 = react.useMemo(function()
			if v16 then
				return v16.voiceChannelId
			end

			return nil
		end, { v16 })
		v20 = react.useMemo(function()
			if v16 then
				return v16.voiceSessionId
			end

			return nil
		end, { v16 })
	else
		v19 = nil
		v20 = nil
		v18 = {}
	end

	local v21 = react.useCallback(function(p3)
		return p3.Squad.Presence.byUserId[union.userId]
	end, { union.userId })
	local v22

	if fFlagSquadsPresenceStoreMigration then
		v22 = useGetPresenceByUserId((tostring(union.userId)))
	else
		v22 = useSelector(v21)
	end

	local v23 = react.useMemo(function()
		local v24

		if table.find(v11, "JoinButton") == nil then
			v24 = false
			return false
		end

		v24 = v22

		if not v24 then
			return v24
		end

		v24 = false
		local userPresenceType = v22.userPresenceType
		local v25 = if fFlagSquadsPresenceStoreMigration then presenceType2.InGame else presenceType.InGame

		if userPresenceType ~= v25 then
			return false
		end

		if fFlagSquadsPresenceStoreMigration then
			return v22.placeId ~= ""
		end

		v24 = v22.placeId
		return v24
	end, { v22, v11 })

	local v24 = react.useCallback(function()
		if v23 then
			local fromUserId = gameParams.fromUserId
			local userId = union.userId

			local v25 = if fFlagSquadsPresenceStoreMigration then v22 and v22.placeId else v22.placeId
			local v26 = fromUserId(userId, v25)

			if union.isInExperience and fFlagSquadLaunchExperienceMobileFix then
				game:Shutdown()
			end

			experienceService:LaunchExperience(
				v26,
				v6.squadLocation == squadLocationEnum.UniversalApp and "SquadLobbyFromUA" or v6.squadLocation == squadLocationEnum.InExperience and "SquadLobbyFromInExp" or "SquadLobby",
				nil
			)
		end
	end, { v23, v6.squadLocation, union.isInExperience, union.userId, v22 })

	local v25 = react.useMemo(function()
		local v26 = {
			VoiceIneligibleButton = {
				icon = iconscontrolsheadphoneDeafen_small,
				text = v13.voiceIneligibleText,
				stayOnActivated = true
			},
			JoinButton = {
				icon = iconscommonplay,
				text = v13.joinButtonText,
				onActivated = v24
			},
			RemoveUserButton = {
				icon = iconsactionsleave,
				text = v13.removeFromGroupText,
				onActivated = v15
			},
			ViewProfileButton = {
				icon = iconsmenuprofile,
				text = v13.viewProfileText,
				onActivated = v14
			},
			ReportButton = {
				icon = iconsactionsfeedback,
				text = v13.reportUserText,
				onActivated = function()
					local v27 = {
						submitterUserId = tostring(v8),
						abuserUserId = union.userId,
						reportBeginTimestampMs = workspace:GetServerTimeNow() * 1000,
						voiceChannelId = v19,
						voiceSessionId = v20,
						voiceUserIds = v18,
						voiceUserCount = #v18
					}

					union.openSquadVoiceAbuseReport(v27)
				end
			},
			MuteVoiceButton = 0
		}

		local v27 = {
			icon = if v12 then iconscontrolsmicrophoneMute else iconscontrolsmicrophone,
			text = 0,
			onActivated = 0
		}

		local v29 = if v12 then v13.unmuteVoiceButtonText else v13.muteVoiceButtonText
		v27.text = v29

		function v27.onActivated()
			local userId = tonumber(union.userId)

			if not userId then
				warn("Invalid userId: " .. tostring(union.userId))
			elseif v12 then
				default:unmuteVoiceParticipant(userId)
			else
				default:muteVoiceParticipant(userId)
			end
		end

		v26.MuteVoiceButton = v27

		local result = {}

		for k, v30 in v11 do
			local v31 = v26[v30]

			if v31 then
				table.insert(result, v31)
			end
		end

		return result
	end, {
		union.userId,
		union.openSquadVoiceAbuseReport,
		v13.joinButtonText,
		v13.removeFromGroupText,
		v13.reportUserText,
		v13.viewProfileText,
		v13.voiceIneligibleText,
		v13.muteVoiceButtonText,
		v13.unmuteVoiceButtonText,
		v8,
		v19,
		v20,
		v18,
		v15,
		v11,
		v24,
		v14,
		v12
	})

	if not (#v25 > 0) then
		union.onDismiss()
		return nil
	end

	return react.createElement(focusNavigableSurfaceWrapper, {
		customEventHandlers = {
			[focusNavigationEventNameEnum.NavigateBack] = {
				handler = InputHandlers.onRelease(function(object)
					union.onDismiss()
					object:cancel()
				end)
			}
		},
		isAutoFocusRoot = true,
		isFocusable = true,
		isIsolated = true,
		surfaceIdentifier = focusNavigableSurfaceIdentifierEnum.PopUp
	}, { react.createElement(modalBottomSheet, {
			bottomGap = 20,
			buttonModels = v25,
			onDismiss = function()
				union.onDismiss()
			end,
			screenWidth = 400,
			showImages = true
		}) })
end
