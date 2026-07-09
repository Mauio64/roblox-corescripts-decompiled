local EdpStoreAnalytics = script:FindFirstAncestor("EdpStoreAnalytics")
local EdpStoreAnalyticsParent = EdpStoreAnalytics.Parent
local Cryo = require(EdpStoreAnalyticsParent.Cryo)
local AvatarExperienceAnalytics = require(EdpStoreAnalyticsParent.AvatarExperienceAnalytics)
local UnifiedEventLogEnums = AvatarExperienceAnalytics.UnifiedEventLogEnums
local UnifiedLoggingSurface = require(EdpStoreAnalyticsParent.AvatarExperienceNavigation).Enums.UnifiedLoggingSurface
local sendUnifiedEventLogForInstance = AvatarExperienceAnalytics.sendUnifiedEventLogForInstance
local Constants = require(EdpStoreAnalytics.Constants)

local function EdpUnifiedImpressionsReporter(s1: string) -- line: 14
	-- upvalues: sendUnifiedEventLogForInstance (copy), Cryo (copy), UnifiedEventLogEnums (copy), Constants (copy), UnifiedLoggingSurface (copy)
	return function(t1: {[any]: any}) -- line: 15
		-- upvalues: sendUnifiedEventLogForInstance (copy), Cryo (copy), UnifiedEventLogEnums (copy), s1 (copy), Constants (copy), UnifiedLoggingSurface (copy)
		local visibleInstance = t1.visibleInstance
		local v13 = visibleInstance:GetAttributes() or {}

		sendUnifiedEventLogForInstance(visibleInstance, Cryo.Dictionary.join(v13, {
			action = UnifiedEventLogEnums.MarketplaceUnifiedAction.ITEM_IMPRESSION,
			surface = if s1 ~= Constants.StoreEnums.LocationType.Edp then UnifiedLoggingSurface.EDP_STORE else UnifiedLoggingSurface.EDP_PREVIEW
		}), {
			includeScreenSize = true,
			includeElementSizeAndPosition = true
		})
	end
end

return EdpUnifiedImpressionsReporter
