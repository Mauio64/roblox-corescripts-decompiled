local parent = script:FindFirstAncestor("AvatarExperienceAnalytics").Parent

local CollectionService = game:GetService("CollectionService")
local Cryo = require(parent.Cryo)
local React = require(parent.React)
local UnifiedEventLogConstants = require(script.Parent.UnifiedEventLogConstants)
local UnifiedEventLogEnums = require(script.Parent.UnifiedEventLogEnums)

local AvatarExperienceScreenSizeImpressionsDetector = require(script.Parent.AvatarExperienceScreenSizeImpressionsDetector)
local AvatarExperienceNavigation = require(parent.AvatarExperienceNavigation)
local useAvatarRoute = AvatarExperienceNavigation.AvatarRoute.Hooks.useAvatarRoute
local AvatarScreenProperties = AvatarExperienceNavigation.AvatarRoute.AvatarScreenProperties
local sendUnifiedEventLogForInstance = require(script.Parent.sendUnifiedEventLogForInstance)
local SeenImpressionsStore = require(script.Parent.Store.SeenImpressionsStore)

local UnifiedImpressions = SeenImpressionsStore.Category.UnifiedImpressions
local AvatarExperienceCommon = require(parent.AvatarExperienceCommon)
local useSelectorSignal = AvatarExperienceCommon.Hooks.useSelectorSignal
local selectSearchKeyword = AvatarExperienceCommon.State.Selectors.selectSearchKeyword

local AvatarExperienceFlags = require(parent.AvatarExperienceFlags)
local FFlagAXItemDetailsIxpExposure = AvatarExperienceFlags.FFlagAXItemDetailsIxpExposure
local FFlagAXUnifiedImpressionsOnThumbnail = AvatarExperienceFlags.FFlagAXUnifiedImpressionsOnThumbnail

local function AnalyticsMetadataSelector(p)
	return p.AvatarExperience.AnalyticsMetadata
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
	local v, v2, v3

	if FFlagAXItemDetailsIxpExposure then
		v = nil
		v2 = nil
		v3 = nil
	else
		v = useAvatarRoute()
		v3 = useSelectorSignal(selectSearchKeyword)
		v2 = useSelectorSignal(AnalyticsMetadataSelector)
	end

	local ref = React.useRef({})
	local ref2

	if FFlagAXItemDetailsIxpExposure then
		ref2 = React.useRef({})
	else
		ref2 = nil
	end

	local filterImpressionFunc = React.useCallback(function(instance): boolean
		if not FFlagAXUnifiedImpressionsOnThumbnail then
			return not ref.current[instance:GetFullName()]
		end

		if instance:GetAttribute(UnifiedEventLogConstants.SKIP_IMPRESSION_DETECTION) then
			return false
		end

		return not SeenImpressionsStore.hasSeen(UnifiedImpressions, getImpressionDedupKey(instance))
	end, {})

	local useCallback = React.useCallback
	local function fn(items)
		local v4 = {}

		for _, item in items do
			local fullName = item:GetFullName()
			local v5

			if FFlagAXUnifiedImpressionsOnThumbnail then
				v5 = SeenImpressionsStore.hasSeen(UnifiedImpressions, getImpressionDedupKey(item))
			else
				v5 = ref.current[fullName]
			end

			if v5 then
				continue
			end

			if FFlagAXItemDetailsIxpExposure then
				v4[fullName] = item

				if not (FFlagAXUnifiedImpressionsOnThumbnail or ref2.current[fullName]) then
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
				local avatarScreenProperty = AvatarScreenProperties[v.current.name]

				local join = Cryo.Dictionary.join
				local v6 = v2(false)
				local v7 = {
					action = UnifiedEventLogEnums.MarketplaceUnifiedAction.ITEM_IMPRESSION,
					surface = 0,
					keyword = 0
				}
				local surface

				if avatarScreenProperty and avatarScreenProperty.analyticsData then
					surface = avatarScreenProperty.analyticsData.unifiedLoggingSurface
				end

				v7.surface = surface

				v7.keyword = v3(false)
				sendUnifiedEventLogForInstance(item, join(v6, v7), {
					includeScreenSize = true,
					includeElementSizeAndPosition = true
				})
			end

			if FFlagAXUnifiedImpressionsOnThumbnail then
				SeenImpressionsStore.markSeen(UnifiedImpressions, getImpressionDedupKey(item))
			else
				ref.current[fullName] = true
			end
		end

		if FFlagAXItemDetailsIxpExposure and next(v4) and props.extensions then
			for _, visibleInstance in v4 do
				for _, extension in props.extensions do
					extension({ visibleInstance = visibleInstance })
				end
			end
		end
	end

	local v4

	if FFlagAXItemDetailsIxpExposure then
		v4 = { props.extensions }
	else
		v4 = { v, v3, v2 }
	end

	local onImpressionsDetected = useCallback(fn, v4)

	if FFlagAXItemDetailsIxpExposure then
		React.useEffect(function()
			return function()
				for _, connection in ref2.current do
					if connection then
						connection:Disconnect()
					end
				end

				ref2.current = {}
			end
		end, {})
	end

	local collectObjectsFunc = React.useCallback(function(ancestor)
		if not FFlagAXUnifiedImpressionsOnThumbnail then
			return CollectionService:GetTagged(UnifiedEventLogConstants.TAG_NAME)
		end

		local tagged = CollectionService:GetTagged(UnifiedEventLogConstants.TAG_NAME)

		if not ancestor then
			return tagged
		end

		local result = {}

		for _, v5 in tagged do
			if v5:IsDescendantOf(ancestor) then
				table.insert(result, v5)
			end
		end

		return result
	end, {})

	return React.createElement(AvatarExperienceScreenSizeImpressionsDetector, {
		parentRef = props.parentRef,
		pageFilter = props.pageFilter,
		onRequestImpressionsSignal = props.requestImpressionsSignal,
		filterImpressionFunc = filterImpressionFunc,
		onImpressionsDetected = onImpressionsDetected,
		collectObjectsFunc = collectObjectsFunc
	})
end
