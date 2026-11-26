local appPage = require("@game/CorePackages/Workspace/Packages/_Workspace/AmpV2Wizard/RobloxAppEnums").AppPage
require("@game/CorePackages/Workspace/Packages/_Workspace/AmpV2Wizard/Navigation")

local function getAmpV2WizardRoutes()
	return {
		{
			[appPage.AmpV2Wizard] = {
				getScreen = function()
					return require("@game/CorePackages/Workspace/Packages/_Index/AmpV2Wizard/AmpV2Wizard/AmpV2WizardRoute")
				end,
				navigationOptions = {
					overlayEnabled = true,
					transparent = true,
					absorbInput = true,
					renderUnderlyingPage = true,
					disableBackButton = true,
					bottomTabBarHidden = true,
					sideTabBarHidden = false
				}
			}
		}
	}
end

return getAmpV2WizardRoutes
