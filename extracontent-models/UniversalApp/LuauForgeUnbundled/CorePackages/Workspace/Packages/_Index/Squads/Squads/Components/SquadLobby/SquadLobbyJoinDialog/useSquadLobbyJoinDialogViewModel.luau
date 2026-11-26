local React = require("@game/CorePackages/Workspace/Packages/_Workspace/Squads/React")
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/Squads/Foundation")
local ExperienceService = require("@game/CorePackages/Workspace/Packages/_Workspace/Squads/ExperienceService")
local FocusNavigationUtils = require("@game/CorePackages/Workspace/Packages/_Workspace/Squads/FocusNavigationUtils")
local InputHandlers = require("@game/CorePackages/Workspace/Packages/_Workspace/Squads/InputHandlers")
require("@game/CorePackages/Workspace/Packages/_Workspace/Squads/ReactFocusNavigation")
local UserProfiles = require("@game/CorePackages/Workspace/Packages/_Index/Squads/UserProfiles")
local useVoiceStatus = require("@game/CorePackages/Workspace/Packages/_Workspace/Squads/CrossExperienceVoice").Hooks.useVoiceStatus

local dependencies = require("@game/CorePackages/Workspace/Packages/_Index/Squads/Squads/dependencies")
local SquadPartySheetActionEnum = require("@game/CorePackages/Workspace/Packages/_Index/Squads/Squads/Enums/SquadPartySheetActionEnum")

local EventNames = require("@game/CorePackages/Workspace/Packages/_Index/Squads/SquadsCore/EventNames")

local squadExternalContractContext = require("@game/CorePackages/Workspace/Packages/_Index/Squads/SquadsCore/SquadExternalContractProvider").SquadExternalContractContext
local squadLocationEnum = require("@game/CorePackages/Workspace/Packages/_Index/Squads/SquadsCore/Enums").SquadLocationEnum
local useCurrentSquadParentChannelId = require("@game/CorePackages/Workspace/Packages/_Index/Squads/SquadsCore/Hooks").useCurrentSquadParentChannelId

require("@game/CorePackages/Workspace/Packages/_Index/Squads/Squads/Components/SquadLobby/SquadLobbyJoinDialog/SquadLobbyJoinDialogView")
local isPresenceJoinable = require("@game/CorePackages/Workspace/Packages/_Index/Squads/Squads/Common/isPresenceJoinable")

local fFlagSquadLaunchExperienceMobileFix = dependencies.SharedFlags.FFlagSquadLaunchExperienceMobileFix
local useLocalization = dependencies.Hooks.useLocalization
local useSelector = dependencies.Hooks.useSelector

local fFlagSquadsPresenceStoreMigration = require("@game/CorePackages/Workspace/Packages/_Index/Squads/SquadsCore/Flags").FFlagSquadsPresenceStoreMigration
local useGetPresenceByUserId

if fFlagSquadsPresenceStoreMigration then
	useGetPresenceByUserId = require("@game/CorePackages/Workspace/Packages/_Workspace/Squads/FriendsCommon").Hooks.useGetPresenceByUserId
else
	useGetPresenceByUserId = nil
end

local gameParams = ExperienceService.GameParams
local experienceService = ExperienceService.ExperienceService
local getRbxThumb = Foundation.Utility.getRbxThumb
local thumbnailSize = Foundation.Enums.ThumbnailSize
local thumbnailType = Foundation.Enums.ThumbnailType

local focusNavigableSurfaceIdentifierEnum = FocusNavigationUtils.FocusNavigableSurfaceIdentifierEnum
local focusNavigationEventNameEnum = FocusNavigationUtils.FocusNavigationEventNameEnum
local useFocusRoot = FocusNavigationUtils.useFocusRoot
local useLastInputMode = FocusNavigationUtils.useLastInputMode

local navigateBacks = {
	[Enum.KeyCode.ButtonB] = focusNavigationEventNameEnum.NavigateBack,
	[Enum.KeyCode.Escape] = focusNavigationEventNameEnum.NavigateBack
}

local function nonEmpty(p2)
	if p2 == nil or p2 == "" then
		return nil
	end

	return (tostring(p2))
end

