return function(purchase_flow_uuid: string, p: string?, purchase_flow: string, view_name: string, event_metadata: string?)
	if p then
		purchase_flow = p .. purchase_flow
	end

	return {
		purchase_flow_uuid = purchase_flow_uuid,
		purchase_flow = purchase_flow,
		view_name = view_name,
		purchase_event_type = "ViewShown",
		event_metadata = event_metadata
	}
end
