local IXPService = game:GetService("IXPService")
local SocialCarousel = script:FindFirstAncestor("SocialCarousel")
local SocialCarouselParent = SocialCarousel.Parent
local Cryo = require(SocialCarouselParent.Cryo)
local Foundation = require(SocialCarouselParent.Foundation)
local GameJoinCard = require(SocialCarouselParent.GameJoinCard)
local PlayerContextualMenu = require(SocialCarouselParent.PlayerContextualMenu)
local React = require(SocialCarouselParent.React)
local Responsive = require(SocialCarouselParent.Responsive)
local RobloxAppEnums = require(SocialCarouselParent.RobloxAppEnums)
local UserProfiles = require(SocialCarouselParent.UserProfiles)
local SocialCommon = require(SocialCarouselParent.SocialCommon)
local Enums = require(SocialCarouselParent.FriendsNetworking).Enums
local FFlagSocialCarouselUseProfileStore = require(SocialCarouselParent.SharedFlags).FFlagSocialCarouselUseProfileStore
local Signals = require(SocialCarouselParent.Signals)
local SignalsReact = require(SocialCarouselParent.SignalsReact)
local v17 = UserProfiles.Stores.UserProfileStore.get()
local PresenceTypes = SocialCommon.Enums.PresenceTypes
local SetCentralOverlay = require(SocialCarouselParent.CentralOverlay).Actions.SetCentralOverlay
local Enums2 = require(SocialCarouselParent.SocialLuaAnalytics).Analytics.Enums
local Enums3 = require(SocialCarousel.Common.Enums)
local Localization = require(SocialCarouselParent.Localization)
local useSocialCarouselAnalytics = require(SocialCarousel.Analytics.useSocialCarouselAnalytics)
local usePreferredInput = Responsive.usePreferredInput
local useNavigation = require(SocialCarouselParent.Navigation).useNavigation
local useDispatch = require(SocialCarouselParent.RoactUtils).Hooks.RoactRodux.useDispatch
local View = Foundation.View
local CentralOverlayType = RobloxAppEnums.CentralOverlayType
local AppPage = RobloxAppEnums.AppPage
local useLocalization = Localization.Hooks.useLocalization
local Tile = Enums3.Tile
local UserTile = require(script.Parent.UserTile)
local UserTileEventHandlers = require(SocialCarouselParent.UserTile).UserTileEventHandlers
local FocusNavigationEventNameEnum = require(SocialCarouselParent.FocusNavigationUtils).FocusNavigationEventNameEnum
local Constants = require(SocialCarousel.Common.Constants)
local useSocialCarouselContext = require(SocialCarousel.Contexts.useSocialCarouselContext)
local DesktopGameJoinCardContainer = GameJoinCard.DesktopGameJoinCardContainer
local useGameJoinCardNavigation = GameJoinCard.useGameJoinCardNavigation
local GameJoinCardTTI = GameJoinCard.Telemetry.GameJoinCardTTI
local v40 = game:DefineFastString("SocialCarouselVendorImagePath", "rbxasset://textures/ui/Shell/Icons/PlatformLogo.png")
local FFlagJoinGameCardPassThroughUniversePlaceInfoFromFriendsCarousel = require(SocialCarouselParent.SharedFlags).FFlagJoinGameCardPassThroughUniversePlaceInfoFromFriendsCarousel
local FFlagPPVEnabledOnConsole = require(SocialCarouselParent.SharedFlags).FFlagPPVEnabledOnConsole
local FFlagSocialCarouselPressXToViewProfile = require(SocialCarouselParent.SharedFlags).FFlagSocialCarouselPressXToViewProfile
local FFlagSocialCarouselEnableUserSeenEvents = require(SocialCarousel.Flags.FFlagSocialCarouselEnableUserSeenEvents)
local FFlagEnableDesktopGameJoinCard = require(SocialCarouselParent.SharedFlags).FFlagEnableDesktopGameJoinCard
local FFlagEnableMobileGameJoinCard = require(SocialCarouselParent.SharedFlags).FFlagEnableMobileGameJoinCard
local FFlagEnableConsoleGameJoinCard = require(SocialCarouselParent.SharedFlags).FFlagEnableConsoleGameJoinCard
local FFlagMobileGameJoinCardTTITracking = require(SocialCarouselParent.SharedFlags).FFlagMobileGameJoinCardTTITracking
local v49 = game:DefineFastFlag("EnableFriendCarouselInGameFriendExposureLogging_v2", false)
local v50 = game:DefineFastString("SocialViewFriendSortInGameFriendsLayer", "Social.ViewFriendSortInGameFriends")

