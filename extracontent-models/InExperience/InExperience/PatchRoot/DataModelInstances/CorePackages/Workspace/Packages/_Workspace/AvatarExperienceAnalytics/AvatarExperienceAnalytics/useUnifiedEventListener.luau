local AvatarExperienceAnalytics = script:FindFirstAncestor("AvatarExperienceAnalytics")
local AvatarExperienceAnalyticsParent = AvatarExperienceAnalytics.Parent
local CollectionService = game:GetService("CollectionService")
local React = require(AvatarExperienceAnalyticsParent.React)
local Cryo = require(AvatarExperienceAnalyticsParent.Cryo)
local sendUnifiedEventLogForInstance = require(script.Parent.sendUnifiedEventLogForInstance)
local UnifiedEventLogConstants = require(script.Parent.UnifiedEventLogConstants)
local resolveClickSurface = require(script.Parent.resolveClickSurface)
local UnifiedEventLoggingUtils = require(AvatarExperienceAnalytics.Utils.UnifiedEventLoggingUtils)
local UnifiedSelectionListStore = require(AvatarExperienceAnalytics.Store.UnifiedSelectionListStore)
local CartIdService = require(AvatarExperienceAnalytics.Lib.CartIdService)
local AvatarExperienceCommon = require(AvatarExperienceAnalyticsParent.AvatarExperienceCommon)
local useSelectorSignal = AvatarExperienceCommon.Hooks.useSelectorSignal
local selectSearchKeyword = AvatarExperienceCommon.State.Selectors.selectSearchKeyword
local AvatarExperienceNavigation = require(AvatarExperienceAnalyticsParent.AvatarExperienceNavigation)
local useAvatarRoute = AvatarExperienceNavigation.AvatarRoute.Hooks.useAvatarRoute
local AvatarScreenProperties = AvatarExperienceNavigation.AvatarRoute.AvatarScreenProperties
local UnifiedLoggingSurface = AvatarExperienceNavigation.Enums.UnifiedLoggingSurface
local AvatarExperienceFlags = require(AvatarExperienceAnalyticsParent.AvatarExperienceFlags)
local FFlagAXMISEnableMultiShoppingUnifiedEvents = AvatarExperienceFlags.FFlagAXMISEnableMultiShoppingUnifiedEvents
local FFlagAXUnifiedImpressionsOnThumbnail = AvatarExperienceFlags.FFlagAXUnifiedImpressionsOnThumbnail

local function markLastActivated(p1) -- line: 25
	-- upvalues: CollectionService (copy), UnifiedEventLogConstants (copy)
	for _, v28 in (CollectionService:GetTagged(UnifiedEventLogConstants.LAST_ACTIVATED_TAG_NAME)) do
		CollectionService:RemoveTag(v28, UnifiedEventLogConstants.LAST_ACTIVATED_TAG_NAME)
	end

	CollectionService:AddTag(p1, UnifiedEventLogConstants.LAST_ACTIVATED_TAG_NAME)
end
local function markSelectionListStatus(p2, b1: boolean) -- line: 36
	-- upvalues: FFlagAXMISEnableMultiShoppingUnifiedEvents (copy), UnifiedEventLoggingUtils (copy), UnifiedEventLogConstants (copy), UnifiedSelectionListStore (copy)
	local Attributes = p2:GetAttributes()

	if FFlagAXMISEnableMultiShoppingUnifiedEvents then
		for v32, v33 in UnifiedEventLoggingUtils.getScreenSize(p2) do
			Attributes[UnifiedEventLogConstants.ATTRIBUTE_PREFIX .. v32] = v33
		end

		for v34, v35 in UnifiedEventLoggingUtils.getElementSizeAndPosition(p2) do
			Attributes[UnifiedEventLogConstants.ATTRIBUTE_PREFIX .. v34] = v35
		end
	end

	if b1 then
		UnifiedSelectionListStore.removeFromSelectionList(Attributes)

		return
	end

	UnifiedSelectionListStore.addToSelectionList(Attributes)
end
local function getChildButton(p3) -- line: 61
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
local function AnalyticsMetadataSelector(t1: {[any]: any}) -- line: 79
	return t1.AvatarExperience.AnalyticsMetadata
end

