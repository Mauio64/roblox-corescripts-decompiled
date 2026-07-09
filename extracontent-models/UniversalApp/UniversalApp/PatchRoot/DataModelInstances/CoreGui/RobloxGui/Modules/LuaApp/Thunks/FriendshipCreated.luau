local CorePackages = game:GetService("CorePackages")
local UserService = game:GetService("UserService")
local ApiFetchUsersPresences = require(CorePackages.Workspace.Packages.UserLib).Thunks.ApiFetchUsersPresences
local UserModel = require(CorePackages.Workspace.Packages.UserLib).Models.UserModel
local Promise = require(CorePackages.Packages.Promise)
local UpdateUsers = require(CorePackages.Workspace.Packages.UserLib).Thunks.UpdateUsers
local PreloadUsersThumbnail = require(CorePackages.Workspace.Packages.UserLib).Thunks.PreloadUsersThumbnail
local USER_CAROUSEL_HEAD_SHOT = require(CorePackages.Workspace.Packages.UserLib).Utils.AvatarThumbnailRequests.USER_CAROUSEL_HEAD_SHOT

local function AddNewFriend(p1, p2, s1: string, p3) -- line: 13
	-- upvalues: UserService (copy), UserModel (copy), UpdateUsers (copy), PreloadUsersThumbnail (copy), USER_CAROUSEL_HEAD_SHOT (copy), ApiFetchUsersPresences (copy), Promise (copy)
	local v14 = p3 and p3.UserService or UserService
	local ok, result = pcall(function() -- line: 17
		-- upvalues: v14 (copy), s1 (copy)
		return v14:GetUserInfosByUserIdsAsync({ (tonumber(s1)) })[1]
	end)

	if not ok then
		return
	end

	if not result or not result.Username or not result.DisplayName then
		return
	end

	local v17 = UserModel.fromDataTable({
		isFriend = true,
		friendRank = 0,
		id = s1,
		name = result.Username,
		displayName = result.DisplayName,
		hasVerifiedBadge = result.HasVerifiedBadge
	})

	p1:dispatch(UpdateUsers({ v17 }))

	local t1 = { s1 }
	local v19 = p1:dispatch(PreloadUsersThumbnail(t1, USER_CAROUSEL_HEAD_SHOT, nil))
	local t2 = {
		p1:dispatch(ApiFetchUsersPresences(p2, t1)),
		v19
	}

	Promise.all(t2)
end

return function(p4, s2: string) -- line: 52
	-- upvalues: AddNewFriend (copy)
	return function(p5, p6) -- line: 53
		-- upvalues: AddNewFriend (copy), p4 (copy), s2 (copy)
		AddNewFriend(p5, p4, s2, p6)
	end
end
