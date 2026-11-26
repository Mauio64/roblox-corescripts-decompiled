local IXPService = game:GetService("IXPService")

local Cryo = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialCarousel/Cryo")
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialCarousel/Foundation")
local GameJoinCard = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialCarousel/GameJoinCard")
local PlayerContextualMenu = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialCarousel/PlayerContextualMenu")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialCarousel/React")
local Responsive = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialCarousel/Responsive")
local RobloxAppEnums = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialCarousel/RobloxAppEnums")
local dataStatus = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialCarousel/DataHydration").DataStatus
local UserProfiles = require("@game/CorePackages/Workspace/Packages/_Index/SocialCarousel/UserProfiles")
local SocialCommon = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialCarousel/SocialCommon")
local useJoinUserInExperience = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialCarousel/SocialExperienceJoin").useJoinUserInExperience
local enums = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialCarousel/NetworkingFriends").Enums
local useGetPresenceByUserId = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialCarousel/FriendsCommon").Hooks.useGetPresenceByUserId

local fFlagSocialCarouselUseProfileStore = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialCarousel/SharedFlags").FFlagSocialCarouselUseProfileStore
local fFlagSocialCarouselInGameTitleMarquee = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialCarousel/SharedFlags").FFlagSocialCarouselInGameTitleMarquee
local fFlagUserProfilePlatformProfile = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialCarousel/SharedFlags").FFlagUserProfilePlatformProfile
local fFlagMobileGameJoinCardVideo = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialCarousel/SharedFlags").FFlagMobileGameJoinCardVideo
local fFlagSocialCarouselBuildPresence = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialCarousel/SharedFlags").FFlagSocialCarouselBuildPresence
local Signals = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialCarousel/Signals")
local SignalsReact = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialCarousel/SignalsReact")
local v5 = UserProfiles.Stores.UserProfileStore.get()
local presenceTypes = SocialCommon.Enums.PresenceTypes
local enums2 = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialCarousel/SocialLuaAnalytics").Analytics.Enums
local Enums = require("@game/CorePackages/Workspace/Packages/_Index/SocialCarousel/SocialCarousel/Common/Enums")
local Localization = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialCarousel/Localization")
local useSocialCarouselAnalytics = require("@game/CorePackages/Workspace/Packages/_Index/SocialCarousel/SocialCarousel/Analytics/useSocialCarouselAnalytics")
local usePreferredInput = Responsive.usePreferredInput
local useAppPolicy = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialCarousel/UniversalAppPolicy").useAppPolicy
local useDeviceType = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialCarousel/RobloxAppHooks").useDeviceType

local useNavigation = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialCarousel/Navigation").useNavigation
local useDispatch = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialCarousel/RoactUtils").Hooks.RoactRodux.useDispatch

local view = Foundation.View
local appPage = RobloxAppEnums.AppPage
local useLocalization = Localization.Hooks.useLocalization
local tile = Enums.Tile

local module15 = require("@game/CorePackages/Workspace/Packages/_Index/SocialCarousel/SocialCarousel/Components/Tiles/UserTile/UserTile")
local userTileEventHandlers = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialCarousel/UserTile").UserTileEventHandlers
local focusNavigationEventNameEnum = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialCarousel/FocusNavigationUtils").FocusNavigationEventNameEnum
local Constants = require("@game/CorePackages/Workspace/Packages/_Index/SocialCarousel/SocialCarousel/Common/Constants")
local TILE_CLICK_TARGETS = Constants.ANALYTICS.TILE_CLICK_TARGETS
local useSocialCarouselContext = require("@game/CorePackages/Workspace/Packages/_Index/SocialCarousel/SocialCarousel/Contexts/useSocialCarouselContext")
local useBuildCard = require("@game/CorePackages/Workspace/Packages/_Index/SocialCarousel/SocialCarousel/Components/Tiles/UserTile/useBuildCard")

