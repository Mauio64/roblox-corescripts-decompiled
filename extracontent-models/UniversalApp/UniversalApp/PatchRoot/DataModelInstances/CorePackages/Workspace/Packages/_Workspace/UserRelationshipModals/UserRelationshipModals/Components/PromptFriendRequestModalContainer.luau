local Players = game:GetService("Players")
local UserRelationshipModals = script:FindFirstAncestor("UserRelationshipModals")
local UserRelationshipModalsParent = UserRelationshipModals.Parent
local React = require(UserRelationshipModalsParent.React)
local useEffect = React.useEffect
local Signals = require(UserRelationshipModalsParent.Signals)
local SignalsReact = require(UserRelationshipModalsParent.SignalsReact)
local useDispatch = require(UserRelationshipModalsParent.RoactUtils).Hooks.RoactRodux.useDispatch
local useLocalUserId = require(UserRelationshipModalsParent.RobloxAppHooks).useLocalUserId
local UserProfiles = require(UserRelationshipModalsParent.UserProfiles)
local FriendsNetworking = require(UserRelationshipModalsParent.FriendsNetworking)
local myFriendsNetworking = require(UserRelationshipModals.Networking.myFriendsNetworking)
local FriendshipOriginSourceType = FriendsNetworking.Enums.FriendshipOriginSourceType
local Analytics = require(UserRelationshipModals.Analytics)
local useLocalization = require(UserRelationshipModalsParent.Localization).Hooks.useLocalization
local NotificationModalsManager = require(UserRelationshipModalsParent.NotificationModalsManager)
local PromptFriendRequestModal = require(script.Parent.PromptFriendRequestModal)

function triggerToast(s1: string) -- line: 29
	-- upvalues: NotificationModalsManager (copy)
	NotificationModalsManager.SetUIBloxToast({
		toastTitle = s1,
		sequenceNumber = DateTime.now().UnixTimestamp
	})
end

local v18 = UserProfiles.Stores.UserProfileStore.get()

local function PromptFriendRequestModalContainer(t1: {[any]: any}) -- line: 44
	-- upvalues: useDispatch (copy), useLocalUserId (copy), Analytics (copy), useEffect (copy), useLocalization (copy), React (copy), Signals (copy), v18 (copy), SignalsReact (copy), Players (copy), myFriendsNetworking (copy), FriendshipOriginSourceType (copy), PromptFriendRequestModal (copy)
	local v22 = useDispatch()
	local v23 = useLocalUserId()
	local fireAnalyticsEvent = Analytics.useUserRelationshipModalAnalytics(Analytics.RelationshipTypes.Friends, tonumber(v23) or 0, t1.userId).fireAnalyticsEvent

	useEffect(function() -- line: 54
		-- upvalues: fireAnalyticsEvent (copy), Analytics (copy)
		fireAnalyticsEvent(Analytics.EventNames.ModalSeen)
	end, { fireAnalyticsEvent })

	local v25 = useLocalization({
		friendRequestSent = "Feature.Friends.Action.FriendRequestSent",
		somethingWentWrong = "CommonUI.Messages.Response.SomethingWentWrong"
	})
	local v26 = React.useMemo(function() -- line: 63
		-- upvalues: Signals (copy), v18 (copy), t1 (copy)
		return Signals.createComputed(function(p1) -- line: 64
			-- upvalues: v18 (copy), t1 (copy)
			local v33 = v18.fetchNamesByUserIds({ (tostring(t1.userId)) })(p1)
			local v34 = v33 and (v33.data and v33.data[1])
			local v35 = v34 and v34.names

			return {
				combinedName = not v35 and "" or v35.getCombinedName(p1),
				username = not v35 and "" or v35.getUsername()
			}
		end)
	end, { t1.userId })
	local v27 = SignalsReact.useSignalState(v26)
	local v28 = React.useCallback(function() -- line: 78
		-- upvalues: fireAnalyticsEvent (copy), Analytics (copy), Players (copy), t1 (copy), v25 (copy), v22 (copy), myFriendsNetworking (copy), v23 (copy), FriendshipOriginSourceType (copy)
		fireAnalyticsEvent(Analytics.EventNames.CreateActionPressed)

		local PlayerByUserId = Players:GetPlayerByUserId(t1.userId)

		if Players.LocalPlayer ~= nil and PlayerByUserId ~= nil then
			local ok, _ = pcall(function() -- line: 88
				-- upvalues: Players (copy), PlayerByUserId (copy)
				Players.LocalPlayer:RequestFriendship(PlayerByUserId)
			end)

			triggerToast(if not ok then v25.somethingWentWrong else v25.friendRequestSent)
		else
			v22(myFriendsNetworking.RequestFriendshipFromUserId.API({
				currentUserId = v23,
				targetUserId = tostring(t1.userId),
				friendshipOriginSourceType = FriendshipOriginSourceType.InGame.rawValue()
			})):andThen(function() -- line: 98
				-- upvalues: v25 (copy)
				triggerToast(v25.friendRequestSent)
			end):catch(function(_) -- line: 101
				-- upvalues: v25 (copy)
				triggerToast(v25.somethingWentWrong)
			end)
		end

		t1.onClose()
	end, {
		v23,
		t1.userId,
		v22,
		t1.onClose,
		v25.friendRequestSent,
		v25.somethingWentWrong,
		fireAnalyticsEvent
	})

	return React.createElement(PromptFriendRequestModal, {
		userId = t1.userId,
		displayName = v27.combinedName,
		username = v27.username,
		onClose = function() -- line: 122
			-- upvalues: fireAnalyticsEvent (copy), Analytics (copy), t1 (copy)
			fireAnalyticsEvent(Analytics.EventNames.ModalClosed)
			t1.onClose()
		end,
		onSendClicked = v28,
		inputDelay = t1.inputDelay
	})
end

return PromptFriendRequestModalContainer
