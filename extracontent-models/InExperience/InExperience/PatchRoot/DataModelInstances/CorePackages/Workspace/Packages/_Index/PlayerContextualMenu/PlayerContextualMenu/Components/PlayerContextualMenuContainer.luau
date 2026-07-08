local HttpService = game:GetService("HttpService")
local PlayerContextualMenu = script:FindFirstAncestor("PlayerContextualMenu")
local PlayerContextualMenuParent = PlayerContextualMenu.Parent
local Cryo = require(PlayerContextualMenuParent.Cryo)
local React = require(PlayerContextualMenuParent.React)
local UserProfiles = require(PlayerContextualMenuParent.UserProfiles)
local Url = require(PlayerContextualMenuParent.Http).Url
local RoactRodux = require(PlayerContextualMenuParent.RoactUtils).Hooks.RoactRodux
local RobloxAppHooks = require(PlayerContextualMenuParent.RobloxAppHooks)
local AppPage = require(PlayerContextualMenuParent.RobloxAppEnums).AppPage
local useLocalization = require(PlayerContextualMenuParent.Localization).Hooks.useLocalization
local ToastRodux = require(PlayerContextualMenuParent.ToastRodux)
local DiscoveryAnalytics = require(PlayerContextualMenuParent.DiscoveryAnalytics)
local Navigation = require(PlayerContextualMenuParent.Navigation)
local getCurrentRouteState = Navigation.getCurrentRouteState
local ExperienceService = require(PlayerContextualMenuParent.ExperienceService).ExperienceService
local AppSessionService = require(PlayerContextualMenuParent.RoactServiceTags).AppSessionService
local RobloxAppSessionization = require(PlayerContextualMenuParent.RobloxAppSessionization)
local Dash = require(PlayerContextualMenuParent.Dash)
local SetGamePlaySession = RobloxAppSessionization.SetGamePlaySession
local SessionType = RobloxAppSessionization.SessionType
local v22 = require(PlayerContextualMenuParent.Loggers).Logger:new(script.Name)
local SharedFlags = require(PlayerContextualMenuParent.SharedFlags)
local FFlagConnectionsToFriendsRename = SharedFlags.FFlagConnectionsToFriendsRename
local getFFlagAppChatPCMFixBlocking = SharedFlags.getFFlagAppChatPCMFixBlocking
local RecommendationContextType = require(PlayerContextualMenuParent.FriendsRodux).config({
	keyPath = "PlayerContextualMenu.Friends"
}).Enums.RecommendationContextType
local useRecommendationContextualInfoDisplay = require(PlayerContextualMenuParent.SocialCommon).Hooks.useRecommendationContextualInfoDisplay

require(script.Parent.Types)

local getPresenceIcon = require(script.Parent.getPresenceIcon)
local getPresenceText = require(script.Parent.getPresenceText)
local UIBlox = require(PlayerContextualMenuParent.UIBlox)
local Images = UIBlox.App.ImageSet.Images
local Button = UIBlox.App.Button.Button
local ButtonType = UIBlox.App.Button.Enum.ButtonType
local useDesignTokens = require(PlayerContextualMenuParent.Style).useDesignTokens
local Analytics = require(PlayerContextualMenu.Analytics)
local setupFireEvent = Analytics.setupFireEvent
local EventNames = Analytics.EventNames
local AnalyticsService = Analytics.AnalyticsService
local Friends = require(PlayerContextualMenu.Http.Friends)
local Blocking = require(PlayerContextualMenu.Http.Blocking)
local PlayerContextualMenuComponent = require(PlayerContextualMenu.Components.PlayerContextualMenuComponent)
local useHttpRequest = require(script.Parent.HttpRequest.useHttpRequest)
local _ = require(PlayerContextualMenuParent.FriendsNetworking).Enums
local FFlagUserProfileConsoleUseNewReportFlow = require(PlayerContextualMenu.Flags.FFlagUserProfileConsoleUseNewReportFlow)
local CloseCentralOverlay = nil
local AbuseVector = nil
local OpenDynamicAbuseReport = nil

