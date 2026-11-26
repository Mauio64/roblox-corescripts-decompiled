local formatNumber = require("@game/CorePackages/Workspace/Packages/_Index/IAPExperience/IAPExperience/Utility/formatNumber")

local React = require("@game/CorePackages/Workspace/Packages/_Workspace/IAPExperience/React")

local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/IAPExperience/Foundation")
local useTokens = Foundation.Hooks.useTokens
local text = Foundation.Text
local image = Foundation.Image
local view = Foundation.View
local skeleton = Foundation.Skeleton
local radius = Foundation.Enums.Radius

local VirtualItemBadgeType = require("@game/CorePackages/Workspace/Packages/_Index/IAPExperience/IAPExperience/Enums/VirtualItemBadgeType")

local ModelViewport = require("@game/CorePackages/Workspace/Packages/_Index/IAPExperience/IAPExperience/Generic/ModelViewport")
local YellowBadge = require("@game/CorePackages/Workspace/Packages/_Index/IAPExperience/IAPExperience/Generic/YellowBadge")

local LocalizationService = game:GetService("LocalizationService")
local useLocalization = require("@game/CorePackages/Workspace/Packages/_Workspace/IAPExperience/Localization").Hooks.useLocalization

local useRobuxText = require("@game/CorePackages/Workspace/Packages/_Index/IAPExperience/IAPExperience/Generic/Hooks/useRobuxText")

local fFlagUnifiedPurchaseFlowMarketplaceUIImprovements = require("@game/CorePackages/Workspace/Packages/_Workspace/IAPExperience/SharedFlags").FFlagUnifiedPurchaseFlowMarketplaceUIImprovements
local fFlagUnifiedPurchaseAddSkeleton = require("@game/CorePackages/Workspace/Packages/_Workspace/IAPExperience/SharedFlags").FFlagUnifiedPurchaseAddSkeleton

local fFlagEnableUnifiedPurchaseFlowForDevSubs = require("@game/CorePackages/Workspace/Packages/_Workspace/IAPExperience/SharedFlags").FFlagEnableUnifiedPurchaseFlowForDevSubs

local getFFlagDiscountInfoForSubscriptionPurchaseModalLua = require("@game/CorePackages/Workspace/Packages/_Workspace/IAPExperience/SharedFlags").GetFFlagDiscountInfoForSubscriptionPurchaseModalLua

local fFlagLuaAppsEnablePromptVIPServerPurchase = require("@game/CorePackages/Workspace/Packages/_Workspace/IAPExperience/SharedFlags").FFlagLuaAppsEnablePromptVIPServerPurchase

local default = require("@game/CorePackages/Workspace/Packages/_Index/IAPExperience/LoggingProtocol").default
local virtualItemBadgeShownCounter = require("@game/CorePackages/Workspace/Packages/_Index/IAPExperience/IAPExperience/Generic/Events/VirtualItemBadgeCounter").VirtualItemBadgeShownCounter

local function withMaxLength(value)
	if #value > 50 then
		return value:sub(1, 50) .. "..."
	end

	return value
end

require("@game/CorePackages/Workspace/Packages/_Index/IAPExperience/IAPExperience/ProductPurchase/PricingTypes")

