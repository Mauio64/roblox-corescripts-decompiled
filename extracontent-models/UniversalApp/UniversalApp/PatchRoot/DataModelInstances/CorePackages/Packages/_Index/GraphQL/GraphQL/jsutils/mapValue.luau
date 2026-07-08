require(script.Parent.ObjMap)

return {
	mapValue = function(p1, p2: ((...any) -> ...any)) -- line: 15
		local t1 = {}

		for k, v in pairs(p1) do
			t1[k] = p2(v, k)
		end

		return t1
	end
}
