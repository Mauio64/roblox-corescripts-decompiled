return function(s1: string, s2: string?, s3: string, s4: string, s5: string?) -- line: 1
	if s2 then
		s3 = s2 .. s3
	end

	return {
		purchase_event_type = "ViewShown",
		purchase_flow_uuid = s1,
		purchase_flow = s3,
		view_name = s4,
		event_metadata = s5
	}
end