local function useSquadLobbyJoinDialogViewModel(data)
	local userId = data.userId
	local onClose = data.onClose
	local v5 = React.useContext(squadExternalContractContext)
	local v6 = useVoiceStatus()
	local v7 = useCurrentSquadParentChannelId() or ""

	local v8 = React.useCallback(function(p2)
		return p2.Squad.Presence.byUserId[userId]
	end, { userId })
	local v9

	if fFlagSquadsPresenceStoreMigration then
		v9 = useGetPresenceByUserId(userId)
	else
		v9 = useSelector(v8)
	end

	local placeId

	if v9 then
		local placeId2 = v9.placeId
		local v10 = if not (placeId2 == nil or placeId2 == "") then tostring(placeId2) else nil

		placeId = if v10 then v9.placeId else nil
	else
		placeId = nil
	end

	local v10 = isPresenceJoinable(v9)
	local v11

	if v9 then
		local rootPlaceId = v9.rootPlaceId

		if not (rootPlaceId == nil or rootPlaceId == "") then
			v11 = tostring(rootPlaceId)
		end

		if not v11 then
			local placeId2 = v9.placeId
			v11 = if not (placeId2 == nil or placeId2 == "") then tostring(placeId2) else nil
		end
	else
		v11 = v9
	end

	if v9 then
		local lastLocation = v9.lastLocation
		v9 = if not (lastLocation == nil or lastLocation == "") then tostring(lastLocation) else nil
	end

	local v12 = UserProfiles.Hooks.useUserProfilesFetch({
		userIds = { userId },
		query = UserProfiles.Queries.userProfilesCombinedNameByUserIds
	})

	local v13 = if v12.data then UserProfiles.Selectors.getCombinedNameFromId(v12.data, userId) else nil

	local v14 = useLocalization({
		inExperience = "Common.Presence.Label.InExperience",
		isPlaying = "Feature.Friends.Text.IsPlaying",
		join = "Feature.Profile.Action.JoinGame",
		viewProfile = "Feature.Profile.Action.ViewProfile"
	})

	local ref = React.useRef(false)
	React.useEffect(function()
		if v10 then
			ref.current = true
		elseif ref.current then
			onClose()
		end
	end, { v10, onClose })

	local v15 = React.useCallback(function()
		onClose()

		if data.isInExperience and fFlagSquadLaunchExperienceMobileFix then
			game:Shutdown()
		end

		local v16 = v5.squadLocation == squadLocationEnum.UniversalApp and "SquadLobbyFromUA"
			or v5.squadLocation == squadLocationEnum.InExperience and "SquadLobbyFromInExp"
			or "SquadLobby"

		experienceService:LaunchExperience(gameParams.fromUserId(userId, placeId), v16, nil)
	end, { placeId, onClose, data.isInExperience, v5.squadLocation, userId })

	local v16 = React.useCallback(function()
		v5.fireSquadAnalytics(EventNames.PartySheetAction, {
			parentChannelId = v7,
			actionType = SquadPartySheetActionEnum.ViewProfileButtonClicked,
			voiceStatus = v6
		})

		onClose()
		data.openViewProfile(userId)
	end, { v5.fireSquadAnalytics, v7, v6, onClose, data.openViewProfile, userId })

	local v17 = React.useMemo(function()
		return {
			[focusNavigationEventNameEnum.NavigateBack] = {
				handler = InputHandlers.onRelease(function(object)
					onClose()
					object:cancel()
				end)
			}
		}
	end, { onClose })

	local v18 = useFocusRoot({
		surfaceIdentifier = focusNavigableSurfaceIdentifierEnum.PopUp,
		isAutoFocusRoot = true,
		eventMap = navigateBacks,
		eventHandlers = v17
	})

	local v19 = useLastInputMode() == "Focus"

	local v20 = {
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

	local v21 = if v11 then getRbxThumb(thumbnailType.GameThumbnail, v11, thumbnailSize.Large) else nil
	v20.gameImage = v21
	local v22 = if v13 ~= nil and v13 ~= "" then tostring(v13) else nil

	v20.playerName = v22
	v20.isPlayingText = v14.isPlaying
	v20.experienceName = v9 or v14.inExperience
	v20.joinText = v14.join
	v20.onJoin = v15
	local v23 = if not data.isInExperience then v14.viewProfile else nil
	v20.viewProfileText = v23

	if data.isInExperience then
		v16 = nil
	end

	v20.onViewProfile = v16
	v20.onClose = if not v19 then onClose else nil
	v20.dialogRef = v18
	v20.testId = `--social-squad-lobby-join-dialog-{userId}`
	return v20
end

return useSquadLobbyJoinDialogViewModel
