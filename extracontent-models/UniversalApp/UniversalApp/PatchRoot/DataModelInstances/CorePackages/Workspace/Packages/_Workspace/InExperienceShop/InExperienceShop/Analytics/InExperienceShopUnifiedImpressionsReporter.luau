local Parent = script:FindFirstAncestor("InExperienceShop").Parent
local AvatarExperienceAnalytics = require(Parent.AvatarExperienceAnalytics)
local UnifiedEventLogEnums = AvatarExperienceAnalytics.UnifiedEventLogEnums
local sendUnifiedEventLogForInstance = AvatarExperienceAnalytics.sendUnifiedEventLogForInstance
local UnifiedLoggingSurface = require(Parent.AvatarExperienceNavigation).Enums.UnifiedLoggingSurface
local Constants = require(script.Parent.Constants)

local function InExperienceShopUnifiedImpressionsReporter(s1: string) -- line: 12
	-- upvalues: Constants (copy), UnifiedLoggingSurface (copy), sendUnifiedEventLogForInstance (copy), UnifiedEventLogEnums (copy)
	return function(t1: {[any]: any}) -- line: 13
		-- upvalues: s1 (copy), Constants (copy), UnifiedLoggingSurface (copy), sendUnifiedEventLogForInstance (copy), UnifiedEventLogEnums (copy)
		local visibleInstance = t1.visibleInstance
		local v11 = if s1 ~= Constants.ShopPageType.Home then if s1 ~= Constants.ShopPageType.Search then UnifiedLoggingSurface.IN_EXPERIENCE_SHOP_DETAILS else UnifiedLoggingSurface.IN_EXPERIENCE_SHOP_SEARCH else UnifiedLoggingSurface.IN_EXPERIENCE_SHOP_HOME

		sendUnifiedEventLogForInstance(visibleInstance, {
			action = UnifiedEventLogEnums.MarketplaceUnifiedAction.ITEM_IMPRESSION,
			surface = v11
		}, {
			includeScreenSize = true,
			includeElementSizeAndPosition = true
		})
	end
end

return InExperienceShopUnifiedImpressionsReporter
