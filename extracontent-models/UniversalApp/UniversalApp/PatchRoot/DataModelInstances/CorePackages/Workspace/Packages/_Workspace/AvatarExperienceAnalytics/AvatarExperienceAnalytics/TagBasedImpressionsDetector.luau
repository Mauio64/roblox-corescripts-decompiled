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
local AvatarExperienceCommon = require(Parent.AvatarExperienceCommon)
local useSelectorSignal = AvatarExperienceCommon.Hooks.useSelectorSignal
local selectSearchKeyword = AvatarExperienceCommon.State.Selectors.selectSearchKeyword
local FFlagAXItemDetailsIxpExposure = require(Parent.AvatarExperienceFlags).FFlagAXItemDetailsIxpExposure

local function AnalyticsMetadataSelector(p1) -- line: 31
	return p1.AvatarExperience.AnalyticsMetadata
end

return function(t1: {[any]: any}) -- line: 35
	-- upvalues: FFlagAXItemDetailsIxpExposure (copy), useAvatarRoute (copy), useSelectorSignal (copy), selectSearchKeyword (copy), AnalyticsMetadataSelector (copy), React (copy), AvatarScreenProperties (copy), sendUnifiedEventLogForInstance (copy), Cryo (copy), UnifiedEventLogEnums (copy), CollectionService (copy), UnifiedEventLogConstants (copy), AvatarExperienceScreenSizeImpressionsDetector (copy)
	local u19 = nil
	local u20 = nil
	local u21 = nil

	if not FFlagAXItemDetailsIxpExposure then
		u19 = useAvatarRoute()
		u20 = useSelectorSignal(selectSearchKeyword)
		u21 = useSelectorSignal(AnalyticsMetadataSelector)
	end

	local v22 = React.useRef({})
	local u23 = nil

	if FFlagAXItemDetailsIxpExposure then
		u23 = React.useRef({})
	end

	local v24 = React.useCallback(function(p2) -- line: 51
		-- upvalues: v22 (copy)
		return not v22.current[p2:GetFullName()]
	end, {})
	local v25 = React.useCallback(function(p3) -- line: 56
		-- upvalues: v22 (copy), FFlagAXItemDetailsIxpExposure (copy), u23 (ref), AvatarScreenProperties (copy), u19 (ref), sendUnifiedEventLogForInstance (copy), Cryo (copy), u21 (ref), UnifiedEventLogEnums (copy), u20 (ref), t1 (copy)
		local t2 = {}

		for _, v31 in p3 do
			local FullName = v31:GetFullName()

			if not v22.current[FullName] then
				if FFlagAXItemDetailsIxpExposure then
					t2[FullName] = v31

					if not u23.current[FullName] then
						u23.current[FullName] = v31.AncestryChanged:Connect(function() -- line: 69
							-- upvalues: v31 (copy), v22 (copy), FullName (copy), u23 (ref)
							if not v31.Parent then
								v22.current[FullName] = nil

								if u23.current[FullName] then
									u23.current[FullName]:Disconnect()
									u23.current[FullName] = nil
								end
							end
						end)
					end
				else
					local v33 = AvatarScreenProperties[u19.current.name]

					sendUnifiedEventLogForInstance(v31, Cryo.Dictionary.join(u21(false), {
						action = UnifiedEventLogEnums.MarketplaceUnifiedAction.ITEM_IMPRESSION,
						surface = if not v33 or not v33.analyticsData then nil else v33.analyticsData.unifiedLoggingSurface,
						keyword = u20(false)
					}), {
						includeScreenSize = true,
						includeElementSizeAndPosition = true
					})
				end

				v22.current[FullName] = true
			end
		end

		if FFlagAXItemDetailsIxpExposure and next(t2) and t1.extensions then
			for _, v35 in t2 do
				for _, v37 in t1.extensions do
					v37({
						visibleInstance = v35
					})
				end
			end
		end
	end, if not FFlagAXItemDetailsIxpExposure then {
		u19,
		u20,
		u21
	} else { t1.extensions })

	if FFlagAXItemDetailsIxpExposure then
		React.useEffect(function() -- line: 121
			-- upvalues: u23 (ref)
			return function() -- line: 122
				-- upvalues: u23 (ref)
				for _, v39 in u23.current do
					if v39 then
						v39:Disconnect()
					end
				end

				u23.current = {}
			end
		end, {})
	end

	local v26 = React.useCallback(function() -- line: 133
		-- upvalues: CollectionService (copy), UnifiedEventLogConstants (copy)
		return CollectionService:GetTagged(UnifiedEventLogConstants.TAG_NAME)
	end, {})

	return React.createElement(AvatarExperienceScreenSizeImpressionsDetector, {
		parentRef = t1.parentRef,
		pageFilter = t1.pageFilter,
		onRequestImpressionsSignal = t1.requestImpressionsSignal,
		filterImpressionFunc = v24,
		onImpressionsDetected = v25,
		collectObjectsFunc = v26
	})
end
