local Players = game:GetService("Players")

local parent = script.Parent
local parent2 = parent.Parent
local parent3 = parent2.Parent

local utils = parent2.utils
local FriendsMenuDependencies = require(parent2.FriendsMenuDependencies)

local React = require(parent3.React)
local UserLib = require(parent3.UserLib)
local RoactUtils = require(parent3.RoactUtils)
local UserProfiles = require(parent3.UserProfiles)
local FriendsCommon = require(parent3.FriendsCommon)
local Cryo = require(parent3.Cryo)
local GraphQLServer = require(parent3.GraphQLServer)

local Constants = UserLib.Utils.Constants
local ThumbnailRequest = UserLib.Utils.ThumbnailRequest
local PreloadUsersThumbnail = UserLib.Thunks.PreloadUsersThumbnail

local useDispatch = RoactUtils.Hooks.RoactRodux.useDispatch
local sortFriendsByCorrectedPresenceAndRank = FriendsMenuDependencies.sortFriendsByCorrectedPresenceAndRank
local networkImpl = FriendsMenuDependencies.networkImpl
local presenceType = GraphQLServer.types.PresenceType
local GetFriendsSearch = require(parent2.Requests.GetFriendsSearch)
local Constants2 = require(parent2.Constants)
local SortInvitesByScoreIXP = require(parent2.Experiments.SortInvitesByScoreIXP)

local FriendsListContext = require(parent.FriendsListContext)
local useFriendsListOrderedByPresence = FriendsCommon.Hooks.useFriendsListOrderedByPresence
local generateDummyFriends = require(utils.generateDummyFriends)

local FFlagFilterOutDeletedAccountsGameInvites = require(parent2.Flags.FFlagFilterOutDeletedAccountsGameInvites)

local SharedFlags = require(parent3.SharedFlags)
local FFlagGameInviteOpenModalWithoutBlockingOnCanPrompt = SharedFlags.FFlagGameInviteOpenModalWithoutBlockingOnCanPrompt

local UserModel = UserLib.Models.UserModel
local v = {
	["InviteAvatarThumbnailType"] = Constants.RbxAvatarThumbnailTypesFromEnum.HeadShot,
	InviteAvatarThumbnailSize = Constants.RbxThumbnailSizes.Size150x150,
	InviteAvatarRbxthumbType = Constants.RbxthumbTypes.AvatarHeadShot
}

v.ThumbnailRequest = {
	InviteToGame = { ThumbnailRequest.fromData(v.InviteAvatarThumbnailType, v.InviteAvatarThumbnailSize) }
}

