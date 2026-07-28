local Parent = script:FindFirstAncestor("AvatarExperienceAnalytics").Parent
local CollectionService = game:GetService("CollectionService")
local Cryo = require(Parent.Cryo)
local React = require(Parent.React)
local UnifiedEventLogConstants = require(script.Parent.UnifiedEventLogConstants)
local UnifiedEventLogEnums = require(script.Parent.UnifiedEventLogEnums)
local AvatarExperienceScreenSizeImpressionsDetector = require(script.Parent.AvatarExperienceScreenSizeImpressionsDetector)
local AvatarExperienceNavigation = require(Parent.AvatarExperienceNavigation)
local useAvatarRoute = AvatarExperienceNavigation.AvatarRoute.Hooks.useAvatarRoute
local AvatarScreenProperties = AvatarExperienceNavigation.AvatarRoute.AvatarScreenProperties
local sendUnifiedEventLogForInstance = require(script.Parent.sendUnifiedEventLogForInstance)
local SeenImpressionsStore = require(script.Parent.Store.SeenImpressionsStore)
local UnifiedImpressions = SeenImpressionsStore.Category.UnifiedImpressions
local AvatarExperienceCommon = require(Parent.AvatarExperienceCommon)
local useSelectorSignal = AvatarExperienceCommon.Hooks.useSelectorSignal
local selectSearchKeyword = AvatarExperienceCommon.State.Selectors.selectSearchKeyword
local AvatarExperienceFlags = require(Parent.AvatarExperienceFlags)
local FFlagAXItemDetailsIxpExposure = AvatarExperienceFlags.FFlagAXItemDetailsIxpExposure
local FFlagAXUnifiedImpressionsOnThumbnail = AvatarExperienceFlags.FFlagAXUnifiedImpressionsOnThumbnail

local function AnalyticsMetadataSelector(p1) -- line: 36
	return p1.AvatarExperience.AnalyticsMetadata
end
local function getImpressionDedupKey(p2) -- line: 40
	-- upvalues: UnifiedEventLogConstants (copy)
	local ATTRIBUTE_PREFIX = UnifiedEventLogConstants.ATTRIBUTE_PREFIX
	local v25 = p2:GetAttribute(ATTRIBUTE_PREFIX .. "widgetId")
	local v26 = p2:GetAttribute(ATTRIBUTE_PREFIX .. "itemId")

	if v26 ~= nil then
		return string.format("item|%s|%s|%s|%s|%s", tostring(v25), tostring(v26), tostring(p2:GetAttribute(ATTRIBUTE_PREFIX .. "gridPositionRow")), tostring(p2:GetAttribute(ATTRIBUTE_PREFIX .. "gridPositionColumn")), (tostring(p2:GetAttribute(ATTRIBUTE_PREFIX .. "itemPosition"))))
	end

	if v25 ~= nil then
		return "widget|" .. tostring(v25)
	end

	return p2:GetFullName()
end

