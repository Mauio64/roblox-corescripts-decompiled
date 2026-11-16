local React = require("@game/CorePackages/Workspace/Packages/_Workspace/IAPExperience/React")

local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/IAPExperience/Foundation")
local accordion = Foundation.Accordion
local view = Foundation.View
local divider = Foundation.Divider
local formatNumber = require("@game/CorePackages/Workspace/Packages/_Index/IAPExperience/IAPExperience/Utility/formatNumber")

local LocalizationService = game:GetService("LocalizationService")
local useLocalization = require("@game/CorePackages/Workspace/Packages/_Workspace/IAPExperience/Localization").Hooks.useLocalization
local useRobuxText = require("@game/CorePackages/Workspace/Packages/_Index/IAPExperience/IAPExperience/Generic/Hooks/useRobuxText")
local useDiscountAccordionConfig = require("@game/CorePackages/Workspace/Packages/_Index/IAPExperience/IAPExperience/Generic/Hooks/useDiscountAccordionConfig")

local discountType = require("@game/CorePackages/Workspace/Packages/_Index/IAPExperience/IAPExperience/ProductPurchase/PricingTypes").DiscountType
local DiscountRow = require("@game/CorePackages/Workspace/Packages/_Index/IAPExperience/IAPExperience/Generic/DiscountRow")
local PriceLineItem = require("@game/CorePackages/Workspace/Packages/_Index/IAPExperience/IAPExperience/Generic/PriceLineItem")

local v5 = utf8.char(57346)

local function DiscountSummary(p2)
	local itemPrice = p2.itemPrice
	local robloxLocaleId = LocalizationService.RobloxLocaleId

	local discounts = itemPrice.discounts
	local v6 = useRobuxText(itemPrice.basePriceInRobux)
	local v7 = useRobuxText(itemPrice.priceInRobux)

	local v8, v9 = React.useMemo(function()
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

	local v10 = useLocalization({
		Subtotal = "IAPExperience.PurchasePrompt.Label.Subtotal",
		Total = "IAPExperience.PurchasePrompt.Label.Total",
		BlackbirdSummary = {
			"IAPExperience.PurchasePrompt.Label.BlackbirdSummary",
			robuxIcon = v5,
			savingsAmount = formatNumber(robloxLocaleId, v8)
		}
	})

	local v12 = useDiscountAccordionConfig({
		itemPrice = itemPrice,
		hasSubscriptionDiscount = React.useMemo(function(): boolean
			for i, discount in ipairs(discounts) do
				if
					discount.type == discountType.BlackbirdSubscription
					or discount.type == discountType.RobloxPlusSubscription
				then
					return true
				end
			end

			return false
		end, { discounts }),
		blackbirdSummaryText = v10.BlackbirdSummary,
		savingsSummary = p2.savingsSummary
	})

	local showAccordion = v12.showAccordion
	local accordionHeaderText = v12.accordionHeaderText
	local accordionLeadingIcon = v12.accordionLeadingIcon

	local v13 = React.useMemo(function()
		local result = {
			SubtotalRow = React.createElement(PriceLineItem, {
				label = v10.Subtotal,
				amount = v6,
				LayoutOrder = 1
			})
		}

		for k, v14 in pairs(v9) do
			result[k] = v14
		end

		return result
	end, { v10.Subtotal, v6, v9 })

	if showAccordion then
		return React.createElement(
			view,
			{ tag = "size-full-0 auto-y padding-x-small stroke-default radius-medium" },
			{
				AccordionContent = React.createElement(
					accordion.Root,
					{ width = UDim.new(1, 0), size = "Small" },
					{
						SavingsItem = React.createElement(accordion.Item, {
							leadingIcon = accordionLeadingIcon,
							text = accordionHeaderText,
							id = "discount",
							isExpanded = false,
							hasDivider = false,
							LayoutOrder = 1
						}, React.createElement(view, {
							tag = "col gap-xsmall size-full-0 auto-y"
						}, {
							BreakdownSection = React.createElement(
								view,
								{
									LayoutOrder = 1,
									tag = "col gap-xsmall size-full-0 auto-y padding-y-xsmall"
								},
								v13
							),
							BreakdownDivider = React.createElement(divider, {
								LayoutOrder = 2
							}),
							TotalRow = React.createElement(PriceLineItem, {
								label = v10.Total,
								amount = v7,
								textStyle = "text-caption-medium",
								tag = "row size-full-0 auto-y align-y-center padding-x-xsmall padding-top-small",
								LayoutOrder = 3
							})
						}))
					}
				)
			}
		)
	end

	return nil
end

return DiscountSummary
