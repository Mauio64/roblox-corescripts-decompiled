local EdpStoreAnalytics = script:FindFirstAncestor("EdpStoreAnalytics")
local parent = EdpStoreAnalytics.Parent

local Cryo = require(parent.Cryo)

local AvatarExperienceAnalytics = require(parent.AvatarExperienceAnalytics)
local UnifiedEventLogEnums = AvatarExperienceAnalytics.UnifiedEventLogEnums
local AvatarExperienceNavigation = require(parent.AvatarExperienceNavigation)
local UnifiedLoggingSurface = AvatarExperienceNavigation.Enums.UnifiedLoggingSurface
local sendUnifiedEventLogForInstance = AvatarExperienceAnalytics.sendUnifiedEventLogForInstance

local Constants = require(EdpStoreAnalytics.Constants)

local function EdpUnifiedImpressionsReporter(p: string)
	return function(p2)
		local visibleInstance = p2.visibleInstance
		local attributes = visibleInstance:GetAttributes() or {}

		local join = Cryo.Dictionary.join
		local v = {
			action = UnifiedEventLogEnums.MarketplaceUnifiedAction.ITEM_IMPRESSION,
			surface = 0
		}
		local surface

		if p == Constants.StoreEnums.LocationType.Edp then
			surface = UnifiedLoggingSurface.EDP_PREVIEW
		else
			surface = UnifiedLoggingSurface.EDP_STORE
		end

		v.surface = surface
		sendUnifiedEventLogForInstance(visibleInstance, join(attributes, v), {
			includeScreenSize = true,
			includeElementSizeAndPosition = true
		})
	end
end

return EdpUnifiedImpressionsReporter
