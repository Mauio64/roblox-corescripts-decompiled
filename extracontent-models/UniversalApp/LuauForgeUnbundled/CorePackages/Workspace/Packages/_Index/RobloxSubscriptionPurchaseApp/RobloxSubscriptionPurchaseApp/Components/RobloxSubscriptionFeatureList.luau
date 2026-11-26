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
local FFlagRobloxPlusAppIconBenefit = require("@game/CorePackages/Workspace/Packages/_Index/RobloxSubscriptionPurchaseApp/RobloxSubscriptionPurchaseApp/Flags/FFlagRobloxPlusAppIconBenefit")
local fFlagAppIconSelectionPage = require("@game/CorePackages/Workspace/Packages/_Workspace/RobloxSubscriptionPurchaseApp/SharedFlags").FFlagAppIconSelectionPage

local v5 = if FFlagRobloxPlusAppIconBenefit then require("@game/CorePackages/Workspace/Packages/_Workspace/RobloxSubscriptionPurchaseApp/UniversalAppPolicy") else nil

local array = LuauPolyfill.Array

local FeatureRow = require("@game/CorePackages/Workspace/Packages/_Index/RobloxSubscriptionPurchaseApp/RobloxSubscriptionPurchaseApp/Components/FeatureRow")

local view = Foundation.View
local iconName = Foundation.Enums.IconName

