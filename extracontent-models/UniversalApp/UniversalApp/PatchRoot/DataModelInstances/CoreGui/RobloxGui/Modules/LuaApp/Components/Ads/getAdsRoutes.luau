local CorePackages = game:GetService("CorePackages")
local AppPage = require(CorePackages.Workspace.Packages.RobloxAppEnums).AppPage

require(CorePackages.Workspace.Packages.Navigation)

local v3 = game:DefineFastInt("FeatureTileAdPlayerOverlayTransparencyPercent", 20)

return function() -- line: 9
	-- upvalues: AppPage (copy), CorePackages (copy), v3 (copy)
	return {{
		[AppPage.FeatureTileAdPlayer] = {
			getScreen = function() -- line: 13
				-- upvalues: CorePackages (copy)
				return require(CorePackages.Workspace.Packages.FeatureTileAdPlayer).FeatureTileAdPlayer
			end,
			navigationOptions = {
				overlayEnabled = true,
				transparent = true,
				absorbInput = true,
				renderUnderlyingPage = true,
				disableBackButton = true,
				overlayTransparency = v3 / 100
			}
		}
	}}
end
