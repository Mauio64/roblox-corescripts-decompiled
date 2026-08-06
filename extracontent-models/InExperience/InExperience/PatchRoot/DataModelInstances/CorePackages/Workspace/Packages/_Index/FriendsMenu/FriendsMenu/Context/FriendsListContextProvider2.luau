local Players = game:GetService("Players")
local scriptParent = script.Parent
local scriptParentParent = scriptParent.Parent
local scriptParentParentParent = scriptParentParent.Parent
local utils = scriptParentParent.utils
local FriendsMenuDependencies = require(scriptParentParent.FriendsMenuDependencies)
local React = require(scriptParentParentParent.React)
local UserLib = require(scriptParentParentParent.UserLib)
local RoactUtils = require(scriptParentParentParent.RoactUtils)
local UserProfiles = require(scriptParentParentParent.UserProfiles)
local FriendsCommon = require(scriptParentParentParent.FriendsCommon)
local Cryo = require(scriptParentParentParent.Cryo)
local GraphQLServer = require(scriptParentParentParent.GraphQLServer)
local Constants = UserLib.Utils.Constants
local ThumbnailRequest = UserLib.Utils.ThumbnailRequest
local PreloadUsersThumbnail = UserLib.Thunks.PreloadUsersThumbnail
local useDispatch = RoactUtils.Hooks.RoactRodux.useDispatch
local sortFriendsByCorrectedPresenceAndRank = FriendsMenuDependencies.sortFriendsByCorrectedPresenceAndRank
local networkImpl = FriendsMenuDependencies.networkImpl
local PresenceType = GraphQLServer.types.PresenceType
local GetFriendsSearch = require(scriptParentParent.Requests.GetFriendsSearch)
local Constants2 = require(scriptParentParent.Constants)
local SortInvitesByScoreIXP = require(scriptParentParent.Experiments.SortInvitesByScoreIXP)
local FriendsListContext = require(scriptParent.FriendsListContext)
local useFriendsListOrderedByPresence = FriendsCommon.Hooks.useFriendsListOrderedByPresence
local generateDummyFriends = require(utils.generateDummyFriends)
local FFlagFilterOutDeletedAccountsGameInvites = require(scriptParentParent.Flags.FFlagFilterOutDeletedAccountsGameInvites)
local FFlagGameInviteOpenModalWithoutBlockingOnCanPrompt = require(scriptParentParentParent.SharedFlags).FFlagGameInviteOpenModalWithoutBlockingOnCanPrompt
local UserModel = UserLib.Models.UserModel
local t1 = {
	InviteAvatarThumbnailType = Constants.RbxAvatarThumbnailTypesFromEnum.HeadShot,
	InviteAvatarThumbnailSize = Constants.RbxThumbnailSizes.Size150x150,
	InviteAvatarRbxthumbType = Constants.RbxthumbTypes.AvatarHeadShot
}

t1.ThumbnailRequest = {
	InviteToGame = { ThumbnailRequest.fromData(t1.InviteAvatarThumbnailType, t1.InviteAvatarThumbnailSize) }
}

