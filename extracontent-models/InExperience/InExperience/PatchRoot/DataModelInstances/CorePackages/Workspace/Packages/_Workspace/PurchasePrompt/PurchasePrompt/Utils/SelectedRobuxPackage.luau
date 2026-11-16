local function getSelectedRobuxPackage(p) -- 6 equivalent calls inferred from this helper
	if p.robuxUpsellSuggestions and p.robuxUpsellSuggestions.products and p.robuxUpsellSuggestions.selection then
		return p.robuxUpsellSuggestions.products[p.robuxUpsellSuggestions.selection]
	end

	return nil
end

local SelectedRobuxPackage = {}

function SelectedRobuxPackage.getRobuxProductId(p)
	local selectedRobuxPackage = getSelectedRobuxPackage(p) -- inferred equivalent call

	if selectedRobuxPackage then
		return selectedRobuxPackage.providerId
	end

	return nil
end

function SelectedRobuxPackage.getProductId(p)
	local selectedRobuxPackage = getSelectedRobuxPackage(p) -- inferred equivalent call

	if selectedRobuxPackage then
		return selectedRobuxPackage.productId
	end

	return nil
end

function SelectedRobuxPackage.getProductName(p)
	local selectedRobuxPackage = getSelectedRobuxPackage(p) -- inferred equivalent call

	if selectedRobuxPackage then
		return selectedRobuxPackage.productName
	end

	return nil
end

function SelectedRobuxPackage.getRobuxPurchaseAmount(p)
	local selectedRobuxPackage = getSelectedRobuxPackage(p) -- inferred equivalent call

	if selectedRobuxPackage then
		return selectedRobuxPackage.robuxAmount
	end

	return nil
end

function SelectedRobuxPackage.getRobuxAmountBeforeBonus(p)
	local selectedRobuxPackage = getSelectedRobuxPackage(p) -- inferred equivalent call

	if selectedRobuxPackage then
		return selectedRobuxPackage.robuxAmountBeforeBonus
	end

	return nil
end

function SelectedRobuxPackage.getPrice(p)
	local selectedRobuxPackage = getSelectedRobuxPackage(p) -- inferred equivalent call

	if selectedRobuxPackage then
		return selectedRobuxPackage.price
	end

	return nil
end

return SelectedRobuxPackage
