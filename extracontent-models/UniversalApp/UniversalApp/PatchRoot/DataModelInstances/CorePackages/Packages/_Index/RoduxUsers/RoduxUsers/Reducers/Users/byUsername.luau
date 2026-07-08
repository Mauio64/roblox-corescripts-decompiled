local RoduxUsers = script:FindFirstAncestor("RoduxUsers")
local RoduxUsersParent = RoduxUsers.Parent
local Rodux = require(RoduxUsersParent.Rodux)
local Cryo = require(RoduxUsersParent.Cryo)
local Actions = RoduxUsers.Actions
local Models = RoduxUsers.Models
local UserRemoved = require(Actions.UserRemoved)
local UserUpdated = require(Actions.UserUpdated)
local UserModel = require(Models.UserModel)

local function v10(p1, p2) -- line: 25
	-- upvalues: Cryo (copy)
	local t1 = {}

	for _, v in ipairs(p2) do
		if v.name then
			t1[v.name] = tostring(v.id)
		end
	end

	return Cryo.Dictionary.join(p1, t1)
end

local t2 = {}

return function(p3) -- line: 37
	-- upvalues: Rodux (copy), t2 (copy), v10 (copy), UserUpdated (copy), UserModel (copy), Cryo (copy), UserRemoved (copy)
	local usersNetworking = p3.usersNetworking
	local friendsNetworking = p3.friendsNetworking

	return Rodux.createReducer(t2, {
		[usersNetworking.GetUserV2FromUserId.Succeeded.name] = function(p4, p5) -- line: 42
			-- upvalues: v10 (copy)
			return v10(p4, { p5.responseBody })
		end,
		[usersNetworking.GetSkinnyUsersFromUserIds.Succeeded.name] = function(p6, p7) -- line: 46
			-- upvalues: v10 (copy)
			return v10(p6, p7.responseBody.data)
		end,
		[friendsNetworking.GetFriendsFromUserId.Succeeded.name] = function(p8, p9) -- line: 50
			-- upvalues: v10 (copy)
			return v10(p8, p9.responseBody.data)
		end,
		[friendsNetworking.GetFriendRequests.Succeeded.name] = function(p10, p11) -- line: 54
			-- upvalues: v10 (copy)
			return v10(p10, p11.responseBody.data)
		end,
		[friendsNetworking.GetFriendRecommendationsFromUserId.Succeeded.name] = function(p12, p13) -- line: 58
			-- upvalues: v10 (copy)
			return v10(p12, p13.responseBody.data)
		end,
		[UserUpdated.name] = function(p14, p15) -- line: 62
			-- upvalues: UserModel (copy), Cryo (copy)
			assert(UserModel.isValid(p15.payload))

			return Cryo.Dictionary.join(p14, {
				[p15.payload.username] = p15.payload.id
			})
		end,
		[UserRemoved.name] = function(p16, p17) -- line: 70
			-- upvalues: Cryo (copy)
			assert(type(p17.payload.id) == "string", "Expected id to be a string")

			local id = p17.payload.id
			local v39 = nil

			for k, v in pairs(p16) do
				if v == id then
					v39 = k

					break
				end
			end

			if v39 then
				return Cryo.Dictionary.join(p16, {
					[v39] = Cryo.None
				})
			end

			return p16
		end
	})
end
