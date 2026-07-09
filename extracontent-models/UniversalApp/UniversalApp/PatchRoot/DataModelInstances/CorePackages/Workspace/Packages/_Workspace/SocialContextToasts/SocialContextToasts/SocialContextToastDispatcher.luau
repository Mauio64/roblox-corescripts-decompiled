local SocialContextToasts = script:FindFirstAncestor("SocialContextToasts")
local SocialContextToastsParent = SocialContextToasts.Parent
local React = require(SocialContextToastsParent.React)
local Cryo = require(SocialContextToastsParent.Cryo)
local Promise = require(SocialContextToastsParent.Promise)
local UsersGetPresence = require(SocialContextToastsParent.UserLib).Requests.UsersGetPresence
local UserProfiles = require(SocialContextToastsParent.UserProfiles)
local getCombinedNameFromId = UserProfiles.Selectors.getCombinedNameFromId
local PostSendExperienceInvite = require(SocialContextToastsParent.GameInvite).PostSendExperienceInvite
local JoinExperience = require(SocialContextToastsParent.NotificationsCommon).JoinExperience
local SocialContextToastDiagKeys = require(SocialContextToasts.Enums.SocialContextToastDiagKeys)
local SetToastContent = require(SocialContextToasts.Actions.SetToastContent)
local SetConfirmationModal = require(SocialContextToasts.Actions.SetConfirmationModal)
local useDispatch = require(SocialContextToastsParent.RoactUtils).Hooks.RoactRodux.useDispatch
local ToastTypes = require(SocialContextToasts.Enums.ToastTypes)
local SocialContextToastAnalyticsActionTypes = require(SocialContextToasts.Enums.SocialContextToastAnalyticsActionTypes)
local SocialContextToastEvents = require(SocialContextToasts.SocialContextToastEvents)
local useOneToOnePartyNudgeStartPartyRejected = require(SocialContextToastsParent.SquadsCore.Hooks).useOneToOnePartyNudgeStartPartyRejected
local DEPRECATED_FriendsGetFriendStatuses = require(SocialContextToastsParent.Http).Requests.DEPRECATED_FriendsGetFriendStatuses
local GetFFlagSocialContextToastEventStream = require(SocialContextToastsParent.SharedFlags).GetFFlagSocialContextToastEventStream
local GetFFlagEnableReferredPlayerJoinRemoteEvent = require(SocialContextToastsParent.SharedFlags).GetFFlagEnableReferredPlayerJoinRemoteEvent
local GetFFlagEnableReferredPlayerJoinRemoteEventForAll = require(SocialContextToastsParent.SharedFlags).GetFFlagEnableReferredPlayerJoinRemoteEventForAll
local GetFIntMaxReferredPlayerJoinToasts = require(SocialContextToastsParent.SharedFlags).GetFIntMaxReferredPlayerJoinToasts
local FFlagEnablePartyNudgeAfterJoin = require(SocialContextToastsParent.SharedFlags).FFlagEnablePartyNudgeAfterJoin
local v25 = game:DefineFastInt("SocialContextToastDelay", 10)
local u26 = nil

if GetFFlagEnableReferredPlayerJoinRemoteEvent() then
	function u26() -- line: 55
		-- upvalues: GetFFlagEnableReferredPlayerJoinRemoteEventForAll (copy)
		if GetFFlagEnableReferredPlayerJoinRemoteEventForAll() then
			return true
		end

		return false
	end
end

local function getNames(p1, p2) -- line: 64
	-- upvalues: Promise (copy), UserProfiles (copy), getCombinedNameFromId (copy)
	local t1 = {}

	for i = 1, #p2 do
		t1[i] = tostring(p2[i])
	end

	return Promise.new(function(resolve, _) -- line: 69
		-- upvalues: p1 (copy), UserProfiles (copy), t1 (copy), p2 (copy), getCombinedNameFromId (copy)
		p1:query({
			query = UserProfiles.Queries.userProfilesAllNamesByUserIds,
			variables = {
				userIds = t1
			}
		}):andThen(function(p4) -- line: 77
			-- upvalues: p2 (copy), getCombinedNameFromId (copy), resolve (copy)
			local t2 = {}

			for i = 1, #p2 do
				table.insert(t2, {
					userId = p2[i],
					name = getCombinedNameFromId(p4.data, p2[i])
				})
			end

			resolve(t2)
		end)
	end)
end
local function sortFriendsList(p5, p6, p7) -- line: 90
	-- upvalues: Cryo (copy)
	if not p7 then
		return p5
	end

	local v38 = Cryo.List.removeValue(p5, p6)

	table.insert(v38, 1, p6)

	return v38
