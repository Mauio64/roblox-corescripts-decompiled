local Cryo = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceAnalytics/Cryo")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceAnalytics/React")
local UnifiedEventLogEnums = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceAnalytics/AvatarExperienceAnalytics/UnifiedEventLogEnums")
local AvatarExperienceNavigation = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceAnalytics/AvatarExperienceNavigation")
local useAvatarRoute = AvatarExperienceNavigation.AvatarRoute.Hooks.useAvatarRoute
local avatarScreenProperties = AvatarExperienceNavigation.AvatarRoute.AvatarScreenProperties
local unifiedLoggingSurface = AvatarExperienceNavigation.Enums.UnifiedLoggingSurface
local sendUnifiedEventLogForInstance = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceAnalytics/AvatarExperienceAnalytics/sendUnifiedEventLogForInstance")
local AvatarExperienceCommon = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceAnalytics/AvatarExperienceCommon")
local useSelectorSignal = AvatarExperienceCommon.Hooks.useSelectorSignal
local selectSearchKeyword = AvatarExperienceCommon.State.Selectors.selectSearchKeyword
local UnifiedEventLoggingUtils = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceAnalytics/AvatarExperienceAnalytics/Utils/UnifiedEventLoggingUtils")
local mapAnalyticsMetadataFields = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceAnalytics/AvatarExperienceAnalytics/Utils/mapAnalyticsMetadataFields")
local AvatarExperienceFlags = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceAnalytics/AvatarExperienceFlags")
local fFlagAXUnifiedImpressionsOnThumbnail = AvatarExperienceFlags.FFlagAXUnifiedImpressionsOnThumbnail
local fFlagAXUnifiedEventStrictPayloads = AvatarExperienceFlags.FFlagAXUnifiedEventStrictPayloads
local UnifiedEventLogConstants = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceAnalytics/AvatarExperienceAnalytics/UnifiedEventLogConstants")

local function selectAnalyticsMetadata(p2)
	return p2.AvatarExperience.AnalyticsMetadata
end

local function useUnifiedEventImpressionsReporter(p2)
	local v5 = useAvatarRoute()
	local v6 = useSelectorSignal(selectSearchKeyword)
	local v7 = useSelectorSignal(selectAnalyticsMetadata)

	local function fn(p3)
		local visibleInstance = p3.visibleInstance
		local avatarScreenProperty = avatarScreenProperties[v5.opaque.name]

		local attributes = visibleInstance:GetAttributes()
		local v8 = nil

		for k, attribute in attributes do
			if not (UnifiedEventLoggingUtils.isUnifiedLoggingAttribute(k) and UnifiedEventLoggingUtils.getUnifiedLoggingFieldName(k) == "action") then
				continue
			end

			v8 = attribute == UnifiedEventLogEnums.MarketplaceUnifiedAction.WIDGET_IMPRESSION or v8

			if
				attribute == UnifiedEventLogEnums.MarketplaceUnifiedAction.PURCHASE_ATTEMPT
				or attribute == UnifiedEventLogEnums.MarketplaceUnifiedAction.UI_ELEMENT_CLICK
			then
				return
			end
		end

		if fFlagAXUnifiedImpressionsOnThumbnail then
			local avatarScreenProperty2 = avatarScreenProperties[p2 or v5.opaque.name]

			local v10 = if v8 then UnifiedEventLogEnums.MarketplaceUnifiedAction.WIDGET_IMPRESSION else UnifiedEventLogEnums.MarketplaceUnifiedAction.ITEM_IMPRESSION
			local v9 = { action = v10, keyword = v6(false) }

			if visibleInstance:GetAttribute(UnifiedEventLogConstants.ATTRIBUTE_PREFIX .. "surface") == nil then
				local v11 = if avatarScreenProperty2 and avatarScreenProperty2.analyticsData then avatarScreenProperty2.analyticsData.unifiedLoggingSurface else nil
				v9.surface = v11
			end

			if (v9.surface or visibleInstance:GetAttribute(UnifiedEventLogConstants.ATTRIBUTE_PREFIX .. "surface")) ~= unifiedLoggingSurface.SEARCH_RESULTS then
				v9.keyword = nil
			end

			local join = Cryo.Dictionary.join

			local v11 = if fFlagAXUnifiedEventStrictPayloads then mapAnalyticsMetadataFields(v7(false), true) else v7(false)
			local v12 = join(v11, { selectedItemIndex = Cryo.None })

			sendUnifiedEventLogForInstance(visibleInstance, Cryo.Dictionary.union(v12, v9), {
				includeScreenSize = true,
				includeElementSizeAndPosition = true
			})
		elseif fFlagAXUnifiedEventStrictPayloads then
			local join = Cryo.Dictionary.join
			local v10 = mapAnalyticsMetadataFields(v7(false), true)

			local v12 = if v8 then UnifiedEventLogEnums.MarketplaceUnifiedAction.WIDGET_IMPRESSION else UnifiedEventLogEnums.MarketplaceUnifiedAction.ITEM_IMPRESSION
			local v13 = if avatarScreenProperty and avatarScreenProperty.analyticsData then avatarScreenProperty.analyticsData.unifiedLoggingSurface else nil
			sendUnifiedEventLogForInstance(visibleInstance, join(v10, {
				action = v12,
				surface = v13,
				keyword = v6(false)
			}), {
				includeScreenSize = true,
				includeElementSizeAndPosition = true
			})
		else
			local join = Cryo.Dictionary.join
			local v10 = v7(false)

			local v12 = if v8 then UnifiedEventLogEnums.MarketplaceUnifiedAction.WIDGET_IMPRESSION else UnifiedEventLogEnums.MarketplaceUnifiedAction.ITEM_IMPRESSION
			local v13 = if avatarScreenProperty and avatarScreenProperty.analyticsData then avatarScreenProperty.analyticsData.unifiedLoggingSurface else nil
			sendUnifiedEventLogForInstance(visibleInstance, join(v10, {
				action = v12,
				surface = v13,
				keyword = v6(false)
			}), {
				includeScreenSize = true,
				includeElementSizeAndPosition = true
			})
		end
	end

	return React.useCallback(fn, {
		v5,
		v6,
		v7,
		if fFlagAXUnifiedImpressionsOnThumbnail then p2 else nil
	})
end

return useUnifiedEventImpressionsReporter
