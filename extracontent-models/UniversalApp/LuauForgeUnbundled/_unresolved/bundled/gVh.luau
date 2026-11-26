local appUserLayers = require("@luauforge/bundled/dPQ").AppUserLayers
local module = require("@luauforge/bundled/dPR")

local module2 = require("@luauforge/bundled/gVi")

game:DefineFastFlag("AXDefaultAvatarToShopEnabled3", false)

game:DefineFastFlag("AXDefaultAvatarToShopEnabledForAll3", false)

game:DefineFastString("AXDefaultAvatarToShopLayer3", appUserLayers.AvatarMarketplaceUILayer)

game:DefineFastFlag("AXDefaultAvatarToShopWidgetEnabled3", false)

if module2() then
	return nil
end

return module.defineIXPTest({
	name = "AXDefaultAvatarToShop",
	layer = game:GetFastString("AXDefaultAvatarToShopLayer3"),
	getDependentFlagsEnabled = function(): boolean
		return true
	end,
	getEnabledFlag = function()
		return game:GetFastFlag("AXDefaultAvatarToShopEnabled3")
	end,
	getEnabledForAllFlag = function()
		return game:GetFastFlag("AXDefaultAvatarToShopEnabledForAll3")
	end,
	cacheVariables = true,
	variables = {
		EnabledForUser = function(p2, p3)
			local avatarExperienceLandingPage = p2.avatarExperienceLandingPage
			return p3
				or avatarExperienceLandingPage and avatarExperienceLandingPage ~= "default" and true
				or false
		end,
		GetFullScreenEnabled = function(p2, p3)
			return p3 or p2.avatarExperienceLandingPage == "shopFullscreen"
		end,
		Row = function(p2, p3): number
			return 2
		end,
		WidgetEnabled = function(p2, p3)
			return game:GetFastFlag("AXDefaultAvatarToShopWidgetEnabled3")
		end
	}
})
