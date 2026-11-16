local Players = game:GetService("Players")

local UserRelationshipModals = script:FindFirstAncestor("UserRelationshipModals")
local parent = UserRelationshipModals.Parent

local React = require(parent.React)
local useEffect = React.useEffect
local Signals = require(parent.Signals)
local SignalsReact = require(parent.SignalsReact)
local RoactUtils = require(parent.RoactUtils)
local useDispatch = RoactUtils.Hooks.RoactRodux.useDispatch

local RobloxAppHooks = require(parent.RobloxAppHooks)
local useLocalUserId = RobloxAppHooks.useLocalUserId

local UserProfiles = require(parent.UserProfiles)

local FriendsNetworking = require(parent.FriendsNetworking)
local myFriendsNetworking = require(UserRelationshipModals.Networking.myFriendsNetworking)
local FriendshipOriginSourceType = FriendsNetworking.Enums.FriendshipOriginSourceType

local SharedFlags = require(parent.SharedFlags)
local FFlagMigrateFriendshipStatusesRemainingActions = SharedFlags.FFlagMigrateFriendshipStatusesRemainingActions
local DataHydration = require(parent.DataHydration)
local v = DataHydration.Friends.FriendsStore.get()
local DataHydration2 = require(parent.DataHydration)
local Enums = DataHydration2.Friends.Enums

local Analytics = require(UserRelationshipModals.Analytics)
local Localization = require(parent.Localization)
local useLocalization = Localization.Hooks.useLocalization

local NotificationModalsManager = require(parent.NotificationModalsManager)

local PromptFriendRequestModal = require(script.Parent.PromptFriendRequestModal)

function triggerToast(toastTitle: string)
	NotificationModalsManager.SetUIBloxToast({
		toastTitle = toastTitle,
		sequenceNumber = DateTime.now().UnixTimestamp
	})
end

local v2 = UserProfiles.Stores.UserProfileStore.get()

local function PromptFriendRequestModalContainer(props)
	local v3 = useDispatch()
	local currentUserId = useLocalUserId()

	local fireAnalyticsEvent = Analytics.useUserRelationshipModalAnalytics(
		Analytics.RelationshipTypes.Friends,
		tonumber(currentUserId) or 0,
		props.userId
	).fireAnalyticsEvent

	useEffect(function()
		fireAnalyticsEvent(Analytics.EventNames.ModalSeen)
	end, { fireAnalyticsEvent })

	local v4 = useLocalization({
		friendRequestSent = "Feature.Friends.Action.FriendRequestSent",
		somethingWentWrong = "CommonUI.Messages.Response.SomethingWentWrong"
	})

	local v5 = React.useMemo(function()
		return Signals.createComputed(function(p)
			local v5 = v2.fetchNamesByUserIds({ (tostring(props.userId)) })(p)
			local v6 = v5 and v5.data and v5.data[1]
			local names = v6 and v6.names
			return {
				combinedName = not names and "" or names.getCombinedName(p),
				username = not names and "" or names.getUsername()
			}
		end)
	end, { props.userId })

	local v6 = SignalsReact.useSignalState(v5)

	local onSendClicked = React.useCallback(function()
		fireAnalyticsEvent(Analytics.EventNames.CreateActionPressed)

		local playerByUserId = Players:GetPlayerByUserId(props.userId)

		if Players.LocalPlayer == nil or playerByUserId == nil then
			local v7

			if FFlagMigrateFriendshipStatusesRemainingActions then
				v7 = v.RequestFriendship(tostring(props.userId), Enums.FriendshipOriginSourceType.InGame)
			else
				v7 = v3(myFriendsNetworking.RequestFriendshipFromUserId.API({
					currentUserId = currentUserId,
					targetUserId = tostring(props.userId),
					friendshipOriginSourceType = FriendshipOriginSourceType.InGame.rawValue()
				}))
			end

			v7:andThen(function()
				triggerToast(v4.friendRequestSent)
			end):catch(function(_)
				triggerToast(v4.somethingWentWrong)
			end)
		else
			local success, _ = pcall(function()
				Players.LocalPlayer:RequestFriendship(playerByUserId)
			end)
			local triggerToast = triggerToast
			local v7

			if success then
				v7 = v4.friendRequestSent
			else
				v7 = v4.somethingWentWrong
			end

			triggerToast(v7)
		end

		props.onClose()
	end, {
		currentUserId,
		props.userId,
		v3,
		props.onClose,
		v4.friendRequestSent,
		v4.somethingWentWrong,
		fireAnalyticsEvent
	})

	return React.createElement(PromptFriendRequestModal, {
		userId = props.userId,
		displayName = v6.combinedName,
		username = v6.username,
		onClose = function()
			fireAnalyticsEvent(Analytics.EventNames.ModalClosed)
			props.onClose()
		end,
		onSendClicked = onSendClicked,
		inputDelay = props.inputDelay
	})
end

return PromptFriendRequestModalContainer
