return function(purchase_flow_uuid: string, purchase_flow_event_type: string, view_name: string, input_type: string?, subscription_provider_id: string, value: string, localized_subscription_name: string, localized_subscription_description: string, subscription_period: string, price_in_cents_usd: number, display_price: string)
	local subscription_product_type_prefix = nil
	local subscription_id = nil

	for k, v in string.gmatch(value, "(%w+)-(%w+)") do
		subscription_product_type_prefix = string.upper(k)
		subscription_id = v
	end

	return {
		purchase_flow_uuid = purchase_flow_uuid,
		purchase_flow_event_type = purchase_flow_event_type,
		view_name = view_name,
		input_type = input_type,
		subscription_provider_id = subscription_provider_id,
		subscription_product_type_prefix = subscription_product_type_prefix,
		subscription_id = subscription_id,
		localized_subscription_name = localized_subscription_name,
		localized_subscription_description = localized_subscription_description,
		subscription_period = subscription_period,
		price_in_cents_usd = price_in_cents_usd,
		display_price = display_price
	}
end
