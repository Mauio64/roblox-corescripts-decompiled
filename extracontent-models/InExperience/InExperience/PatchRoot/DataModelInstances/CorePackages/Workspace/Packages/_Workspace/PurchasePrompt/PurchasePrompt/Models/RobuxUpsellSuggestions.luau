local parent = script.Parent.Parent
local RobuxUpsell = require(parent.Models.RobuxUpsell)

local RobuxUpsellSuggestions = {}

function RobuxUpsellSuggestions.new(products)
	return { products = products }
end

function RobuxUpsellSuggestions.fromJson(p)
	local v = {}

	for k, product in pairs(p.products) do
		v[k] = RobuxUpsell.fromJson(product)
	end

	return RobuxUpsellSuggestions.new(v)
end

return RobuxUpsellSuggestions
