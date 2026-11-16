local function getSelectedRobuxPackage(p2)
	if
		p2.robuxUpsellSuggestions
		and p2.robuxUpsellSuggestions.products
		and p2.robuxUpsellSuggestions.selection
	then
		return p2.robuxUpsellSuggestions.products[p2.robuxUpsellSuggestions.selection]
	end

	return nil
end

return {
	getRobuxProductId = function(p2)
		local v5

		if
			p2.robuxUpsellSuggestions
			and p2.robuxUpsellSuggestions.products
			and p2.robuxUpsellSuggestions.selection
		then
			v5 = p2.robuxUpsellSuggestions.products[p2.robuxUpsellSuggestions.selection]
		end

		if v5 then
			return v5.providerId
		end

		return nil
	end,
	getProductId = function(p2)
		local v5

		if
			p2.robuxUpsellSuggestions
			and p2.robuxUpsellSuggestions.products
			and p2.robuxUpsellSuggestions.selection
		then
			v5 = p2.robuxUpsellSuggestions.products[p2.robuxUpsellSuggestions.selection]
		end

		if v5 then
			return v5.productId
		end

		return nil
	end,
	getProductName = function(p2)
		local v5

		if
			p2.robuxUpsellSuggestions
			and p2.robuxUpsellSuggestions.products
			and p2.robuxUpsellSuggestions.selection
		then
			v5 = p2.robuxUpsellSuggestions.products[p2.robuxUpsellSuggestions.selection]
		end

		if v5 then
			return v5.productName
		end

		return nil
	end,
	getRobuxPurchaseAmount = function(p2)
		local v5

		if
			p2.robuxUpsellSuggestions
			and p2.robuxUpsellSuggestions.products
			and p2.robuxUpsellSuggestions.selection
		then
			v5 = p2.robuxUpsellSuggestions.products[p2.robuxUpsellSuggestions.selection]
		end

		if v5 then
			return v5.robuxAmount
		end

		return nil
	end,
	getRobuxAmountBeforeBonus = function(p2)
		local v5

		if
			p2.robuxUpsellSuggestions
			and p2.robuxUpsellSuggestions.products
			and p2.robuxUpsellSuggestions.selection
		then
			v5 = p2.robuxUpsellSuggestions.products[p2.robuxUpsellSuggestions.selection]
		end

		if v5 then
			return v5.robuxAmountBeforeBonus
		end

		return nil
	end,
	getPrice = function(p2)
		local v5

		if
			p2.robuxUpsellSuggestions
			and p2.robuxUpsellSuggestions.products
			and p2.robuxUpsellSuggestions.selection
		then
			v5 = p2.robuxUpsellSuggestions.products[p2.robuxUpsellSuggestions.selection]
		end

		if v5 then
			return v5.price
		end

		return nil
	end
}
