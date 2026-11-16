return function(object, value, value2, cstm, value3)
	assert(type(value) == "string", "Expected eventContext to be a string")
	assert(type(value2) == "string", "Expected buttonName to be a string")
	assert(type(value3) == "string", "Expected ctype to be a string")

	local v5 = { btn = value2, ctype = value3 }

	if cstm ~= nil then
		assert(type(cstm) == "string", "Expected extraData to be a string")
		v5.cstm = cstm
	end

	object:setRBXEventStream(value, "buttonClick", v5)
end
