local AvatarExperienceAnalytics = script:FindFirstAncestor("AvatarExperienceAnalytics")
local AvatarExperienceAnalyticsParent = AvatarExperienceAnalytics.Parent
local CollectionService = game:GetService("CollectionService")
local React = require(AvatarExperienceAnalyticsParent.React)
local Cryo = require(AvatarExperienceAnalyticsParent.Cryo)
local sendUnifiedEventLogForInstance = require(script.Parent.sendUnifiedEventLogForInstance)
local UnifiedEventLogConstants = require(script.Parent.UnifiedEventLogConstants)
local UnifiedEventLoggingUtils = require(AvatarExperienceAnalytics.Utils.UnifiedEventLoggingUtils)
local UnifiedSelectionListStore = require(AvatarExperienceAnalytics.Store.UnifiedSelectionListStore)
local CartIdService = require(AvatarExperienceAnalytics.Lib.CartIdService)
local AvatarExperienceCommon = require(AvatarExperienceAnalyticsParent.AvatarExperienceCommon)
local useSelectorSignal = AvatarExperienceCommon.Hooks.useSelectorSignal
local selectSearchKeyword = AvatarExperienceCommon.State.Selectors.selectSearchKeyword
local AvatarExperienceNavigation = require(AvatarExperienceAnalyticsParent.AvatarExperienceNavigation)
local useAvatarRoute = AvatarExperienceNavigation.AvatarRoute.Hooks.useAvatarRoute
local AvatarScreenProperties = AvatarExperienceNavigation.AvatarRoute.AvatarScreenProperties
local FFlagAXMISEnableMultiShoppingUnifiedEvents = require(AvatarExperienceAnalyticsParent.AvatarExperienceFlags).FFlagAXMISEnableMultiShoppingUnifiedEvents

local function markLastActivated(p1) -- line: 22
	-- upvalues: CollectionService (copy), UnifiedEventLogConstants (copy)
	for _, v24 in (CollectionService:GetTagged(UnifiedEventLogConstants.LAST_ACTIVATED_TAG_NAME)) do
		CollectionService:RemoveTag(v24, UnifiedEventLogConstants.LAST_ACTIVATED_TAG_NAME)
	end

	CollectionService:AddTag(p1, UnifiedEventLogConstants.LAST_ACTIVATED_TAG_NAME)
end
local function markSelectionListStatus(p2, b1: boolean) -- line: 33
	-- upvalues: FFlagAXMISEnableMultiShoppingUnifiedEvents (copy), UnifiedEventLoggingUtils (copy), UnifiedEventLogConstants (copy), UnifiedSelectionListStore (copy)
	local Attributes = p2:GetAttributes()

	if FFlagAXMISEnableMultiShoppingUnifiedEvents then
		for v28, v29 in UnifiedEventLoggingUtils.getScreenSize(p2) do
			Attributes[UnifiedEventLogConstants.ATTRIBUTE_PREFIX .. v28] = v29
		end

		for v30, v31 in UnifiedEventLoggingUtils.getElementSizeAndPosition(p2) do
			Attributes[UnifiedEventLogConstants.ATTRIBUTE_PREFIX .. v30] = v31
		end
	end

	if b1 then
		UnifiedSelectionListStore.removeFromSelectionList(Attributes)

		return
	end

	UnifiedSelectionListStore.addToSelectionList(Attributes)
end
local function getChildButton(p3) -- line: 58
	if not p3 then
		return nil
	end

	if p3:IsA("TextButton") or p3:IsA("ImageButton") or p3:IsA("GuiButton") then
		return p3
	end

	for _, _ in p3:GetDescendants() do
		if p3:IsA("TextButton") or p3:IsA("ImageButton") or p3:IsA("GuiButton") then
			return p3
		end
	end

	return nil
end
local function AnalyticsMetadataSelector(t1: {[any]: any}) -- line: 76
	return t1.AvatarExperience.AnalyticsMetadata
end

