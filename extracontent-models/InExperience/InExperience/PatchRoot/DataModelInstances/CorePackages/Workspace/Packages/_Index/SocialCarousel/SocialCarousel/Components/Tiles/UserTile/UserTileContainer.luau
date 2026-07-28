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
local FFlagEnableSplitPane = require(SocialCarouselParent.SharedFlags).FFlagEnableSplitPane
local FFlagSocialCarouselEnableUserSeenEvents = require(SocialCarousel.Flags.FFlagSocialCarouselEnableUserSeenEvents)
local FFlagSocialCarouselFixConsoleCtaForInGame = require(SocialCarousel.Flags.FFlagSocialCarouselFixConsoleCtaForInGame)
local FFlagEnableDesktopGameJoinCard = require(SocialCarouselParent.SharedFlags).FFlagEnableDesktopGameJoinCard
local FFlagEnableMobileGameJoinCard = require(SocialCarouselParent.SharedFlags).FFlagEnableMobileGameJoinCard
local FFlagEnableConsoleGameJoinCard = require(SocialCarouselParent.SharedFlags).FFlagEnableConsoleGameJoinCard
local FFlagMobileGameJoinCardTTITracking = require(SocialCarouselParent.SharedFlags).FFlagMobileGameJoinCardTTITracking
local v51 = game:DefineFastFlag("EnableFriendCarouselInGameFriendExposureLogging_v2", false)
local v52 = game:DefineFastString("SocialViewFriendSortInGameFriendsLayer", "Social.ViewFriendSortInGameFriends")

