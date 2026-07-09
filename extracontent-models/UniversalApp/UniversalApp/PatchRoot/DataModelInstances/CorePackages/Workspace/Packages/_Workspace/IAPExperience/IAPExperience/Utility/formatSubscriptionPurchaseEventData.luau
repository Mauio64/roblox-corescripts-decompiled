return function(s1: string, s2: string, s3: string, s4: string?, s5: string, s6: string, s7: string, s8: string, s9: string, n1: number, s10: string) -- line: 1
	local v12 = nil
	local v13 = nil

	for match, v15 in string.gmatch(s6, "(%w+)-(%w+)") do
		v13 = string.upper(match)
		v12 = v15
	end

	return {
		purchase_flow_uuid = s1,
		purchase_flow_event_type = s2,
		view_name = s3,
		input_type = s4,
		subscription_provider_id = s5,
		subscription_product_type_prefix = v13,
		subscription_id = v12,
		localized_subscription_name = s7,
		localized_subscription_description = s8,
		subscription_period = s9,
		price_in_cents_usd = n1,
		display_price = s10
	}
end
