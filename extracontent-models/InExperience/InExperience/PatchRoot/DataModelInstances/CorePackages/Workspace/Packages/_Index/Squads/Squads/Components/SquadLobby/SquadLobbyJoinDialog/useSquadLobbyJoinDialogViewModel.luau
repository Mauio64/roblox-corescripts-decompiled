local Squads = script:FindFirstAncestor("Squads")
local parent = Squads.Parent
local React = require(parent.React)
local Foundation = require(parent.Foundation)
local ExperienceService = require(parent.ExperienceService)
local FocusNavigationUtils = require(parent.FocusNavigationUtils)
local InputHandlers = require(parent.InputHandlers)
require(parent.ReactFocusNavigation)
local UserProfiles = require(parent.UserProfiles)
local CrossExperienceVoice = require(parent.CrossExperienceVoice)
local useVoiceStatus = CrossExperienceVoice.Hooks.useVoiceStatus

local dependencies = require(Squads.dependencies)
local SquadPartySheetActionEnum = require(Squads.Enums.SquadPartySheetActionEnum)

local EventNames = require(parent.SquadsCore.EventNames)

local SquadExternalContractProvider = require(parent.SquadsCore.SquadExternalContractProvider)
local SquadExternalContractContext = SquadExternalContractProvider.SquadExternalContractContext
local Enums = require(parent.SquadsCore.Enums)
local SquadLocationEnum = Enums.SquadLocationEnum
local Hooks = require(parent.SquadsCore.Hooks)
local useCurrentSquadParentChannelId = Hooks.useCurrentSquadParentChannelId

require(script.Parent.SquadLobbyJoinDialogView)
local isPresenceJoinable = require(Squads.Common.isPresenceJoinable)

local fFlagSquadLaunchExperienceMobileFix = dependencies.SharedFlags.FFlagSquadLaunchExperienceMobileFix
local useLocalization = dependencies.Hooks.useLocalization
local useSelector = dependencies.Hooks.useSelector

local Flags = require(parent.SquadsCore.Flags)
local FFlagSquadsPresenceStoreMigration = Flags.FFlagSquadsPresenceStoreMigration
local useGetPresenceByUserId

if FFlagSquadsPresenceStoreMigration then
	local FriendsCommon = require(parent.FriendsCommon)
	useGetPresenceByUserId = FriendsCommon.Hooks.useGetPresenceByUserId
else
	useGetPresenceByUserId = nil
end

local GameParams = ExperienceService.GameParams
local experienceService = ExperienceService.ExperienceService
local getRbxThumb = Foundation.Utility.getRbxThumb
local ThumbnailSize = Foundation.Enums.ThumbnailSize
local ThumbnailType = Foundation.Enums.ThumbnailType

local FocusNavigableSurfaceIdentifierEnum = FocusNavigationUtils.FocusNavigableSurfaceIdentifierEnum
local FocusNavigationEventNameEnum = FocusNavigationUtils.FocusNavigationEventNameEnum
local useFocusRoot = FocusNavigationUtils.useFocusRoot
local useLastInputMode = FocusNavigationUtils.useLastInputMode

local navigateBacks = {
	[Enum.KeyCode.ButtonB] = FocusNavigationEventNameEnum.NavigateBack,
	[Enum.KeyCode.Escape] = FocusNavigationEventNameEnum.NavigateBack
}

local function nonEmpty(p) -- 5 equivalent calls inferred from this helper
	if p == nil or p == "" then
		return nil
	end

	return (tostring(p))
end

