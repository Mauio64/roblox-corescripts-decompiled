local HttpService = game:GetService("HttpService")
local PlayerContextualMenu = script:FindFirstAncestor("PlayerContextualMenu")
local parent = PlayerContextualMenu.Parent
local Cryo = require(parent.Cryo)
local React = require(parent.React)
local UserProfiles = require(parent.UserProfiles)
local Http = require(parent.Http)
local Url = Http.Url
local RoactUtils = require(parent.RoactUtils)
local RoactRodux = RoactUtils.Hooks.RoactRodux
local RobloxAppHooks = require(parent.RobloxAppHooks)
local RobloxAppEnums = require(parent.RobloxAppEnums)
local AppPage = RobloxAppEnums.AppPage
local Localization = require(parent.Localization)
local useLocalization = Localization.Hooks.useLocalization
local ToastRodux = require(parent.ToastRodux)
local DiscoveryAnalytics = require(parent.DiscoveryAnalytics)
local Navigation = require(parent.Navigation)
local getCurrentRouteState = Navigation.getCurrentRouteState
local ExperienceService = require(parent.ExperienceService)
local experienceService = ExperienceService.ExperienceService
local RoactServiceTags = require(parent.RoactServiceTags)
local AppSessionService = RoactServiceTags.AppSessionService
local RobloxAppSessionization = require(parent.RobloxAppSessionization)
local Dash = require(parent.Dash)
local SetGamePlaySession = RobloxAppSessionization.SetGamePlaySession
local SessionType = RobloxAppSessionization.SessionType

local Loggers = require(parent.Loggers)
local v = Loggers.Logger:new(script.Name)

local SharedFlags = require(parent.SharedFlags)
local getFFlagAppChatPCMFixBlocking = SharedFlags.getFFlagAppChatPCMFixBlocking

local FriendsRodux = require(parent.FriendsRodux)
local recommendationContextType = FriendsRodux.config({ keyPath = "PlayerContextualMenu.Friends" }).Enums.RecommendationContextType

local SocialCommon = require(parent.SocialCommon)
local useRecommendationContextualInfoDisplay = SocialCommon.Hooks.useRecommendationContextualInfoDisplay

require(script.Parent.Types)
local getPresenceIcon = require(script.Parent.getPresenceIcon)
local getPresenceText = require(script.Parent.getPresenceText)

local UIBlox = require(parent.UIBlox)
local Images = UIBlox.App.ImageSet.Images
local Button = UIBlox.App.Button.Button
local ButtonType = UIBlox.App.Button.Enum.ButtonType

local Style = require(parent.Style)
local useDesignTokens = Style.useDesignTokens

local Analytics = require(PlayerContextualMenu.Analytics)
local setupFireEvent = Analytics.setupFireEvent
local EventNames = Analytics.EventNames
local AnalyticsService = Analytics.AnalyticsService

local Friends = require(PlayerContextualMenu.Http.Friends)
local Blocking = require(PlayerContextualMenu.Http.Blocking)
local PlayerContextualMenuComponent = require(PlayerContextualMenu.Components.PlayerContextualMenuComponent)
local useHttpRequest = require(script.Parent.HttpRequest.useHttpRequest)
local v2 = require(parent.FriendsNetworking)
v2 = v2.Enums

local DataHydration = require(parent.DataHydration)
local v3 = DataHydration.Friends.FriendsStore.get()

local FFlagUserProfileConsoleUseNewReportFlow = require(PlayerContextualMenu.Flags.FFlagUserProfileConsoleUseNewReportFlow)
local closeCentralOverlay, AbuseVector, OpenDynamicAbuseReport

if FFlagUserProfileConsoleUseNewReportFlow then
	local CentralOverlay = require(parent.CentralOverlay)
	closeCentralOverlay = CentralOverlay.Thunks.CloseCentralOverlay
	AbuseVector = require(parent.GenericAbuseReporting.AbuseVector)
	OpenDynamicAbuseReport = require(parent.GenericAbuseReporting.OpenDynamicAbuseReport)
else
	OpenDynamicAbuseReport = nil
	AbuseVector = nil
	closeCentralOverlay = nil
end

local defineFastString = game:DefineFastString(
	"PlayerContextualMenuVendorImagePath",
	"rbxasset://textures/ui/Shell/Icons/PlatformLogo.png"
)

