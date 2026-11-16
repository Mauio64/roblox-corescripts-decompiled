local parent = script.Parent.Parent
local parent2 = parent.Parent

local formatNumber = require(parent.Utility.formatNumber)

local React = require(parent2.React)

local Foundation = require(parent2.Foundation)
local useTokens = Foundation.Hooks.useTokens
local Text = Foundation.Text
local Image = Foundation.Image
local View = Foundation.View
local Skeleton = Foundation.Skeleton
local Radius = Foundation.Enums.Radius

local VirtualItemBadgeType = require(parent.Enums.VirtualItemBadgeType)

local ModelViewport = require(parent.Generic.ModelViewport)
local YellowBadge = require(parent.Generic.YellowBadge)

local LocalizationService = game:GetService("LocalizationService")
local Localization = require(parent2.Localization)
local useLocalization = Localization.Hooks.useLocalization

local useRobuxText = require(parent.Generic.Hooks.useRobuxText)

local SharedFlags = require(parent.Parent.SharedFlags)
local FFlagUnifiedPurchaseFlowMarketplaceUIImprovements = SharedFlags.FFlagUnifiedPurchaseFlowMarketplaceUIImprovements
local SharedFlags2 = require(parent.Parent.SharedFlags)
local FFlagUnifiedPurchaseAddSkeleton = SharedFlags2.FFlagUnifiedPurchaseAddSkeleton

local SharedFlags3 = require(parent.Parent.SharedFlags)
local FFlagEnableUnifiedPurchaseFlowForDevSubs = SharedFlags3.FFlagEnableUnifiedPurchaseFlowForDevSubs

local SharedFlags4 = require(parent.Parent.SharedFlags)
local GetFFlagDiscountInfoForSubscriptionPurchaseModalLua = SharedFlags4.GetFFlagDiscountInfoForSubscriptionPurchaseModalLua

local SharedFlags5 = require(parent.Parent.SharedFlags)
local FFlagLuaAppsEnablePromptVIPServerPurchase = SharedFlags5.FFlagLuaAppsEnablePromptVIPServerPurchase

local LoggingProtocol = require(parent2.LoggingProtocol)
local default = LoggingProtocol.default
local VirtualItemBadgeCounter = require(parent.Generic.Events.VirtualItemBadgeCounter)
local VirtualItemBadgeShownCounter = VirtualItemBadgeCounter.VirtualItemBadgeShownCounter

local function withMaxLength(itemName: string) -- 1 equivalent call inferred from this helper
	if #itemName > 50 then
		return itemName:sub(1, 50) .. "..."
	end

	return itemName
end

require(parent.ProductPurchase.PricingTypes)

