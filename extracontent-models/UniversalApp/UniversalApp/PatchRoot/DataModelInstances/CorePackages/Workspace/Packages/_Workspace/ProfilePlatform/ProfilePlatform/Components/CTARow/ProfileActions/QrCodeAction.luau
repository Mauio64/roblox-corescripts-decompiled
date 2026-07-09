local ProfilePlatform = script:FindFirstAncestor("ProfilePlatform")
local ProfilePlatformParent = ProfilePlatform.Parent
local IconName = require(ProfilePlatformParent.Foundation).Enums.IconName
local Enums = require(ProfilePlatform.Common.Enums)

require(ProfilePlatform.Components.CTARow.Types)

local EventNames = require(ProfilePlatform.Analytics.EventNames)
local ProfileTypes = Enums.ProfileTypes

return {
	[Enums.ProfileActions.QrCode] = function(p1) -- line: 14
		-- upvalues: IconName (copy), ProfileTypes (copy), EventNames (copy)
		return {
			icon = IconName.SquaresGridQr,
			onActivated = {
				[ProfileTypes.User] = function() -- line: 18
					-- upvalues: p1 (copy), EventNames (copy)
					p1.analytics.fireAnalyticsEvent(EventNames.CTAButtonShareProfileQRCode, {
						buttonSurface = p1.buttonSurface
					})
					p1.navigateTo.qRCodePage()
				end
			}
		}
	end
}
