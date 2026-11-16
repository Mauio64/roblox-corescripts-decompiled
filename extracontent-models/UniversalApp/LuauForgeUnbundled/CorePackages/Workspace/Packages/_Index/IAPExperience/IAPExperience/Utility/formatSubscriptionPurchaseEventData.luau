return function(p2, p3, p4, p5, p6, value, p7, p8, p9, p10, p11)
	local v5 = nil
	local v6 = nil

	for k, v7 in string.gmatch(value, "(%w+)-(%w+)") do
		v5 = string.upper(k)
		v6 = v7
	end

	return {
		purchase_flow_uuid = p2,
		purchase_flow_event_type = p3,
		view_name = p4,
		input_type = p5,
		subscription_provider_id = p6,
		subscription_product_type_prefix = v5,
		subscription_id = v6,
		localized_subscription_name = p7,
		localized_subscription_description = p8,
		subscription_period = p9,
		price_in_cents_usd = p10,
		display_price = p11
	}
end
