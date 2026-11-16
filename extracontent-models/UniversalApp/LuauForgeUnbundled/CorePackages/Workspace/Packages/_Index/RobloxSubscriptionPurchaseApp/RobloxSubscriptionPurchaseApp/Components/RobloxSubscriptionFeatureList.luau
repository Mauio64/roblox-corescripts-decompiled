local React = require("@game/CorePackages/Workspace/Packages/_Workspace/RobloxSubscriptionPurchaseApp/React")
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/RobloxSubscriptionPurchaseApp/Foundation")
local LuauPolyfill = require("@game/CorePackages/Workspace/Packages/_Workspace/RobloxSubscriptionPurchaseApp/LuauPolyfill")
local RobloxSubscriptionStore = require("@game/CorePackages/Workspace/Packages/_Index/RobloxSubscriptionPurchaseApp/RobloxSubscriptionPurchaseApp/Store/RobloxSubscriptionStore")
require("@game/CorePackages/Workspace/Packages/_Index/RobloxSubscriptionPurchaseApp/RobloxSubscriptionPurchaseApp/Models/GetRobloxSubscriptionProductsModel")
local useLocalization = require("@game/CorePackages/Workspace/Packages/_Workspace/RobloxSubscriptionPurchaseApp/Localization").Hooks.useLocalization
local getPeriodTypeDisplayLabel = require("@game/CorePackages/Workspace/Packages/_Index/RobloxSubscriptionPurchaseApp/RobloxSubscriptionPurchaseApp/Utils/getPeriodTypeDisplayLabel")
local getFreeTrialOffer = require("@game/CorePackages/Workspace/Packages/_Index/RobloxSubscriptionPurchaseApp/RobloxSubscriptionPurchaseApp/Utils/getFreeTrialOffer")
local getTrialUnlockDays = require("@game/CorePackages/Workspace/Packages/_Index/RobloxSubscriptionPurchaseApp/RobloxSubscriptionPurchaseApp/Utils/getTrialUnlockDays")
local isSupportedTrialPeriodType = require("@game/CorePackages/Workspace/Packages/_Index/RobloxSubscriptionPurchaseApp/RobloxSubscriptionPurchaseApp/Utils/isSupportedTrialPeriodType")
local SignalsReact = require("@game/CorePackages/Workspace/Packages/_Workspace/RobloxSubscriptionPurchaseApp/SignalsReact")

local defineFastFlag = game:DefineFastFlag("RobloxPlusUpdateDiscountIcons", false)
local FFlagRobloxPlusEnableNewFeatureList = require("@game/CorePackages/Workspace/Packages/_Index/RobloxSubscriptionPurchaseApp/RobloxSubscriptionPurchaseApp/Flags/FFlagRobloxPlusEnableNewFeatureList")
local FFlagRobloxPlusTrialDiscountTiming = require("@game/CorePackages/Workspace/Packages/_Index/RobloxSubscriptionPurchaseApp/RobloxSubscriptionPurchaseApp/Flags/FFlagRobloxPlusTrialDiscountTiming")
local fFlagEnablePlusReferralLandingSheet = require("@game/CorePackages/Workspace/Packages/_Workspace/RobloxSubscriptionPurchaseApp/SharedFlags").FFlagEnablePlusReferralLandingSheet

local array = LuauPolyfill.Array

local view = Foundation.View
local text = Foundation.Text
local icon = Foundation.Icon
local iconName = Foundation.Enums.IconName
local iconSize = Foundation.Enums.IconSize

local function FeatureRow(props)
	return React.createElement(
		view,
		{
			tag = "row auto-y size-full-0 align-y-center align-x-left gap-medium",
			LayoutOrder = props.layoutOrder
		},
		{
			Icon = React.createElement(icon, {
				name = props.iconName,
				size = iconSize.Medium
			}),
			FeatureText = React.createElement(text, {
				Text = props.text,
				tag = "size-full-0 auto-y text-body-medium content-default text-align-x-left"
			})
		}
	)
end

local function getVirtualTransactionDiscounts(featureConfig)
	if not (featureConfig and featureConfig.VirtualTransactionDiscounts) then
		return nil, nil
	end

	local v5 = nil
	local v6 = nil

	for i, virtualTransactionDiscount in ipairs(featureConfig.VirtualTransactionDiscounts) do
		if not (typeof(virtualTransactionDiscount) == "table" and typeof(virtualTransactionDiscount.PeriodIndex) == "number") then
			continue
		end

		if virtualTransactionDiscount.PeriodIndex == 0 then
			v6 = v6 or virtualTransactionDiscount
		elseif
			virtualTransactionDiscount.PeriodIndex > 0
			and (v5 == nil or virtualTransactionDiscount.PeriodIndex < v5.PeriodIndex)
		then
			v5 = virtualTransactionDiscount
		end
	end

	return v6, v5
end

local function getPrivateServerDiscount(p2)
	if p2 and p2.PrivateServerDiscounts then
		return array.find(p2.PrivateServerDiscounts, function(p3): boolean
			return typeof(p3) == "table" and typeof(p3.PeriodIndex) == "number" and p3.PeriodIndex == 0
		end)
	end

	return nil
end

