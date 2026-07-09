local IAPExperience = script:FindFirstAncestor("IAPExperience")
local IAPExperienceParent = IAPExperience.Parent
local React = require(IAPExperienceParent.React)
local SharedFlags = require(IAPExperienceParent.SharedFlags)
local Foundation = require(IAPExperienceParent.Foundation)
local Accordion = Foundation.Accordion
local View = Foundation.View
local Divider = Foundation.Divider
local IconName = Foundation.Enums.IconName
local formatNumber = require(IAPExperience.Utility.formatNumber)
local LocalizationService = game:GetService("LocalizationService")
local useLocalization = require(IAPExperienceParent.Localization).Hooks.useLocalization
local useRobuxText = require(IAPExperience.Generic.Hooks.useRobuxText)
local useDiscountAccordionConfig = require(IAPExperience.Generic.Hooks.useDiscountAccordionConfig)
local DiscountType = require(IAPExperience.ProductPurchase.PricingTypes).DiscountType
local DiscountRow = require(IAPExperience.Generic.DiscountRow)
local PriceLineItem = require(IAPExperience.Generic.PriceLineItem)
local FFlagPurchasePromptFetchCartPricing = SharedFlags.FFlagPurchasePromptFetchCartPricing
local v19 = utf8.char(57346)

local function DiscountSummary(t1: {[any]: any}) -- line: 37
	-- upvalues: LocalizationService (copy), useRobuxText (copy), React (copy), DiscountRow (copy), FFlagPurchasePromptFetchCartPricing (copy), useLocalization (copy), v19 (copy), formatNumber (copy), DiscountType (copy), useDiscountAccordionConfig (copy), PriceLineItem (copy), View (copy), Accordion (copy), IconName (copy), Divider (copy)
	local itemPrice = t1.itemPrice
	local RobloxLocaleId = LocalizationService.RobloxLocaleId
	local discounts = itemPrice.discounts
	local v25 = useRobuxText(itemPrice.basePriceInRobux)
	local v26 = useRobuxText(itemPrice.priceInRobux)
	local v27, v28 = React.useMemo(function() -- line: 45
		-- upvalues: discounts (copy), React (copy), DiscountRow (copy), FFlagPurchasePromptFetchCartPricing (copy)
		local n1 = 0
		local t2 = {}

		for i, v in ipairs(discounts) do
			if v.amountInRobux > 0 then
				n1 += v.amountInRobux
				t2["DiscountRow_" .. tostring(i)] = React.createElement(DiscountRow, {
					discount = v,
					label = if not FFlagPurchasePromptFetchCartPricing then nil else v.localizedDiscountAttribution,
					LayoutOrder = i + 1
				})
			end
		end

		return n1, t2
	end, { discounts })
	local v29 = useLocalization({
		Subtotal = "IAPExperience.PurchasePrompt.Label.Subtotal",
		Total = "IAPExperience.PurchasePrompt.Label.Total",
		BlackbirdSummary = {
			"IAPExperience.PurchasePrompt.Label.BlackbirdSummary",
			robuxIcon = v19,
			savingsAmount = formatNumber(RobloxLocaleId, v27)
		}
	})
	local v30 = React.useMemo(function() -- line: 72
		-- upvalues: discounts (copy), DiscountType (copy)
		for _, v in ipairs(discounts) do
			if v.type == DiscountType.BlackbirdSubscription or v.type == DiscountType.RobloxPlusSubscription then
				return true
			end
		end

		return false
	end, { discounts })
	local showAccordion = nil
	local accordionHeaderText = nil
	local accordionLeadingIcon = nil

	if FFlagPurchasePromptFetchCartPricing then
		local v34 = useDiscountAccordionConfig({
			itemPrice = itemPrice,
			hasSubscriptionDiscount = v30,
			blackbirdSummaryText = v29.BlackbirdSummary,
			savingsSummary = t1.savingsSummary
		})

		showAccordion = v34.showAccordion
		accordionHeaderText = v34.accordionHeaderText
		accordionLeadingIcon = v34.accordionLeadingIcon
	end

	local v35 = React.useMemo(function() -- line: 98
		-- upvalues: React (copy), PriceLineItem (copy), v29 (copy), v25 (copy), v28 (copy)
		local t3 = {
			SubtotalRow = React.createElement(PriceLineItem, {
				LayoutOrder = 1,
				label = v29.Subtotal,
				amount = v25
			})
		}

		for k, v in pairs(v28) do
			t3[k] = v
		end

		return t3
	end, {
		v29.Subtotal,
		v25,
		v28
	})

	if FFlagPurchasePromptFetchCartPricing and not showAccordion then
		return nil
	end

	if not FFlagPurchasePromptFetchCartPricing and (not v30 or itemPrice.basePriceInRobux == itemPrice.priceInRobux) then
		return nil
	end

	return React.createElement(View, {
		tag = {
			["size-full-0 auto-y padding-x-small stroke-default radius-medium"] = FFlagPurchasePromptFetchCartPricing,
			["size-full-0 auto-y stroke-default radius-medium padding-x-small"] = not FFlagPurchasePromptFetchCartPricing
		}
	}, {
		AccordionContent = React.createElement(Accordion.Root, {
			size = "Small",
			width = UDim.new(1, 0)
		}, {
			SavingsItem = React.createElement(Accordion.Item, {
				id = "discount",
				isExpanded = false,
				hasDivider = false,
				LayoutOrder = 1,
				leadingIcon = if not FFlagPurchasePromptFetchCartPricing then IconName.RobloxPlus else accordionLeadingIcon,
				text = if not FFlagPurchasePromptFetchCartPricing then v29.BlackbirdSummary else accordionHeaderText
			}, React.createElement(View, {
				tag = {
					["col gap-xsmall size-full-0 auto-y"] = FFlagPurchasePromptFetchCartPricing,
					["col size-full-0 auto-y gap-xsmall"] = not FFlagPurchasePromptFetchCartPricing
				}
			}, {
				BreakdownSection = React.createElement(View, {
					LayoutOrder = 1,
					tag = {
						["col gap-xsmall size-full-0 auto-y padding-y-xsmall"] = FFlagPurchasePromptFetchCartPricing,
						["col size-full-0 auto-y gap-xsmall padding-y-xsmall"] = not FFlagPurchasePromptFetchCartPricing
					}
				}, v35),
				BreakdownDivider = React.createElement(Divider, {
					LayoutOrder = 2
				}),
				TotalRow = React.createElement(PriceLineItem, {
					textStyle = "text-caption-medium",
					tag = "row size-full-0 auto-y align-y-center padding-x-xsmall padding-top-small",
					LayoutOrder = 3,
					label = v29.Total,
					amount = v26
				})
			}))
		})
	})
end

return DiscountSummary
