local RobloxSubscriptionPurchaseApp = script:FindFirstAncestor("RobloxSubscriptionPurchaseApp")
local parent = RobloxSubscriptionPurchaseApp.Parent

local React = require(parent.React)
local Foundation = require(parent.Foundation)
local LuauPolyfill = require(parent.LuauPolyfill)
local RobloxSubscriptionStore = require(RobloxSubscriptionPurchaseApp.Store.RobloxSubscriptionStore)
require(RobloxSubscriptionPurchaseApp.Models.GetRobloxSubscriptionProductsModel)
local Localization = require(parent.Localization)
local useLocalization = Localization.Hooks.useLocalization
local getPeriodTypeDisplayLabel = require(RobloxSubscriptionPurchaseApp.Utils.getPeriodTypeDisplayLabel)
local getFreeTrialOffer = require(RobloxSubscriptionPurchaseApp.Utils.getFreeTrialOffer)
local getTrialUnlockDays = require(RobloxSubscriptionPurchaseApp.Utils.getTrialUnlockDays)
local isSupportedTrialPeriodType = require(RobloxSubscriptionPurchaseApp.Utils.isSupportedTrialPeriodType)
local SignalsReact = require(parent.SignalsReact)

local defineFastFlag = game:DefineFastFlag("RobloxPlusUpdateDiscountIcons", false)
local FFlagRobloxPlusEnableNewFeatureList = require(RobloxSubscriptionPurchaseApp.Flags.FFlagRobloxPlusEnableNewFeatureList)
local FFlagRobloxPlusTrialDiscountTiming = require(RobloxSubscriptionPurchaseApp.Flags.FFlagRobloxPlusTrialDiscountTiming)
local SharedFlags = require(parent.SharedFlags)
local FFlagEnablePlusReferralLandingSheet = SharedFlags.FFlagEnablePlusReferralLandingSheet
local FFlagRobloxPlusAppIconBenefit = require(RobloxSubscriptionPurchaseApp.Flags.FFlagRobloxPlusAppIconBenefit)
local SharedFlags2 = require(parent.SharedFlags)
local FFlagAppIconSelectionPage = SharedFlags2.FFlagAppIconSelectionPage
local UniversalAppPolicy

if FFlagRobloxPlusAppIconBenefit then
	UniversalAppPolicy = require(parent.UniversalAppPolicy)
else
	UniversalAppPolicy = nil
end

local Array = LuauPolyfill.Array

local FeatureRow = require(script.Parent.FeatureRow)

local View = Foundation.View
local IconName = Foundation.Enums.IconName

local function getVirtualTransactionDiscounts(featureConfig)
	if not (featureConfig and featureConfig.VirtualTransactionDiscounts) then
		return nil, nil
	end

	local v = nil
	local v2 = nil

	for _, virtualTransactionDiscount in ipairs(featureConfig.VirtualTransactionDiscounts) do
		if not (typeof(virtualTransactionDiscount) == "table" and typeof(virtualTransactionDiscount.PeriodIndex) == "number") then
			continue
		end

		if virtualTransactionDiscount.PeriodIndex == 0 then
			v2 = v2 or virtualTransactionDiscount
		elseif
			virtualTransactionDiscount.PeriodIndex > 0
			and (v == nil or virtualTransactionDiscount.PeriodIndex < v.PeriodIndex)
		then
			v = virtualTransactionDiscount
		end
	end

	return v2, v
end

local function getPrivateServerDiscount(p)
	if p and p.PrivateServerDiscounts then
		return Array.find(p.PrivateServerDiscounts, function(p2): boolean
			return typeof(p2) == "table" and typeof(p2.PeriodIndex) == "number" and p2.PeriodIndex == 0
		end)
	end

	return nil
end

