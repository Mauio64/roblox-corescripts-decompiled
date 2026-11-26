local SharedFlags = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/SharedFlags")
local enums = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/CurrencyTransfers").Enums
local transferDirection = enums.TransferDirection
local transferOrigination = enums.TransferOrigination

local Enums = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Common/Enums")
require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Components/CTARow/Types")
local EventNames = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Analytics/EventNames")
local profileTypes = Enums.ProfileTypes

local fFlagProfilePlatformEnableCurrencyTransfer = SharedFlags.FFlagProfilePlatformEnableCurrencyTransfer

return {
	[Enums.ProfileActions.CurrencyTransfer] = fFlagProfilePlatformEnableCurrencyTransfer and function(data)
		return {
			text = data.localized[Enums.ProfileActions.CurrencyTransfer],
			onActivated = {
				[profileTypes.User] = function()
					if data.buttonSurface == Enums.ButtonSurface.ContextualMenu then
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
							direction = transferDirection.Send,
							transferOrigination = transferOrigination.Profile
						})
					end
				end
			}
		}
	end or nil
}
