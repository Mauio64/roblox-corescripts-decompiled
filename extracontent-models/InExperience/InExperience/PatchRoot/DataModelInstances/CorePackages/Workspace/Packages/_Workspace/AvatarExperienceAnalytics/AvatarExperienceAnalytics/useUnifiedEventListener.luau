local AvatarExperienceAnalytics = script:FindFirstAncestor("AvatarExperienceAnalytics")
local parent = AvatarExperienceAnalytics.Parent

local CollectionService = game:GetService("CollectionService")
local React = require(parent.React)
local Cryo = require(parent.Cryo)
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
local AvatarExperienceCommon = require(parent.AvatarExperienceCommon)
local useSelectorSignal = AvatarExperienceCommon.Hooks.useSelectorSignal
local selectSearchKeyword = AvatarExperienceCommon.State.Selectors.selectSearchKeyword
local AvatarExperienceNavigation = require(parent.AvatarExperienceNavigation)
local useAvatarRoute = AvatarExperienceNavigation.AvatarRoute.Hooks.useAvatarRoute
local AvatarScreenProperties = AvatarExperienceNavigation.AvatarRoute.AvatarScreenProperties
local UnifiedLoggingSurface = AvatarExperienceNavigation.Enums.UnifiedLoggingSurface

local AvatarExperienceFlags = require(parent.AvatarExperienceFlags)
local FFlagAXMISEnableMultiShoppingUnifiedEvents = AvatarExperienceFlags.FFlagAXMISEnableMultiShoppingUnifiedEvents
local FFlagAXUnifiedImpressionsOnThumbnail = AvatarExperienceFlags.FFlagAXUnifiedImpressionsOnThumbnail
local FFlagAXFixSingleItemPurchaseWidgetLogging = AvatarExperienceFlags.FFlagAXFixSingleItemPurchaseWidgetLogging
local FFlagAXFixSearchPurchaseSurface = AvatarExperienceFlags.FFlagAXFixSearchPurchaseSurface
local FFlagAXSkipTapDetection = AvatarExperienceFlags.FFlagAXSkipTapDetection

local function markLastActivated(instance)
	local tagged = CollectionService:GetTagged(UnifiedEventLogConstants.LAST_ACTIVATED_TAG_NAME)

	for _, instance2 in tagged do
		CollectionService:RemoveTag(instance2, UnifiedEventLogConstants.LAST_ACTIVATED_TAG_NAME)
	end

	CollectionService:AddTag(instance, UnifiedEventLogConstants.LAST_ACTIVATED_TAG_NAME)
end

local function markSelectionListStatus(instance, attribute: boolean, p)
	local attributes = instance:GetAttributes()

	if FFlagAXMISEnableMultiShoppingUnifiedEvents then
		for k, v in UnifiedEventLoggingUtils.getScreenSize(instance) do
			attributes[UnifiedEventLogConstants.ATTRIBUTE_PREFIX .. k] = v
		end

		for k, v in UnifiedEventLoggingUtils.getElementSizeAndPosition(instance) do
			attributes[UnifiedEventLogConstants.ATTRIBUTE_PREFIX .. k] = v
		end
	end

	if FFlagAXFixSearchPurchaseSurface and not attribute then
		local v = UnifiedEventLogConstants.ATTRIBUTE_PREFIX .. "surface"

		if attributes[v] == nil then
			local v2

			if p then
				v2 = p.current
			end

			local clickSurface = resolveClickSurface(instance, v2)

			if clickSurface ~= nil then
				attributes[v] = clickSurface
			end
		end
	end

	if attribute then
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

	for _, _ in button:GetDescendants() do
		if button:IsA("TextButton") or button:IsA("ImageButton") or button:IsA("GuiButton") then
			return button
		end
	end

	return nil
end

local function AnalyticsMetadataSelector(p)
	return p.AvatarExperience.AnalyticsMetadata
end

