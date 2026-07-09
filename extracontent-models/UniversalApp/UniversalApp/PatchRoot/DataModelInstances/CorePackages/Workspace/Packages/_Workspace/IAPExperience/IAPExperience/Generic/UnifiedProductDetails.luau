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
local FFlagAddCompactUnifiedUpsellModalMode = require(ParentParent.Flags.FFlagAddCompactUnifiedUpsellModalMode)
local FFlagUnifiedPurchaseAddSkeleton = require(ParentParent.Parent.SharedFlags).FFlagUnifiedPurchaseAddSkeleton
local FFlagEnableUnifiedPurchaseFlowForDevSubs = require(ParentParent.Parent.SharedFlags).FFlagEnableUnifiedPurchaseFlowForDevSubs
local FFlagEnableDiscountInfoInUnifiedPurchaseModal = require(ParentParent.Parent.SharedFlags).FFlagEnableDiscountInfoInUnifiedPurchaseModal
local GetFFlagDiscountInfoForSubscriptionPurchaseModalLua = require(ParentParent.Parent.SharedFlags).GetFFlagDiscountInfoForSubscriptionPurchaseModalLua
local default = require(ParentParentParent.LoggingProtocol).default
local VirtualItemBadgeShownCounter = require(ParentParent.Generic.Events.VirtualItemBadgeCounter).VirtualItemBadgeShownCounter
local n1 = 80

if FFlagAddCompactUnifiedUpsellModalMode then
	n1 = 72
end

local function withMaxLength(s1: string) -- line: 56
	if #s1 > 50 then
		return s1:sub(1, 50) .. "..."
	end

	return s1
end

require(ParentParent.ProductPurchase.PricingTypes)

