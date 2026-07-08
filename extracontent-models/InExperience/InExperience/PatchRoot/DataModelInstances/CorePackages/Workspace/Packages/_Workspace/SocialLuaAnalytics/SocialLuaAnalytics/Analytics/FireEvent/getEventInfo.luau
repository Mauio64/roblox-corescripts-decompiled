require(script.Parent.Parent.Types)

return function(p1) -- line: 3
	return function(p2, p3) -- line: 4
		-- upvalues: p1 (copy)
		local v4 = p1[p2]

		assert(v4, "Invalid eventName used: " .. tostring(p2) .. " called")

		return v4, p3
	end
end