end
local function showYouJoinedFriendsToast(p8, p9, p10, p11, p12, p13, p14) -- line: 100
	-- upvalues: SetToastContent (copy), SocialContextToastDiagKeys (copy), GetFFlagSocialContextToastEventStream (copy), SocialContextToastEvents (copy), ToastTypes (copy), SocialContextToastAnalyticsActionTypes (copy), Cryo (copy), getNames (copy)
	if #p11 == 0 then
		return p9(SetToastContent(nil))
	end

	p8.analytics.Diag:reportCounter(SocialContextToastDiagKeys.YouJoinedFriends, 1)

	if GetFFlagSocialContextToastEventStream() then
		SocialContextToastEvents(p8.eventIngest, {
			toastType = ToastTypes.YouJoinedFriends,
			friendId = table.concat(p11, ","),
			universeId = p13,
			placeId = p14,
			actionType = SocialContextToastAnalyticsActionTypes.Shown
		})
	end

	if p10 > 0 then
		if not p12 then
		else
			p11 = Cryo.List.removeValue(p11, p10)
			table.insert(p11, 1, p10)
		end
	end

	return getNames(p8.apolloClient, p11):andThen(function(p15) -- line: 127
		-- upvalues: p9 (copy), SetToastContent (copy), ToastTypes (copy)
		p9(SetToastContent({
			toastType = ToastTypes.YouJoinedFriends,
			userList = p15
		}))
	end)
