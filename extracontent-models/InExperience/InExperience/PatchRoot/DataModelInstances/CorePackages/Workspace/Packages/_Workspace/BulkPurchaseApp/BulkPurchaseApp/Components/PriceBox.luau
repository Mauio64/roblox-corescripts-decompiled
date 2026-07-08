local BulkPurchaseApp = script:FindFirstAncestor("BulkPurchaseApp")
local BulkPurchaseAppParent = BulkPurchaseApp.Parent
local React = require(BulkPurchaseAppParent.React)
local useLocalization = require(BulkPurchaseAppParent.Localization).Hooks.useLocalization
local Foundation = require(BulkPurchaseAppParent.Foundation)
local View = Foundation.View
local DiscountSummary = require(BulkPurchaseAppParent.IAPExperience).DiscountSummary
local useDiscountSummaryProps = require(BulkPurchaseApp.Hooks.useDiscountSummaryProps)
local PriceBoxLine = require(script.Parent.PriceBoxLine)
local PriceBoxLineVariantEnum = require(BulkPurchaseApp.Enums.PriceBoxLineVariantEnum)
local FFlagAddTimerToBulkPurchaseBuyButton = require(BulkPurchaseApp.Flags.FFlagAddTimerToBulkPurchaseBuyButton)
local FIntBulkPurchaseEnabledCountdownMS = require(BulkPurchaseApp.Flags.FIntBulkPurchaseEnabledCountdownMS)
local t1 = {
	heading = "CoreScripts.BulkPurchasePrompt.RequestPrompt.PriceBox.TotalCost",
	currentBalanceLine = "CoreScripts.BulkPurchasePrompt.RequestPrompt.PriceBox.CurrentBalance",
	projectedBalanceLine = "CoreScripts.BulkPurchasePrompt.RequestPrompt.PriceBox.NewBalance",
	missingRobuxLine = "CoreScripts.BulkPurchasePrompt.RequestPrompt.PriceBox.MissingRobux",
	confirmCTA = "CoreScripts.BulkPurchasePrompt.RequestPrompt.PriceBox.ConfirmCTA",
	buyRobuxCTA = "CoreScripts.BulkPurchasePrompt.RequestPrompt.PriceBox.BuyRobuxCTA"
}

require(BulkPurchaseApp.Store.Types)

local function PriceBox(t2: {[any]: any}) -- line: 41
	-- upvalues: useLocalization (copy), t1 (copy), useDiscountSummaryProps (copy), React (copy), View (copy), PriceBoxLine (copy), PriceBoxLineVariantEnum (copy), DiscountSummary (copy), Foundation (copy), FFlagAddTimerToBulkPurchaseBuyButton (copy), FIntBulkPurchaseEnabledCountdownMS (copy)
	local v16 = useLocalization(t1)
	local v17 = useDiscountSummaryProps(t2.discountInformation, t2.totalCost)

	return React.createElement(View, {
		tag = "col align-x-center gap-xxlarge size-full-0 auto-y padding-xxlarge radius-medium bg-surface-100"
	}, {
		LineItems = React.createElement(View, {
			LayoutOrder = 1,
			tag = "col gap-large size-full-0 auto-y"
		}, {
			BalanceLines = React.createElement(View, {
				LayoutOrder = 1,
				tag = "col gap-xsmall size-full-0 auto-y"
			}, {
				PriceBoxCurrentBalance = React.createElement(PriceBoxLine, {
					LayoutOrder = 1,
					text = v16.currentBalanceLine,
					amount = t2.currentBalance
				}),
				PriceBoxProjectedBalance = React.createElement(PriceBoxLine, {
					LayoutOrder = 2,
					text = if not t2.missingRobux then v16.projectedBalanceLine else v16.missingRobuxLine,
					amount = math.abs(t2.totalCost - t2.currentBalance),
					variant = if not t2.missingRobux then nil else PriceBoxLineVariantEnum.Danger
				})
			}),
			DiscountSummary = if not v17 then nil else React.createElement(View, {
				LayoutOrder = 2,
				tag = "size-full-0 auto-y"
			}, {
				Content = React.createElement(DiscountSummary, v17)
			}),
			PriceBoxHeader = React.createElement(PriceBoxLine, {
				LayoutOrder = 3,
				text = v16.heading,
				amount = t2.totalCost,
				originalPrice = if not t2.discountInformation then nil else t2.discountInformation.originalPrice,
				variant = PriceBoxLineVariantEnum.Highlight
			})
		}),
		PriceBoxConfirmButton = React.createElement(Foundation.Button, {
			LayoutOrder = 2,
			text = if not t2.missingRobux then v16.confirmCTA else v16.buyRobuxCTA,
			onActivated = t2.onAccept or function() -- line: 88
			end,
			variant = Foundation.Enums.ButtonVariant.Emphasis,
			size = Foundation.Enums.InputSize.Medium,
			width = UDim.new(1, 0),
			ref = t2.buttonRef,
			isDisabled = t2.isDisabled,
			inputDelay = if not FFlagAddTimerToBulkPurchaseBuyButton then nil else math.max(0, FIntBulkPurchaseEnabledCountdownMS) / 1000
		})
	})
end

return PriceBox
