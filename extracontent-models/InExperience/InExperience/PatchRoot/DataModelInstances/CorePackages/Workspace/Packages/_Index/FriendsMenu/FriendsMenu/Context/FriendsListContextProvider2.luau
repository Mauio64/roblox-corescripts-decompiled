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
local UserModel = UserLib.Models.UserModel
local t1 = {
	InviteAvatarThumbnailType = Constants.RbxAvatarThumbnailTypesFromEnum.HeadShot,
	InviteAvatarThumbnailSize = Constants.RbxThumbnailSizes.Size150x150,
	InviteAvatarRbxthumbType = Constants.RbxthumbTypes.AvatarHeadShot
}

t1.ThumbnailRequest = {
	InviteToGame = { ThumbnailRequest.fromData(t1.InviteAvatarThumbnailType, t1.InviteAvatarThumbnailSize) }
}

return function(t2: {[any]: any}) -- line: 55
	-- upvalues: SortInvitesByScoreIXP (copy), networkImpl (copy), Players (copy), useDispatch (copy), React (copy), generateDummyFriends (copy), useFriendsListOrderedByPresence (copy), UserProfiles (copy), PreloadUsersThumbnail (copy), t1 (copy), UserModel (copy), PresenceType (copy), FFlagFilterOutDeletedAccountsGameInvites (copy), Constants2 (copy), sortFriendsByCorrectedPresenceAndRank (copy), Cryo (copy), GetFriendsSearch (copy), FriendsListContext (copy)
	local v31 = if not SortInvitesByScoreIXP.FFlagEnableSortInvitesByScoreExperiment then nil else SortInvitesByScoreIXP.useSortInvitesByScoreExperiment()
	local u32 = if not t2.networkImplOverride then networkImpl else t2.networkImplOverride
	local v33 = not Players.LocalPlayer and "0" or tostring(Players.LocalPlayer.UserId)
	local v34 = useDispatch()
	local v35, v36 = React.useState("")
	local v37, v38 = React.useState(true)
	local t3 = {}
	local v40, v41 = React.useState((generateDummyFriends(10)))
	local v42 = useFriendsListOrderedByPresence({
		pageSize = 50,
		shouldListenToPresenceUpdates = false,
		userId = v33
	})
	local v43 = UserProfiles.Hooks.useUserProfilesFetch({
		userIds = {},
		query = UserProfiles.Queries.userProfilesCombinedNameAndUsernameByUserIds
	})

	local function v44(p1, p2) -- line: 85
		-- upvalues: v34 (copy), PreloadUsersThumbnail (copy), t1 (copy), v43 (copy), t2 (copy), UserModel (copy), v42 (copy), PresenceType (copy), FFlagFilterOutDeletedAccountsGameInvites (copy), Constants2 (copy), v31 (copy), SortInvitesByScoreIXP (copy), sortFriendsByCorrectedPresenceAndRank (copy), v41 (copy), v38 (copy), t3 (ref), Cryo (copy)
		v34(PreloadUsersThumbnail(p1, t1.ThumbnailRequest.InviteToGame, nil))
		v43:fetchMore({
			variables = {
				userIds = p1
			}
		}):andThen(function(p3) -- line: 93
			-- upvalues: p1 (copy), t2 (copy), UserModel (copy), v42 (copy), PresenceType (copy), FFlagFilterOutDeletedAccountsGameInvites (copy), Constants2 (copy), v31 (copy), SortInvitesByScoreIXP (copy), p2 (copy), sortFriendsByCorrectedPresenceAndRank (copy), v41 (copy), v38 (copy)
			local t4 = {}

			for _, v54 in p1 do
				if not t2.excludedFriendsSet or not t2.excludedFriendsSet[v54] then
					local OFFLINE = UserModel.PresenceType.OFFLINE
					local lastLocation = nil

					for _, v58 in v42.onlineFriends do
						if v54 == v58.id then
							if not v58.presence then
								break
							end

							local userPresenceType = v58.presence.userPresenceType

							if userPresenceType == PresenceType.InGame then
								OFFLINE = UserModel.PresenceType.IN_GAME
							elseif userPresenceType == PresenceType.Online then
								OFFLINE = UserModel.PresenceType.ONLINE
							elseif userPresenceType == PresenceType.InStudio then
								OFFLINE = UserModel.PresenceType.IN_STUDIO
							end

							lastLocation = v58.presence.lastLocation

							break
						end
					end

					for _, v61 in p3.data.userProfiles do
						if (not FFlagFilterOutDeletedAccountsGameInvites or v61.names.username ~= Constants2.NameAccountDeleted) and v54 == v61.id then
							table.insert(t4, {
								id = v54,
								presence = OFFLINE,
								lastLocation = lastLocation,
								displayName = v61.names.combinedName,
								name = v61.names.username,
								friendRank = if not v31 and not SortInvitesByScoreIXP.FFlagSortInvitesByScoreEnabledForAll then nil else p2 and p2[v54]
							})

							break
						end
					end
				end
			end

			table.sort(t4, sortFriendsByCorrectedPresenceAndRank)
			v41(t4)
			v38(false)
		end):catch(function(p4) -- line: 144
			-- upvalues: v38 (copy)
			print("error", p4)
			v38(false)
		end)

		if t3 then
			return (Cryo.List.join(t3, p1))
		end

		return p1
	end

	t3 = React.useMemo(function() -- line: 152
		-- upvalues: v35 (copy), GetFriendsSearch (copy), u32 (ref), v33 (copy), v31 (copy), SortInvitesByScoreIXP (copy), Cryo (copy), v44 (copy), v42 (copy), t3 (ref)
		if v35 ~= "" then
			GetFriendsSearch(u32, v33, v35, 20):andThen(function(p5) -- line: 154
				-- upvalues: v31 (copy), SortInvitesByScoreIXP (copy), Cryo (copy), v44 (copy)
				local v64 = if not v31 and not SortInvitesByScoreIXP.FFlagSortInvitesByScoreEnabledForAll then nil else {}
				local v65 = Cryo.List.map(p5.responseBody.PageItems, function(p6, p7) -- line: 159
					-- upvalues: v31 (copy), SortInvitesByScoreIXP (copy), v64 (copy)
					if v31 or SortInvitesByScoreIXP.FFlagSortInvitesByScoreEnabledForAll then
						v64[p6.id] = p7
					end

					return (tostring(p6.id))
				end)

				return (v44(v65, v64))
			end):catch(function(p8) -- line: 166
				print("error", p8)
			end)
		elseif v42.onlineFriends and v42.offlineFriends then
			local t5 = {}
			local v48 = if not v31 and not SortInvitesByScoreIXP.FFlagSortInvitesByScoreEnabledForAll then nil else {}

			for v49, v50 in (Cryo.List.join(v42.offlineFriends, v42.onlineFriends)) do
				if Cryo.List.find(t3, v50.id) == nil then
					table.insert(t5, v50.id)

					if v31 or SortInvitesByScoreIXP.FFlagSortInvitesByScoreEnabledForAll then
						v48[v50.id] = v49
					end
				end
			end

			return (v44(t5, v48))
		end

		return {}
	end, {
		v42.onlineFriends,
		v42.offlineFriends,
		v35
	})

	return React.createElement(FriendsListContext.Provider, {
		value = {
			isFriendsListFetchFailed = false,
			friends = v40,
			hasFriends = not Cryo.isEmpty(v42.onlineFriends) or not Cryo.isEmpty(v42.offlineFriends),
			isFetchingFriends = v43.loading or (t2.isLoadingCustomParams or v37),
			friendsNames = {
				loading = v43 and v43.loading
			},
			fetchMoreFriends = v42.fetchMoreFriends,
			searchFriends = v36,
			searchFriendsString = v35
		}
	}, t2.children)
end