return function(t1: {[any]: any}) -- line: 81
	-- upvalues: GetFFlagDiscountInfoForSubscriptionPurchaseModalLua (copy), FFlagEnableDiscountInfoInUnifiedPurchaseModal (copy), useLocalization (copy), useTokens (copy), n1 (ref), FFlagUnifiedPurchaseFlowMarketplaceUIImprovements (copy), useRobuxText (copy), FFlagAddCompactUnifiedUpsellModalMode (copy), React (copy), ModelViewport (copy), FFlagUnifiedPurchaseAddSkeleton (copy), Skeleton (copy), EnumsRadius (copy), FoundationImage (copy), VirtualItemBadgeType (copy), YellowBadge (copy), default (copy), VirtualItemBadgeShownCounter (copy), View (copy), FoundationText (copy), formatNumber (copy), LocalizationService (copy), FFlagEnableUnifiedPurchaseFlowForDevSubs (copy)
	local v30 = GetFFlagDiscountInfoForSubscriptionPurchaseModalLua()
	local v31 = if not FFlagEnableDiscountInfoInUnifiedPurchaseModal then nil else t1.itemPrice
	local v32 = if not v31 then t1.itemRobuxCost else v31.priceInRobux
	local v33 = useLocalization({
		Popular = "IAPExperience.RobuxUpsell.Text.PopularItem"
	})
	local priceSuffix = t1.priceSuffix
	local v35 = useTokens()
	local v36 = if not t1.isPortrait then n1 else 128
	local v37 = nil

	if FFlagUnifiedPurchaseFlowMarketplaceUIImprovements then
		v37 = useRobuxText(v32)
	end

	local v38 = if not FFlagEnableDiscountInfoInUnifiedPurchaseModal then nil else useRobuxText(if not v31 then t1.itemRobuxCost else v31.basePriceInRobux)
	local v39 = v31 and v31.basePriceInRobux > v31.priceInRobux

	if FFlagAddCompactUnifiedUpsellModalMode and t1.isCompact then
		v36 *= 0.7
	end

	local v40 = if t1.model == nil then if not FFlagUnifiedPurchaseAddSkeleton or (t1.itemIcon ~= nil or not t1.isLoading) then React.createElement(FoundationImage, {
		BackgroundTransparency = 1,
		Position = UDim2.new(0, 5, 0, 5),
		Size = UDim2.new(0, v36, 0, v36),
		ScaleType = Enum.ScaleType.Stretch,
		Image = not t1.itemIcon and "icons/status/imageunavailable" or t1.itemIcon,
		imageStyle = {
			Transparency = if not t1.itemIcon then v35.Color.Content.Default.Transparency else nil
		}
	}) else React.createElement(Skeleton, {
		LayoutOrder = 1,
		Size = UDim2.fromOffset(v36, v36),
		radius = EnumsRadius.Circle
	}) else React.createElement(ModelViewport, {
		model = t1.model,
		Position = UDim2.fromOffset(5, 5),
		Size = UDim2.fromOffset(v36, v36)
	})
	local v41 = if not t1.badgeType or t1.badgeType ~= VirtualItemBadgeType.Popular then nil else React.createElement(YellowBadge, {
		LayoutOrder = 3,
		Icon = "icons/menu/fire_fill",
		Text = v33.Popular
	})

	React.useEffect(function() -- line: 144
		-- upvalues: v41 (copy), default (copy), VirtualItemBadgeShownCounter (copy), t1 (copy)
		if not v41 then
			return
		end

		default:logRobloxTelemetryCounter(VirtualItemBadgeShownCounter, 1, {
			badgeType = t1.badgeType
		})
	end, {})

	local v42 = (not FFlagAddCompactUnifiedUpsellModalMode or not t1.isCompact) and "auto-xy text-align-x-left text-wrap text-title-medium content-emphasis" or "auto-xy text-align-x-left text-wrap text-title-small content-emphasis"
	local v43 = (not FFlagAddCompactUnifiedUpsellModalMode or not t1.isCompact) and "auto-xy text-align-x-left text-wrap text-title-medium content-emphasis" or "auto-xy text-align-x-left text-wrap text-title-small content-emphasis"
	local createElement = React.createElement
	local v45 = View
	local t2 = {
		tag = "auto-y row gap-small align-y-center align-x-left",
		LayoutOrder = t1.layoutOrder,
		Size = UDim2.new(1, 0, 0, 0)
	}
	local t3 = {
		ItemIcon = v40
	}
	local createElement2 = React.createElement
	local v49 = View
	local t4 = {
		LayoutOrder = 2,
		tag = "col auto-y gap-small",
		Size = UDim2.new(1, -v36 - 6, 0, 0)
	}
	local t5 = {}
	local v52

	if FFlagUnifiedPurchaseAddSkeleton and t1.isLoading and t1.itemName == nil then
		v52 = React.createElement(Skeleton, {
			LayoutOrder = 1,
			tag = "position-bottom-center",
			Size = UDim2.fromScale(1, 0.3),
			radius = EnumsRadius.Circle
		})
	else
		local createElement3 = React.createElement
		local v54 = FoundationText
		local t6 = {
			LayoutOrder = 1,
			Size = UDim2.new(1, 0, 0, 0)
		}
		local itemName = t1.itemName

		t6.Text = if not (#itemName > 50) then itemName else itemName:sub(1, 50) .. "..."
		t6.tag = not FFlagAddCompactUnifiedUpsellModalMode and "auto-xy text-align-x-left text-wrap text-title-medium content-emphasis" or v42
		v52 = createElement3(v54, t6)
	end

	t5.ItemName = v52
	t5.ItemSubtitle = t1.subtitleView
	t5.ItemDetails = if not FFlagUnifiedPurchaseAddSkeleton or (not t1.isLoading or v32 ~= nil) then React.createElement(View, {
		LayoutOrder = not t1.subtitleView and 2 or 3,
		tag = if not t1.isPortrait then (not v30 or not v39) and "auto-xy row gap-small align-y-center" or "row align-y-center gap-small auto-xy clip" else "auto-xy col gap-small align-y-center"
	}, {
		ItemCost = if not v32 then if not FFlagEnableUnifiedPurchaseFlowForDevSubs or not t1.itemDisplayPrice then nil else React.createElement(FoundationText, {
			LayoutOrder = 1,
			Text = t1.itemDisplayPrice .. ((not priceSuffix or priceSuffix == "") and "" or "" .. priceSuffix),
			tag = not FFlagAddCompactUnifiedUpsellModalMode and "auto-xy text-align-x-left text-wrap text-body-small content-emphasis" or v43
		}) else if not FFlagUnifiedPurchaseFlowMarketplaceUIImprovements then React.createElement(FoundationText, {
			LayoutOrder = 1,
			tag = "auto-xy text-align-x-left text-wrap text-title-medium content-emphasis",
			Text = utf8.char(57346) .. " " .. formatNumber(LocalizationService.RobloxLocaleId, v32) .. ((not priceSuffix or priceSuffix == "") and "" or "" .. priceSuffix)
		}) else React.createElement(FoundationText, {
			LayoutOrder = 1,
			RichText = true,
			Text = v37 .. ((not priceSuffix or priceSuffix == "") and "" or "" .. priceSuffix),
			tag = not FFlagAddCompactUnifiedUpsellModalMode and "auto-xy text-align-x-left text-wrap text-body-small content-emphasis" or v43
		}),
		OriginalPrice = if not v39 or not v38 then nil else React.createElement(FoundationText, {
			LayoutOrder = 2,
			tag = "auto-xy text-align-x-left text-wrap text-body-small content-default",
			RichText = true,
			Text = "<s>" .. v38 .. ((not v30 or (not priceSuffix or priceSuffix == "")) and "" or priceSuffix) .. "</s>"
		}),
		ItemBadge = v41
	}) else React.createElement(Skeleton, {
		LayoutOrder = not t1.subtitleView and 2 or 3,
		Size = UDim2.fromScale(0.4, 0.3),
		radius = EnumsRadius.Circle
	})
	t3.ItemDetailsFrame = createElement2(v49, t4, t5)

	return createElement(v45, t2, t3)
end
