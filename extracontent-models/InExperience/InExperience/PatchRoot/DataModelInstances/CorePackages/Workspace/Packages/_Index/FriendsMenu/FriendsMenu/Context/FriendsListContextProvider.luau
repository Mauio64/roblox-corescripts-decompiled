local Players = game:GetService("Players")

local parent = script.Parent
local parent2 = parent.Parent
local utils = parent2.utils
local parent3 = parent2.Parent

local FriendsMenuDependencies = require(parent2.FriendsMenuDependencies)
local Constants = require(parent2.Constants)
require(parent2.friendsMenuModalType)

local React = require(parent3.React)
local Http = require(parent3.Http)
local Requests = Http.Requests
local UserLib = require(parent3.UserLib)
local RoactUtils = require(parent3.RoactUtils)
local UserProfiles = require(parent3.UserProfiles)
local SharedFlags = require(parent3.SharedFlags)

local GetFFlagEnableFriendsListSearchNormalizationErrorFix = SharedFlags.GetFFlagEnableFriendsListSearchNormalizationErrorFix

local UserModel = UserLib.Models.UserModel
local constants = UserLib.Utils.Constants
local ApiFetchUsersPresences = UserLib.Thunks.ApiFetchUsersPresences
local UpdateUsers = UserLib.Thunks.UpdateUsers
local ThumbnailRequest = UserLib.Utils.ThumbnailRequest
local PreloadUsersThumbnail = UserLib.Thunks.PreloadUsersThumbnail
local networkImpl = FriendsMenuDependencies.networkImpl
local sortFriendsByCorrectedPresenceAndRank = FriendsMenuDependencies.sortFriendsByCorrectedPresenceAndRank

local useSelector = RoactUtils.Hooks.RoactRodux.useSelector
local useDispatch = RoactUtils.Hooks.RoactRodux.useDispatch

local FriendsListContext = require(parent.FriendsListContext)
local generateDummyFriends = require(utils.generateDummyFriends)
local DEPRECATED_UsersGetFriends = Requests.DEPRECATED_UsersGetFriends

local UserSorts = Constants.UserSorts
local v = {
	["InviteAvatarThumbnailType"] = constants.RbxAvatarThumbnailTypesFromEnum.HeadShot,
	InviteAvatarThumbnailSize = constants.RbxThumbnailSizes.Size150x150,
	InviteAvatarRbxthumbType = constants.RbxthumbTypes.AvatarHeadShot
}

v.ThumbnailRequest = {
	InviteToGame = { ThumbnailRequest.fromData(v.InviteAvatarThumbnailType, v.InviteAvatarThumbnailSize) }
}