local desktopGameJoinCardContainer = GameJoinCard.DesktopGameJoinCardContainer
local useAgeCheckCompletionLogger = GameJoinCard.Analytics.useAgeCheckUpsellAnalytics.useAgeCheckCompletionLogger
local useGameJoinCardNavigation = GameJoinCard.useGameJoinCardNavigation
local gameJoinCardTTI = GameJoinCard.Telemetry.GameJoinCardTTI

local defineFastString = game:DefineFastString(
	"SocialCarouselVendorImagePath",
	"rbxasset://textures/ui/Shell/Icons/PlatformLogo.png"
)
local fFlagEnableSplitPane = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialCarousel/SharedFlags").FFlagEnableSplitPane
local FFlagSocialCarouselEnableUserSeenEvents = require("@game/CorePackages/Workspace/Packages/_Index/SocialCarousel/SocialCarousel/Flags/FFlagSocialCarouselEnableUserSeenEvents")

local FFlagSocialCarouselUseConsolePolicyForCta = require("@game/CorePackages/Workspace/Packages/_Index/SocialCarousel/SocialCarousel/Flags/FFlagSocialCarouselUseConsolePolicyForCta")

local FFlagSocialCarouselFixGameJoinCardDismiss = require("@game/CorePackages/Workspace/Packages/_Index/SocialCarousel/SocialCarousel/Flags/FFlagSocialCarouselFixGameJoinCardDismiss")
local FFlagSocialCarouselShowPlusBadge = require("@game/CorePackages/Workspace/Packages/_Index/SocialCarousel/SocialCarousel/Flags/FFlagSocialCarouselShowPlusBadge")
local fFlagSocialCarouselInGamePlayIcon = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialCarousel/SharedFlags").FFlagSocialCarouselInGamePlayIcon
local fFlagSocialCarouselInGameTileInstantJoin = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialCarousel/SharedFlags").FFlagSocialCarouselInGameTileInstantJoin
local fFlagSocialCarouselInGameTextInstantJoin = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialCarousel/SharedFlags").FFlagSocialCarouselInGameTextInstantJoin
local v6

if fFlagSocialCarouselInGameTileInstantJoin or fFlagSocialCarouselInGameTextInstantJoin then
	v6 = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialCarousel/DiscoveryAnalytics")
else
	v6 = nil
end

local HttpService

if fFlagSocialCarouselInGameTileInstantJoin or fFlagSocialCarouselInGameTextInstantJoin then
	HttpService = game:GetService("HttpService")
else
	HttpService = nil
end

local fFlagEnableMobileGameJoinCard = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialCarousel/SharedFlags").FFlagEnableMobileGameJoinCard
local fFlagConsoleOpenMobileGameJoinCard = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialCarousel/SharedFlags").FFlagConsoleOpenMobileGameJoinCard
local fFlagConsoleOpenGameJoinCard = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialCarousel/SharedFlags").FFlagConsoleOpenGameJoinCard
local fFlagShowRequestsInCarouselForAllUsers = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialCarousel/SharedFlags").FFlagShowRequestsInCarouselForAllUsers
local fFlagMobileGameJoinCardTTITracking = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialCarousel/SharedFlags").FFlagMobileGameJoinCardTTITracking
local fFlagMobileGameJoinCardGamepadSupport = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialCarousel/SharedFlags").FFlagMobileGameJoinCardGamepadSupport
local fFlagDesktopGameJoinCardGamepadSupport = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialCarousel/SharedFlags").FFlagDesktopGameJoinCardGamepadSupport

local defineFastFlag = game:DefineFastFlag("EnableFriendCarouselInGameFriendExposureLogging_v2", false)

local defineFastString2 = game:DefineFastString(
	"SocialViewFriendSortInGameFriendsLayer",
	"Social.ViewFriendSortInGameFriends"
)

