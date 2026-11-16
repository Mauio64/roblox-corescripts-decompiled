local ProfilePlatform = script:FindFirstAncestor("ProfilePlatform")
local parent = ProfilePlatform.Parent

local Foundation = require(parent.Foundation)

local IconName = Foundation.Enums.IconName

local Enums = require(ProfilePlatform.Common.Enums)
require(ProfilePlatform.Components.CTARow.Types)
local EventNames = require(ProfilePlatform.Analytics.EventNames)
local ProfileTypes = Enums.ProfileTypes

return {
	[Enums.ProfileActions.QrCode] = function(data)
		return {
			icon = IconName.SquaresGridQr,
			onActivated = {
				[ProfileTypes.User] = function()
					data.analytics.fireAnalyticsEvent(EventNames.CTAButtonShareProfileQRCode, {
						buttonSurface = data.buttonSurface
					})

					data.navigateTo.qRCodePage()
				end
			}
		}
	end
}
