local Parent = script:FindFirstAncestor("InExperienceShop").Parent
local AvatarExperienceAnalytics = require(Parent.AvatarExperienceAnalytics)
local UnifiedEventLogEnums = AvatarExperienceAnalytics.UnifiedEventLogEnums
local sendUnifiedEventLogForInstance = AvatarExperienceAnalytics.sendUnifiedEventLogForInstance
local FFlagAllowCustomUnifiedEventFilter = AvatarExperienceAnalytics.Flags.FFlagAllowCustomUnifiedEventFilter
local UnifiedLoggingSurface = require(Parent.AvatarExperienceNavigation).Enums.UnifiedLoggingSurface
local Constants = require(script.Parent.Constants)
local InExperienceShopUnifiedEventFilter = require(script.Parent.InExperienceShopUnifiedEventFilter)

local function InExperienceShopUnifiedImpressionsReporter(s1: string) -- line: 14
	-- upvalues: Constants (copy), UnifiedLoggingSurface (copy), FFlagAllowCustomUnifiedEventFilter (copy), InExperienceShopUnifiedEventFilter (copy), sendUnifiedEventLogForInstance (copy), UnifiedEventLogEnums (copy)
	return function(t1: {[any]: any}) -- line: 15
		-- upvalues: s1 (copy), Constants (copy), UnifiedLoggingSurface (copy), FFlagAllowCustomUnifiedEventFilter (copy), InExperienceShopUnifiedEventFilter (copy), sendUnifiedEventLogForInstance (copy), UnifiedEventLogEnums (copy)
		local visibleInstance = t1.visibleInstance
		local v13 = if s1 ~= Constants.ShopPageType.Home then if s1 ~= Constants.ShopPageType.Search then UnifiedLoggingSurface.IN_EXPERIENCE_SHOP_DETAILS else UnifiedLoggingSurface.IN_EXPERIENCE_SHOP_SEARCH else UnifiedLoggingSurface.IN_EXPERIENCE_SHOP_HOME
		local v14 = if not FFlagAllowCustomUnifiedEventFilter then nil else InExperienceShopUnifiedEventFilter.filter

		sendUnifiedEventLogForInstance(visibleInstance, {
			action = UnifiedEventLogEnums.MarketplaceUnifiedAction.ITEM_IMPRESSION,
			surface = v13
		}, {
			includeScreenSize = true,
			includeElementSizeAndPosition = true,
			filter = v14
		})
	end
end

return InExperienceShopUnifiedImpressionsReporter
