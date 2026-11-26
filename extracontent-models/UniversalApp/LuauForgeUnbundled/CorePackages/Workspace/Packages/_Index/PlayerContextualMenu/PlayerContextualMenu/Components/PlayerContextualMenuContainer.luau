local HttpService = game:GetService("HttpService")

local Cryo = require("@game/CorePackages/Workspace/Packages/_Workspace/PlayerContextualMenu/Cryo")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/PlayerContextualMenu/React")
local UserProfiles = require("@game/CorePackages/Workspace/Packages/_Index/PlayerContextualMenu/UserProfiles")
local url = require("@game/CorePackages/Workspace/Packages/_Workspace/PlayerContextualMenu/Http").Url
local roactRodux = require("@game/CorePackages/Workspace/Packages/_Workspace/PlayerContextualMenu/RoactUtils").Hooks.RoactRodux
local RobloxAppHooks = require("@game/CorePackages/Workspace/Packages/_Workspace/PlayerContextualMenu/RobloxAppHooks")
local appPage = require("@game/CorePackages/Workspace/Packages/_Workspace/PlayerContextualMenu/RobloxAppEnums").AppPage
local useLocalization = require("@game/CorePackages/Workspace/Packages/_Workspace/PlayerContextualMenu/Localization").Hooks.useLocalization
local ToastRodux = require("@game/CorePackages/Workspace/Packages/_Index/PlayerContextualMenu/ToastRodux")
local DiscoveryAnalytics = require("@game/CorePackages/Workspace/Packages/_Workspace/PlayerContextualMenu/DiscoveryAnalytics")
local Navigation = require("@game/CorePackages/Workspace/Packages/_Workspace/PlayerContextualMenu/Navigation")
local getCurrentRouteState = Navigation.getCurrentRouteState
local experienceService = require("@game/CorePackages/Workspace/Packages/_Workspace/PlayerContextualMenu/ExperienceService").ExperienceService
local appSessionService = require("@game/CorePackages/Workspace/Packages/_Workspace/PlayerContextualMenu/RoactServiceTags").AppSessionService
local RobloxAppSessionization = require("@game/CorePackages/Workspace/Packages/_Workspace/PlayerContextualMenu/RobloxAppSessionization")
local Dash = require("@game/CorePackages/Workspace/Packages/_Index/PlayerContextualMenu/Dash")
local setGamePlaySession = RobloxAppSessionization.SetGamePlaySession
local sessionType = RobloxAppSessionization.SessionType

local v5 = require("@game/CorePackages/Workspace/Packages/_Workspace/PlayerContextualMenu/Loggers").Logger:new("PlayerContextualMenuContainer")

local getFFlagAppChatPCMFixBlocking = require("@game/CorePackages/Workspace/Packages/_Workspace/PlayerContextualMenu/SharedFlags").getFFlagAppChatPCMFixBlocking

local recommendationContextType = require("@game/CorePackages/Workspace/Packages/_Workspace/PlayerContextualMenu/FriendsRodux").config({
	keyPath = "PlayerContextualMenu.Friends"
}).Enums.RecommendationContextType

local useRecommendationContextualInfoDisplay = require("@game/CorePackages/Workspace/Packages/_Workspace/PlayerContextualMenu/SocialCommon").Hooks.useRecommendationContextualInfoDisplay

require("@game/CorePackages/Workspace/Packages/_Index/PlayerContextualMenu/PlayerContextualMenu/Components/Types")
local getPresenceIcon = require("@game/CorePackages/Workspace/Packages/_Index/PlayerContextualMenu/PlayerContextualMenu/Components/getPresenceIcon")
local getPresenceText = require("@game/CorePackages/Workspace/Packages/_Index/PlayerContextualMenu/PlayerContextualMenu/Components/getPresenceText")

local UIBlox = require("@game/CorePackages/Workspace/Packages/_Workspace/PlayerContextualMenu/UIBlox")
local images = UIBlox.App.ImageSet.Images
local button = UIBlox.App.Button.Button
local buttonType = UIBlox.App.Button.Enum.ButtonType

local useDesignTokens = require("@game/CorePackages/Workspace/Packages/_Workspace/PlayerContextualMenu/Style").useDesignTokens

