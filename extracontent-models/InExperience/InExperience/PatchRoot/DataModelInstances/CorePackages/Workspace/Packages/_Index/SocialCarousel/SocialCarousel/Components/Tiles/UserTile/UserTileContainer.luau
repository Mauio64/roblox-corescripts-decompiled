local IXPService = game:GetService("IXPService")

local SocialCarousel = script:FindFirstAncestor("SocialCarousel")
local parent = SocialCarousel.Parent
local Cryo = require(parent.Cryo)
local Foundation = require(parent.Foundation)
local GameJoinCard = require(parent.GameJoinCard)
local PlayerContextualMenu = require(parent.PlayerContextualMenu)
local React = require(parent.React)
local Responsive = require(parent.Responsive)
local RobloxAppEnums = require(parent.RobloxAppEnums)
local DataHydration = require(parent.DataHydration)
local DataStatus = DataHydration.DataStatus
local UserProfiles = require(parent.UserProfiles)
local SocialCommon = require(parent.SocialCommon)
local SocialExperienceJoin = require(parent.SocialExperienceJoin)
local useJoinUserInExperience = SocialExperienceJoin.useJoinUserInExperience
local FriendsNetworking = require(parent.FriendsNetworking)
local Enums = FriendsNetworking.Enums
local FriendsCommon = require(parent.FriendsCommon)
local useGetPresenceByUserId = FriendsCommon.Hooks.useGetPresenceByUserId

local SharedFlags = require(parent.SharedFlags)
local FFlagSocialCarouselUseProfileStore = SharedFlags.FFlagSocialCarouselUseProfileStore
local SharedFlags2 = require(parent.SharedFlags)
local FFlagSocialCarouselInGameTitleMarquee = SharedFlags2.FFlagSocialCarouselInGameTitleMarquee
local SharedFlags3 = require(parent.SharedFlags)
local FFlagUserProfilePlatformProfile = SharedFlags3.FFlagUserProfilePlatformProfile
local SharedFlags4 = require(parent.SharedFlags)
local FFlagMobileGameJoinCardVideo = SharedFlags4.FFlagMobileGameJoinCardVideo
local SharedFlags5 = require(parent.SharedFlags)
local FFlagSocialCarouselBuildPresence = SharedFlags5.FFlagSocialCarouselBuildPresence
local Signals = require(parent.Signals)
local SignalsReact = require(parent.SignalsReact)
local v = UserProfiles.Stores.UserProfileStore.get()
local PresenceTypes = SocialCommon.Enums.PresenceTypes
local SocialLuaAnalytics = require(parent.SocialLuaAnalytics)
local enums = SocialLuaAnalytics.Analytics.Enums
local Enums2 = require(SocialCarousel.Common.Enums)
local Localization = require(parent.Localization)
local useSocialCarouselAnalytics = require(SocialCarousel.Analytics.useSocialCarouselAnalytics)
local usePreferredInput = Responsive.usePreferredInput
local UniversalAppPolicy = require(parent.UniversalAppPolicy)
local useAppPolicy = UniversalAppPolicy.useAppPolicy
local RobloxAppHooks = require(parent.RobloxAppHooks)
local useDeviceType = RobloxAppHooks.useDeviceType

local Navigation = require(parent.Navigation)
local useNavigation = Navigation.useNavigation
local RoactUtils = require(parent.RoactUtils)
local useDispatch = RoactUtils.Hooks.RoactRodux.useDispatch

local View = Foundation.View
local AppPage = RobloxAppEnums.AppPage
local useLocalization = Localization.Hooks.useLocalization
local Tile = Enums2.Tile

local UserTile = require(script.Parent.UserTile)
local UserTile2 = require(parent.UserTile)
local UserTileEventHandlers = UserTile2.UserTileEventHandlers
local FocusNavigationUtils = require(parent.FocusNavigationUtils)
local FocusNavigationEventNameEnum = FocusNavigationUtils.FocusNavigationEventNameEnum
local Constants = require(SocialCarousel.Common.Constants)
local TILE_CLICK_TARGETS = Constants.ANALYTICS.TILE_CLICK_TARGETS
local useSocialCarouselContext = require(SocialCarousel.Contexts.useSocialCarouselContext)
local useBuildCard = require(script.Parent.useBuildCard)

