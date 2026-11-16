local module = require("@luauforge/deferred/eeO")
local module2 = require("@luauforge/deferred/eiJ")
local module3 = require("@luauforge/deferred/egi")
local v5 = require("@luauforge/deferred/efT").Friends.FriendsStore.get()

local useGetPresenceByUserId = require("@luauforge/deferred/eip").Hooks.useGetPresenceByUserId

local entityType = require("@luauforge/deferred/egF").Enums.EntityType

local v6 = { forceFetch = true }

local module4 = require("@luauforge/deferred/eiW")
local friendsRecommendationsStore = module4.FriendsRecommendationsStore
local dataSource = module4.Enums.DataSource

local module5 = require("@luauforge/deferred/eiq")

local module6 = require("@luauforge/deferred/eiz")
local module7 = require("@luauforge/deferred/eiy")
local module8 = require("@luauforge/deferred/eiA")

local module9 = require("@luauforge/deferred/eiw")

local contextInfoType = module9.ContextInfoType
local ctaAction = module9.CtaAction

local function RecommendationRow(props)
	local entity = props.entity
	local v7 = entity.type == entityType.Contact

	local v8 = module.useMemo(function()
		return v5.GetFriendshipStatus(entity.id, { skipFetch = true })
	end, { v7, entity.id })

	local v9 = module.useMemo(function()
		return module2.createComputed(function(p2)
			if v8 then
				return (v8.data(p2))
			end

			return nil
		end)
	end, { v8 })
	local v10 = module3.useSignalState(v9)

	local v12 = if not v7 then entity.id else nil
	local v13 = useGetPresenceByUserId(v12, v6)

	local contextProps = entity.contextProps
	local contextType = contextProps and contextProps.contextType
	local mutualFriendsCount = contextProps and contextProps.mutualFriendsCount or 0

	local v14 = module.useMemo(function()
		local v15 = nil

		if module7 and v10 == Enum.FriendStatus.Friend then
			v15 = contextInfoType.NewFriend
		elseif v7 then
			v15 = contextInfoType.Contacts
		elseif contextType == "Contacts" then
			v15 = contextInfoType.Contacts
		elseif contextType == "MutualFriends" and mutualFriendsCount > 0 then
			v15 = contextInfoType.MutualFriends
		elseif contextType == "Frequents" then
			v15 = contextInfoType.Frequents
		elseif module8 and contextType == "Classmates" then
			v15 = contextInfoType.Classmates
		elseif entity.hasIncomingFriendRequest then
			v15 = contextInfoType.OffNetworkFriendRequest
		end

		local v17 = if v15 == contextInfoType.MutualFriends then mutualFriendsCount else nil
		return { type = v15, mutualFriendsCount = v17 }
	end, { v7, contextType, mutualFriendsCount, entity.hasIncomingFriendRequest, v10 })

	local v15 = module.useCallback(function()
		friendsRecommendationsStore.get().removeFriendsRecommendationByUserId(
			dataSource.AddFriendsPage,
			entity.id
		)
	end, { entity.id })

	local v16 = module.useMemo(function()
		if v10 == Enum.FriendStatus.Friend then
			return {
				{ actionEnum = ctaAction.ViewProfile }
			}
		end

		if entity.hasIncomingFriendRequest or v10 == Enum.FriendStatus.FriendRequestReceived then
			return {
				{
					actionEnum = ctaAction.AcceptFriendRequest,
					onSuccessCallback = if not module6 then v15 else nil
				}
			}
		elseif v10 == Enum.FriendStatus.FriendRequestSent then
			return {
				{ actionEnum = ctaAction.PendingFriendRequest }
			}
		else
			return {
				{ actionEnum = ctaAction.RequestFriendship }
			}
		end
	end, { entity.hasIncomingFriendRequest, v10, v15 })

	local contactProps = entity.contactProps

	local v17 = v7 and {
		id = entity.id,
		type = entity.type,
		entityId = contactProps and contactProps.contactId,
		entityDisplayName = contactProps and contactProps.displayName,
		thumbnailEntities = contactProps and contactProps.thumbnailEntities
	} or entity

	return module.createElement(module5, {
		isRecommendation = true,
		user = v17,
		createRow = props.createRow,
		position = props.position,
		layoutOrder = props.layoutOrder,
		size = props.size,
		impressionsTag = props.impressionsTag,
		isContact = v7,
		friendStatus = v10,
		presence = v13,
		rank = entity.rank,
		contextInfo = v14,
		ctaActions = v16
	})
end

return RecommendationRow
