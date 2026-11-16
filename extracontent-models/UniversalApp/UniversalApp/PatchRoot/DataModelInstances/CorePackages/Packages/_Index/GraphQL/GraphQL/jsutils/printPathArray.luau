local parent = script.Parent.Parent.Parent
require(parent.LuauPolyfill)

return {
	printPathArray = function(list)
		local v = {}

		for i = 1, #list do
			local item = list[i]
			v[i] = typeof(item) == "number" and "[" .. tostring(item) .. "]" or "." .. item
		end

		return table.concat(v, "")
	end
}
