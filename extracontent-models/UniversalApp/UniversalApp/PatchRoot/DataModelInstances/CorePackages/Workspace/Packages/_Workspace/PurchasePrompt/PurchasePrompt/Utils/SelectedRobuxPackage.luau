local function getSelectedRobuxPackage(p1) -- line: 3
	if not p1.robuxUpsellSuggestions or (not p1.robuxUpsellSuggestions.products or not p1.robuxUpsellSuggestions.selection) then
		return nil
	end

	return p1.robuxUpsellSuggestions.products[p1.robuxUpsellSuggestions.selection]
end

return {
	getRobuxProductId = function(p2) -- line: 14
		local v4 = if not not p2.robuxUpsellSuggestions and (not not p2.robuxUpsellSuggestions.products and p2.robuxUpsellSuggestions.selection) then p2.robuxUpsellSuggestions.products[p2.robuxUpsellSuggestions.selection] else nil

		if not v4 then
			return nil
		end

		return v4.providerId
	end,
	getProductId = function(p3) -- line: 23
		local v6 = if not not p3.robuxUpsellSuggestions and (not not p3.robuxUpsellSuggestions.products and p3.robuxUpsellSuggestions.selection) then p3.robuxUpsellSuggestions.products[p3.robuxUpsellSuggestions.selection] else nil

		if not v6 then
			return nil
		end

		return v6.productId
	end,
	getProductName = function(p4) -- line: 32
		local v8 = if not not p4.robuxUpsellSuggestions and (not not p4.robuxUpsellSuggestions.products and p4.robuxUpsellSuggestions.selection) then p4.robuxUpsellSuggestions.products[p4.robuxUpsellSuggestions.selection] else nil

		if not v8 then
			return nil
		end

		return v8.productName
	end,
	getRobuxPurchaseAmount = function(p5) -- line: 41
		local v10 = if not not p5.robuxUpsellSuggestions and (not not p5.robuxUpsellSuggestions.products and p5.robuxUpsellSuggestions.selection) then p5.robuxUpsellSuggestions.products[p5.robuxUpsellSuggestions.selection] else nil

		if not v10 then
			return nil
		end

		return v10.robuxAmount
	end,
	getRobuxAmountBeforeBonus = function(p6) -- line: 59
		local v14 = if not not p6.robuxUpsellSuggestions and (not not p6.robuxUpsellSuggestions.products and p6.robuxUpsellSuggestions.selection) then p6.robuxUpsellSuggestions.products[p6.robuxUpsellSuggestions.selection] else nil

		if not v14 then
			return nil
		end

		return v14.robuxAmountBeforeBonus
	end,
	getPrice = function(p7) -- line: 50
		local v12 = if not not p7.robuxUpsellSuggestions and (not not p7.robuxUpsellSuggestions.products and p7.robuxUpsellSuggestions.selection) then p7.robuxUpsellSuggestions.products[p7.robuxUpsellSuggestions.selection] else nil

		if not v12 then
			return nil
		end

		return v12.price
	end
}
