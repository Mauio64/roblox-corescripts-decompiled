local Players = game:GetService("Players")

local FriendsMenuDependencies = require("@game/CorePackages/Workspace/Packages/_Index/FriendsMenu/FriendsMenu/FriendsMenuDependencies")

local React = require("@game/CorePackages/Workspace/Packages/_Workspace/FriendsMenu/React")
local UserLib = require("@game/CorePackages/Workspace/Packages/_Workspace/FriendsMenu/UserLib")
local RoactUtils = require("@game/CorePackages/Workspace/Packages/_Workspace/FriendsMenu/RoactUtils")
local UserProfiles = require("@game/CorePackages/Workspace/Packages/_Index/FriendsMenu/UserProfiles")
local FriendsCommon = require("@game/CorePackages/Workspace/Packages/_Workspace/FriendsMenu/FriendsCommon")
local Cryo = require("@game/CorePackages/Workspace/Packages/_Workspace/FriendsMenu/Cryo")
local GraphQLServer = require("@game/CorePackages/Workspace/Packages/_Workspace/FriendsMenu/GraphQLServer")

local constants = UserLib.Utils.Constants
local thumbnailRequest = UserLib.Utils.ThumbnailRequest
local preloadUsersThumbnail = UserLib.Thunks.PreloadUsersThumbnail

local useDispatch = RoactUtils.Hooks.RoactRodux.useDispatch
local sortFriendsByCorrectedPresenceAndRank = FriendsMenuDependencies.sortFriendsByCorrectedPresenceAndRank
local networkImpl = FriendsMenuDependencies.networkImpl
local presenceType = GraphQLServer.types.PresenceType
local GetFriendsSearch = require("@game/CorePackages/Workspace/Packages/_Index/FriendsMenu/FriendsMenu/Requests/GetFriendsSearch")
local Constants = require("@game/CorePackages/Workspace/Packages/_Index/FriendsMenu/FriendsMenu/Constants")
local SortInvitesByScoreIXP = require("@game/CorePackages/Workspace/Packages/_Index/FriendsMenu/FriendsMenu/Experiments/SortInvitesByScoreIXP")

local FriendsListContext = require("@game/CorePackages/Workspace/Packages/_Index/FriendsMenu/FriendsMenu/Context/FriendsListContext")
local useFriendsListOrderedByPresence = FriendsCommon.Hooks.useFriendsListOrderedByPresence
local generateDummyFriends = require("@game/CorePackages/Workspace/Packages/_Index/FriendsMenu/FriendsMenu/utils/generateDummyFriends")

local FFlagFilterOutDeletedAccountsGameInvites = require("@game/CorePackages/Workspace/Packages/_Index/FriendsMenu/FriendsMenu/Flags/FFlagFilterOutDeletedAccountsGameInvites")

local fFlagGameInviteOpenModalWithoutBlockingOnCanPrompt = require("@game/CorePackages/Workspace/Packages/_Workspace/FriendsMenu/SharedFlags").FFlagGameInviteOpenModalWithoutBlockingOnCanPrompt

local userModel = UserLib.Models.UserModel
local v5 = {
	["InviteAvatarThumbnailType"] = constants.RbxAvatarThumbnailTypesFromEnum.HeadShot,
	InviteAvatarThumbnailSize = constants.RbxThumbnailSizes.Size150x150,
	InviteAvatarRbxthumbType = constants.RbxthumbTypes.AvatarHeadShot
}

v5.ThumbnailRequest = {
	InviteToGame = { thumbnailRequest.fromData(
			v5.InviteAvatarThumbnailType,
			v5.InviteAvatarThumbnailSize
		) }
}

