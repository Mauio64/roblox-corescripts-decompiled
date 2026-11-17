local SocialContextToasts = script:FindFirstAncestor("SocialContextToasts")
local parent = SocialContextToasts.Parent
local SharedFlags = require(parent.SharedFlags)
local FFlagUserProfilePlatformProfile = SharedFlags.FFlagUserProfilePlatformProfile
local React = require(parent.React)
local Cryo = require(parent.Cryo)
local Promise = require(parent.Promise)
local UserLib = require(parent.UserLib)
local UsersGetPresence = UserLib.Requests.UsersGetPresence
local UserProfiles = require(parent.UserProfiles)
local getCombinedNameFromId = UserProfiles.Selectors.getCombinedNameFromId
local GameInvite = require(parent.GameInvite)
local PostSendExperienceInvite = GameInvite.PostSendExperienceInvite
local NotificationsCommon = require(parent.NotificationsCommon)
local JoinExperience = NotificationsCommon.JoinExperience
local SocialContextToastDiagKeys = require(SocialContextToasts.Enums.SocialContextToastDiagKeys)
local SetToastContent = require(SocialContextToasts.Actions.SetToastContent)
local SetConfirmationModal = require(SocialContextToasts.Actions.SetConfirmationModal)
local RoactUtils = require(parent.RoactUtils)
local useDispatch = RoactUtils.Hooks.RoactRodux.useDispatch
local ToastTypes = require(SocialContextToasts.Enums.ToastTypes)
local SocialContextToastAnalyticsActionTypes = require(SocialContextToasts.Enums.SocialContextToastAnalyticsActionTypes)
local SocialContextToastEvents = require(SocialContextToasts.SocialContextToastEvents)

local Hooks = require(parent.SquadsCore.Hooks)
local useOneToOnePartyNudgeStartPartyRejected = Hooks.useOneToOnePartyNudgeStartPartyRejected

local Http = require(parent.Http)
local DEPRECATED_FriendsGetFriendStatuses = Http.Requests.DEPRECATED_FriendsGetFriendStatuses

local SharedFlags2 = require(parent.SharedFlags)
local GetFFlagEnableReferredPlayerJoinRemoteEvent = SharedFlags2.GetFFlagEnableReferredPlayerJoinRemoteEvent

local SharedFlags3 = require(parent.SharedFlags)
local GetFFlagEnableReferredPlayerJoinRemoteEventForAll = SharedFlags3.GetFFlagEnableReferredPlayerJoinRemoteEventForAll
local SharedFlags4 = require(parent.SharedFlags)
local GetFIntMaxReferredPlayerJoinToasts = SharedFlags4.GetFIntMaxReferredPlayerJoinToasts
local SharedFlags5 = require(parent.SharedFlags)
local FFlagEnablePartyNudgeAfterJoin = SharedFlags5.FFlagEnablePartyNudgeAfterJoin

local SharedFlags6 = require(parent.SharedFlags)
local FFlagShowFriendJoinedYouToastForNonReferredJoins = SharedFlags6.FFlagShowFriendJoinedYouToastForNonReferredJoins

local defineFastInt = game:DefineFastInt("SocialContextToastDelay", 10)

local fn = GetFFlagEnableReferredPlayerJoinRemoteEvent() and function(): boolean
	if GetFFlagEnableReferredPlayerJoinRemoteEventForAll() then
		return true
	end

	return false
end or nil

local function getNames(apolloClient, list)
	local userIds = {}

	for i = 1, #list do
		userIds[i] = tostring(list[i])
	end

	return Promise.new(function(callback, _)
		local query

		if FFlagUserProfilePlatformProfile then
			query = UserProfiles.Queries.userProfilesBasicNamesByUserIds
		else
			query = UserProfiles.Queries.userProfilesAllNamesByUserIds
		end

		apolloClient:query({
			query = query,
			variables = { userIds = userIds }
		}):andThen(function(p)
			local v = {}

			for i = 1, #list do
				table.insert(v, {
					userId = list[i],
					name = getCombinedNameFromId(p.data, list[i])
				})
			end

			callback(v)
		end)
	end)
