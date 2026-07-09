local CorePackages = game:GetService("CorePackages")
local AppPage = require(CorePackages.Workspace.Packages.RobloxAppEnums).AppPage

require(CorePackages.Workspace.Packages.Navigation)

return function() -- line: 6
	-- upvalues: AppPage (copy)
	return {{
		[AppPage.TransferRobuxFlow] = {
			getScreen = function() -- line: 10
				return require(script.Parent.CurrencyTransferUniversalAppWrapper)
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
	}}
end
