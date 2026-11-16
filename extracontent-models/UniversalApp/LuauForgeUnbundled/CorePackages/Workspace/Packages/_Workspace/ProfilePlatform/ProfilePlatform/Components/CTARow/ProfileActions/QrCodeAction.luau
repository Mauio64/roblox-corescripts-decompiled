local iconName = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/Foundation").Enums.IconName

local Enums = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Common/Enums")
require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Components/CTARow/Types")
local EventNames = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Analytics/EventNames")
local profileTypes = Enums.ProfileTypes

return {
	[Enums.ProfileActions.QrCode] = function(data)
		return {
			icon = iconName.SquaresGridQr,
			onActivated = {
				[profileTypes.User] = function()
					data.analytics.fireAnalyticsEvent(EventNames.CTAButtonShareProfileQRCode, {
						buttonSurface = data.buttonSurface
					})

					data.navigateTo.qRCodePage()
				end
			}
		}
	end
}
