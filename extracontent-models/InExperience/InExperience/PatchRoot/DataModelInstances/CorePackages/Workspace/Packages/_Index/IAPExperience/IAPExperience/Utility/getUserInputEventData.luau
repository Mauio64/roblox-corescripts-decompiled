return function(s1: string, s2: string?, s3: string, s4: string, s5: string, s6: string?) -- line: 1
	if s2 then
		s3 = s2 .. s3
	end

	return {
		purchase_event_type = "UserInput",
		purchase_flow_uuid = s1,
		purchase_flow = s3,
		view_name = s4,
		input_type = s5,
		event_metadata = s6
	}
end
