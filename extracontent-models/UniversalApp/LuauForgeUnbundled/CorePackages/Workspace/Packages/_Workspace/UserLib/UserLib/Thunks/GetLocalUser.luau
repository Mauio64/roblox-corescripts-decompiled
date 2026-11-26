local Players = game:GetService("Players")

local mutedError = require("@game/CorePackages/Workspace/Packages/_Workspace/UserLib/Loggers").mutedError
local isPlayerVerified = require("@game/CorePackages/Workspace/Packages/_Workspace/UserLib/UserLib/Utils/isPlayerVerified")
local Actions = require("@game/CorePackages/Workspace/Packages/_Workspace/UserLib/UserLib/Actions")
local addUser = Actions.AddUser
local setLocalUserId = Actions.SetLocalUserId
local setUserMembershipType = Actions.SetUserMembershipType
local setUserHasRobloxSubscription = Actions.SetUserHasRobloxSubscription
local setLocalUserUnder13 = Actions.SetLocalUserUnder13
local userModel = require("@game/CorePackages/Workspace/Packages/_Workspace/UserLib/UserLib/Models").UserModel

local SharedFlags = require("@game/CorePackages/Workspace/Packages/_Workspace/UserLib/SharedFlags")
local fFlagEnableBlackbirdCheck = SharedFlags.FFlagEnableBlackbirdCheck
local fFlagUseSignalsForIsLocalUserUnder13 = SharedFlags.FFlagUseSignalsForIsLocalUserUnder13

local v5 = if fFlagUseSignalsForIsLocalUserUnder13 then require("@game/CorePackages/Workspace/Packages/_Workspace/UserLib/UserLib/Stores/GetIsLocalUserUnder13Store") else nil

local function getHasRobloxSubscription(localPlayer)
	if not (fFlagEnableBlackbirdCheck and game:GetEngineFeature("ReadHasRobloxSubscriptionLua")) then
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
		object:dispatch(addUser((userModel.fromDataTable({
			id = userId,
			name = localPlayer.Name,
			displayName = localPlayer.displayName,
			isFriend = false,
			hasVerifiedBadge = isPlayerVerified(localPlayer)
		}))))
		object:dispatch(setLocalUserId(userId))
		object:dispatch(setUserMembershipType(userId, localPlayer.MembershipType))

		if fFlagEnableBlackbirdCheck then
			object:dispatch(setUserHasRobloxSubscription(userId, getHasRobloxSubscription(localPlayer)))
		end

		if fFlagUseSignalsForIsLocalUserUnder13 then
			v5(false).setIsLocalUserUnder13(localPlayer:GetUnder13())
		else
			object:dispatch(setLocalUserUnder13(localPlayer:GetUnder13()))
		end
	end
end