local function RobloxSubscriptionFeatureList(props)
	local v = RobloxSubscriptionStore.get()
	local v2 = SignalsReact.useSignalState(v.getRobloxSubscriptionProduct)

	local periodType = v2 and v2.PeriodType and tostring(v2.PeriodType) or ""
	local periodTypeDisplayLabel = getPeriodTypeDisplayLabel(periodType, true)
	local v3

	if FFlagRobloxPlusTrialDiscountTiming then
		v3 = getFreeTrialOffer(v2)
	end

	local v4 = FFlagRobloxPlusTrialDiscountTiming

	if v4 then
		if v3 == nil then
			v4 = false
		else
			v4 = isSupportedTrialPeriodType(v3.PeriodType)
		end
	end

	local v5 = useLocalization({ periodType = periodTypeDisplayLabel })

	local featureConfig = v2
		and v2.ProductTypeDetails
		and v2.ProductTypeDetails.RobloxSubscriptionProductDetails
		and v2.ProductTypeDetails.RobloxSubscriptionProductDetails.FeatureConfig

	local virtualTransactionDiscounts, v6 = getVirtualTransactionDiscounts(featureConfig)
	local v7

	if featureConfig and featureConfig.PrivateServerDiscounts then
		v7 = Array.find(featureConfig.PrivateServerDiscounts, function(p): boolean
			return typeof(p) == "table" and typeof(p.PeriodIndex) == "number" and p.PeriodIndex == 0
		end)
	end

	local trialUnlockDays

	if v4 then
		trialUnlockDays = getTrialUnlockDays(v3, v6 and v6.PeriodIndex, periodType)
	end

	local v8 = FFlagRobloxPlusAppIconBenefit
		and FFlagAppIconSelectionPage
		and UniversalAppPolicy.getAppFeaturePolicies().getShowAppIconSetting()

	local v9 = useLocalization({
		baseVirtualTransactionDiscountText = {
			"Feature.RobloxSubscription.Label.BlackbirdVTDiscountFirst",
			discountPercent = virtualTransactionDiscounts and virtualTransactionDiscounts.DiscountPercent or 0
		},
		nextVirtualTransactionDiscountText = {
			"Feature.RobloxSubscription.Label.BlackbirdVTDiscountSecond",
			discountPercent = v6 and v6.DiscountPercent or 0,
			periodIndex = v6 and v6.PeriodIndex or 0,
			periodType = v5.periodType
		},
		robuxTransfersText = "Feature.RobloxSubscription.Label.BlackbirdTr",
		privateServerDiscountText = "Feature.RobloxSubscription.Label.BlackbirdPSDiscount",
		discountFeatureText = "Feature.RobloxSubscription.Description.Benefit.DiscountV2",
		discountFeatureTextV3 = v4 and {
			"Feature.RobloxSubscription.Description.Benefit.DiscountV3",
			trialUnlockDays = trialUnlockDays
		} or nil,
		customizeFeatureText = v8 and "Feature.RobloxSubscription.Description.Benefit.CustomizeWithAppIcon" or "Feature.RobloxSubscription.Description.Benefit.Customize"
	})

	local v10 = {}

	local function addRow(iconName, text) -- 8 equivalent calls inferred from this helper
		table.insert(v10, FeatureRow({
			layoutOrder = #v10 + 1,
			iconName = iconName,
			text = text
		}))
	end

	if FFlagRobloxPlusEnableNewFeatureList then
		if props.noPurchaseMethodRequired then
			if virtualTransactionDiscounts then
				addRow(IconName.Tag, v9.baseVirtualTransactionDiscountText) -- inferred equivalent call
			end
		else
			if virtualTransactionDiscounts and v6 then
				local tag = IconName.Tag
				local v11

				if v4 then
					v11 = v9.discountFeatureTextV3
				else
					v11 = v9.discountFeatureText
				end

				addRow(tag, v11) -- inferred equivalent call
			elseif virtualTransactionDiscounts and not v6 then
				addRow(IconName.Tag, v9.baseVirtualTransactionDiscountText) -- inferred equivalent call
			end

			addRow(IconName.PaintBrush, v9.customizeFeatureText) -- inferred equivalent call
		end
	else
		if virtualTransactionDiscounts and typeof(virtualTransactionDiscounts.DiscountPercent) == "number" then
			local v11

			if defineFastFlag then
				v11 = IconName.Tag
			else
				v11 = IconName.TagSparkle
			end

			addRow(v11, v9.baseVirtualTransactionDiscountText) -- inferred equivalent call
		end

		if v6 and typeof(v6.DiscountPercent) == "number" and not props.noPurchaseMethodRequired then
			local v11

			if defineFastFlag then
				v11 = IconName.TagArrowUp
			else
				v11 = IconName.TagSparkleArrowUp
			end

			addRow(v11, v9.nextVirtualTransactionDiscountText) -- inferred equivalent call
		end
	end

	if v7 and typeof(v7.DiscountPercent) == "number" then
		addRow(IconName.Controller, v9.privateServerDiscountText) -- inferred equivalent call
	end

	if featureConfig and featureConfig.IsRobuxTransferEnabled then
		addRow(IconName.Robux, v9.robuxTransfersText) -- inferred equivalent call
	end

	return React.createElement(View, {
		tag = FFlagEnablePlusReferralLandingSheet and props.compact and "col auto-y size-full-0 align-x-left gap-small padding-top-small" or "col auto-y size-full-0 align-x-left gap-medium padding-top-large",
		LayoutOrder = props.layoutOrder
	}, v10)
end

return RobloxSubscriptionFeatureList
