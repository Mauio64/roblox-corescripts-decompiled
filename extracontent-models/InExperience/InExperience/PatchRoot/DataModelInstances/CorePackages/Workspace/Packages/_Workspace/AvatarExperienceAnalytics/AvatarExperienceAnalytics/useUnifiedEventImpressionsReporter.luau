local AvatarExperienceAnalytics = script:FindFirstAncestor("AvatarExperienceAnalytics")
local parent = AvatarExperienceAnalytics.Parent

local Cryo = require(parent.Cryo)
local React = require(parent.React)
local UnifiedEventLogEnums = require(script.Parent.UnifiedEventLogEnums)
local AvatarExperienceNavigation = require(parent.AvatarExperienceNavigation)
local useAvatarRoute = AvatarExperienceNavigation.AvatarRoute.Hooks.useAvatarRoute
local AvatarScreenProperties = AvatarExperienceNavigation.AvatarRoute.AvatarScreenProperties
local UnifiedLoggingSurface = AvatarExperienceNavigation.Enums.UnifiedLoggingSurface
local sendUnifiedEventLogForInstance = require(script.Parent.sendUnifiedEventLogForInstance)
local AvatarExperienceCommon = require(parent.AvatarExperienceCommon)
local useSelectorSignal = AvatarExperienceCommon.Hooks.useSelectorSignal
local selectSearchKeyword = AvatarExperienceCommon.State.Selectors.selectSearchKeyword
local UnifiedEventLoggingUtils = require(AvatarExperienceAnalytics.Utils.UnifiedEventLoggingUtils)
local mapAnalyticsMetadataFields = require(AvatarExperienceAnalytics.Utils.mapAnalyticsMetadataFields)
local AvatarExperienceFlags = require(parent.AvatarExperienceFlags)
local FFlagAXUnifiedImpressionsOnThumbnail = AvatarExperienceFlags.FFlagAXUnifiedImpressionsOnThumbnail
local FFlagAXUnifiedEventStrictPayloads = AvatarExperienceFlags.FFlagAXUnifiedEventStrictPayloads
local UnifiedEventLogConstants = require(script.Parent.UnifiedEventLogConstants)

local function selectAnalyticsMetadata(p)
	return p.AvatarExperience.AnalyticsMetadata
end

local function useUnifiedEventImpressionsReporter(p: string?)
	local v = useAvatarRoute()
	local v2 = useSelectorSignal(selectSearchKeyword)
	local v3 = useSelectorSignal(selectAnalyticsMetadata)

	local useCallback = React.useCallback
	local function fn(p2)
		local visibleInstance = p2.visibleInstance
		local avatarScreenProperty = AvatarScreenProperties[v.opaque.name]

		local attributes = visibleInstance:GetAttributes()
		local v4 = nil

		for k, attribute in attributes do
			if not (UnifiedEventLoggingUtils.isUnifiedLoggingAttribute(k) and UnifiedEventLoggingUtils.getUnifiedLoggingFieldName(k) == "action") then
				continue
			end

			v4 = attribute == UnifiedEventLogEnums.MarketplaceUnifiedAction.WIDGET_IMPRESSION or v4

			if
				attribute == UnifiedEventLogEnums.MarketplaceUnifiedAction.PURCHASE_ATTEMPT
				or attribute == UnifiedEventLogEnums.MarketplaceUnifiedAction.UI_ELEMENT_CLICK
			then
				return
			end
		end

		if FFlagAXUnifiedImpressionsOnThumbnail then
			local avatarScreenProperty2 = AvatarScreenProperties[p or v.opaque.name]
			local action

			if v4 then
				action = UnifiedEventLogEnums.MarketplaceUnifiedAction.WIDGET_IMPRESSION
			else
				action = UnifiedEventLogEnums.MarketplaceUnifiedAction.ITEM_IMPRESSION
			end

			local v5 = { action = action, keyword = v2(false) }

			if visibleInstance:GetAttribute(UnifiedEventLogConstants.ATTRIBUTE_PREFIX .. "surface") == nil then
				local surface

				if avatarScreenProperty2 and avatarScreenProperty2.analyticsData then
					surface = avatarScreenProperty2.analyticsData.unifiedLoggingSurface
				end

				v5.surface = surface
			end

			if (v5.surface or visibleInstance:GetAttribute(UnifiedEventLogConstants.ATTRIBUTE_PREFIX .. "surface")) ~= UnifiedLoggingSurface.SEARCH_RESULTS then
				v5.keyword = nil
			end

			local join = Cryo.Dictionary.join
			local v6

			if FFlagAXUnifiedEventStrictPayloads then
				v6 = mapAnalyticsMetadataFields(v3(false), true)
			else
				v6 = v3(false)
			end

			local v7 = join(v6, { selectedItemIndex = Cryo.None })

			sendUnifiedEventLogForInstance(visibleInstance, Cryo.Dictionary.union(v7, v5), {
				includeScreenSize = true,
				includeElementSizeAndPosition = true
			})
		elseif FFlagAXUnifiedEventStrictPayloads then
			local join = Cryo.Dictionary.join
			local v5 = mapAnalyticsMetadataFields(v3(false), true)
			local action

			if v4 then
				action = UnifiedEventLogEnums.MarketplaceUnifiedAction.WIDGET_IMPRESSION
			else
				action = UnifiedEventLogEnums.MarketplaceUnifiedAction.ITEM_IMPRESSION
			end

			local surface

			if avatarScreenProperty and avatarScreenProperty.analyticsData then
				surface = avatarScreenProperty.analyticsData.unifiedLoggingSurface
			end

			sendUnifiedEventLogForInstance(
				visibleInstance,
				join(v5, { action = action, surface = surface, keyword = v2(false) }),
				{ includeScreenSize = true, includeElementSizeAndPosition = true }
			)
		else
			local join = Cryo.Dictionary.join
			local v5 = v3(false)
			local action

			if v4 then
				action = UnifiedEventLogEnums.MarketplaceUnifiedAction.WIDGET_IMPRESSION
			else
				action = UnifiedEventLogEnums.MarketplaceUnifiedAction.ITEM_IMPRESSION
			end

			local surface

			if avatarScreenProperty and avatarScreenProperty.analyticsData then
				surface = avatarScreenProperty.analyticsData.unifiedLoggingSurface
			end

			sendUnifiedEventLogForInstance(
				visibleInstance,
				join(v5, { action = action, surface = surface, keyword = v2(false) }),
				{ includeScreenSize = true, includeElementSizeAndPosition = true }
			)
		end
	end

	local v4

	if FFlagAXUnifiedImpressionsOnThumbnail then
		v4 = p
	end

	return useCallback(fn, { v, v2, v3, v4 })
end

return useUnifiedEventImpressionsReporter
