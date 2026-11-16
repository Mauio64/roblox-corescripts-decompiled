local appPage = require("@luauforge/bundled/gvP").AppPage
require("@luauforge/bundled/gvO")

local function getAmpV2WizardRoutes()
	return {
		{
			[appPage.AmpV2Wizard] = {
				getScreen = function()
					return require("@luauforge/bundled/gwz")
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
