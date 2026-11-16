local Squads = script:FindFirstAncestor("Squads")
local dependencies = require(Squads.dependencies)

local parent = Squads.Parent
local CrossExperienceVoice = require(parent.CrossExperienceVoice)
local ExperienceService = require(parent.ExperienceService)
local FocusNavigationUtils = require(parent.FocusNavigationUtils)
local InputHandlers = require(parent.InputHandlers)
local UIBlox = require(parent.UIBlox)
local RobloxAppHooks = require(parent.RobloxAppHooks)
local useLocalUserId = RobloxAppHooks.useLocalUserId

local SquadPartySheetActionEnum = require(Squads.Enums.SquadPartySheetActionEnum)
require(Squads.Common.ModelTypes)
local cryo = dependencies.Cryo
local presenceType = dependencies.RoduxPresence.Enums.PresenceType
local react = dependencies.React
local sharedFlags = dependencies.SharedFlags

local Flags = require(parent.SquadsCore.Flags)
local FFlagSquadsPresenceStoreMigration = Flags.FFlagSquadsPresenceStoreMigration
local useGetPresenceByUserId

if FFlagSquadsPresenceStoreMigration then
	local FriendsCommon = require(parent.FriendsCommon)
	useGetPresenceByUserId = FriendsCommon.Hooks.useGetPresenceByUserId
else
	useGetPresenceByUserId = nil
end

local presenceType2

if FFlagSquadsPresenceStoreMigration then
	local DataHydration = require(parent.DataHydration)
	presenceType2 = DataHydration.Presence.PresenceEnums.PresenceType
else
	presenceType2 = nil
end

local Images = UIBlox.App.ImageSet.Images

local ModalBottomSheet = UIBlox.ModalBottomSheet
local useDispatch = dependencies.Hooks.useDispatch
local useLocalization = dependencies.Hooks.useLocalization
local useStore = dependencies.Hooks.useStore
local useSelector = dependencies.Hooks.useSelector
local useBackgroundExperience = CrossExperienceVoice.Hooks.useBackgroundExperience
local useParticipants = CrossExperienceVoice.Hooks.useParticipants
local useVoiceStatus = CrossExperienceVoice.Hooks.useVoiceStatus
local useSquadUserDropdownMenuButtons = require(Squads.Hooks.useSquadUserDropdownMenuButtons)

local GameParams = ExperienceService.GameParams
local experienceService = ExperienceService.ExperienceService

local FocusNavigableSurfaceIdentifierEnum = FocusNavigationUtils.FocusNavigableSurfaceIdentifierEnum
local FocusNavigableSurfaceWrapper = FocusNavigationUtils.FocusNavigableSurfaceWrapper
local FocusNavigationEventNameEnum = FocusNavigationUtils.FocusNavigationEventNameEnum

local EventNames = require(parent.SquadsCore.EventNames)

local SquadExternalContractProvider = require(parent.SquadsCore.SquadExternalContractProvider)
local SquadExternalContractContext = SquadExternalContractProvider.SquadExternalContractContext
local Enums = require(parent.SquadsCore.Enums)
local SquadLocationEnum = Enums.SquadLocationEnum
local Enums2 = require(parent.SquadsCore.Enums)
local SquadPromptType = Enums2.SquadPromptType

local getFFlagEnableCrossExpVoice = sharedFlags.GetFFlagEnableCrossExpVoice
local fFlagSquadLaunchExperienceMobileFix = sharedFlags.FFlagSquadLaunchExperienceMobileFix

local useIsParticipantMutedLocally = CrossExperienceVoice.Hooks.useIsParticipantMutedLocally
local default = CrossExperienceVoice.CrossExperienceVoiceManager.default

local iconscommonplay = Images["icons/common/play"]
local iconsmenuprofile = Images["icons/menu/profile"]
local iconsactionsfeedback = Images["icons/actions/feedback"]
local iconsactionsleave = Images["icons/actions/leave"]
local iconscontrolsheadphoneDeafen_small = Images["icons/controls/headphoneDeafen_small"]
local iconscontrolsmicrophoneMute = Images["icons/controls/microphoneMute"]
local iconscontrolsmicrophone = Images["icons/controls/microphone"]

local v = {
	isInExperience = false,
	onDismiss = function() end,
	openViewProfile = function() end,
	openVoiceAbuseReport = function() end,
	parentChannelId = "",
	userId = ""
}