end
local function handleFollowedPlayerDisconnected(p16, p17, n1: number, _, p19, p20) -- line: 135
	-- upvalues: UsersGetPresence (copy), SocialContextToastDiagKeys (copy), GetFFlagSocialContextToastEventStream (copy), SocialContextToastEvents (copy), ToastTypes (copy), SocialContextToastAnalyticsActionTypes (copy), getNames (copy), SetToastContent (copy), SetConfirmationModal (copy), JoinExperience (copy), PostSendExperienceInvite (copy)
	local analytics = p16.analytics
	local networking = p16.networking

	UsersGetPresence(networking, { n1 }):andThen(function(p21) -- line: 138
		-- upvalues: p19 (copy), analytics (copy), SocialContextToastDiagKeys (copy), GetFFlagSocialContextToastEventStream (copy), SocialContextToastEvents (copy), p16 (copy), ToastTypes (copy), n1 (copy), p20 (copy), SocialContextToastAnalyticsActionTypes (copy), getNames (copy), p17 (copy), SetToastContent (copy), SetConfirmationModal (copy), JoinExperience (copy), PostSendExperienceInvite (copy)
		if not p21.responseBody or (not p21.responseBody.userPresences or #p21.responseBody.userPresences == 0) then
			return
		end

		local v72 = p21.responseBody.userPresences[1]
		local universeId = v72.universeId

		if tostring(universeId) == tostring(p19) then
			analytics.Diag:reportCounter(SocialContextToastDiagKeys.FollowedFriendInOtherPlace, 1)

			if GetFFlagSocialContextToastEventStream() then
				SocialContextToastEvents(p16.eventIngest, {
					toastType = ToastTypes.FriendInNonRootPlace,
					friendId = tostring(n1),
					universeId = p19,
					placeId = p20,
					actionType = SocialContextToastAnalyticsActionTypes.Shown
				})
			end

			return getNames(p16.apolloClient, { n1 }):andThen(function(p22) -- line: 163
				-- upvalues: p17 (copy), SetToastContent (copy), ToastTypes (copy), n1 (copy)
				if #p22 == 0 then
					return
				end

				p17(SetToastContent({
					toastType = ToastTypes.FriendInNonRootPlace,
					joinerUserId = n1,
					joinerName = p22[1].name
				}))
			end)
		end

		if universeId ~= nil then
			analytics.Diag:reportCounter(SocialContextToastDiagKeys.FollowedFriendInOtherUniverse, 1)

			if GetFFlagSocialContextToastEventStream() then
				SocialContextToastEvents(p16.eventIngest, {
					toastType = ToastTypes.FollowYourFriend,
					friendId = tostring(n1),
					universeId = p19,
					placeId = p20,
					actionType = SocialContextToastAnalyticsActionTypes.Shown
				})
			end

			local function closeCallback(p23) -- line: 184
				-- upvalues: p17 (copy), SetConfirmationModal (copy), analytics (copy), SocialContextToastDiagKeys (copy), GetFFlagSocialContextToastEventStream (copy), SocialContextToastEvents (copy), p16 (copy), n1 (copy), p19 (copy), p20 (copy), SocialContextToastAnalyticsActionTypes (copy), v72 (copy), JoinExperience (copy)
				if not p23 then
					p17(SetConfirmationModal(false))

					return
				end

				analytics.Diag:reportCounter(SocialContextToastDiagKeys.ConfirmLeaveGameButtonClicked, 1)

				if GetFFlagSocialContextToastEventStream() then
					SocialContextToastEvents(p16.eventIngest, {
						toastType = "LeaveGameConfirmationModal",
						friendId = tostring(n1),
						universeId = p19,
						placeId = p20,
						actionType = SocialContextToastAnalyticsActionTypes.ButtonClicked
					})
				end

				local v98 = string.format("roblox://userid=%s&placeid=%s", tostring(n1), v72.placeId)

				JoinExperience(v98, true)
			end
			local function onJoinFriendButtonClick() -- line: 204
				-- upvalues: analytics (copy), SocialContextToastDiagKeys (copy), GetFFlagSocialContextToastEventStream (copy), SocialContextToastEvents (copy), p16 (copy), ToastTypes (copy), n1 (copy), p19 (copy), p20 (copy), SocialContextToastAnalyticsActionTypes (copy), p17 (copy), SetConfirmationModal (copy), closeCallback (copy)
				analytics.Diag:reportCounter(SocialContextToastDiagKeys.JoinFriendButtonClicked, 1)

				if GetFFlagSocialContextToastEventStream() then
					SocialContextToastEvents(p16.eventIngest, {
						toastType = ToastTypes.FollowYourFriend,
						friendId = tostring(n1),
						universeId = p19,
						placeId = p20,
						actionType = SocialContextToastAnalyticsActionTypes.ButtonClicked
					})
				end

				p17(SetConfirmationModal(true, closeCallback))
			end

			return getNames(p16.apolloClient, { n1 }):andThen(function(p24) -- line: 218
				-- upvalues: p17 (copy), SetToastContent (copy), ToastTypes (copy), n1 (copy), v72 (copy), onJoinFriendButtonClick (copy)
				if #p24 == 0 then
					return
				end

				p17(SetToastContent({
					toastType = ToastTypes.FollowYourFriend,
					joinerUserId = n1,
					joinerName = p24[1].name,
					experienceName = v72.lastLocation,
					onActivated = onJoinFriendButtonClick
				}))
			end)
		end

		analytics.Diag:reportCounter(SocialContextToastDiagKeys.FollowedFriendNotInGame, 1)

		if GetFFlagSocialContextToastEventStream() then
			SocialContextToastEvents(p16.eventIngest, {
				toastType = ToastTypes.InviteBack,
				friendId = tostring(n1),
				universeId = p19,
				placeId = p20,
				actionType = SocialContextToastAnalyticsActionTypes.Shown
			})
		end

		local function onInviteBackButtonClick() -- line: 241
			-- upvalues: analytics (copy), SocialContextToastDiagKeys (copy), GetFFlagSocialContextToastEventStream (copy), SocialContextToastEvents (copy), p16 (copy), ToastTypes (copy), n1 (copy), p19 (copy), p20 (copy), SocialContextToastAnalyticsActionTypes (copy), PostSendExperienceInvite (copy), p17 (copy), SetToastContent (copy)
			analytics.Diag:reportCounter(SocialContextToastDiagKeys.InviteBackButtonClicked, 1)

			if GetFFlagSocialContextToastEventStream() then
				SocialContextToastEvents(p16.eventIngest, {
					toastType = ToastTypes.InviteBack,
					friendId = tostring(n1),
					universeId = p19,
					placeId = p20,
					actionType = SocialContextToastAnalyticsActionTypes.ButtonClicked
				})
			end

			PostSendExperienceInvite(p16.networking, tostring(n1), tostring(p20), "SocialContextToast"):andThen(function(_) -- line: 257
				-- upvalues: p17 (copy), SetToastContent (copy), ToastTypes (copy)
				p17(SetToastContent({
					toastType = ToastTypes.InviteSuccess
				}))
			end, function(_) -- line: 261
				-- upvalues: p17 (copy), SetToastContent (copy), ToastTypes (copy)
				p17(SetToastContent({
					toastType = ToastTypes.InviteFailure
				}))
			end)
		end

		return getNames(p16.apolloClient, { n1 }):andThen(function(t3: {[any]: any}) -- line: 269
			-- upvalues: p17 (copy), SetToastContent (copy), ToastTypes (copy), n1 (copy), onInviteBackButtonClick (copy)
			if #t3 == 0 then
				return
			end

			p17(SetToastContent({
				toastType = ToastTypes.InviteBack,
				joinerUserId = n1,
				joinerName = t3[1].name,
				onActivated = onInviteBackButtonClick
			}))
		end)
	end, function(_) -- line: 282
		-- upvalues: analytics (copy), SocialContextToastDiagKeys (copy)
		analytics.Diag:reportCounter(SocialContextToastDiagKeys.ErrorFetchingPresence, 1)
	end)
end

function SocialContextToastDispatcher(t4: {[any]: any}) -- line: 288
	-- upvalues: React (copy), GetFFlagEnableReferredPlayerJoinRemoteEvent (copy), useDispatch (copy), DEPRECATED_FriendsGetFriendStatuses (copy), handleFollowedPlayerDisconnected (copy), showYouJoinedFriendsToast (copy), SocialContextToastDiagKeys (copy), GetFFlagSocialContextToastEventStream (copy), SocialContextToastEvents (copy), ToastTypes (copy), SocialContextToastAnalyticsActionTypes (copy), getNames (copy), SetToastContent (copy), FFlagEnablePartyNudgeAfterJoin (copy), useOneToOnePartyNudgeStartPartyRejected (copy), GetFIntMaxReferredPlayerJoinToasts (copy), v25 (copy), u26 (ref)
	local services = t4.services
	local analytics = services.analytics
	local playersService = services.playersService
	local v58 = React.createRef()
	local networking = services.networking
	local v60 = React.useRef(nil)
	local v61 = React.useRef(nil)
	local v62 = if not GetFFlagEnableReferredPlayerJoinRemoteEvent() then nil else React.useRef(nil)
	local v63 = if not GetFFlagEnableReferredPlayerJoinRemoteEvent() then nil else React.useRef(0)
	local v64 = useDispatch()

	local function showToastOnJoin() -- line: 307
		-- upvalues: playersService (copy), DEPRECATED_FriendsGetFriendStatuses (copy), networking (copy), handleFollowedPlayerDisconnected (copy), services (copy), v64 (copy), t4 (copy), showYouJoinedFriendsToast (copy)
		local FollowUserId = playersService.LocalPlayer.FollowUserId
		local u79 = false
		local t5 = {}
		local t6 = {}

		for _, player in pairs(playersService:GetPlayers()) do
			table.insert(t6, player.UserId)
		end

		DEPRECATED_FriendsGetFriendStatuses(networking, t6):andThen(function(p28) -- line: 319
			-- upvalues: FollowUserId (copy), u79 (ref), t5 (copy), handleFollowedPlayerDisconnected (copy), services (copy), v64 (copy), t4 (copy), showYouJoinedFriendsToast (copy)
			if p28 and (p28.responseBody and p28.responseBody.data) then
				local data = p28.responseBody.data

				for _, v in pairs(data) do
					local id = v.id

					if id == FollowUserId then
						u79 = true
					end

					if v.status == "Friends" then
						table.insert(t5, id)
					end
				end

				if FollowUserId > 0 and not u79 then
					return handleFollowedPlayerDisconnected(services, v64, FollowUserId, t5, t4.gameId, t4.placeId)
				end

				return showYouJoinedFriendsToast(services, v64, FollowUserId, t5, u79, t4.gameId, t4.placeId)
			end
		end)
	end
	local function onPlayerAdded(p29) -- line: 355
		-- upvalues: playersService (copy), analytics (copy), SocialContextToastDiagKeys (copy), GetFFlagSocialContextToastEventStream (copy), SocialContextToastEvents (copy), services (copy), ToastTypes (copy), t4 (copy), SocialContextToastAnalyticsActionTypes (copy), getNames (copy), v64 (copy), SetToastContent (copy)
		local LocalPlayer = playersService.LocalPlayer

		if p29.FollowUserId == LocalPlayer.UserId then
			local ok, result = pcall(function() -- line: 358
				-- upvalues: LocalPlayer (copy), p29 (copy)
				if game:GetEngineFeature("AsyncRenamesUsedInLuaApps") then
					return LocalPlayer:IsFriendsWithAsync(p29.UserId)
				end

				return LocalPlayer:IsFriendsWith(p29.UserId)
			end)

			if ok and result then
				analytics.Diag:reportCounter(SocialContextToastDiagKeys.YouWereFollowed, 1)

				if GetFFlagSocialContextToastEventStream() then
					SocialContextToastEvents(services.eventIngest, {
						toastType = ToastTypes.FriendJoinedYou,
						friendId = tostring(p29.UserId),
						universeId = t4.gameId,
						placeId = t4.placeId,
						actionType = SocialContextToastAnalyticsActionTypes.Shown
					})
				end

				local t7 = { p29.UserId }

				getNames(services.apolloClient, t7):andThen(function(p30) -- line: 380
					-- upvalues: p29 (copy), v64 (copy), SetToastContent (copy), ToastTypes (copy)
					local name = p30[1].name

					if name == nil then
						name = p29.DisplayName
					end

					v64(SetToastContent({
						toastType = ToastTypes.FriendJoinedYou,
						joinerUserId = p29.UserId,
						joinerName = name
					}))
				end)
			end
		end
	end

	if FFlagEnablePartyNudgeAfterJoin then
		useOneToOnePartyNudgeStartPartyRejected(function(p31) -- line: 398
			-- upvalues: playersService (copy), onPlayerAdded (copy)
			if p31 and p31.inviterId then
				local PlayerByUserId = playersService:GetPlayerByUserId(p31.inviterId)

				if PlayerByUserId then
					onPlayerAdded(PlayerByUserId)
				end
			end
		end)
	end

	local u67 = nil

	if GetFFlagEnableReferredPlayerJoinRemoteEvent() then
		u67 = React.useCallback(function(p32) -- line: 410
			-- upvalues: v63 (copy), GetFIntMaxReferredPlayerJoinToasts (copy), v64 (copy), SetToastContent (copy), ToastTypes (copy)
			if v63.current >= GetFIntMaxReferredPlayerJoinToasts() then
				return
			end

			v63.current = v63.current + 1
			v64(SetToastContent({
				toastType = ToastTypes.InviteeJoinedYou,
				joinerUserId = p32.UserId,
				joinerName = p32.DisplayName
			}))
		end, {})
	end

	React.useEffect(function() -- line: 425
		-- upvalues: FFlagEnablePartyNudgeAfterJoin (copy), services (copy), v61 (copy), v25 (copy), v58 (copy), playersService (copy), showToastOnJoin (copy), v60 (copy), onPlayerAdded (copy), GetFFlagEnableReferredPlayerJoinRemoteEvent (copy), u26 (ref), v62 (copy), u67 (ref)
		local u92 = true

		if FFlagEnablePartyNudgeAfterJoin and services.showPlayerJoinedFriendsToastRemoteEvent then
			u92 = false
			v61.current = services.showPlayerJoinedFriendsToastRemoteEvent.OnClientEvent:Connect(function() -- line: 430
				-- upvalues: u92 (ref)
				u92 = true
			end)
		end

		task.delay(v25, function() -- line: 438
			-- upvalues: v58 (copy), playersService (copy), u92 (ref), showToastOnJoin (copy), FFlagEnablePartyNudgeAfterJoin (copy), services (copy), v60 (copy), onPlayerAdded (copy), GetFFlagEnableReferredPlayerJoinRemoteEvent (copy), u26 (ref), v62 (copy), u67 (ref)
			if not v58.current then
				if #playersService:GetPlayers() > 0 and u92 then
					showToastOnJoin()
				end

				if FFlagEnablePartyNudgeAfterJoin then
					if services.showFriendJoinedPlayerToastRemoteEvent then
						v60.current = services.showFriendJoinedPlayerToastRemoteEvent.OnClientEvent:Connect(onPlayerAdded)
					end
				else
					v60.current = playersService.PlayerAdded:Connect(onPlayerAdded)
				end

				if GetFFlagEnableReferredPlayerJoinRemoteEvent() and services.referredPlayerJoinRemoteEvent and u26() then
					v62.current = services.referredPlayerJoinRemoteEvent.OnClientEvent:Connect(u67)
				end
			end
		end)

		return function() -- line: 465
			-- upvalues: v58 (copy), v60 (copy), FFlagEnablePartyNudgeAfterJoin (copy), v61 (copy), GetFFlagEnableReferredPlayerJoinRemoteEvent (copy), v62 (copy)
			v58.current = true

			if v60.current then
				v60.current:disconnect()
			end

			if FFlagEnablePartyNudgeAfterJoin and v61.current then
				v61.current:disconnect()
			end

			if GetFFlagEnableReferredPlayerJoinRemoteEvent() and v62.current then
				v62.current:disconnect()
			end
		end
	end, {
		playersService,
		u67,
		services.referredPlayerJoinRemoteEvent,
		if not FFlagEnablePartyNudgeAfterJoin then nil else services.showFriendJoinedPlayerToastRemoteEvent,
		if not FFlagEnablePartyNudgeAfterJoin then nil else services.showPlayerJoinedFriendsToastRemoteEvent
	})
end

return SocialContextToastDispatcher
