local Players = game:GetService("Players")
local scriptParent = script.Parent
local scriptParentParent = scriptParent.Parent
local utils = scriptParentParent.utils
local scriptParentParentParent = scriptParentParent.Parent
local FriendsMenuDependencies = require(scriptParentParent.FriendsMenuDependencies)
local Constants = require(scriptParentParent.Constants)

require(scriptParentParent.friendsMenuModalType)

local React = require(scriptParentParentParent.React)
local Requests = require(scriptParentParentParent.Http).Requests
local UserLib = require(scriptParentParentParent.UserLib)
local RoactUtils = require(scriptParentParentParent.RoactUtils)
local UserProfiles = require(scriptParentParentParent.UserProfiles)
local GetFFlagEnableFriendsListSearchNormalizationErrorFix = require(scriptParentParentParent.SharedFlags).GetFFlagEnableFriendsListSearchNormalizationErrorFix
local UserModel = UserLib.Models.UserModel
local Constants2 = UserLib.Utils.Constants
local ApiFetchUsersPresences = UserLib.Thunks.ApiFetchUsersPresences
local UpdateUsers = UserLib.Thunks.UpdateUsers
local ThumbnailRequest = UserLib.Utils.ThumbnailRequest
local PreloadUsersThumbnail = UserLib.Thunks.PreloadUsersThumbnail
local networkImpl = FriendsMenuDependencies.networkImpl
local sortFriendsByCorrectedPresenceAndRank = FriendsMenuDependencies.sortFriendsByCorrectedPresenceAndRank
local useSelector = RoactUtils.Hooks.RoactRodux.useSelector
local useDispatch = RoactUtils.Hooks.RoactRodux.useDispatch
local FriendsListContext = require(scriptParent.FriendsListContext)
local generateDummyFriends = require(utils.generateDummyFriends)
local DEPRECATED_UsersGetFriends = Requests.DEPRECATED_UsersGetFriends
local UserSorts = Constants.UserSorts
local t1 = {
	InviteAvatarThumbnailType = Constants2.RbxAvatarThumbnailTypesFromEnum.HeadShot,
	InviteAvatarThumbnailSize = Constants2.RbxThumbnailSizes.Size150x150,
	InviteAvatarRbxthumbType = Constants2.RbxthumbTypes.AvatarHeadShot
}

t1.ThumbnailRequest = {
	InviteToGame = { ThumbnailRequest.fromData(t1.InviteAvatarThumbnailType, t1.InviteAvatarThumbnailSize) }
}