if FFlagUserProfileConsoleUseNewReportFlow then
	CloseCentralOverlay = require(PlayerContextualMenuParent.CentralOverlay).Thunks.CloseCentralOverlay
	AbuseVector = require(PlayerContextualMenuParent.GenericAbuseReporting.AbuseVector)
	OpenDynamicAbuseReport = require(PlayerContextualMenuParent.GenericAbuseReporting.OpenDynamicAbuseReport)
end

local v48 = game:DefineFastString("PlayerContextualMenuVendorImagePath", "rbxasset://textures/ui/Shell/Icons/PlatformLogo.png")
local FFlagUserBlockingApiPlayerContextMenuEnabled = require(PlayerContextualMenu.Flags.FFlagUserBlockingApiPlayerContextMenuEnabled)
local v50 = game:DefineFastFlag("FFlagPCMAcceptWidthAsProp", false)
local FFlagSkipBlockModal = require(PlayerContextualMenuParent.SharedFlags).FFlagSkipBlockModal
local v52 = if not game:GetEngineFeature("PlatformFriendsService") or not game:GetEngineFeature("PlatformFriendsProfile") then nil else game:GetService("PlatformFriendsService")

local function NO_OPT_CALLBACK() -- line: 103
end
local function launchGameWithAnalytics(p1, s1: string, s2: string, p2, p3) -- line: 105
	-- upvalues: SetGamePlaySession (copy), SessionType (copy), EventNames (copy), HttpService (copy), DiscoveryAnalytics (copy), AnalyticsService (copy), ExperienceService (copy)
	SetGamePlaySession(p3, SessionType.StructuralIdentifier.GamePlayFromFriendsList, true)
	p1(EventNames.JoinExperience, {
		profileUserId = s2
	})

	local guid = HttpService:GenerateGUID(false)

	DiscoveryAnalytics.Events.gamePlayIntent(AnalyticsService.EventStream, DiscoveryAnalytics.Constants.Context.PlayerContextualMenu, {
		friendId = s2,
		pageName = s1,
		placeId = if not p2 then nil else p2.locationPlaceId,
		rootPlaceId = if not p2 then nil else p2.locationRootPlaceId,
		joinAttemptId = guid
	})
	ExperienceService:LaunchExperience({
		userId = s2,
		joinAttemptId = guid
	}, "PlayerContextualMenu")
end

local t1 = {
	enableExperienceCTAs = true,
	width = UDim.new(0, 400)
}
local t2 = {
	Block = "Feature.Friends.Action.Block",
	Unblock = "Feature.Friends.Action.Unblock",
	Chat = "CommonUI.Features.Label.Chat",
	Join = "Feature.Chat.Drawer.Join",
	PendingRequest = "Feature.Friends.Action.PendingRequest",
	Report = "Feature.Catalog.Action.Report",
	ViewDetails = "Feature.Profile.Label.ViewDetails",
	ViewPlatformProfile = "Feature.Friends.Action.ViewPlatformProfile",
	FriendRequestIgnored = "Feature.AddFriends.Action.RequestIgnored",
	SomethingIsWrong = "Feature.Toast.NetworkingError.SomethingIsWrong",
	UserBlocked = "Feature.Profile.Action.UserBlocked",
	AcceptConnection = not FFlagConnectionsToFriendsRename and "CommonUI.Features.Label.AcceptConnection" or "Feature.Friends.Action.AcceptFriend",
	AddConnection = not FFlagConnectionsToFriendsRename and "CommonUI.Features.Label.AddConnection" or "Feature.Profile.Label.AddFriend",
	IgnoreConnectionRequest = not FFlagConnectionsToFriendsRename and "Feature.AddFriends.Action.IgnoreConnectionRequest" or "Feature.AddFriends.Action.IgnoreFriendRequest",
	RemoveConnection = not FFlagConnectionsToFriendsRename and "CommonUI.Features.Label.RemoveConnection" or "Feature.Friends.Action.Unfriend",
	ConnectionAdded = not FFlagConnectionsToFriendsRename and "Feature.Friends.Action.ConnectionAdded" or "Feature.Friends.Action.FriendAdded",
	ConnectionRequestSent = not FFlagConnectionsToFriendsRename and "Feature.Friends.Action.ConnectionRequestSent" or "Feature.Friends.Action.FriendRequestSent",
	ConnectionRemoved = not FFlagConnectionsToFriendsRename and "Feature.Friends.Label.ConnectionRemoved" or "Feature.Friends.Action.FriendRemoved"
}

