local RobloxSubscriptionPurchaseApp = script:FindFirstAncestor("RobloxSubscriptionPurchaseApp")
local RobloxSubscriptionPurchaseAppParent = RobloxSubscriptionPurchaseApp.Parent
local React = require(RobloxSubscriptionPurchaseAppParent.React)
local Foundation = require(RobloxSubscriptionPurchaseAppParent.Foundation)
local LuauPolyfill = require(RobloxSubscriptionPurchaseAppParent.LuauPolyfill)
local RobloxSubscriptionStore = require(RobloxSubscriptionPurchaseApp.Store.RobloxSubscriptionStore)

require(RobloxSubscriptionPurchaseApp.Models.GetRobloxSubscriptionProductsModel)

local useLocalization = require(RobloxSubscriptionPurchaseAppParent.Localization).Hooks.useLocalization
local getPeriodTypeDisplayLabel = require(RobloxSubscriptionPurchaseApp.Utils.getPeriodTypeDisplayLabel)
local SignalsReact = require(RobloxSubscriptionPurchaseAppParent.SignalsReact)
local v10 = game:DefineFastFlag("RobloxPlusUpdateDiscountIcons", false)
local FFlagRobloxPlusFAEFreeTrial = require(RobloxSubscriptionPurchaseApp.Flags.FFlagRobloxPlusFAEFreeTrial)
local Array = LuauPolyfill.Array
local View = Foundation.View
local FoundationText = Foundation.Text
local Icon = Foundation.Icon
local IconName = Foundation.Enums.IconName
local IconSize = Foundation.Enums.IconSize

local function FeatureRow(t1: {[any]: any}) -- line: 33
	-- upvalues: React (copy), View (copy), Icon (copy), IconSize (copy), FoundationText (copy)
	return React.createElement(View, {
		tag = "row auto-y size-full-0 align-y-center align-x-left gap-medium",
		LayoutOrder = t1.layoutOrder
	}, {
		Icon = React.createElement(Icon, {
			name = t1.iconName,
			size = IconSize.Medium
		}),
		FeatureText = React.createElement(FoundationText, {
			tag = "size-full-0 auto-y text-body-medium content-default text-align-x-left",
			Text = t1.text
		})
	})
end
local function getVirtualTransactionDiscounts(p1) -- line: 49
	if not p1 or not p1.VirtualTransactionDiscounts then
		return nil, nil
	end

	local v24 = nil
	local v25 = nil

	for _, v in ipairs(p1.VirtualTransactionDiscounts) do
		if typeof(v) == "table" and typeof(v.PeriodIndex) == "number" then
			if v.PeriodIndex == 0 then
				v24 = v24 or v
			elseif v.PeriodIndex > 0 and (v25 == nil or v.PeriodIndex < v25.PeriodIndex) then
				v25 = v
			end
		end
	end

	return v24, v25
end
local function getPrivateServerDiscount(p2) -- line: 77
	-- upvalues: Array (copy)
	if not p2 or not p2.PrivateServerDiscounts then
		return nil
	end

	return Array.find(p2.PrivateServerDiscounts, function(p3) -- line: 82
		return typeof(p3) == "table" and (typeof(p3.PeriodIndex) == "number" and p3.PeriodIndex == 0)
	end)
end
local function RobloxSubscriptionFeatureList(t2: {[any]: any}) -- line: 87
	-- upvalues: RobloxSubscriptionStore (copy), SignalsReact (copy), getPeriodTypeDisplayLabel (copy), useLocalization (copy), getVirtualTransactionDiscounts (copy), Array (copy), FeatureRow (copy), v10 (copy), IconName (copy), FFlagRobloxPlusFAEFreeTrial (copy), React (copy), View (copy)
	local v30 = RobloxSubscriptionStore.get()
	local v31 = SignalsReact.useSignalState(v30.getRobloxSubscriptionProduct)
	local v32 = v31 and (not not v31.PeriodType and tostring(v31.PeriodType)) or ""
	local v33 = getPeriodTypeDisplayLabel(v32, true)
	local v34 = useLocalization({
		periodType = v33
	})
	local v35 = v31 and (v31.ProductTypeDetails and (v31.ProductTypeDetails.RobloxSubscriptionProductDetails and v31.ProductTypeDetails.RobloxSubscriptionProductDetails.FeatureConfig))
	local v36, v37 = getVirtualTransactionDiscounts(v35)
	local v38 = if not not v35 and v35.PrivateServerDiscounts then Array.find(v35.PrivateServerDiscounts, function(p4) -- line: 82
		return typeof(p4) == "table" and (typeof(p4.PeriodIndex) == "number" and p4.PeriodIndex == 0)
	end) else nil
	local v39 = useLocalization({
		robuxTransfersText = "Feature.RobloxSubscription.Label.BlackbirdTr",
		privateServerDiscountText = "Feature.RobloxSubscription.Label.BlackbirdPSDiscount",
		baseVirtualTransactionDiscountText = {
			"Feature.RobloxSubscription.Label.BlackbirdVTDiscountFirst",
			discountPercent = v36 and v36.DiscountPercent or 0
		},
		nextVirtualTransactionDiscountText = {
			"Feature.RobloxSubscription.Label.BlackbirdVTDiscountSecond",
			discountPercent = v37 and v37.DiscountPercent or 0,
			periodIndex = v37 and v37.PeriodIndex or 0,
			periodType = v34.periodType
		}
	})
	local t3 = {}

	local function addRow(p5, p6) -- line: 124
		-- upvalues: t3 (copy), FeatureRow (copy)
		table.insert(t3, FeatureRow({
			layoutOrder = #t3 + 1,
			iconName = p5,
			text = p6
		}))
	end

	if v36 and typeof(v36.DiscountPercent) == "number" then
		local v42 = if not v10 then IconName.TagSparkle else IconName.Tag
		local baseVirtualTransactionDiscountText = v39.baseVirtualTransactionDiscountText

		table.insert(t3, FeatureRow({
			layoutOrder = #t3 + 1,
			iconName = v42,
			text = baseVirtualTransactionDiscountText
		}))
	end

	if v37 and typeof(v37.DiscountPercent) == "number" and (not FFlagRobloxPlusFAEFreeTrial or not t2.noPurchaseMethodRequired) then
		local v44 = if not v10 then IconName.TagSparkleArrowUp else IconName.TagArrowUp
		local nextVirtualTransactionDiscountText = v39.nextVirtualTransactionDiscountText

		table.insert(t3, FeatureRow({
			layoutOrder = #t3 + 1,
			iconName = v44,
			text = nextVirtualTransactionDiscountText
		}))
	end

	if v38 and typeof(v38.DiscountPercent) == "number" then
		local Controller = IconName.Controller
		local privateServerDiscountText = v39.privateServerDiscountText

		table.insert(t3, FeatureRow({
			layoutOrder = #t3 + 1,
			iconName = Controller,
			text = privateServerDiscountText
		}))
	end

	if v35 and v35.IsRobuxTransferEnabled then
		local Robux = IconName.Robux
		local robuxTransfersText = v39.robuxTransfersText

		table.insert(t3, FeatureRow({
			layoutOrder = #t3 + 1,
			iconName = Robux,
			text = robuxTransfersText
		}))
	end

	return React.createElement(View, {
		tag = "col auto-y size-full-0 align-x-left gap-medium padding-top-large",
		LayoutOrder = t2.layoutOrder
	}, t3)
end

return RobloxSubscriptionFeatureList