local function useSquadLobbyJoinDialogViewModel(data)
	local userId = data.userId
	local onClose = data.onClose
	local v = React.useContext(SquadExternalContractContext)
	local voiceStatus = useVoiceStatus()
	local parentChannelId = useCurrentSquadParentChannelId() or ""

	local v2 = React.useCallback(function(p)
		return p.Squad.Presence.byUserId[userId]
	end, { userId })
	local v3

	if FFlagSquadsPresenceStoreMigration then
		v3 = useGetPresenceByUserId(userId)
	else
		v3 = useSelector(v2)
	end

	local placeId

	if v3 then
		if nonEmpty(v3.placeId) then -- inferred equivalent call
			placeId = v3.placeId
		else
			placeId = nil
		end
	else
		placeId = nil
	end

	local presenceJoinable = isPresenceJoinable(v3)
	local v4

	if v3 then
		v4 = nonEmpty(v3.rootPlaceId) or nonEmpty(v3.placeId) -- inferred equivalent call
	else
		v4 = v3
	end

	if v3 then
		v3 = nonEmpty(v3.lastLocation) -- inferred equivalent call
	end

	local v5 = UserProfiles.Hooks.useUserProfilesFetch({
		userIds = { userId },
		query = UserProfiles.Queries.userProfilesCombinedNameByUserIds
	})
	local v6

	if v5.data then
		v6 = UserProfiles.Selectors.getCombinedNameFromId(v5.data, userId)
	end

	local v7 = useLocalization({
		inExperience = "Common.Presence.Label.InExperience",
		isPlaying = "Feature.Friends.Text.IsPlaying",
		join = "Feature.Profile.Action.JoinGame",
		viewProfile = "Feature.Profile.Action.ViewProfile"
	})

	local ref = React.useRef(false)
	React.useEffect(function()
		if presenceJoinable then
			ref.current = true
		elseif ref.current then
			onClose()
		end
	end, { presenceJoinable, onClose })

	local onJoin = React.useCallback(function()
		onClose()

		if data.isInExperience and fFlagSquadLaunchExperienceMobileFix then
			game:Shutdown()
		end

		local v8 = v.squadLocation == SquadLocationEnum.UniversalApp and "SquadLobbyFromUA"
			or v.squadLocation == SquadLocationEnum.InExperience and "SquadLobbyFromInExp"
			or "SquadLobby"

		experienceService:LaunchExperience(GameParams.fromUserId(userId, placeId), v8, nil)
	end, { placeId, onClose, data.isInExperience, v.squadLocation, userId })

	local onViewProfile = React.useCallback(function()
		v.fireSquadAnalytics(EventNames.PartySheetAction, {
			parentChannelId = parentChannelId,
			actionType = SquadPartySheetActionEnum.ViewProfileButtonClicked,
			voiceStatus = voiceStatus
		})

		onClose()
		data.openViewProfile(userId)
	end, {
		v.fireSquadAnalytics,
		parentChannelId,
		voiceStatus,
		onClose,
		data.openViewProfile,
		userId
	})

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

	local dialogRef = useFocusRoot({
		surfaceIdentifier = FocusNavigableSurfaceIdentifierEnum.PopUp,
		isAutoFocusRoot = true,
		eventMap = navigateBacks,
		eventHandlers = eventHandlers
	})

	local v8 = useLastInputMode() == "Focus"

	local v9 = {
		userId = tonumber(userId) or 0,
		gameImage = 0,
		playerName = 0,
		isPlayingText = 0,
		experienceName = 0,
		joinText = 0,
		onJoin = 0,
		viewProfileText = 0,
		onViewProfile = 0,
		onClose = 0,
		dialogRef = 0,
		testId = 0
	}
	local gameImage

	if v4 then
		gameImage = getRbxThumb(ThumbnailType.GameThumbnail, v4, ThumbnailSize.Large)
	end

	v9.gameImage = gameImage
	v9.playerName = nonEmpty(v6) -- inferred equivalent call
	v9.isPlayingText = v7.isPlaying
	v9.experienceName = v3 or v7.inExperience
	v9.joinText = v7.join
	v9.onJoin = onJoin
	local viewProfileText

	if not data.isInExperience then
		viewProfileText = v7.viewProfile
	end

	v9.viewProfileText = viewProfileText

	if data.isInExperience then
		onViewProfile = nil
	end

	v9.onViewProfile = onViewProfile
	local onClose2

	if not v8 then
		onClose2 = onClose
	end

	v9.onClose = onClose2
	v9.dialogRef = dialogRef
	v9.testId = `--social-squad-lobby-join-dialog-{userId}`
	return v9
end

return useSquadLobbyJoinDialogViewModel
