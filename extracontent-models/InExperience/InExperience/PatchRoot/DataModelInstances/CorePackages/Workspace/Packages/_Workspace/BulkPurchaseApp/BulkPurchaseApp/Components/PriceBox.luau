local BulkPurchaseApp = script:FindFirstAncestor("BulkPurchaseApp")
local parent = BulkPurchaseApp.Parent
local React = require(parent.React)
local Localization = require(parent.Localization)
local useLocalization = Localization.Hooks.useLocalization

local Foundation = require(parent.Foundation)
local View = Foundation.View
local useTokens = Foundation.Hooks.useTokens

local IAPExperience = require(parent.IAPExperience)
local DiscountSummary = IAPExperience.DiscountSummary

local RobloxSubscriptionPurchaseApp = require(parent.RobloxSubscriptionPurchaseApp)
local BlackbirdUpsellBanner = RobloxSubscriptionPurchaseApp.Components.BlackbirdUpsellBanner
local AvatarExperienceCommon = require(parent.AvatarExperienceCommon)
local OfferExpiryBadge = AvatarExperienceCommon.Components.OfferExpiryBadge
local useDiscountSummaryProps = require(BulkPurchaseApp.Hooks.useDiscountSummaryProps)

local PriceBoxLine = require(script.Parent.PriceBoxLine)
local PriceBoxLineVariantEnum = require(BulkPurchaseApp.Enums.PriceBoxLineVariantEnum)
local FFlagAddTimerToBulkPurchaseBuyButton = require(BulkPurchaseApp.Flags.FFlagAddTimerToBulkPurchaseBuyButton)
local FIntBulkPurchaseEnabledCountdownMS = require(BulkPurchaseApp.Flags.FIntBulkPurchaseEnabledCountdownMS)
local FFlagAXAddPlusUpsellToBulkPurchase = require(BulkPurchaseApp.Flags.FFlagAXAddPlusUpsellToBulkPurchase)
local FFlagAXAddOffersToBulkPurchase = require(BulkPurchaseApp.Flags.FFlagAXAddOffersToBulkPurchase)
local FFlagAXUpdateBulkPurchaseOfferExpiryBadge = require(BulkPurchaseApp.Flags.FFlagAXUpdateBulkPurchaseOfferExpiryBadge)
local FFlagBulkPurchaseTestPurchaseHint = require(BulkPurchaseApp.Flags.FFlagBulkPurchaseTestPurchaseHint)

local v = {
	heading = "CoreScripts.BulkPurchasePrompt.RequestPrompt.PriceBox.TotalCost",
	currentBalanceLine = "CoreScripts.BulkPurchasePrompt.RequestPrompt.PriceBox.CurrentBalance",
	projectedBalanceLine = "CoreScripts.BulkPurchasePrompt.RequestPrompt.PriceBox.NewBalance",
	missingRobuxLine = "CoreScripts.BulkPurchasePrompt.RequestPrompt.PriceBox.MissingRobux",
	confirmCTA = "CoreScripts.BulkPurchasePrompt.RequestPrompt.PriceBox.ConfirmCTA",
	buyRobuxCTA = "CoreScripts.BulkPurchasePrompt.RequestPrompt.PriceBox.BuyRobuxCTA",
	testPurchaseDisclaimer = "IAPExperience.PurchasePrompt.Text.TestPurchase"
}

require(BulkPurchaseApp.Store.Types)

