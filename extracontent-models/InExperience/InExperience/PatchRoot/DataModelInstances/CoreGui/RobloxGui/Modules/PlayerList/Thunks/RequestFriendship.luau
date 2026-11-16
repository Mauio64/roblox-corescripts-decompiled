local CoreGui = game:GetService("CoreGui")
local RbxAnalyticsService = game:GetService("RbxAnalyticsService")
local Players = game:GetService("Players")
local CorePackages = game:GetService("CorePackages")

local LocalPlayer = Players.LocalPlayer

local RobloxGui = CoreGui:WaitForChild("RobloxGui")
local RobloxTranslator = require(CorePackages.Workspace.Packages.RobloxTranslator)
local FriendingUtility = require(RobloxGui.Modules.FriendingUtility)
local SendNotificationInfo = RobloxGui:WaitForChild("SendNotificationInfo")
local FFlagRemoveHardCodedFriendLimitPrompt = require(RobloxGui.Modules.Flags.FFlagRemoveHardCodedFriendLimitPrompt)

local function RequestFriendship(instance, p)
	return function()
		coroutine.wrap(function()
			if FFlagRemoveHardCodedFriendLimitPrompt then
				RbxAnalyticsService:ReportCounter("PlayerDropDown-RequestFriendship")
				RbxAnalyticsService:TrackEvent("Game", "RequestFriendship", "PlayerDropDown")

				if instance.Parent == Players then
					LocalPlayer:RequestFriendship(instance)
				end
			else
				local friendCountAsync = FriendingUtility:GetFriendCountAsync(instance.UserId)
				local friendCountAsync2 = FriendingUtility:GetFriendCountAsync(LocalPlayer.UserId)

				if not (friendCountAsync2 and friendCountAsync) then
					return
				end

				if friendCountAsync2 < 200 and friendCountAsync < 200 then
					RbxAnalyticsService:ReportCounter("PlayerDropDown-RequestFriendship")
					RbxAnalyticsService:TrackEvent("Game", "RequestFriendship", "PlayerDropDown")

					if instance.Parent == Players then
						LocalPlayer:RequestFriendship(instance)
					end
				elseif friendCountAsync2 >= 200 then
					SendNotificationInfo:Fire({
						Title = p and "Cannot accept friend request" or "Cannot send friend request",
						Text = "You are at the max friends limit.",
						Duration = 5
					})
				elseif friendCountAsync >= 200 then
					SendNotificationInfo:Fire({
						Title = p and "Cannot accept friend request" or "Cannot send friend request",
						Text = RobloxTranslator:FormatByKey("InGame.PlayerDropDown.OtherPlayerFriendLimit", {
							RBX_NAME = instance.Name
						}),
						Duration = 5
					})
				end
			end
		end)()
	end
end

return RequestFriendship