return function(t2: {[any]: any}) -- line: 57
	-- upvalues: SortInvitesByScoreIXP (copy), networkImpl (copy), Players (copy), useDispatch (copy), React (copy), generateDummyFriends (copy), useFriendsListOrderedByPresence (copy), UserProfiles (copy), PreloadUsersThumbnail (copy), t1 (copy), UserModel (copy), PresenceType (copy), FFlagFilterOutDeletedAccountsGameInvites (copy), Constants2 (copy), sortFriendsByCorrectedPresenceAndRank (copy), Cryo (copy), GetFriendsSearch (copy), FFlagGameInviteOpenModalWithoutBlockingOnCanPrompt (copy), FriendsListContext (copy)
	local v32 = if not SortInvitesByScoreIXP.FFlagEnableSortInvitesByScoreExperiment then nil else SortInvitesByScoreIXP.useSortInvitesByScoreExperiment()
	local u33 = if not t2.networkImplOverride then networkImpl else t2.networkImplOverride
	local v34 = not Players.LocalPlayer and "0" or tostring(Players.LocalPlayer.UserId)
	local v35 = useDispatch()
	local v36, v37 = React.useState("")
	local v38, v39 = React.useState(true)
	local t3 = {}
	local v41, v42 = React.useState((generateDummyFriends(10)))
	local v43 = useFriendsListOrderedByPresence({
		pageSize = 50,
		shouldListenToPresenceUpdates = false,
		userId = v34
	})
	local v44 = UserProfiles.Hooks.useUserProfilesFetch({
		userIds = {},
		query = UserProfiles.Queries.userProfilesCombinedNameAndUsernameByUserIds
	})

	local function v45(p1, p2) -- line: 87
		-- upvalues: v35 (copy), PreloadUsersThumbnail (copy), t1 (copy), v44 (copy), t2 (copy), UserModel (copy), v43 (copy), PresenceType (copy), FFlagFilterOutDeletedAccountsGameInvites (copy), Constants2 (copy), v32 (copy), SortInvitesByScoreIXP (copy), sortFriendsByCorrectedPresenceAndRank (copy), v42 (copy), v39 (copy), t3 (ref), Cryo (copy)
		v35(PreloadUsersThumbnail(p1, t1.ThumbnailRequest.InviteToGame, nil))
		v44:fetchMore({
			variables = {
				userIds = p1
			}
		}):andThen(function(p3) -- line: 95
			-- upvalues: p1 (copy), t2 (copy), UserModel (copy), v43 (copy), PresenceType (copy), FFlagFilterOutDeletedAccountsGameInvites (copy), Constants2 (copy), v32 (copy), SortInvitesByScoreIXP (copy), p2 (copy), sortFriendsByCorrectedPresenceAndRank (copy), v42 (copy), v39 (copy)
			local t4 = {}

			for _, v55 in p1 do
				if not t2.excludedFriendsSet or not t2.excludedFriendsSet[v55] then
					local OFFLINE = UserModel.PresenceType.OFFLINE
					local lastLocation = nil

					for _, v59 in v43.onlineFriends do
						if v55 == v59.id then
							if not v59.presence then
								break
							end

							local userPresenceType = v59.presence.userPresenceType

							if userPresenceType == PresenceType.InGame then
								OFFLINE = UserModel.PresenceType.IN_GAME
							elseif userPresenceType == PresenceType.Online then
								OFFLINE = UserModel.PresenceType.ONLINE
							elseif userPresenceType == PresenceType.InStudio then
								OFFLINE = UserModel.PresenceType.IN_STUDIO
							end

							lastLocation = v59.presence.lastLocation

							break
						end
					end

					for _, v62 in p3.data.userProfiles do
						if (not FFlagFilterOutDeletedAccountsGameInvites or v62.names.username ~= Constants2.NameAccountDeleted) and v55 == v62.id then
							table.insert(t4, {
								id = v55,
								presence = OFFLINE,
								lastLocation = lastLocation,
								displayName = v62.names.combinedName,
								name = v62.names.username,
								friendRank = if not v32 and not SortInvitesByScoreIXP.FFlagSortInvitesByScoreEnabledForAll then nil else p2 and p2[v55]
							})

							break
						end
					end
				end
			end

			table.sort(t4, sortFriendsByCorrectedPresenceAndRank)
			v42(t4)
			v39(false)
		end):catch(function(p4) -- line: 146
			-- upvalues: v39 (copy)
			print("error", p4)
			v39(false)
		end)

		if t3 then
			return (Cryo.List.join(t3, p1))
		end

		return p1
	end

	t3 = React.useMemo(function() -- line: 154
		-- upvalues: v36 (copy), GetFriendsSearch (copy), u33 (ref), v34 (copy), v32 (copy), SortInvitesByScoreIXP (copy), Cryo (copy), v45 (copy), v43 (copy), t3 (ref), FFlagGameInviteOpenModalWithoutBlockingOnCanPrompt (copy), v42 (copy), v39 (copy)
		if v36 ~= "" then
			GetFriendsSearch(u33, v34, v36, 20):andThen(function(p5) -- line: 156
				-- upvalues: v32 (copy), SortInvitesByScoreIXP (copy), Cryo (copy), v45 (copy)
				local v65 = if not v32 and not SortInvitesByScoreIXP.FFlagSortInvitesByScoreEnabledForAll then nil else {}
				local v66 = Cryo.List.map(p5.responseBody.PageItems, function(p6, p7) -- line: 161
					-- upvalues: v32 (copy), SortInvitesByScoreIXP (copy), v65 (copy)
					if v32 or SortInvitesByScoreIXP.FFlagSortInvitesByScoreEnabledForAll then
						v65[p6.id] = p7
					end

					return (tostring(p6.id))
				end)

				return (v45(v66, v65))
			end):catch(function(p8) -- line: 168
				print("error", p8)
			end)
		elseif v43.onlineFriends and v43.offlineFriends then
			local t5 = {}
			local v49 = if not v32 and not SortInvitesByScoreIXP.FFlagSortInvitesByScoreEnabledForAll then nil else {}

			for v50, v51 in (Cryo.List.join(v43.offlineFriends, v43.onlineFriends)) do
				if Cryo.List.find(t3, v51.id) == nil then
					table.insert(t5, v51.id)

					if v32 or SortInvitesByScoreIXP.FFlagSortInvitesByScoreEnabledForAll then
						v49[v51.id] = v50
					end
				end
			end

			if FFlagGameInviteOpenModalWithoutBlockingOnCanPrompt and #t5 == 0 then
				if v43.isLoading then
					return {}
				end

				v42({})
				v39(false)

				return {}
			end

			return (v45(t5, v49))
		end

		return {}
	end, {
		v43.onlineFriends,
		v43.offlineFriends,
		v36,
		if not FFlagGameInviteOpenModalWithoutBlockingOnCanPrompt then nil else v43.isLoading
	})

	return React.createElement(FriendsListContext.Provider, {
		value = {
			isFriendsListFetchFailed = false,
			friends = v41,
			hasFriends = not Cryo.isEmpty(v43.onlineFriends) or not Cryo.isEmpty(v43.offlineFriends),
			isFetchingFriends = v44.loading or (t2.isLoadingCustomParams or (v38 or FFlagGameInviteOpenModalWithoutBlockingOnCanPrompt and v43.isLoading)),
			friendsNames = {
				loading = v44 and v44.loading
			},
			fetchMoreFriends = v43.fetchMoreFriends,
			searchFriends = v37,
			searchFriendsString = v36
		}
	}, t2.children)
end
