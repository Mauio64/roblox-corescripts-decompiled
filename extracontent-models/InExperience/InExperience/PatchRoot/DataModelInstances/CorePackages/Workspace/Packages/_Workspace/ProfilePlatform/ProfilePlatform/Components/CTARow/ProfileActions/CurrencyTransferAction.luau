local ProfilePlatform = script:FindFirstAncestor("ProfilePlatform")
local parent = ProfilePlatform.Parent

local SharedFlags = require(parent.SharedFlags)
local CurrencyTransfers = require(parent.CurrencyTransfers)
local Enums = CurrencyTransfers.Enums
local TransferDirection = Enums.TransferDirection
local TransferOrigination = Enums.TransferOrigination

local Enums2 = require(ProfilePlatform.Common.Enums)
require(ProfilePlatform.Components.CTARow.Types)
local EventNames = require(ProfilePlatform.Analytics.EventNames)
local ProfileTypes = Enums2.ProfileTypes

local FFlagProfilePlatformEnableCurrencyTransfer = SharedFlags.FFlagProfilePlatformEnableCurrencyTransfer

return {
	[Enums2.ProfileActions.CurrencyTransfer] = FFlagProfilePlatformEnableCurrencyTransfer and function(data)
		return {
			text = data.localized[Enums2.ProfileActions.CurrencyTransfer],
			onActivated = {
				[ProfileTypes.User] = function()
					if data.buttonSurface == Enums2.ButtonSurface.ContextualMenu then
						data.analytics.fireAnalyticsEvent(EventNames.ContextualMenuButtonCurrencyTransfer, {
							buttonSurface = data.buttonSurface
						})
					else
						data.analytics.fireAnalyticsEvent(EventNames.CTAButtonCurrencyTransfer, {
							buttonSurface = data.buttonSurface
						})
					end

					local navigateToTransfer = data.navigateTo and data.navigateTo.navigateToTransfer

					if navigateToTransfer then
						navigateToTransfer({
							recipientUserId = data.profileId,
							direction = TransferDirection.Send,
							transferOrigination = TransferOrigination.Profile
						})
					end
				end
			}
		}
	end or nil
}
