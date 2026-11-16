local appPage = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePromptLite/RobloxAppEnums").AppPage
require("@game/CorePackages/Workspace/Packages/Navigation")

return function()
	return {
		{
			[appPage.TransferRobuxFlow] = {
				getScreen = function()
					return require("@luauforge/deferred/eWz")
				end,
				navigationOptions = {
					overlayEnabled = true,
					transparent = true,
					absorbInput = true,
					overlayTransparency = 0.5,
					renderUnderlyingPage = true,
					disableBackButton = true
				}
			}
		}
	}
end
