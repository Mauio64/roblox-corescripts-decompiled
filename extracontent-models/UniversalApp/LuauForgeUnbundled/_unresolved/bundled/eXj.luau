local appPage = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePromptLite/RobloxAppEnums").AppPage
require("@game/CorePackages/Workspace/Packages/Navigation")
local fFlagEnableSplitPane = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagEnableSplitPane
local v5 = if fFlagEnableSplitPane then require("@luauforge/bundled/dFR") else nil

return function()
	return {
		{
			[appPage.ProfilePlatform] = {
				getScreen = function()
					return require("@luauforge/deferred/eXk")
				end,
				navigationOptions = fFlagEnableSplitPane and function()
					local profileRoutePresentation = v5.SplitPaneVariant.getProfileRoutePresentation(v5.SplitPaneStore.getStore().getSupportPaneModeIfActive(false))

					return {
						overlayEnabled = profileRoutePresentation.rendersOverlay,
						transparent = true,
						absorbInput = true,
						overlayTransparency = profileRoutePresentation.rendersOverlay and 0.5 or nil,
						renderUnderlyingPage = true,
						disableBackButton = true,
						splitPaneEligibility = profileRoutePresentation.splitPaneEligibility
					}
				end or {
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
