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
local FFlagRenameDeprecatedUIBloxTokens = SharedFlags.FFlagRenameDeprecatedUIBloxTokens
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

local v49 = game:DefineFastString("PlayerContextualMenuVendorImagePath", "rbxasset://textures/ui/Shell/Icons/PlatformLogo.png")
local FFlagUserBlockingApiPlayerContextMenuEnabled = require(PlayerContextualMenu.Flags.FFlagUserBlockingApiPlayerContextMenuEnabled)
local v51 = game:DefineFastFlag("FFlagPCMAcceptWidthAsProp", false)
local FFlagSkipBlockModal = require(PlayerContextualMenuParent.SharedFlags).FFlagSkipBlockModal
local v53 = if not game:GetEngineFeature("PlatformFriendsService") or not game:GetEngineFeature("PlatformFriendsProfile") then nil else game:GetService("PlatformFriendsService")

local function NO_OPT_CALLBACK() -- line: 104
end
local function launchGameWithAnalytics(p1, s1: string, s2: string, p2, p3) -- line: 106
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

local function PlayerContextualMenuContainer(p4) -- line: 210
	-- upvalues: Cryo (copy), t1 (copy), RoactRodux (copy), RobloxAppHooks (copy), Navigation (copy), AppSessionService (copy), useLocalization (copy), t2 (copy), ToastRodux (copy), React (copy), setupFireEvent (copy), AnalyticsService (copy), useHttpRequest (copy), Url (copy), getFFlagAppChatPCMFixBlocking (copy), FFlagUserBlockingApiPlayerContextMenuEnabled (copy), Blocking (copy), v22 (copy), useDesignTokens (copy), FFlagRenameDeprecatedUIBloxTokens (copy), UserProfiles (copy), v53 (copy), RecommendationContextType (copy), getPresenceIcon (copy), getPresenceText (copy), useRecommendationContextualInfoDisplay (copy), EventNames (copy), SetGamePlaySession (copy), SessionType (copy), DiscoveryAnalytics (copy), getCurrentRouteState (copy), AppPage (copy), Button (copy), ButtonType (copy), launchGameWithAnalytics (copy), FFlagUserProfileConsoleUseNewReportFlow (copy), OpenDynamicAbuseReport (ref), AbuseVector (ref), CloseCentralOverlay (ref), FFlagSkipBlockModal (copy), Friends (copy), Images (copy), v49 (copy), NO_OPT_CALLBACK (copy), Dash (copy), PlayerContextualMenuComponent (copy), v51 (copy)
	local v66 = Cryo.Dictionary.union(t1, p4)
	local v67 = RoactRodux.useDispatch()
	local v68 = RobloxAppHooks.useLocalUserId()
	local v69 = Navigation.useNavigation()
	local v70 = RobloxAppHooks.useRoactService(AppSessionService)
	local v71 = useLocalization(t2)
	local t3 = {
		isLocalized = true,
		toastMessage = v71.SomethingIsWrong,
		toastType = ToastRodux.Enums.ToastType.NetworkingError
	}
	local v73 = React.useMemo(function() -- line: 226
		-- upvalues: setupFireEvent (copy), AnalyticsService (copy), v68 (copy)
		return setupFireEvent({
			analytics = AnalyticsService,
			infoForAllEvents = {
				uid = v68
			}
		})
	end, { v68 })
	local v74 = useHttpRequest()
	local v75, v76 = React.useState({
		status = "NotStarted",
		isPlayable = false
	})

	React.useEffect(function() -- line: 242
		-- upvalues: v66 (copy), v76 (copy), v74 (copy), Url (copy)
		if v66.subjectPresence and v66.subjectPresence.locationUniverseId then
			v76({
				status = "Fetching",
				isPlayable = false
			})
			v74(Url.GAME_URL .. "v1/games/multiget-playability-status?universeIds=" .. v66.subjectPresence.locationUniverseId, "GET"):andThen(function(p5) -- line: 254
				-- upvalues: v76 (copy)
				if p5.responseBody and p5.responseBody[1] then
					v76({
						status = "Finished",
						isPlayable = p5.responseBody[1].isPlayable
					})
				end
			end):catch(function(_) -- line: 262
				-- upvalues: v76 (copy)
				v76({
					status = "Failed",
					isPlayable = false
				})
			end)
		end
	end, { (tostring(v66.subjectPresence)) })

	local u77 = nil

	if getFFlagAppChatPCMFixBlocking() then
		u77 = RoactRodux.useSelector(function(p7) -- line: 274
			-- upvalues: FFlagUserBlockingApiPlayerContextMenuEnabled (copy), v66 (copy)
			return ((if not FFlagUserBlockingApiPlayerContextMenuEnabled then p7.PlayerContextualMenu.IsBlockedByMe else p7.PlayerContextualMenu.UserBlocking.isBlockedByMe))[v66.subjectUserId] == nil
		end)
		React.useEffect(function() -- line: 282
			-- upvalues: u77 (ref), v67 (copy), Blocking (copy), v66 (copy), v22 (copy)
			if u77 then
				v67(Blocking.IsBlockedById.API({
					userId = v66.subjectUserId
				})):andThen(function() -- line: 287
				end):catch(function() -- line: 288
					-- upvalues: v22 (copy)
					v22:warning("Failed to check if subject user is blocked")
				end)
			end
		end, {
			u77,
			v67,
			v66.subjectUserId
		})
	end

	local v78 = useDesignTokens(function(p8) -- line: 295
		-- upvalues: FFlagRenameDeprecatedUIBloxTokens (copy)
		return {
			iconEmphasis = if not FFlagRenameDeprecatedUIBloxTokens then p8.Semantic.Icon.Emphasis else p8.Color.Content.Emphasis,
			onlinePresence = p8.Color.System.Success,
			joinEventButtonHeight = p8.Size.Size_1200
		}
	end)
	local v79 = UserProfiles.Hooks.useUserProfilesFetch({
		userIds = { v66.subjectUserId },
		query = UserProfiles.Queries.userProfilesDisplayUserPlatformNamesByUserIds
	})
	local s3 = ""
	local s4 = ""
	local s5 = ""
	local s6 = ""

	if v79.data then
		s3 = UserProfiles.Selectors.getUsernameFromId(v79.data, v66.subjectUserId)
		s4 = UserProfiles.Selectors.getDisplayNameFromId(v79.data, v66.subjectUserId)
		s5 = UserProfiles.Selectors.getPlatformNameFromId(v79.data, v66.subjectUserId)

		if v53 then
			s6 = UserProfiles.Selectors.getPlatformProfileIdFromId(v79.data, v66.subjectUserId)
		end
	end

	local v84 = not not s5 and s5 ~= ""

	if v66.recommendationContext == RecommendationContextType.Contacts then
		s4 = v66.contactName or ""
	end

	local u85, u86 = getPresenceIcon(v66.subjectPresence, v78)

	if v66.robloxFriendshipStatus ~= Enum.FriendStatus.Friend then
		u85 = nil
		u86 = nil
	end

	local u87 = if v66.robloxFriendshipStatus ~= Enum.FriendStatus.Friend then nil else getPresenceText(v66.subjectPresence)

	if v66.recommendationContext then
		local v88 = useRecommendationContextualInfoDisplay({
			contextType = v66.recommendationContext,
			mutualFriendsCount = v66.mutualFriendsCount
		})

		u87 = v88.text
		u85 = v88.icon
	end

	local v89 = React.useCallback(function() -- line: 348
		-- upvalues: v73 (copy), EventNames (copy), v66 (copy), v67 (copy), v70 (copy), SetGamePlaySession (copy), SessionType (copy), DiscoveryAnalytics (copy), AnalyticsService (copy), getCurrentRouteState (copy), v69 (copy), AppPage (copy)
		v73(EventNames.ViewExperienceDetails, {
			profileUserId = v66.subjectUserId
		})
		v67(v66.closeCentralOverlayThunk())

		if v66.subjectPresence and v66.subjectPresence.locationUniverseId then
			local str = tostring(v66.subjectPresence.locationUniverseId)

			if v70 then
				SetGamePlaySession(v70, SessionType.StructuralIdentifier.GameDetailSource, false)
			end

			DiscoveryAnalytics.Events.gameDetailReferral(AnalyticsService.EventStream, DiscoveryAnalytics.Constants.Context.PlayerContextualMenu, {
				pg = getCurrentRouteState(v69).routeName,
				universeId = str,
				pid = v66.subjectPresence.locationPlaceId,
				friendId = v66.subjectUserId
			})
			v69.navigate(AppPage.ExperienceDetail, {
				detail = str
			})
		end
	end, {
		v73,
		v66.subjectUserId,
		v66.closeCentralOverlayThunk,
		v66.subjectPresence,
		v69,
		v70
	})
	local v90 = React.useMemo(function() -- line: 386
		-- upvalues: v66 (copy), v75 (copy), React (copy), Button (copy), ButtonType (copy), v89 (copy), v78 (copy), v71 (copy)
		if v66.enableExperienceCTAs then
			if not not v66.subjectPresence and v66.subjectPresence.status == "InGame" and not v75.isPlayable then
				return function() -- line: 394
					-- upvalues: React (copy), Button (copy), ButtonType (copy), v89 (copy), v78 (copy), v71 (copy)
					return React.createElement(Button, {
						isLoading = false,
						layoutOrder = 100,
						buttonType = ButtonType.PrimarySystem,
						onActivated = v89,
						size = UDim2.new(1, 0, 0, v78.joinEventButtonHeight),
						text = v71.ViewDetails
					})
				end
			end

			return nil
		end

		return function() -- line: 411
			-- upvalues: React (copy)
			return React.createElement("Folder")
		end
	end, {
		v75,
		tostring(v66.subjectPresence),
		v66.enableExperienceCTAs
	})
	local v91 = if v66.robloxFriendshipStatus ~= Enum.FriendStatus.Friend or (not v66.subjectPresence or v66.subjectPresence.status ~= "InGame") then nil else v71.Join
	local v92 = React.useCallback(function() -- line: 429
		-- upvalues: launchGameWithAnalytics (copy), v73 (copy), getCurrentRouteState (copy), v69 (copy), v66 (copy), v70 (copy)
		launchGameWithAnalytics(v73, getCurrentRouteState(v69).routeName, v66.subjectUserId, v66.subjectPresence, v70)
	end, {
		v73,
		v69,
		v66.subjectUserId,
		v66.subjectPresence,
		v70
	})
	local v93 = React.useCallback(function() -- line: 439
		-- upvalues: v73 (copy), EventNames (copy), v66 (copy), v67 (copy), FFlagUserProfileConsoleUseNewReportFlow (copy), OpenDynamicAbuseReport (ref), AbuseVector (ref), CloseCentralOverlay (ref), v69 (copy), AppPage (copy)
		v73(EventNames.ReportPlayer, {
			profileUserId = v66.subjectUserId
		})

		if v66.onReportActivated then
			v66.onReportActivated()

			return
		end

		v67(v66.closeCentralOverlayThunk())

		if FFlagUserProfileConsoleUseNewReportFlow then
			v67(OpenDynamicAbuseReport({
				abuseVector = AbuseVector.UserProfile,
				targetId = v66.subjectUserId,
				onClose = function() -- line: 450
					-- upvalues: v67 (copy), CloseCentralOverlay (ref)
					v67(CloseCentralOverlay())
				end
			}))

			return
		end

		v69.navigate(AppPage.ReportScreen, {
			reportData = {
				reportAbuseVector = "user",
				context = "profile",
				platform = "console",
				assetId = v66.subjectUserId
			}
		})
	end, {
		v67,
		v69,
		v66.subjectUserId,
		v66.closeCentralOverlayThunk,
		v66.onReportActivated
	})
	local v94 = if not v53 then nil else React.useCallback(function() -- line: 475
		-- upvalues: v73 (copy), EventNames (copy), v66 (copy), v53 (copy), s6 (ref)
		v73(EventNames.ViewPlatformProfile, {
			profileUserId = v66.subjectUserId
		})
		v53:ShowProfile(s6)
	end, {
		s6,
		v67,
		v69,
		v66.subjectUserId,
		v66.closeCentralOverlayThunk
	})
	local v95 = React.useCallback(function() -- line: 483
		-- upvalues: v73 (copy), EventNames (copy), v66 (copy), FFlagSkipBlockModal (copy), v67 (copy), v69 (copy), AppPage (copy), ToastRodux (copy), v71 (copy), Blocking (copy), v68 (copy), t3 (copy)
		v73(EventNames.BlockPlayer, {
			profileUserId = v66.subjectUserId
		})

		if not FFlagSkipBlockModal or not v66.skipBlockModal then
			if v66.onBlockActivated then
				v66.onBlockActivated()

				return
			end

			v67(v66.closeCentralOverlayThunk())
			v69.push(AppPage.BlockingModal, {
				navProps = {
					userId = v66.subjectUserId,
					onBlockSuccess = function() -- line: 494
						-- upvalues: v67 (copy), ToastRodux (copy), v71 (copy)
						v67(ToastRodux.Actions.SetCurrentToastMessage({
							isLocalized = true,
							toastMessage = v71.UserBlocked,
							toastType = ToastRodux.Enums.ToastType.SuccessConfirmation
						}))
					end
				}
			})

			return
		end

		v67(Blocking.BlockUserById.API({
			userId = v66.subjectUserId,
			currentUserId = v68
		})):andThen(function() -- line: 509
			-- upvalues: v67 (copy), ToastRodux (copy), v71 (copy), v66 (copy)
			v67(ToastRodux.Actions.SetCurrentToastMessage({
				isLocalized = true,
				toastMessage = v71.UserBlocked,
				toastType = ToastRodux.Enums.ToastType.SuccessConfirmation
			}))
			v67(v66.closeCentralOverlayThunk())
		end):catch(function(_) -- line: 517
			-- upvalues: v67 (copy), ToastRodux (copy), t3 (copy)
			v67(ToastRodux.Actions.SetCurrentToastMessage(t3))
		end)
	end, {
		v71,
		v68,
		v67,
		v66.closeCentralOverlayThunk,
		v66.subjectUserId,
		v66.onBlockActivated,
		if not FFlagSkipBlockModal then nil else v66.skipBlockModal
	})
	local v96 = React.useCallback(function() -- line: 531
		-- upvalues: v67 (copy), Blocking (copy), v66 (copy), v68 (copy), ToastRodux (copy), t3 (copy)
		v67(Blocking.UnblockUserById.API({
			userId = v66.subjectUserId,
			currentUserId = v68
		})):andThen(function() -- line: 536
			-- upvalues: v67 (copy), v66 (copy)
			v67(v66.closeCentralOverlayThunk())
		end):catch(function(_) -- line: 539
			-- upvalues: v67 (copy), ToastRodux (copy), t3 (copy)
			v67(ToastRodux.Actions.SetCurrentToastMessage(t3))
		end)
	end, {
		v68,
		v67,
		v66.closeCentralOverlayThunk,
		v66.subjectUserId
	})
	local v97 = React.useCallback(function() -- line: 544
		-- upvalues: v73 (copy), EventNames (copy), v66 (copy), v67 (copy), Friends (copy), v68 (copy), ToastRodux (copy), v71 (copy), t3 (copy)
		v73(EventNames.Unfriend, {
			profileUserId = v66.subjectUserId
		})
		v67(Friends.UnfriendTargetUserId.API({
			targetUserId = v66.subjectUserId,
			currentUserId = v68
		})):andThen(function() -- line: 551
			-- upvalues: v67 (copy), ToastRodux (copy), v71 (copy), v66 (copy)
			v67(ToastRodux.Actions.SetCurrentToastMessage({
				isLocalized = true,
				toastMessage = v71.ConnectionRemoved,
				toastType = ToastRodux.Enums.ToastType.SuccessConfirmation
			}))
			v67(v66.closeCentralOverlayThunk())
		end):catch(function() -- line: 559
			-- upvalues: v67 (copy), ToastRodux (copy), t3 (copy)
			v67(ToastRodux.Actions.SetCurrentToastMessage(t3))
		end)
	end, {
		v71,
		v68,
		v67,
		v66.subjectUserId,
		v66.closeCentralOverlayThunk
	})
	local v98 = React.useCallback(function() -- line: 565
		-- upvalues: v73 (copy), EventNames (copy), v66 (copy), v67 (copy), RecommendationContextType (copy), Friends (copy), v68 (copy), ToastRodux (copy), v71 (copy), t3 (copy)
		v73(EventNames.RequestFriendship, {
			profileUserId = v66.subjectUserId
		})
		v67((if v66.recommendationContext ~= RecommendationContextType.Contacts or not v66.contactId then Friends.RequestFriendshipFromUserId.API({
			targetUserId = v66.subjectUserId,
			currentUserId = v68,
			friendshipOriginSourceType = v66.friendshipOriginSourceType
		}) else Friends.RequestFriendshipFromContactId.API({
			contactId = v66.contactId,
			currentUserId = v68
		}))):andThen(function() -- line: 577
			-- upvalues: v67 (copy), ToastRodux (copy), v71 (copy), v66 (copy)
			v67(ToastRodux.Actions.SetCurrentToastMessage({
				isLocalized = true,
				toastMessage = v71.ConnectionRequestSent,
				toastType = ToastRodux.Enums.ToastType.SuccessConfirmation
			}))
			v67(v66.closeCentralOverlayThunk())
		end):catch(function() -- line: 585
			-- upvalues: v67 (copy), ToastRodux (copy), t3 (copy)
			v67(ToastRodux.Actions.SetCurrentToastMessage(t3))
		end)
	end, {
		v71,
		v68,
		v67,
		v66.closeCentralOverlayThunk,
		v66.subjectUserId,
		v66.recommendationContext,
		v66.contactId,
		v66.friendshipOriginSourceType
	})
	local v99 = React.useCallback(function() -- line: 601
		-- upvalues: v73 (copy), EventNames (copy), v66 (copy), v67 (copy), Friends (copy), v68 (copy), ToastRodux (copy), v71 (copy), t3 (copy)
		v73(EventNames.AcceptFriendRequest, {
			profileUserId = v66.subjectUserId
		})
		v67(Friends.AcceptFriendRequestFromUserId.API({
			targetUserId = v66.subjectUserId,
			currentUserId = v68
		})):andThen(function() -- line: 608
			-- upvalues: v67 (copy), ToastRodux (copy), v71 (copy), v66 (copy)
			v67(ToastRodux.Actions.SetCurrentToastMessage({
				isLocalized = true,
				toastMessage = v71.ConnectionAdded,
				toastType = ToastRodux.Enums.ToastType.SuccessConfirmation
			}))
			v67(v66.closeCentralOverlayThunk())
		end):catch(function() -- line: 616
			-- upvalues: v67 (copy), ToastRodux (copy), t3 (copy)
			v67(ToastRodux.Actions.SetCurrentToastMessage(t3))
		end)
	end, {
		v71,
		v68,
		v67,
		v66.closeCentralOverlayThunk,
		v66.subjectUserId
	})
	local v100 = React.useCallback(function() -- line: 621
		-- upvalues: v73 (copy), EventNames (copy), v66 (copy), v67 (copy), Friends (copy), v68 (copy), ToastRodux (copy), v71 (copy), t3 (copy)
		v73(EventNames.IgnoreFriendRequest, {
			profileUserId = v66.subjectUserId
		})
		v67(Friends.DeclineFriendRequestFromUserId.API({
			targetUserId = v66.subjectUserId,
			currentUserId = v68
		})):andThen(function() -- line: 628
			-- upvalues: v67 (copy), ToastRodux (copy), v71 (copy), v66 (copy)
			v67(ToastRodux.Actions.SetCurrentToastMessage({
				isLocalized = true,
				toastMessage = v71.FriendRequestIgnored,
				toastType = ToastRodux.Enums.ToastType.SuccessConfirmation
			}))
			v67(v66.closeCentralOverlayThunk())
		end):catch(function() -- line: 636
			-- upvalues: v67 (copy), ToastRodux (copy), t3 (copy)
			v67(ToastRodux.Actions.SetCurrentToastMessage(t3))
		end)
	end, {
		v71,
		v68,
		v67,
		v66.closeCentralOverlayThunk,
		v66.subjectUserId
	})
	local v101 = RoactRodux.useSelector(function(p11) -- line: 641
		-- upvalues: FFlagUserBlockingApiPlayerContextMenuEnabled (copy), v66 (copy)
		return ((if not FFlagUserBlockingApiPlayerContextMenuEnabled then p11.PlayerContextualMenu.IsBlockedByMe else p11.PlayerContextualMenu.UserBlocking.isBlockedByMe))[v66.subjectUserId] or false
	end)
	local v102 = React.useMemo(function() -- line: 650
		-- upvalues: Images (copy), v71 (copy), v93 (copy), v49 (copy), v94 (copy), v95 (copy), u77 (ref), v96 (copy), v97 (copy), v98 (copy), NO_OPT_CALLBACK (copy), v99 (copy), v100 (copy), v101 (copy), v66 (copy), getFFlagAppChatPCMFixBlocking (copy), Cryo (copy), v53 (copy), s6 (ref), Dash (copy)
		local t4 = {
			icon = Images["icons/actions/feedback"],
			text = v71.Report,
			onActivated = v93
		}
		local t5 = {
			icon = v49,
			text = v71.ViewPlatformProfile,
			onActivated = v94
		}
		local t6 = {
			icon = Images["icons/actions/block"],
			text = v71.Block,
			onActivated = v95,
			disabled = u77
		}
		local t7 = {
			icon = Images["icons/actions/block"],
			text = v71.Unblock,
			onActivated = v96
		}
		local t8 = {
			icon = Images["icons/actions/friends/friendRemove"],
			text = v71.RemoveConnection,
			onActivated = v97
		}
		local t9 = {
			icon = Images["icons/actions/friends/friendAdd"],
			text = v71.AddConnection,
			onActivated = v98
		}
		local t10 = {
			icon = Images["icons/actions/friends/friendpending"],
			text = v71.PendingRequest,
			onActivated = NO_OPT_CALLBACK
		}
		local t11 = {
			icon = Images["icons/actions/friends/friendpending"],
			text = v71.AcceptConnection,
			onActivated = v99
		}
		local t12 = {
			icon = Images["icons/actions/reject"],
			text = v71.IgnoreConnectionRequest,
			onActivated = v100
		}

		local function makeCtas() -- line: 706
			-- upvalues: v101 (copy), t7 (copy), t6 (copy), v66 (copy), t4 (copy), getFFlagAppChatPCMFixBlocking (copy), t8 (copy), t9 (copy), t10 (copy), t11 (copy), t12 (copy), Cryo (copy)
			local v121 = if not v101 then t6 else t7
			local v122 = if v66.robloxFriendshipStatus ~= Enum.FriendStatus.Friend then if v66.robloxFriendshipStatus ~= Enum.FriendStatus.NotFriend then if v66.robloxFriendshipStatus ~= Enum.FriendStatus.FriendRequestSent then if v66.robloxFriendshipStatus ~= Enum.FriendStatus.FriendRequestReceived then {
				t4,
				v121
			} else {
				t11,
				t12,
				t4,
				v121
			} else {
				t10,
				t4,
				v121
			} else if not v66.contactId then {
				t9,
				t4,
				v121
			} else { t9 } else {
				t4,
				if not getFFlagAppChatPCMFixBlocking() then t6 else v121,
				t8
			}

			if v66.additionalButtons then
				v122 = Cryo.List.join(v122, v66.additionalButtons)
			end

			return v122
		end

		if v53 and (v53:IsProfileEnabled() and s6 and s6 ~= "") then
			return Dash.append({ t5 }, (makeCtas()))
		end

		return (makeCtas())
	end, Cryo.Dictionary.union(if not v53 then {
		v66.robloxFriendshipStatus,
		v101,
		v66.contactId,
		v66.additionalButtons
	} else {
		v66.robloxFriendshipStatus,
		v101,
		s6,
		v66.contactId,
		v66.additionalButtons
	}, if not getFFlagAppChatPCMFixBlocking() then {} else { u77 }))

	return React.createElement(PlayerContextualMenuComponent, {
		headerProps = React.useMemo(function() -- line: 783
			-- upvalues: s4 (ref), v79 (copy), v66 (copy), RecommendationContextType (copy), s3 (ref), s5 (ref), v84 (copy), v49 (copy), u87 (ref), u85 (ref), u86 (ref), v91 (copy), v92 (copy), v90 (copy)
			return {
				displayNameItem = {
					icon = nil,
					labelText = s4,
					isLoading = v79.loading
				},
				userNameItem = if v66.recommendationContext ~= RecommendationContextType.Contacts then {
					icon = nil,
					labelText = "@" .. s3,
					isLoading = v79.loading
				} else nil,
				vendorNameItem = if s5 ~= "" then {
					labelText = s5 or "",
					icon = v84 and {
						Image = v49,
						ImageRectOffset = Vector2.zero,
						ImageRectSize = Vector2.zero
					} or nil,
					isLoading = v79.loading
				} else nil,
				contextText = u87,
				contextIcon = u85,
				contextIconColor = if not u86 then nil else u86.Color3,
				contextIconTransparency = if not u86 then nil else u86.Transparency,
				joinEventText = v91,
				joinEventOnActivated = v92,
				renderJoinEventButton = v90
			}
		end, {
			v79,
			s4,
			s3,
			s5,
			v84,
			u85,
			u87,
			u86,
			v90,
			v91,
			v92,
			v66.recommendationContext
		}),
		buttonProps = v102,
		width = if not v51 then UDim.new(0, 400) else v66.width
	})
end

return PlayerContextualMenuContainer