return {
	useUnifiedEventListener = function() -- line: 161
		-- upvalues: useSelectorSignal (copy), AnalyticsMetadataSelector (copy), selectSearchKeyword (copy), useAvatarRoute (copy), React (copy), CollectionService (copy), UnifiedEventLogConstants (copy), getChildButton (copy), markLastActivated (copy), FFlagAXMISEnableMultiShoppingUnifiedEvents (copy), markSelectionListStatus (copy), Cryo (copy), AvatarScreenProperties (copy), CartIdService (copy), sendUnifiedEventLogForInstance (copy)
		local v38 = useSelectorSignal(AnalyticsMetadataSelector)
		local v39 = useSelectorSignal(selectSearchKeyword)
		local v40 = useAvatarRoute()
		local v41 = React.useRef(v40)

		React.useEffect(function() -- line: 167
			-- upvalues: v41 (copy), v40 (copy)
			v41.current = v40
		end, { v40 })

		local t2 = {
			getAnalyticsMetadata = v38,
			getSearchKeyword = v39
		}

		React.useEffect(function() -- line: 81
			-- upvalues: CollectionService (copy), UnifiedEventLogConstants (copy), getChildButton (copy), markLastActivated (copy), FFlagAXMISEnableMultiShoppingUnifiedEvents (copy), markSelectionListStatus (copy), t2 (copy), Cryo (copy), v41 (copy), AvatarScreenProperties (copy), CartIdService (copy), sendUnifiedEventLogForInstance (copy)
			local t3 = {}

			t3.instanceAdded = CollectionService:GetInstanceAddedSignal(UnifiedEventLogConstants.TAG_NAME):Connect(function(p4) -- line: 89
				-- upvalues: getChildButton (copy), UnifiedEventLogConstants (copy), markLastActivated (copy), FFlagAXMISEnableMultiShoppingUnifiedEvents (copy), markSelectionListStatus (copy), t2 (copy), Cryo (copy), v41 (copy), AvatarScreenProperties (copy), CartIdService (copy), sendUnifiedEventLogForInstance (copy), t3 (ref)
				local v55 = getChildButton(p4)

				if v55 then
					t3[p4] = v55.Activated:Connect(function() -- line: 92
						-- upvalues: p4 (copy), UnifiedEventLogConstants (copy), markLastActivated (copy), FFlagAXMISEnableMultiShoppingUnifiedEvents (copy), markSelectionListStatus (copy), t2 (copy), Cryo (copy), v41 (copy), AvatarScreenProperties (copy), CartIdService (copy), sendUnifiedEventLogForInstance (copy)
						local Attributes = p4:GetAttributes()

						if Attributes[UnifiedEventLogConstants.HAS_DEFERRED_ACTION] then
							markLastActivated(p4)
						end

						if FFlagAXMISEnableMultiShoppingUnifiedEvents and Attributes[UnifiedEventLogConstants.HAS_DEFERRED_ACTION] and Attributes[UnifiedEventLogConstants.IS_SELECTED] ~= nil then
							markSelectionListStatus(p4, Attributes[UnifiedEventLogConstants.IS_SELECTED])
						end

						local t4 = {}

						if t2 then
							t4 = Cryo.Dictionary.join(t2.getAnalyticsMetadata(false), {
								keyword = t2.getSearchKeyword(false)
							})
						end

						if v41 and v41.current and v41.current.current then
							local v71 = AvatarScreenProperties[v41.current.opaque.name]

							if v71 and v71.analyticsData then
								t4.surface = v71.analyticsData.unifiedLoggingSurface
							end
						end

						if FFlagAXMISEnableMultiShoppingUnifiedEvents and Attributes[UnifiedEventLogConstants.HAS_DEFERRED_ACTION] then
							t4.cartId = CartIdService.getCartId()
						end

						sendUnifiedEventLogForInstance(p4, t4, {
							includeScreenSize = true,
							includeElementSizeAndPosition = true
						})
					end)
				end
			end)
			t3.instanceRemoved = CollectionService:GetInstanceRemovedSignal(UnifiedEventLogConstants.TAG_NAME):Connect(function(p5) -- line: 142
				-- upvalues: t3 (ref)
				local v57 = t3[p5]

				if v57 then
					v57:Disconnect()
				end

				t3[p5] = nil
			end)

			return function() -- line: 151
				-- upvalues: t3 (ref)
				for _, v59 in t3 do
					v59:Disconnect()
				end

				t3 = {}
			end
		end, {})
	end,
	useUnifiedEventListenerInExperience = function() -- line: 177
		-- upvalues: React (copy), CollectionService (copy), UnifiedEventLogConstants (copy), getChildButton (copy), markLastActivated (copy), FFlagAXMISEnableMultiShoppingUnifiedEvents (copy), markSelectionListStatus (copy), Cryo (copy), AvatarScreenProperties (copy), CartIdService (copy), sendUnifiedEventLogForInstance (copy)
		local v43 = nil
		local v44 = nil

		React.useEffect(function() -- line: 81
			-- upvalues: CollectionService (copy), UnifiedEventLogConstants (copy), getChildButton (copy), markLastActivated (copy), FFlagAXMISEnableMultiShoppingUnifiedEvents (copy), markSelectionListStatus (copy), v43 (copy), Cryo (copy), v44 (copy), AvatarScreenProperties (copy), CartIdService (copy), sendUnifiedEventLogForInstance (copy)
			local t5 = {}

			t5.instanceAdded = CollectionService:GetInstanceAddedSignal(UnifiedEventLogConstants.TAG_NAME):Connect(function(p6) -- line: 89
				-- upvalues: getChildButton (copy), UnifiedEventLogConstants (copy), markLastActivated (copy), FFlagAXMISEnableMultiShoppingUnifiedEvents (copy), markSelectionListStatus (copy), v43 (copy), Cryo (copy), v44 (copy), AvatarScreenProperties (copy), CartIdService (copy), sendUnifiedEventLogForInstance (copy), t5 (ref)
				local v61 = getChildButton(p6)

				if v61 then
					t5[p6] = v61.Activated:Connect(function() -- line: 92
						-- upvalues: p6 (copy), UnifiedEventLogConstants (copy), markLastActivated (copy), FFlagAXMISEnableMultiShoppingUnifiedEvents (copy), markSelectionListStatus (copy), v43 (copy), Cryo (copy), v44 (copy), AvatarScreenProperties (copy), CartIdService (copy), sendUnifiedEventLogForInstance (copy)
						local Attributes = p6:GetAttributes()

						if Attributes[UnifiedEventLogConstants.HAS_DEFERRED_ACTION] then
							markLastActivated(p6)
						end

						if FFlagAXMISEnableMultiShoppingUnifiedEvents and Attributes[UnifiedEventLogConstants.HAS_DEFERRED_ACTION] and Attributes[UnifiedEventLogConstants.IS_SELECTED] ~= nil then
							markSelectionListStatus(p6, Attributes[UnifiedEventLogConstants.IS_SELECTED])
						end

						local t6 = {}

						if v43 then
							t6 = Cryo.Dictionary.join(v43.getAnalyticsMetadata(false), {
								keyword = v43.getSearchKeyword(false)
							})
						end

						if v44 and v44.current and v44.current.current then
							local v74 = AvatarScreenProperties[v44.current.opaque.name]

							if v74 and v74.analyticsData then
								t6.surface = v74.analyticsData.unifiedLoggingSurface
							end
						end

						if FFlagAXMISEnableMultiShoppingUnifiedEvents and Attributes[UnifiedEventLogConstants.HAS_DEFERRED_ACTION] then
							t6.cartId = CartIdService.getCartId()
						end

						sendUnifiedEventLogForInstance(p6, t6, {
							includeScreenSize = true,
							includeElementSizeAndPosition = true
						})
					end)
				end
			end)
			t5.instanceRemoved = CollectionService:GetInstanceRemovedSignal(UnifiedEventLogConstants.TAG_NAME):Connect(function(p7) -- line: 142
				-- upvalues: t5 (ref)
				local v63 = t5[p7]

				if v63 then
					v63:Disconnect()
				end

				t5[p7] = nil
			end)

			return function() -- line: 151
				-- upvalues: t5 (ref)
				for _, v65 in t5 do
					v65:Disconnect()
				end

				t5 = {}
			end
		end, {})
	end
}
