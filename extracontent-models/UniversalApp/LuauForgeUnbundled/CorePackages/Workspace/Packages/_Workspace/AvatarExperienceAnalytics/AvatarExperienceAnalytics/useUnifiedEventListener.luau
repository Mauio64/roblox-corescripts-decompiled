local CollectionService = game:GetService("CollectionService")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceAnalytics/React")
local Cryo = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceAnalytics/Cryo")
local sendUnifiedEventLogForInstance = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceAnalytics/AvatarExperienceAnalytics/sendUnifiedEventLogForInstance")
local UnifiedEventLogConstants = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceAnalytics/AvatarExperienceAnalytics/UnifiedEventLogConstants")
local UnifiedEventLogEnums = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceAnalytics/AvatarExperienceAnalytics/UnifiedEventLogEnums")
local resolveClickSurface = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceAnalytics/AvatarExperienceAnalytics/resolveClickSurface")
local applyClickStampFieldOverrides = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceAnalytics/AvatarExperienceAnalytics/applyClickStampFieldOverrides")
local UnifiedEventLoggingUtils = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceAnalytics/AvatarExperienceAnalytics/Utils/UnifiedEventLoggingUtils")
local getDeferredPurchaseSourceTile = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceAnalytics/AvatarExperienceAnalytics/Utils/getDeferredPurchaseSourceTile")
local UnifiedSelectionListStore = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceAnalytics/AvatarExperienceAnalytics/Store/UnifiedSelectionListStore")
local LastDeferredSingleItemStore = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceAnalytics/AvatarExperienceAnalytics/Store/LastDeferredSingleItemStore")
local CartIdService = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceAnalytics/AvatarExperienceAnalytics/Lib/CartIdService")
local AvatarExperienceCommon = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceAnalytics/AvatarExperienceCommon")
local useSelectorSignal = AvatarExperienceCommon.Hooks.useSelectorSignal
local selectSearchKeyword = AvatarExperienceCommon.State.Selectors.selectSearchKeyword
local AvatarExperienceNavigation = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceAnalytics/AvatarExperienceNavigation")
local useAvatarRoute = AvatarExperienceNavigation.AvatarRoute.Hooks.useAvatarRoute
local avatarScreenProperties = AvatarExperienceNavigation.AvatarRoute.AvatarScreenProperties
local unifiedLoggingSurface = AvatarExperienceNavigation.Enums.UnifiedLoggingSurface

local AvatarExperienceFlags = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceAnalytics/AvatarExperienceFlags")
local fFlagAXMISEnableMultiShoppingUnifiedEvents = AvatarExperienceFlags.FFlagAXMISEnableMultiShoppingUnifiedEvents
local fFlagAXUnifiedImpressionsOnThumbnail = AvatarExperienceFlags.FFlagAXUnifiedImpressionsOnThumbnail
local fFlagAXFixSingleItemPurchaseWidgetLogging = AvatarExperienceFlags.FFlagAXFixSingleItemPurchaseWidgetLogging
local fFlagAXFixSearchPurchaseSurface = AvatarExperienceFlags.FFlagAXFixSearchPurchaseSurface
local fFlagAXSkipTapDetection = AvatarExperienceFlags.FFlagAXSkipTapDetection

local function markLastActivated(instance)
	local tagged = CollectionService:GetTagged(UnifiedEventLogConstants.LAST_ACTIVATED_TAG_NAME)

	for k, instance2 in tagged do
		CollectionService:RemoveTag(instance2, UnifiedEventLogConstants.LAST_ACTIVATED_TAG_NAME)
	end

	CollectionService:AddTag(instance, UnifiedEventLogConstants.LAST_ACTIVATED_TAG_NAME)
end

local function markSelectionListStatus(object, p2, p3)
	local attributes = object:GetAttributes()

	if fFlagAXMISEnableMultiShoppingUnifiedEvents then
		for k, v5 in UnifiedEventLoggingUtils.getScreenSize(object) do
			attributes[UnifiedEventLogConstants.ATTRIBUTE_PREFIX .. k] = v5
		end

		for k, v5 in UnifiedEventLoggingUtils.getElementSizeAndPosition(object) do
			attributes[UnifiedEventLogConstants.ATTRIBUTE_PREFIX .. k] = v5
		end
	end

	if fFlagAXFixSearchPurchaseSurface and not p2 then
		local v5 = UnifiedEventLogConstants.ATTRIBUTE_PREFIX .. "surface"

		if attributes[v5] == nil then
			local v7 = if p3 then p3.current else nil
			local v8 = resolveClickSurface(object, v7)

			if v8 ~= nil then
				attributes[v5] = v8
			end
		end
	end

	if p2 then
		UnifiedSelectionListStore.removeFromSelectionList(attributes)
	else
		UnifiedSelectionListStore.addToSelectionList(attributes)
	end
end

