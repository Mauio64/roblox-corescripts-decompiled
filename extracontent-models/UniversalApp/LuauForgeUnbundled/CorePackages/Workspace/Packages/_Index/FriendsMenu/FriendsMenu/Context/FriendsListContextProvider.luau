local Players = game:GetService("Players")

local FriendsMenuDependencies = require("@game/CorePackages/Workspace/Packages/_Index/FriendsMenu/FriendsMenu/FriendsMenuDependencies")
local Constants = require("@game/CorePackages/Workspace/Packages/_Index/FriendsMenu/FriendsMenu/Constants")
require("@game/CorePackages/Workspace/Packages/_Index/FriendsMenu/FriendsMenu/friendsMenuModalType")

local React = require("@game/CorePackages/Workspace/Packages/_Workspace/FriendsMenu/React")
local requests = require("@game/CorePackages/Workspace/Packages/_Workspace/FriendsMenu/Http").Requests
local UserLib = require("@game/CorePackages/Workspace/Packages/_Workspace/FriendsMenu/UserLib")
local RoactUtils = require("@game/CorePackages/Workspace/Packages/_Workspace/FriendsMenu/RoactUtils")
local UserProfiles = require("@game/CorePackages/Workspace/Packages/_Index/FriendsMenu/UserProfiles")
local getFFlagEnableFriendsListSearchNormalizationErrorFix = require("@game/CorePackages/Workspace/Packages/_Workspace/FriendsMenu/SharedFlags").GetFFlagEnableFriendsListSearchNormalizationErrorFix

local userModel = UserLib.Models.UserModel
local constants = UserLib.Utils.Constants
local apiFetchUsersPresences = UserLib.Thunks.ApiFetchUsersPresences
local updateUsers = UserLib.Thunks.UpdateUsers
local thumbnailRequest = UserLib.Utils.ThumbnailRequest
local preloadUsersThumbnail = UserLib.Thunks.PreloadUsersThumbnail
local networkImpl = FriendsMenuDependencies.networkImpl
local sortFriendsByCorrectedPresenceAndRank = FriendsMenuDependencies.sortFriendsByCorrectedPresenceAndRank

local useSelector = RoactUtils.Hooks.RoactRodux.useSelector
local useDispatch = RoactUtils.Hooks.RoactRodux.useDispatch

local FriendsListContext = require("@game/CorePackages/Workspace/Packages/_Index/FriendsMenu/FriendsMenu/Context/FriendsListContext")
local generateDummyFriends = require("@game/CorePackages/Workspace/Packages/_Index/FriendsMenu/FriendsMenu/utils/generateDummyFriends")
local DEPRECATED_UsersGetFriends = requests.DEPRECATED_UsersGetFriends

