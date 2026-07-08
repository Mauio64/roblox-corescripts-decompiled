local ParentParent = script.Parent.Parent.Parent

require(ParentParent.LuauPolyfill)

local function v2(...) -- line: 18
	error("Not implemented. Dependencies used upstream aren't implemented")
end

return {
	default = function(p1) -- line: 31
		-- upvalues: v2 (copy)
		local t1 = {}

		for _, v in ipairs(p1.supportedCommands) do
			t1[v] = function(p2, ...) -- line: 35
				-- upvalues: v2 (copy), v (copy)
				v2(p2, v, ...)
			end
		end

		return t1
	end
}
