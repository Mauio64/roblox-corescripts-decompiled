local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/Foundation")
local SharedFlags = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/SharedFlags")
local fFlagFriendsCallingClientGate_DEV = SharedFlags.FFlagFriendsCallingClientGate_DEV
local fFlagFriendsCallingServiceLuaMigration = SharedFlags.FFlagFriendsCallingServiceLuaMigration
local v5 = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/Loggers").Logger:new("CallAction")

local buttonVariant = Foundation.Enums.ButtonVariant

local Enums = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Common/Enums")
require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Components/CTARow/Types")
local EventNames = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Analytics/EventNames")
local profileTypes = Enums.ProfileTypes

return {
	[Enums.ProfileActions.Call] = fFlagFriendsCallingClientGate_DEV and function(data)
		return {
			text = "Call",
			variant = buttonVariant.Standard,
			onActivated = {
				[profileTypes.User] = function()
					if data.buttonSurface == Enums.ButtonSurface.ContextualMenu then
						data.analytics.fireAnalyticsEvent(EventNames.ContextualMenuButtonCall, {
							buttonSurface = data.buttonSurface
						})
					else
						data.analytics.fireAnalyticsEvent(EventNames.CTAButtonCall, {
							buttonSurface = data.buttonSurface
						})
					end

					if fFlagFriendsCallingServiceLuaMigration then
						local friendsCallingService = data.friendsCallingService
							or game:GetService("FriendsCallingService")
						local success, result = pcall(function()
							friendsCallingService:StartCall({
								participantIds = { (tonumber(data.profileId)) }
							})
						end)

						if not success then
							v5:debug("FriendsCallingService:StartCall failed: {}", result)
						end
					else
						task.spawn(function()
							pcall(function()
								(data.callingService or game:GetService("CallingService")):CreateCallAsync(
									{ (tonumber(data.profileId)) },
									""
								)
							end)
						end)
					end
				end
			}
		}
	end or nil
}