local FFlagUserBlockingApiPlayerContextMenuEnabled = require(PlayerContextualMenu.Flags.FFlagUserBlockingApiPlayerContextMenuEnabled)
local SharedFlags2 = require(parent.SharedFlags)
local FFlagSkipBlockModal = SharedFlags2.FFlagSkipBlockModal

local SharedFlags3 = require(parent.SharedFlags)
local FFlagMigrateFriendshipStatusesRemainingActions = SharedFlags3.FFlagMigrateFriendshipStatusesRemainingActions
local PlatformFriendsService

if game:GetEngineFeature("PlatformFriendsService") and game:GetEngineFeature("PlatformFriendsProfile") then
	PlatformFriendsService = game:GetService("PlatformFriendsService")
else
	PlatformFriendsService = nil
end

local function NO_OPT_CALLBACK() end

local function launchGameWithAnalytics(callback, routeName: string, subjectUserId: string, subjectPresence, p)
	SetGamePlaySession(p, SessionType.StructuralIdentifier.GamePlayFromFriendsList, true)

	callback(EventNames.JoinExperience, { profileUserId = subjectUserId })

	local guid = HttpService:GenerateGUID(false)

	local gamePlayIntent = DiscoveryAnalytics.Events.gamePlayIntent
	local eventStream = AnalyticsService.EventStream
	local playerContextualMenu = DiscoveryAnalytics.Constants.Context.PlayerContextualMenu
	local placeId

	if subjectPresence then
		placeId = subjectPresence.locationPlaceId
	end

	local rootPlaceId

	if subjectPresence then
		rootPlaceId = subjectPresence.locationRootPlaceId
	end

	gamePlayIntent(eventStream, playerContextualMenu, {
		friendId = subjectUserId,
		pageName = routeName,
		placeId = placeId,
		rootPlaceId = rootPlaceId,
		joinAttemptId = guid
	})

	experienceService:LaunchExperience({ userId = subjectUserId, joinAttemptId = guid }, "PlayerContextualMenu")
end

local v4 = { enableExperienceCTAs = true, width = UDim.new(0, 400) }