local function RobloxSubscriptionFeatureList(props)
	local v5 = RobloxSubscriptionStore.get()
	local v6 = SignalsReact.useSignalState(v5.getRobloxSubscriptionProduct)

	local periodType = v6 and v6.PeriodType and tostring(v6.PeriodType) or ""
	local v7 = getPeriodTypeDisplayLabel(periodType, true)

	local v8 = if FFlagRobloxPlusTrialDiscountTiming then getFreeTrialOffer(v6) else nil
	local v9 = FFlagRobloxPlusTrialDiscountTiming

	if v9 then
		v9 = not (v8 == nil) and isSupportedTrialPeriodType(v8.PeriodType)
	end

	local v10 = useLocalization({ periodType = v7 })

	local featureConfig = v6
		and v6.ProductTypeDetails
		and v6.ProductTypeDetails.RobloxSubscriptionProductDetails
		and v6.ProductTypeDetails.RobloxSubscriptionProductDetails.FeatureConfig

	local virtualTransactionDiscounts, v11 = getVirtualTransactionDiscounts(featureConfig)
	local v12

	if featureConfig and featureConfig.PrivateServerDiscounts then
		v12 = array.find(featureConfig.PrivateServerDiscounts, function(p2): boolean
			return typeof(p2) == "table" and typeof(p2.PeriodIndex) == "number" and p2.PeriodIndex == 0
		end)
	end

	local v13 = if v9 then getTrialUnlockDays(v8, v11 and v11.PeriodIndex, periodType) else nil

	local v14 = useLocalization({
		baseVirtualTransactionDiscountText = {
			"Feature.RobloxSubscription.Label.BlackbirdVTDiscountFirst",
			discountPercent = virtualTransactionDiscounts and virtualTransactionDiscounts.DiscountPercent or 0
		},
		nextVirtualTransactionDiscountText = {
			"Feature.RobloxSubscription.Label.BlackbirdVTDiscountSecond",
			discountPercent = v11 and v11.DiscountPercent or 0,
			periodIndex = v11 and v11.PeriodIndex or 0,
			periodType = v10.periodType
		},
		robuxTransfersText = "Feature.RobloxSubscription.Label.BlackbirdTr",
		privateServerDiscountText = "Feature.RobloxSubscription.Label.BlackbirdPSDiscount",
		discountFeatureText = "Feature.RobloxSubscription.Description.Benefit.DiscountV2",
		discountFeatureTextV3 = v9 and {
			"Feature.RobloxSubscription.Description.Benefit.DiscountV3",
			trialUnlockDays = v13
		} or nil,
		customizeFeatureText = "Feature.RobloxSubscription.Description.Benefit.Customize"
	})

	local v15 = {}

	local function addRow(p2, p3)
		table.insert(v15, FeatureRow({
			layoutOrder = #v15 + 1,
			iconName = p2,
			text = p3
		}))
	end

	if FFlagRobloxPlusEnableNewFeatureList then
		if props.noPurchaseMethodRequired then
			if virtualTransactionDiscounts then
				local tag = iconName.Tag
				local baseVirtualTransactionDiscountText = v14.baseVirtualTransactionDiscountText
				table.insert(v15, FeatureRow({
					layoutOrder = #v15 + 1,
					iconName = tag,
					text = baseVirtualTransactionDiscountText
				}))
			end
		else
			if virtualTransactionDiscounts and v11 then
				local tag = iconName.Tag

				local v16 = if v9 then v14.discountFeatureTextV3 else v14.discountFeatureText
				table.insert(v15, FeatureRow({
					layoutOrder = #v15 + 1,
					iconName = tag,
					text = v16
				}))
			elseif virtualTransactionDiscounts and not v11 then
				local tag = iconName.Tag
				local baseVirtualTransactionDiscountText = v14.baseVirtualTransactionDiscountText
				table.insert(v15, FeatureRow({
					layoutOrder = #v15 + 1,
					iconName = tag,
					text = baseVirtualTransactionDiscountText
				}))
			end

			local paintBrush = iconName.PaintBrush
			local customizeFeatureText = v14.customizeFeatureText
			table.insert(v15, FeatureRow({
				layoutOrder = #v15 + 1,
				iconName = paintBrush,
				text = customizeFeatureText
			}))
		end
	else
		if
			virtualTransactionDiscounts
			and typeof(virtualTransactionDiscounts.DiscountPercent) == "number"
		then
			local v16 = if defineFastFlag then iconName.Tag else iconName.TagSparkle
			local baseVirtualTransactionDiscountText = v14.baseVirtualTransactionDiscountText
			table.insert(v15, FeatureRow({
				layoutOrder = #v15 + 1,
				iconName = v16,
				text = baseVirtualTransactionDiscountText
			}))
		end

		if v11 and typeof(v11.DiscountPercent) == "number" and not props.noPurchaseMethodRequired then
			local v16 = if defineFastFlag then iconName.TagArrowUp else iconName.TagSparkleArrowUp
			local nextVirtualTransactionDiscountText = v14.nextVirtualTransactionDiscountText
			table.insert(v15, FeatureRow({
				layoutOrder = #v15 + 1,
				iconName = v16,
				text = nextVirtualTransactionDiscountText
			}))
		end
	end

	if v12 and typeof(v12.DiscountPercent) == "number" then
		local controller = iconName.Controller
		local privateServerDiscountText = v14.privateServerDiscountText
		table.insert(v15, FeatureRow({
			layoutOrder = #v15 + 1,
			iconName = controller,
			text = privateServerDiscountText
		}))
	end

	if featureConfig and featureConfig.IsRobuxTransferEnabled then
		local robux = iconName.Robux
		local robuxTransfersText = v14.robuxTransfersText
		table.insert(v15, FeatureRow({
			layoutOrder = #v15 + 1,
			iconName = robux,
			text = robuxTransfersText
		}))
	end

	return React.createElement(view, {
		tag = fFlagEnablePlusReferralLandingSheet and props.compact and "col auto-y size-full-0 align-x-left gap-small padding-top-small" or "col auto-y size-full-0 align-x-left gap-medium padding-top-large",
		LayoutOrder = props.layoutOrder
	}, v15)
end

return RobloxSubscriptionFeatureList