return function(p)
	local union = cryo.Dictionary.union(v, p)

	local v2 = react.useContext(SquadExternalContractContext)

	local v3 = useDispatch()
	local v4 = useLocalUserId()
	local v5 = useStore()
	local voiceStatus = useVoiceStatus()
	local v6 = useSquadUserDropdownMenuButtons(union.userId, union.isInExperience)
	local v7 = useIsParticipantMutedLocally(tonumber(union.userId) or -1)

	local v8 = useLocalization({
		joinButtonText = "Common.VisitGame.Label.Play",
		viewProfileText = "Feature.Chat.Label.ViewProfile",
		reportUserText = "Feature.Chat.Action.ReportUser",
		removeFromGroupText = "Feature.Chat.Action.RemoveFromGroup",
		voiceIneligibleText = "Feature.Squads.Label.UserDropdownMenuVoiceErrorUserIneligible",
		muteVoiceButtonText = "Feature.Chat.Action.MuteVoice",
		unmuteVoiceButtonText = "Feature.Chat.Action.UnmuteVoice"
	})

	local onActivated = react.useCallback(function()
		v2.fireSquadAnalytics(EventNames.PartySheetAction, {
			parentChannelId = union.parentChannelId,
			actionType = SquadPartySheetActionEnum.ViewProfileButtonClicked,
			voiceStatus = voiceStatus
		})

		union.openViewProfile()
	end, { union.parentChannelId, union.openViewProfile, v2.fireSquadAnalytics, voiceStatus })

	local onActivated2 = react.useCallback(function()
		v2.fireSquadAnalytics(EventNames.PartySheetAction, {
			parentChannelId = union.parentChannelId,
			actionType = SquadPartySheetActionEnum.RemoveUserDropDownButtonClicked,
			voiceStatus = voiceStatus
		})

		v2.setSquadPrompt(v5, {
			promptType = SquadPromptType.RemoveFromChat,
			onConfirm = function()
				if union.userId == "" or union.parentChannelId == "" then
					return nil
				end

				v2.fireSquadAnalytics(EventNames.PartySheetAction, {
					parentChannelId = union.parentChannelId,
					actionType = SquadPartySheetActionEnum.RemoveUserDialogButtonClicked,
					voiceStatus = voiceStatus
				})

				return v2.removeUserFromParentChannel(v3, union.parentChannelId, union.userId)
			end
		})
	end, {
		v3,
		union.userId,
		union.parentChannelId,
		v2.fireSquadAnalytics,
		v2.setSquadPrompt,
		v2.removeUserFromParentChannel,
		voiceStatus
	})

	local v9 = nil
	local v10 = nil
	local voiceUserIds, voiceChannelId, voiceSessionId

	if getFFlagEnableCrossExpVoice() then
		v9 = useBackgroundExperience()
		v10 = useParticipants() or {}
		voiceUserIds = react.useMemo(function()
			local userIds = {}

			for _, v11 in pairs(v10) do
				table.insert(userIds, v11.userId)
			end

			return userIds
		end, { v10 })
		voiceChannelId = react.useMemo(function()
			return if v9 then v9.voiceChannelId else nil
		end, { v9 })
		voiceSessionId = react.useMemo(function()
			return if v9 then v9.voiceSessionId else nil
		end, { v9 })
	else
		voiceChannelId = nil
		voiceSessionId = nil
		voiceUserIds = {}
	end

	local v11 = react.useCallback(function(p2)
		return p2.Squad.Presence.byUserId[union.userId]
	end, { union.userId })
	local v12

	if FFlagSquadsPresenceStoreMigration then
		v12 = useGetPresenceByUserId((tostring(union.userId)))
	else
		v12 = useSelector(v11)
	end

	local v13 = react.useMemo(function()
		local v13

		if table.find(v6, "JoinButton") == nil then
			v13 = false
			return false
		end

		v13 = v12

		if not v13 then
			return v13
		end

		v13 = false
		local userPresenceType = v12.userPresenceType
		local v14

		if FFlagSquadsPresenceStoreMigration then
			v14 = presenceType2.InGame
		else
			v14 = presenceType.InGame
		end

		if userPresenceType ~= v14 then
			return false
		end

		if FFlagSquadsPresenceStoreMigration then
			return v12.placeId ~= ""
		end

		return v12.placeId
	end, { v12, v6 })

	local onActivated3 = react.useCallback(function()
		if v13 then
			local fromUserId = GameParams.fromUserId
			local userId = union.userId
			local v14

			if FFlagSquadsPresenceStoreMigration then
				v14 = v12 and v12.placeId
			else
				v14 = v12.placeId
			end

			local v15 = fromUserId(userId, v14)

			if union.isInExperience and fFlagSquadLaunchExperienceMobileFix then
				game:Shutdown()
			end

			experienceService:LaunchExperience(
				v15,
				v2.squadLocation == SquadLocationEnum.UniversalApp and "SquadLobbyFromUA" or v2.squadLocation == SquadLocationEnum.InExperience and "SquadLobbyFromInExp" or "SquadLobby",
				nil
			)
		end
	end, { v13, v2.squadLocation, union.isInExperience, union.userId, v12 })

	local buttonModels = react.useMemo(function()
		local v14 = {
			VoiceIneligibleButton = {
				icon = iconscontrolsheadphoneDeafen_small,
				text = v8.voiceIneligibleText,
				stayOnActivated = true
			},
			JoinButton = {
				icon = iconscommonplay,
				text = v8.joinButtonText,
				onActivated = onActivated3
			},
			RemoveUserButton = {
				icon = iconsactionsleave,
				text = v8.removeFromGroupText,
				onActivated = onActivated2
			},
			ViewProfileButton = {
				icon = iconsmenuprofile,
				text = v8.viewProfileText,
				onActivated = onActivated
			},
			ReportButton = {
				icon = iconsactionsfeedback,
				text = v8.reportUserText,
				onActivated = function()
					local v14 = {
						submitterUserId = tostring(v4),
						abuserUserId = union.userId,
						reportBeginTimestampMs = workspace:GetServerTimeNow() * 1000,
						voiceChannelId = voiceChannelId,
						voiceSessionId = voiceSessionId,
						voiceUserIds = voiceUserIds,
						voiceUserCount = #voiceUserIds
					}

					union.openSquadVoiceAbuseReport(v14)
				end
			},
			MuteVoiceButton = 0
		}
		local icon

		if v7 then
			icon = iconscontrolsmicrophoneMute
		else
			icon = iconscontrolsmicrophone
		end

		local text

		if v7 then
			text = v8.unmuteVoiceButtonText
		else
			text = v8.muteVoiceButtonText
		end

		v14.MuteVoiceButton = {
			icon = icon,
			text = text,
			onActivated = function()
				local userId = tonumber(union.userId)

				if not userId then
					warn("Invalid userId: " .. tostring(union.userId))
				elseif v7 then
					default:unmuteVoiceParticipant(userId)
				else
					default:muteVoiceParticipant(userId)
				end
			end
		}

		local result = {}

		for _, v15 in v6 do
			local v16 = v14[v15]

			if v16 then
				table.insert(result, v16)
			end
		end

		return result
	end, {
		union.userId,
		union.openSquadVoiceAbuseReport,
		v8.joinButtonText,
		v8.removeFromGroupText,
		v8.reportUserText,
		v8.viewProfileText,
		v8.voiceIneligibleText,
		v8.muteVoiceButtonText,
		v8.unmuteVoiceButtonText,
		v4,
		voiceChannelId,
		voiceSessionId,
		voiceUserIds,
		onActivated2,
		v6,
		onActivated3,
		onActivated,
		v7
	})

	if not (#buttonModels > 0) then
		union.onDismiss()
		return nil
	end

	return react.createElement(FocusNavigableSurfaceWrapper, {
		customEventHandlers = {
			[FocusNavigationEventNameEnum.NavigateBack] = {
				handler = InputHandlers.onRelease(function(object)
					union.onDismiss()
					object:cancel()
				end)
			}
		},
		isAutoFocusRoot = true,
		isFocusable = true,
		isIsolated = true,
		surfaceIdentifier = FocusNavigableSurfaceIdentifierEnum.PopUp
	}, { react.createElement(ModalBottomSheet, {
			bottomGap = 20,
			buttonModels = buttonModels,
			onDismiss = function()
				union.onDismiss()
			end,
			screenWidth = 400,
			showImages = true
		}) })
end
