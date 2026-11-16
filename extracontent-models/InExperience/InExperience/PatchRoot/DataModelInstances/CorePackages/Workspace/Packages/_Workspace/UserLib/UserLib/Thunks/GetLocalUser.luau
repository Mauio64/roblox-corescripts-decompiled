local Players = game:GetService("Players")
local UserLib = script:FindFirstAncestor("UserLib")
local parent = UserLib.Parent

local Loggers = require(parent.Loggers)
local mutedError = Loggers.mutedError
local isPlayerVerified = require(UserLib.Utils.isPlayerVerified)
local Actions = require(UserLib.Actions)
local AddUser = Actions.AddUser
local SetLocalUserId = Actions.SetLocalUserId
local SetUserMembershipType = Actions.SetUserMembershipType
local SetUserHasRobloxSubscription = Actions.SetUserHasRobloxSubscription
local SetLocalUserUnder13 = Actions.SetLocalUserUnder13
local Models = require(UserLib.Models)
local UserModel = Models.UserModel

local SharedFlags = require(parent.SharedFlags)
local FFlagEnableBlackbirdCheck = SharedFlags.FFlagEnableBlackbirdCheck
local FFlagUseSignalsForIsLocalUserUnder13 = SharedFlags.FFlagUseSignalsForIsLocalUserUnder13
local GetIsLocalUserUnder13Store

if FFlagUseSignalsForIsLocalUserUnder13 then
	GetIsLocalUserUnder13Store = require(UserLib.Stores.GetIsLocalUserUnder13Store)
else
	GetIsLocalUserUnder13Store = nil
end

local function getHasRobloxSubscription(localPlayer)
	if not (FFlagEnableBlackbirdCheck and game:GetEngineFeature("ReadHasRobloxSubscriptionLua")) then
		return false
	end

	local success, result = pcall(function()
		return localPlayer.HasRobloxSubscription
	end)

	if not success then
		mutedError("[GetLocalUser] Failed to read HasRobloxSubscription: " .. tostring(result))
	end

	return success and result == true
end

return function()
	return function(object)
		local localPlayer = Players.LocalPlayer
		local userId = tostring(localPlayer.UserId)
		object:dispatch(AddUser((UserModel.fromDataTable({
			id = userId,
			name = localPlayer.Name,
			displayName = localPlayer.displayName,
			isFriend = false,
			hasVerifiedBadge = isPlayerVerified(localPlayer)
		}))))
		object:dispatch(SetLocalUserId(userId))
		object:dispatch(SetUserMembershipType(userId, localPlayer.MembershipType))

		if FFlagEnableBlackbirdCheck then
			object:dispatch(SetUserHasRobloxSubscription(userId, getHasRobloxSubscription(localPlayer)))
		end

		if FFlagUseSignalsForIsLocalUserUnder13 then
			GetIsLocalUserUnder13Store(false).setIsLocalUserUnder13(localPlayer:GetUnder13())
		else
			object:dispatch(SetLocalUserUnder13(localPlayer:GetUnder13()))
		end
	end
end