local function PlayerContextualMenuContainer(p4) -- line: 209
	-- upvalues: Cryo (copy), t1 (copy), RoactRodux (copy), RobloxAppHooks (copy), Navigation (copy), AppSessionService (copy), useLocalization (copy), t2 (copy), ToastRodux (copy), React (copy), setupFireEvent (copy), AnalyticsService (copy), useHttpRequest (copy), Url (copy), getFFlagAppChatPCMFixBlocking (copy), FFlagUserBlockingApiPlayerContextMenuEnabled (copy), Blocking (copy), v22 (copy), useDesignTokens (copy), UserProfiles (copy), v52 (copy), RecommendationContextType (copy), getPresenceIcon (copy), getPresenceText (copy), useRecommendationContextualInfoDisplay (copy), EventNames (copy), SetGamePlaySession (copy), SessionType (copy), DiscoveryAnalytics (copy), getCurrentRouteState (copy), AppPage (copy), Button (copy), ButtonType (copy), launchGameWithAnalytics (copy), FFlagUserProfileConsoleUseNewReportFlow (copy), OpenDynamicAbuseReport (ref), AbuseVector (ref), CloseCentralOverlay (ref), FFlagSkipBlockModal (copy), Friends (copy), Images (copy), v48 (copy), NO_OPT_CALLBACK (copy), Dash (copy), PlayerContextualMenuComponent (copy), v50 (copy)
	local v65 = Cryo.Dictionary.union(t1, p4)
	local v66 = RoactRodux.useDispatch()
	local v67 = RobloxAppHooks.useLocalUserId()
	local v68 = Navigation.useNavigation()
	local v69 = RobloxAppHooks.useRoactService(AppSessionService)
	local v70 = useLocalization(t2)
	local t3 = {
		isLocalized = true,
		toastMessage = v70.SomethingIsWrong,
		toastType = ToastRodux.Enums.ToastType.NetworkingError
	}
	local v72 = React.useMemo(function() -- line: 225
		-- upvalues: setupFireEvent (copy), AnalyticsService (copy), v67 (copy)
		return setupFireEvent({
			analytics = AnalyticsService,
			infoForAllEvents = {
				uid = v67
			}
		})
	end, { v67 })
	local v73 = useHttpRequest()
	local v74, v75 = React.useState({
		status = "NotStarted",
		isPlayable = false
	})

	React.useEffect(function() -- line: 241
		-- upvalues: v65 (copy), v75 (copy), v73 (copy), Url (copy)
		if v65.subjectPresence and v65.subjectPresence.locationUniverseId then
			v75({
				status = "Fetching",
				isPlayable = false
			})
			v73(Url.GAME_URL .. "v1/games/multiget-playability-status?universeIds=" .. v65.subjectPresence.locationUniverseId, "GET"):andThen(function(p5) -- line: 253
				-- upvalues: v75 (copy)
				if p5.responseBody and p5.responseBody[1] then
					v75({
						status = "Finished",
						isPlayable = p5.responseBody[1].isPlayable
					})
				end
			end):catch(function(_) -- line: 261
				-- upvalues: v75 (copy)
				v75({
					status = "Failed",
					isPlayable = false
				})
			end)
		end
	end, { (tostring(v65.subjectPresence)) })

	local u76 = nil

	if getFFlagAppChatPCMFixBlocking() then
		u76 = RoactRodux.useSelector(function(p7) -- line: 273
			-- upvalues: FFlagUserBlockingApiPlayerContextMenuEnabled (copy), v65 (copy)
			return ((if not FFlagUserBlockingApiPlayerContextMenuEnabled then p7.PlayerContextualMenu.IsBlockedByMe else p7.PlayerContextualMenu.UserBlocking.isBlockedByMe))[v65.subjectUserId] == nil
		end)
		React.useEffect(function() -- line: 281
			-- upvalues: u76 (ref), v66 (copy), Blocking (copy), v65 (copy), v22 (copy)
			if u76 then
				v66(Blocking.IsBlockedById.API({
					userId = v65.subjectUserId
				})):andThen(function() -- line: 286
				end):catch(function() -- line: 287
					-- upvalues: v22 (copy)
					v22:warning("Failed to check if subject user is blocked")
				end)
			end
		end, {
			u76,
			v66,
			v65.subjectUserId
		})
	end

	local v77 = useDesignTokens(function(p8) -- line: 294
		return {
			iconEmphasis = p8.Semantic.Icon.Emphasis,
			onlinePresence = p8.Color.System.Success,
			joinEventButtonHeight = p8.Size.Size_1200
		}
	end)
	local v78 = UserProfiles.Hooks.useUserProfilesFetch({
		userIds = { v65.subjectUserId },
		query = UserProfiles.Queries.userProfilesDisplayUserPlatformNamesByUserIds
	})
	local s3 = ""
	local s4 = ""
	local s5 = ""
	local s6 = ""

	if v78.data then
		s3 = UserProfiles.Selectors.getUsernameFromId(v78.data, v65.subjectUserId)
		s4 = UserProfiles.Selectors.getDisplayNameFromId(v78.data, v65.subjectUserId)
		s5 = UserProfiles.Selectors.getPlatformNameFromId(v78.data, v65.subjectUserId)

		if v52 then
			s6 = UserProfiles.Selectors.getPlatformProfileIdFromId(v78.data, v65.subjectUserId)
		end
	end

	local v83 = not not s5 and s5 ~= ""

	if v65.recommendationContext == RecommendationContextType.Contacts then
		s4 = v65.contactName or ""
	end

	local u84, u85 = getPresenceIcon(v65.subjectPresence, v77)

	if v65.robloxFriendshipStatus ~= Enum.FriendStatus.Friend then
		u84 = nil
		u85 = nil
	end

	local u86 = if v65.robloxFriendshipStatus ~= Enum.FriendStatus.Friend then nil else getPresenceText(v65.subjectPresence)

	if v65.recommendationContext then
		local v87 = useRecommendationContextualInfoDisplay({
			contextType = v65.recommendationContext,
			mutualFriendsCount = v65.mutualFriendsCount
		})

		u86 = v87.text
		u84 = v87.icon
	end

	local v88 = React.useCallback(function() -- line: 345
		-- upvalues: v72 (copy), EventNames (copy), v65 (copy), v66 (copy), v69 (copy), SetGamePlaySession (copy), SessionType (copy), DiscoveryAnalytics (copy), AnalyticsService (copy), getCurrentRouteState (copy), v68 (copy), AppPage (copy)
		v72(EventNames.ViewExperienceDetails, {
			profileUserId = v65.subjectUserId
		})
		v66(v65.closeCentralOverlayThunk())

		if v65.subjectPresence and v65.subjectPresence.locationUniverseId then
			local str = tostring(v65.subjectPresence.locationUniverseId)

			if v69 then
				SetGamePlaySession(v69, SessionType.StructuralIdentifier.GameDetailSource, false)
			end

			DiscoveryAnalytics.Events.gameDetailReferral(AnalyticsService.EventStream, DiscoveryAnalytics.Constants.Context.PlayerContextualMenu, {
				pg = getCurrentRouteState(v68).routeName,
				universeId = str,
				pid = v65.subjectPresence.locationPlaceId,
				friendId = v65.subjectUserId
			})
			v68.navigate(AppPage.ExperienceDetail, {
				detail = str
			})
		end
	end, {
		v72,
		v65.subjectUserId,
		v65.closeCentralOverlayThunk,
		v65.subjectPresence,
		v68,
		v69
	})
	local v89 = React.useMemo(function() -- line: 383
		-- upvalues: v65 (copy), v74 (copy), React (copy), Button (copy), ButtonType (copy), v88 (copy), v77 (copy), v70 (copy)
		if v65.enableExperienceCTAs then
			if not not v65.subjectPresence and v65.subjectPresence.status == "InGame" and not v74.isPlayable then
				return function() -- line: 391
					-- upvalues: React (copy), Button (copy), ButtonType (copy), v88 (copy), v77 (copy), v70 (copy)
					return React.createElement(Button, {
						isLoading = false,
						layoutOrder = 100,
						buttonType = ButtonType.PrimarySystem,
						onActivated = v88,
						size = UDim2.new(1, 0, 0, v77.joinEventButtonHeight),
						text = v70.ViewDetails
					})
				end
			end

			return nil
		end

		return function() -- line: 408
			-- upvalues: React (copy)
			return React.createElement("Folder")
		end
	end, {
		v74,
		tostring(v65.subjectPresence),
		v65.enableExperienceCTAs
	})
	local v90 = if v65.robloxFriendshipStatus ~= Enum.FriendStatus.Friend or (not v65.subjectPresence or v65.subjectPresence.status ~= "InGame") then nil else v70.Join
	local v91 = React.useCallback(function() -- line: 426
		-- upvalues: launchGameWithAnalytics (copy), v72 (copy), getCurrentRouteState (copy), v68 (copy), v65 (copy), v69 (copy)
		launchGameWithAnalytics(v72, getCurrentRouteState(v68).routeName, v65.subjectUserId, v65.subjectPresence, v69)
	end, {
		v72,
		v68,
		v65.subjectUserId,
		v65.subjectPresence,
		v69
	})
	local v92 = React.useCallback(function() -- line: 436
		-- upvalues: v72 (copy), EventNames (copy), v65 (copy), v66 (copy), FFlagUserProfileConsoleUseNewReportFlow (copy), OpenDynamicAbuseReport (ref), AbuseVector (ref), CloseCentralOverlay (ref), v68 (copy), AppPage (copy)
		v72(EventNames.ReportPlayer, {
			profileUserId = v65.subjectUserId
		})

		if v65.onReportActivated then
			v65.onReportActivated()

			return
		end

		v66(v65.closeCentralOverlayThunk())

		if FFlagUserProfileConsoleUseNewReportFlow then
			v66(OpenDynamicAbuseReport({
				abuseVector = AbuseVector.UserProfile,
				targetId = v65.subjectUserId,
				onClose = function() -- line: 447
					-- upvalues: v66 (copy), CloseCentralOverlay (ref)
					v66(CloseCentralOverlay())
				end
			}))

			return
		end

		v68.navigate(AppPage.ReportScreen, {
			reportData = {
				reportAbuseVector = "user",
				context = "profile",
				platform = "console",
				assetId = v65.subjectUserId
			}
		})
	end, {
		v66,
		v68,
		v65.subjectUserId,
		v65.closeCentralOverlayThunk,
		v65.onReportActivated
	})
	local v93 = if not v52 then nil else React.useCallback(function() -- line: 472
		-- upvalues: v72 (copy), EventNames (copy), v65 (copy), v52 (copy), s6 (ref)
		v72(EventNames.ViewPlatformProfile, {
			profileUserId = v65.subjectUserId
		})
		v52:ShowProfile(s6)
	end, {
		s6,
		v66,
		v68,
		v65.subjectUserId,
		v65.closeCentralOverlayThunk
	})
	local v94 = React.useCallback(function() -- line: 480
		-- upvalues: v72 (copy), EventNames (copy), v65 (copy), FFlagSkipBlockModal (copy), v66 (copy), v68 (copy), AppPage (copy), ToastRodux (copy), v70 (copy), Blocking (copy), v67 (copy), t3 (copy)
		v72(EventNames.BlockPlayer, {
			profileUserId = v65.subjectUserId
		})

		if not FFlagSkipBlockModal or not v65.skipBlockModal then
			if v65.onBlockActivated then
				v65.onBlockActivated()

				return
			end

			v66(v65.closeCentralOverlayThunk())
			v68.push(AppPage.BlockingModal, {
				navProps = {
					userId = v65.subjectUserId,
					onBlockSuccess = function() -- line: 491
						-- upvalues: v66 (copy), ToastRodux (copy), v70 (copy)
						v66(ToastRodux.Actions.SetCurrentToastMessage({
							isLocalized = true,
							toastMessage = v70.UserBlocked,
							toastType = ToastRodux.Enums.ToastType.SuccessConfirmation
						}))
					end
				}
			})

			return
		end

		v66(Blocking.BlockUserById.API({
			userId = v65.subjectUserId,
			currentUserId = v67
		})):andThen(function() -- line: 506
			-- upvalues: v66 (copy), ToastRodux (copy), v70 (copy), v65 (copy)
			v66(ToastRodux.Actions.SetCurrentToastMessage({
				isLocalized = true,
				toastMessage = v70.UserBlocked,
				toastType = ToastRodux.Enums.ToastType.SuccessConfirmation
			}))
			v66(v65.closeCentralOverlayThunk())
		end):catch(function(_) -- line: 514
			-- upvalues: v66 (copy), ToastRodux (copy), t3 (copy)
			v66(ToastRodux.Actions.SetCurrentToastMessage(t3))
		end)
	end, {
		v70,
		v67,
		v66,
		v65.closeCentralOverlayThunk,
		v65.subjectUserId,
		v65.onBlockActivated,
		if not FFlagSkipBlockModal then nil else v65.skipBlockModal
	})
	local v95 = React.useCallback(function() -- line: 528
		-- upvalues: v66 (copy), Blocking (copy), v65 (copy), v67 (copy), ToastRodux (copy), t3 (copy)
		v66(Blocking.UnblockUserById.API({
			userId = v65.subjectUserId,
			currentUserId = v67
		})):andThen(function() -- line: 533
			-- upvalues: v66 (copy), v65 (copy)
			v66(v65.closeCentralOverlayThunk())
		end):catch(function(_) -- line: 536
			-- upvalues: v66 (copy), ToastRodux (copy), t3 (copy)
			v66(ToastRodux.Actions.SetCurrentToastMessage(t3))
		end)
	end, {
		v67,
		v66,
		v65.closeCentralOverlayThunk,
		v65.subjectUserId
	})
	local v96 = React.useCallback(function() -- line: 541
		-- upvalues: v72 (copy), EventNames (copy), v65 (copy), v66 (copy), Friends (copy), v67 (copy), ToastRodux (copy), v70 (copy), t3 (copy)
		v72(EventNames.Unfriend, {
			profileUserId = v65.subjectUserId
		})
		v66(Friends.UnfriendTargetUserId.API({
			targetUserId = v65.subjectUserId,
			currentUserId = v67
		})):andThen(function() -- line: 548
			-- upvalues: v66 (copy), ToastRodux (copy), v70 (copy), v65 (copy)
			v66(ToastRodux.Actions.SetCurrentToastMessage({
				isLocalized = true,
				toastMessage = v70.ConnectionRemoved,
				toastType = ToastRodux.Enums.ToastType.SuccessConfirmation
			}))
			v66(v65.closeCentralOverlayThunk())
		end):catch(function() -- line: 556
			-- upvalues: v66 (copy), ToastRodux (copy), t3 (copy)
			v66(ToastRodux.Actions.SetCurrentToastMessage(t3))
		end)
	end, {
		v70,
		v67,
		v66,
		v65.subjectUserId,
		v65.closeCentralOverlayThunk
	})
	local v97 = React.useCallback(function() -- line: 562
		-- upvalues: v72 (copy), EventNames (copy), v65 (copy), v66 (copy), RecommendationContextType (copy), Friends (copy), v67 (copy), ToastRodux (copy), v70 (copy), t3 (copy)
		v72(EventNames.RequestFriendship, {
			profileUserId = v65.subjectUserId
		})
		v66((if v65.recommendationContext ~= RecommendationContextType.Contacts or not v65.contactId then Friends.RequestFriendshipFromUserId.API({
			targetUserId = v65.subjectUserId,
			currentUserId = v67,
			friendshipOriginSourceType = v65.friendshipOriginSourceType
		}) else Friends.RequestFriendshipFromContactId.API({
			contactId = v65.contactId,
			currentUserId = v67
		}))):andThen(function() -- line: 574
			-- upvalues: v66 (copy), ToastRodux (copy), v70 (copy), v65 (copy)
			v66(ToastRodux.Actions.SetCurrentToastMessage({
				isLocalized = true,
				toastMessage = v70.ConnectionRequestSent,
				toastType = ToastRodux.Enums.ToastType.SuccessConfirmation
			}))
			v66(v65.closeCentralOverlayThunk())
		end):catch(function() -- line: 582
			-- upvalues: v66 (copy), ToastRodux (copy), t3 (copy)
			v66(ToastRodux.Actions.SetCurrentToastMessage(t3))
		end)
	end, {
		v70,
		v67,
		v66,
		v65.closeCentralOverlayThunk,
		v65.subjectUserId,
		v65.recommendationContext,
		v65.contactId,
		v65.friendshipOriginSourceType
	})
	local v98 = React.useCallback(function() -- line: 598
		-- upvalues: v72 (copy), EventNames (copy), v65 (copy), v66 (copy), Friends (copy), v67 (copy), ToastRodux (copy), v70 (copy), t3 (copy)
		v72(EventNames.AcceptFriendRequest, {
			profileUserId = v65.subjectUserId
		})
		v66(Friends.AcceptFriendRequestFromUserId.API({
			targetUserId = v65.subjectUserId,
			currentUserId = v67
		})):andThen(function() -- line: 605
			-- upvalues: v66 (copy), ToastRodux (copy), v70 (copy), v65 (copy)
			v66(ToastRodux.Actions.SetCurrentToastMessage({
				isLocalized = true,
				toastMessage = v70.ConnectionAdded,
				toastType = ToastRodux.Enums.ToastType.SuccessConfirmation
			}))
			v66(v65.closeCentralOverlayThunk())
		end):catch(function() -- line: 613
			-- upvalues: v66 (copy), ToastRodux (copy), t3 (copy)
			v66(ToastRodux.Actions.SetCurrentToastMessage(t3))
		end)
	end, {
		v70,
		v67,
		v66,
		v65.closeCentralOverlayThunk,
		v65.subjectUserId
	})
	local v99 = React.useCallback(function() -- line: 618
		-- upvalues: v72 (copy), EventNames (copy), v65 (copy), v66 (copy), Friends (copy), v67 (copy), ToastRodux (copy), v70 (copy), t3 (copy)
		v72(EventNames.IgnoreFriendRequest, {
			profileUserId = v65.subjectUserId
		})
		v66(Friends.DeclineFriendRequestFromUserId.API({
			targetUserId = v65.subjectUserId,
			currentUserId = v67
		})):andThen(function() -- line: 625
			-- upvalues: v66 (copy), ToastRodux (copy), v70 (copy), v65 (copy)
			v66(ToastRodux.Actions.SetCurrentToastMessage({
				isLocalized = true,
				toastMessage = v70.FriendRequestIgnored,
				toastType = ToastRodux.Enums.ToastType.SuccessConfirmation
			}))
			v66(v65.closeCentralOverlayThunk())
		end):catch(function() -- line: 633
			-- upvalues: v66 (copy), ToastRodux (copy), t3 (copy)
			v66(ToastRodux.Actions.SetCurrentToastMessage(t3))
		end)
	end, {
		v70,
		v67,
		v66,
		v65.closeCentralOverlayThunk,
		v65.subjectUserId
	})
	local v100 = RoactRodux.useSelector(function(p11) -- line: 638
		-- upvalues: FFlagUserBlockingApiPlayerContextMenuEnabled (copy), v65 (copy)
		return ((if not FFlagUserBlockingApiPlayerContextMenuEnabled then p11.PlayerContextualMenu.IsBlockedByMe else p11.PlayerContextualMenu.UserBlocking.isBlockedByMe))[v65.subjectUserId] or false
	end)
	local v101 = React.useMemo(function() -- line: 647
		-- upvalues: Images (copy), v70 (copy), v92 (copy), v48 (copy), v93 (copy), v94 (copy), u76 (ref), v95 (copy), v96 (copy), v97 (copy), NO_OPT_CALLBACK (copy), v98 (copy), v99 (copy), v100 (copy), v65 (copy), getFFlagAppChatPCMFixBlocking (copy), Cryo (copy), v52 (copy), s6 (ref), Dash (copy)
		local t4 = {
			icon = Images["icons/actions/feedback"],
			text = v70.Report,
			onActivated = v92
		}
		local t5 = {
			icon = v48,
			text = v70.ViewPlatformProfile,
			onActivated = v93
		}
		local t6 = {
			icon = Images["icons/actions/block"],
			text = v70.Block,
			onActivated = v94,
			disabled = u76
		}
		local t7 = {
			icon = Images["icons/actions/block"],
			text = v70.Unblock,
			onActivated = v95
		}
		local t8 = {
			icon = Images["icons/actions/friends/friendRemove"],
			text = v70.RemoveConnection,
			onActivated = v96
		}
		local t9 = {
			icon = Images["icons/actions/friends/friendAdd"],
			text = v70.AddConnection,
			onActivated = v97
		}
		local t10 = {
			icon = Images["icons/actions/friends/friendpending"],
			text = v70.PendingRequest,
			onActivated = NO_OPT_CALLBACK
		}
		local t11 = {
			icon = Images["icons/actions/friends/friendpending"],
			text = v70.AcceptConnection,
			onActivated = v98
		}
		local t12 = {
			icon = Images["icons/actions/reject"],
			text = v70.IgnoreConnectionRequest,
			onActivated = v99
		}

		local function makeCtas() -- line: 703
			-- upvalues: v100 (copy), t7 (copy), t6 (copy), v65 (copy), t4 (copy), getFFlagAppChatPCMFixBlocking (copy), t8 (copy), t9 (copy), t10 (copy), t11 (copy), t12 (copy), Cryo (copy)
			local v120 = if not v100 then t6 else t7
			local v121 = if v65.robloxFriendshipStatus ~= Enum.FriendStatus.Friend then if v65.robloxFriendshipStatus ~= Enum.FriendStatus.NotFriend then if v65.robloxFriendshipStatus ~= Enum.FriendStatus.FriendRequestSent then if v65.robloxFriendshipStatus ~= Enum.FriendStatus.FriendRequestReceived then {
				t4,
				v120
			} else {
				t11,
				t12,
				t4,
				v120
			} else {
				t10,
				t4,
				v120
			} else if not v65.contactId then {
				t9,
				t4,
				v120
			} else { t9 } else {
				t4,
				if not getFFlagAppChatPCMFixBlocking() then t6 else v120,
				t8
			}

			if v65.additionalButtons then
				v121 = Cryo.List.join(v121, v65.additionalButtons)
			end

			return v121
		end

		if v52 and (v52:IsProfileEnabled() and s6 and s6 ~= "") then
			return Dash.append({ t5 }, (makeCtas()))
		end

		return (makeCtas())
	end, Cryo.Dictionary.union(if not v52 then {
		v65.robloxFriendshipStatus,
		v100,
		v65.contactId,
		v65.additionalButtons
	} else {
		v65.robloxFriendshipStatus,
		v100,
		s6,
		v65.contactId,
		v65.additionalButtons
	}, if not getFFlagAppChatPCMFixBlocking() then {} else { u76 }))

	return React.createElement(PlayerContextualMenuComponent, {
		headerProps = React.useMemo(function() -- line: 780
			-- upvalues: s4 (ref), v78 (copy), v65 (copy), RecommendationContextType (copy), s3 (ref), s5 (ref), v83 (copy), v48 (copy), u86 (ref), u84 (ref), u85 (ref), v90 (copy), v91 (copy), v89 (copy)
			return {
				displayNameItem = {
					icon = nil,
					labelText = s4,
					isLoading = v78.loading
				},
				userNameItem = if v65.recommendationContext ~= RecommendationContextType.Contacts then {
					icon = nil,
					labelText = "@" .. s3,
					isLoading = v78.loading
				} else nil,
				vendorNameItem = if s5 ~= "" then {
					labelText = s5 or "",
					icon = v83 and {
						Image = v48,
						ImageRectOffset = Vector2.zero,
						ImageRectSize = Vector2.zero
					} or nil,
					isLoading = v78.loading
				} else nil,
				contextText = u86,
				contextIcon = u84,
				contextIconColor = if not u85 then nil else u85.Color3,
				contextIconTransparency = if not u85 then nil else u85.Transparency,
				joinEventText = v90,
				joinEventOnActivated = v91,
				renderJoinEventButton = v89
			}
		end, {
			v78,
			s4,
			s3,
			s5,
			v83,
			u84,
			u86,
			u85,
			v89,
			v90,
			v91,
			v65.recommendationContext
		}),
		buttonProps = v101,
		width = if not v50 then UDim.new(0, 400) else v65.width
	})
end

return PlayerContextualMenuContainer
