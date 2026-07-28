local ParentParent = script.Parent.Parent
local ParentParentParent = ParentParent.Parent
local formatNumber = require(ParentParent.Utility.formatNumber)
local React = require(ParentParentParent.React)
local Foundation = require(ParentParentParent.Foundation)
local useTokens = Foundation.Hooks.useTokens
local FoundationText = Foundation.Text
local FoundationImage = Foundation.Image
local View = Foundation.View
local Skeleton = Foundation.Skeleton
local EnumsRadius = Foundation.Enums.Radius
local VirtualItemBadgeType = require(ParentParent.Enums.VirtualItemBadgeType)
local ModelViewport = require(ParentParent.Generic.ModelViewport)
local YellowBadge = require(ParentParent.Generic.YellowBadge)
local LocalizationService = game:GetService("LocalizationService")
local useLocalization = require(ParentParentParent.Localization).Hooks.useLocalization
local useRobuxText = require(ParentParent.Generic.Hooks.useRobuxText)
local FFlagUnifiedPurchaseFlowMarketplaceUIImprovements = require(ParentParent.Parent.SharedFlags).FFlagUnifiedPurchaseFlowMarketplaceUIImprovements
local FFlagUnifiedPurchaseAddSkeleton = require(ParentParent.Parent.SharedFlags).FFlagUnifiedPurchaseAddSkeleton
local FFlagEnableUnifiedPurchaseFlowForDevSubs = require(ParentParent.Parent.SharedFlags).FFlagEnableUnifiedPurchaseFlowForDevSubs
local FFlagEnableDiscountInfoInUnifiedPurchaseModal = require(ParentParent.Parent.SharedFlags).FFlagEnableDiscountInfoInUnifiedPurchaseModal
local GetFFlagDiscountInfoForSubscriptionPurchaseModalLua = require(ParentParent.Parent.SharedFlags).GetFFlagDiscountInfoForSubscriptionPurchaseModalLua
local default = require(ParentParentParent.LoggingProtocol).default
local VirtualItemBadgeShownCounter = require(ParentParent.Generic.Events.VirtualItemBadgeCounter).VirtualItemBadgeShownCounter

local function withMaxLength(s1: string) -- line: 52
	if #s1 > 50 then
		return s1:sub(1, 50) .. "..."
	end

	return s1
end

require(ParentParent.ProductPurchase.PricingTypes)

