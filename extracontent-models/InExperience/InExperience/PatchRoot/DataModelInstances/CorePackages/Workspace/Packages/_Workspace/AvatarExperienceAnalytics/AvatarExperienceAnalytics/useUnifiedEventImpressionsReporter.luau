local AvatarExperienceAnalytics = script:FindFirstAncestor("AvatarExperienceAnalytics")
local AvatarExperienceAnalyticsParent = AvatarExperienceAnalytics.Parent
local Cryo = require(AvatarExperienceAnalyticsParent.Cryo)
local React = require(AvatarExperienceAnalyticsParent.React)
local UnifiedEventLogEnums = require(script.Parent.UnifiedEventLogEnums)
local AvatarExperienceNavigation = require(AvatarExperienceAnalyticsParent.AvatarExperienceNavigation)
local useAvatarRoute = AvatarExperienceNavigation.AvatarRoute.Hooks.useAvatarRoute
local AvatarScreenProperties = AvatarExperienceNavigation.AvatarRoute.AvatarScreenProperties
local UnifiedLoggingSurface = AvatarExperienceNavigation.Enums.UnifiedLoggingSurface
local sendUnifiedEventLogForInstance = require(script.Parent.sendUnifiedEventLogForInstance)
local AvatarExperienceCommon = require(AvatarExperienceAnalyticsParent.AvatarExperienceCommon)
local useSelectorSignal = AvatarExperienceCommon.Hooks.useSelectorSignal
local selectSearchKeyword = AvatarExperienceCommon.State.Selectors.selectSearchKeyword
local UnifiedEventLoggingUtils = require(AvatarExperienceAnalytics.Utils.UnifiedEventLoggingUtils)
local FFlagAXUnifiedImpressionsOnThumbnail = require(AvatarExperienceAnalyticsParent.AvatarExperienceFlags).FFlagAXUnifiedImpressionsOnThumbnail
local UnifiedEventLogConstants = require(script.Parent.UnifiedEventLogConstants)

local function selectAnalyticsMetadata(p1) -- line: 20
	return p1.AvatarExperience.AnalyticsMetadata
end
local function useUnifiedEventImpressionsReporter(s1: string?) -- line: 24
	-- upvalues: useAvatarRoute (copy), useSelectorSignal (copy), selectSearchKeyword (copy), selectAnalyticsMetadata (copy), React (copy), AvatarScreenProperties (copy), UnifiedEventLoggingUtils (copy), UnifiedEventLogEnums (copy), FFlagAXUnifiedImpressionsOnThumbnail (copy), UnifiedEventLogConstants (copy), UnifiedLoggingSurface (copy), sendUnifiedEventLogForInstance (copy), Cryo (copy)
	local v21 = useAvatarRoute()
	local v22 = useSelectorSignal(selectSearchKeyword)
	local v23 = useSelectorSignal(selectAnalyticsMetadata)

	return React.useCallback(function(t1: {[any]: any}) -- line: 32
		-- upvalues: AvatarScreenProperties (copy), v21 (copy), UnifiedEventLoggingUtils (copy), UnifiedEventLogEnums (copy), FFlagAXUnifiedImpressionsOnThumbnail (copy), s1 (copy), v22 (copy), UnifiedEventLogConstants (copy), UnifiedLoggingSurface (copy), sendUnifiedEventLogForInstance (copy), Cryo (copy), v23 (copy)
		local visibleInstance = t1.visibleInstance
		local v26 = AvatarScreenProperties[v21.opaque.name]
		local v27 = nil

		for v28, v29 in (visibleInstance:GetAttributes()) do
			if not UnifiedEventLoggingUtils.isUnifiedLoggingAttribute(v28) or UnifiedEventLoggingUtils.getUnifiedLoggingFieldName(v28) ~= "action" then
				continue
			end

			if v29 == UnifiedEventLogEnums.MarketplaceUnifiedAction.WIDGET_IMPRESSION then
				v27 = true
			end

			if v29 == UnifiedEventLogEnums.MarketplaceUnifiedAction.PURCHASE_ATTEMPT or v29 == UnifiedEventLogEnums.MarketplaceUnifiedAction.UI_ELEMENT_CLICK then
				return
			end
		end

		if FFlagAXUnifiedImpressionsOnThumbnail then
			local v30 = AvatarScreenProperties[s1 or v21.opaque.name]
			local t2 = {
				action = if not v27 then UnifiedEventLogEnums.MarketplaceUnifiedAction.ITEM_IMPRESSION else UnifiedEventLogEnums.MarketplaceUnifiedAction.WIDGET_IMPRESSION,
				keyword = v22(false)
			}

			if visibleInstance:GetAttribute(UnifiedEventLogConstants.ATTRIBUTE_PREFIX .. "surface") == nil then
				t2.surface = if not v30 or not v30.analyticsData then nil else v30.analyticsData.unifiedLoggingSurface
			end

			if (t2.surface or visibleInstance:GetAttribute(UnifiedEventLogConstants.ATTRIBUTE_PREFIX .. "surface")) ~= UnifiedLoggingSurface.SEARCH_RESULTS then
				t2.keyword = nil
			end

			sendUnifiedEventLogForInstance(visibleInstance, Cryo.Dictionary.union(v23(false), t2), {
				includeScreenSize = true,
				includeElementSizeAndPosition = true
			})

			return
		end

		sendUnifiedEventLogForInstance(visibleInstance, Cryo.Dictionary.join(v23(false), {
			action = if not v27 then UnifiedEventLogEnums.MarketplaceUnifiedAction.ITEM_IMPRESSION else UnifiedEventLogEnums.MarketplaceUnifiedAction.WIDGET_IMPRESSION,
			surface = if not v26 or not v26.analyticsData then nil else v26.analyticsData.unifiedLoggingSurface,
			keyword = v22(false)
		}), {
			includeScreenSize = true,
			includeElementSizeAndPosition = true
		})
	end, {
		v21,
		v22,
		v23,
		if not FFlagAXUnifiedImpressionsOnThumbnail then nil else s1
	})
end

return useUnifiedEventImpressionsReporter