end

local function sortFriendsList(p, p2, p3)
	if not p3 then
		return p
	end

	local v = Cryo.List.removeValue(p, p2)
	table.insert(v, 1, p2)
	return v
end

local function showYouJoinedFriendsToast(services, callback, followUserId, ids, p, gameId, placeId)
	if #ids == 0 then
		return callback(SetToastContent(nil))
	end

	services.analytics.Diag:reportCounter(SocialContextToastDiagKeys.YouJoinedFriends, 1)
	SocialContextToastEvents(services.eventIngest, {
		toastType = ToastTypes.YouJoinedFriends,
		friendId = table.concat(ids, ","),
		universeId = gameId,
		placeId = placeId,
		actionType = SocialContextToastAnalyticsActionTypes.Shown
	})

	if followUserId > 0 and p then
		ids = Cryo.List.removeValue(ids, followUserId)
		table.insert(ids, 1, followUserId)
	end

	return getNames(services.apolloClient, ids):andThen(function(userList)
		callback(SetToastContent({ toastType = ToastTypes.YouJoinedFriends, userList = userList }))
	end)
end

local function handleFollowedPlayerDisconnected(services, callback, followUserId: number, _, gameId, placeId)
	local analytics = services.analytics
	UsersGetPresence(services.networking, { followUserId }):andThen(function(p)
		if not p.responseBody or not p.responseBody.userPresences or #p.responseBody.userPresences == 0 then
			return
		end

		local userPresence = p.responseBody.userPresences[1]
		local universeId = userPresence.universeId

		if tostring(universeId) == tostring(gameId) then
			analytics.Diag:reportCounter(SocialContextToastDiagKeys.FollowedFriendInOtherPlace, 1)
			SocialContextToastEvents(services.eventIngest, {
				toastType = ToastTypes.FriendInNonRootPlace,
				friendId = tostring(followUserId),
				universeId = gameId,
				placeId = placeId,
				actionType = SocialContextToastAnalyticsActionTypes.Shown
			})

			return getNames(services.apolloClient, { followUserId }):andThen(function(list)
				if #list == 0 then
					return
				end

				callback(SetToastContent({
					toastType = ToastTypes.FriendInNonRootPlace,
					joinerUserId = followUserId,
					joinerName = list[1].name
				}))
			end)
		elseif universeId == nil then
			analytics.Diag:reportCounter(SocialContextToastDiagKeys.FollowedFriendNotInGame, 1)
			SocialContextToastEvents(services.eventIngest, {
				toastType = ToastTypes.InviteBack,
				friendId = tostring(followUserId),
				universeId = gameId,
				placeId = placeId,
				actionType = SocialContextToastAnalyticsActionTypes.Shown
			})

			local function onInviteBackButtonClick()
				analytics.Diag:reportCounter(SocialContextToastDiagKeys.InviteBackButtonClicked, 1)
				SocialContextToastEvents(services.eventIngest, {
					toastType = ToastTypes.InviteBack,
					friendId = tostring(followUserId),
					universeId = gameId,
					placeId = placeId,
					actionType = SocialContextToastAnalyticsActionTypes.ButtonClicked
				})

				PostSendExperienceInvite(
					services.networking,
					tostring(followUserId),
					tostring(placeId),
					"SocialContextToast"
				):andThen(
					function(_)
						callback(SetToastContent({ toastType = ToastTypes.InviteSuccess }))
					end,
					function(_)
						callback(SetToastContent({ toastType = ToastTypes.InviteFailure }))
					end
				)
			end

			return getNames(services.apolloClient, { followUserId }):andThen(function(list)
				if #list == 0 then
					return
				end

				callback(SetToastContent({
					toastType = ToastTypes.InviteBack,
					joinerUserId = followUserId,
					joinerName = list[1].name,
					onActivated = onInviteBackButtonClick
				}))
			end)
		else
			analytics.Diag:reportCounter(SocialContextToastDiagKeys.FollowedFriendInOtherUniverse, 1)
			SocialContextToastEvents(services.eventIngest, {
				toastType = ToastTypes.FollowYourFriend,
				friendId = tostring(followUserId),
				universeId = gameId,
				placeId = placeId,
				actionType = SocialContextToastAnalyticsActionTypes.Shown
			})

			local function closeCallback(p2)
				if not p2 then
					callback(SetConfirmationModal(false))
					return
				end

				analytics.Diag:reportCounter(SocialContextToastDiagKeys.ConfirmLeaveGameButtonClicked, 1)
				SocialContextToastEvents(services.eventIngest, {
					toastType = "LeaveGameConfirmationModal",
					friendId = tostring(followUserId),
					universeId = gameId,
					placeId = placeId,
					actionType = SocialContextToastAnalyticsActionTypes.ButtonClicked
				})

				JoinExperience(
					string.format("roblox://userid=%s&placeid=%s", tostring(followUserId), userPresence.placeId),
					true
				)
			end

			local function onJoinFriendButtonClick()
				analytics.Diag:reportCounter(SocialContextToastDiagKeys.JoinFriendButtonClicked, 1)
				SocialContextToastEvents(services.eventIngest, {
					toastType = ToastTypes.FollowYourFriend,
					friendId = tostring(followUserId),
					universeId = gameId,
					placeId = placeId,
					actionType = SocialContextToastAnalyticsActionTypes.ButtonClicked
				})

				callback(SetConfirmationModal(true, closeCallback))
			end

			return getNames(services.apolloClient, { followUserId }):andThen(function(list)
				if #list == 0 then
					return
				end

				callback(SetToastContent({
					toastType = ToastTypes.FollowYourFriend,
					joinerUserId = followUserId,
					joinerName = list[1].name,
					experienceName = userPresence.lastLocation,
					onActivated = onJoinFriendButtonClick
				}))
			end)
		end
	end, function(_)
		analytics.Diag:reportCounter(SocialContextToastDiagKeys.ErrorFetchingPresence, 1)
	end)
