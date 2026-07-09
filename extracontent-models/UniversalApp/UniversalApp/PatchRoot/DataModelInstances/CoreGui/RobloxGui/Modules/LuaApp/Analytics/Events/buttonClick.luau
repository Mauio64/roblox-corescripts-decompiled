return function(p1, s1: string, s2: string, s3: string?) -- line: 5
	assert(type(s1) == "string", "Expected eventContext to be a string")
	assert(type(s2) == "string", "Expected buttonName to be a string")

	local t1 = {
		btn = s2
	}

	if s3 ~= nil then
		assert(type(s3) == "string", "Expected extraData to be a string")
		t1.cstm = s3
	end

	p1:setRBXEventStream(s1, "buttonClick", t1)
end