local Analytics = require("@game/CorePackages/Workspace/Packages/_Index/PlayerContextualMenu/PlayerContextualMenu/Analytics")
local setupFireEvent = Analytics.setupFireEvent
local eventNames = Analytics.EventNames
local analyticsService = Analytics.AnalyticsService

local Friends = require("@game/CorePackages/Workspace/Packages/_Index/PlayerContextualMenu/PlayerContextualMenu/Http/Friends")
local Blocking = require("@game/CorePackages/Workspace/Packages/_Index/PlayerContextualMenu/PlayerContextualMenu/Http/Blocking")
local PlayerContextualMenuComponent = require("@game/CorePackages/Workspace/Packages/_Index/PlayerContextualMenu/PlayerContextualMenu/Components/PlayerContextualMenuComponent")
local useHttpRequest = require("@game/CorePackages/Workspace/Packages/_Index/PlayerContextualMenu/PlayerContextualMenu/Components/HttpRequest/useHttpRequest")
local enums = require("@game/CorePackages/Workspace/Packages/_Workspace/PlayerContextualMenu/NetworkingFriends").Enums

local v6 = require("@game/CorePackages/Workspace/Packages/_Workspace/PlayerContextualMenu/DataHydration").Friends.FriendsStore.get()

local FFlagUserProfileConsoleUseNewReportFlow = require("@game/CorePackages/Workspace/Packages/_Index/PlayerContextualMenu/PlayerContextualMenu/Flags/FFlagUserProfileConsoleUseNewReportFlow")
local closeCentralOverlay, v7, v8

if FFlagUserProfileConsoleUseNewReportFlow then
	closeCentralOverlay = require("@game/CorePackages/Workspace/Packages/_Workspace/PlayerContextualMenu/CentralOverlay").Thunks.CloseCentralOverlay
	v7 = require("@game/CorePackages/Workspace/Packages/_Index/PlayerContextualMenu/GenericAbuseReporting/AbuseVector")
	v8 = require("@game/CorePackages/Workspace/Packages/_Index/PlayerContextualMenu/GenericAbuseReporting/OpenDynamicAbuseReport")
else
	v8 = nil
	v7 = nil
	closeCentralOverlay = nil
end

local defineFastString = game:DefineFastString(
	"PlayerContextualMenuVendorImagePath",
	"rbxasset://textures/ui/Shell/Icons/PlatformLogo.png"
)

local FFlagUserBlockingApiPlayerContextMenuEnabled = require("@game/CorePackages/Workspace/Packages/_Index/PlayerContextualMenu/PlayerContextualMenu/Flags/FFlagUserBlockingApiPlayerContextMenuEnabled")
local fFlagSkipBlockModal = require("@game/CorePackages/Workspace/Packages/_Workspace/PlayerContextualMenu/SharedFlags").FFlagSkipBlockModal

local fFlagMigrateFriendshipStatusesRemainingActions = require("@game/CorePackages/Workspace/Packages/_Workspace/PlayerContextualMenu/SharedFlags").FFlagMigrateFriendshipStatusesRemainingActions
local PlatformFriendsService

if game:GetEngineFeature("PlatformFriendsService") and game:GetEngineFeature("PlatformFriendsProfile") then
	PlatformFriendsService = game:GetService("PlatformFriendsService")
else
	PlatformFriendsService = nil
end

local function NO_OPT_CALLBACK() end

local function launchGameWithAnalytics(callback, routeName, subjectUserId, subjectPresence, p2)
	setGamePlaySession(p2, sessionType.StructuralIdentifier.GamePlayFromFriendsList, true)

	callback(eventNames.JoinExperience, { profileUserId = subjectUserId })

	local guid = HttpService:GenerateGUID(false)

	local gamePlayIntent = DiscoveryAnalytics.Events.gamePlayIntent
	local eventStream = analyticsService.EventStream
	local playerContextualMenu = DiscoveryAnalytics.Constants.Context.PlayerContextualMenu

	local v10 = if subjectPresence then subjectPresence.locationPlaceId else nil
	local v11 = if subjectPresence then subjectPresence.locationRootPlaceId else nil
	gamePlayIntent(eventStream, playerContextualMenu, {
		friendId = subjectUserId,
		pageName = routeName,
		placeId = v10,
		rootPlaceId = v11,
		joinAttemptId = guid
	})

	experienceService:LaunchExperience(
		{ userId = subjectUserId, joinAttemptId = guid },
		"PlayerContextualMenu"
	)