local function fn(p, p2) -- 2 equivalent calls inferred from this helper
	React.useEffect(function()
		local v = {}

		v.instanceAdded = CollectionService:GetInstanceAddedSignal(UnifiedEventLogConstants.TAG_NAME):Connect(function(instance)
			local childButton = getChildButton(instance)

			if childButton then
				local activatedConnection = childButton.Activated:Connect(function()
					local attributes = instance:GetAttributes()

					if FFlagAXSkipTapDetection and attributes[UnifiedEventLogConstants.SKIP_TAP_DETECTION] == true then
						return
					end

					if attributes[UnifiedEventLogConstants.HAS_DEFERRED_ACTION] then
						markLastActivated(instance)
					end

					if
						FFlagAXMISEnableMultiShoppingUnifiedEvents
						and attributes[UnifiedEventLogConstants.HAS_DEFERRED_ACTION]
						and attributes[UnifiedEventLogConstants.IS_SELECTED] ~= nil
					then
						local attribute = attributes[UnifiedEventLogConstants.IS_SELECTED]
						local v2

						if FFlagAXFixSearchPurchaseSurface then
							v2 = p2
						end

						markSelectionListStatus(instance, attribute, v2)
					end

					if
						FFlagAXFixSingleItemPurchaseWidgetLogging
						and FFlagAXMISEnableMultiShoppingUnifiedEvents
						and attributes[UnifiedEventLogConstants.ATTRIBUTE_PREFIX .. "action"] == UnifiedEventLogEnums.MarketplaceUnifiedAction.PURCHASE_ATTEMPT
					then
						local v2 = getDeferredPurchaseSourceTile(
								CollectionService:GetTagged(UnifiedEventLogConstants.TAG_NAME),
								instance,
								attributes[UnifiedEventLogConstants.ATTRIBUTE_PREFIX .. "itemId"],
								attributes[UnifiedEventLogConstants.ATTRIBUTE_PREFIX .. "itemType"]
							)
							or instance

						local attributes2 = v2:GetAttributes()

						for k, v3 in UnifiedEventLoggingUtils.getScreenSize(v2) do
							attributes2[UnifiedEventLogConstants.ATTRIBUTE_PREFIX .. k] = v3
						end

						for k, v3 in UnifiedEventLoggingUtils.getElementSizeAndPosition(v2) do
							attributes2[UnifiedEventLogConstants.ATTRIBUTE_PREFIX .. k] = v3
						end

						LastDeferredSingleItemStore.setSnapshot(attributes2)
					end

					local v2 = not p and {}
						or Cryo.Dictionary.join(p.getAnalyticsMetadata(false), {
							keyword = p.getSearchKeyword(false)
						})

					if FFlagAXUnifiedImpressionsOnThumbnail then
						local attribute = instance:GetAttribute(UnifiedEventLogConstants.ATTRIBUTE_PREFIX .. "surface")
						local v3

						if p2 then
							v3 = p2.current
						end

						local surface = resolveClickSurface(instance, v3)

						if surface ~= nil then
							v2.surface = surface
						end

						if attribute ~= nil then
							surface = attribute
						end

						if surface ~= UnifiedLoggingSurface.SEARCH_RESULTS then
							v2.keyword = nil
						end
					elseif p2 and p2.current and p2.current.current then
						local avatarScreenProperty = AvatarScreenProperties[p2.current.opaque.name]

						if avatarScreenProperty and avatarScreenProperty.analyticsData then
							v2.surface = avatarScreenProperty.analyticsData.unifiedLoggingSurface
						end
					end

					if
						FFlagAXMISEnableMultiShoppingUnifiedEvents
						and attributes[UnifiedEventLogConstants.HAS_DEFERRED_ACTION]
					then
						v2.cartId = CartIdService.getCartId()
					end

					if FFlagAXUnifiedImpressionsOnThumbnail then
						v2 = applyClickStampFieldOverrides(v2, attributes)
					end

					sendUnifiedEventLogForInstance(instance, v2, {
						includeScreenSize = true,
						includeElementSizeAndPosition = true
					})
				end)

				v[instance] = activatedConnection
			end
		end)

		v.instanceRemoved = CollectionService:GetInstanceRemovedSignal(UnifiedEventLogConstants.TAG_NAME):Connect(function(p3)
			local connection = v[p3]

			if connection then
				connection:Disconnect()
			end

			v[p3] = nil
		end)

		return function()
			for _, connection in v do
				connection:Disconnect()
			end

			v = {}
		end
	end, {})
end

local UseUnifiedEventListener = {}

function UseUnifiedEventListener.useUnifiedEventListener()
	local getAnalyticsMetadata = useSelectorSignal(AnalyticsMetadataSelector)
	local getSearchKeyword = useSelectorSignal(selectSearchKeyword)

	local current = useAvatarRoute()
	local ref = React.useRef(current)
	React.useEffect(function()
		ref.current = current
	end, { current })

	fn({ getAnalyticsMetadata = getAnalyticsMetadata, getSearchKeyword = getSearchKeyword }, ref) -- inferred equivalent call
end

function UseUnifiedEventListener.useUnifiedEventListenerInExperience()
	fn(nil) -- inferred equivalent call
end

return UseUnifiedEventListener