return function(props)
	local v2

	if SortInvitesByScoreIXP.FFlagEnableSortInvitesByScoreExperiment then
		v2 = SortInvitesByScoreIXP.useSortInvitesByScoreExperiment()
	else
		v2 = nil
	end

	local v3

	if props.networkImplOverride then
		v3 = props.networkImplOverride
	else
		v3 = networkImpl
	end

	local userId = not Players.LocalPlayer and "0" or tostring(Players.LocalPlayer.UserId)
	local v4 = useDispatch()
	local state, setState = React.useState("")
	local state2, setState2 = React.useState(true)
	local v5 = {}
	local state3, setState3 = React.useState((generateDummyFriends(10)))

	local v6 = useFriendsListOrderedByPresence({
		userId = userId,
		pageSize = 50,
		shouldListenToPresenceUpdates = false
	})
	local v7 = UserProfiles.Hooks.useUserProfilesFetch({
		userIds = {},
		query = UserProfiles.Queries.userProfilesCombinedNameAndUsernameByUserIds
	})

	local function fn(userIds, p)
		v4(PreloadUsersThumbnail(userIds, v.ThumbnailRequest.InviteToGame, nil))

		v7:fetchMore({
			variables = { userIds = userIds }
		}):andThen(function(p2)
			local v8 = {}

			for _, item in userIds do
				if props.excludedFriendsSet and props.excludedFriendsSet[item] then
					continue
				end

				local presence = UserModel.PresenceType.OFFLINE
				local lastLocation = nil

				for _, onlineFriend in v6.onlineFriends do
					if item == onlineFriend.id then
						if not onlineFriend.presence then
							break
						end

						local userPresenceType = onlineFriend.presence.userPresenceType

						if userPresenceType == presenceType.InGame then
							presence = UserModel.PresenceType.IN_GAME
						elseif userPresenceType == presenceType.Online then
							presence = UserModel.PresenceType.ONLINE
						elseif userPresenceType == presenceType.InStudio then
							presence = UserModel.PresenceType.IN_STUDIO
						end

						lastLocation = onlineFriend.presence.lastLocation
						break
					end
				end

				for _, userProfile in p2.data.userProfiles do
					if
						(not FFlagFilterOutDeletedAccountsGameInvites or userProfile.names.username ~= Constants2.NameAccountDeleted)
						and userProfile.id == item
					then
						local v9 = {
							id = item,
							presence = presence,
							lastLocation = lastLocation,
							displayName = userProfile.names.combinedName,
							name = userProfile.names.username,
							friendRank = 0
						}
						local friendRank

						if v2 or SortInvitesByScoreIXP.FFlagSortInvitesByScoreEnabledForAll then
							friendRank = p and p[item]
						end

						v9.friendRank = friendRank
						table.insert(v8, v9)
						break
					end
				end
			end

			table.sort(v8, sortFriendsByCorrectedPresenceAndRank)
			setState3(v8)
			setState2(false)
		end):catch(function(p2)
			print("error", p2)
			setState2(false)
		end)

		if v5 then
			return (Cryo.List.join(v5, userIds))
		end

		return userIds
	end

	local useMemo = React.useMemo
	local function fn2()
		if state == "" then
			if v6.onlineFriends and v6.offlineFriends then
				local v8 = (v2 or SortInvitesByScoreIXP.FFlagSortInvitesByScoreEnabledForAll) and {} or nil

				local joined = Cryo.List.join(v6.offlineFriends, v6.onlineFriends)
				local ids = {}

				for k, v9 in joined do
					if Cryo.List.find(v5, v9.id) ~= nil then
						continue
					end

					table.insert(ids, v9.id)

					if v2 or SortInvitesByScoreIXP.FFlagSortInvitesByScoreEnabledForAll then
						v8[v9.id] = k
					end
				end

				if not FFlagGameInviteOpenModalWithoutBlockingOnCanPrompt or #ids ~= 0 then
					return fn(ids, v8)
				end

				if v6.isLoading then
					return {}
				end

				setState3({})
				setState2(false)
				return {}
			end
		else
			GetFriendsSearch(v3, userId, state, 20):andThen(function(p)
				local v8 = (v2 or SortInvitesByScoreIXP.FFlagSortInvitesByScoreEnabledForAll) and {} or nil

				return fn(Cryo.List.map(p.responseBody.PageItems, function(p2, p3)
					if v2 or SortInvitesByScoreIXP.FFlagSortInvitesByScoreEnabledForAll then
						v8[p2.id] = p3
					end

					return (tostring(p2.id))
				end), v8)
			end):catch(function(p)
				print("error", p)
			end)
		end

		return {}
	end

	local onlineFriends = v6.onlineFriends
	local offlineFriends = v6.offlineFriends
	local v8

	if FFlagGameInviteOpenModalWithoutBlockingOnCanPrompt then
		v8 = v6.isLoading
	end

	v5 = useMemo(fn2, { onlineFriends, offlineFriends, state, v8 })

	return React.createElement(FriendsListContext.Provider, {
		value = {
			friends = state3,
			hasFriends = not (Cryo.isEmpty(v6.onlineFriends) and Cryo.isEmpty(v6.offlineFriends)),
			isFetchingFriends = v7.loading or props.isLoadingCustomParams or state2 or FFlagGameInviteOpenModalWithoutBlockingOnCanPrompt and v6.isLoading,
			isFriendsListFetchFailed = false,
			friendsNames = {
				loading = v7 and v7.loading
			},
			fetchMoreFriends = v6.fetchMoreFriends,
			searchFriends = setState,
			searchFriendsString = state
		}
	}, props.children)
end
