local RoduxUsers = script:FindFirstAncestor("RoduxUsers")
local parent = RoduxUsers.Parent
local Rodux = require(parent.Rodux)
local Cryo = require(parent.Cryo)

local Actions = RoduxUsers.Actions
local Models = RoduxUsers.Models
local UserRemoved = require(Actions.UserRemoved)
local UserUpdated = require(Actions.UserUpdated)
local UserModel = require(Models.UserModel)

local v = {}

local function fn(p, list)
	local v2 = {}

	for _, item in ipairs(list) do
		local id = tostring(item.id)

		v2[id] = UserModel.new({
			id = id,
			username = item.name or "",
			displayName = item.displayName or "",
			hasVerifiedBadge = item.hasVerifiedBadge,
			created = item.created
		})
	end

	return Cryo.Dictionary.join(p, v2)
end

return function(p)
	local usersNetworking = p.usersNetworking
	local friendsNetworking = p.friendsNetworking

	return Rodux.createReducer(v, {
		[usersNetworking.GetUserV2FromUserId.Succeeded.name] = function(p2, p3)
			return fn(p2, { p3.responseBody })
		end,
		[usersNetworking.GetSkinnyUsersFromUserIds.Succeeded.name] = function(p2, p3)
			return fn(p2, p3.responseBody.data)
		end,
		[friendsNetworking.GetFriendsFromUserId.Succeeded.name] = function(p2, p3)
			return fn(p2, p3.responseBody.data)
		end,
		[friendsNetworking.GetFriendRequests.Succeeded.name] = function(p2, p3)
			return fn(p2, p3.responseBody.data)
		end,
		[friendsNetworking.GetFriendRecommendationsFromUserId.Succeeded.name] = function(p2, p3)
			return fn(p2, p3.responseBody.data)
		end,
		[UserUpdated.name] = function(p2, p3)
			assert(UserModel.isValid(p3.payload))

			return Cryo.Dictionary.join(p2, { [p3.payload.id] = p3.payload })
		end,
		[UserRemoved.name] = function(p2, p3)
			assert(type(p3.payload.id) == "string", "Expected id to be a string")

			return Cryo.Dictionary.join(p2, { [p3.payload.id] = Cryo.None })
		end
	})
end
