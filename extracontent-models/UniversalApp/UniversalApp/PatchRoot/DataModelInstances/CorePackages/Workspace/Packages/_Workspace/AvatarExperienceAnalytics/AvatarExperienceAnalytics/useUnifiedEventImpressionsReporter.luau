local AvatarExperienceAnalytics = script:FindFirstAncestor("AvatarExperienceAnalytics")
local AvatarExperienceAnalyticsParent = AvatarExperienceAnalytics.Parent
local Cryo = require(AvatarExperienceAnalyticsParent.Cryo)
local React = require(AvatarExperienceAnalyticsParent.React)
local UnifiedEventLogEnums = require(script.Parent.UnifiedEventLogEnums)
local AvatarExperienceNavigation = require(AvatarExperienceAnalyticsParent.AvatarExperienceNavigation)
local useAvatarRoute = AvatarExperienceNavigation.AvatarRoute.Hooks.useAvatarRoute
local AvatarScreenProperties = AvatarExperienceNavigation.AvatarRoute.AvatarScreenProperties
local sendUnifiedEventLogForInstance = require(script.Parent.sendUnifiedEventLogForInstance)
local AvatarExperienceCommon = require(AvatarExperienceAnalyticsParent.AvatarExperienceCommon)
local useSelectorSignal = AvatarExperienceCommon.Hooks.useSelectorSignal
local selectSearchKeyword = AvatarExperienceCommon.State.Selectors.selectSearchKeyword
local UnifiedEventLoggingUtils = require(AvatarExperienceAnalytics.Utils.UnifiedEventLoggingUtils)

local function selectAnalyticsMetadata(p1) -- line: 16
	return p1.AvatarExperience.AnalyticsMetadata
end
local function useUnifiedEventImpressionsReporter() -- line: 20
	-- upvalues: useAvatarRoute (copy), useSelectorSignal (copy), selectSearchKeyword (copy), selectAnalyticsMetadata (copy), React (copy), AvatarScreenProperties (copy), UnifiedEventLoggingUtils (copy), UnifiedEventLogEnums (copy), sendUnifiedEventLogForInstance (copy), Cryo (copy)
	local v17 = useAvatarRoute()
	local v18 = useSelectorSignal(selectSearchKeyword)
	local v19 = useSelectorSignal(selectAnalyticsMetadata)

	return React.useCallback(function(t1: {[any]: any}) -- line: 25
		-- upvalues: AvatarScreenProperties (copy), v17 (copy), UnifiedEventLoggingUtils (copy), UnifiedEventLogEnums (copy), sendUnifiedEventLogForInstance (copy), Cryo (copy), v19 (copy), v18 (copy)
		local visibleInstance = t1.visibleInstance
		local v22 = AvatarScreenProperties[v17.opaque.name]
		local v23 = nil

		for v24, v25 in (visibleInstance:GetAttributes()) do
			if not UnifiedEventLoggingUtils.isUnifiedLoggingAttribute(v24) or UnifiedEventLoggingUtils.getUnifiedLoggingFieldName(v24) ~= "action" then
				continue
			end

			if v25 == UnifiedEventLogEnums.MarketplaceUnifiedAction.WIDGET_IMPRESSION then
				v23 = true
			end

			if v25 == UnifiedEventLogEnums.MarketplaceUnifiedAction.PURCHASE_ATTEMPT or v25 == UnifiedEventLogEnums.MarketplaceUnifiedAction.UI_ELEMENT_CLICK then
				return
			end
		end

		sendUnifiedEventLogForInstance(visibleInstance, Cryo.Dictionary.join(v19(false), {
			action = if not v23 then UnifiedEventLogEnums.MarketplaceUnifiedAction.ITEM_IMPRESSION else UnifiedEventLogEnums.MarketplaceUnifiedAction.WIDGET_IMPRESSION,
			surface = if not v22 or not v22.analyticsData then nil else v22.analyticsData.unifiedLoggingSurface,
			keyword = v18(false)
		}), {
			includeScreenSize = true,
			includeElementSizeAndPosition = true
		})
	end, {
		v17,
		v18,
		v19
	})
end

return useUnifiedEventImpressionsReporter
