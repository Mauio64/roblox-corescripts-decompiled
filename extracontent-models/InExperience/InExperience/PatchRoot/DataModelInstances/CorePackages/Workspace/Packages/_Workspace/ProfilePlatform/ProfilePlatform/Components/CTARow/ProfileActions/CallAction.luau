local ProfilePlatform = script:FindFirstAncestor("ProfilePlatform")
local parent = ProfilePlatform.Parent

local Foundation = require(parent.Foundation)
local SharedFlags = require(parent.SharedFlags)
local FFlagFriendsCallingClientGate_DEV = SharedFlags.FFlagFriendsCallingClientGate_DEV
local FFlagFriendsCallingServiceLuaMigration = SharedFlags.FFlagFriendsCallingServiceLuaMigration
local Loggers = require(parent.Loggers)
local v = Loggers.Logger:new(script.Name)

local ButtonVariant = Foundation.Enums.ButtonVariant

local Enums = require(ProfilePlatform.Common.Enums)
require(ProfilePlatform.Components.CTARow.Types)
local EventNames = require(ProfilePlatform.Analytics.EventNames)
local ProfileTypes = Enums.ProfileTypes

return {
	[Enums.ProfileActions.Call] = FFlagFriendsCallingClientGate_DEV and function(data)
		return {
			text = "Call",
			variant = ButtonVariant.Standard,
			onActivated = {
				[ProfileTypes.User] = function()
					if data.buttonSurface == Enums.ButtonSurface.ContextualMenu then
						data.analytics.fireAnalyticsEvent(EventNames.ContextualMenuButtonCall, {
							buttonSurface = data.buttonSurface
						})
					else
						data.analytics.fireAnalyticsEvent(EventNames.CTAButtonCall, {
							buttonSurface = data.buttonSurface
						})
					end

					if FFlagFriendsCallingServiceLuaMigration then
						local friendsCallingService = data.friendsCallingService
							or game:GetService("FriendsCallingService")
						local success, result = pcall(function()
							friendsCallingService:StartCall({
								participantIds = { (tonumber(data.profileId)) }
							})
						end)

						if not success then
							v:debug("FriendsCallingService:StartCall failed: {}", result)
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