return function(t1: {[any]: any}) -- line: 59
	-- upvalues: FFlagAXItemDetailsIxpExposure (copy), useAvatarRoute (copy), useSelectorSignal (copy), selectSearchKeyword (copy), AnalyticsMetadataSelector (copy), React (copy), FFlagAXUnifiedImpressionsOnThumbnail (copy), UnifiedEventLogConstants (copy), SeenImpressionsStore (copy), UnifiedImpressions (copy), getImpressionDedupKey (copy), AvatarScreenProperties (copy), sendUnifiedEventLogForInstance (copy), Cryo (copy), UnifiedEventLogEnums (copy), CollectionService (copy), AvatarExperienceScreenSizeImpressionsDetector (copy)
	local u28 = nil
	local u29 = nil
	local u30 = nil

	if not FFlagAXItemDetailsIxpExposure then
		u28 = useAvatarRoute()
		u29 = useSelectorSignal(selectSearchKeyword)
		u30 = useSelectorSignal(AnalyticsMetadataSelector)
	end

	local v31 = React.useRef({})
	local u32 = nil

	if FFlagAXItemDetailsIxpExposure then
		u32 = React.useRef({})
	end

	local v33 = React.useCallback(function(p3) -- line: 75
		-- upvalues: FFlagAXUnifiedImpressionsOnThumbnail (copy), UnifiedEventLogConstants (copy), SeenImpressionsStore (copy), UnifiedImpressions (copy), getImpressionDedupKey (copy), v31 (copy)
		if FFlagAXUnifiedImpressionsOnThumbnail then
			if p3:GetAttribute(UnifiedEventLogConstants.SKIP_IMPRESSION_DETECTION) then
				return false
			end

			return not SeenImpressionsStore.hasSeen(UnifiedImpressions, getImpressionDedupKey(p3))
		end

		return not v31.current[p3:GetFullName()]
	end, {})
	local v34 = React.useCallback(function(p4) -- line: 86
		-- upvalues: FFlagAXUnifiedImpressionsOnThumbnail (copy), SeenImpressionsStore (copy), UnifiedImpressions (copy), getImpressionDedupKey (copy), v31 (copy), FFlagAXItemDetailsIxpExposure (copy), u32 (ref), AvatarScreenProperties (copy), u28 (ref), sendUnifiedEventLogForInstance (copy), Cryo (copy), u30 (ref), UnifiedEventLogEnums (copy), u29 (ref), t1 (copy)
		local t2 = {}

		for _, v40 in p4 do
			local FullName = v40:GetFullName()

			if not if not FFlagAXUnifiedImpressionsOnThumbnail then v31.current[FullName] else SeenImpressionsStore.hasSeen(UnifiedImpressions, getImpressionDedupKey(v40)) then
				if FFlagAXItemDetailsIxpExposure then
					t2[FullName] = v40

					if not FFlagAXUnifiedImpressionsOnThumbnail and not u32.current[FullName] then
						u32.current[FullName] = v40.AncestryChanged:Connect(function() -- line: 106
							-- upvalues: v40 (copy), v31 (copy), FullName (copy), u32 (ref)
							if not v40.Parent then
								v31.current[FullName] = nil

								if u32.current[FullName] then
									u32.current[FullName]:Disconnect()
									u32.current[FullName] = nil
								end
							end
						end)
					end
				else
					local v42 = AvatarScreenProperties[u28.current.name]

					sendUnifiedEventLogForInstance(v40, Cryo.Dictionary.join(u30(false), {
						action = UnifiedEventLogEnums.MarketplaceUnifiedAction.ITEM_IMPRESSION,
						surface = if not v42 or not v42.analyticsData then nil else v42.analyticsData.unifiedLoggingSurface,
						keyword = u29(false)
					}), {
						includeScreenSize = true,
						includeElementSizeAndPosition = true
					})
				end

				if FFlagAXUnifiedImpressionsOnThumbnail then
					SeenImpressionsStore.markSeen(UnifiedImpressions, getImpressionDedupKey(v40))
				else
					v31.current[FullName] = true
				end
			end
		end

		if FFlagAXItemDetailsIxpExposure and next(t2) and t1.extensions then
			for _, v44 in t2 do
				for _, v46 in t1.extensions do
					v46({
						visibleInstance = v44
					})
				end
			end
		end
	end, if not FFlagAXItemDetailsIxpExposure then {
		u28,
		u29,
		u30
	} else { t1.extensions })

	if FFlagAXItemDetailsIxpExposure then
		React.useEffect(function() -- line: 162
			-- upvalues: u32 (ref)
			return function() -- line: 163
				-- upvalues: u32 (ref)
				for _, v53 in u32.current do
					if v53 then
						v53:Disconnect()
					end
				end

				u32.current = {}
			end
		end, {})
	end

	local v35 = React.useCallback(function(p5) -- line: 174
		-- upvalues: FFlagAXUnifiedImpressionsOnThumbnail (copy), CollectionService (copy), UnifiedEventLogConstants (copy)
		if FFlagAXUnifiedImpressionsOnThumbnail then
			local UnifiedEventLogConstantsTAG_NAME = CollectionService:GetTagged(UnifiedEventLogConstants.TAG_NAME)

			if p5 then
				local t3 = {}

				for _, v51 in UnifiedEventLogConstantsTAG_NAME do
					if v51:IsDescendantOf(p5) then
						table.insert(t3, v51)
					end
				end

				return t3
			end

			return UnifiedEventLogConstantsTAG_NAME
		end

		return CollectionService:GetTagged(UnifiedEventLogConstants.TAG_NAME)
	end, {})

	return React.createElement(AvatarExperienceScreenSizeImpressionsDetector, {
		parentRef = t1.parentRef,
		pageFilter = t1.pageFilter,
		onRequestImpressionsSignal = t1.requestImpressionsSignal,
		filterImpressionFunc = v33,
		onImpressionsDetected = v34,
		collectObjectsFunc = v35
	})
end
