return function(object, value: string, value2: string, cstm: string?)
	assert(type(value) == "string", "Expected eventContext to be a string")
	assert(type(value2) == "string", "Expected buttonName to be a string")

	local v = { btn = value2 }

	if cstm ~= nil then
		assert(type(cstm) == "string", "Expected extraData to be a string")
		v.cstm = cstm
	end

	object:setRBXEventStream(value, "buttonClick", v)
end
