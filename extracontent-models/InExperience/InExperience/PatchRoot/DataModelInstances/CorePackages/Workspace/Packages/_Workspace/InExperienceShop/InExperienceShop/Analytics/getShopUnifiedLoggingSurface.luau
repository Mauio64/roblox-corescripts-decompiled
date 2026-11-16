local parent = script:FindFirstAncestor("InExperienceShop").Parent

local AvatarExperienceNavigation = require(parent.AvatarExperienceNavigation)
local UnifiedLoggingSurface = AvatarExperienceNavigation.Enums.UnifiedLoggingSurface

local Constants = require(script.Parent.Constants)

local function getShopUnifiedLoggingSurface(p: string?)
	if p == Constants.ShopPageType.Home then
		return UnifiedLoggingSurface.IN_EXPERIENCE_SHOP_HOME
	end

	if p == Constants.ShopPageType.Search then
		return UnifiedLoggingSurface.IN_EXPERIENCE_SHOP_SEARCH
	end

	return UnifiedLoggingSurface.IN_EXPERIENCE_SHOP_DETAILS
end

return getShopUnifiedLoggingSurface
