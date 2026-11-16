local IAPExperience = script:FindFirstAncestor("IAPExperience")
local parent = IAPExperience.Parent

local React = require(parent.React)

local Foundation = require(parent.Foundation)
local Accordion = Foundation.Accordion
local View = Foundation.View
local Divider = Foundation.Divider
local formatNumber = require(IAPExperience.Utility.formatNumber)

local LocalizationService = game:GetService("LocalizationService")
local Localization = require(parent.Localization)
local useLocalization = Localization.Hooks.useLocalization
local useRobuxText = require(IAPExperience.Generic.Hooks.useRobuxText)
local useDiscountAccordionConfig = require(IAPExperience.Generic.Hooks.useDiscountAccordionConfig)

local PricingTypes = require(IAPExperience.ProductPurchase.PricingTypes)

local DiscountType = PricingTypes.DiscountType
local DiscountRow = require(IAPExperience.Generic.DiscountRow)
local PriceLineItem = require(IAPExperience.Generic.PriceLineItem)

local robuxIcon = utf8.char(57346)

local function DiscountSummary(p)
	local itemPrice = p.itemPrice
	local robloxLocaleId = LocalizationService.RobloxLocaleId

	local discounts = itemPrice.discounts
	local amount = useRobuxText(itemPrice.basePriceInRobux)
	local amount2 = useRobuxText(itemPrice.priceInRobux)

	local v, v2 = React.useMemo(function()
		local total = 0
		local children = {}

		for i, discount in ipairs(discounts) do
			if not (discount.amountInRobux > 0) then
				continue
			end

			total += discount.amountInRobux
			children["DiscountRow_" .. tostring(i)] = React.createElement(DiscountRow, {
				discount = discount,
				label = discount.localizedDiscountAttribution,
				LayoutOrder = i + 1
			})
		end

		return total, children
	end, { discounts })

	local v3 = useLocalization({
		Subtotal = "IAPExperience.PurchasePrompt.Label.Subtotal",
		Total = "IAPExperience.PurchasePrompt.Label.Total",
		BlackbirdSummary = {
			"IAPExperience.PurchasePrompt.Label.BlackbirdSummary",
			robuxIcon = robuxIcon,
			savingsAmount = formatNumber(robloxLocaleId, v)
		}
	})

	local v4 = useDiscountAccordionConfig({
		itemPrice = itemPrice,
		hasSubscriptionDiscount = React.useMemo(function(): boolean
			for _, discount in ipairs(discounts) do
				if
					discount.type == DiscountType.BlackbirdSubscription
					or discount.type == DiscountType.RobloxPlusSubscription
				then
					return true
				end
			end

			return false
		end, { discounts }),
		blackbirdSummaryText = v3.BlackbirdSummary,
		savingsSummary = p.savingsSummary
	})

	local showAccordion = v4.showAccordion
	local accordionHeaderText = v4.accordionHeaderText
	local accordionLeadingIcon = v4.accordionLeadingIcon

	local v5 = React.useMemo(function()
		local result = {
			SubtotalRow = React.createElement(PriceLineItem, {
				label = v3.Subtotal,
				amount = amount,
				LayoutOrder = 1
			})
		}

		for k, v5 in pairs(v2) do
			result[k] = v5
		end

		return result
	end, { v3.Subtotal, amount, v2 })

	if showAccordion then
		return React.createElement(View, {
			tag = "size-full-0 auto-y padding-x-small stroke-default radius-medium"
		}, {
			AccordionContent = React.createElement(Accordion.Root, {
				width = UDim.new(1, 0),
				size = "Small"
			}, {
				SavingsItem = React.createElement(Accordion.Item, {
					leadingIcon = accordionLeadingIcon,
					text = accordionHeaderText,
					id = "discount",
					isExpanded = false,
					hasDivider = false,
					LayoutOrder = 1
				}, React.createElement(View, { tag = "col gap-xsmall size-full-0 auto-y" }, {
					BreakdownSection = React.createElement(
						View,
						{
							LayoutOrder = 1,
							tag = "col gap-xsmall size-full-0 auto-y padding-y-xsmall"
						},
						v5
					),
					BreakdownDivider = React.createElement(Divider, { LayoutOrder = 2 }),
					TotalRow = React.createElement(PriceLineItem, {
						label = v3.Total,
						amount = amount2,
						textStyle = "text-caption-medium",
						tag = "row size-full-0 auto-y align-y-center padding-x-xsmall padding-top-small",
						LayoutOrder = 3
					})
				}))
			})
		})
	end

	return nil
end

return DiscountSummary