return function(t2: {[any]: any}) -- line: 62
	-- upvalues: networkImpl (copy), React (copy), generateDummyFriends (copy), useDispatch (copy), UserProfiles (copy), GetFFlagEnableFriendsListSearchNormalizationErrorFix (copy), Players (copy), DEPRECATED_UsersGetFriends (copy), UserSorts (copy), UserModel (copy), UpdateUsers (copy), PreloadUsersThumbnail (copy), t1 (copy), ApiFetchUsersPresences (copy), useSelector (copy), sortFriendsByCorrectedPresenceAndRank (copy), FriendsListContext (copy)
	local u30 = if not t2.networkImplOverride then networkImpl else t2.networkImplOverride
	local v31, v32 = React.useState(false)
	local v33, v34 = React.useState(false)
	local v35, v36 = React.useState({})
	local v37, v38 = React.useState("")
	local v39, v40 = React.useState((generateDummyFriends(7)))
	local v41 = useDispatch()
	local u42 = UserProfiles.Hooks.useUserProfilesFetch({
		userIds = v35,
		query = UserProfiles.Queries.userProfilesAllNamesByUserIds
	})

	local function v43(p1) -- line: 89
		-- upvalues: t2 (copy), v37 (copy), u42 (ref), UserProfiles (copy), GetFFlagEnableFriendsListSearchNormalizationErrorFix (copy)
		if not p1 or not p1.isFriend then
			return false
		end

		if t2.excludedFriendsSet and t2.excludedFriendsSet[p1.id] then
			return false
		end

		if v37 == nil or v37 == "" then
			return true
		end

		local v46 = p1.displayName or ""
		local v47 = p1.name or ""
		local s1 = ""
		local s2 = ""
		local s3 = ""

		if u42 and u42.data then
			local names = UserProfiles.Selectors.getUserProfileFromId(u42.data, p1.id).names

			if names then
				s1 = names.alias or ""
				v46 = names.displayName or ""
				v47 = names.username or ""
				s2 = names.contactName or ""
				s3 = names.platformName or ""
			end
		end

		local v52 = utf8.nfdnormalize(v46)
		local v53 = utf8.nfdnormalize(s1)
		local v54 = utf8.nfdnormalize(s2)
		local v55 = utf8.nfdnormalize(s3)
		local u56 = nil

		if GetFFlagEnableFriendsListSearchNormalizationErrorFix() then
			pcall(function() -- line: 126
				-- upvalues: u56 (ref), v37 (copy)
				u56 = utf8.nfdnormalize(v37)
			end)
		else
			u56 = utf8.nfdnormalize(v37)
		end

		if GetFFlagEnableFriendsListSearchNormalizationErrorFix() then
			return u56 and (string.find(v53:lower(), u56:lower(), 1, true) ~= nil or (string.find(v54:lower(), u56:lower(), 1, true) ~= nil or (string.find(v55:lower(), u56:lower(), 1, true) ~= nil or string.find(v52:lower(), u56:lower(), 1, true) ~= nil))) or string.find(v47:lower(), v37:lower(), 1, true) ~= nil
		end

		return string.find(v53:lower(), u56:lower(), 1, true) ~= nil or (string.find(v54:lower(), u56:lower(), 1, true) ~= nil or (string.find(v55:lower(), u56:lower(), 1, true) ~= nil or (string.find(v52:lower(), u56:lower(), 1, true) ~= nil or string.find(v47:lower(), v37:lower(), 1, true) ~= nil)))
	end

	React.useEffect(function() -- line: 180
		-- upvalues: Players (copy), v31 (copy), v32 (copy), v34 (copy), DEPRECATED_UsersGetFriends (copy), u30 (ref), UserSorts (copy), UserModel (copy), v41 (copy), UpdateUsers (copy), v36 (copy), PreloadUsersThumbnail (copy), t1 (copy), ApiFetchUsersPresences (copy)
		local str = nil

		if Players and Players.LocalPlayer then
			str = tostring(Players.LocalPlayer.UserId)
		end

		if not v31 and str then
			v32(true)
			v34(false)
			DEPRECATED_UsersGetFriends(u30, str, UserSorts.StatusFrequents):andThen(function(p2) -- line: 190
				-- upvalues: UserModel (copy), v41 (copy), UpdateUsers (copy), v36 (copy)
				local responseBody = p2.responseBody
				local t3 = {}
				local t4 = {}

				for k, v in pairs(responseBody.data) do
					local str2 = tostring(v.id)

					v.isFriend = true
					v.friendRank = k
					v.name = ""
					v.displayName = ""

					local v75 = UserModel.fromDataTable(v)

					table.insert(t3, str2)
					t4[v75.id] = v75
				end

				v41(UpdateUsers(t4))
				v36(t3)

				return t3
			end, function(_) -- line: 209
				-- upvalues: v32 (copy), v34 (copy)
				v32(false)
				v34(true)

				return {}
			end):andThen(function(p4) -- line: 215
				-- upvalues: v41 (copy), PreloadUsersThumbnail (copy), t1 (copy), ApiFetchUsersPresences (copy), u30 (ref)
				v41(PreloadUsersThumbnail(p4, t1.ThumbnailRequest.InviteToGame, nil))

				return v41(ApiFetchUsersPresences(u30, p4))
			end):andThen(function(_) -- line: 223
				-- upvalues: v32 (copy)
				v32(false)
			end, function(_) -- line: 225
				-- upvalues: v32 (copy), v34 (copy)
				v32(false)
				v34(true)
			end)
		end
	end, {})

	local v44 = useSelector(function(p7) -- line: 232
		return p7.Users
	end)

	React.useEffect(function() -- line: 236
		-- upvalues: v31 (copy), v40 (copy), generateDummyFriends (copy), v44 (copy), v43 (copy), u42 (ref), UserProfiles (copy), sortFriendsByCorrectedPresenceAndRank (copy)
		if v31 then
			v40(generateDummyFriends(7))

			return
		end

		local t5 = {}

		for _, v in pairs(v44) do
			if v43(v) then
				t5[#t5 + 1] = v

				local v66 = nil

				if u42 and u42.data then
					v66 = UserProfiles.Selectors.getCombinedNameFromId(u42.data, v.id)
				end

				v.displayName = if v66 ~= nil then v66 else v.displayName

				local v67 = nil

				if u42 and u42.data then
					v67 = UserProfiles.Selectors.getUsernameFromId(u42.data, v.id)
				end

				v.name = if v67 ~= nil then v67 else v.name
			end
		end

		table.sort(t5, sortFriendsByCorrectedPresenceAndRank)
		v40(t5)
	end, {
		v44,
		v37,
		tostring(v31),
		(tostring(u42 and u42.loading))
	})

	return React.createElement(FriendsListContext.Provider, {
		value = {
			friends = v39,
			hasFriends = #v35 > 0,
			isFetchingFriends = v31 or t2.isLoadingCustomParams,
			isFriendsListFetchFailed = v33,
			friendsNames = {
				loading = u42 and u42.loading
			},
			searchFriends = v38,
			searchFriendsString = v37
		}
	}, t2.children)
end
