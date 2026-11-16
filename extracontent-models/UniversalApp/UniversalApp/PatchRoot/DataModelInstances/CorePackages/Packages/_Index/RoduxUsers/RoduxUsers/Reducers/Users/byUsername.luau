local RoduxUsers = script:FindFirstAncestor("RoduxUsers")
local parent = RoduxUsers.Parent
local Rodux = require(parent.Rodux)
local Cryo = require(parent.Cryo)

local Actions = RoduxUsers.Actions
local Models = RoduxUsers.Models

local UserRemoved = require(Actions.UserRemoved)
local UserUpdated = require(Actions.UserUpdated)
local UserModel = require(Models.UserModel)

local function fn(p, list)
	local idsByName = {}

	for _, item in ipairs(list) do
		if item.name then
			idsByName[item.name] = tostring(item.id)
		end
	end

	return Cryo.Dictionary.join(p, idsByName)
end

local v = {}

local function fn2(id, items) -- 1 equivalent call inferred from this helper
	for k, item in pairs(items) do
		if item == id then
			return k
		end
	end

	return nil
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

			return Cryo.Dictionary.join(p2, { [p3.payload.username] = p3.payload.id })
		end,
		[UserRemoved.name] = function(items, p2)
			assert(type(p2.payload.id) == "string", "Expected id to be a string")

			local k = fn2(p2.payload.id, items) -- inferred equivalent call

			if k then
				return Cryo.Dictionary.join(items, { [k] = Cryo.None })
			end

			return items
		end
	})
end
