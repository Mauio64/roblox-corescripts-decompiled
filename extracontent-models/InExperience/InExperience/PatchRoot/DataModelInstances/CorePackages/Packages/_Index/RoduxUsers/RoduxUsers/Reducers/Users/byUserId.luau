local RoduxUsers = script:FindFirstAncestor("RoduxUsers")
local RoduxUsersParent = RoduxUsers.Parent
local Rodux = require(RoduxUsersParent.Rodux)
local Cryo = require(RoduxUsersParent.Cryo)
local Actions = RoduxUsers.Actions
local Models = RoduxUsers.Models
local UserRemoved = require(Actions.UserRemoved)
local UserUpdated = require(Actions.UserUpdated)
local UserModel = require(Models.UserModel)
local t1 = {}

local function v11(p1, p2) -- line: 14
	-- upvalues: UserModel (copy), Cryo (copy)
	local t2 = {}

	for _, v in ipairs(p2) do
		local str = tostring(v.id)

		t2[str] = UserModel.new({
			id = str,
			username = v.name or "",
			displayName = v.displayName or "",
			hasVerifiedBadge = v.hasVerifiedBadge,
			created = v.created
		})
	end

	return Cryo.Dictionary.join(p1, t2)
end

return function(p3) -- line: 32
	-- upvalues: Rodux (copy), t1 (copy), v11 (copy), UserUpdated (copy), UserModel (copy), Cryo (copy), UserRemoved (copy)
	local usersNetworking = p3.usersNetworking
	local friendsNetworking = p3.friendsNetworking

	return Rodux.createReducer(t1, {
		[usersNetworking.GetUserV2FromUserId.Succeeded.name] = function(p4, p5) -- line: 37
			-- upvalues: v11 (copy)
			return v11(p4, { p5.responseBody })
		end,
		[usersNetworking.GetSkinnyUsersFromUserIds.Succeeded.name] = function(p6, p7) -- line: 41
			-- upvalues: v11 (copy)
			return v11(p6, p7.responseBody.data)
		end,
		[friendsNetworking.GetFriendsFromUserId.Succeeded.name] = function(p8, p9) -- line: 45
			-- upvalues: v11 (copy)
			return v11(p8, p9.responseBody.data)
		end,
		[friendsNetworking.GetFriendRequests.Succeeded.name] = function(p10, p11) -- line: 49
			-- upvalues: v11 (copy)
			return v11(p10, p11.responseBody.data)
		end,
		[friendsNetworking.GetFriendRecommendationsFromUserId.Succeeded.name] = function(p12, p13) -- line: 53
			-- upvalues: v11 (copy)
			return v11(p12, p13.responseBody.data)
		end,
		[UserUpdated.name] = function(p14, p15) -- line: 57
			-- upvalues: UserModel (copy), Cryo (copy)
			assert(UserModel.isValid(p15.payload))

			return Cryo.Dictionary.join(p14, {
				[p15.payload.id] = p15.payload
			})
		end,
		[UserRemoved.name] = function(p16, p17) -- line: 65
			-- upvalues: Cryo (copy)
			assert(type(p17.payload.id) == "string", "Expected id to be a string")

			return Cryo.Dictionary.join(p16, {
				[p17.payload.id] = Cryo.None
			})
		end
	})
end
