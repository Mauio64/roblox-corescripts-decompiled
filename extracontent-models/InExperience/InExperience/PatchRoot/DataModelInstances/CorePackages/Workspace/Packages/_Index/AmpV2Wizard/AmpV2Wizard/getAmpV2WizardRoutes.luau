local AmpV2Wizard = script:FindFirstAncestor("AmpV2Wizard")
local parent = AmpV2Wizard.Parent

local RobloxAppEnums = require(parent.RobloxAppEnums)
local AppPage = RobloxAppEnums.AppPage
require(parent.Navigation)

local function getAmpV2WizardRoutes()
	return {
		{
			[AppPage.AmpV2Wizard] = {
				getScreen = function()
					return require(AmpV2Wizard.AmpV2WizardRoute)
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
