local appPage = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePromptLite/RobloxAppEnums").AppPage
require("@game/CorePackages/Workspace/Packages/Navigation")

local defineFastInt = game:DefineFastInt("FeatureTileAdPlayerOverlayTransparencyPercent", 20)

return function()
	return {
		{
			[appPage.FeatureTileAdPlayer] = {
				getScreen = function()
					return require("@luauforge/deferred/eWC").FeatureTileAdPlayer
				end,
				navigationOptions = {
					overlayEnabled = true,
					transparent = true,
					absorbInput = true,
					overlayTransparency = defineFastInt / 100,
					renderUnderlyingPage = true,
					disableBackButton = true
				}
			}
		}
	}
end