end

local v9 = { enableExperienceCTAs = true, width = UDim.new(0, 400) }

local v10 = {
	AcceptConnection = "Feature.Friends.Action.AcceptFriend",
	AddConnection = "Feature.Profile.Label.AddFriend",
	IgnoreConnectionRequest = "Feature.AddFriends.Action.IgnoreFriendRequest",
	RemoveConnection = "Feature.Friends.Action.Unfriend",
	Block = "Feature.Friends.Action.Block",
	Unblock = "Feature.Friends.Action.Unblock",
	Chat = "CommonUI.Features.Label.Chat",
	Join = "Feature.Chat.Drawer.Join",
	PendingRequest = "Feature.Friends.Action.PendingRequest",
	Report = "Feature.Catalog.Action.Report",
	ViewDetails = "Feature.Profile.Label.ViewDetails",
	ViewPlatformProfile = "Feature.Friends.Action.ViewPlatformProfile",
	ConnectionAdded = "Feature.Friends.Action.FriendAdded",
	ConnectionRequestSent = "Feature.Friends.Action.FriendRequestSent",
	ConnectionRemoved = "Feature.Friends.Action.FriendRemoved",
	FriendRequestIgnored = "Feature.AddFriends.Action.RequestIgnored",
	SomethingIsWrong = "Feature.Toast.NetworkingError.SomethingIsWrong",
	UserBlocked = "Feature.Profile.Action.UserBlocked"
}