return function(t1: {[any]: any}) -- line: 77
	-- upvalues: GetFFlagDiscountInfoForSubscriptionPurchaseModalLua (copy), FFlagEnableDiscountInfoInUnifiedPurchaseModal (copy), useLocalization (copy), useTokens (copy), FFlagUnifiedPurchaseFlowMarketplaceUIImprovements (copy), useRobuxText (copy), React (copy), ModelViewport (copy), FFlagUnifiedPurchaseAddSkeleton (copy), Skeleton (copy), EnumsRadius (copy), FoundationImage (copy), VirtualItemBadgeType (copy), YellowBadge (copy), default (copy), VirtualItemBadgeShownCounter (copy), View (copy), FoundationText (copy), formatNumber (copy), LocalizationService (copy), FFlagEnableUnifiedPurchaseFlowForDevSubs (copy)
	local v28 = GetFFlagDiscountInfoForSubscriptionPurchaseModalLua()
	local v29 = if not FFlagEnableDiscountInfoInUnifiedPurchaseModal then nil else t1.itemPrice
	local v30 = if not v29 then t1.itemRobuxCost else v29.priceInRobux
	local v31 = useLocalization({
		Popular = "IAPExperience.RobuxUpsell.Text.PopularItem"
	})
	local priceSuffix = t1.priceSuffix
	local v33 = useTokens()
	local v34 = not t1.isPortrait and 72 or 128
	local v35 = nil

	if FFlagUnifiedPurchaseFlowMarketplaceUIImprovements then
		v35 = useRobuxText(v30)
	end

	local v36 = if not FFlagEnableDiscountInfoInUnifiedPurchaseModal then nil else useRobuxText(if not v29 then t1.itemRobuxCost else v29.basePriceInRobux)
	local v37 = v29 and v29.basePriceInRobux > v29.priceInRobux

	if t1.isCompact then
		v34 *= 0.7
	end

	local v38 = if t1.model == nil then if not FFlagUnifiedPurchaseAddSkeleton or (t1.itemIcon ~= nil or not t1.isLoading) then React.createElement(FoundationImage, {
		BackgroundTransparency = 1,
		Position = UDim2.new(0, 5, 0, 5),
		Size = UDim2.new(0, v34, 0, v34),
		ScaleType = Enum.ScaleType.Stretch,
		Image = not t1.itemIcon and "icons/status/imageunavailable" or t1.itemIcon,
		imageStyle = {
			Transparency = if not t1.itemIcon then v33.Color.Content.Default.Transparency else nil
		}
	}) else React.createElement(Skeleton, {
		LayoutOrder = 1,
		Size = UDim2.fromOffset(v34, v34),
		radius = EnumsRadius.Circle
	}) else React.createElement(ModelViewport, {
		model = t1.model,
		Position = UDim2.fromOffset(5, 5),
		Size = UDim2.fromOffset(v34, v34)
	})
	local v39 = if not t1.badgeType or t1.badgeType ~= VirtualItemBadgeType.Popular then nil else React.createElement(YellowBadge, {
		LayoutOrder = 3,
		Icon = "icons/menu/fire_fill",
		Text = v31.Popular
	})

	React.useEffect(function() -- line: 138
		-- upvalues: v39 (copy), default (copy), VirtualItemBadgeShownCounter (copy), t1 (copy)
		if not v39 then
			return
		end

		default:logRobloxTelemetryCounter(VirtualItemBadgeShownCounter, 1, {
			badgeType = t1.badgeType
		})
	end, {})

	local v40 = not t1.isCompact and "auto-xy text-align-x-left text-wrap text-title-medium content-emphasis" or "auto-xy text-align-x-left text-wrap text-title-small content-emphasis"
	local v41 = not t1.isCompact and "auto-xy text-align-x-left text-wrap text-title-medium content-emphasis" or "auto-xy text-align-x-left text-wrap text-title-small content-emphasis"
	local createElement = React.createElement
	local v43 = View
	local t2 = {
		tag = "auto-y row gap-small align-y-center align-x-left",
		LayoutOrder = t1.layoutOrder,
		Size = UDim2.new(1, 0, 0, 0)
	}
	local t3 = {
		ItemIcon = v38
	}
	local createElement2 = React.createElement
	local v47 = View
	local t4 = {
		LayoutOrder = 2,
		tag = "col auto-y gap-small",
		Size = UDim2.new(1, -v34 - 6, 0, 0)
	}
	local t5 = {}
	local v50

	if FFlagUnifiedPurchaseAddSkeleton and t1.isLoading and t1.itemName == nil then
		v50 = React.createElement(Skeleton, {
			LayoutOrder = 1,
			tag = "position-bottom-center",
			Size = UDim2.fromScale(1, 0.3),
			radius = EnumsRadius.Circle
		})
	else
		local createElement3 = React.createElement
		local v52 = FoundationText
		local t6 = {
			LayoutOrder = 1,
			Size = UDim2.new(1, 0, 0, 0)
		}
		local itemName = t1.itemName

		t6.Text = if not (#itemName > 50) then itemName else itemName:sub(1, 50) .. "..."
		t6.tag = v40
		v50 = createElement3(v52, t6)
	end

	t5.ItemName = v50
	t5.ItemSubtitle = t1.subtitleView
	t5.ItemDetails = if not FFlagUnifiedPurchaseAddSkeleton or (not t1.isLoading or v30 ~= nil) then React.createElement(View, {
		LayoutOrder = not t1.subtitleView and 2 or 3,
		tag = if not t1.isPortrait then (not v28 or not v37) and "auto-xy row gap-small align-y-center" or "row align-y-center gap-small auto-xy clip" else "auto-xy col gap-small align-y-center"
	}, {
		ItemCost = if not v30 then if not FFlagEnableUnifiedPurchaseFlowForDevSubs or not t1.itemDisplayPrice then nil else React.createElement(FoundationText, {
			LayoutOrder = 1,
			Text = t1.itemDisplayPrice .. ((not priceSuffix or priceSuffix == "") and "" or "" .. priceSuffix),
			tag = v41
		}) else if not FFlagUnifiedPurchaseFlowMarketplaceUIImprovements then React.createElement(FoundationText, {
			LayoutOrder = 1,
			tag = "auto-xy text-align-x-left text-wrap text-title-medium content-emphasis",
			Text = utf8.char(57346) .. " " .. formatNumber(LocalizationService.RobloxLocaleId, v30) .. ((not priceSuffix or priceSuffix == "") and "" or "" .. priceSuffix)
		}) else React.createElement(FoundationText, {
			LayoutOrder = 1,
			RichText = true,
			Text = v35 .. ((not priceSuffix or priceSuffix == "") and "" or "" .. priceSuffix),
			tag = v41
		}),
		OriginalPrice = if not v37 or not v36 then nil else React.createElement(FoundationText, {
			LayoutOrder = 2,
			tag = "auto-xy text-align-x-left text-wrap text-body-small content-default",
			RichText = true,
			Text = "<s>" .. v36 .. ((not v28 or (not priceSuffix or priceSuffix == "")) and "" or priceSuffix) .. "</s>"
		}),
		ItemBadge = v39
	}) else React.createElement(Skeleton, {
		LayoutOrder = not t1.subtitleView and 2 or 3,
		Size = UDim2.fromScale(0.4, 0.3),
		radius = EnumsRadius.Circle
	})
	t3.ItemDetailsFrame = createElement2(v47, t4, t5)

	return createElement(v43, t2, t3)
end
