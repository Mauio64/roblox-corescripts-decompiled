local ParentParent = script.Parent.Parent.Parent

require(ParentParent.LuauPolyfill)

return {
	printPathArray = function(p1) -- line: 15
		local t1 = {}

		for i = 1, #p1 do
			local v5 = p1[i]

			t1[i] = typeof(v5) == "number" and "[" .. tostring(v5) .. "]" or "." .. v5
		end

		return table.concat(t1, "")
	end
}