local function fn(item)
	if fFlagShowRequestsInCarouselForAllUsers and item.tileType == tile.FriendRequest then
		return Enum.FriendStatus.FriendRequestReceived
	end

	if item.tileType ~= tile.Recommendation or item.isFriendWithUser then
		return Enum.FriendStatus.Friend
	end

	if item.hasIncomingFriendRequest then
		return Enum.FriendStatus.FriendRequestReceived
	end

	if item.hasPendingFriendRequest then
		return Enum.FriendStatus.FriendRequestSent
	end

	return Enum.FriendStatus.NotFriend
end

return function(props)
	local ref = React.useRef(nil)
	local v7 = useDispatch()
	local v8 = useNavigation()
	local v9

	if fFlagMobileGameJoinCardGamepadSupport or fFlagDesktopGameJoinCardGamepadSupport then
		v9 = useDeviceType()
	end

	local v10 = usePreferredInput()
	local v11 = v10 == Responsive.Input.Directional
	local v12

	if FFlagSocialCarouselUseConsolePolicyForCta or fFlagMobileGameJoinCardGamepadSupport then
		v12 = useAppPolicy(function(p2)
			return p2.getUseConsoleGameJoinCard()
		end)
	else
		v12 = v11
	end

	if fFlagDesktopGameJoinCardGamepadSupport and v9 == RobloxAppEnums.DeviceType.Desktop then
		v12 = false
	end

	local v13 = v10 == Responsive.Input.Directional

	local v14 = v9 == RobloxAppEnums.DeviceType.Phone or v9 == RobloxAppEnums.DeviceType.Tablet
	local v15

	if fFlagEnableMobileGameJoinCard then
		if fFlagMobileGameJoinCardGamepadSupport then
			v15 = v14 or v10 == Responsive.Input.Touch
		else
			v15 = v10 == Responsive.Input.Touch
		end

		if not v15 then
			v15 = fFlagConsoleOpenMobileGameJoinCard and v12
		end
	else
		v15 = fFlagConsoleOpenMobileGameJoinCard and v12
	end

	local v16 = useSocialCarouselContext()
	local v17 = useSocialCarouselAnalytics()
	local userPressed = v17.userPressed
	local userSeen = v17.userSeen
	local v18 = useLocalization({
		suggestedLabel = "Feature.Friends.Label.Suggested",
		friendRequestLabel = fFlagShowRequestsInCarouselForAllUsers and "Feature.Friends.Label.FriendRequest" or nil
	})
	local v19, v20, v21

	if fFlagShowRequestsInCarouselForAllUsers then
		v19 = props.item.tileType == tile.FriendRequest

		local v23 = if v19 then props.item.id else nil
		v20, v21 = useGetPresenceByUserId(v23)
	else
		v19 = nil
		v20 = nil
	end

	local v22 = React.useMemo(function()
		if not fFlagShowRequestsInCarouselForAllUsers then
			return props.item
		end

		local item = props.item
		local v23 = v20

		if v19 and v23 then
			local clone = table.clone(item)
			clone.presence = v23
			return clone
		end

		return item
	end, { props.item, v19, v20 })
	local v23 = v20 ~= nil or v21 == dataStatus.Ready or v21 == dataStatus.Failed

	local v24 = React.useMemo(function()
		if fFlagShowRequestsInCarouselForAllUsers and v19 and v23 then
			local clone = table.clone(props.item)
			clone.presence = v20 or { userPresenceType = presenceTypes.Offline }

			return clone
		end

		return props.item
	end, { props.item, v19, v20, v23 })

	local v25 = not (fFlagShowRequestsInCarouselForAllUsers and v19) and props.item.presence and {
		locationString = props.item.presence.lastLocation,
		locationPlaceId = props.item.presence.placeId,
		locationRootPlaceId = props.item.presence.rootPlaceId,
		locationUniverseId = props.item.presence.universeId,
		status = props.item.presence.userPresenceType
	} or nil
	local v26, v27, v28

	if fFlagSocialCarouselUseProfileStore then
		local v29 = React.useMemo(function()
			return v5.fetchNamesByUserIds({ props.item.id }, nil, fFlagUserProfilePlatformProfile)
		end, { props.item.id })

		local v30 = React.useMemo(function()
			return Signals.createComputed(function(p2)
				local v31 = v29(p2)
				local v32 = v31 and v31.data and v31.data[1]

				if v32 and v32.names then
					return (v32.names.getCombinedName(p2))
				end

				return nil
			end)
		end, { v29 })

		local v31 = React.useMemo(function()
			return Signals.createComputed(function(p2)
				local v32 = v29(p2)
				local v33 = v32 and v32.data and v32.data[1]

				if v33 and v33.names then
					return (v33.names.getPlatformName(p2))
				end

				return nil
			end)
		end, { v29 })

		v26 = SignalsReact.useSignalState(v30)
		v27 = SignalsReact.useSignalState(v31)

		local v32 = React.useMemo(function()
			return Signals.createComputed(function(p2)
				local v33 = v29(p2)
				local v34 = v33 and v33.data and v33.data[1]

				if v34 then
					return (v34.getPlatformProfileId(p2))
				end

				return nil
			end)
		end, { v29 })

		v28 = SignalsReact.useSignalState(v32)
	else
		local v29 = UserProfiles.Hooks.useUserProfilesFetch({
			userIds = { props.item.id },
			query = UserProfiles.Queries.userProfilesDisplayUserPlatformNamesByUserIds
		})

		v26 = React.useMemo(function()
			if v29.data then
				return UserProfiles.Selectors.getCombinedNameFromId(v29.data, props.item.id)
			end

			return nil
		end, { v29.data })

		v27 = React.useMemo(function()
			if v29.data then
				return UserProfiles.Selectors.getPlatformNameFromId(v29.data, props.item.id)
			end

			return nil
		end, { v29.data })

		v28 = React.useMemo(function()
			if v29.data then
				return UserProfiles.Selectors.getPlatformProfileIdFromId(v29.data, props.item.id)
			end

			return nil
		end, { v29.data, props.item.id })
	end

	local v29 = if FFlagSocialCarouselShowPlusBadge then UserProfiles.Hooks.useIsRobloxSubscriber(props.item.id) else nil

	local state, setState = React.useState(false)
	local setOpenGameJoinCardUserId = v16.setOpenGameJoinCardUserId

	if setOpenGameJoinCardUserId then
		state = v16.openGameJoinCardUserId == props.item.id

		setState = function(p2)
			if p2 then
				setOpenGameJoinCardUserId(props.item.id)
			else
				setOpenGameJoinCardUserId(function(p3)
					if p3 == props.item.id then
						return nil
					end

					return p3
				end)
			end
		end
	end

	local v30

	if fFlagSocialCarouselBuildPresence then
		v30 = useBuildCard({
			userId = props.item.id,
			playerName = v26 or "",
			presence = props.item.presence,
			preferredInput = v10,
			isPhoneOrTablet = v14,
			anchorRef = ref
		})
	else
		v30 = nil
	end

	local v31 = if fFlagMobileGameJoinCardGamepadSupport then v15 else nil
	local v32

	if fFlagMobileGameJoinCardGamepadSupport or fFlagDesktopGameJoinCardGamepadSupport then
		v32 = v12
	end

	local joinSheetUserIdRef = if fFlagSocialCarouselInGameTitleMarquee then v16.joinSheetUserIdRef else nil
	local v33

	if fFlagShowRequestsInCarouselForAllUsers then
		v33 = React.useCallback(function()
			local v34 = if fFlagEnableSplitPane then v8.push else v8.navigate
			v34(appPage.ProfilePlatform, {
				detail = props.item.id,
				extraProps = { source = enums2.Sources.HomePageFriendsCarousel }
			})
		end, { v8, props.item.id })
	else
		v33 = nil
	end

	local v34 = fFlagSocialCarouselInGamePlayIcon

	if v34 then
		if
			props.item.onActivated == nil
			and props.item.tileType == tile.Friend
			and props.item.presence ~= nil
		then
			v34 = props.item.presence.userPresenceType == presenceTypes.InGame
		else
			v34 = false
		end
	end

	local v35

	if fFlagSocialCarouselInGameTileInstantJoin or fFlagSocialCarouselInGameTextInstantJoin then
		v35 = useJoinUserInExperience(props.item.id, {
			isHomePageCarousel = true,
			homepageCarouselAbsolutePosition = props.index,
			presence = props.item.presence,
			onAgeCheckCompletion = useAgeCheckCompletionLogger(not props.item.presence and "" or tostring(props.item.presence.universeId))
		})
	else
		v35 = nil
	end

	local useCallback = React.useCallback
	local function fn2(p2, tileClickTarget)
		if
			(fFlagSocialCarouselInGameTileInstantJoin or fFlagSocialCarouselInGameTextInstantJoin)
			and v34
			and not v35.isLoading
			and (fFlagSocialCarouselInGameTileInstantJoin or tileClickTarget ~= TILE_CLICK_TARGETS.AVATAR)
		then
			local presence = props.item.presence
			local v36 = (not presence or presence.placeId == nil) and "" or tostring(presence.placeId)
			local rootPlaceId = if presence then tonumber(presence.rootPlaceId) else nil

			if v36 ~= "" and rootPlaceId ~= nil then
				v6.Events.gamePlayIntent(v16.eventIngest, v6.Constants.Context.PeopleListInHomePage, {
					placeId = v36,
					rootPlaceId = rootPlaceId,
					friendId = props.item.id,
					joinAttemptId = HttpService:GenerateGUID(false)
				})
			end

			userPressed(v24, {
				absolutePosition = props.index,
				tileClickTarget = tileClickTarget
			})

			v35.joinExperience()
		else
			if props.item.onActivated then
				props.item.onActivated(props.item)
			else
				local v36

				if props.item.presence == nil then
					v36 = false
				else
					v36 = props.item.presence.userPresenceType == presenceTypes.InGame
				end

				local v37 = v12 and v36

				if fFlagShowRequestsInCarouselForAllUsers and v19 and v33 then
					v33()
				elseif
					v37
					and not (fFlagConsoleOpenMobileGameJoinCard and v15 and v36)
					and not fFlagConsoleOpenGameJoinCard
				then
					v7(PlayerContextualMenu.openPlayerContextualMenu({
						subjectUserId = props.item.id,
						subjectPresence = v25,
						robloxFriendshipStatus = fn(props.item),
						friendshipOriginSourceType = enums.FriendshipOriginSourceType.FriendRecommendations.rawValue()
					}))
				elseif
					props.item.presence
					and props.item.presence.userPresenceType == presenceTypes.InGame
				then
					if defineFastFlag then
						IXPService:LogFlagLinkedUserLayerExposure(defineFastString2)
					end

					if v15 then
						if fFlagMobileGameJoinCardTTITracking then
							gameJoinCardTTI.trackMobileCardClickStart()
						end

						if joinSheetUserIdRef ~= nil then
							joinSheetUserIdRef.current = props.item.id
						end

						local navigate = v8.navigate
						local gameJoinCard = appPage.GameJoinCard
						local v38 = {
							userId = props.item.id,
							homepageCarouselAbsolutePosition = props.index,
							isBannerVideoEnabled = 0,
							videoPlaybackContext = 0
						}

						local v39 = if fFlagMobileGameJoinCardVideo then v16.isJoinCardVideoEnabled else nil
						v38.isBannerVideoEnabled = v39

						local v40 = if fFlagMobileGameJoinCardVideo then v16.videoPlaybackContext else nil
						v38.videoPlaybackContext = v40
						navigate(gameJoinCard, v38)
					else
						setState(not state)
					end
				elseif fFlagSocialCarouselBuildPresence and v30.isInBuild and v30.canOpen then
					v30.onActivated()
				elseif fFlagShowRequestsInCarouselForAllUsers and v33 then
					v33()
				else
					local v38 = if fFlagEnableSplitPane then v8.push else v8.navigate
					v38(appPage.ProfilePlatform, {
						detail = props.item.id,
						extraProps = { source = enums2.Sources.HomePageFriendsCarousel }
					})
				end
			end

			local v38 = { absolutePosition = props.index, tileClickTarget = 0 }

			if not (fFlagSocialCarouselInGamePlayIcon and v34) then
				tileClickTarget = nil
			end

			v38.tileClickTarget = tileClickTarget
			userPressed(v24, v38)
		end
	end

	local item = props.item
	local v38 = if fFlagSocialCarouselInGamePlayIcon then v34 else nil
	local joinExperience

	if fFlagSocialCarouselInGameTileInstantJoin or fFlagSocialCarouselInGameTextInstantJoin then
		joinExperience = v35.joinExperience
	end

	local isLoading

	if fFlagSocialCarouselInGameTileInstantJoin or fFlagSocialCarouselInGameTextInstantJoin then
		isLoading = v35.isLoading
	end

	local eventIngest

	if fFlagSocialCarouselInGameTileInstantJoin or fFlagSocialCarouselInGameTextInstantJoin then
		eventIngest = v16.eventIngest
	end

	local v39 = if fFlagSocialCarouselInGameTitleMarquee then joinSheetUserIdRef else nil
	local v41 = if fFlagShowRequestsInCarouselForAllUsers then v19 else nil
	local v42 = if fFlagShowRequestsInCarouselForAllUsers then v33 else nil
	local v36 = {
		item,
		state,
		v38,
		joinExperience,
		isLoading,
		eventIngest,
		v31,
		v32,
		v39,
		fFlagSocialCarouselBuildPresence and v30,
		v41,
		v42,
		if fFlagShowRequestsInCarouselForAllUsers then v8 else nil,
		v24,
		v7,
		userPressed,
		nil,
		nil,
		nil,
		nil,
		nil,
		nil
	}

	local index = props.index

	local isJoinCardVideoEnabled = if fFlagMobileGameJoinCardVideo then v16.isJoinCardVideoEnabled else nil
	local v45 = if fFlagMobileGameJoinCardVideo then v16.videoPlaybackContext else nil
	v36[17], v36[18], v36[19], v36[20], v36[21], v36[22] = v12, index, v15, v25, isJoinCardVideoEnabled, v45
	local v46 = useCallback(fn2, v36)
	local v47

	if fFlagSocialCarouselInGamePlayIcon then
		v47 = React.useCallback(function()
			v46(nil, TILE_CLICK_TARGETS.AVATAR)
		end, { v46 })
	else
		v47 = v46
	end

	local v48

	if fFlagSocialCarouselInGamePlayIcon then
		v48 = React.useCallback(function()
			v46(nil, TILE_CLICK_TARGETS.TILE_TEXT)
		end, { v46 })
	end

	local v49

	if fFlagSocialCarouselInGamePlayIcon then
		v49 = React.useCallback(function()
			v46(nil, TILE_CLICK_TARGETS.PLAY_ICON)
		end, { v46 })
	end

	local v50 = React.useMemo(function()
		if fFlagShowRequestsInCarouselForAllUsers and v19 then
			return v18.friendRequestLabel
		end

		if props.item.tileType == tile.Recommendation then
			return v18.suggestedLabel
		end

		if props.item.presence and props.item.presence.userPresenceType == presenceTypes.InGame then
			return props.item.presence.lastLocation
		end

		return nil
	end, { props.item, v19, v18.friendRequestLabel, v18.suggestedLabel })

	local contextualInfo = if fFlagSocialCarouselBuildPresence and v30.isInBuild then v30.contextualInfo else nil

	local state2, setState2 = React.useState(nil)

	local ref2 = React.useRef(nil)

	local useCallback2 = React.useCallback
	local function fn3()
		if fFlagShowRequestsInCarouselForAllUsers and v33 then
			v33()
		else
			local v52 = if fFlagEnableSplitPane then v8.push else v8.navigate
			v52(appPage.ProfilePlatform, {
				detail = props.item.id,
				extraProps = { source = enums2.Sources.HomePageFriendsCarousel }
			})
		end

		userPressed(v24, { absolutePosition = props.index })
	end

	local item2 = props.item
	local index2 = props.index
	local v53 = if fFlagShowRequestsInCarouselForAllUsers then v33 else nil
	local navigate = if not fFlagShowRequestsInCarouselForAllUsers then v8.navigate else nil
	local v54 = if not fFlagShowRequestsInCarouselForAllUsers then v8.push else nil
	local v55 = useCallback2(fn3, {
		item2,
		index2,
		v53,
		navigate,
		v54,
		userPressed,
		v24
	})

	local v56 = React.useMemo(function()
		return {
			{
				onActivated = v55,
				focusEventName = focusNavigationEventNameEnum.ViewProfile
			},
			{
				onActivated = function() end
			}
		}
	end, { v55 })

	local v57 = React.useCallback(function(current)
		ref2.current = current

		if setState2 then
			setState2(current)
		end
	end, { setState2 })

	React.useEffect(function()
		if v16.unifiedLogging then
			v16.unifiedLogging.tagTileForImpressions(ref, props.index)
		end
	end, { props.index })

	React.useEffect(function()
		v16.onSuccessfulRender(Constants.ANALYTICS.UI_LOADING_EVENTS.CAROUSEL_FRIEND)

		if FFlagSocialCarouselEnableUserSeenEvents and not fFlagShowRequestsInCarouselForAllUsers then
			userSeen(props.item, { absolutePosition = props.index })
		end
	end, {})

	local ref3 = React.useRef(nil)
	React.useEffect(function()
		if
			fFlagShowRequestsInCarouselForAllUsers
			and FFlagSocialCarouselEnableUserSeenEvents
			and (not v19 or v23)
			and ref3.current ~= props.item.id
		then
			ref3.current = props.item.id
			userSeen(v24, { absolutePosition = props.index })
		end
	end, { v24, v19, v23, userSeen, props.item.id, props.index })

	if fFlagShowRequestsInCarouselForAllUsers then
		React.useEffect(function()
			if props.onTileContentChanged then
				props.onTileContentChanged(props.item.id, props.index, v24)
			end
		end, { props.item.id, props.index, v24, props.onTileContentChanged })
	else
		React.useEffect(function()
			if props.onTileContentChanged then
				props.onTileContentChanged(props.item.id, props.index)
			end
		end, { props.item.id, props.index })
	end

	local v58

	if FFlagSocialCarouselFixGameJoinCardDismiss then
		local id = props.item.id
		v58 = React.useCallback(function()
			if setOpenGameJoinCardUserId then
				setOpenGameJoinCardUserId(function(p2)
					if p2 == id then
						return nil
					end

					return p2
				end)
			elseif setState then
				setState(false)
			end
		end, { id, setOpenGameJoinCardUserId })
	else
		v58 = React.useCallback(function()
			if setState then
				setState(false)
			end
		end, {})
	end

	if fFlagDesktopGameJoinCardGamepadSupport and v11 then
		v11 = v9 ~= RobloxAppEnums.DeviceType.Desktop
	end

	if fFlagConsoleOpenGameJoinCard then
		v11 = v12
	end

	local v60

	if not (fFlagConsoleOpenGameJoinCard and v11) then
		if not (fFlagDesktopGameJoinCardGamepadSupport and not v11) then
			v60 = state2
		end
	end

	local v61 = useGameJoinCardNavigation(v60, v11 and not fFlagConsoleOpenGameJoinCard, ref)

	local presence = props.item.presence
	local v62 = presence and presence.userPresenceType == presenceTypes.InGame
	local v63 = if state or v61 then v62 and v25 ~= nil else v61
	local v64 = v62 and v11 and v63
	React.useEffect(function()
		if defineFastFlag and v63 then
			IXPService:LogFlagLinkedUserLayerExposure(defineFastString2)
		end
	end, { v63 })

	local createElement = React.createElement

	local join = Cryo.Dictionary.join

	if not fFlagShowRequestsInCarouselForAllUsers then
		v22 = nil
	end

	local v66 = {
		item = v22,
		itemSize = UDim2.fromScale(1, 1),
		onActivated = v47,
		name = 0,
		contextualText = 0,
		overlayIcon = 0,
		contextualInfo = 0,
		contextualInfoIcon = 0,
		tileRef = 0,
		titleIcon = 0,
		isRobloxSubscriber = 0,
		showPlayIcon = 0,
		onPlayIconActivated = 0,
		onTextActivated = 0
	}

	local v67 = if props.item.tileType == tile.Recommendation then v27 else v26
	v66.name = v67
	v66.contextualText = v50

	local v68 = if fFlagShowRequestsInCarouselForAllUsers and v19 then Foundation.Enums.IconName.PersonPlus else nil
	v66.overlayIcon = v68

	local v69 = if fFlagSocialCarouselBuildPresence and contextualInfo then contextualInfo.text else nil
	v66.contextualInfo = v69

	local v70 = if fFlagSocialCarouselBuildPresence and contextualInfo then contextualInfo.icon else nil
	v66.contextualInfoIcon = v70

	v66.tileRef = ref
	local v71 = if props.item.tileType == tile.Recommendation then defineFastString else nil
	v66.titleIcon = v71

	if not FFlagSocialCarouselShowPlusBadge then
		v29 = nil
	end

	v66.isRobloxSubscriber = v29
	v66.showPlayIcon = if fFlagSocialCarouselInGamePlayIcon then v34 else nil

	if not (fFlagSocialCarouselInGamePlayIcon and v34) then
		v49 = nil
	end

	v66.onPlayIconActivated = v49

	if not (fFlagSocialCarouselInGamePlayIcon and v34) then
		v48 = nil
	end

	v66.onTextActivated = v48
	local element = createElement(module15, join(props, v66))

	local createElement2 = React.createElement
	local v74 = {
		Size = props.itemSize,
		LayoutOrder = props.index,
		BackgroundTransparency = 1,
		ref = ref,
		stateLayer = { affordance = Foundation.Enums.StateLayerAffordance.None }
	}
	local v76

	if not (fFlagSocialCarouselBuildPresence and v30.isInBuild or not (v25 and presence)) then
		local createElement3 = React.createElement
		local v78 = {
			layoutOrder = 1,
			playerName = v26 or "",
			platformName = v27 or "",
			platformProfileId = v28,
			universeId = tostring(presence.universeId),
			experienceName = presence.lastLocation,
			userId = props.item.id,
			presence = presence,
			anchorRef = ref,
			isOpen = v63 == true,
			onClose = v58,
			homepageCarouselAbsolutePosition = props.index,
			showGamepadJoinFocus = v64 == true,
			onCardGuiObjectChanged = v57,
			isFocused = v61,
			isConsole = v11,
			experienceUtilities = 0
		}
		local v79 = if fFlagSocialCarouselInGameTileInstantJoin or fFlagSocialCarouselInGameTextInstantJoin then v35 else nil
		v78.experienceUtilities = v79
		v76 = createElement3(desktopGameJoinCardContainer, v78)
	end

	local v77 = if fFlagSocialCarouselBuildPresence then v30.popover else nil
	local v75 = {
		UserTile = element,
		GameJoinCardPopover = v76,
		BuildJoinCardPopover = v77,
		TileEventHandlers = React.createElement(userTileEventHandlers, {
			tileRef = ref,
			buttons = if v13 then v56 else nil,
			onTileActivated = function() end
		}),
		CardEventHandlers = 0
	}
	local v81

	if v13 and state2 then
		v81 = React.createElement(userTileEventHandlers, {
			tileRef = ref2,
			buttons = v56,
			onTileActivated = function() end
		})
	end

	v75.CardEventHandlers = v81
	return createElement2(view, v74, v75)
end