local function getVirtualTransactionDiscounts(featureConfig)
	if not (featureConfig and featureConfig.VirtualTransactionDiscounts) then
		return nil, nil
	end

	local v6 = nil
	local v7 = nil

	for i, virtualTransactionDiscount in ipairs(featureConfig.VirtualTransactionDiscounts) do
		if not (typeof(virtualTransactionDiscount) == "table" and typeof(virtualTransactionDiscount.PeriodIndex) == "number") then
			continue
		end

		if virtualTransactionDiscount.PeriodIndex == 0 then
			v7 = v7 or virtualTransactionDiscount
		elseif
			virtualTransactionDiscount.PeriodIndex > 0
			and (v6 == nil or virtualTransactionDiscount.PeriodIndex < v6.PeriodIndex)
		then
			v6 = virtualTransactionDiscount
		end
	end

	return v7, v6
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
	local v6 = RobloxSubscriptionStore.get()
	local v7 = SignalsReact.useSignalState(v6.getRobloxSubscriptionProduct)

	local periodType = v7 and v7.PeriodType and tostring(v7.PeriodType) or ""
	local v8 = getPeriodTypeDisplayLabel(periodType, true)

	local v9 = if FFlagRobloxPlusTrialDiscountTiming then getFreeTrialOffer(v7) else nil
	local v10 = FFlagRobloxPlusTrialDiscountTiming

	if v10 then
		v10 = not (v9 == nil) and isSupportedTrialPeriodType(v9.PeriodType)
	end

	local v11 = useLocalization({ periodType = v8 })

	local featureConfig = v7
		and v7.ProductTypeDetails
		and v7.ProductTypeDetails.RobloxSubscriptionProductDetails
		and v7.ProductTypeDetails.RobloxSubscriptionProductDetails.FeatureConfig

	local virtualTransactionDiscounts, v12 = getVirtualTransactionDiscounts(featureConfig)
	local v13

	if featureConfig and featureConfig.PrivateServerDiscounts then
		v13 = array.find(featureConfig.PrivateServerDiscounts, function(p2): boolean
			return typeof(p2) == "table" and typeof(p2.PeriodIndex) == "number" and p2.PeriodIndex == 0
		end)
	end

	local v14 = if v10 then getTrialUnlockDays(v9, v12 and v12.PeriodIndex, periodType) else nil

	local v15 = FFlagRobloxPlusAppIconBenefit
		and fFlagAppIconSelectionPage
		and v5.getAppFeaturePolicies().getShowAppIconSetting()

	local v16 = useLocalization({
		baseVirtualTransactionDiscountText = {
			"Feature.RobloxSubscription.Label.BlackbirdVTDiscountFirst",
			discountPercent = virtualTransactionDiscounts and virtualTransactionDiscounts.DiscountPercent or 0
		},
		nextVirtualTransactionDiscountText = {
			"Feature.RobloxSubscription.Label.BlackbirdVTDiscountSecond",
			discountPercent = v12 and v12.DiscountPercent or 0,
			periodIndex = v12 and v12.PeriodIndex or 0,
			periodType = v11.periodType
		},
		robuxTransfersText = "Feature.RobloxSubscription.Label.BlackbirdTr",
		privateServerDiscountText = "Feature.RobloxSubscription.Label.BlackbirdPSDiscount",
		discountFeatureText = "Feature.RobloxSubscription.Description.Benefit.DiscountV2",
		discountFeatureTextV3 = v10 and {
			"Feature.RobloxSubscription.Description.Benefit.DiscountV3",
			trialUnlockDays = v14
		} or nil,
		customizeFeatureText = v15 and "Feature.RobloxSubscription.Description.Benefit.CustomizeWithAppIcon" or "Feature.RobloxSubscription.Description.Benefit.Customize"
	})

	local v17 = {}

	local function addRow(p2, p3)
		table.insert(v17, FeatureRow({
			layoutOrder = #v17 + 1,
			iconName = p2,
			text = p3
		}))
	end

	if FFlagRobloxPlusEnableNewFeatureList then
		if props.noPurchaseMethodRequired then
			if virtualTransactionDiscounts then
				local tag = iconName.Tag
				local baseVirtualTransactionDiscountText = v16.baseVirtualTransactionDiscountText
				table.insert(v17, FeatureRow({
					layoutOrder = #v17 + 1,
					iconName = tag,
					text = baseVirtualTransactionDiscountText
				}))
			end
		else
			if virtualTransactionDiscounts and v12 then
				local tag = iconName.Tag

				local v18 = if v10 then v16.discountFeatureTextV3 else v16.discountFeatureText
				table.insert(v17, FeatureRow({
					layoutOrder = #v17 + 1,
					iconName = tag,
					text = v18
				}))
			elseif virtualTransactionDiscounts and not v12 then
				local tag = iconName.Tag
				local baseVirtualTransactionDiscountText = v16.baseVirtualTransactionDiscountText
				table.insert(v17, FeatureRow({
					layoutOrder = #v17 + 1,
					iconName = tag,
					text = baseVirtualTransactionDiscountText
				}))
			end

			local paintBrush = iconName.PaintBrush
			local customizeFeatureText = v16.customizeFeatureText
			table.insert(v17, FeatureRow({
				layoutOrder = #v17 + 1,
				iconName = paintBrush,
				text = customizeFeatureText
			}))
		end
	else
		if
			virtualTransactionDiscounts
			and typeof(virtualTransactionDiscounts.DiscountPercent) == "number"
		then
			local v18 = if defineFastFlag then iconName.Tag else iconName.TagSparkle
			local baseVirtualTransactionDiscountText = v16.baseVirtualTransactionDiscountText
			table.insert(v17, FeatureRow({
				layoutOrder = #v17 + 1,
				iconName = v18,
				text = baseVirtualTransactionDiscountText
			}))
		end

		if v12 and typeof(v12.DiscountPercent) == "number" and not props.noPurchaseMethodRequired then
			local v18 = if defineFastFlag then iconName.TagArrowUp else iconName.TagSparkleArrowUp
			local nextVirtualTransactionDiscountText = v16.nextVirtualTransactionDiscountText
			table.insert(v17, FeatureRow({
				layoutOrder = #v17 + 1,
				iconName = v18,
				text = nextVirtualTransactionDiscountText
			}))
		end
	end

	if v13 and typeof(v13.DiscountPercent) == "number" then
		local controller = iconName.Controller
		local privateServerDiscountText = v16.privateServerDiscountText
		table.insert(v17, FeatureRow({
			layoutOrder = #v17 + 1,
			iconName = controller,
			text = privateServerDiscountText
		}))
	end

	if featureConfig and featureConfig.IsRobuxTransferEnabled then
		local robux = iconName.Robux
		local robuxTransfersText = v16.robuxTransfersText
		table.insert(v17, FeatureRow({
			layoutOrder = #v17 + 1,
			iconName = robux,
			text = robuxTransfersText
		}))
	end

	return React.createElement(view, {
		tag = fFlagEnablePlusReferralLandingSheet and props.compact and "col auto-y size-full-0 align-x-left gap-small padding-top-small" or "col auto-y size-full-0 align-x-left gap-medium padding-top-large",
		LayoutOrder = props.layoutOrder
	}, v17)
end

return RobloxSubscriptionFeatureList