end

function SocialContextToastDispatcher(data)
	local services = data.services
	local analytics = services.analytics
	local playersService = services.playersService
	local ref = React.createRef()
	local networking = services.networking

	local ref2 = React.useRef(nil)
	local ref3 = React.useRef(nil)
	local ref4

	if GetFFlagEnableReferredPlayerJoinRemoteEvent() then
		ref4 = React.useRef(nil)
	else
		ref4 = nil
	end

	local ref5

	if GetFFlagEnableReferredPlayerJoinRemoteEvent() then
		ref5 = React.useRef(0)
	else
		ref5 = nil
	end

	local v = useDispatch()

	local function showToastOnJoin()
		local followUserId = playersService.LocalPlayer.FollowUserId

		local userIds = {}
		local v2 = false
		local ids = {}

		for _, v3 in pairs(playersService:GetPlayers()) do
			table.insert(userIds, v3.UserId)
		end

		DEPRECATED_FriendsGetFriendStatuses(networking, userIds):andThen(function(p)
			if not (p and p.responseBody and p.responseBody.data) then
				return
			end

			local data2 = p.responseBody.data

			for _, v3 in pairs(data2) do
				local id = v3.id

				if id == followUserId then
					v2 = true
				end

				if v3.status == "Friends" then
					table.insert(ids, id)
				end
			end

			if followUserId > 0 and not v2 then
				return handleFollowedPlayerDisconnected(services, v, followUserId, ids, data.gameId, data.placeId)
			end

			return showYouJoinedFriendsToast(services, v, followUserId, ids, v2, data.gameId, data.placeId)
		end)
	end

	local function onPlayerAdded(playerByUserId)
		local localPlayer = playersService.LocalPlayer

		if playerByUserId.FollowUserId == localPlayer.UserId then
			local success, result = pcall(function()
				return localPlayer:IsFriendsWithAsync(playerByUserId.UserId)
			end)

			if success and result then
				analytics.Diag:reportCounter(SocialContextToastDiagKeys.YouWereFollowed, 1)
				SocialContextToastEvents(services.eventIngest, {
					toastType = ToastTypes.FriendJoinedYou,
					friendId = tostring(playerByUserId.UserId),
					universeId = data.gameId,
					placeId = data.placeId,
					actionType = SocialContextToastAnalyticsActionTypes.Shown
				})

				local v2 = { playerByUserId.UserId }
				getNames(services.apolloClient, v2):andThen(function(list)
					local joinerName = list[1].name

					if joinerName == nil then
						joinerName = playerByUserId.DisplayName
					end

					v(SetToastContent({
						toastType = ToastTypes.FriendJoinedYou,
						joinerUserId = playerByUserId.UserId,
						joinerName = joinerName
					}))
				end)
			end
		end
	end

	if FFlagEnablePartyNudgeAfterJoin then
		useOneToOnePartyNudgeStartPartyRejected(function(p)
			local playerByUserId = p and p.inviterId and playersService:GetPlayerByUserId(p.inviterId)

			if playerByUserId then
				onPlayerAdded(playerByUserId)
			end
		end)
	end

	local v2

	if GetFFlagEnableReferredPlayerJoinRemoteEvent() then
		local useCallback = React.useCallback
		local function fn2(player)
			if ref5.current >= GetFIntMaxReferredPlayerJoinToasts() then
				return
			end

			ref5.current += 1

			v(SetToastContent({
				toastType = ToastTypes.InviteeJoinedYou,
				joinerUserId = player.UserId,
				joinerName = player.DisplayName
			}))
		end

		local v3

		if FFlagShowFriendJoinedYouToastForNonReferredJoins then
			v3 = v
		end

		v2 = useCallback(fn2, { v3 })
	else
		v2 = nil
	end

	local useEffect = React.useEffect
	local function fn2()
		local v3

		if FFlagEnablePartyNudgeAfterJoin and services.showPlayerJoinedFriendsToastRemoteEvent then
			v3 = false
			ref3.current = services.showPlayerJoinedFriendsToastRemoteEvent.OnClientEvent:Connect(function()
				v3 = true
			end)
		else
			v3 = true
		end

		task.delay(defineFastInt, function()
			if not ref.current then
				if #playersService:GetPlayers() > 0 and v3 then
					showToastOnJoin()
				end

				if FFlagEnablePartyNudgeAfterJoin or FFlagShowFriendJoinedYouToastForNonReferredJoins then
					if services.showFriendJoinedPlayerToastRemoteEvent then
						ref2.current = services.showFriendJoinedPlayerToastRemoteEvent.OnClientEvent:Connect(onPlayerAdded)
					end
				else
					ref2.current = playersService.PlayerAdded:Connect(onPlayerAdded)
				end

				if
					GetFFlagEnableReferredPlayerJoinRemoteEvent()
					and services.referredPlayerJoinRemoteEvent
					and fn()
				then
					ref4.current = services.referredPlayerJoinRemoteEvent.OnClientEvent:Connect(v2)
				end
			end
		end)

		return function()
			ref.current = true

			if ref2.current then
				ref2.current:disconnect()
			end

			if FFlagEnablePartyNudgeAfterJoin and ref3.current then
				ref3.current:disconnect()
			end

			if GetFFlagEnableReferredPlayerJoinRemoteEvent() and ref4.current then
				ref4.current:disconnect()
			end
		end
	end

	local referredPlayerJoinRemoteEvent = services.referredPlayerJoinRemoteEvent
	local showFriendJoinedPlayerToastRemoteEvent

	if FFlagEnablePartyNudgeAfterJoin then
		showFriendJoinedPlayerToastRemoteEvent = services.showFriendJoinedPlayerToastRemoteEvent
	end

	local v3

	if FFlagEnablePartyNudgeAfterJoin then
		v3 = services.showPlayerJoinedFriendsToastRemoteEvent
	end

	useEffect(fn2, {
		playersService,
		v2,
		referredPlayerJoinRemoteEvent,
		showFriendJoinedPlayerToastRemoteEvent,
		v3
	})
end

return SocialContextToastDispatcher
