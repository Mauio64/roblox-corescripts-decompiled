local AvatarExperienceAnalytics = script:FindFirstAncestor("AvatarExperienceAnalytics")
local AvatarExperienceAnalyticsParent = AvatarExperienceAnalytics.Parent
local CollectionService = game:GetService("CollectionService")
local React = require(AvatarExperienceAnalyticsParent.React)
local Cryo = require(AvatarExperienceAnalyticsParent.Cryo)
local sendUnifiedEventLogForInstance = require(script.Parent.sendUnifiedEventLogForInstance)
local UnifiedEventLogConstants = require(script.Parent.UnifiedEventLogConstants)
local UnifiedEventLogEnums = require(script.Parent.UnifiedEventLogEnums)
local resolveClickSurface = require(script.Parent.resolveClickSurface)
local applyClickStampFieldOverrides = require(script.Parent.applyClickStampFieldOverrides)
local UnifiedEventLoggingUtils = require(AvatarExperienceAnalytics.Utils.UnifiedEventLoggingUtils)
local getDeferredPurchaseSourceTile = require(AvatarExperienceAnalytics.Utils.getDeferredPurchaseSourceTile)
local UnifiedSelectionListStore = require(AvatarExperienceAnalytics.Store.UnifiedSelectionListStore)
local LastDeferredSingleItemStore = require(AvatarExperienceAnalytics.Store.LastDeferredSingleItemStore)
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
local FFlagAXFixSingleItemPurchaseWidgetLogging = AvatarExperienceFlags.FFlagAXFixSingleItemPurchaseWidgetLogging

local function markLastActivated(p1) -- line: 30
	-- upvalues: CollectionService (copy), UnifiedEventLogConstants (copy)
	for _, v33 in (CollectionService:GetTagged(UnifiedEventLogConstants.LAST_ACTIVATED_TAG_NAME)) do
		CollectionService:RemoveTag(v33, UnifiedEventLogConstants.LAST_ACTIVATED_TAG_NAME)
	end

	CollectionService:AddTag(p1, UnifiedEventLogConstants.LAST_ACTIVATED_TAG_NAME)
end
local function markSelectionListStatus(p2, b1: boolean) -- line: 41
	-- upvalues: FFlagAXMISEnableMultiShoppingUnifiedEvents (copy), UnifiedEventLoggingUtils (copy), UnifiedEventLogConstants (copy), UnifiedSelectionListStore (copy)
	local Attributes = p2:GetAttributes()

	if FFlagAXMISEnableMultiShoppingUnifiedEvents then
		for v37, v38 in UnifiedEventLoggingUtils.getScreenSize(p2) do
			Attributes[UnifiedEventLogConstants.ATTRIBUTE_PREFIX .. v37] = v38
		end

		for v39, v40 in UnifiedEventLoggingUtils.getElementSizeAndPosition(p2) do
			Attributes[UnifiedEventLogConstants.ATTRIBUTE_PREFIX .. v39] = v40
		end
	end

	if b1 then
		UnifiedSelectionListStore.removeFromSelectionList(Attributes)

		return
	end

	UnifiedSelectionListStore.addToSelectionList(Attributes)
end
local function getChildButton(p3) -- line: 66
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
local function AnalyticsMetadataSelector(t1: {[any]: any}) -- line: 84
	return t1.AvatarExperience.AnalyticsMetadata
end