return function(props)
	local v6

	if SortInvitesByScoreIXP.FFlagEnableSortInvitesByScoreExperiment then
		v6 = SortInvitesByScoreIXP.useSortInvitesByScoreExperiment()
	else
		v6 = nil
	end

	local v7 = if props.networkImplOverride then props.networkImplOverride else networkImpl

	local v8 = not Players.LocalPlayer and "0" or tostring(Players.LocalPlayer.UserId)
	local v9 = useDispatch()
	local state, setState = React.useState("")
	local state2, setState2 = React.useState(true)
	local v10 = {}
	local state3, setState3 = React.useState(generateDummyFriends(10))

	local v11 = useFriendsListOrderedByPresence({
		userId = v8,
		pageSize = 50,
		shouldListenToPresenceUpdates = false
	})
	local v12 = UserProfiles.Hooks.useUserProfilesFetch({
		userIds = {},
		query = UserProfiles.Queries.userProfilesCombinedNameAndUsernameByUserIds
	})

	local function fn(items, p2)
		v9(preloadUsersThumbnail(items, v5.ThumbnailRequest.InviteToGame, nil))

		v12:fetchMore({
			variables = { userIds = items }
		}):andThen(function(p3)
			local v13 = {}

			for k, item in items do
				if props.excludedFriendsSet and props.excludedFriendsSet[item] then
					continue
				end

				local v14 = userModel.PresenceType.OFFLINE
				local lastLocation = nil

				for k2, onlineFriend in v11.onlineFriends do
					if item == onlineFriend.id then
						if not onlineFriend.presence then
							break
						end

						local userPresenceType = onlineFriend.presence.userPresenceType

						if userPresenceType == presenceType.InGame then
							v14 = userModel.PresenceType.IN_GAME
						elseif userPresenceType == presenceType.Online then
							v14 = userModel.PresenceType.ONLINE
						elseif userPresenceType == presenceType.InStudio then
							v14 = userModel.PresenceType.IN_STUDIO
						end

						lastLocation = onlineFriend.presence.lastLocation
						break
					end
				end

				for k2, userProfile in p3.data.userProfiles do
					if
						(not FFlagFilterOutDeletedAccountsGameInvites or userProfile.names.username ~= Constants.NameAccountDeleted)
						and userProfile.id == item
					then
						local v17 = {
							id = item,
							presence = v14,
							lastLocation = lastLocation,
							displayName = userProfile.names.combinedName,
							name = userProfile.names.username,
							friendRank = 0
						}

						local v18 = if v6 or SortInvitesByScoreIXP.FFlagSortInvitesByScoreEnabledForAll then p2 and p2[item] else nil
						v17.friendRank = v18
						table.insert(v13, v17)
						break
					end
				end
			end

			table.sort(v13, sortFriendsByCorrectedPresenceAndRank)
			setState3(v13)
			setState2(false)
		end):catch(function(p3)
			print("error", p3)
			setState2(false)
		end)

		if v10 then
			return (Cryo.List.join(v10, items))
		end

		return items
	end

	local useMemo = React.useMemo
	local function fn2()
		if state == "" then
			if v11.onlineFriends and v11.offlineFriends then
				local v13 = (v6 or SortInvitesByScoreIXP.FFlagSortInvitesByScoreEnabledForAll) and {} or nil

				local joined = Cryo.List.join(v11.offlineFriends, v11.onlineFriends)
				local ids = {}

				for k, v14 in joined do
					if Cryo.List.find(v10, v14.id) ~= nil then
						continue
					end

					table.insert(ids, v14.id)

					if v6 or SortInvitesByScoreIXP.FFlagSortInvitesByScoreEnabledForAll then
						v13[v14.id] = k
					end
				end

				if not fFlagGameInviteOpenModalWithoutBlockingOnCanPrompt or #ids ~= 0 then
					return fn(ids, v13)
				end

				if v11.isLoading then
					return {}
				end

				setState3({})
				setState2(false)
				return {}
			end
		else
			GetFriendsSearch(v7, v8, state, 20):andThen(function(p2)
				local v13 = (v6 or SortInvitesByScoreIXP.FFlagSortInvitesByScoreEnabledForAll) and {} or nil

				return fn(Cryo.List.map(p2.responseBody.PageItems, function(p3, p4)
					if v6 or SortInvitesByScoreIXP.FFlagSortInvitesByScoreEnabledForAll then
						v13[p3.id] = p4
					end

					return (tostring(p3.id))
				end), v13)
			end):catch(function(p2)
				print("error", p2)
			end)
		end

		return {}
	end

	local onlineFriends = v11.onlineFriends
	local offlineFriends = v11.offlineFriends

	local v14 = if fFlagGameInviteOpenModalWithoutBlockingOnCanPrompt then v11.isLoading else nil
	v10 = useMemo(fn2, { onlineFriends, offlineFriends, state, v14 })

	return React.createElement(FriendsListContext.Provider, {
		value = {
			friends = state3,
			hasFriends = not (Cryo.isEmpty(v11.onlineFriends) and Cryo.isEmpty(v11.offlineFriends)),
			isFetchingFriends = v12.loading or props.isLoadingCustomParams or state2 or fFlagGameInviteOpenModalWithoutBlockingOnCanPrompt and v11.isLoading,
			isFriendsListFetchFailed = false,
			friendsNames = {
				loading = v12 and v12.loading
			},
			fetchMoreFriends = v11.fetchMoreFriends,
			searchFriends = setState,
			searchFriendsString = state
		}
	}, props.children)
end