return function(t1: {[any]: any}) -- line: 111
	-- upvalues: React (copy), useDispatch (copy), useNavigation (copy), FFlagEnableMobileGameJoinCard (copy), FFlagEnableDesktopGameJoinCard (copy), FFlagSocialCarouselPressXToViewProfile (copy), usePreferredInput (copy), FFlagSocialCarouselFixConsoleCtaForInGame (copy), FFlagPPVEnabledOnConsole (copy), FFlagEnableConsoleGameJoinCard (copy), Responsive (copy), useSocialCarouselContext (copy), useSocialCarouselAnalytics (copy), useLocalization (copy), FFlagSocialCarouselUseProfileStore (copy), v17 (copy), Signals (copy), SignalsReact (copy), UserProfiles (copy), PresenceTypes (copy), PlayerContextualMenu (copy), Tile (copy), Enums (copy), v51 (copy), IXPService (copy), v52 (copy), FFlagMobileGameJoinCardTTITracking (copy), GameJoinCardTTI (copy), AppPage (copy), SetCentralOverlay (copy), CentralOverlayType (copy), Enums3 (copy), FFlagJoinGameCardPassThroughUniversePlaceInfoFromFriendsCarousel (copy), Enums2 (copy), FFlagEnableSplitPane (copy), FocusNavigationEventNameEnum (copy), Constants (copy), FFlagSocialCarouselEnableUserSeenEvents (copy), useGameJoinCardNavigation (copy), UserTile (copy), Cryo (copy), v40 (copy), View (copy), Foundation (copy), DesktopGameJoinCardContainer (copy), UserTileEventHandlers (copy)
	local v55 = React.useRef(nil)
	local v56 = useDispatch()
	local v57 = useNavigation()
	local v58 = if not FFlagEnableMobileGameJoinCard and (not FFlagEnableDesktopGameJoinCard and not FFlagSocialCarouselPressXToViewProfile) then nil else usePreferredInput()
	local u59 = false

	if FFlagSocialCarouselFixConsoleCtaForInGame or (not FFlagPPVEnabledOnConsole or FFlagEnableConsoleGameJoinCard) then
		u59 = ((if not FFlagEnableMobileGameJoinCard and (not FFlagEnableDesktopGameJoinCard and not FFlagSocialCarouselPressXToViewProfile) then usePreferredInput() else v58)) == Responsive.Input.Directional
	end

	local v60 = not not FFlagSocialCarouselPressXToViewProfile and v58 == Responsive.Input.Directional
	local v61 = useSocialCarouselContext()
	local v62 = useSocialCarouselAnalytics()
	local v63 = useLocalization({
		suggestedLabel = "Feature.Friends.Label.Suggested"
	})
	local v64 = if not t1.item.presence then nil else {
		locationString = t1.item.presence.lastLocation,
		locationPlaceId = t1.item.presence.placeId,
		locationRootPlaceId = t1.item.presence.rootPlaceId,
		locationUniverseId = t1.item.presence.universeId,
		status = t1.item.presence.userPresenceType
	}
	local v65 = nil
	local u69, v70

	if FFlagSocialCarouselUseProfileStore then
		local v66 = React.useMemo(function() -- line: 155
			-- upvalues: v17 (copy), t1 (copy)
			return v17.fetchNamesByUserIds({ t1.item.id })
		end, { t1.item.id })
		local v67 = React.useMemo(function() -- line: 159
			-- upvalues: Signals (copy), v66 (copy)
			return Signals.createComputed(function(p1) -- line: 160
				-- upvalues: v66 (copy)
				local v105 = v66(p1)
				local v106 = v105 and (v105.data and v105.data[1])

				if v106 and v106.names then
					return (v106.names.getCombinedName(p1))
				end

				return nil
			end)
		end, { v66 })
		local v68 = React.useMemo(function() -- line: 167
			-- upvalues: Signals (copy), v66 (copy)
			return Signals.createComputed(function(p2) -- line: 168
				-- upvalues: v66 (copy)
				local v108 = v66(p2)
				local v109 = v108 and (v108.data and v108.data[1])

				if v109 and v109.names then
					return (v109.names.getPlatformName(p2))
				end

				return nil
			end)
		end, { v66 })

		u69 = SignalsReact.useSignalState(v67)
		v70 = SignalsReact.useSignalState(v68)

		if FFlagEnableConsoleGameJoinCard then
			local v71 = React.useMemo(function() -- line: 179
				-- upvalues: Signals (copy), v66 (copy)
				return Signals.createComputed(function(p3) -- line: 180
					-- upvalues: v66 (copy)
					local v111 = v66(p3)
					local v112 = v111 and (v111.data and v111.data[1])

					if v112 then
						return (v112.getPlatformProfileId(p3))
					end

					return nil
				end)
			end, { v66 })

			v65 = SignalsReact.useSignalState(v71)
		end
	else
		local v72 = UserProfiles.Hooks.useUserProfilesFetch({
			userIds = { t1.item.id },
			query = if not FFlagEnableConsoleGameJoinCard then UserProfiles.Queries.userProfilesCombinedAndPlatformByUserIds else UserProfiles.Queries.userProfilesDisplayUserPlatformNamesByUserIds
		})

		u69 = React.useMemo(function() -- line: 203
			-- upvalues: v72 (copy), UserProfiles (copy), t1 (copy)
			if not v72.data then
				return nil
			end

			return UserProfiles.Selectors.getCombinedNameFromId(v72.data, t1.item.id)
		end, { v72.data })
		v70 = React.useMemo(function() -- line: 211
			-- upvalues: v72 (copy), UserProfiles (copy), t1 (copy)
			if not v72.data then
				return nil
			end

			return UserProfiles.Selectors.getPlatformNameFromId(v72.data, t1.item.id)
		end, { v72.data })

		if FFlagEnableConsoleGameJoinCard then
			v65 = React.useMemo(function() -- line: 220
				-- upvalues: v72 (copy), UserProfiles (copy), t1 (copy)
				if not v72.data then
					return nil
				end

				return UserProfiles.Selectors.getPlatformProfileIdFromId(v72.data, t1.item.id)
			end, {
				v72.data,
				t1.item.id
			})
		end
	end

	local u73 = nil
	local u74 = nil

	if FFlagEnableDesktopGameJoinCard or FFlagEnableConsoleGameJoinCard then
		local v75, v76 = React.useState(false)

		u73 = v75
		u74 = v76

		local setOpenGameJoinCardUserId = v61.setOpenGameJoinCardUserId

		if setOpenGameJoinCardUserId then
			u73 = v61.openGameJoinCardUserId == t1.item.id

			function u74(p4) -- line: 237
				-- upvalues: setOpenGameJoinCardUserId (copy), t1 (copy)
				if p4 then
					setOpenGameJoinCardUserId(t1.item.id)

					return
				end

				setOpenGameJoinCardUserId(function(s1: string?) -- line: 241
					-- upvalues: t1 (copy)
					if s1 == t1.item.id then
						return nil
					end

					return s1
				end)
			end
		end
	end

	local v78 = React.useCallback(function(p5) -- line: 252
		-- upvalues: t1 (copy), FFlagSocialCarouselFixConsoleCtaForInGame (copy), PresenceTypes (copy), u59 (ref), FFlagPPVEnabledOnConsole (copy), v56 (copy), PlayerContextualMenu (copy), v64 (copy), Tile (copy), Enums (copy), v51 (copy), IXPService (copy), v52 (copy), FFlagEnableMobileGameJoinCard (copy), v58 (copy), Responsive (copy), FFlagMobileGameJoinCardTTITracking (copy), GameJoinCardTTI (copy), v57 (copy), AppPage (copy), FFlagEnableDesktopGameJoinCard (copy), u74 (ref), u73 (ref), SetCentralOverlay (copy), CentralOverlayType (copy), u69 (ref), Enums3 (copy), FFlagJoinGameCardPassThroughUniversePlaceInfoFromFriendsCarousel (copy), Enums2 (copy), FFlagEnableSplitPane (copy), v62 (copy)
		if t1.item.onActivated then
			t1.item.onActivated(t1.item)
		else
			local v98

			if FFlagSocialCarouselFixConsoleCtaForInGame then
				local v97 = t1.item.presence ~= nil and t1.item.presence.userPresenceType == PresenceTypes.InGame

				v98 = u59 and (not FFlagPPVEnabledOnConsole or v97)
			else
				v98 = not FFlagPPVEnabledOnConsole and u59
			end

			if v98 then
				local v99 = v56
				local openPlayerContextualMenu = PlayerContextualMenu.openPlayerContextualMenu
				local t2 = {
					subjectUserId = t1.item.id,
					subjectPresence = v64
				}
				local item = t1.item

				t2.robloxFriendshipStatus = if item.tileType == Tile.Recommendation then if not item.isFriendWithUser then if not item.hasIncomingFriendRequest then if not item.hasPendingFriendRequest then Enum.FriendStatus.NotFriend else Enum.FriendStatus.FriendRequestSent else Enum.FriendStatus.FriendRequestReceived else Enum.FriendStatus.Friend else Enum.FriendStatus.Friend
				t2.friendshipOriginSourceType = Enums.FriendshipOriginSourceType.FriendRecommendations.rawValue()
				v99(openPlayerContextualMenu(t2))
			elseif t1.item.presence and t1.item.presence.userPresenceType == PresenceTypes.InGame then
				if v51 then
					IXPService:LogFlagLinkedUserLayerExposure(v52)
				end

				if FFlagEnableMobileGameJoinCard and v58 == Responsive.Input.Touch then
					if FFlagMobileGameJoinCardTTITracking then
						GameJoinCardTTI.trackMobileCardClickStart()
					end

					v57.navigate(AppPage.GameJoinCard, {
						userId = t1.item.id,
						homepageCarouselAbsolutePosition = t1.index
					})
				elseif FFlagEnableDesktopGameJoinCard then
					u74(not u73)
				else
					if FFlagMobileGameJoinCardTTITracking then
						GameJoinCardTTI.trackPeopleListClickStart()
					end

					v56(SetCentralOverlay(CentralOverlayType.PeopleList, {
						user = {
							id = t1.item.id,
							combinedName = u69,
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
				((if not FFlagEnableSplitPane then v57.navigate else v57.push))(AppPage.ProfilePlatform, {
					detail = t1.item.id,
					extraProps = {
						source = Enums2.Sources.HomePageFriendsCarousel
					}
				})
			end
		end

		v62.userPressed(t1.item, {
			absolutePosition = t1.index
		})
	end, {
		t1.item,
		u73
	})
	local v79 = React.useMemo(function() -- line: 329
		-- upvalues: t1 (copy), Tile (copy), v63 (copy), PresenceTypes (copy)
		if t1.item.tileType == Tile.Recommendation then
			return v63.suggestedLabel
		end

		if t1.item.presence and t1.item.presence.userPresenceType == PresenceTypes.InGame then
			return t1.item.presence.lastLocation
		end

		return nil
	end, { t1.item })
	local v80 = nil
	local u81 = nil

	if FFlagEnableDesktopGameJoinCard or v51 then
		local v82

		v80, v82 = React.useState(nil)
		u81 = v82
	end

	local v83 = if not FFlagSocialCarouselPressXToViewProfile then nil else React.useRef(nil)
	local v84 = if not FFlagSocialCarouselPressXToViewProfile then nil else React.useCallback(function() -- line: 347
		-- upvalues: FFlagEnableSplitPane (copy), v57 (copy), AppPage (copy), t1 (copy), Enums2 (copy), v62 (copy);
		((if not FFlagEnableSplitPane then v57.navigate else v57.push))(AppPage.ProfilePlatform, {
			detail = t1.item.id,
			extraProps = {
				source = Enums2.Sources.HomePageFriendsCarousel
			}
		})
		v62.userPressed(t1.item, {
			absolutePosition = t1.index
		})
	end, {
		t1.item,
		t1.index,
		v57.navigate,
		v57.push,
		v62.userPressed
	})
	local v85 = if not FFlagSocialCarouselPressXToViewProfile then nil else React.useMemo(function() -- line: 364
		-- upvalues: v84 (copy), FocusNavigationEventNameEnum (copy)
		return {
			{
				onActivated = v84,
				focusEventName = FocusNavigationEventNameEnum.ViewProfile
			},
			{
				onActivated = function() -- line: 370
				end
			}
		}
	end, { v84 })
	local v86 = if not FFlagSocialCarouselPressXToViewProfile then nil else React.useCallback(function(p6) -- line: 376
		-- upvalues: v83 (copy), u81 (ref)
		v83.current = p6

		if u81 then
			u81(p6)
		end
	end, { u81 })

	React.useEffect(function() -- line: 384
		-- upvalues: v61 (copy), v55 (copy), t1 (copy)
		if v61.unifiedLogging then
			v61.unifiedLogging.tagTileForImpressions(v55, t1.index)
		end
	end, { t1.index })
	React.useEffect(function() -- line: 390
		-- upvalues: v61 (copy), Constants (copy), FFlagSocialCarouselEnableUserSeenEvents (copy), v62 (copy), t1 (copy)
		v61.onSuccessfulRender(Constants.ANALYTICS.UI_LOADING_EVENTS.CAROUSEL_FRIEND)

		if FFlagSocialCarouselEnableUserSeenEvents then
			v62.userSeen(t1.item, {
				absolutePosition = t1.index
			})
		end
	end, {})
	React.useEffect(function() -- line: 399
		-- upvalues: t1 (copy)
		if t1.onTileContentChanged then
			t1.onTileContentChanged(t1.item.id, t1.index)
		end
	end, {
		t1.item.id,
		t1.index
	})

	if FFlagEnableDesktopGameJoinCard or v51 then
		local v87 = React.useCallback(function() -- line: 406
			-- upvalues: u74 (ref)
			if u74 then
				u74(false)
			end
		end, {})
		local v88 = false

		if FFlagEnableConsoleGameJoinCard then
			v88 = useGameJoinCardNavigation(v80, u59, v55)
		end

		local presence = t1.item.presence
		local v90 = presence and presence.userPresenceType == PresenceTypes.InGame
		local v91 = (u73 or v88) and (v90 and v64 ~= nil)
		local v92 = FFlagEnableConsoleGameJoinCard and (v90 and (u59 and v91))

		React.useEffect(function() -- line: 422
			-- upvalues: v51 (copy), v91 (copy), IXPService (copy), v52 (copy)
			if v51 and v91 then
				IXPService:LogFlagLinkedUserLayerExposure(v52)
			end
		end, { v91 })

		local v93 = React.createElement(UserTile, Cryo.Dictionary.join(t1, {
			itemSize = UDim2.fromScale(1, 1),
			onActivated = v78,
			name = if t1.item.tileType ~= Tile.Recommendation then u69 else v70,
			contextualText = v79,
			tileRef = v55,
			titleIcon = if t1.item.tileType ~= Tile.Recommendation then nil else v40
		}))

		return React.createElement(View, {
			BackgroundTransparency = 1,
			Size = t1.itemSize,
			LayoutOrder = t1.index,
			ref = v55,
			stateLayer = {
				affordance = Foundation.Enums.StateLayerAffordance.None
			}
		}, {
			UserTile = v93,
			GameJoinCardPopover = if not FFlagEnableDesktopGameJoinCard or (not v64 or not presence) then nil else React.createElement(DesktopGameJoinCardContainer, {
				layoutOrder = 1,
				playerName = u69 or "",
				platformName = v70 or "",
				platformProfileId = if not FFlagEnableConsoleGameJoinCard then nil else v65,
				universeId = tostring(presence.universeId),
				experienceName = presence.lastLocation,
				userId = t1.item.id,
				presence = presence,
				anchorRef = v55,
				isOpen = v91 == true,
				onClose = v87,
				homepageCarouselAbsolutePosition = t1.index,
				showGamepadJoinFocus = v92 == true,
				onCardGuiObjectChanged = if not FFlagSocialCarouselPressXToViewProfile then u81 else v86,
				isFocused = v88
			}),
			TileEventHandlers = if not FFlagSocialCarouselPressXToViewProfile then nil else React.createElement(UserTileEventHandlers, {
				tileRef = v55,
				buttons = if not v60 then nil else v85,
				onTileActivated = function() -- line: 476
				end
			}),
			CardEventHandlers = if not FFlagSocialCarouselPressXToViewProfile or (not v60 or not v80) then nil else React.createElement(UserTileEventHandlers, {
				tileRef = v83,
				buttons = v85,
				onTileActivated = function() -- line: 485
				end
			})
		})
	end

	local v94 = React.createElement(UserTile, Cryo.Dictionary.join(t1, {
		onActivated = v78,
		name = if t1.item.tileType ~= Tile.Recommendation then u69 else v70,
		contextualText = v79,
		tileRef = v55,
		titleIcon = if t1.item.tileType ~= Tile.Recommendation then nil else v40
	}))

	if FFlagSocialCarouselPressXToViewProfile then
		return React.createElement(React.Fragment, nil, {
			UserTile = v94,
			TileEventHandlers = React.createElement(UserTileEventHandlers, {
				tileRef = v55,
				buttons = if not v60 then nil else v85,
				onTileActivated = function() -- line: 508
				end
			})
		})
	end

	return v94
end
