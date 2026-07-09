local CorePackages = game:GetService("CorePackages")
local Modules = game:GetService("CoreGui").RobloxGui.Modules
local AppUserLayers = require(CorePackages.Workspace.Packages.ExperimentLayers).AppUserLayers
local IxpUtils = require(CorePackages.Workspace.Packages.IxpUtils)
local GetFFlagCleanUpAXAlternativeLandingPageIXP = require(Modules.AvatarExperience.Flags.GetFFlagCleanUpAXAlternativeLandingPageIXP)

game:DefineFastFlag("AXDefaultAvatarToShopEnabled3", false)
game:DefineFastFlag("AXDefaultAvatarToShopEnabledForAll3", false)
game:DefineFastString("AXDefaultAvatarToShopLayer3", AppUserLayers.AvatarMarketplaceUILayer)
game:DefineFastFlag("AXDefaultAvatarToShopWidgetEnabled3", false)

if GetFFlagCleanUpAXAlternativeLandingPageIXP() then
	return nil
end

return IxpUtils.defineIXPTest({
	name = "AXDefaultAvatarToShop",
	cacheVariables = true,
	layer = game:GetFastString("AXDefaultAvatarToShopLayer3"),
	getDependentFlagsEnabled = function() -- line: 40
		return true
	end,
	getEnabledFlag = function() -- line: 44
		return game:GetFastFlag("AXDefaultAvatarToShopEnabled3")
	end,
	getEnabledForAllFlag = function() -- line: 48
		return game:GetFastFlag("AXDefaultAvatarToShopEnabledForAll3")
	end,
	variables = {
		EnabledForUser = function(p1, p2) -- line: 57
			local avatarExperienceLandingPage = p1.avatarExperienceLandingPage

			return p2 or not not avatarExperienceLandingPage and (avatarExperienceLandingPage ~= "default" or false)
		end,
		GetFullScreenEnabled = function(p3, p4) -- line: 77
			return p4 or p3.avatarExperienceLandingPage == "shopFullscreen"
		end,
		Row = function(_, _) -- line: 81
			return 2
		end,
		WidgetEnabled = function(_, _) -- line: 85
			return game:GetFastFlag("AXDefaultAvatarToShopWidgetEnabled3")
		end
	}
})
