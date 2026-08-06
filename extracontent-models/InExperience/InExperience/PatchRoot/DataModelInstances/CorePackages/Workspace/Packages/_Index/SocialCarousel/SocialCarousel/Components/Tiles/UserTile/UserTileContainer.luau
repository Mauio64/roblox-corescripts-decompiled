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
local FFlagDeprecatePeopleListContextualMenu = require(SocialCarouselParent.SharedFlags).FFlagDeprecatePeopleListContextualMenu
local v52 = game:DefineFastFlag("EnableFriendCarouselInGameFriendExposureLogging_v2", false)
local v53 = game:DefineFastString("SocialViewFriendSortInGameFriendsLayer", "Social.ViewFriendSortInGameFriends")

return function(t1: {[any]: any}) -- line: 112
	-- upvalues: React (copy), useDispatch (copy), useNavigation (copy), FFlagEnableMobileGameJoinCard (copy), FFlagEnableDesktopGameJoinCard (copy), FFlagSocialCarouselPressXToViewProfile (copy), usePreferredInput (copy), FFlagSocialCarouselFixConsoleCtaForInGame (copy), FFlagPPVEnabledOnConsole (copy), FFlagEnableConsoleGameJoinCard (copy), Responsive (copy), useSocialCarouselContext (copy), useSocialCarouselAnalytics (copy), useLocalization (copy), FFlagSocialCarouselUseProfileStore (copy), v17 (copy), Signals (copy), SignalsReact (copy), UserProfiles (copy), PresenceTypes (copy), PlayerContextualMenu (copy), Tile (copy), Enums (copy), v52 (copy), IXPService (copy), v53 (copy), FFlagMobileGameJoinCardTTITracking (copy), GameJoinCardTTI (copy), AppPage (copy), FFlagDeprecatePeopleListContextualMenu (copy), SetCentralOverlay (copy), CentralOverlayType (copy), Enums3 (copy), FFlagJoinGameCardPassThroughUniversePlaceInfoFromFriendsCarousel (copy), Enums2 (copy), FFlagEnableSplitPane (copy), FocusNavigationEventNameEnum (copy), Constants (copy), FFlagSocialCarouselEnableUserSeenEvents (copy), useGameJoinCardNavigation (copy), UserTile (copy), Cryo (copy), v40 (copy), View (copy), Foundation (copy), DesktopGameJoinCardContainer (copy), UserTileEventHandlers (copy)
	local v56 = React.useRef(nil)
	local v57 = useDispatch()
	local v58 = useNavigation()
	local v59 = if not FFlagEnableMobileGameJoinCard and (not FFlagEnableDesktopGameJoinCard and not FFlagSocialCarouselPressXToViewProfile) then nil else usePreferredInput()
	local u60 = false

	if FFlagSocialCarouselFixConsoleCtaForInGame or (not FFlagPPVEnabledOnConsole or FFlagEnableConsoleGameJoinCard) then
		u60 = ((if not FFlagEnableMobileGameJoinCard and (not FFlagEnableDesktopGameJoinCard and not FFlagSocialCarouselPressXToViewProfile) then usePreferredInput() else v59)) == Responsive.Input.Directional
	end

	local v61 = not not FFlagSocialCarouselPressXToViewProfile and v59 == Responsive.Input.Directional
	local v62 = useSocialCarouselContext()
	local v63 = useSocialCarouselAnalytics()
	local v64 = useLocalization({
		suggestedLabel = "Feature.Friends.Label.Suggested"
	})
	local v65 = if not t1.item.presence then nil else {
		locationString = t1.item.presence.lastLocation,
		locationPlaceId = t1.item.presence.placeId,
		locationRootPlaceId = t1.item.presence.rootPlaceId,
		locationUniverseId = t1.item.presence.universeId,
		status = t1.item.presence.userPresenceType
	}
	local v66 = nil
	local u70, v71

	if FFlagSocialCarouselUseProfileStore then
		local v67 = React.useMemo(function() -- line: 156
			-- upvalues: v17 (copy), t1 (copy)
			return v17.fetchNamesByUserIds({ t1.item.id })
		end, { t1.item.id })
		local v68 = React.useMemo(function() -- line: 160
			-- upvalues: Signals (copy), v67 (copy)
			return Signals.createComputed(function(p1) -- line: 161
				-- upvalues: v67 (copy)
				local v106 = v67(p1)
				local v107 = v106 and (v106.data and v106.data[1])

				if v107 and v107.names then
					return (v107.names.getCombinedName(p1))
				end

				return nil
			end)
		end, { v67 })
		local v69 = React.useMemo(function() -- line: 168
			-- upvalues: Signals (copy), v67 (copy)
			return Signals.createComputed(function(p2) -- line: 169
				-- upvalues: v67 (copy)
				local v109 = v67(p2)
				local v110 = v109 and (v109.data and v109.data[1])

				if v110 and v110.names then
					return (v110.names.getPlatformName(p2))
				end

				return nil
			end)
		end, { v67 })

		u70 = SignalsReact.useSignalState(v68)
		v71 = SignalsReact.useSignalState(v69)

		if FFlagEnableConsoleGameJoinCard then
			local v72 = React.useMemo(function() -- line: 180
				-- upvalues: Signals (copy), v67 (copy)
				return Signals.createComputed(function(p3) -- line: 181
					-- upvalues: v67 (copy)
					local v112 = v67(p3)
					local v113 = v112 and (v112.data and v112.data[1])

					if v113 then
						return (v113.getPlatformProfileId(p3))
					end

					return nil
				end)
			end, { v67 })

			v66 = SignalsReact.useSignalState(v72)
		end
	else
		local v73 = UserProfiles.Hooks.useUserProfilesFetch({
			userIds = { t1.item.id },
			query = if not FFlagEnableConsoleGameJoinCard then UserProfiles.Queries.userProfilesCombinedAndPlatformByUserIds else UserProfiles.Queries.userProfilesDisplayUserPlatformNamesByUserIds
		})

		u70 = React.useMemo(function() -- line: 204
			-- upvalues: v73 (copy), UserProfiles (copy), t1 (copy)
			if not v73.data then
				return nil
			end

			return UserProfiles.Selectors.getCombinedNameFromId(v73.data, t1.item.id)
		end, { v73.data })
		v71 = React.useMemo(function() -- line: 212
			-- upvalues: v73 (copy), UserProfiles (copy), t1 (copy)
			if not v73.data then
				return nil
			end

			return UserProfiles.Selectors.getPlatformNameFromId(v73.data, t1.item.id)
		end, { v73.data })

		if FFlagEnableConsoleGameJoinCard then
			v66 = React.useMemo(function() -- line: 221
				-- upvalues: v73 (copy), UserProfiles (copy), t1 (copy)
				if not v73.data then
					return nil
				end

				return UserProfiles.Selectors.getPlatformProfileIdFromId(v73.data, t1.item.id)
			end, {
				v73.data,
				t1.item.id
			})
		end
	end

	local u74 = nil
	local u75 = nil

	if FFlagEnableDesktopGameJoinCard or FFlagEnableConsoleGameJoinCard then
		local v76, v77 = React.useState(false)

		u74 = v76
		u75 = v77

		local setOpenGameJoinCardUserId = v62.setOpenGameJoinCardUserId

		if setOpenGameJoinCardUserId then
			u74 = v62.openGameJoinCardUserId == t1.item.id

			function u75(p4) -- line: 238
				-- upvalues: setOpenGameJoinCardUserId (copy), t1 (copy)
				if p4 then
					setOpenGameJoinCardUserId(t1.item.id)

					return
				end

				setOpenGameJoinCardUserId(function(s1: string?) -- line: 242
					-- upvalues: t1 (copy)
					if s1 == t1.item.id then
						return nil
					end

					return s1
				end)
			end
		end
	end

	local v79 = React.useCallback(function(p5) -- line: 253
		-- upvalues: t1 (copy), FFlagSocialCarouselFixConsoleCtaForInGame (copy), PresenceTypes (copy), u60 (ref), FFlagPPVEnabledOnConsole (copy), v57 (copy), PlayerContextualMenu (copy), v65 (copy), Tile (copy), Enums (copy), v52 (copy), IXPService (copy), v53 (copy), FFlagEnableMobileGameJoinCard (copy), v59 (copy), Responsive (copy), FFlagMobileGameJoinCardTTITracking (copy), GameJoinCardTTI (copy), v58 (copy), AppPage (copy), FFlagEnableDesktopGameJoinCard (copy), u75 (ref), u74 (ref), FFlagDeprecatePeopleListContextualMenu (copy), SetCentralOverlay (copy), CentralOverlayType (copy), u70 (ref), Enums3 (copy), FFlagJoinGameCardPassThroughUniversePlaceInfoFromFriendsCarousel (copy), Enums2 (copy), FFlagEnableSplitPane (copy), v63 (copy)
		if t1.item.onActivated then
			t1.item.onActivated(t1.item)
		else
			local v99

			if FFlagSocialCarouselFixConsoleCtaForInGame then
				local v98 = t1.item.presence ~= nil and t1.item.presence.userPresenceType == PresenceTypes.InGame

				v99 = u60 and (not FFlagPPVEnabledOnConsole or v98)
			else
				v99 = not FFlagPPVEnabledOnConsole and u60
			end

			if v99 then
				local v100 = v57
				local openPlayerContextualMenu = PlayerContextualMenu.openPlayerContextualMenu
				local t2 = {
					subjectUserId = t1.item.id,
					subjectPresence = v65
				}
				local item = t1.item

				t2.robloxFriendshipStatus = if item.tileType == Tile.Recommendation then if not item.isFriendWithUser then if not item.hasIncomingFriendRequest then if not item.hasPendingFriendRequest then Enum.FriendStatus.NotFriend else Enum.FriendStatus.FriendRequestSent else Enum.FriendStatus.FriendRequestReceived else Enum.FriendStatus.Friend else Enum.FriendStatus.Friend
				t2.friendshipOriginSourceType = Enums.FriendshipOriginSourceType.FriendRecommendations.rawValue()
				v100(openPlayerContextualMenu(t2))
			elseif t1.item.presence and t1.item.presence.userPresenceType == PresenceTypes.InGame then
				if v52 then
					IXPService:LogFlagLinkedUserLayerExposure(v53)
				end

				if FFlagEnableMobileGameJoinCard and v59 == Responsive.Input.Touch then
					if FFlagMobileGameJoinCardTTITracking then
						GameJoinCardTTI.trackMobileCardClickStart()
					end

					v58.navigate(AppPage.GameJoinCard, {
						userId = t1.item.id,
						homepageCarouselAbsolutePosition = t1.index
					})
				elseif FFlagEnableDesktopGameJoinCard then
					u75(not u74)
				elseif not FFlagDeprecatePeopleListContextualMenu then
					if FFlagMobileGameJoinCardTTITracking then
						GameJoinCardTTI.trackPeopleListClickStart()
					end

					v57(SetCentralOverlay(CentralOverlayType.PeopleList, {
						user = {
							id = t1.item.id,
							combinedName = u70,
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
				((if not FFlagEnableSplitPane then v58.navigate else v58.push))(AppPage.ProfilePlatform, {
					detail = t1.item.id,
					extraProps = {
						source = Enums2.Sources.HomePageFriendsCarousel
					}
				})
			end
		end

		v63.userPressed(t1.item, {
			absolutePosition = t1.index
		})
	end, {
		t1.item,
		u74
	})
	local v80 = React.useMemo(function() -- line: 330
		-- upvalues: t1 (copy), Tile (copy), v64 (copy), PresenceTypes (copy)
		if t1.item.tileType == Tile.Recommendation then
			return v64.suggestedLabel
		end

		if t1.item.presence and t1.item.presence.userPresenceType == PresenceTypes.InGame then
			return t1.item.presence.lastLocation
		end

		return nil
	end, { t1.item })
	local v81 = nil
	local u82 = nil

	if FFlagEnableDesktopGameJoinCard or v52 then
		local v83

		v81, v83 = React.useState(nil)
		u82 = v83
	end

	local v84 = if not FFlagSocialCarouselPressXToViewProfile then nil else React.useRef(nil)
	local v85 = if not FFlagSocialCarouselPressXToViewProfile then nil else React.useCallback(function() -- line: 348
		-- upvalues: FFlagEnableSplitPane (copy), v58 (copy), AppPage (copy), t1 (copy), Enums2 (copy), v63 (copy);
		((if not FFlagEnableSplitPane then v58.navigate else v58.push))(AppPage.ProfilePlatform, {
			detail = t1.item.id,
			extraProps = {
				source = Enums2.Sources.HomePageFriendsCarousel
			}
		})
		v63.userPressed(t1.item, {
			absolutePosition = t1.index
		})
	end, {
		t1.item,
		t1.index,
		v58.navigate,
		v58.push,
		v63.userPressed
	})
	local v86 = if not FFlagSocialCarouselPressXToViewProfile then nil else React.useMemo(function() -- line: 365
		-- upvalues: v85 (copy), FocusNavigationEventNameEnum (copy)
		return {
			{
				onActivated = v85,
				focusEventName = FocusNavigationEventNameEnum.ViewProfile
			},
			{
				onActivated = function() -- line: 371
				end
			}
		}
	end, { v85 })
	local v87 = if not FFlagSocialCarouselPressXToViewProfile then nil else React.useCallback(function(p6) -- line: 377
		-- upvalues: v84 (copy), u82 (ref)
		v84.current = p6

		if u82 then
			u82(p6)
		end
	end, { u82 })

	React.useEffect(function() -- line: 385
		-- upvalues: v62 (copy), v56 (copy), t1 (copy)
		if v62.unifiedLogging then
			v62.unifiedLogging.tagTileForImpressions(v56, t1.index)
		end
	end, { t1.index })
	React.useEffect(function() -- line: 391
		-- upvalues: v62 (copy), Constants (copy), FFlagSocialCarouselEnableUserSeenEvents (copy), v63 (copy), t1 (copy)
		v62.onSuccessfulRender(Constants.ANALYTICS.UI_LOADING_EVENTS.CAROUSEL_FRIEND)

		if FFlagSocialCarouselEnableUserSeenEvents then
			v63.userSeen(t1.item, {
				absolutePosition = t1.index
			})
		end
	end, {})
	React.useEffect(function() -- line: 400
		-- upvalues: t1 (copy)
		if t1.onTileContentChanged then
			t1.onTileContentChanged(t1.item.id, t1.index)
		end
	end, {
		t1.item.id,
		t1.index
	})

	if FFlagEnableDesktopGameJoinCard or v52 then
		local v88 = React.useCallback(function() -- line: 407
			-- upvalues: u75 (ref)
			if u75 then
				u75(false)
			end
		end, {})
		local v89 = false

		if FFlagEnableConsoleGameJoinCard then
			v89 = useGameJoinCardNavigation(v81, u60, v56)
		end

		local presence = t1.item.presence
		local v91 = presence and presence.userPresenceType == PresenceTypes.InGame
		local v92 = (u74 or v89) and (v91 and v65 ~= nil)
		local v93 = FFlagEnableConsoleGameJoinCard and (v91 and (u60 and v92))

		React.useEffect(function() -- line: 423
			-- upvalues: v52 (copy), v92 (copy), IXPService (copy), v53 (copy)
			if v52 and v92 then
				IXPService:LogFlagLinkedUserLayerExposure(v53)
			end
		end, { v92 })

		local v94 = React.createElement(UserTile, Cryo.Dictionary.join(t1, {
			itemSize = UDim2.fromScale(1, 1),
			onActivated = v79,
			name = if t1.item.tileType ~= Tile.Recommendation then u70 else v71,
			contextualText = v80,
			tileRef = v56,
			titleIcon = if t1.item.tileType ~= Tile.Recommendation then nil else v40
		}))

		return React.createElement(View, {
			BackgroundTransparency = 1,
			Size = t1.itemSize,
			LayoutOrder = t1.index,
			ref = v56,
			stateLayer = {
				affordance = Foundation.Enums.StateLayerAffordance.None
			}
		}, {
			UserTile = v94,
			GameJoinCardPopover = if not FFlagEnableDesktopGameJoinCard or (not v65 or not presence) then nil else React.createElement(DesktopGameJoinCardContainer, {
				layoutOrder = 1,
				playerName = u70 or "",
				platformName = v71 or "",
				platformProfileId = if not FFlagEnableConsoleGameJoinCard then nil else v66,
				universeId = tostring(presence.universeId),
				experienceName = presence.lastLocation,
				userId = t1.item.id,
				presence = presence,
				anchorRef = v56,
				isOpen = v92 == true,
				onClose = v88,
				homepageCarouselAbsolutePosition = t1.index,
				showGamepadJoinFocus = v93 == true,
				onCardGuiObjectChanged = if not FFlagSocialCarouselPressXToViewProfile then u82 else v87,
				isFocused = v89
			}),
			TileEventHandlers = if not FFlagSocialCarouselPressXToViewProfile then nil else React.createElement(UserTileEventHandlers, {
				tileRef = v56,
				buttons = if not v61 then nil else v86,
				onTileActivated = function() -- line: 477
				end
			}),
			CardEventHandlers = if not FFlagSocialCarouselPressXToViewProfile or (not v61 or not v81) then nil else React.createElement(UserTileEventHandlers, {
				tileRef = v84,
				buttons = v86,
				onTileActivated = function() -- line: 486
				end
			})
		})
	end

	local v95 = React.createElement(UserTile, Cryo.Dictionary.join(t1, {
		onActivated = v79,
		name = if t1.item.tileType ~= Tile.Recommendation then u70 else v71,
		contextualText = v80,
		tileRef = v56,
		titleIcon = if t1.item.tileType ~= Tile.Recommendation then nil else v40
	}))

	if FFlagSocialCarouselPressXToViewProfile then
		return React.createElement(React.Fragment, nil, {
			UserTile = v95,
			TileEventHandlers = React.createElement(UserTileEventHandlers, {
				tileRef = v56,
				buttons = if not v61 then nil else v86,
				onTileActivated = function() -- line: 509
				end
			})
		})
	end

	return v95
end
