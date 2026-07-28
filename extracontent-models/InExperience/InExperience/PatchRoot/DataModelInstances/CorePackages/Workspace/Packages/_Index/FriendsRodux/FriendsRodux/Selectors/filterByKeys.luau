return function(t1: {[any]: any}, t2: {[any]: any}) -- line: 1
	local t3 = {}

	for _, v in pairs(t1) do
		local str = tostring(v)
		local v7 = t2[str]

		if v7 then
			t3[str] = v7
		end
	end

	return t3
end