return function(t1: {[any]: any}) -- line: 108
	-- upvalues: React (copy), useDispatch (copy), useNavigation (copy), FFlagEnableMobileGameJoinCard (copy), FFlagEnableDesktopGameJoinCard (copy), FFlagSocialCarouselPressXToViewProfile (copy), usePreferredInput (copy), FFlagPPVEnabledOnConsole (copy), FFlagEnableConsoleGameJoinCard (copy), Responsive (copy), useSocialCarouselContext (copy), useSocialCarouselAnalytics (copy), useLocalization (copy), FFlagSocialCarouselUseProfileStore (copy), v17 (copy), Signals (copy), SignalsReact (copy), UserProfiles (copy), PlayerContextualMenu (copy), Tile (copy), Enums (copy), PresenceTypes (copy), v49 (copy), IXPService (copy), v50 (copy), FFlagMobileGameJoinCardTTITracking (copy), GameJoinCardTTI (copy), AppPage (copy), SetCentralOverlay (copy), CentralOverlayType (copy), Enums3 (copy), FFlagJoinGameCardPassThroughUniversePlaceInfoFromFriendsCarousel (copy), Enums2 (copy), FocusNavigationEventNameEnum (copy), Constants (copy), FFlagSocialCarouselEnableUserSeenEvents (copy), useGameJoinCardNavigation (copy), UserTile (copy), Cryo (copy), v40 (copy), View (copy), Foundation (copy), DesktopGameJoinCardContainer (copy), UserTileEventHandlers (copy)
	local v53 = React.useRef(nil)
	local v54 = useDispatch()
	local v55 = useNavigation()
	local v56 = if not FFlagEnableMobileGameJoinCard and (not FFlagEnableDesktopGameJoinCard and not FFlagSocialCarouselPressXToViewProfile) then nil else usePreferredInput()
	local u57 = false

	if not FFlagPPVEnabledOnConsole or FFlagEnableConsoleGameJoinCard then
		u57 = ((if not FFlagEnableMobileGameJoinCard and (not FFlagEnableDesktopGameJoinCard and not FFlagSocialCarouselPressXToViewProfile) then usePreferredInput() else v56)) == Responsive.Input.Directional
	end

	local v58 = not not FFlagSocialCarouselPressXToViewProfile and v56 == Responsive.Input.Directional
	local v59 = useSocialCarouselContext()
	local v60 = useSocialCarouselAnalytics()
	local v61 = useLocalization({
		suggestedLabel = "Feature.Friends.Label.Suggested"
	})
	local v62 = if not t1.item.presence then nil else {
		locationString = t1.item.presence.lastLocation,
		locationPlaceId = t1.item.presence.placeId,
		locationRootPlaceId = t1.item.presence.rootPlaceId,
		locationUniverseId = t1.item.presence.universeId,
		status = t1.item.presence.userPresenceType
	}
	local v63 = nil
	local u67, v68

	if FFlagSocialCarouselUseProfileStore then
		local v64 = React.useMemo(function() -- line: 152
			-- upvalues: v17 (copy), t1 (copy)
			return v17.fetchNamesByUserIds({ t1.item.id })
		end, { t1.item.id })
		local v65 = React.useMemo(function() -- line: 156
			-- upvalues: Signals (copy), v64 (copy)
			return Signals.createComputed(function(p1) -- line: 157
				-- upvalues: v64 (copy)
				local v101 = v64(p1)
				local v102 = v101 and (v101.data and v101.data[1])

				if v102 and v102.names then
					return (v102.names.getCombinedName(p1))
				end

				return nil
			end)
		end, { v64 })
		local v66 = React.useMemo(function() -- line: 164
			-- upvalues: Signals (copy), v64 (copy)
			return Signals.createComputed(function(p2) -- line: 165
				-- upvalues: v64 (copy)
				local v104 = v64(p2)
				local v105 = v104 and (v104.data and v104.data[1])

				if v105 and v105.names then
					return (v105.names.getPlatformName(p2))
				end

				return nil
			end)
		end, { v64 })

		u67 = SignalsReact.useSignalState(v65)
		v68 = SignalsReact.useSignalState(v66)

		if FFlagEnableConsoleGameJoinCard then
			local v69 = React.useMemo(function() -- line: 176
				-- upvalues: Signals (copy), v64 (copy)
				return Signals.createComputed(function(p3) -- line: 177
					-- upvalues: v64 (copy)
					local v107 = v64(p3)
					local v108 = v107 and (v107.data and v107.data[1])

					if v108 then
						return (v108.getPlatformProfileId(p3))
					end

					return nil
				end)
			end, { v64 })

			v63 = SignalsReact.useSignalState(v69)
		end
	else
		local v70 = UserProfiles.Hooks.useUserProfilesFetch({
			userIds = { t1.item.id },
			query = if not FFlagEnableConsoleGameJoinCard then UserProfiles.Queries.userProfilesCombinedAndPlatformByUserIds else UserProfiles.Queries.userProfilesDisplayUserPlatformNamesByUserIds
		})

		u67 = React.useMemo(function() -- line: 200
			-- upvalues: v70 (copy), UserProfiles (copy), t1 (copy)
			if not v70.data then
				return nil
			end

			return UserProfiles.Selectors.getCombinedNameFromId(v70.data, t1.item.id)
		end, { v70.data })
		v68 = React.useMemo(function() -- line: 208
			-- upvalues: v70 (copy), UserProfiles (copy), t1 (copy)
			if not v70.data then
				return nil
			end

			return UserProfiles.Selectors.getPlatformNameFromId(v70.data, t1.item.id)
		end, { v70.data })

		if FFlagEnableConsoleGameJoinCard then
			v63 = React.useMemo(function() -- line: 217
				-- upvalues: v70 (copy), UserProfiles (copy), t1 (copy)
				if not v70.data then
					return nil
				end

				return UserProfiles.Selectors.getPlatformProfileIdFromId(v70.data, t1.item.id)
			end, {
				v70.data,
				t1.item.id
			})
		end
	end

	local u71 = nil
	local u72 = nil

	if FFlagEnableDesktopGameJoinCard or FFlagEnableConsoleGameJoinCard then
		local v73, v74 = React.useState(false)

		u71 = v73
		u72 = v74

		local setOpenGameJoinCardUserId = v59.setOpenGameJoinCardUserId

		if setOpenGameJoinCardUserId then
			u71 = v59.openGameJoinCardUserId == t1.item.id

			function u72(p4) -- line: 234
				-- upvalues: setOpenGameJoinCardUserId (copy), t1 (copy)
				if p4 then
					setOpenGameJoinCardUserId(t1.item.id)

					return
				end

				setOpenGameJoinCardUserId(function(s1: string?) -- line: 238
					-- upvalues: t1 (copy)
					if s1 == t1.item.id then
						return nil
					end

					return s1
				end)
			end
		end
	end

	local v76 = React.useCallback(function(p5) -- line: 249
		-- upvalues: t1 (copy), FFlagPPVEnabledOnConsole (copy), u57 (ref), v54 (copy), PlayerContextualMenu (copy), v62 (copy), Tile (copy), Enums (copy), PresenceTypes (copy), v49 (copy), IXPService (copy), v50 (copy), FFlagEnableMobileGameJoinCard (copy), v56 (copy), Responsive (copy), FFlagMobileGameJoinCardTTITracking (copy), GameJoinCardTTI (copy), v55 (copy), AppPage (copy), FFlagEnableDesktopGameJoinCard (copy), u72 (ref), u71 (ref), SetCentralOverlay (copy), CentralOverlayType (copy), u67 (ref), Enums3 (copy), FFlagJoinGameCardPassThroughUniversePlaceInfoFromFriendsCarousel (copy), Enums2 (copy), v60 (copy)
		if t1.item.onActivated then
			t1.item.onActivated(t1.item)
		elseif not FFlagPPVEnabledOnConsole and u57 then
			local v95 = v54
			local openPlayerContextualMenu = PlayerContextualMenu.openPlayerContextualMenu
			local t2 = {
				subjectUserId = t1.item.id,
				subjectPresence = v62
			}
			local item = t1.item

			t2.robloxFriendshipStatus = if item.tileType == Tile.Recommendation then if not item.isFriendWithUser then if not item.hasIncomingFriendRequest then if not item.hasPendingFriendRequest then Enum.FriendStatus.NotFriend else Enum.FriendStatus.FriendRequestSent else Enum.FriendStatus.FriendRequestReceived else Enum.FriendStatus.Friend else Enum.FriendStatus.Friend
			t2.friendshipOriginSourceType = Enums.FriendshipOriginSourceType.FriendRecommendations.rawValue()
			v95(openPlayerContextualMenu(t2))
		elseif t1.item.presence and t1.item.presence.userPresenceType == PresenceTypes.InGame then
			if v49 then
				IXPService:LogFlagLinkedUserLayerExposure(v50)
			end

			if FFlagEnableMobileGameJoinCard and v56 == Responsive.Input.Touch then
				if FFlagMobileGameJoinCardTTITracking then
					GameJoinCardTTI.trackMobileCardClickStart()
				end

				v55.navigate(AppPage.GameJoinCard, {
					userId = t1.item.id,
					homepageCarouselAbsolutePosition = t1.index
				})
			elseif FFlagEnableDesktopGameJoinCard then
				u72(not u71)
			else
				if FFlagMobileGameJoinCardTTITracking then
					GameJoinCardTTI.trackPeopleListClickStart()
				end

				v54(SetCentralOverlay(CentralOverlayType.PeopleList, {
					user = {
						id = t1.item.id,
						combinedName = u67,
						presence = Enums3.OldPresence.IN_GAME,
						universeId = t1.item.presence.universeId,
						rootPlaceId = if not FFlagJoinGameCardPassThroughUniversePlaceInfoFromFriendsCarousel then nil else t1.item.presence.rootPlaceId,
						placeId = if not FFlagJoinGameCardPassThroughUniversePlaceInfoFromFriendsCarousel then nil else t1.item.presence.placeId,
						gameInstanceId = t1.item.presence.gameId,
						lastLocation = t1.item.presence.lastLocation
					},
					positionIndex = t1.index,
					absolutePosition = t1.index,
					anchorSpaceSize = p5.AbsoluteSize,
					anchorSpacePosition = p5.AbsolutePosition,
					source = Enums2.Sources.HomePageFriendsCarousel
				}))
			end
		else
			v55.navigate(AppPage.ProfilePlatform, {
				detail = t1.item.id,
				extraProps = {
					source = Enums2.Sources.HomePageFriendsCarousel
				}
			})
		end

		v60.userPressed(t1.item, {
			absolutePosition = t1.index
		})
	end, {
		t1.item,
		u71
	})
	local v77 = React.useMemo(function() -- line: 317
		-- upvalues: t1 (copy), Tile (copy), v61 (copy), PresenceTypes (copy)
		if t1.item.tileType == Tile.Recommendation then
			return v61.suggestedLabel
		end

		if t1.item.presence and t1.item.presence.userPresenceType == PresenceTypes.InGame then
			return t1.item.presence.lastLocation
		end

		return nil
	end, { t1.item })
	local v78 = nil
	local u79 = nil

	if FFlagEnableDesktopGameJoinCard or v49 then
		local v80

		v78, v80 = React.useState(nil)
		u79 = v80
	end

	local v81 = if not FFlagSocialCarouselPressXToViewProfile then nil else React.useRef(nil)
	local v82 = if not FFlagSocialCarouselPressXToViewProfile then nil else React.useCallback(function() -- line: 334
		-- upvalues: v55 (copy), AppPage (copy), t1 (copy), Enums2 (copy), v60 (copy)
		v55.navigate(AppPage.ProfilePlatform, {
			detail = t1.item.id,
			extraProps = {
				source = Enums2.Sources.HomePageFriendsCarousel
			}
		})
		v60.userPressed(t1.item, {
			absolutePosition = t1.index
		})
	end, {
		t1.item,
		t1.index,
		v55.navigate,
		v60.userPressed
	})
	local v83 = if not FFlagSocialCarouselPressXToViewProfile then nil else React.useMemo(function() -- line: 348
		-- upvalues: v82 (copy), FocusNavigationEventNameEnum (copy)
		return {
			{
				onActivated = v82,
				focusEventName = FocusNavigationEventNameEnum.ViewProfile
			},
			{
				onActivated = function() -- line: 354
				end
			}
		}
	end, { v82 })
	local v84 = if not FFlagSocialCarouselPressXToViewProfile then nil else React.useCallback(function(p6) -- line: 360
		-- upvalues: v81 (copy), u79 (ref)
		v81.current = p6

		if u79 then
			u79(p6)
		end
	end, { u79 })

	React.useEffect(function() -- line: 368
		-- upvalues: v59 (copy), v53 (copy), t1 (copy)
		if v59.unifiedLogging then
			v59.unifiedLogging.tagTileForImpressions(v53, t1.index)
		end
	end, { t1.index })
	React.useEffect(function() -- line: 374
		-- upvalues: v59 (copy), Constants (copy), FFlagSocialCarouselEnableUserSeenEvents (copy), v60 (copy), t1 (copy)
		v59.onSuccessfulRender(Constants.ANALYTICS.UI_LOADING_EVENTS.CAROUSEL_FRIEND)

		if FFlagSocialCarouselEnableUserSeenEvents then
			v60.userSeen(t1.item, {
				absolutePosition = t1.index
			})
		end
	end, {})
	React.useEffect(function() -- line: 383
		-- upvalues: t1 (copy)
		if t1.onTileContentChanged then
			t1.onTileContentChanged(t1.item.id, t1.index)
		end
	end, {
		t1.item.id,
		t1.index
	})

	if FFlagEnableDesktopGameJoinCard or v49 then
		local v85 = React.useCallback(function() -- line: 390
			-- upvalues: u72 (ref)
			if u72 then
				u72(false)
			end
		end, {})
		local v86 = false

		if FFlagEnableConsoleGameJoinCard then
			v86 = useGameJoinCardNavigation(v78, u57, v53)
		end

		local presence = t1.item.presence
		local v88 = presence and presence.userPresenceType == PresenceTypes.InGame
		local v89 = (u71 or v86) and (v88 and v62 ~= nil)
		local v90 = FFlagEnableConsoleGameJoinCard and (v88 and (u57 and v89))

		React.useEffect(function() -- line: 406
			-- upvalues: v49 (copy), v89 (copy), IXPService (copy), v50 (copy)
			if v49 and v89 then
				IXPService:LogFlagLinkedUserLayerExposure(v50)
			end
		end, { v89 })

		local v91 = React.createElement(UserTile, Cryo.Dictionary.join(t1, {
			itemSize = UDim2.fromScale(1, 1),
			onActivated = v76,
			name = if t1.item.tileType ~= Tile.Recommendation then u67 else v68,
			contextualText = v77,
			tileRef = v53,
			titleIcon = if t1.item.tileType ~= Tile.Recommendation then nil else v40
		}))

		return React.createElement(View, {
			BackgroundTransparency = 1,
			Size = t1.itemSize,
			LayoutOrder = t1.index,
			ref = v53,
			stateLayer = {
				affordance = Foundation.Enums.StateLayerAffordance.None
			}
		}, {
			UserTile = v91,
			GameJoinCardPopover = if not FFlagEnableDesktopGameJoinCard or (not v62 or not presence) then nil else React.createElement(DesktopGameJoinCardContainer, {
				layoutOrder = 1,
				playerName = u67 or "",
				platformName = v68 or "",
				platformProfileId = if not FFlagEnableConsoleGameJoinCard then nil else v63,
				universeId = tostring(presence.universeId),
				experienceName = presence.lastLocation,
				userId = t1.item.id,
				presence = presence,
				anchorRef = v53,
				isOpen = v89 == true,
				onClose = v85,
				homepageCarouselAbsolutePosition = t1.index,
				showGamepadJoinFocus = v90 == true,
				onCardGuiObjectChanged = if not FFlagSocialCarouselPressXToViewProfile then u79 else v84,
				isFocused = v86
			}),
			TileEventHandlers = if not FFlagSocialCarouselPressXToViewProfile then nil else React.createElement(UserTileEventHandlers, {
				tileRef = v53,
				buttons = if not v58 then nil else v83,
				onTileActivated = function() -- line: 460
				end
			}),
			CardEventHandlers = if not FFlagSocialCarouselPressXToViewProfile or (not v58 or not v78) then nil else React.createElement(UserTileEventHandlers, {
				tileRef = v81,
				buttons = v83,
				onTileActivated = function() -- line: 469
				end
			})
		})
	end

	local v92 = React.createElement(UserTile, Cryo.Dictionary.join(t1, {
		onActivated = v76,
		name = if t1.item.tileType ~= Tile.Recommendation then u67 else v68,
		contextualText = v77,
		tileRef = v53,
		titleIcon = if t1.item.tileType ~= Tile.Recommendation then nil else v40
	}))

	if FFlagSocialCarouselPressXToViewProfile then
		return React.createElement(React.Fragment, nil, {
			UserTile = v92,
			TileEventHandlers = React.createElement(UserTileEventHandlers, {
				tileRef = v53,
				buttons = if not v58 then nil else v83,
				onTileActivated = function() -- line: 492
				end
			})
		})
	end

	return v92
end