return function(props)
	local fFlagDiscountInfoForSubscriptionPurchaseModalLua = GetFFlagDiscountInfoForSubscriptionPurchaseModalLua()
	local itemPrice = props.itemPrice
	local v

	if itemPrice then
		v = itemPrice.priceInRobux
	else
		v = props.itemRobuxCost
	end

	local v2 = useLocalization({ Popular = "IAPExperience.RobuxUpsell.Text.PopularItem" })

	local priceSuffix = props.priceSuffix

	local v3 = useTokens()
	local v4 = props.isPortrait and 128 or 72
	local v5

	if FFlagUnifiedPurchaseFlowMarketplaceUIImprovements then
		v5 = useRobuxText(v)
	end

	local v6

	if itemPrice then
		v6 = itemPrice.basePriceInRobux
	else
		v6 = props.itemRobuxCost
	end

	local v7 = useRobuxText(v6)
	local v8 = itemPrice and itemPrice.basePriceInRobux > itemPrice.priceInRobux
	local v9

	if FFlagLuaAppsEnablePromptVIPServerPurchase and props.includePriceSuffixOnOriginal ~= nil then
		v9 = props.includePriceSuffixOnOriginal
	else
		v9 = fFlagDiscountInfoForSubscriptionPurchaseModalLua
	end

	if props.isCompact then
		v4 *= 0.7
	end

	local itemIcon

	if props.model == nil then
		if FFlagUnifiedPurchaseAddSkeleton and props.itemIcon == nil and props.isLoading then
			itemIcon = React.createElement(Skeleton, {
				LayoutOrder = 1,
				Size = UDim2.fromOffset(v4, v4),
				radius = Radius.Circle
			})
		else
			local createElement = React.createElement
			local v10 = {
				BackgroundTransparency = 1,
				Position = UDim2.new(0, 5, 0, 5),
				Size = UDim2.new(0, v4, 0, v4),
				ScaleType = Enum.ScaleType.Stretch,
				Image = not props.itemIcon and "icons/status/imageunavailable" or props.itemIcon,
				imageStyle = 0
			}
			local transparency

			if not props.itemIcon then
				transparency = v3.Color.Content.Default.Transparency
			end

			v10.imageStyle = { Transparency = transparency }
			itemIcon = createElement(Image, v10)
		end
	else
		itemIcon = React.createElement(ModelViewport, {
			model = props.model,
			Position = UDim2.fromOffset(5, 5),
			Size = UDim2.fromOffset(v4, v4)
		})
	end

	local itemBadge

	if props.badgeType and props.badgeType == VirtualItemBadgeType.Popular then
		itemBadge = React.createElement(YellowBadge, {
			LayoutOrder = 3,
			Text = v2.Popular,
			Icon = "icons/menu/fire_fill"
		})
	else
		itemBadge = nil
	end

	React.useEffect(function()
		if not itemBadge then
			return
		end

		default:logRobloxTelemetryCounter(VirtualItemBadgeShownCounter, 1, {
			badgeType = props.badgeType
		})
	end, {})
	local tag = props.isCompact and "auto-xy text-align-x-left text-wrap text-title-small content-emphasis"
		or "auto-xy text-align-x-left text-wrap text-title-medium content-emphasis"

	local tag2 = props.isCompact and "auto-xy text-align-x-left text-wrap text-title-small content-emphasis"
		or "auto-xy text-align-x-left text-wrap text-title-medium content-emphasis"

	local createElement = React.createElement
	local v10 = {
		LayoutOrder = props.layoutOrder,
		Size = UDim2.new(1, 0, 0, 0),
		tag = "auto-y row gap-small align-y-center align-x-left"
	}

	local createElement2 = React.createElement
	local v11 = {
		LayoutOrder = 2,
		Size = UDim2.new(1, -v4 - 6, 0, 0),
		tag = "col auto-y gap-small"
	}
	local itemName

	if FFlagUnifiedPurchaseAddSkeleton and props.isLoading and props.itemName == nil then
		itemName = React.createElement(Skeleton, {
			LayoutOrder = 1,
			Size = UDim2.fromScale(1, 0.3),
			radius = Radius.Circle,
			tag = "position-bottom-center"
		})
	else
		itemName = React.createElement(Text, {
			LayoutOrder = 1,
			Size = UDim2.new(1, 0, 0, 0),
			Text = withMaxLength(props.itemName), -- inferred equivalent call
			tag = tag
		})
	end

	local v12 = { ItemName = itemName, ItemSubtitle = props.subtitleView, ItemDetails = 0 }
	local itemDetails

	if FFlagUnifiedPurchaseAddSkeleton and props.isLoading and v == nil then
		itemDetails = React.createElement(Skeleton, {
			LayoutOrder = props.subtitleView and 3 or 2,
			Size = UDim2.fromScale(0.4, 0.3),
			radius = Radius.Circle
		})
	else
		local createElement3 = React.createElement
		local v13 = {
			LayoutOrder = props.subtitleView and 3 or 2,
			tag = props.isPortrait and "auto-xy col gap-small align-y-center" or fFlagDiscountInfoForSubscriptionPurchaseModalLua and v8 and "row align-y-center gap-small auto-xy clip" or "auto-xy row gap-small align-y-center"
		}
		local itemCost

		if FFlagLuaAppsEnablePromptVIPServerPurchase and props.priceText then
			itemCost = React.createElement(Text, {
				LayoutOrder = 1,
				Text = props.priceText,
				tag = tag2,
				RichText = true
			})
		elseif v then
			if FFlagUnifiedPurchaseFlowMarketplaceUIImprovements then
				itemCost = React.createElement(Text, {
					LayoutOrder = 1,
					Text = v5 .. ((not priceSuffix or priceSuffix == "") and "" or "" .. priceSuffix),
					tag = tag2,
					RichText = true
				})
			else
				itemCost = React.createElement(Text, {
					LayoutOrder = 1,
					Text = utf8.char(57346) .. " " .. formatNumber(LocalizationService.RobloxLocaleId, v) .. ((not priceSuffix or priceSuffix == "") and "" or "" .. priceSuffix),
					tag = "auto-xy text-align-x-left text-wrap text-title-medium content-emphasis"
				})
			end
		elseif FFlagEnableUnifiedPurchaseFlowForDevSubs and props.itemDisplayPrice then
			itemCost = React.createElement(Text, {
				LayoutOrder = 1,
				Text = props.itemDisplayPrice .. ((not priceSuffix or priceSuffix == "") and "" or "" .. priceSuffix),
				tag = tag2
			})
		end

		local originalPrice

		if v8 and v7 then
			originalPrice = React.createElement(Text, {
				LayoutOrder = 2,
				Text = "<s>" .. v7 .. ((not v9 or not priceSuffix or priceSuffix == "") and "" or priceSuffix) .. "</s>",
				tag = "auto-xy text-align-x-left text-wrap text-body-small content-default",
				RichText = true
			})
		end

		itemDetails = createElement3(View, v13, {
			ItemCost = itemCost,
			OriginalPrice = originalPrice,
			ItemBadge = itemBadge
		})
	end

	v12.ItemDetails = itemDetails
	return createElement(View, v10, {
		ItemIcon = itemIcon,
		ItemDetailsFrame = createElement2(View, v11, v12)
	})
end