return function(props)
	local v2

	if props.networkImplOverride then
		v2 = props.networkImplOverride
	else
		v2 = networkImpl
	end

	local state, setState = React.useState(false)
	local state2, setState2 = React.useState(false)
	local state3, setState3 = React.useState({})
	local state4, setState4 = React.useState("")

	local state5, setState5 = React.useState((generateDummyFriends(7)))
	local v3 = useDispatch()

	local v4 = UserProfiles.Hooks.useUserProfilesFetch({
		userIds = state3,
		query = UserProfiles.Queries.userProfilesAllNamesByUserIds
	})

	local function fn(data)
		if not (data and data.isFriend) or props.excludedFriendsSet and props.excludedFriendsSet[data.id] then
			return false
		end

		if state4 == nil or state4 == "" then
			return true
		end

		local displayName = data.displayName or ""
		local v5 = data.name or ""
		local v6 = ""
		local v7 = ""
		local v8 = ""

		if v4 and v4.data then
			local names = UserProfiles.Selectors.getUserProfileFromId(v4.data, data.id).names

			if names then
				v6 = names.alias or ""
				displayName = names.displayName or ""
				v5 = names.username or ""
				v7 = names.contactName or ""
				v8 = names.platformName or ""
			end
		end

		local v9 = utf8.nfdnormalize(displayName)
		local v10 = utf8.nfdnormalize(v6)
		local v11 = utf8.nfdnormalize(v7)
		local v12 = utf8.nfdnormalize(v8)
		local v13 = nil

		if GetFFlagEnableFriendsListSearchNormalizationErrorFix() then
			pcall(function()
				v13 = utf8.nfdnormalize(state4)
			end)
		else
			v13 = utf8.nfdnormalize(state4)
		end

		if GetFFlagEnableFriendsListSearchNormalizationErrorFix() then
			return v13
				and (string.find(v10:lower(), v13:lower(), 1, true) ~= nil or string.find(v11:lower(), v13:lower(), 1, true) ~= nil or string.find(v12:lower(), v13:lower(), 1, true) ~= nil or string.find(v9:lower(), v13:lower(), 1, true) ~= nil)
				and true
				or string.find(v5:lower(), state4:lower(), 1, true) ~= nil
		end

		return string.find(v10:lower(), v13:lower(), 1, true) ~= nil
			or string.find(v11:lower(), v13:lower(), 1, true) ~= nil
			or string.find(v12:lower(), v13:lower(), 1, true) ~= nil
			or string.find(v9:lower(), v13:lower(), 1, true) ~= nil
			or string.find(v5:lower(), state4:lower(), 1, true) ~= nil
	end

	React.useEffect(function()
		local userId

		if Players and Players.LocalPlayer then
			userId = tostring(Players.LocalPlayer.UserId)
		end

		if not state and userId then
			setState(true)
			setState2(false)
			DEPRECATED_UsersGetFriends(v2, userId, UserSorts.StatusFrequents):andThen(function(p)
				local responseBody = p.responseBody
				local ids = {}
				local v5 = {}

				for k, v6 in pairs(responseBody.data) do
					local id = tostring(v6.id)
					v6.isFriend = true
					v6.friendRank = k
					v6.name = ""
					v6.displayName = ""

					local v7 = UserModel.fromDataTable(v6)

					table.insert(ids, id)
					v5[v7.id] = v7
				end

				v3(UpdateUsers(v5))
				setState3(ids)
				return ids
			end, function(_)
				setState(false)
				setState2(true)

				return {}
			end):andThen(function(p)
				v3(PreloadUsersThumbnail(p, v.ThumbnailRequest.InviteToGame, nil))

				return v3(ApiFetchUsersPresences(v2, p))
			end):andThen(function(_)
				setState(false)
			end, function(_)
				setState(false)
				setState2(true)
			end)
		end
	end, {})

	local v5 = useSelector(function(p)
		return p.Users
	end)

	local function fn2(p) -- 1 equivalent call inferred from this helper
		local v6

		if v4 and v4.data then
			v6 = UserProfiles.Selectors.getCombinedNameFromId(v4.data, p.id)
		end

		return if v6 == nil then p.displayName else v6
	end

	local function fn3(p) -- 1 equivalent call inferred from this helper
		local v6

		if v4 and v4.data then
			v6 = UserProfiles.Selectors.getUsernameFromId(v4.data, p.id)
		end

		return if v6 == nil then p.name else v6
	end

	React.useEffect(function()
		if state then
			setState5(generateDummyFriends(7))
			return
		end

		local v6 = {}

		for _, v7 in pairs(v5) do
			if not fn(v7) then
				continue
			end

			v6[#v6 + 1] = v7
			v7.displayName = fn2(v7) -- inferred equivalent call
			v7.name = fn3(v7) -- inferred equivalent call
		end

		table.sort(v6, sortFriendsByCorrectedPresenceAndRank)
		setState5(v6)
	end, {
		v5,
		state4,
		tostring(state),
		(tostring(v4 and v4.loading))
	})

	return React.createElement(FriendsListContext.Provider, {
		value = {
			friends = state5,
			hasFriends = #state3 > 0,
			isFetchingFriends = state or props.isLoadingCustomParams,
			isFriendsListFetchFailed = state2,
			friendsNames = {
				loading = v4 and v4.loading
			},
			searchFriends = setState4,
			searchFriendsString = state4
		}
	}, props.children)
end
