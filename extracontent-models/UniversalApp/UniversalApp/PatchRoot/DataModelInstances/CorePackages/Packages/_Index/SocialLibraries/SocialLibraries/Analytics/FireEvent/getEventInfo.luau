require(script.Parent.Types)

return function(p1) -- line: 4
	return function(p2) -- line: 5
		-- upvalues: p1 (copy)
		local v3 = p1[p2]

		assert(v3, "Invalid eventName used: " .. tostring(p2) .. " called")

		return v3
	end
end
