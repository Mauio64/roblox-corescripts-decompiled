return function(p2, p3, p4, p5, p6)
	if p3 then
		p4 = p3 .. p4
	end

	return {
		purchase_flow_uuid = p2,
		purchase_flow = p4,
		view_name = p5,
		purchase_event_type = "ViewShown",
		event_metadata = p6
	}
end