local function PriceBox(props)
	local v2 = useLocalization(v)

	local discountInformation = props.discountInformation
	local totalCost = props.totalCost
	local v3

	if FFlagAXAddOffersToBulkPurchase and props.offerData then
		v3 = props.offerData.savingsSummary
	end

	local v4 = useDiscountSummaryProps(discountInformation, totalCost, v3)
	local v5

	if FFlagAXAddOffersToBulkPurchase then
		local v6 = useTokens()
		v5 = React.useMemo(function()
			local children = {}
			local offersAvailable

			if props.offerData then
				offersAvailable = props.offerData.offersAvailable
			end

			local toggleOfferSelected = props.toggleOfferSelected

			if not (offersAvailable and toggleOfferSelected) then
				return children
			end

			for k, v7 in offersAvailable do
				local v8 = "Offer_" .. k
				local createElement = React.createElement

				local v9 = {
					Text = "",
					AutomaticSize = Enum.AutomaticSize.XY,
					BackgroundTransparency = 1,
					BorderSizePixel = 0,
					Selectable = false,
					LayoutOrder = 0,
					[React.Event.Activated] = function()
						toggleOfferSelected(k)
					end
				}

				local createElement2 = React.createElement
				local view = Foundation.View
				local v10 = {
					tag = "row gap-medium auto-xy align-y-center",
					Position = UDim2.fromOffset(v6.Stroke.Standard, 0)
				}
				local v11 = {
					Checkbox = React.createElement(Foundation.Checkbox, {
						label = not FFlagAXUpdateBulkPurchaseOfferExpiryBadge and "" or v7.localizedDescription,
						isChecked = v7.selected,
						onActivated = function()
							toggleOfferSelected(k)
						end,
						size = Foundation.Enums.InputSize.Small,
						LayoutOrder = 1
					}),
					Label = 0,
					ExpiryBadge = 0
				}
				local label

				if not FFlagAXUpdateBulkPurchaseOfferExpiryBadge then
					label = React.createElement(Foundation.Text, {
						Text = "<b>" .. v7.localizedDescription .. "</b>",
						RichText = true,
						tag = "text-body-small content-default auto-xy",
						LayoutOrder = 2
					})
				end

				v11.Label = label
				local expiryBadge

				if FFlagAXUpdateBulkPurchaseOfferExpiryBadge and v7.expirationTimeUtc then
					expiryBadge = React.createElement(OfferExpiryBadge, {
						layoutOrder = 2,
						expirationTimeInUTC = v7.expirationTimeUtc
					})
				end

				v11.ExpiryBadge = expiryBadge
				children[v8] = createElement("TextButton", v9, {
					Content = createElement2(view, v10, v11)
				})
			end

			return children
		end, { props.offerData, props.toggleOfferSelected })
	end

	local createElement = React.createElement

	local createElement2 = React.createElement

	local createElement3 = React.createElement

	local v6 = {
		PriceBoxCurrentBalance = React.createElement(PriceBoxLine, {
			text = v2.currentBalanceLine,
			amount = props.currentBalance,
			LayoutOrder = 1
		}),
		PriceBoxProjectedBalance = 0
	}

	local createElement4 = React.createElement
	local text

	if props.missingRobux then
		text = v2.missingRobuxLine
	else
		text = v2.projectedBalanceLine
	end

	local v7 = {
		text = text,
		amount = math.abs(props.totalCost - props.currentBalance),
		variant = 0,
		LayoutOrder = 2
	}
	local variant

	if props.missingRobux then
		variant = PriceBoxLineVariantEnum.Danger
	end

	v7.variant = variant
	v6.PriceBoxProjectedBalance = createElement4(PriceBoxLine, v7)
	local children2 = {
		BalanceLines = createElement3(View, {
			LayoutOrder = 1,
			tag = "col gap-xsmall size-full-0 auto-y"
		}, v6),
		OfferCheckboxes = 0,
		DiscountSummary = 0,
		PriceBoxHeader = 0
	}
	local offerCheckboxes

	if FFlagAXAddOffersToBulkPurchase and next(v5) ~= nil then
		offerCheckboxes = React.createElement(
			Foundation.View,
			{ tag = "col gap-medium size-full-0 auto-y padding-top-medium", LayoutOrder = 2 },
			v5
		)
	end

	children2.OfferCheckboxes = offerCheckboxes
	local discountSummary

	if v4 then
		discountSummary = React.createElement(View, {
			LayoutOrder = FFlagAXAddOffersToBulkPurchase and 3 or 2,
			tag = "size-full-0 auto-y"
		}, {
			Content = React.createElement(DiscountSummary, v4)
		})
	end

	children2.DiscountSummary = discountSummary

	local createElement5 = React.createElement
	local v8 = {
		text = v2.heading,
		amount = props.totalCost,
		originalPrice = 0,
		variant = 0,
		LayoutOrder = 0
	}
	local originalPrice

	if props.discountInformation then
		originalPrice = props.discountInformation.originalPrice
	end

	v8.originalPrice = originalPrice
	v8.variant = PriceBoxLineVariantEnum.Highlight
	v8.LayoutOrder = FFlagAXAddOffersToBulkPurchase and 4 or 3
	children2.PriceBoxHeader = createElement5(PriceBoxLine, v8)
	local children = {
		LineItems = createElement2(View, {
			LayoutOrder = 1,
			tag = "col gap-large size-full-0 auto-y"
		}, children2),
		PriceBoxConfirmButton = 0,
		BlackbirdUpsellBanner = 0,
		TestPurchaseDisclaimer = 0
	}

	local createElement6 = React.createElement
	local button = Foundation.Button
	local text2

	if props.missingRobux then
		text2 = v2.buyRobuxCTA
	else
		text2 = v2.confirmCTA
	end

	local v9 = {
		text = text2,
		onActivated = props.onAccept or function() end,
		variant = Foundation.Enums.ButtonVariant.Emphasis,
		size = Foundation.Enums.InputSize.Medium,
		width = UDim.new(1, 0),
		ref = props.buttonRef,
		isDisabled = props.isDisabled,
		LayoutOrder = 2,
		inputDelay = 0
	}
	local inputDelay

	if FFlagAddTimerToBulkPurchaseBuyButton then
		inputDelay = math.max(0, FIntBulkPurchaseEnabledCountdownMS) / 1000
	end

	v9.inputDelay = inputDelay
	children.PriceBoxConfirmButton = createElement6(button, v9)
	local blackbirdUpsellBanner

	if
		FFlagAXAddPlusUpsellToBulkPurchase
		and props.shouldShowBlackbirdUpsellBanner
		and props.blackbirdUpsellBannerProductInfo
		and props.onBlackbirdUpsellActivated
	then
		blackbirdUpsellBanner = React.createElement(BlackbirdUpsellBanner, {
			productInfo = props.blackbirdUpsellBannerProductInfo,
			onActivated = props.onBlackbirdUpsellActivated,
			LayoutOrder = 3
		})
	end

	children.BlackbirdUpsellBanner = blackbirdUpsellBanner
	local testPurchaseDisclaimer

	if FFlagBulkPurchaseTestPurchaseHint and props.isTestPurchase then
		testPurchaseDisclaimer = React.createElement(Foundation.Text, {
			LayoutOrder = 4,
			Text = v2.testPurchaseDisclaimer,
			tag = "wrap size-full-0 auto-y text-caption-small text-wrap text-align-x-center"
		})
	end

	children.TestPurchaseDisclaimer = testPurchaseDisclaimer
	return createElement(
		View,
		{
			tag = "col align-x-center gap-xxlarge size-full-0 auto-y padding-xxlarge radius-medium bg-surface-100"
		},
		children
	)
end

return PriceBox
