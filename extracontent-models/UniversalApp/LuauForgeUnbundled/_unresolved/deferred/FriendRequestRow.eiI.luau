local module = require("@luauforge/deferred/eeO")
local module2 = require("@luauforge/deferred/eiJ")
local module3 = require("@luauforge/deferred/egi")
local module4 = require("@luauforge/deferred/efT")

local useGetPresenceByUserId = require("@luauforge/deferred/eip").Hooks.useGetPresenceByUserId

local v5 = module4.Friends.FriendsStore.get()
local v6 = require("@luauforge/deferred/eiK").FollowingStore.get()
local gameInfoStore = module4.Game.getGameInfoStore(false)

local constants = require("@luauforge/deferred/egJ").Constants
local friendshipOriginSourceType = require("@luauforge/deferred/efT").Friends.Enums.FriendshipOriginSourceType

local module5 = require("@luauforge/deferred/eix")
local friendsRequestsStore = require("@luauforge/deferred/eig").FriendsRequestsStore

local module6 = require("@luauforge/deferred/eiq")

local module7 = require("@luauforge/deferred/eiz")
local module8 = require("@luauforge/deferred/eiL")
local module9 = require("@luauforge/deferred/eiy")

local v7 = { forceFetch = true }

local module10 = require("@luauforge/deferred/eiw")

local contextInfoType = module10.ContextInfoType
local ctaAction = module10.CtaAction

local function FriendRequestRow(props)
	local entity = props.entity

	local v8 = module.useMemo(function()
		return v5.GetFriendshipStatus(entity.id, { skipFetch = true })
	end, { entity.id })
	local v9 = module3.useSignalState(v8 and v8.data)

	local v10 = module.useMemo(function()
		return v6.GetIsFollowing(entity.id)
	end, { entity.id })
	local v11 = module3.useSignalState(v10 and v10.data) or false

	local v12 = module.useMemo(function()
		return v6.GetIsFollowed(entity.id)
	end, { entity.id })
	local v13 = module3.useSignalState(v12 and v12.data) or false

	local sourceUniverseId = if entity.sourceUniverseId then tonumber(entity.sourceUniverseId) else nil
	local v14 = if sourceUniverseId and sourceUniverseId ~= 0 then tostring(sourceUniverseId) else nil
	local v15 = module.useMemo(function()
		if v14 then
			return gameInfoStore.getAndFetchGameInfo(v14, function(): boolean
				return true
			end)
		end

		return nil
	end, { v14 })
	local v16 = module.useMemo(function()
		return module2.createComputed(function(p2)
			if v15 then
				return (v15.data(p2))
			end

			return nil
		end)
	end, { v15 })
	local v17 = module3.useSignalState(v16)

	local mutualFriendsIds = entity.mutualFriendsIds
	local v18 = mutualFriendsIds and #mutualFriendsIds or 0
	local name = if v14 then v17 and v17.name else nil

	local v19 = module9 and v9 == Enum.FriendStatus.Friend

	local v20 = module.useMemo(function()
		local v21 = nil

		if module9 and v19 then
			v21 = contextInfoType.NewFriend
		elseif entity.contactName then
			v21 = contextInfoType.HaveContact
		elseif entity.originSourceType == constants.PHONE_CONTACT_IMPORTER then
			v21 = contextInfoType.FromCI
		elseif entity.originSourceType == friendshipOriginSourceType.QrCode then
			v21 = contextInfoType.FromQR
		elseif module5 and entity.originSourceType == friendshipOriginSourceType.SchoolMemberList then
			v21 = contextInfoType.SchoolMemberList
		elseif v18 > 0 then
			v21 = contextInfoType.MutualFriends
		elseif name == nil then
			if v11 then
				v21 = contextInfoType.FollowingUser
			elseif v13 then
				v21 = contextInfoType.FollowingMe
			end
		else
			v21 = contextInfoType.FromExperience
		end

		local v23 = if v21 == contextInfoType.MutualFriends then v18 else nil
		local v24 = if v21 == contextInfoType.HaveContact then entity.contactName else nil
		local v25 = if v21 == contextInfoType.FromExperience then name else nil
		return {
			type = v21,
			mutualFriendsCount = v23,
			contactName = v24,
			sentFromExperienceName = v25
		}
	end, { entity.contactName, entity.originSourceType, v18, name, v11, v13, v19 })

	local v21 = if module8 then useGetPresenceByUserId(entity.id, v7) else nil

	local v22 = module.useCallback(function()
		friendsRequestsStore.get().removeFriendRequestByUserId(entity.id)
	end, { entity.id })

	local v23 = module.useMemo(function()
		local v24 = v9 or Enum.FriendStatus.FriendRequestReceived

		if v24 == Enum.FriendStatus.FriendRequestReceived then
			return {
				{ actionEnum = ctaAction.DeclineFriendRequest, onSuccessCallback = v22 },
				{
					actionEnum = ctaAction.AcceptFriendRequest,
					onSuccessCallback = if not module7 then v22 else nil
				}
			}
		elseif v24 == Enum.FriendStatus.Friend then
			return {
				{ actionEnum = ctaAction.ViewProfile }
			}
		else
			return {}
		end
	end, { v9, v22 })

	return module.createElement(module6, {
		isFriendRequest = true,
		user = entity,
		createRow = props.createRow,
		position = props.position,
		layoutOrder = props.layoutOrder,
		size = props.size,
		selected = props.selected,
		impressionsTag = props.impressionsTag,
		isContact = false,
		friendStatus = v9,
		presence = v21,
		isUnseen = not (module9 and v19) and entity.isUnseen,
		contextInfo = v20,
		ctaActions = v23
	})
end

return FriendRequestRow