return {
	useUnifiedEventListener = function() -- line: 182
		-- upvalues: useSelectorSignal (copy), AnalyticsMetadataSelector (copy), selectSearchKeyword (copy), useAvatarRoute (copy), React (copy), CollectionService (copy), UnifiedEventLogConstants (copy), getChildButton (copy), markLastActivated (copy), FFlagAXMISEnableMultiShoppingUnifiedEvents (copy), markSelectionListStatus (copy), Cryo (copy), FFlagAXUnifiedImpressionsOnThumbnail (copy), resolveClickSurface (copy), UnifiedLoggingSurface (copy), AvatarScreenProperties (copy), CartIdService (copy), sendUnifiedEventLogForInstance (copy)
		local v42 = useSelectorSignal(AnalyticsMetadataSelector)
		local v43 = useSelectorSignal(selectSearchKeyword)
		local v44 = useAvatarRoute()
		local v45 = React.useRef(v44)

		React.useEffect(function() -- line: 188
			-- upvalues: v45 (copy), v44 (copy)
			v45.current = v44
		end, { v44 })

		local t2 = {
			getAnalyticsMetadata = v42,
			getSearchKeyword = v43
		}

		React.useEffect(function() -- line: 84
			-- upvalues: CollectionService (copy), UnifiedEventLogConstants (copy), getChildButton (copy), markLastActivated (copy), FFlagAXMISEnableMultiShoppingUnifiedEvents (copy), markSelectionListStatus (copy), t2 (copy), Cryo (copy), FFlagAXUnifiedImpressionsOnThumbnail (copy), resolveClickSurface (copy), v45 (copy), UnifiedLoggingSurface (copy), AvatarScreenProperties (copy), CartIdService (copy), sendUnifiedEventLogForInstance (copy)
			local t3 = {}

			t3.instanceAdded = CollectionService:GetInstanceAddedSignal(UnifiedEventLogConstants.TAG_NAME):Connect(function(p4) -- line: 92
				-- upvalues: getChildButton (copy), UnifiedEventLogConstants (copy), markLastActivated (copy), FFlagAXMISEnableMultiShoppingUnifiedEvents (copy), markSelectionListStatus (copy), t2 (copy), Cryo (copy), FFlagAXUnifiedImpressionsOnThumbnail (copy), resolveClickSurface (copy), v45 (copy), UnifiedLoggingSurface (copy), AvatarScreenProperties (copy), CartIdService (copy), sendUnifiedEventLogForInstance (copy), t3 (ref)
				local v59 = getChildButton(p4)

				if v59 then
					t3[p4] = v59.Activated:Connect(function() -- line: 95
						-- upvalues: p4 (copy), UnifiedEventLogConstants (copy), markLastActivated (copy), FFlagAXMISEnableMultiShoppingUnifiedEvents (copy), markSelectionListStatus (copy), t2 (copy), Cryo (copy), FFlagAXUnifiedImpressionsOnThumbnail (copy), resolveClickSurface (copy), v45 (copy), UnifiedLoggingSurface (copy), AvatarScreenProperties (copy), CartIdService (copy), sendUnifiedEventLogForInstance (copy)
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

						if FFlagAXUnifiedImpressionsOnThumbnail then
							local v77 = p4:GetAttribute(UnifiedEventLogConstants.ATTRIBUTE_PREFIX .. "surface")
							local v78 = resolveClickSurface(p4, if not v45 then nil else v45.current)

							if v78 ~= nil then
								t4.surface = v78
							end

							if ((if v77 == nil then v78 else v77)) ~= UnifiedLoggingSurface.SEARCH_RESULTS then
								t4.keyword = nil
							end
						elseif v45 and v45.current and v45.current.current then
							local v79 = AvatarScreenProperties[v45.current.opaque.name]

							if v79 and v79.analyticsData then
								t4.surface = v79.analyticsData.unifiedLoggingSurface
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
			t3.instanceRemoved = CollectionService:GetInstanceRemovedSignal(UnifiedEventLogConstants.TAG_NAME):Connect(function(p5) -- line: 163
				-- upvalues: t3 (ref)
				local v61 = t3[p5]

				if v61 then
					v61:Disconnect()
				end

				t3[p5] = nil
			end)

			return function() -- line: 172
				-- upvalues: t3 (ref)
				for _, v63 in t3 do
					v63:Disconnect()
				end

				t3 = {}
			end
		end, {})
	end,
	useUnifiedEventListenerInExperience = function() -- line: 198
		-- upvalues: React (copy), CollectionService (copy), UnifiedEventLogConstants (copy), getChildButton (copy), markLastActivated (copy), FFlagAXMISEnableMultiShoppingUnifiedEvents (copy), markSelectionListStatus (copy), Cryo (copy), FFlagAXUnifiedImpressionsOnThumbnail (copy), resolveClickSurface (copy), UnifiedLoggingSurface (copy), AvatarScreenProperties (copy), CartIdService (copy), sendUnifiedEventLogForInstance (copy)
		local v47 = nil
		local v48 = nil

		React.useEffect(function() -- line: 84
			-- upvalues: CollectionService (copy), UnifiedEventLogConstants (copy), getChildButton (copy), markLastActivated (copy), FFlagAXMISEnableMultiShoppingUnifiedEvents (copy), markSelectionListStatus (copy), v47 (copy), Cryo (copy), FFlagAXUnifiedImpressionsOnThumbnail (copy), resolveClickSurface (copy), v48 (copy), UnifiedLoggingSurface (copy), AvatarScreenProperties (copy), CartIdService (copy), sendUnifiedEventLogForInstance (copy)
			local t5 = {}

			t5.instanceAdded = CollectionService:GetInstanceAddedSignal(UnifiedEventLogConstants.TAG_NAME):Connect(function(p6) -- line: 92
				-- upvalues: getChildButton (copy), UnifiedEventLogConstants (copy), markLastActivated (copy), FFlagAXMISEnableMultiShoppingUnifiedEvents (copy), markSelectionListStatus (copy), v47 (copy), Cryo (copy), FFlagAXUnifiedImpressionsOnThumbnail (copy), resolveClickSurface (copy), v48 (copy), UnifiedLoggingSurface (copy), AvatarScreenProperties (copy), CartIdService (copy), sendUnifiedEventLogForInstance (copy), t5 (ref)
				local v65 = getChildButton(p6)

				if v65 then
					t5[p6] = v65.Activated:Connect(function() -- line: 95
						-- upvalues: p6 (copy), UnifiedEventLogConstants (copy), markLastActivated (copy), FFlagAXMISEnableMultiShoppingUnifiedEvents (copy), markSelectionListStatus (copy), v47 (copy), Cryo (copy), FFlagAXUnifiedImpressionsOnThumbnail (copy), resolveClickSurface (copy), v48 (copy), UnifiedLoggingSurface (copy), AvatarScreenProperties (copy), CartIdService (copy), sendUnifiedEventLogForInstance (copy)
						local Attributes = p6:GetAttributes()

						if Attributes[UnifiedEventLogConstants.HAS_DEFERRED_ACTION] then
							markLastActivated(p6)
						end

						if FFlagAXMISEnableMultiShoppingUnifiedEvents and Attributes[UnifiedEventLogConstants.HAS_DEFERRED_ACTION] and Attributes[UnifiedEventLogConstants.IS_SELECTED] ~= nil then
							markSelectionListStatus(p6, Attributes[UnifiedEventLogConstants.IS_SELECTED])
						end

						local t6 = {}

						if v47 then
							t6 = Cryo.Dictionary.join(v47.getAnalyticsMetadata(false), {
								keyword = v47.getSearchKeyword(false)
							})
						end

						if FFlagAXUnifiedImpressionsOnThumbnail then
							local v82 = p6:GetAttribute(UnifiedEventLogConstants.ATTRIBUTE_PREFIX .. "surface")
							local v83 = resolveClickSurface(p6, if not v48 then nil else v48.current)

							if v83 ~= nil then
								t6.surface = v83
							end

							if ((if v82 == nil then v83 else v82)) ~= UnifiedLoggingSurface.SEARCH_RESULTS then
								t6.keyword = nil
							end
						elseif v48 and v48.current and v48.current.current then
							local v84 = AvatarScreenProperties[v48.current.opaque.name]

							if v84 and v84.analyticsData then
								t6.surface = v84.analyticsData.unifiedLoggingSurface
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
			t5.instanceRemoved = CollectionService:GetInstanceRemovedSignal(UnifiedEventLogConstants.TAG_NAME):Connect(function(p7) -- line: 163
				-- upvalues: t5 (ref)
				local v67 = t5[p7]

				if v67 then
					v67:Disconnect()
				end

				t5[p7] = nil
			end)

			return function() -- line: 172
				-- upvalues: t5 (ref)
				for _, v69 in t5 do
					v69:Disconnect()
				end

				t5 = {}
			end
		end, {})
	end
}