local function getChildButton(button)
	if not button then
		return nil
	end

	if button:IsA("TextButton") or button:IsA("ImageButton") or button:IsA("GuiButton") then
		return button
	end

	for i, descendant in button:GetDescendants() do
		if button:IsA("TextButton") or button:IsA("ImageButton") or button:IsA("GuiButton") then
			return button
		end
	end

	return nil
end

local function AnalyticsMetadataSelector(p2)
	return p2.AvatarExperience.AnalyticsMetadata
end

return {
	useUnifiedEventListener = function()
		local v5 = useSelectorSignal(AnalyticsMetadataSelector)
		local v6 = useSelectorSignal(selectSearchKeyword)

		local v7 = useAvatarRoute()
		local ref = React.useRef(v7)
		React.useEffect(function()
			ref.current = v7
		end, { v7 })

		local v8 = { getAnalyticsMetadata = v5, getSearchKeyword = v6 }
		React.useEffect(function()
			local v9 = {}

			v9.instanceAdded = CollectionService:GetInstanceAddedSignal(UnifiedEventLogConstants.TAG_NAME):Connect(function(instance)
				local childButton = getChildButton(instance)

				if childButton then
					local activatedConnection = childButton.Activated:Connect(function()
						local attributes = instance:GetAttributes()

						if fFlagAXSkipTapDetection and attributes[UnifiedEventLogConstants.SKIP_TAP_DETECTION] == true then
							return
						end

						if attributes[UnifiedEventLogConstants.HAS_DEFERRED_ACTION] then
							markLastActivated(instance)
						end

						if
							fFlagAXMISEnableMultiShoppingUnifiedEvents
							and attributes[UnifiedEventLogConstants.HAS_DEFERRED_ACTION]
							and attributes[UnifiedEventLogConstants.IS_SELECTED] ~= nil
						then
							markSelectionListStatus(
								instance,
								attributes[UnifiedEventLogConstants.IS_SELECTED],
								if fFlagAXFixSearchPurchaseSurface then ref else nil
							)
						end

						if
							fFlagAXFixSingleItemPurchaseWidgetLogging
							and fFlagAXMISEnableMultiShoppingUnifiedEvents
							and attributes[UnifiedEventLogConstants.ATTRIBUTE_PREFIX .. "action"] == UnifiedEventLogEnums.MarketplaceUnifiedAction.PURCHASE_ATTEMPT
						then
							local v10 = getDeferredPurchaseSourceTile(
									CollectionService:GetTagged(UnifiedEventLogConstants.TAG_NAME),
									instance,
									attributes[UnifiedEventLogConstants.ATTRIBUTE_PREFIX .. "itemId"],
									attributes[UnifiedEventLogConstants.ATTRIBUTE_PREFIX .. "itemType"]
								)
								or instance

							local attributes2 = v10:GetAttributes()

							for k, v11 in UnifiedEventLoggingUtils.getScreenSize(v10) do
								attributes2[UnifiedEventLogConstants.ATTRIBUTE_PREFIX .. k] = v11
							end

							for k, v11 in UnifiedEventLoggingUtils.getElementSizeAndPosition(v10) do
								attributes2[UnifiedEventLogConstants.ATTRIBUTE_PREFIX .. k] = v11
							end

							LastDeferredSingleItemStore.setSnapshot(attributes2)
						end

						local v10 = not v8 and {}
							or Cryo.Dictionary.join(v8.getAnalyticsMetadata(false), {
								keyword = v8.getSearchKeyword(false)
							})

						if fFlagAXUnifiedImpressionsOnThumbnail then
							local attribute = instance:GetAttribute(UnifiedEventLogConstants.ATTRIBUTE_PREFIX .. "surface")

							local v13 = if ref then ref.current else nil
							local v14 = resolveClickSurface(instance, v13)

							if v14 ~= nil then
								v10.surface = v14
							end

							if attribute ~= nil then
								v14 = attribute
							end

							if v14 ~= unifiedLoggingSurface.SEARCH_RESULTS then
								v10.keyword = nil
							end
						elseif ref and ref.current and ref.current.current then
							local avatarScreenProperty = avatarScreenProperties[ref.current.opaque.name]

							if avatarScreenProperty and avatarScreenProperty.analyticsData then
								v10.surface = avatarScreenProperty.analyticsData.unifiedLoggingSurface
							end
						end

						if
							fFlagAXMISEnableMultiShoppingUnifiedEvents
							and attributes[UnifiedEventLogConstants.HAS_DEFERRED_ACTION]
						then
							v10.cartId = CartIdService.getCartId()
						end

						if fFlagAXUnifiedImpressionsOnThumbnail then
							v10 = applyClickStampFieldOverrides(v10, attributes)
						end

						sendUnifiedEventLogForInstance(instance, v10, {
							includeScreenSize = true,
							includeElementSizeAndPosition = true
						})
					end)

					v9[instance] = activatedConnection
				end
			end)

			v9.instanceRemoved = CollectionService:GetInstanceRemovedSignal(UnifiedEventLogConstants.TAG_NAME):Connect(function(p2)
				local connection = v9[p2]

				if connection then
					connection:Disconnect()
				end

				v9[p2] = nil
			end)

			return function()
				for k, connection in v9 do
					connection:Disconnect()
				end

				v9 = {}
			end
		end, {})
	end,
	useUnifiedEventListenerInExperience = function()
		local v5 = nil
		local v6 = nil
		React.useEffect(function()
			local v7 = {}

			v7.instanceAdded = CollectionService:GetInstanceAddedSignal(UnifiedEventLogConstants.TAG_NAME):Connect(function(instance)
				local childButton = getChildButton(instance)

				if childButton then
					local activatedConnection = childButton.Activated:Connect(function()
						local attributes = instance:GetAttributes()

						if fFlagAXSkipTapDetection and attributes[UnifiedEventLogConstants.SKIP_TAP_DETECTION] == true then
							return
						end

						if attributes[UnifiedEventLogConstants.HAS_DEFERRED_ACTION] then
							markLastActivated(instance)
						end

						if
							fFlagAXMISEnableMultiShoppingUnifiedEvents
							and attributes[UnifiedEventLogConstants.HAS_DEFERRED_ACTION]
							and attributes[UnifiedEventLogConstants.IS_SELECTED] ~= nil
						then
							markSelectionListStatus(
								instance,
								attributes[UnifiedEventLogConstants.IS_SELECTED],
								if fFlagAXFixSearchPurchaseSurface then v5 else nil
							)
						end

						if
							fFlagAXFixSingleItemPurchaseWidgetLogging
							and fFlagAXMISEnableMultiShoppingUnifiedEvents
							and attributes[UnifiedEventLogConstants.ATTRIBUTE_PREFIX .. "action"] == UnifiedEventLogEnums.MarketplaceUnifiedAction.PURCHASE_ATTEMPT
						then
							local v8 = getDeferredPurchaseSourceTile(
									CollectionService:GetTagged(UnifiedEventLogConstants.TAG_NAME),
									instance,
									attributes[UnifiedEventLogConstants.ATTRIBUTE_PREFIX .. "itemId"],
									attributes[UnifiedEventLogConstants.ATTRIBUTE_PREFIX .. "itemType"]
								)
								or instance

							local attributes2 = v8:GetAttributes()

							for k, v9 in UnifiedEventLoggingUtils.getScreenSize(v8) do
								attributes2[UnifiedEventLogConstants.ATTRIBUTE_PREFIX .. k] = v9
							end

							for k, v9 in UnifiedEventLoggingUtils.getElementSizeAndPosition(v8) do
								attributes2[UnifiedEventLogConstants.ATTRIBUTE_PREFIX .. k] = v9
							end

							LastDeferredSingleItemStore.setSnapshot(attributes2)
						end

						local v8 = not v6 and {}
							or Cryo.Dictionary.join(v6.getAnalyticsMetadata(false), {
								keyword = v6.getSearchKeyword(false)
							})

						if fFlagAXUnifiedImpressionsOnThumbnail then
							local attribute = instance:GetAttribute(UnifiedEventLogConstants.ATTRIBUTE_PREFIX .. "surface")

							local v11 = if v5 then v5.current else nil
							local v12 = resolveClickSurface(instance, v11)

							if v12 ~= nil then
								v8.surface = v12
							end

							if attribute ~= nil then
								v12 = attribute
							end

							if v12 ~= unifiedLoggingSurface.SEARCH_RESULTS then
								v8.keyword = nil
							end
						elseif v5 and v5.current and v5.current.current then
							local avatarScreenProperty = avatarScreenProperties[v5.current.opaque.name]

							if avatarScreenProperty and avatarScreenProperty.analyticsData then
								v8.surface = avatarScreenProperty.analyticsData.unifiedLoggingSurface
							end
						end

						if
							fFlagAXMISEnableMultiShoppingUnifiedEvents
							and attributes[UnifiedEventLogConstants.HAS_DEFERRED_ACTION]
						then
							v8.cartId = CartIdService.getCartId()
						end

						if fFlagAXUnifiedImpressionsOnThumbnail then
							v8 = applyClickStampFieldOverrides(v8, attributes)
						end

						sendUnifiedEventLogForInstance(instance, v8, {
							includeScreenSize = true,
							includeElementSizeAndPosition = true
						})
					end)

					v7[instance] = activatedConnection
				end
			end)

			v7.instanceRemoved = CollectionService:GetInstanceRemovedSignal(UnifiedEventLogConstants.TAG_NAME):Connect(function(p2)
				local connection = v7[p2]

				if connection then
					connection:Disconnect()
				end

				v7[p2] = nil
			end)

			return function()
				for k, connection in v7 do
					connection:Disconnect()
				end

				v7 = {}
			end
		end, {})
	end
}
