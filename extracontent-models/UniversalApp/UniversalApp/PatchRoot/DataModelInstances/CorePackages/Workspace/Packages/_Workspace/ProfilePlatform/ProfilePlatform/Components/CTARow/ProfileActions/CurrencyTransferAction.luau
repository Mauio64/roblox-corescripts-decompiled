local ProfilePlatform = script:FindFirstAncestor("ProfilePlatform")
local ProfilePlatformParent = ProfilePlatform.Parent
local SharedFlags = require(ProfilePlatformParent.SharedFlags)
local Enums = require(ProfilePlatformParent.CurrencyTransfers).Enums
local TransferDirection = Enums.TransferDirection
local TransferOrigination = Enums.TransferOrigination
local Enums2 = require(ProfilePlatform.Common.Enums)

require(ProfilePlatform.Components.CTARow.Types)

local EventNames = require(ProfilePlatform.Analytics.EventNames)
local ProfileTypes = Enums2.ProfileTypes
local FFlagProfilePlatformEnableCurrencyTransfer = SharedFlags.FFlagProfilePlatformEnableCurrencyTransfer

return {
	[Enums2.ProfileActions.CurrencyTransfer] = if not FFlagProfilePlatformEnableCurrencyTransfer then nil else function(p1) -- line: 18
		-- upvalues: Enums2 (copy), ProfileTypes (copy), EventNames (copy), TransferDirection (copy), TransferOrigination (copy)
		return {
			text = p1.localized[Enums2.ProfileActions.CurrencyTransfer],
			onActivated = {
				[ProfileTypes.User] = function() -- line: 22
					-- upvalues: p1 (copy), Enums2 (copy), EventNames (copy), TransferDirection (copy), TransferOrigination (copy)
					if p1.buttonSurface == Enums2.ButtonSurface.ContextualMenu then
						p1.analytics.fireAnalyticsEvent(EventNames.ContextualMenuButtonCurrencyTransfer, {
							buttonSurface = p1.buttonSurface
						})
					else
						p1.analytics.fireAnalyticsEvent(EventNames.CTAButtonCurrencyTransfer, {
							buttonSurface = p1.buttonSurface
						})
					end

					local v12 = p1.navigateTo and p1.navigateTo.navigateToTransfer

					if v12 then
						v12({
							recipientUserId = p1.profileId,
							direction = TransferDirection.Send,
							transferOrigination = TransferOrigination.Profile
						})
					end
				end
			}
		}
	end
}
