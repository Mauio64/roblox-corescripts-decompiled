return function(p2, p3, p4, p5, p6, p7)
	if p3 then
		p4 = p3 .. p4
	end

	return {
		purchase_flow_uuid = p2,
		purchase_flow = p4,
		view_name = p5,
		purchase_event_type = "UserInput",
		input_type = p6,
		event_metadata = p7
	}
end
