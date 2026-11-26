local CorePackages = game:GetService("CorePackages")
local UserService = game:GetService("UserService")

local apiFetchUsersPresences = require("@luauforge/bundled/ciE").Thunks.ApiFetchUsersPresences
local userModel = require("@luauforge/bundled/ciE").Models.UserModel
local Promise = require(CorePackages.Packages.Promise)
local updateUsers = require("@luauforge/bundled/ciE").Thunks.UpdateUsers
local preloadUsersThumbnail = require("@luauforge/bundled/ciE").Thunks.PreloadUsersThumbnail
local USER_CAROUSEL_HEAD_SHOT = require("@luauforge/bundled/ciE").Utils.AvatarThumbnailRequests.USER_CAROUSEL_HEAD_SHOT

local function AddNewFriend(object, p2, p3, p4)
	local userService = p4 and p4.UserService or UserService

	local success, result = pcall(function()
		return userService:GetUserInfosByUserIdsAsync({ (tonumber(p3)) })[1]
	end)

	if not (success and (result and result.Username and result.DisplayName)) then
		return
	end

	object:dispatch(updateUsers({ (userModel.fromDataTable({
			id = p3,
			isFriend = true,
			friendRank = 0,
			name = result.Username,
			displayName = result.DisplayName,
			hasVerifiedBadge = result.HasVerifiedBadge
		})) }))

	local v6 = { p3 }

	local v7 = object:dispatch(preloadUsersThumbnail(v6, USER_CAROUSEL_HEAD_SHOT, nil))

	local v8 = { object:dispatch(apiFetchUsersPresences(p2, v6)), v7 }

	Promise.all(v8)
end

return function(p2, p3)
	return function(p4, p5)
		AddNewFriend(p4, p2, p3, p5)
	end
end
