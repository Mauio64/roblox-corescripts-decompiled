local CollectionService = game:GetService("CollectionService")
local Cryo = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceAnalytics/Cryo")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceAnalytics/React")
local UnifiedEventLogConstants = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceAnalytics/AvatarExperienceAnalytics/UnifiedEventLogConstants")
local UnifiedEventLogEnums = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceAnalytics/AvatarExperienceAnalytics/UnifiedEventLogEnums")

local AvatarExperienceScreenSizeImpressionsDetector = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceAnalytics/AvatarExperienceAnalytics/AvatarExperienceScreenSizeImpressionsDetector")
local AvatarExperienceNavigation = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceAnalytics/AvatarExperienceNavigation")
local useAvatarRoute = AvatarExperienceNavigation.AvatarRoute.Hooks.useAvatarRoute
local avatarScreenProperties = AvatarExperienceNavigation.AvatarRoute.AvatarScreenProperties
local sendUnifiedEventLogForInstance = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceAnalytics/AvatarExperienceAnalytics/sendUnifiedEventLogForInstance")
local SeenImpressionsStore = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceAnalytics/AvatarExperienceAnalytics/Store/SeenImpressionsStore")

local unifiedImpressions = SeenImpressionsStore.Category.UnifiedImpressions
local AvatarExperienceCommon = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceAnalytics/AvatarExperienceCommon")
local useSelectorSignal = AvatarExperienceCommon.Hooks.useSelectorSignal
local selectSearchKeyword = AvatarExperienceCommon.State.Selectors.selectSearchKeyword

local AvatarExperienceFlags = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceAnalytics/AvatarExperienceFlags")
local fFlagAXItemDetailsIxpExposure = AvatarExperienceFlags.FFlagAXItemDetailsIxpExposure
local fFlagAXUnifiedImpressionsOnThumbnail = AvatarExperienceFlags.FFlagAXUnifiedImpressionsOnThumbnail

local function AnalyticsMetadataSelector(p2)
	return p2.AvatarExperience.AnalyticsMetadata
end

local function getImpressionDedupKey(instance)
	local ATTRIBUTE_PREFIX = UnifiedEventLogConstants.ATTRIBUTE_PREFIX
	local attribute = instance:GetAttribute(ATTRIBUTE_PREFIX .. "widgetId")
	local attribute2 = instance:GetAttribute(ATTRIBUTE_PREFIX .. "itemId")

	if attribute2 ~= nil then
		return string.format(
			"item|%s|%s|%s|%s|%s",
			tostring(attribute),
			tostring(attribute2),
			tostring(instance:GetAttribute(ATTRIBUTE_PREFIX .. "gridPositionRow")),
			tostring(instance:GetAttribute(ATTRIBUTE_PREFIX .. "gridPositionColumn")),
			(tostring(instance:GetAttribute(ATTRIBUTE_PREFIX .. "itemPosition")))
		)
	end

	if attribute == nil then
		return instance:GetFullName()
	end

	return "widget|" .. tostring(attribute)
end

return function(props)
	local v5, v6, v7

	if fFlagAXItemDetailsIxpExposure then
		v5 = nil
		v6 = nil
		v7 = nil
	else
		v5 = useAvatarRoute()
		v7 = useSelectorSignal(selectSearchKeyword)
		v6 = useSelectorSignal(AnalyticsMetadataSelector)
	end

	local ref = React.useRef({})

	local ref2 = if fFlagAXItemDetailsIxpExposure then React.useRef({}) else nil

	local v8 = React.useCallback(function(instance): boolean
		if not fFlagAXUnifiedImpressionsOnThumbnail then
			return not ref.current[instance:GetFullName()]
		end

		if instance:GetAttribute(UnifiedEventLogConstants.SKIP_IMPRESSION_DETECTION) then
			return false
		end

		return not SeenImpressionsStore.hasSeen(unifiedImpressions, getImpressionDedupKey(instance))
	end, {})

	local useCallback = React.useCallback
	local function fn(items)
		local v9 = {}

		for k, item in items do
			local fullName = item:GetFullName()
			local v10

			if fFlagAXUnifiedImpressionsOnThumbnail then
				v10 = SeenImpressionsStore.hasSeen(unifiedImpressions, getImpressionDedupKey(item))
			else
				v10 = ref.current[fullName]
			end

			if v10 then
				continue
			end

			if fFlagAXItemDetailsIxpExposure then
				v9[fullName] = item

				if not (fFlagAXUnifiedImpressionsOnThumbnail or ref2.current[fullName]) then
					ref2.current[fullName] = item.AncestryChanged:Connect(function()
						if not item.Parent then
							ref.current[fullName] = nil

							if ref2.current[fullName] then
								ref2.current[fullName]:Disconnect()
								ref2.current[fullName] = nil
							end
						end
					end)
				end
			else
				local avatarScreenProperty = avatarScreenProperties[v5.current.name]

				local join = Cryo.Dictionary.join
				local v12 = v6(false)
				local v13 = {
					action = UnifiedEventLogEnums.MarketplaceUnifiedAction.ITEM_IMPRESSION,
					surface = 0,
					keyword = 0
				}
				local v14 = if avatarScreenProperty and avatarScreenProperty.analyticsData then avatarScreenProperty.analyticsData.unifiedLoggingSurface else nil
				v13.surface = v14

				v13.keyword = v7(false)
				sendUnifiedEventLogForInstance(item, join(v12, v13), {
					includeScreenSize = true,
					includeElementSizeAndPosition = true
				})
			end

			if fFlagAXUnifiedImpressionsOnThumbnail then
				SeenImpressionsStore.markSeen(unifiedImpressions, getImpressionDedupKey(item))
			else
				ref.current[fullName] = true
			end
		end

		if fFlagAXItemDetailsIxpExposure and next(v9) and props.extensions then
			for k, v10 in v9 do
				for k2, extension in props.extensions do
					extension({ visibleInstance = v10 })
				end
			end
		end
	end

	local v9

	if fFlagAXItemDetailsIxpExposure then
		v9 = { props.extensions }
	else
		v9 = { v5, v7, v6 }
	end

	local v10 = useCallback(fn, v9)

	if fFlagAXItemDetailsIxpExposure then
		React.useEffect(function()
			return function()
				for k, connection in ref2.current do
					if connection then
						connection:Disconnect()
					end
				end

				ref2.current = {}
			end
		end, {})
	end

	local v11 = React.useCallback(function(ancestor)
		if not fFlagAXUnifiedImpressionsOnThumbnail then
			return CollectionService:GetTagged(UnifiedEventLogConstants.TAG_NAME)
		end

		local tagged = CollectionService:GetTagged(UnifiedEventLogConstants.TAG_NAME)

		if not ancestor then
			return tagged
		end

		local result = {}

		for k, v12 in tagged do
			if v12:IsDescendantOf(ancestor) then
				table.insert(result, v12)
			end
		end

		return result
	end, {})

	return React.createElement(AvatarExperienceScreenSizeImpressionsDetector, {
		parentRef = props.parentRef,
		pageFilter = props.pageFilter,
		onRequestImpressionsSignal = props.requestImpressionsSignal,
		filterImpressionFunc = v8,
		onImpressionsDetected = v10,
		collectObjectsFunc = v11
	})
end