local function PlayerContextualMenuContainer(p2)
	local union = Cryo.Dictionary.union(v9, p2)
	local v11 = roactRodux.useDispatch()
	local v12 = RobloxAppHooks.useLocalUserId()
	local v13 = Navigation.useNavigation()
	local v14 = RobloxAppHooks.useRoactService(appSessionService)

	local v15 = useLocalization(v10)

	local v16 = {
		toastMessage = v15.SomethingIsWrong,
		isLocalized = true,
		toastType = ToastRodux.Enums.ToastType.NetworkingError
	}

	local v17 = React.useMemo(function()
		return setupFireEvent({
			analytics = analyticsService,
			infoForAllEvents = { uid = v12 }
		})
	end, { v12 })

	local v18 = useHttpRequest()
	local state, setState = React.useState({
		status = "NotStarted",
		isPlayable = false
	})

	React.useEffect(function()
		if union.subjectPresence and union.subjectPresence.locationUniverseId then
			setState({ status = "Fetching", isPlayable = false })

			v18(
				url.GAME_URL .. "v1/games/multiget-playability-status?universeIds=" .. union.subjectPresence.locationUniverseId,
				"GET"
			):andThen(function(p3)
				if p3.responseBody and p3.responseBody[1] then
					setState({
						status = "Finished",
						isPlayable = p3.responseBody[1].isPlayable
					})
				end
			end):catch(function(p3)
				setState({ status = "Failed", isPlayable = false })
			end)
		end
	end, { (tostring(union.subjectPresence)) })
	local v19

	if getFFlagAppChatPCMFixBlocking() then
		v19 = roactRodux.useSelector(function(p3): boolean
			return (if FFlagUserBlockingApiPlayerContextMenuEnabled then p3.PlayerContextualMenu.UserBlocking.isBlockedByMe else p3.PlayerContextualMenu.IsBlockedByMe)[union.subjectUserId] == nil
		end)

		React.useEffect(function()
			if v19 then
				v11(Blocking.IsBlockedById.API({ userId = union.subjectUserId })):andThen(function() end):catch(function()
					v5:warning("Failed to check if subject user is blocked")
				end)
			end
		end, { v19, v11, union.subjectUserId })
	else
		v19 = nil
	end

	local v20 = useDesignTokens(function(p3)
		return {
			iconEmphasis = p3.Color.Content.Emphasis,
			onlinePresence = p3.Color.System.Success,
			joinEventButtonHeight = p3.Size.Size_1200
		}
	end)

	local v21 = UserProfiles.Hooks.useUserProfilesFetch({
		userIds = { union.subjectUserId },
		query = UserProfiles.Queries.userProfilesDisplayUserPlatformNamesByUserIds
	})

	local v22 = ""
	local v23, v24, v25

	if v21.data then
		v23 = UserProfiles.Selectors.getUsernameFromId(v21.data, union.subjectUserId)
		v24 = UserProfiles.Selectors.getDisplayNameFromId(v21.data, union.subjectUserId)
		v25 = UserProfiles.Selectors.getPlatformNameFromId(v21.data, union.subjectUserId)

		if PlatformFriendsService then
			v22 = UserProfiles.Selectors.getPlatformProfileIdFromId(v21.data, union.subjectUserId)
		end
	else
		v25 = ""
		v24 = ""
		v23 = ""
	end

	local v26 = if v25 then v25 ~= "" else false
	local contactName = union.recommendationContext == recommendationContextType.Contacts
		and (union.contactName or "")
		or v24

	local v27, v28 = getPresenceIcon(union.subjectPresence, v20)

	if union.robloxFriendshipStatus ~= Enum.FriendStatus.Friend then
		v27 = nil
		v28 = nil
	end

	local v29

	if union.robloxFriendshipStatus == Enum.FriendStatus.Friend then
		v29 = getPresenceText(union.subjectPresence)
	else
		v29 = nil
	end

	if union.recommendationContext then
		local v30 = useRecommendationContextualInfoDisplay({
			contextType = union.recommendationContext,
			mutualFriendsCount = union.mutualFriendsCount
		})

		v29 = v30.text
		v27 = v30.icon
	end

	local v30 = React.useCallback(function()
		v17(eventNames.ViewExperienceDetails, { profileUserId = union.subjectUserId })

		v11(union.closeCentralOverlayThunk())

		if union.subjectPresence and union.subjectPresence.locationUniverseId then
			local locationUniverseId = tostring(union.subjectPresence.locationUniverseId)

			if v14 then
				setGamePlaySession(v14, sessionType.StructuralIdentifier.GameDetailSource, false)
			end

			DiscoveryAnalytics.Events.gameDetailReferral(
				analyticsService.EventStream,
				DiscoveryAnalytics.Constants.Context.PlayerContextualMenu,
				{
					pg = getCurrentRouteState(v13).routeName,
					universeId = locationUniverseId,
					pid = union.subjectPresence.locationPlaceId,
					friendId = union.subjectUserId
				}
			)

			v13.navigate(appPage.ExperienceDetail, { detail = locationUniverseId })
		end
	end, {
		v17,
		union.subjectUserId,
		union.closeCentralOverlayThunk,
		union.subjectPresence,
		v13,
		v14
	})

	local v31 = React.useMemo(function()
		if not union.enableExperienceCTAs then
			return function()
				return React.createElement("Folder")
			end
		end

		local v32 = if union.subjectPresence then union.subjectPresence.status == "InGame" else false

		if v32 and not state.isPlayable then
			return function()
				return React.createElement(button, {
					buttonType = buttonType.PrimarySystem,
					onActivated = v30,
					isLoading = false,
					size = UDim2.new(1, 0, 0, v20.joinEventButtonHeight),
					text = v15.ViewDetails,
					layoutOrder = 100
				})
			end
		end

		return nil
	end, { state, tostring(union.subjectPresence), union.enableExperienceCTAs })
	local join

	if
		union.robloxFriendshipStatus == Enum.FriendStatus.Friend
		and union.subjectPresence
		and union.subjectPresence.status == "InGame"
	then
		join = v15.Join
	else
		join = nil
	end

	local v32 = React.useCallback(function()
		launchGameWithAnalytics(
			v17,
			getCurrentRouteState(v13).routeName,
			union.subjectUserId,
			union.subjectPresence,
			v14
		)
	end, { v17, v13, union.subjectUserId, union.subjectPresence, v14 })

	local v33 = React.useCallback(function()
		v17(eventNames.ReportPlayer, { profileUserId = union.subjectUserId })

		if union.onReportActivated then
			union.onReportActivated()
			return
		end

		v11(union.closeCentralOverlayThunk())

		if FFlagUserProfileConsoleUseNewReportFlow then
			v11(v8({
				abuseVector = v7.UserProfile,
				targetId = union.subjectUserId,
				onClose = function()
					v11(closeCentralOverlay())
				end
			}))
		else
			v13.navigate(appPage.ReportScreen, {
				reportData = {
					assetId = union.subjectUserId,
					reportAbuseVector = "user",
					context = "profile",
					platform = "console"
				}
			})
		end
	end, {
		v11,
		v13,
		union.subjectUserId,
		union.closeCentralOverlayThunk,
		union.onReportActivated
	})
	local v34

	if PlatformFriendsService then
		v34 = React.useCallback(function()
			v17(eventNames.ViewPlatformProfile, { profileUserId = union.subjectUserId })
			PlatformFriendsService:ShowProfile(v22)
		end, { v22, v11, v13, union.subjectUserId, union.closeCentralOverlayThunk })
	else
		v34 = nil
	end

	local useCallback = React.useCallback
	local function fn()
		v17(eventNames.BlockPlayer, { profileUserId = union.subjectUserId })

		if fFlagSkipBlockModal and union.skipBlockModal then
			v11(Blocking.BlockUserById.API({
				userId = union.subjectUserId,
				currentUserId = v12
			})):andThen(function()
				v11(ToastRodux.Actions.SetCurrentToastMessage({
					toastMessage = v15.UserBlocked,
					isLocalized = true,
					toastType = ToastRodux.Enums.ToastType.SuccessConfirmation
				}))

				v11(union.closeCentralOverlayThunk())
			end):catch(function(p3)
				v11(ToastRodux.Actions.SetCurrentToastMessage(v16))
			end)

			return
		end

		if union.onBlockActivated then
			union.onBlockActivated()
			return
		end

		v11(union.closeCentralOverlayThunk())
		v13.push(appPage.BlockingModal, {
			navProps = {
				userId = union.subjectUserId,
				onBlockSuccess = function()
					v11(ToastRodux.Actions.SetCurrentToastMessage({
						toastMessage = v15.UserBlocked,
						isLocalized = true,
						toastType = ToastRodux.Enums.ToastType.SuccessConfirmation
					}))
				end
			}
		})
	end

	local closeCentralOverlayThunk = union.closeCentralOverlayThunk
	local subjectUserId = union.subjectUserId
	local onBlockActivated = union.onBlockActivated
	local v36 = if fFlagSkipBlockModal then union.skipBlockModal else nil
	local v37 = useCallback(fn, {
		v15,
		v12,
		v11,
		closeCentralOverlayThunk,
		subjectUserId,
		onBlockActivated,
		v36
	})

	local v38 = React.useCallback(function()
		v11(Blocking.UnblockUserById.API({
			userId = union.subjectUserId,
			currentUserId = v12
		})):andThen(function()
			v11(union.closeCentralOverlayThunk())
		end):catch(function(p3)
			v11(ToastRodux.Actions.SetCurrentToastMessage(v16))
		end)
	end, { v12, v11, union.closeCentralOverlayThunk, union.subjectUserId })

	local v39 = React.useCallback(function()
		v17(eventNames.Unfriend, { profileUserId = union.subjectUserId })
		local v40

		if fFlagMigrateFriendshipStatusesRemainingActions then
			v40 = v6.Unfriend(union.subjectUserId)
		else
			v40 = v11(Friends.UnfriendTargetUserId.API({
				targetUserId = union.subjectUserId,
				currentUserId = v12
			}))
		end

		v40:andThen(function()
			v11(ToastRodux.Actions.SetCurrentToastMessage({
				toastMessage = v15.ConnectionRemoved,
				isLocalized = true,
				toastType = ToastRodux.Enums.ToastType.SuccessConfirmation
			}))

			v11(union.closeCentralOverlayThunk())
		end):catch(function()
			v11(ToastRodux.Actions.SetCurrentToastMessage(v16))
		end)
	end, { v15, v12, v11, union.subjectUserId, union.closeCentralOverlayThunk })

	local v40 = React.useCallback(function()
		v17(eventNames.RequestFriendship, { profileUserId = union.subjectUserId })
		local contactId = union.contactId
		local v41 = union.recommendationContext == recommendationContextType.Contacts and contactId
		local v42

		if fFlagMigrateFriendshipStatusesRemainingActions then
			if v41 then
				v42 = v6.RequestFriendship(contactId, union.friendshipOriginSourceType, {
					isContact = true
				})
			else
				v42 = v6.RequestFriendship(union.subjectUserId, union.friendshipOriginSourceType)
			end
		else
			local v44

			if v41 then
				v44 = Friends.RequestFriendshipFromContactId.API({
					contactId = contactId,
					currentUserId = v12
				})
			else
				v44 = Friends.RequestFriendshipFromUserId.API({
					targetUserId = union.subjectUserId,
					currentUserId = v12,
					friendshipOriginSourceType = union.friendshipOriginSourceType
				})
			end

			v42 = v11(v44)
		end

		v42:andThen(function()
			v11(ToastRodux.Actions.SetCurrentToastMessage({
				toastMessage = v15.ConnectionRequestSent,
				isLocalized = true,
				toastType = ToastRodux.Enums.ToastType.SuccessConfirmation
			}))

			v11(union.closeCentralOverlayThunk())
		end):catch(function()
			v11(ToastRodux.Actions.SetCurrentToastMessage(v16))
		end)
	end, {
		v15,
		v12,
		v11,
		union.closeCentralOverlayThunk,
		union.subjectUserId,
		union.recommendationContext,
		union.contactId,
		union.friendshipOriginSourceType
	})

	local v41 = React.useCallback(function()
		v17(eventNames.AcceptFriendRequest, { profileUserId = union.subjectUserId })
		local v42

		if fFlagMigrateFriendshipStatusesRemainingActions then
			v42 = v6.AcceptFriendRequest(union.subjectUserId)
		else
			v42 = v11(Friends.AcceptFriendRequestFromUserId.API({
				targetUserId = union.subjectUserId,
				currentUserId = v12
			}))
		end

		v42:andThen(function()
			v11(ToastRodux.Actions.SetCurrentToastMessage({
				toastMessage = v15.ConnectionAdded,
				isLocalized = true,
				toastType = ToastRodux.Enums.ToastType.SuccessConfirmation
			}))

			v11(union.closeCentralOverlayThunk())
		end):catch(function()
			v11(ToastRodux.Actions.SetCurrentToastMessage(v16))
		end)
	end, { v15, v12, v11, union.closeCentralOverlayThunk, union.subjectUserId })

	local v42 = React.useCallback(function()
		v17(eventNames.IgnoreFriendRequest, { profileUserId = union.subjectUserId })
		local v43

		if fFlagMigrateFriendshipStatusesRemainingActions then
			v43 = v6.DeclineFriendRequest(union.subjectUserId)
		else
			v43 = v11(Friends.DeclineFriendRequestFromUserId.API({
				targetUserId = union.subjectUserId,
				currentUserId = v12
			}))
		end

		v43:andThen(function()
			v11(ToastRodux.Actions.SetCurrentToastMessage({
				toastMessage = v15.FriendRequestIgnored,
				isLocalized = true,
				toastType = ToastRodux.Enums.ToastType.SuccessConfirmation
			}))

			v11(union.closeCentralOverlayThunk())
		end):catch(function()
			v11(ToastRodux.Actions.SetCurrentToastMessage(v16))
		end)
	end, { v15, v12, v11, union.closeCentralOverlayThunk, union.subjectUserId })

	local v43 = roactRodux.useSelector(function(p3)
		return (if FFlagUserBlockingApiPlayerContextMenuEnabled then p3.PlayerContextualMenu.UserBlocking.isBlockedByMe else p3.PlayerContextualMenu.IsBlockedByMe)[union.subjectUserId]
			or false
	end)

	local useMemo = React.useMemo
	local function fn2()
		local v44 = {
			icon = images["icons/actions/feedback"],
			text = v15.Report,
			onActivated = v33
		}

		local v45 = {
			icon = defineFastString,
			text = v15.ViewPlatformProfile,
			onActivated = v34
		}

		local v46 = {
			icon = images["icons/actions/block"],
			text = v15.Block,
			onActivated = v37,
			disabled = v19
		}

		local v47 = {
			icon = images["icons/actions/block"],
			text = v15.Unblock,
			onActivated = v38
		}

		local v48 = {
			icon = images["icons/actions/friends/friendRemove"],
			text = v15.RemoveConnection,
			onActivated = v39
		}

		local v49 = {
			icon = images["icons/actions/friends/friendAdd"],
			text = v15.AddConnection,
			onActivated = v40
		}

		local v50 = {
			icon = images["icons/actions/friends/friendpending"],
			text = v15.PendingRequest,
			onActivated = NO_OPT_CALLBACK
		}

		local v51 = {
			icon = images["icons/actions/friends/friendpending"],
			text = v15.AcceptConnection,
			onActivated = v41
		}

		local v52 = {
			icon = images["icons/actions/reject"],
			text = v15.IgnoreConnectionRequest,
			onActivated = v42
		}

		local function makeCtas()
			local v53 = if v43 then v47 else v46
			local ctas

			if union.robloxFriendshipStatus == Enum.FriendStatus.Friend then
				ctas = { nil, nil, nil }

				if not getFFlagAppChatPCMFixBlocking() then
					v53 = v46
				end

				ctas[1], ctas[2], ctas[3] = v44, v53, v48
			elseif union.robloxFriendshipStatus == Enum.FriendStatus.NotFriend then
				if union.contactId then
					ctas = { v49 }
				else
					ctas = { v49, v44, v53 }
				end
			elseif union.robloxFriendshipStatus == Enum.FriendStatus.FriendRequestSent then
				ctas = { v50, v44, v53 }
			elseif union.robloxFriendshipStatus == Enum.FriendStatus.FriendRequestReceived then
				ctas = { v51, v52, v44, v53 }
			else
				ctas = { v44, v53 }
			end

			if union.additionalButtons then
				ctas = Cryo.List.join(ctas, union.additionalButtons)
			end

			return ctas
		end

		if PlatformFriendsService and PlatformFriendsService:IsProfileEnabled() and v22 and v22 ~= "" then
			return Dash.append({ v45 }, makeCtas())
		end

		return makeCtas()
	end

	local union2 = Cryo.Dictionary.union
	local v44

	if PlatformFriendsService then
		v44 = {
			union.robloxFriendshipStatus,
			v43,
			v22,
			union.contactId,
			union.additionalButtons
		}
	else
		v44 = {
			union.robloxFriendshipStatus,
			v43,
			union.contactId,
			union.additionalButtons
		}
	end

	local v45 = useMemo(fn2, union2(v44, getFFlagAppChatPCMFixBlocking() and { v19 } or {}))

	return React.createElement(PlayerContextualMenuComponent, {
		headerProps = React.useMemo(function()
			local v46 = {
				displayNameItem = {
					labelText = contactName,
					icon = nil,
					isLoading = v21.loading
				},
				userNameItem = union.recommendationContext ~= recommendationContextType.Contacts and {
					labelText = "@" .. v23,
					icon = nil,
					isLoading = v21.loading
				} or nil,
				vendorNameItem = v25 ~= "" and {
					labelText = v25 or "",
					icon = v26 and {
						Image = defineFastString,
						ImageRectOffset = Vector2.zero,
						ImageRectSize = Vector2.zero
					} or nil,
					isLoading = v21.loading
				} or nil,
				contextText = v29,
				contextIcon = v27,
				contextIconColor = 0,
				contextIconTransparency = 0,
				joinEventText = 0,
				joinEventOnActivated = 0,
				renderJoinEventButton = 0
			}

			local v47 = if v28 then v28.Color3 else nil
			v46.contextIconColor = v47
			local v48 = if v28 then v28.Transparency else nil
			v46.contextIconTransparency = v48
			v46.joinEventText = join
			v46.joinEventOnActivated = v32
			v46.renderJoinEventButton = v31
			return v46
		end, {
			v21,
			contactName,
			v23,
			v25,
			v26,
			v27,
			v29,
			v28,
			v31,
			join,
			v32,
			union.recommendationContext
		}),
		buttonProps = v45,
		width = union.width
	})
end

return PlayerContextualMenuContainer