local userSorts = Constants.UserSorts
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
	local v6 = if props.networkImplOverride then props.networkImplOverride else networkImpl

	local state, setState = React.useState(false)
	local state2, setState2 = React.useState(false)
	local state3, setState3 = React.useState({})
	local state4, setState4 = React.useState("")

	local state5, setState5 = React.useState(generateDummyFriends(7))
	local v7 = useDispatch()

	local v8 = UserProfiles.Hooks.useUserProfilesFetch({
		userIds = state3,
		query = UserProfiles.Queries.userProfilesAllNamesByUserIds
	})

	local function fn(data)
		if
			not (data and data.isFriend)
			or props.excludedFriendsSet and props.excludedFriendsSet[data.id]
		then
			return false
		end

		if state4 == nil or state4 == "" then
			return true
		end

		local displayName = data.displayName or ""
		local v9 = data.name or ""
		local v10 = ""
		local v11 = ""
		local v12 = ""

		if v8 and v8.data then
			local names = UserProfiles.Selectors.getUserProfileFromId(v8.data, data.id).names

			if names then
				v10 = names.alias or ""
				displayName = names.displayName or ""
				v9 = names.username or ""
				v11 = names.contactName or ""
				v12 = names.platformName or ""
			end
		end

		local v13 = utf8.nfdnormalize(displayName)
		local v14 = utf8.nfdnormalize(v10)
		local v15 = utf8.nfdnormalize(v11)
		local v16 = utf8.nfdnormalize(v12)
		local v17 = nil

		if getFFlagEnableFriendsListSearchNormalizationErrorFix() then
			pcall(function()
				v17 = utf8.nfdnormalize(state4)
			end)
		else
			v17 = utf8.nfdnormalize(state4)
		end

		if getFFlagEnableFriendsListSearchNormalizationErrorFix() then
			return v17
				and (string.find(v14:lower(), v17:lower(), 1, true) ~= nil or string.find(v15:lower(), v17:lower(), 1, true) ~= nil or string.find(v16:lower(), v17:lower(), 1, true) ~= nil or string.find(v13:lower(), v17:lower(), 1, true) ~= nil)
				and true
				or string.find(v9:lower(), state4:lower(), 1, true) ~= nil
		end

		return string.find(v14:lower(), v17:lower(), 1, true) ~= nil
			or string.find(v15:lower(), v17:lower(), 1, true) ~= nil
			or string.find(v16:lower(), v17:lower(), 1, true) ~= nil
			or string.find(v13:lower(), v17:lower(), 1, true) ~= nil
			or string.find(v9:lower(), state4:lower(), 1, true) ~= nil
	end

	React.useEffect(function()
		local userId = if Players and Players.LocalPlayer then tostring(Players.LocalPlayer.UserId) else nil

		if not state and userId then
			setState(true)
			setState2(false)
			DEPRECATED_UsersGetFriends(v6, userId, userSorts.StatusFrequents):andThen(function(p2)
				local responseBody = p2.responseBody
				local ids = {}
				local v9 = {}

				for k, v10 in pairs(responseBody.data) do
					local id = tostring(v10.id)
					v10.isFriend = true
					v10.friendRank = k
					v10.name = ""
					v10.displayName = ""

					local v11 = userModel.fromDataTable(v10)

					table.insert(ids, id)
					v9[v11.id] = v11
				end

				v7(updateUsers(v9))
				setState3(ids)
				return ids
			end, function(p2)
				setState(false)
				setState2(true)

				return {}
			end):andThen(function(p2)
				v7(preloadUsersThumbnail(p2, v5.ThumbnailRequest.InviteToGame, nil))

				return v7(apiFetchUsersPresences(v6, p2))
			end):andThen(function(p2)
				setState(false)
			end, function(p2)
				setState(false)
				setState2(true)
			end)
		end
	end, {})

	local v9 = useSelector(function(p2)
		return p2.Users
	end)

	React.useEffect(function()
		if state then
			setState5(generateDummyFriends(7))
			return
		end

		local v10 = {}

		for k, v11 in pairs(v9) do
			if not fn(v11) then
				continue
			end

			v10[#v10 + 1] = v11
			local v12 = if v8 and v8.data then UserProfiles.Selectors.getCombinedNameFromId(v8.data, v11.id) else nil

			if v12 == nil then
				v12 = v11.displayName
			end

			v11.displayName = v12
			local v13 = if v8 and v8.data then UserProfiles.Selectors.getUsernameFromId(v8.data, v11.id) else nil

			if v13 == nil then
				v13 = v11.name
			end

			v11.name = v13
		end

		table.sort(v10, sortFriendsByCorrectedPresenceAndRank)
		setState5(v10)
	end, {
		v9,
		state4,
		tostring(state),
		(tostring(v8 and v8.loading))
	})

	return React.createElement(FriendsListContext.Provider, {
		value = {
			friends = state5,
			hasFriends = #state3 > 0,
			isFetchingFriends = state or props.isLoadingCustomParams,
			isFriendsListFetchFailed = state2,
			friendsNames = {
				loading = v8 and v8.loading
			},
			searchFriends = setState4,
			searchFriendsString = state4
		}
	}, props.children)
end
