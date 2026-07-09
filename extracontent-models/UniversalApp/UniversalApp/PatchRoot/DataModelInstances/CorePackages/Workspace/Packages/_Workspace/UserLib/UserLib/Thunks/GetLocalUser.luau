local Players = game:GetService("Players")
local UserLib = script:FindFirstAncestor("UserLib")
local UserLibParent = UserLib.Parent
local mutedError = require(UserLibParent.Loggers).mutedError
local isPlayerVerified = require(UserLib.Utils.isPlayerVerified)
local Actions = require(UserLib.Actions)
local AddUser = Actions.AddUser
local SetLocalUserId = Actions.SetLocalUserId
local SetUserMembershipType = Actions.SetUserMembershipType
local SetUserHasRobloxSubscription = Actions.SetUserHasRobloxSubscription
local SetLocalUserUnder13 = Actions.SetLocalUserUnder13
local UserModel = require(UserLib.Models).UserModel
local FFlagEnableBlackbirdCheck = require(UserLibParent.SharedFlags).FFlagEnableBlackbirdCheck

local function getHasRobloxSubscription(p1) -- line: 19
	-- upvalues: FFlagEnableBlackbirdCheck (copy), mutedError (copy)
	if not FFlagEnableBlackbirdCheck then
		return false
	end

	if not game:GetEngineFeature("ReadHasRobloxSubscriptionLua") then
		return false
	end

	local ok, result = pcall(function() -- line: 26
		-- upvalues: p1 (copy)
		return p1.HasRobloxSubscription
	end)

	if not ok then
		mutedError("[GetLocalUser] Failed to read HasRobloxSubscription: " .. tostring(result))
	end

	return ok and result == true
end

return function() -- line: 35
	-- upvalues: Players (copy), UserModel (copy), isPlayerVerified (copy), AddUser (copy), SetLocalUserId (copy), SetUserMembershipType (copy), FFlagEnableBlackbirdCheck (copy), SetUserHasRobloxSubscription (copy), getHasRobloxSubscription (copy), SetLocalUserUnder13 (copy)
	return function(p2) -- line: 36
		-- upvalues: Players (copy), UserModel (copy), isPlayerVerified (copy), AddUser (copy), SetLocalUserId (copy), SetUserMembershipType (copy), FFlagEnableBlackbirdCheck (copy), SetUserHasRobloxSubscription (copy), getHasRobloxSubscription (copy), SetLocalUserUnder13 (copy)
		local LocalPlayer = Players.LocalPlayer
		local str = tostring(LocalPlayer.UserId)
		local v21 = UserModel.fromDataTable({
			isFriend = false,
			id = str,
			name = LocalPlayer.Name,
			displayName = LocalPlayer.displayName,
			hasVerifiedBadge = isPlayerVerified(LocalPlayer)
		})

		p2:dispatch(AddUser(v21))
		p2:dispatch(SetLocalUserId(str))
		p2:dispatch(SetUserMembershipType(str, LocalPlayer.MembershipType))

		if FFlagEnableBlackbirdCheck then
			p2:dispatch(SetUserHasRobloxSubscription(str, (getHasRobloxSubscription(LocalPlayer))))
		end

		p2:dispatch(SetLocalUserUnder13(LocalPlayer:GetUnder13()))
	end
end
