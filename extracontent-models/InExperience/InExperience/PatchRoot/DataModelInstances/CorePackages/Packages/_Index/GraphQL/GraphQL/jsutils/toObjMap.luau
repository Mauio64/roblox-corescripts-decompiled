require(script.Parent.ObjMap)

return {
	toObjMap = function(p1) -- line: 12
		local t1 = {}

		for k, v in pairs(p1) do
			t1[k] = v
		end

		return t1
	end
}