return function(props)
	local fFlagDiscountInfoForSubscriptionPurchaseModalLua = getFFlagDiscountInfoForSubscriptionPurchaseModalLua()
	local itemPrice = props.itemPrice
	local v5 = if itemPrice then itemPrice.priceInRobux else props.itemRobuxCost

	local v6 = useLocalization({
		Popular = "IAPExperience.RobuxUpsell.Text.PopularItem"
	})

	local priceSuffix = props.priceSuffix

	local v7 = useTokens()
	local v8 = props.isPortrait and 128 or 72

	local v9 = if fFlagUnifiedPurchaseFlowMarketplaceUIImprovements then useRobuxText(v5) else nil

	local v11 = if itemPrice then itemPrice.basePriceInRobux else props.itemRobuxCost
	local v12 = useRobuxText(v11)
	local v13 = itemPrice and itemPrice.basePriceInRobux > itemPrice.priceInRobux
	local v14

	if fFlagLuaAppsEnablePromptVIPServerPurchase and props.includePriceSuffixOnOriginal ~= nil then
		v14 = props.includePriceSuffixOnOriginal
	else
		v14 = fFlagDiscountInfoForSubscriptionPurchaseModalLua
	end

	if props.isCompact then
		v8 *= 0.7
	end

	local v15

	if props.model == nil then
		if fFlagUnifiedPurchaseAddSkeleton and props.itemIcon == nil and props.isLoading then
			v15 = React.createElement(skeleton, {
				LayoutOrder = 1,
				Size = UDim2.fromOffset(v8, v8),
				radius = radius.Circle
			})
		else
			local createElement = React.createElement
			local v17 = {
				BackgroundTransparency = 1,
				Position = UDim2.new(0, 5, 0, 5),
				Size = UDim2.new(0, v8, 0, v8),
				ScaleType = Enum.ScaleType.Stretch,
				Image = not props.itemIcon and "icons/status/imageunavailable" or props.itemIcon,
				imageStyle = 0
			}

			local v19 = if not props.itemIcon then v7.Color.Content.Default.Transparency else nil
			v17.imageStyle = { Transparency = v19 }
			v15 = createElement(image, v17)
		end
	else
		v15 = React.createElement(ModelViewport, {
			model = props.model,
			Position = UDim2.fromOffset(5, 5),
			Size = UDim2.fromOffset(v8, v8)
		})
	end

	local v16

	if props.badgeType and props.badgeType == VirtualItemBadgeType.Popular then
		v16 = React.createElement(YellowBadge, {
			LayoutOrder = 3,
			Text = v6.Popular,
			Icon = "icons/menu/fire_fill"
		})
	else
		v16 = nil
	end

	React.useEffect(function()
		if not v16 then
			return
		end

		default:logRobloxTelemetryCounter(virtualItemBadgeShownCounter, 1, {
			badgeType = props.badgeType
		})
	end, {})
	local v17 = props.isCompact
		and "auto-xy text-align-x-left text-wrap text-title-small content-emphasis"
		or "auto-xy text-align-x-left text-wrap text-title-medium content-emphasis"

	local v18 = props.isCompact
		and "auto-xy text-align-x-left text-wrap text-title-small content-emphasis"
		or "auto-xy text-align-x-left text-wrap text-title-medium content-emphasis"

	local createElement = React.createElement
	local v20 = {
		LayoutOrder = props.layoutOrder,
		Size = UDim2.new(1, 0, 0, 0),
		tag = "auto-y row gap-small align-y-center align-x-left"
	}

	local createElement2 = React.createElement
	local v23 = {
		LayoutOrder = 2,
		Size = UDim2.new(1, -v8 - 6, 0, 0),
		tag = "col auto-y gap-small"
	}
	local v25

	if fFlagUnifiedPurchaseAddSkeleton and props.isLoading and props.itemName == nil then
		v25 = React.createElement(skeleton, {
			LayoutOrder = 1,
			Size = UDim2.fromScale(1, 0.3),
			radius = radius.Circle,
			tag = "position-bottom-center"
		})
	else
		local createElement3 = React.createElement
		local v27 = { LayoutOrder = 1, Size = UDim2.new(1, 0, 0, 0), Text = 0, tag = 0 }
		local v28 = props.itemName

		if #v28 > 50 then
			v28 = v28:sub(1, 50) .. "..."
		end

		v27.Text = v28
		v27.tag = v17
		v25 = createElement3(text, v27)
	end

	local v24 = { ItemName = v25, ItemSubtitle = props.subtitleView, ItemDetails = 0 }
	local v26

	if fFlagUnifiedPurchaseAddSkeleton and props.isLoading and v5 == nil then
		v26 = React.createElement(skeleton, {
			LayoutOrder = props.subtitleView and 3 or 2,
			Size = UDim2.fromScale(0.4, 0.3),
			radius = radius.Circle
		})
	else
		local createElement3 = React.createElement
		local v28 = {
			LayoutOrder = props.subtitleView and 3 or 2,
			tag = props.isPortrait and "auto-xy col gap-small align-y-center" or fFlagDiscountInfoForSubscriptionPurchaseModalLua and v13 and "row align-y-center gap-small auto-xy clip" or "auto-xy row gap-small align-y-center"
		}
		local v30

		if fFlagLuaAppsEnablePromptVIPServerPurchase and props.priceText then
			v30 = React.createElement(text, {
				LayoutOrder = 1,
				Text = props.priceText,
				tag = v18,
				RichText = true
			})
		elseif v5 then
			if fFlagUnifiedPurchaseFlowMarketplaceUIImprovements then
				v30 = React.createElement(text, {
					LayoutOrder = 1,
					Text = v9 .. ((not priceSuffix or priceSuffix == "") and "" or "" .. priceSuffix),
					tag = v18,
					RichText = true
				})
			else
				v30 = React.createElement(text, {
					LayoutOrder = 1,
					Text = utf8.char(57346) .. " " .. formatNumber(LocalizationService.RobloxLocaleId, v5) .. ((not priceSuffix or priceSuffix == "") and "" or "" .. priceSuffix),
					tag = "auto-xy text-align-x-left text-wrap text-title-medium content-emphasis"
				})
			end
		elseif fFlagEnableUnifiedPurchaseFlowForDevSubs and props.itemDisplayPrice then
			v30 = React.createElement(text, {
				LayoutOrder = 1,
				Text = props.itemDisplayPrice .. ((not priceSuffix or priceSuffix == "") and "" or "" .. priceSuffix),
				tag = v18
			})
		end

		local v31 = if v13 and v12 then React.createElement(text, {
			LayoutOrder = 2,
			Text = "<s>" .. v12 .. ((not v14 or not priceSuffix or priceSuffix == "") and "" or priceSuffix) .. "</s>",
			tag = "auto-xy text-align-x-left text-wrap text-body-small content-default",
			RichText = true
		}) else nil
		v26 = createElement3(view, v28, {
			ItemCost = v30,
			OriginalPrice = v31,
			ItemBadge = v16
		})
	end

	v24.ItemDetails = v26
	return createElement(view, v20, {
		ItemIcon = v15,
		ItemDetailsFrame = createElement2(view, v23, v24)
	})
end
