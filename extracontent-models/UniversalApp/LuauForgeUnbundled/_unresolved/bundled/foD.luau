return function(object, value, value2, cstm)
	assert(type(value) == "string", "Expected eventContext to be a string")
	assert(type(value2) == "string", "Expected buttonName to be a string")

	local v5 = { btn = value2 }

	if cstm ~= nil then
		assert(type(cstm) == "string", "Expected extraData to be a string")
		v5.cstm = cstm
	end

	object:setRBXEventStream(value, "buttonClick", v5)
end