return {
	useUnifiedEventListener = function() -- line: 236
		-- upvalues: useSelectorSignal (copy), AnalyticsMetadataSelector (copy), selectSearchKeyword (copy), useAvatarRoute (copy), React (copy), CollectionService (copy), UnifiedEventLogConstants (copy), getChildButton (copy), markLastActivated (copy), FFlagAXMISEnableMultiShoppingUnifiedEvents (copy), markSelectionListStatus (copy), FFlagAXFixSingleItemPurchaseWidgetLogging (copy), UnifiedEventLogEnums (copy), getDeferredPurchaseSourceTile (copy), UnifiedEventLoggingUtils (copy), LastDeferredSingleItemStore (copy), Cryo (copy), FFlagAXUnifiedImpressionsOnThumbnail (copy), resolveClickSurface (copy), UnifiedLoggingSurface (copy), AvatarScreenProperties (copy), CartIdService (copy), applyClickStampFieldOverrides (copy), sendUnifiedEventLogForInstance (copy)
		local v47 = useSelectorSignal(AnalyticsMetadataSelector)
		local v48 = useSelectorSignal(selectSearchKeyword)
		local v49 = useAvatarRoute()
		local v50 = React.useRef(v49)

		React.useEffect(function() -- line: 242
			-- upvalues: v50 (copy), v49 (copy)
			v50.current = v49
		end, { v49 })

		local t2 = {
			getAnalyticsMetadata = v47,
			getSearchKeyword = v48
		}

		React.useEffect(function() -- line: 89
			-- upvalues: CollectionService (copy), UnifiedEventLogConstants (copy), getChildButton (copy), markLastActivated (copy), FFlagAXMISEnableMultiShoppingUnifiedEvents (copy), markSelectionListStatus (copy), FFlagAXFixSingleItemPurchaseWidgetLogging (copy), UnifiedEventLogEnums (copy), getDeferredPurchaseSourceTile (copy), UnifiedEventLoggingUtils (copy), LastDeferredSingleItemStore (copy), t2 (copy), Cryo (copy), FFlagAXUnifiedImpressionsOnThumbnail (copy), resolveClickSurface (copy), v50 (copy), UnifiedLoggingSurface (copy), AvatarScreenProperties (copy), CartIdService (copy), applyClickStampFieldOverrides (copy), sendUnifiedEventLogForInstance (copy)
			local t3 = {}

			t3.instanceAdded = CollectionService:GetInstanceAddedSignal(UnifiedEventLogConstants.TAG_NAME):Connect(function(p4) -- line: 97
				-- upvalues: getChildButton (copy), UnifiedEventLogConstants (copy), markLastActivated (copy), FFlagAXMISEnableMultiShoppingUnifiedEvents (copy), markSelectionListStatus (copy), FFlagAXFixSingleItemPurchaseWidgetLogging (copy), UnifiedEventLogEnums (copy), getDeferredPurchaseSourceTile (copy), CollectionService (copy), UnifiedEventLoggingUtils (copy), LastDeferredSingleItemStore (copy), t2 (copy), Cryo (copy), FFlagAXUnifiedImpressionsOnThumbnail (copy), resolveClickSurface (copy), v50 (copy), UnifiedLoggingSurface (copy), AvatarScreenProperties (copy), CartIdService (copy), applyClickStampFieldOverrides (copy), sendUnifiedEventLogForInstance (copy), t3 (ref)
				local v64 = getChildButton(p4)

				if v64 then
					t3[p4] = v64.Activated:Connect(function() -- line: 100
						-- upvalues: p4 (copy), UnifiedEventLogConstants (copy), markLastActivated (copy), FFlagAXMISEnableMultiShoppingUnifiedEvents (copy), markSelectionListStatus (copy), FFlagAXFixSingleItemPurchaseWidgetLogging (copy), UnifiedEventLogEnums (copy), getDeferredPurchaseSourceTile (copy), CollectionService (copy), UnifiedEventLoggingUtils (copy), LastDeferredSingleItemStore (copy), t2 (copy), Cryo (copy), FFlagAXUnifiedImpressionsOnThumbnail (copy), resolveClickSurface (copy), v50 (copy), UnifiedLoggingSurface (copy), AvatarScreenProperties (copy), CartIdService (copy), applyClickStampFieldOverrides (copy), sendUnifiedEventLogForInstance (copy)
						local Attributes = p4:GetAttributes()

						if Attributes[UnifiedEventLogConstants.HAS_DEFERRED_ACTION] then
							markLastActivated(p4)
						end

						if FFlagAXMISEnableMultiShoppingUnifiedEvents and Attributes[UnifiedEventLogConstants.HAS_DEFERRED_ACTION] and Attributes[UnifiedEventLogConstants.IS_SELECTED] ~= nil then
							markSelectionListStatus(p4, Attributes[UnifiedEventLogConstants.IS_SELECTED])
						end

						if FFlagAXFixSingleItemPurchaseWidgetLogging and FFlagAXMISEnableMultiShoppingUnifiedEvents and Attributes[UnifiedEventLogConstants.ATTRIBUTE_PREFIX .. "action"] == UnifiedEventLogEnums.MarketplaceUnifiedAction.PURCHASE_ATTEMPT then
							local v87 = getDeferredPurchaseSourceTile(CollectionService:GetTagged(UnifiedEventLogConstants.TAG_NAME), p4, Attributes[UnifiedEventLogConstants.ATTRIBUTE_PREFIX .. "itemId"], Attributes[UnifiedEventLogConstants.ATTRIBUTE_PREFIX .. "itemType"]) or p4
							local Attributes2 = v87:GetAttributes()

							for v89, v90 in UnifiedEventLoggingUtils.getScreenSize(v87) do
								Attributes2[UnifiedEventLogConstants.ATTRIBUTE_PREFIX .. v89] = v90
							end

							for v91, v92 in UnifiedEventLoggingUtils.getElementSizeAndPosition(v87) do
								Attributes2[UnifiedEventLogConstants.ATTRIBUTE_PREFIX .. v91] = v92
							end

							LastDeferredSingleItemStore.setSnapshot(Attributes2)
						end

						local t4 = {}

						if t2 then
							t4 = Cryo.Dictionary.join(t2.getAnalyticsMetadata(false), {
								keyword = t2.getSearchKeyword(false)
							})
						end

						if FFlagAXUnifiedImpressionsOnThumbnail then
							local v94 = p4:GetAttribute(UnifiedEventLogConstants.ATTRIBUTE_PREFIX .. "surface")
							local v95 = resolveClickSurface(p4, if not v50 then nil else v50.current)

							if v95 ~= nil then
								t4.surface = v95
							end

							if ((if v94 == nil then v95 else v94)) ~= UnifiedLoggingSurface.SEARCH_RESULTS then
								t4.keyword = nil
							end
						elseif v50 and v50.current and v50.current.current then
							local v96 = AvatarScreenProperties[v50.current.opaque.name]

							if v96 and v96.analyticsData then
								t4.surface = v96.analyticsData.unifiedLoggingSurface
							end
						end

						if FFlagAXMISEnableMultiShoppingUnifiedEvents and Attributes[UnifiedEventLogConstants.HAS_DEFERRED_ACTION] then
							t4.cartId = CartIdService.getCartId()
						end

						if FFlagAXUnifiedImpressionsOnThumbnail then
							t4 = applyClickStampFieldOverrides(t4, Attributes)
						end

						sendUnifiedEventLogForInstance(p4, t4, {
							includeScreenSize = true,
							includeElementSizeAndPosition = true
						})
					end)
				end
			end)
			t3.instanceRemoved = CollectionService:GetInstanceRemovedSignal(UnifiedEventLogConstants.TAG_NAME):Connect(function(p5) -- line: 217
				-- upvalues: t3 (ref)
				local v66 = t3[p5]

				if v66 then
					v66:Disconnect()
				end

				t3[p5] = nil
			end)

			return function() -- line: 226
				-- upvalues: t3 (ref)
				for _, v68 in t3 do
					v68:Disconnect()
				end

				t3 = {}
			end
		end, {})
	end,
	useUnifiedEventListenerInExperience = function() -- line: 252
		-- upvalues: React (copy), CollectionService (copy), UnifiedEventLogConstants (copy), getChildButton (copy), markLastActivated (copy), FFlagAXMISEnableMultiShoppingUnifiedEvents (copy), markSelectionListStatus (copy), FFlagAXFixSingleItemPurchaseWidgetLogging (copy), UnifiedEventLogEnums (copy), getDeferredPurchaseSourceTile (copy), UnifiedEventLoggingUtils (copy), LastDeferredSingleItemStore (copy), Cryo (copy), FFlagAXUnifiedImpressionsOnThumbnail (copy), resolveClickSurface (copy), UnifiedLoggingSurface (copy), AvatarScreenProperties (copy), CartIdService (copy), applyClickStampFieldOverrides (copy), sendUnifiedEventLogForInstance (copy)
		local v52 = nil
		local v53 = nil

		React.useEffect(function() -- line: 89
			-- upvalues: CollectionService (copy), UnifiedEventLogConstants (copy), getChildButton (copy), markLastActivated (copy), FFlagAXMISEnableMultiShoppingUnifiedEvents (copy), markSelectionListStatus (copy), FFlagAXFixSingleItemPurchaseWidgetLogging (copy), UnifiedEventLogEnums (copy), getDeferredPurchaseSourceTile (copy), UnifiedEventLoggingUtils (copy), LastDeferredSingleItemStore (copy), v52 (copy), Cryo (copy), FFlagAXUnifiedImpressionsOnThumbnail (copy), resolveClickSurface (copy), v53 (copy), UnifiedLoggingSurface (copy), AvatarScreenProperties (copy), CartIdService (copy), applyClickStampFieldOverrides (copy), sendUnifiedEventLogForInstance (copy)
			local t5 = {}

			t5.instanceAdded = CollectionService:GetInstanceAddedSignal(UnifiedEventLogConstants.TAG_NAME):Connect(function(p6) -- line: 97
				-- upvalues: getChildButton (copy), UnifiedEventLogConstants (copy), markLastActivated (copy), FFlagAXMISEnableMultiShoppingUnifiedEvents (copy), markSelectionListStatus (copy), FFlagAXFixSingleItemPurchaseWidgetLogging (copy), UnifiedEventLogEnums (copy), getDeferredPurchaseSourceTile (copy), CollectionService (copy), UnifiedEventLoggingUtils (copy), LastDeferredSingleItemStore (copy), v52 (copy), Cryo (copy), FFlagAXUnifiedImpressionsOnThumbnail (copy), resolveClickSurface (copy), v53 (copy), UnifiedLoggingSurface (copy), AvatarScreenProperties (copy), CartIdService (copy), applyClickStampFieldOverrides (copy), sendUnifiedEventLogForInstance (copy), t5 (ref)
				local v70 = getChildButton(p6)

				if v70 then
					t5[p6] = v70.Activated:Connect(function() -- line: 100
						-- upvalues: p6 (copy), UnifiedEventLogConstants (copy), markLastActivated (copy), FFlagAXMISEnableMultiShoppingUnifiedEvents (copy), markSelectionListStatus (copy), FFlagAXFixSingleItemPurchaseWidgetLogging (copy), UnifiedEventLogEnums (copy), getDeferredPurchaseSourceTile (copy), CollectionService (copy), UnifiedEventLoggingUtils (copy), LastDeferredSingleItemStore (copy), v52 (copy), Cryo (copy), FFlagAXUnifiedImpressionsOnThumbnail (copy), resolveClickSurface (copy), v53 (copy), UnifiedLoggingSurface (copy), AvatarScreenProperties (copy), CartIdService (copy), applyClickStampFieldOverrides (copy), sendUnifiedEventLogForInstance (copy)
						local Attributes = p6:GetAttributes()

						if Attributes[UnifiedEventLogConstants.HAS_DEFERRED_ACTION] then
							markLastActivated(p6)
						end

						if FFlagAXMISEnableMultiShoppingUnifiedEvents and Attributes[UnifiedEventLogConstants.HAS_DEFERRED_ACTION] and Attributes[UnifiedEventLogConstants.IS_SELECTED] ~= nil then
							markSelectionListStatus(p6, Attributes[UnifiedEventLogConstants.IS_SELECTED])
						end

						if FFlagAXFixSingleItemPurchaseWidgetLogging and FFlagAXMISEnableMultiShoppingUnifiedEvents and Attributes[UnifiedEventLogConstants.ATTRIBUTE_PREFIX .. "action"] == UnifiedEventLogEnums.MarketplaceUnifiedAction.PURCHASE_ATTEMPT then
							local v98 = getDeferredPurchaseSourceTile(CollectionService:GetTagged(UnifiedEventLogConstants.TAG_NAME), p6, Attributes[UnifiedEventLogConstants.ATTRIBUTE_PREFIX .. "itemId"], Attributes[UnifiedEventLogConstants.ATTRIBUTE_PREFIX .. "itemType"]) or p6
							local Attributes3 = v98:GetAttributes()

							for v100, v101 in UnifiedEventLoggingUtils.getScreenSize(v98) do
								Attributes3[UnifiedEventLogConstants.ATTRIBUTE_PREFIX .. v100] = v101
							end

							for v102, v103 in UnifiedEventLoggingUtils.getElementSizeAndPosition(v98) do
								Attributes3[UnifiedEventLogConstants.ATTRIBUTE_PREFIX .. v102] = v103
							end

							LastDeferredSingleItemStore.setSnapshot(Attributes3)
						end

						local t6 = {}

						if v52 then
							t6 = Cryo.Dictionary.join(v52.getAnalyticsMetadata(false), {
								keyword = v52.getSearchKeyword(false)
							})
						end

						if FFlagAXUnifiedImpressionsOnThumbnail then
							local v105 = p6:GetAttribute(UnifiedEventLogConstants.ATTRIBUTE_PREFIX .. "surface")
							local v106 = resolveClickSurface(p6, if not v53 then nil else v53.current)

							if v106 ~= nil then
								t6.surface = v106
							end

							if ((if v105 == nil then v106 else v105)) ~= UnifiedLoggingSurface.SEARCH_RESULTS then
								t6.keyword = nil
							end
						elseif v53 and v53.current and v53.current.current then
							local v107 = AvatarScreenProperties[v53.current.opaque.name]

							if v107 and v107.analyticsData then
								t6.surface = v107.analyticsData.unifiedLoggingSurface
							end
						end

						if FFlagAXMISEnableMultiShoppingUnifiedEvents and Attributes[UnifiedEventLogConstants.HAS_DEFERRED_ACTION] then
							t6.cartId = CartIdService.getCartId()
						end

						if FFlagAXUnifiedImpressionsOnThumbnail then
							t6 = applyClickStampFieldOverrides(t6, Attributes)
						end

						sendUnifiedEventLogForInstance(p6, t6, {
							includeScreenSize = true,
							includeElementSizeAndPosition = true
						})
					end)
				end
			end)
			t5.instanceRemoved = CollectionService:GetInstanceRemovedSignal(UnifiedEventLogConstants.TAG_NAME):Connect(function(p7) -- line: 217
				-- upvalues: t5 (ref)
				local v72 = t5[p7]

				if v72 then
					v72:Disconnect()
				end

				t5[p7] = nil
			end)

			return function() -- line: 226
				-- upvalues: t5 (ref)
				for _, v74 in t5 do
					v74:Disconnect()
				end

				t5 = {}
			end
		end, {})
	end
}