local v5 = {
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

local function PlayerContextualMenuContainer(p)
	local union = Cryo.Dictionary.union(v4, p)
	local v6 = RoactRodux.useDispatch()
	local v7 = RobloxAppHooks.useLocalUserId()
	local v8 = Navigation.useNavigation()
	local v9 = RobloxAppHooks.useRoactService(AppSessionService)

	local v10 = useLocalization(v5)

	local v11 = {
		toastMessage = v10.SomethingIsWrong,
		isLocalized = true,
		toastType = ToastRodux.Enums.ToastType.NetworkingError
	}

	local v12 = React.useMemo(function()
		return setupFireEvent({
			analytics = AnalyticsService,
			infoForAllEvents = { uid = v7 }
		})
	end, { v7 })

	local v13 = useHttpRequest()
	local state, setState = React.useState({ status = "NotStarted", isPlayable = false })

	React.useEffect(function()
		if union.subjectPresence and union.subjectPresence.locationUniverseId then
			setState({ status = "Fetching", isPlayable = false })

			v13(
				Url.GAME_URL .. "v1/games/multiget-playability-status?universeIds=" .. union.subjectPresence.locationUniverseId,
				"GET"
			):andThen(function(p2)
				if p2.responseBody and p2.responseBody[1] then
					setState({ status = "Finished", isPlayable = p2.responseBody[1].isPlayable })
				end
			end):catch(function(_)
				setState({ status = "Failed", isPlayable = false })
			end)
		end
	end, { (tostring(union.subjectPresence)) })
	local disabled

	if getFFlagAppChatPCMFixBlocking() then
		disabled = RoactRodux.useSelector(function(p2): boolean
			local v14

			if FFlagUserBlockingApiPlayerContextMenuEnabled then
				v14 = p2.PlayerContextualMenu.UserBlocking.isBlockedByMe
			else
				v14 = p2.PlayerContextualMenu.IsBlockedByMe
			end

			return v14[union.subjectUserId] == nil
		end)

		React.useEffect(function()
			if disabled then
				v6(Blocking.IsBlockedById.API({ userId = union.subjectUserId })):andThen(function() end):catch(function()
					v:warning("Failed to check if subject user is blocked")
				end)
			end
		end, { disabled, v6, union.subjectUserId })
	else
		disabled = nil
	end

	local v14 = useDesignTokens(function(p2)
		return {
			iconEmphasis = p2.Color.Content.Emphasis,
			onlinePresence = p2.Color.System.Success,
			joinEventButtonHeight = p2.Size.Size_1200
		}
	end)

	local v15 = UserProfiles.Hooks.useUserProfilesFetch({
		userIds = { union.subjectUserId },
		query = UserProfiles.Queries.userProfilesDisplayUserPlatformNamesByUserIds
	})

	local v16 = ""
	local v17, v18, v19

	if v15.data then
		v17 = UserProfiles.Selectors.getUsernameFromId(v15.data, union.subjectUserId)
		v18 = UserProfiles.Selectors.getDisplayNameFromId(v15.data, union.subjectUserId)
		v19 = UserProfiles.Selectors.getPlatformNameFromId(v15.data, union.subjectUserId)

		if PlatformFriendsService then
			v16 = UserProfiles.Selectors.getPlatformProfileIdFromId(v15.data, union.subjectUserId)
		end
	else
		v19 = ""
		v18 = ""
		v17 = ""
	end

	local v20

	if v19 then
		v20 = v19 ~= ""
	else
		v20 = false
	end

	local contactName = union.recommendationContext == recommendationContextType.Contacts
		and (union.contactName or "")
		or v18

	local contextIcon, v21 = getPresenceIcon(union.subjectPresence, v14)

	if union.robloxFriendshipStatus ~= Enum.FriendStatus.Friend then
		contextIcon = nil
		v21 = nil
	end

	local contextText

	if union.robloxFriendshipStatus == Enum.FriendStatus.Friend then
		contextText = getPresenceText(union.subjectPresence)
	else
		contextText = nil
	end

	if union.recommendationContext then
		local v22 = useRecommendationContextualInfoDisplay({
			contextType = union.recommendationContext,
			mutualFriendsCount = union.mutualFriendsCount
		})

		contextText = v22.text
		contextIcon = v22.icon
	end

	local onActivated = React.useCallback(function()
		v12(EventNames.ViewExperienceDetails, { profileUserId = union.subjectUserId })

		v6(union.closeCentralOverlayThunk())

		if union.subjectPresence and union.subjectPresence.locationUniverseId then
			local locationUniverseId = tostring(union.subjectPresence.locationUniverseId)

			if v9 then
				SetGamePlaySession(v9, SessionType.StructuralIdentifier.GameDetailSource, false)
			end

			DiscoveryAnalytics.Events.gameDetailReferral(
				AnalyticsService.EventStream,
				DiscoveryAnalytics.Constants.Context.PlayerContextualMenu,
				{
					pg = getCurrentRouteState(v8).routeName,
					universeId = locationUniverseId,
					pid = union.subjectPresence.locationPlaceId,
					friendId = union.subjectUserId
				}
			)

			v8.navigate(AppPage.ExperienceDetail, { detail = locationUniverseId })
		end
	end, { v12, union.subjectUserId, union.closeCentralOverlayThunk, union.subjectPresence, v8, v9 })

	local renderJoinEventButton = React.useMemo(function()
		if not union.enableExperienceCTAs then
			return function()
				return React.createElement("Folder")
			end
		end

		local v22

		if union.subjectPresence then
			v22 = union.subjectPresence.status == "InGame"
		else
			v22 = false
		end

		if v22 and not state.isPlayable then
			return function()
				return React.createElement(Button, {
					buttonType = ButtonType.PrimarySystem,
					onActivated = onActivated,
					isLoading = false,
					size = UDim2.new(1, 0, 0, v14.joinEventButtonHeight),
					text = v10.ViewDetails,
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
		join = v10.Join
	else
		join = nil
	end

	local joinEventOnActivated = React.useCallback(function()
		launchGameWithAnalytics(v12, getCurrentRouteState(v8).routeName, union.subjectUserId, union.subjectPresence, v9)
	end, { v12, v8, union.subjectUserId, union.subjectPresence, v9 })

	local onActivated2 = React.useCallback(function()
		v12(EventNames.ReportPlayer, { profileUserId = union.subjectUserId })

		if union.onReportActivated then
			union.onReportActivated()
			return
		end

		v6(union.closeCentralOverlayThunk())

		if FFlagUserProfileConsoleUseNewReportFlow then
			v6(OpenDynamicAbuseReport({
				abuseVector = AbuseVector.UserProfile,
				targetId = union.subjectUserId,
				onClose = function()
					v6(closeCentralOverlay())
				end
			}))
		else
			v8.navigate(AppPage.ReportScreen, {
				reportData = {
					assetId = union.subjectUserId,
					reportAbuseVector = "user",
					context = "profile",
					platform = "console"
				}
			})
		end
	end, { v6, v8, union.subjectUserId, union.closeCentralOverlayThunk, union.onReportActivated })
	local onActivated3

	if PlatformFriendsService then
		onActivated3 = React.useCallback(function()
			v12(EventNames.ViewPlatformProfile, { profileUserId = union.subjectUserId })
			PlatformFriendsService:ShowProfile(v16)
		end, { v16, v6, v8, union.subjectUserId, union.closeCentralOverlayThunk })
	else
		onActivated3 = nil
	end

	local useCallback = React.useCallback
	local function fn()
		v12(EventNames.BlockPlayer, { profileUserId = union.subjectUserId })

		if FFlagSkipBlockModal and union.skipBlockModal then
			v6(Blocking.BlockUserById.API({ userId = union.subjectUserId, currentUserId = v7 })):andThen(function()
				v6(ToastRodux.Actions.SetCurrentToastMessage({
					toastMessage = v10.UserBlocked,
					isLocalized = true,
					toastType = ToastRodux.Enums.ToastType.SuccessConfirmation
				}))

				v6(union.closeCentralOverlayThunk())
			end):catch(function(_)
				v6(ToastRodux.Actions.SetCurrentToastMessage(v11))
			end)

			return
		end

		if union.onBlockActivated then
			union.onBlockActivated()
			return
		end

		v6(union.closeCentralOverlayThunk())
		v8.push(AppPage.BlockingModal, {
			navProps = {
				userId = union.subjectUserId,
				onBlockSuccess = function()
					v6(ToastRodux.Actions.SetCurrentToastMessage({
						toastMessage = v10.UserBlocked,
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
	local v22

	if FFlagSkipBlockModal then
		v22 = union.skipBlockModal
	end

	local onActivated4 = useCallback(fn, {
		v10,
		v7,
		v6,
		closeCentralOverlayThunk,
		subjectUserId,
		onBlockActivated,
		v22
	})

	local onActivated5 = React.useCallback(function()
		v6(Blocking.UnblockUserById.API({ userId = union.subjectUserId, currentUserId = v7 })):andThen(function()
			v6(union.closeCentralOverlayThunk())
		end):catch(function(_)
			v6(ToastRodux.Actions.SetCurrentToastMessage(v11))
		end)
	end, { v7, v6, union.closeCentralOverlayThunk, union.subjectUserId })

	local onActivated6 = React.useCallback(function()
		v12(EventNames.Unfriend, { profileUserId = union.subjectUserId })
		local v23

		if FFlagMigrateFriendshipStatusesRemainingActions then
			v23 = v3.Unfriend(union.subjectUserId)
		else
			v23 = v6(Friends.UnfriendTargetUserId.API({
				targetUserId = union.subjectUserId,
				currentUserId = v7
			}))
		end

		v23:andThen(function()
			v6(ToastRodux.Actions.SetCurrentToastMessage({
				toastMessage = v10.ConnectionRemoved,
				isLocalized = true,
				toastType = ToastRodux.Enums.ToastType.SuccessConfirmation
			}))

			v6(union.closeCentralOverlayThunk())
		end):catch(function()
			v6(ToastRodux.Actions.SetCurrentToastMessage(v11))
		end)
	end, { v10, v7, v6, union.subjectUserId, union.closeCentralOverlayThunk })

	local onActivated7 = React.useCallback(function()
		v12(EventNames.RequestFriendship, { profileUserId = union.subjectUserId })
		local contactId = union.contactId
		local v23

		if union.recommendationContext == recommendationContextType.Contacts then
			v23 = contactId
		else
			v23 = false
		end

		local v24

		if FFlagMigrateFriendshipStatusesRemainingActions then
			if v23 then
				v24 = v3.RequestFriendship(contactId, union.friendshipOriginSourceType, {
					isContact = true
				})
			else
				v24 = v3.RequestFriendship(union.subjectUserId, union.friendshipOriginSourceType)
			end
		else
			local v25

			if v23 then
				v25 = Friends.RequestFriendshipFromContactId.API({
					contactId = contactId,
					currentUserId = v7
				})
			else
				v25 = Friends.RequestFriendshipFromUserId.API({
					targetUserId = union.subjectUserId,
					currentUserId = v7,
					friendshipOriginSourceType = union.friendshipOriginSourceType
				})
			end

			v24 = v6(v25)
		end

		v24:andThen(function()
			v6(ToastRodux.Actions.SetCurrentToastMessage({
				toastMessage = v10.ConnectionRequestSent,
				isLocalized = true,
				toastType = ToastRodux.Enums.ToastType.SuccessConfirmation
			}))

			v6(union.closeCentralOverlayThunk())
		end):catch(function()
			v6(ToastRodux.Actions.SetCurrentToastMessage(v11))
		end)
	end, {
		v10,
		v7,
		v6,
		union.closeCentralOverlayThunk,
		union.subjectUserId,
		union.recommendationContext,
		union.contactId,
		union.friendshipOriginSourceType
	})

	local onActivated8 = React.useCallback(function()
		v12(EventNames.AcceptFriendRequest, { profileUserId = union.subjectUserId })
		local v23

		if FFlagMigrateFriendshipStatusesRemainingActions then
			v23 = v3.AcceptFriendRequest(union.subjectUserId)
		else
			v23 = v6(Friends.AcceptFriendRequestFromUserId.API({
				targetUserId = union.subjectUserId,
				currentUserId = v7
			}))
		end

		v23:andThen(function()
			v6(ToastRodux.Actions.SetCurrentToastMessage({
				toastMessage = v10.ConnectionAdded,
				isLocalized = true,
				toastType = ToastRodux.Enums.ToastType.SuccessConfirmation
			}))

			v6(union.closeCentralOverlayThunk())
		end):catch(function()
			v6(ToastRodux.Actions.SetCurrentToastMessage(v11))
		end)
	end, { v10, v7, v6, union.closeCentralOverlayThunk, union.subjectUserId })

	local onActivated9 = React.useCallback(function()
		v12(EventNames.IgnoreFriendRequest, { profileUserId = union.subjectUserId })
		local v23

		if FFlagMigrateFriendshipStatusesRemainingActions then
			v23 = v3.DeclineFriendRequest(union.subjectUserId)
		else
			v23 = v6(Friends.DeclineFriendRequestFromUserId.API({
				targetUserId = union.subjectUserId,
				currentUserId = v7
			}))
		end

		v23:andThen(function()
			v6(ToastRodux.Actions.SetCurrentToastMessage({
				toastMessage = v10.FriendRequestIgnored,
				isLocalized = true,
				toastType = ToastRodux.Enums.ToastType.SuccessConfirmation
			}))

			v6(union.closeCentralOverlayThunk())
		end):catch(function()
			v6(ToastRodux.Actions.SetCurrentToastMessage(v11))
		end)
	end, { v10, v7, v6, union.closeCentralOverlayThunk, union.subjectUserId })

	local v23 = RoactRodux.useSelector(function(p2)
		local v23

		if FFlagUserBlockingApiPlayerContextMenuEnabled then
			v23 = p2.PlayerContextualMenu.UserBlocking.isBlockedByMe
		else
			v23 = p2.PlayerContextualMenu.IsBlockedByMe
		end

		return v23[union.subjectUserId] or false
	end)

	local useMemo = React.useMemo
	local function fn2()
		local v24 = {
			icon = Images["icons/actions/feedback"],
			text = v10.Report,
			onActivated = onActivated2
		}

		local v25 = {
			icon = defineFastString,
			text = v10.ViewPlatformProfile,
			onActivated = onActivated3
		}

		local v26 = {
			icon = Images["icons/actions/block"],
			text = v10.Block,
			onActivated = onActivated4,
			disabled = disabled
		}

		local v27 = {
			icon = Images["icons/actions/block"],
			text = v10.Unblock,
			onActivated = onActivated5
		}

		local v28 = {
			icon = Images["icons/actions/friends/friendRemove"],
			text = v10.RemoveConnection,
			onActivated = onActivated6
		}

		local v29 = {
			icon = Images["icons/actions/friends/friendAdd"],
			text = v10.AddConnection,
			onActivated = onActivated7
		}

		local v30 = {
			icon = Images["icons/actions/friends/friendpending"],
			text = v10.PendingRequest,
			onActivated = NO_OPT_CALLBACK
		}

		local v31 = {
			icon = Images["icons/actions/friends/friendpending"],
			text = v10.AcceptConnection,
			onActivated = onActivated8
		}

		local v32 = {
			icon = Images["icons/actions/reject"],
			text = v10.IgnoreConnectionRequest,
			onActivated = onActivated9
		}

		local function makeCtas()
			local v48 = if v23 then v27 else v26
			local ctas

			if union.robloxFriendshipStatus == Enum.FriendStatus.Friend then
				ctas = { nil, nil, nil }

				if not getFFlagAppChatPCMFixBlocking() then
					v48 = v26
				end

				ctas[1], ctas[2], ctas[3] = v24, v48, v28
			elseif union.robloxFriendshipStatus == Enum.FriendStatus.NotFriend then
				if union.contactId then
					ctas = { v29 }
				else
					ctas = { v29, v24, v48 }
				end
			elseif union.robloxFriendshipStatus == Enum.FriendStatus.FriendRequestSent then
				ctas = { v30, v24, v48 }
			elseif union.robloxFriendshipStatus == Enum.FriendStatus.FriendRequestReceived then
				ctas = { v31, v32, v24, v48 }
			else
				ctas = { v24, v48 }
			end

			if union.additionalButtons then
				ctas = Cryo.List.join(ctas, union.additionalButtons)
			end

			return ctas
		end

		if PlatformFriendsService and PlatformFriendsService:IsProfileEnabled() and v16 and v16 ~= "" then
			return Dash.append({ v25 }, makeCtas())
		end

		return makeCtas()
	end

	local union2 = Cryo.Dictionary.union
	local v24

	if PlatformFriendsService then
		v24 = { union.robloxFriendshipStatus, v23, v16, union.contactId, union.additionalButtons }
	else
		v24 = { union.robloxFriendshipStatus, v23, union.contactId, union.additionalButtons }
	end

	local buttonProps = useMemo(fn2, union2(v24, getFFlagAppChatPCMFixBlocking() and { disabled } or {}))

	return React.createElement(PlayerContextualMenuComponent, {
		headerProps = React.useMemo(function()
			local v25 = {
				displayNameItem = { labelText = contactName, icon = nil, isLoading = v15.loading },
				userNameItem = union.recommendationContext ~= recommendationContextType.Contacts and {
					labelText = "@" .. v17,
					icon = nil,
					isLoading = v15.loading
				} or nil,
				vendorNameItem = v19 ~= "" and {
					labelText = v19 or "",
					icon = v20 and {
						Image = defineFastString,
						ImageRectOffset = Vector2.zero,
						ImageRectSize = Vector2.zero
					} or nil,
					isLoading = v15.loading
				} or nil,
				contextText = contextText,
				contextIcon = contextIcon,
				contextIconColor = 0,
				contextIconTransparency = 0,
				joinEventText = 0,
				joinEventOnActivated = 0,
				renderJoinEventButton = 0
			}
			local contextIconColor

			if v21 then
				contextIconColor = v21.Color3
			end

			v25.contextIconColor = contextIconColor
			local contextIconTransparency

			if v21 then
				contextIconTransparency = v21.Transparency
			end

			v25.contextIconTransparency = contextIconTransparency
			v25.joinEventText = join
			v25.joinEventOnActivated = joinEventOnActivated
			v25.renderJoinEventButton = renderJoinEventButton
			return v25
		end, {
			v15,
			contactName,
			v17,
			v19,
			v20,
			contextIcon,
			contextText,
			v21,
			renderJoinEventButton,
			join,
			joinEventOnActivated,
			union.recommendationContext
		}),
		buttonProps = buttonProps,
		width = union.width
	})
end

return PlayerContextualMenuContainer
