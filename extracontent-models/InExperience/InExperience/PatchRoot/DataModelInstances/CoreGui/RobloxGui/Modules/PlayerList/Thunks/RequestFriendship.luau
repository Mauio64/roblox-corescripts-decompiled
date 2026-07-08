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

local function RequestFriendship(p1, p2) -- line: 18
	-- upvalues: FFlagRemoveHardCodedFriendLimitPrompt (copy), RbxAnalyticsService (copy), Players (copy), LocalPlayer (copy), FriendingUtility (copy), SendNotificationInfo (copy), RobloxTranslator (copy)
	return function() -- line: 19
		-- upvalues: FFlagRemoveHardCodedFriendLimitPrompt (copy), RbxAnalyticsService (copy), p1 (copy), Players (copy), LocalPlayer (copy), FriendingUtility (copy), p2 (copy), SendNotificationInfo (copy), RobloxTranslator (copy)
		coroutine.wrap(function() -- line: 20
			-- upvalues: FFlagRemoveHardCodedFriendLimitPrompt (copy), RbxAnalyticsService (copy), p1 (copy), Players (copy), LocalPlayer (copy), FriendingUtility (copy), p2 (copy), SendNotificationInfo (copy), RobloxTranslator (copy)
			if FFlagRemoveHardCodedFriendLimitPrompt then
				RbxAnalyticsService:ReportCounter("PlayerDropDown-RequestFriendship")
				RbxAnalyticsService:TrackEvent("Game", "RequestFriendship", "PlayerDropDown")

				if p1.Parent == Players then
					LocalPlayer:RequestFriendship(p1)

					return
				end
			else
				local FriendCountAsync = FriendingUtility:GetFriendCountAsync(p1.UserId)
				local FriendCountAsync2 = FriendingUtility:GetFriendCountAsync(LocalPlayer.UserId)

				if not FriendCountAsync2 or not FriendCountAsync then
					return
				end

				if FriendCountAsync2 < 200 and FriendCountAsync < 200 then
					RbxAnalyticsService:ReportCounter("PlayerDropDown-RequestFriendship")
					RbxAnalyticsService:TrackEvent("Game", "RequestFriendship", "PlayerDropDown")

					if p1.Parent == Players then
						LocalPlayer:RequestFriendship(p1)

						return
					end
				else
					if FriendCountAsync2 >= 200 then
						local v16 = not p2 and "Cannot send friend request" or "Cannot accept friend request"

						SendNotificationInfo:Fire({
							Text = "You are at the max friends limit.",
							Duration = 5,
							Title = v16
						})

						return
					end

					if FriendCountAsync >= 200 then
						local v17 = not p2 and "Cannot send friend request" or "Cannot accept friend request"
						local v18 = RobloxTranslator:FormatByKey("InGame.PlayerDropDown.OtherPlayerFriendLimit", {
							RBX_NAME = p1.Name
						})

						SendNotificationInfo:Fire({
							Duration = 5,
							Title = v17,
							Text = v18
						})
					end
				end
			end
		end)()
	end
end

return RequestFriendship