local DesktopGameJoinCardContainer = GameJoinCard.DesktopGameJoinCardContainer
local useAgeCheckCompletionLogger = GameJoinCard.Analytics.useAgeCheckUpsellAnalytics.useAgeCheckCompletionLogger
local useGameJoinCardNavigation = GameJoinCard.useGameJoinCardNavigation
local GameJoinCardTTI = GameJoinCard.Telemetry.GameJoinCardTTI

local defineFastString = game:DefineFastString(
	"SocialCarouselVendorImagePath",
	"rbxasset://textures/ui/Shell/Icons/PlatformLogo.png"
)
local SharedFlags6 = require(parent.SharedFlags)
local FFlagEnableSplitPane = SharedFlags6.FFlagEnableSplitPane
local FFlagSocialCarouselEnableUserSeenEvents = require(SocialCarousel.Flags.FFlagSocialCarouselEnableUserSeenEvents)

local FFlagSocialCarouselUseConsolePolicyForCta = require(SocialCarousel.Flags.FFlagSocialCarouselUseConsolePolicyForCta)

local FFlagSocialCarouselFixGameJoinCardDismiss = require(SocialCarousel.Flags.FFlagSocialCarouselFixGameJoinCardDismiss)
local FFlagSocialCarouselShowPlusBadge = require(SocialCarousel.Flags.FFlagSocialCarouselShowPlusBadge)
local SharedFlags7 = require(parent.SharedFlags)
local FFlagSocialCarouselInGamePlayIcon = SharedFlags7.FFlagSocialCarouselInGamePlayIcon
local SharedFlags8 = require(parent.SharedFlags)
local FFlagSocialCarouselInGameTileInstantJoin = SharedFlags8.FFlagSocialCarouselInGameTileInstantJoin
local SharedFlags9 = require(parent.SharedFlags)
local FFlagSocialCarouselInGameTextInstantJoin = SharedFlags9.FFlagSocialCarouselInGameTextInstantJoin
local DiscoveryAnalytics

if FFlagSocialCarouselInGameTileInstantJoin or FFlagSocialCarouselInGameTextInstantJoin then
	DiscoveryAnalytics = require(parent.DiscoveryAnalytics)
else
	DiscoveryAnalytics = nil
end

local HttpService

if FFlagSocialCarouselInGameTileInstantJoin or FFlagSocialCarouselInGameTextInstantJoin then
	HttpService = game:GetService("HttpService")
else
	HttpService = nil
end

local SharedFlags10 = require(parent.SharedFlags)
local FFlagEnableMobileGameJoinCard = SharedFlags10.FFlagEnableMobileGameJoinCard
local SharedFlags11 = require(parent.SharedFlags)
local FFlagConsoleOpenMobileGameJoinCard = SharedFlags11.FFlagConsoleOpenMobileGameJoinCard
local SharedFlags12 = require(parent.SharedFlags)
local FFlagConsoleOpenGameJoinCard = SharedFlags12.FFlagConsoleOpenGameJoinCard
local SharedFlags13 = require(parent.SharedFlags)
local FFlagShowRequestsInCarouselForAllUsers = SharedFlags13.FFlagShowRequestsInCarouselForAllUsers
local SharedFlags14 = require(parent.SharedFlags)
local FFlagMobileGameJoinCardTTITracking = SharedFlags14.FFlagMobileGameJoinCardTTITracking
local SharedFlags15 = require(parent.SharedFlags)
local FFlagMobileGameJoinCardGamepadSupport = SharedFlags15.FFlagMobileGameJoinCardGamepadSupport
local SharedFlags16 = require(parent.SharedFlags)
local FFlagDesktopGameJoinCardGamepadSupport = SharedFlags16.FFlagDesktopGameJoinCardGamepadSupport

local defineFastFlag = game:DefineFastFlag("EnableFriendCarouselInGameFriendExposureLogging_v2", false)

local defineFastString2 = game:DefineFastString(
	"SocialViewFriendSortInGameFriendsLayer",
	"Social.ViewFriendSortInGameFriends"
)

