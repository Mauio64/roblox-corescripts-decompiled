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
local enums = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialCarousel/NetworkingFriends").Enums
local useGetPresenceByUserId = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialCarousel/FriendsCommon").Hooks.useGetPresenceByUserId

local fFlagSocialCarouselUseProfileStore = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialCarousel/SharedFlags").FFlagSocialCarouselUseProfileStore
local fFlagUserProfilePlatformProfile = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialCarousel/SharedFlags").FFlagUserProfilePlatformProfile
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
local useSocialCarouselContext = require("@game/CorePackages/Workspace/Packages/_Index/SocialCarousel/SocialCarousel/Contexts/useSocialCarouselContext")
local useBuildCard = require("@game/CorePackages/Workspace/Packages/_Index/SocialCarousel/SocialCarousel/Components/Tiles/UserTile/useBuildCard")

local desktopGameJoinCardContainer = GameJoinCard.DesktopGameJoinCardContainer
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
	local v6 = useDispatch()
	local v7 = useNavigation()
	local v8

	if fFlagMobileGameJoinCardGamepadSupport or fFlagDesktopGameJoinCardGamepadSupport then
		v8 = useDeviceType()
	end

	local v9 = usePreferredInput()
	local v10 = v9 == Responsive.Input.Directional
	local v11

	if FFlagSocialCarouselUseConsolePolicyForCta or fFlagMobileGameJoinCardGamepadSupport then
		v11 = useAppPolicy(function(p2)
			return p2.getUseConsoleGameJoinCard()
		end)
	else
		v11 = v10
	end

	if fFlagDesktopGameJoinCardGamepadSupport and v8 == RobloxAppEnums.DeviceType.Desktop then
		v11 = false
	end

	local v12 = v9 == Responsive.Input.Directional

	local v13 = v8 == RobloxAppEnums.DeviceType.Phone or v8 == RobloxAppEnums.DeviceType.Tablet
	local v14

	if fFlagEnableMobileGameJoinCard then
		if fFlagMobileGameJoinCardGamepadSupport then
			v14 = v13 or v9 == Responsive.Input.Touch
		else
			v14 = v9 == Responsive.Input.Touch
		end

		if not v14 then
			v14 = fFlagConsoleOpenMobileGameJoinCard and v11
		end
	else
		v14 = fFlagConsoleOpenMobileGameJoinCard and v11
	end

	local v15 = useSocialCarouselContext()
	local v16 = useSocialCarouselAnalytics()
	local userPressed = v16.userPressed
	local userSeen = v16.userSeen
	local v17 = useLocalization({
		suggestedLabel = "Feature.Friends.Label.Suggested",
		friendRequestLabel = fFlagShowRequestsInCarouselForAllUsers and "Feature.Friends.Label.FriendRequest" or nil
	})
	local v18, v19, v20

	if fFlagShowRequestsInCarouselForAllUsers then
		v18 = props.item.tileType == tile.FriendRequest

		local v22 = if v18 then props.item.id else nil
		v19, v20 = useGetPresenceByUserId(v22)
	else
		v18 = nil
		v19 = nil
	end

	local v21 = React.useMemo(function()
		if not fFlagShowRequestsInCarouselForAllUsers then
			return props.item
		end

		local item = props.item
		local v22 = v19

		if v18 and v22 then
			local clone = table.clone(item)
			clone.presence = v22
			return clone
		end

		return item
	end, { props.item, v18, v19 })
	local v22 = v19 ~= nil or v20 == dataStatus.Ready or v20 == dataStatus.Failed

	local v23 = React.useMemo(function()
		if fFlagShowRequestsInCarouselForAllUsers and v18 and v22 then
			local clone = table.clone(props.item)
			clone.presence = v19 or { userPresenceType = presenceTypes.Offline }

			return clone
		end

		return props.item
	end, { props.item, v18, v19, v22 })

	local v24 = not (fFlagShowRequestsInCarouselForAllUsers and v18) and props.item.presence and {
		locationString = props.item.presence.lastLocation,
		locationPlaceId = props.item.presence.placeId,
		locationRootPlaceId = props.item.presence.rootPlaceId,
		locationUniverseId = props.item.presence.universeId,
		status = props.item.presence.userPresenceType
	} or nil
	local v25, v26, v27

	if fFlagSocialCarouselUseProfileStore then
		local v28 = React.useMemo(function()
			return v5.fetchNamesByUserIds({ props.item.id }, nil, fFlagUserProfilePlatformProfile)
		end, { props.item.id })

		local v29 = React.useMemo(function()
			return Signals.createComputed(function(p2)
				local v30 = v28(p2)
				local v31 = v30 and v30.data and v30.data[1]

				if v31 and v31.names then
					return (v31.names.getCombinedName(p2))
				end

				return nil
			end)
		end, { v28 })

		local v30 = React.useMemo(function()
			return Signals.createComputed(function(p2)
				local v31 = v28(p2)
				local v32 = v31 and v31.data and v31.data[1]

				if v32 and v32.names then
					return (v32.names.getPlatformName(p2))
				end

				return nil
			end)
		end, { v28 })

		v25 = SignalsReact.useSignalState(v29)
		v26 = SignalsReact.useSignalState(v30)

		local v31 = React.useMemo(function()
			return Signals.createComputed(function(p2)
				local v32 = v28(p2)
				local v33 = v32 and v32.data and v32.data[1]

				if v33 then
					return (v33.getPlatformProfileId(p2))
				end

				return nil
			end)
		end, { v28 })

		v27 = SignalsReact.useSignalState(v31)
	else
		local v28 = UserProfiles.Hooks.useUserProfilesFetch({
			userIds = { props.item.id },
			query = UserProfiles.Queries.userProfilesDisplayUserPlatformNamesByUserIds
		})

		v25 = React.useMemo(function()
			if v28.data then
				return UserProfiles.Selectors.getCombinedNameFromId(v28.data, props.item.id)
			end

			return nil
		end, { v28.data })

		v26 = React.useMemo(function()
			if v28.data then
				return UserProfiles.Selectors.getPlatformNameFromId(v28.data, props.item.id)
			end

			return nil
		end, { v28.data })

		v27 = React.useMemo(function()
			if v28.data then
				return UserProfiles.Selectors.getPlatformProfileIdFromId(v28.data, props.item.id)
			end

			return nil
		end, { v28.data, props.item.id })
	end

	local v28 = if FFlagSocialCarouselShowPlusBadge then UserProfiles.Hooks.useIsRobloxSubscriber(props.item.id) else nil

	local state, setState = React.useState(false)
	local setOpenGameJoinCardUserId = v15.setOpenGameJoinCardUserId

	if setOpenGameJoinCardUserId then
		state = v15.openGameJoinCardUserId == props.item.id

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

	local v29

	if fFlagSocialCarouselBuildPresence then
		v29 = useBuildCard({
			userId = props.item.id,
			playerName = v25 or "",
			presence = props.item.presence,
			preferredInput = v9,
			isPhoneOrTablet = v13,
			anchorRef = ref
		})
	else
		v29 = nil
	end

	local v30 = if fFlagMobileGameJoinCardGamepadSupport then v14 else nil
	local v31

	if fFlagMobileGameJoinCardGamepadSupport or fFlagDesktopGameJoinCardGamepadSupport then
		v31 = v11
	end

	local v32

	if fFlagShowRequestsInCarouselForAllUsers then
		v32 = React.useCallback(function()
			local v33 = if fFlagEnableSplitPane then v7.push else v7.navigate
			v33(appPage.ProfilePlatform, {
				detail = props.item.id,
				extraProps = { source = enums2.Sources.HomePageFriendsCarousel }
			})
		end, { v7, props.item.id })
	else
		v32 = nil
	end

	local useCallback = React.useCallback
	local function fn2(p2)
		if props.item.onActivated then
			props.item.onActivated(props.item)
		else
			local v33

			if props.item.presence == nil then
				v33 = false
			else
				v33 = props.item.presence.userPresenceType == presenceTypes.InGame
			end

			local v34 = v11 and v33

			if fFlagShowRequestsInCarouselForAllUsers and v18 and v32 then
				v32()
			elseif
				v34
				and not (fFlagConsoleOpenMobileGameJoinCard and v14 and v33)
				and not fFlagConsoleOpenGameJoinCard
			then
				v6(PlayerContextualMenu.openPlayerContextualMenu({
					subjectUserId = props.item.id,
					subjectPresence = v24,
					robloxFriendshipStatus = fn(props.item),
					friendshipOriginSourceType = enums.FriendshipOriginSourceType.FriendRecommendations.rawValue()
				}))
			elseif props.item.presence and props.item.presence.userPresenceType == presenceTypes.InGame then
				if defineFastFlag then
					IXPService:LogFlagLinkedUserLayerExposure(defineFastString2)
				end

				if v14 then
					if fFlagMobileGameJoinCardTTITracking then
						gameJoinCardTTI.trackMobileCardClickStart()
					end

					v7.navigate(appPage.GameJoinCard, {
						userId = props.item.id,
						homepageCarouselAbsolutePosition = props.index
					})
				else
					setState(not state)
				end
			elseif fFlagSocialCarouselBuildPresence and v29.isInBuild and v29.canOpen then
				v29.onActivated()
			elseif fFlagShowRequestsInCarouselForAllUsers and v32 then
				v32()
			else
				local v35 = if fFlagEnableSplitPane then v7.push else v7.navigate
				v35(appPage.ProfilePlatform, {
					detail = props.item.id,
					extraProps = { source = enums2.Sources.HomePageFriendsCarousel }
				})
			end
		end

		userPressed(v23, { absolutePosition = props.index })
	end

	local item = props.item
	local v36 = if fFlagShowRequestsInCarouselForAllUsers then v18 else nil
	local v37 = if fFlagShowRequestsInCarouselForAllUsers then v32 else nil
	local v39 = useCallback(fn2, {
		item,
		state,
		v30,
		v31,
		fFlagSocialCarouselBuildPresence and v29,
		v36,
		v37,
		if fFlagShowRequestsInCarouselForAllUsers then v7 else nil,
		v23,
		v6,
		userPressed,
		v11,
		props.index,
		v14,
		v24
	})

	local v40 = React.useMemo(function()
		if fFlagShowRequestsInCarouselForAllUsers and v18 then
			return v17.friendRequestLabel
		end

		if props.item.tileType == tile.Recommendation then
			return v17.suggestedLabel
		end

		if props.item.presence and props.item.presence.userPresenceType == presenceTypes.InGame then
			return props.item.presence.lastLocation
		end

		return nil
	end, { props.item, v18, v17.friendRequestLabel, v17.suggestedLabel })

	local contextualInfo = if fFlagSocialCarouselBuildPresence and v29.isInBuild then v29.contextualInfo else nil

	local state2, setState2 = React.useState(nil)

	local ref2 = React.useRef(nil)

	local useCallback2 = React.useCallback
	local function fn3()
		if fFlagShowRequestsInCarouselForAllUsers and v32 then
			v32()
		else
			local v42 = if fFlagEnableSplitPane then v7.push else v7.navigate
			v42(appPage.ProfilePlatform, {
				detail = props.item.id,
				extraProps = { source = enums2.Sources.HomePageFriendsCarousel }
			})
		end

		userPressed(v23, { absolutePosition = props.index })
	end

	local item2 = props.item
	local index = props.index
	local v43 = if fFlagShowRequestsInCarouselForAllUsers then v32 else nil
	local navigate = if not fFlagShowRequestsInCarouselForAllUsers then v7.navigate else nil
	local v44 = if not fFlagShowRequestsInCarouselForAllUsers then v7.push else nil
	local v45 = useCallback2(fn3, { item2, index, v43, navigate, v44, userPressed, v23 })

	local v46 = React.useMemo(function()
		return {
			{
				onActivated = v45,
				focusEventName = focusNavigationEventNameEnum.ViewProfile
			},
			{
				onActivated = function() end
			}
		}
	end, { v45 })

	local v47 = React.useCallback(function(current)
		ref2.current = current

		if setState2 then
			setState2(current)
		end
	end, { setState2 })

	React.useEffect(function()
		if v15.unifiedLogging then
			v15.unifiedLogging.tagTileForImpressions(ref, props.index)
		end
	end, { props.index })

	React.useEffect(function()
		v15.onSuccessfulRender(Constants.ANALYTICS.UI_LOADING_EVENTS.CAROUSEL_FRIEND)

		if FFlagSocialCarouselEnableUserSeenEvents and not fFlagShowRequestsInCarouselForAllUsers then
			userSeen(props.item, { absolutePosition = props.index })
		end
	end, {})

	local ref3 = React.useRef(nil)
	React.useEffect(function()
		if
			fFlagShowRequestsInCarouselForAllUsers
			and FFlagSocialCarouselEnableUserSeenEvents
			and (not v18 or v22)
			and ref3.current ~= props.item.id
		then
			ref3.current = props.item.id
			userSeen(v23, { absolutePosition = props.index })
		end
	end, { v23, v18, v22, userSeen, props.item.id, props.index })

	if fFlagShowRequestsInCarouselForAllUsers then
		React.useEffect(function()
			if props.onTileContentChanged then
				props.onTileContentChanged(props.item.id, props.index, v23)
			end
		end, { props.item.id, props.index, v23, props.onTileContentChanged })
	else
		React.useEffect(function()
			if props.onTileContentChanged then
				props.onTileContentChanged(props.item.id, props.index)
			end
		end, { props.item.id, props.index })
	end

	local v48

	if FFlagSocialCarouselFixGameJoinCardDismiss then
		local id = props.item.id
		v48 = React.useCallback(function()
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
		v48 = React.useCallback(function()
			if setState then
				setState(false)
			end
		end, {})
	end

	if fFlagDesktopGameJoinCardGamepadSupport and v10 then
		v10 = v8 ~= RobloxAppEnums.DeviceType.Desktop
	end

	if fFlagConsoleOpenGameJoinCard then
		v10 = v11
	end

	local v50

	if not (fFlagConsoleOpenGameJoinCard and v10) then
		if not (fFlagDesktopGameJoinCardGamepadSupport and not v10) then
			v50 = state2
		end
	end

	local v51 = useGameJoinCardNavigation(v50, v10 and not fFlagConsoleOpenGameJoinCard, ref)

	local presence = props.item.presence
	local v52 = presence and presence.userPresenceType == presenceTypes.InGame
	local v53 = if state or v51 then v52 and v24 ~= nil else v51
	React.useEffect(function()
		if defineFastFlag and v53 then
			IXPService:LogFlagLinkedUserLayerExposure(defineFastString2)
		end
	end, { v53 })

	local createElement = React.createElement

	local join = Cryo.Dictionary.join

	if not fFlagShowRequestsInCarouselForAllUsers then
		v21 = nil
	end

	local v56 = {
		item = v21,
		itemSize = UDim2.fromScale(1, 1),
		onActivated = v39,
		name = 0,
		contextualText = 0,
		overlayIcon = 0,
		contextualInfo = 0,
		contextualInfoIcon = 0,
		tileRef = 0,
		titleIcon = 0,
		isRobloxSubscriber = 0
	}

	local v57 = if props.item.tileType == tile.Recommendation then v26 else v25
	v56.name = v57
	v56.contextualText = v40

	local v58 = if fFlagShowRequestsInCarouselForAllUsers and v18 then Foundation.Enums.IconName.PersonPlus else nil
	v56.overlayIcon = v58

	local v59 = if fFlagSocialCarouselBuildPresence and contextualInfo then contextualInfo.text else nil
	v56.contextualInfo = v59

	local v60 = if fFlagSocialCarouselBuildPresence and contextualInfo then contextualInfo.icon else nil
	v56.contextualInfoIcon = v60

	v56.tileRef = ref
	local v61 = if props.item.tileType == tile.Recommendation then defineFastString else nil
	v56.titleIcon = v61

	if not FFlagSocialCarouselShowPlusBadge then
		v28 = nil
	end

	v56.isRobloxSubscriber = v28
	local element = createElement(module15, join(props, v56))

	local createElement2 = React.createElement
	local v63 = {
		Size = props.itemSize,
		LayoutOrder = props.index,
		BackgroundTransparency = 1,
		ref = ref,
		stateLayer = { affordance = Foundation.Enums.StateLayerAffordance.None }
	}

	local v65 = if not (fFlagSocialCarouselBuildPresence and v29.isInBuild or not (v24 and presence)) then React.createElement(desktopGameJoinCardContainer, {
		layoutOrder = 1,
		playerName = v25 or "",
		platformName = v26 or "",
		platformProfileId = v27,
		universeId = tostring(presence.universeId),
		experienceName = presence.lastLocation,
		userId = props.item.id,
		presence = presence,
		anchorRef = ref,
		isOpen = v53 == true,
		onClose = v48,
		homepageCarouselAbsolutePosition = props.index,
		showGamepadJoinFocus = (v52 and v10 and v53) == true,
		onCardGuiObjectChanged = v47,
		isFocused = v51,
		isConsole = v10
	}) else nil

	local v66 = if fFlagSocialCarouselBuildPresence then v29.popover else nil
	local v64 = {
		UserTile = element,
		GameJoinCardPopover = v65,
		BuildJoinCardPopover = v66,
		TileEventHandlers = React.createElement(userTileEventHandlers, {
			tileRef = ref,
			buttons = if v12 then v46 else nil,
			onTileActivated = function() end
		}),
		CardEventHandlers = 0
	}
	local v70

	if v12 and state2 then
		v70 = React.createElement(userTileEventHandlers, {
			tileRef = ref2,
			buttons = v46,
			onTileActivated = function() end
		})
	end

	v64.CardEventHandlers = v70
	return createElement2(view, v63, v64)
end