local function fn(item)
	if FFlagShowRequestsInCarouselForAllUsers and item.tileType == Tile.FriendRequest then
		return Enum.FriendStatus.FriendRequestReceived
	end

	if item.tileType ~= Tile.Recommendation or item.isFriendWithUser then
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

local function fn2(p, p2): boolean -- 1 equivalent call inferred from this helper
	return p ~= nil or p2 == DataStatus.Ready or p2 == DataStatus.Failed
end

local function fn3(item, flag: boolean?, presence) -- 1 equivalent call inferred from this helper
	if flag and presence then
		local clone = table.clone(item)
		clone.presence = presence
		return clone
	end

	return item
end

return function(props)
	local ref = React.useRef(nil)
	local v2 = useDispatch()
	local v3 = useNavigation()
	local v4

	if FFlagMobileGameJoinCardGamepadSupport or FFlagDesktopGameJoinCardGamepadSupport then
		v4 = useDeviceType()
	end

	local preferredInput = usePreferredInput()
	local isConsole = preferredInput == Responsive.Input.Directional
	local v5

	if FFlagSocialCarouselUseConsolePolicyForCta or FFlagMobileGameJoinCardGamepadSupport then
		v5 = useAppPolicy(function(p)
			return p.getUseConsoleGameJoinCard()
		end)
	else
		v5 = isConsole
	end

	if FFlagDesktopGameJoinCardGamepadSupport and v4 == RobloxAppEnums.DeviceType.Desktop then
		v5 = false
	end

	local v6 = preferredInput == Responsive.Input.Directional

	local isPhoneOrTablet = v4 == RobloxAppEnums.DeviceType.Phone or v4 == RobloxAppEnums.DeviceType.Tablet
	local v7

	if FFlagEnableMobileGameJoinCard then
		if FFlagMobileGameJoinCardGamepadSupport then
			v7 = isPhoneOrTablet or preferredInput == Responsive.Input.Touch
		else
			v7 = preferredInput == Responsive.Input.Touch
		end

		if not v7 then
			v7 = FFlagConsoleOpenMobileGameJoinCard and v5
		end
	else
		v7 = FFlagConsoleOpenMobileGameJoinCard and v5
	end

	local v8 = useSocialCarouselContext()
	local v9 = useSocialCarouselAnalytics()
	local userPressed = v9.userPressed
	local userSeen = v9.userSeen
	local v10 = useLocalization({
		suggestedLabel = "Feature.Friends.Label.Suggested",
		friendRequestLabel = FFlagShowRequestsInCarouselForAllUsers and "Feature.Friends.Label.FriendRequest" or nil
	})
	local v11, v12, v13

	if FFlagShowRequestsInCarouselForAllUsers then
		v11 = props.item.tileType == Tile.FriendRequest
		local v14

		if v11 then
			v14 = props.item.id
		end

		v12, v13 = useGetPresenceByUserId(v14)
	else
		v11 = nil
		v12 = nil
	end

	local v14 = React.useMemo(function()
		if not FFlagShowRequestsInCarouselForAllUsers then
			return props.item
		end

		return fn3(props.item, v11, v12) -- inferred equivalent call
	end, { props.item, v11, v12 })
	local v15 = fn2(v12, v13) -- inferred equivalent call
	local v16 = React.useMemo(function()
		if FFlagShowRequestsInCarouselForAllUsers and v11 and v15 then
			local clone = table.clone(props.item)
			clone.presence = v12 or { userPresenceType = PresenceTypes.Offline }

			return clone
		end

		return props.item
	end, { props.item, v11, v12, v15 })

	local subjectPresence = not (FFlagShowRequestsInCarouselForAllUsers and v11) and props.item.presence and {
		locationString = props.item.presence.lastLocation,
		locationPlaceId = props.item.presence.placeId,
		locationRootPlaceId = props.item.presence.rootPlaceId,
		locationUniverseId = props.item.presence.universeId,
		status = props.item.presence.userPresenceType
	} or nil
	local v17, v18, platformProfileId

	if FFlagSocialCarouselUseProfileStore then
		local v19 = React.useMemo(function()
			return v.fetchNamesByUserIds({ props.item.id }, nil, FFlagUserProfilePlatformProfile)
		end, { props.item.id })

		local v20 = React.useMemo(function()
			return Signals.createComputed(function(p)
				local v20 = v19(p)
				local v21 = v20 and v20.data and v20.data[1]

				if v21 and v21.names then
					return (v21.names.getCombinedName(p))
				end

				return nil
			end)
		end, { v19 })

		local v21 = React.useMemo(function()
			return Signals.createComputed(function(p)
				local v21 = v19(p)
				local v22 = v21 and v21.data and v21.data[1]

				if v22 and v22.names then
					return (v22.names.getPlatformName(p))
				end

				return nil
			end)
		end, { v19 })

		v17 = SignalsReact.useSignalState(v20)
		v18 = SignalsReact.useSignalState(v21)

		local v22 = React.useMemo(function()
			return Signals.createComputed(function(p)
				local v22 = v19(p)
				local v23 = v22 and v22.data and v22.data[1]

				if v23 then
					return (v23.getPlatformProfileId(p))
				end

				return nil
			end)
		end, { v19 })

		platformProfileId = SignalsReact.useSignalState(v22)
	else
		local v19 = UserProfiles.Hooks.useUserProfilesFetch({
			userIds = { props.item.id },
			query = UserProfiles.Queries.userProfilesDisplayUserPlatformNamesByUserIds
		})

		v17 = React.useMemo(function()
			if v19.data then
				return UserProfiles.Selectors.getCombinedNameFromId(v19.data, props.item.id)
			end

			return nil
		end, { v19.data })

		v18 = React.useMemo(function()
			if v19.data then
				return UserProfiles.Selectors.getPlatformNameFromId(v19.data, props.item.id)
			end

			return nil
		end, { v19.data })

		platformProfileId = React.useMemo(function()
			if v19.data then
				return UserProfiles.Selectors.getPlatformProfileIdFromId(v19.data, props.item.id)
			end

			return nil
		end, { v19.data, props.item.id })
	end

	local isRobloxSubscriber

	if FFlagSocialCarouselShowPlusBadge then
		isRobloxSubscriber = UserProfiles.Hooks.useIsRobloxSubscriber(props.item.id)
	end

	local state, setState = React.useState(false)
	local setOpenGameJoinCardUserId = v8.setOpenGameJoinCardUserId

	if setOpenGameJoinCardUserId then
		state = v8.openGameJoinCardUserId == props.item.id

		setState = function(p)
			if p then
				setOpenGameJoinCardUserId(props.item.id)
			else
				setOpenGameJoinCardUserId(function(p2: string?)
					return if p2 ~= props.item.id then p2 else nil
				end)
			end
		end
	end

	local v19

	if FFlagSocialCarouselBuildPresence then
		v19 = useBuildCard({
			userId = props.item.id,
			playerName = v17 or "",
			presence = props.item.presence,
			preferredInput = preferredInput,
			isPhoneOrTablet = isPhoneOrTablet,
			anchorRef = ref
		})
	else
		v19 = nil
	end

	local v20

	if FFlagMobileGameJoinCardGamepadSupport then
		v20 = v7
	end

	local v21

	if FFlagMobileGameJoinCardGamepadSupport or FFlagDesktopGameJoinCardGamepadSupport then
		v21 = v5
	end

	local joinSheetUserIdRef

	if FFlagSocialCarouselInGameTitleMarquee then
		joinSheetUserIdRef = v8.joinSheetUserIdRef
	else
		joinSheetUserIdRef = nil
	end

	local v22

	if FFlagShowRequestsInCarouselForAllUsers then
		v22 = React.useCallback(function()
			local v23

			if FFlagEnableSplitPane then
				v23 = v3.push
			else
				v23 = v3.navigate
			end

			v23(AppPage.ProfilePlatform, {
				detail = props.item.id,
				extraProps = { source = enums.Sources.HomePageFriendsCarousel }
			})
		end, { v3, props.item.id })
	else
		v22 = nil
	end

	local v23 = FFlagSocialCarouselInGamePlayIcon

	if v23 then
		if props.item.onActivated == nil and props.item.tileType == Tile.Friend and props.item.presence ~= nil then
			v23 = props.item.presence.userPresenceType == PresenceTypes.InGame
		else
			v23 = false
		end
	end

	local v24

	if FFlagSocialCarouselInGameTileInstantJoin or FFlagSocialCarouselInGameTextInstantJoin then
		v24 = useJoinUserInExperience(props.item.id, {
			isHomePageCarousel = true,
			homepageCarouselAbsolutePosition = props.index,
			presence = props.item.presence,
			onAgeCheckCompletion = useAgeCheckCompletionLogger(not props.item.presence and "" or tostring(props.item.presence.universeId))
		})
	else
		v24 = nil
	end

	local useCallback = React.useCallback
	local function fn4(_, tileClickTarget: string?)
		if
			(FFlagSocialCarouselInGameTileInstantJoin or FFlagSocialCarouselInGameTextInstantJoin)
			and v23
			and not v24.isLoading
			and (FFlagSocialCarouselInGameTileInstantJoin or tileClickTarget ~= TILE_CLICK_TARGETS.AVATAR)
		then
			local presence = props.item.presence
			local placeId = (not presence or presence.placeId == nil) and "" or tostring(presence.placeId)
			local rootPlaceId

			if presence then
				rootPlaceId = tonumber(presence.rootPlaceId)
			end

			if placeId ~= "" and rootPlaceId ~= nil then
				DiscoveryAnalytics.Events.gamePlayIntent(
					v8.eventIngest,
					DiscoveryAnalytics.Constants.Context.PeopleListInHomePage,
					{
						placeId = placeId,
						rootPlaceId = rootPlaceId,
						friendId = props.item.id,
						joinAttemptId = HttpService:GenerateGUID(false)
					}
				)
			end

			userPressed(v16, { absolutePosition = props.index, tileClickTarget = tileClickTarget })

			v24.joinExperience()
		else
			if props.item.onActivated then
				props.item.onActivated(props.item)
			else
				local v25

				if props.item.presence == nil then
					v25 = false
				else
					v25 = props.item.presence.userPresenceType == PresenceTypes.InGame
				end

				local v26 = v5 and v25

				if FFlagShowRequestsInCarouselForAllUsers and v11 and v22 then
					v22()
				elseif
					v26
					and not (FFlagConsoleOpenMobileGameJoinCard and v7 and v25)
					and not FFlagConsoleOpenGameJoinCard
				then
					v2(PlayerContextualMenu.openPlayerContextualMenu({
						subjectUserId = props.item.id,
						subjectPresence = subjectPresence,
						robloxFriendshipStatus = fn(props.item),
						friendshipOriginSourceType = Enums.FriendshipOriginSourceType.FriendRecommendations.rawValue()
					}))
				elseif props.item.presence and props.item.presence.userPresenceType == PresenceTypes.InGame then
					if defineFastFlag then
						IXPService:LogFlagLinkedUserLayerExposure(defineFastString2)
					end

					if v7 then
						if FFlagMobileGameJoinCardTTITracking then
							GameJoinCardTTI.trackMobileCardClickStart()
						end

						if joinSheetUserIdRef ~= nil then
							joinSheetUserIdRef.current = props.item.id
						end

						local navigate = v3.navigate
						local gameJoinCard = AppPage.GameJoinCard
						local v27 = {
							userId = props.item.id,
							homepageCarouselAbsolutePosition = props.index,
							isBannerVideoEnabled = 0,
							videoPlaybackContext = 0
						}
						local isBannerVideoEnabled

						if FFlagMobileGameJoinCardVideo then
							isBannerVideoEnabled = v8.isJoinCardVideoEnabled
						end

						v27.isBannerVideoEnabled = isBannerVideoEnabled
						local videoPlaybackContext

						if FFlagMobileGameJoinCardVideo then
							videoPlaybackContext = v8.videoPlaybackContext
						end

						v27.videoPlaybackContext = videoPlaybackContext
						navigate(gameJoinCard, v27)
					else
						setState(not state)
					end
				elseif FFlagSocialCarouselBuildPresence and v19.isInBuild and v19.canOpen then
					v19.onActivated()
				elseif FFlagShowRequestsInCarouselForAllUsers and v22 then
					v22()
				else
					local v27

					if FFlagEnableSplitPane then
						v27 = v3.push
					else
						v27 = v3.navigate
					end

					v27(AppPage.ProfilePlatform, {
						detail = props.item.id,
						extraProps = { source = enums.Sources.HomePageFriendsCarousel }
					})
				end
			end

			local v25 = { absolutePosition = props.index, tileClickTarget = 0 }

			if not (FFlagSocialCarouselInGamePlayIcon and v23) then
				tileClickTarget = nil
			end

			v25.tileClickTarget = tileClickTarget
			userPressed(v16, v25)
		end
	end

	local item = props.item
	local v25

	if FFlagSocialCarouselInGamePlayIcon then
		v25 = v23
	end

	local joinExperience

	if FFlagSocialCarouselInGameTileInstantJoin or FFlagSocialCarouselInGameTextInstantJoin then
		joinExperience = v24.joinExperience
	end

	local isLoading

	if FFlagSocialCarouselInGameTileInstantJoin or FFlagSocialCarouselInGameTextInstantJoin then
		isLoading = v24.isLoading
	end

	local eventIngest

	if FFlagSocialCarouselInGameTileInstantJoin or FFlagSocialCarouselInGameTextInstantJoin then
		eventIngest = v8.eventIngest
	end

	local v26

	if FFlagSocialCarouselInGameTitleMarquee then
		v26 = joinSheetUserIdRef
	end

	local v27

	if FFlagShowRequestsInCarouselForAllUsers then
		v27 = v11
	end

	local v28

	if FFlagShowRequestsInCarouselForAllUsers then
		v28 = v22
	end

	local v29

	if FFlagShowRequestsInCarouselForAllUsers then
		v29 = v3
	end

	local v30 = {
		item,
		state,
		v25,
		joinExperience,
		isLoading,
		eventIngest,
		v20,
		v21,
		v26,
		FFlagSocialCarouselBuildPresence and v19,
		v27,
		v28,
		v29,
		v16,
		v2,
		userPressed,
		nil,
		nil,
		nil,
		nil,
		nil,
		nil
	}

	local index = props.index
	local isJoinCardVideoEnabled

	if FFlagMobileGameJoinCardVideo then
		isJoinCardVideoEnabled = v8.isJoinCardVideoEnabled
	end

	local v31

	if FFlagMobileGameJoinCardVideo then
		v31 = v8.videoPlaybackContext
	end

	v30[17], v30[18], v30[19], v30[20], v30[21], v30[22] = v5, index, v7, subjectPresence, isJoinCardVideoEnabled, v31
	local v32 = useCallback(fn4, v30)
	local onActivated

	if FFlagSocialCarouselInGamePlayIcon then
		onActivated = React.useCallback(function()
			v32(nil, TILE_CLICK_TARGETS.AVATAR)
		end, { v32 })
	else
		onActivated = v32
	end

	local onTextActivated

	if FFlagSocialCarouselInGamePlayIcon then
		onTextActivated = React.useCallback(function()
			v32(nil, TILE_CLICK_TARGETS.TILE_TEXT)
		end, { v32 })
	end

	local onPlayIconActivated

	if FFlagSocialCarouselInGamePlayIcon then
		onPlayIconActivated = React.useCallback(function()
			v32(nil, TILE_CLICK_TARGETS.PLAY_ICON)
		end, { v32 })
	end

	local contextualText = React.useMemo(function()
		if FFlagShowRequestsInCarouselForAllUsers and v11 then
			return v10.friendRequestLabel
		end

		if props.item.tileType == Tile.Recommendation then
			return v10.suggestedLabel
		end

		if props.item.presence and props.item.presence.userPresenceType == PresenceTypes.InGame then
			return props.item.presence.lastLocation
		end

		return nil
	end, { props.item, v11, v10.friendRequestLabel, v10.suggestedLabel })
	local contextualInfo

	if FFlagSocialCarouselBuildPresence and v19.isInBuild then
		contextualInfo = v19.contextualInfo
	end

	local state2, setState2 = React.useState(nil)

	local ref2 = React.useRef(nil)

	local useCallback2 = React.useCallback
	local function fn5()
		if FFlagShowRequestsInCarouselForAllUsers and v22 then
			v22()
		else
			local v47

			if FFlagEnableSplitPane then
				v47 = v3.push
			else
				v47 = v3.navigate
			end

			v47(AppPage.ProfilePlatform, {
				detail = props.item.id,
				extraProps = { source = enums.Sources.HomePageFriendsCarousel }
			})
		end

		userPressed(v16, { absolutePosition = props.index })
	end

	local item2 = props.item
	local index2 = props.index
	local v48

	if FFlagShowRequestsInCarouselForAllUsers then
		v48 = v22
	end

	local navigate

	if not FFlagShowRequestsInCarouselForAllUsers then
		navigate = v3.navigate
	end

	local v49

	if not FFlagShowRequestsInCarouselForAllUsers then
		v49 = v3.push
	end

	local onActivated2 = useCallback2(fn5, { item2, index2, v48, navigate, v49, userPressed, v16 })

	local buttons = React.useMemo(function()
		return {
			{
				onActivated = onActivated2,
				focusEventName = FocusNavigationEventNameEnum.ViewProfile
			},
			{
				onActivated = function() end
			}
		}
	end, { onActivated2 })

	local onCardGuiObjectChanged = React.useCallback(function(current)
		ref2.current = current

		if setState2 then
			setState2(current)
		end
	end, { setState2 })

	React.useEffect(function()
		if v8.unifiedLogging then
			v8.unifiedLogging.tagTileForImpressions(ref, props.index)
		end
	end, { props.index })

	React.useEffect(function()
		v8.onSuccessfulRender(Constants.ANALYTICS.UI_LOADING_EVENTS.CAROUSEL_FRIEND)

		if FFlagSocialCarouselEnableUserSeenEvents and not FFlagShowRequestsInCarouselForAllUsers then
			userSeen(props.item, { absolutePosition = props.index })
		end
	end, {})

	local ref3 = React.useRef(nil)
	React.useEffect(function()
		if
			FFlagShowRequestsInCarouselForAllUsers
			and FFlagSocialCarouselEnableUserSeenEvents
			and (not v11 or v15)
			and ref3.current ~= props.item.id
		then
			ref3.current = props.item.id
			userSeen(v16, { absolutePosition = props.index })
		end
	end, { v16, v11, v15, userSeen, props.item.id, props.index })

	if FFlagShowRequestsInCarouselForAllUsers then
		React.useEffect(function()
			if props.onTileContentChanged then
				props.onTileContentChanged(props.item.id, props.index, v16)
			end
		end, { props.item.id, props.index, v16, props.onTileContentChanged })
	else
		React.useEffect(function()
			if props.onTileContentChanged then
				props.onTileContentChanged(props.item.id, props.index)
			end
		end, { props.item.id, props.index })
	end

	local onClose

	if FFlagSocialCarouselFixGameJoinCardDismiss then
		local id = props.item.id
		onClose = React.useCallback(function()
			if setOpenGameJoinCardUserId then
				setOpenGameJoinCardUserId(function(p: string?)
					return if p ~= id then p else nil
				end)
			elseif setState then
				setState(false)
			end
		end, { id, setOpenGameJoinCardUserId })
	else
		onClose = React.useCallback(function()
			if setState then
				setState(false)
			end
		end, {})
	end

	if FFlagDesktopGameJoinCardGamepadSupport and isConsole then
		isConsole = v4 ~= RobloxAppEnums.DeviceType.Desktop
	end

	if FFlagConsoleOpenGameJoinCard then
		isConsole = v5
	end

	local v55

	if not (FFlagConsoleOpenGameJoinCard and isConsole) then
		if not (FFlagDesktopGameJoinCardGamepadSupport and not isConsole) then
			v55 = state2
		end
	end

	local isFocused = useGameJoinCardNavigation(v55, isConsole and not FFlagConsoleOpenGameJoinCard, ref)

	local presence = props.item.presence
	local v57 = presence and presence.userPresenceType == PresenceTypes.InGame
	local v58

	if state or isFocused then
		v58 = v57 and subjectPresence ~= nil
	else
		v58 = isFocused
	end

	local v59 = v57 and isConsole and v58
	React.useEffect(function()
		if defineFastFlag and v58 then
			IXPService:LogFlagLinkedUserLayerExposure(defineFastString2)
		end
	end, { v58 })

	local createElement = React.createElement

	local join = Cryo.Dictionary.join

	if not FFlagShowRequestsInCarouselForAllUsers then
		v14 = nil
	end

	local v60 = {
		item = v14,
		itemSize = UDim2.fromScale(1, 1),
		onActivated = onActivated,
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
	local name

	if props.item.tileType == Tile.Recommendation then
		name = v18
	else
		name = v17
	end

	v60.name = name
	v60.contextualText = contextualText
	local overlayIcon

	if FFlagShowRequestsInCarouselForAllUsers and v11 then
		overlayIcon = Foundation.Enums.IconName.PersonPlus
	end

	v60.overlayIcon = overlayIcon
	local contextualInfo2

	if FFlagSocialCarouselBuildPresence and contextualInfo then
		contextualInfo2 = contextualInfo.text
	end

	v60.contextualInfo = contextualInfo2
	local contextualInfoIcon

	if FFlagSocialCarouselBuildPresence and contextualInfo then
		contextualInfoIcon = contextualInfo.icon
	end

	v60.contextualInfoIcon = contextualInfoIcon

	v60.tileRef = ref
	local titleIcon

	if props.item.tileType == Tile.Recommendation then
		titleIcon = defineFastString
	end

	v60.titleIcon = titleIcon

	if not FFlagSocialCarouselShowPlusBadge then
		isRobloxSubscriber = nil
	end

	v60.isRobloxSubscriber = isRobloxSubscriber
	local showPlayIcon

	if FFlagSocialCarouselInGamePlayIcon then
		showPlayIcon = v23
	end

	v60.showPlayIcon = showPlayIcon

	if not (FFlagSocialCarouselInGamePlayIcon and v23) then
		onPlayIconActivated = nil
	end

	v60.onPlayIconActivated = onPlayIconActivated

	if not (FFlagSocialCarouselInGamePlayIcon and v23) then
		onTextActivated = nil
	end

	v60.onTextActivated = onTextActivated
	local element = createElement(UserTile, join(props, v60))

	local createElement2 = React.createElement
	local v67 = {
		Size = props.itemSize,
		LayoutOrder = props.index,
		BackgroundTransparency = 1,
		ref = ref,
		stateLayer = { affordance = Foundation.Enums.StateLayerAffordance.None }
	}
	local gameJoinCardPopover

	if not (FFlagSocialCarouselBuildPresence and v19.isInBuild or not (subjectPresence and presence)) then
		local createElement3 = React.createElement
		local v70 = {
			layoutOrder = 1,
			playerName = v17 or "",
			platformName = v18 or "",
			platformProfileId = platformProfileId,
			universeId = tostring(presence.universeId),
			experienceName = presence.lastLocation,
			userId = props.item.id,
			presence = presence,
			anchorRef = ref,
			isOpen = v58 == true,
			onClose = onClose,
			homepageCarouselAbsolutePosition = props.index,
			showGamepadJoinFocus = v59 == true,
			onCardGuiObjectChanged = onCardGuiObjectChanged,
			isFocused = isFocused,
			isConsole = isConsole,
			experienceUtilities = 0
		}
		local experienceUtilities

		if FFlagSocialCarouselInGameTileInstantJoin or FFlagSocialCarouselInGameTextInstantJoin then
			experienceUtilities = v24
		end

		v70.experienceUtilities = experienceUtilities
		gameJoinCardPopover = createElement3(DesktopGameJoinCardContainer, v70)
	end

	local buildJoinCardPopover

	if FFlagSocialCarouselBuildPresence then
		buildJoinCardPopover = v19.popover
	end

	local createElement3 = React.createElement
	local v71 = { tileRef = ref, buttons = nil, onTileActivated = 0 }
	local buttons2

	if v6 then
		buttons2 = buttons
	end

	v71.buttons = buttons2
	function v71.onTileActivated() end

	local v68 = {
		UserTile = element,
		GameJoinCardPopover = gameJoinCardPopover,
		BuildJoinCardPopover = buildJoinCardPopover,
		TileEventHandlers = createElement3(UserTileEventHandlers, v71),
		CardEventHandlers = 0
	}
	local cardEventHandlers

	if v6 and state2 then
		cardEventHandlers = React.createElement(UserTileEventHandlers, {
			tileRef = ref2,
			buttons = buttons,
			onTileActivated = function() end
		})
	end

	v68.CardEventHandlers = cardEventHandlers
	return createElement2(View, v67, v68)
end
