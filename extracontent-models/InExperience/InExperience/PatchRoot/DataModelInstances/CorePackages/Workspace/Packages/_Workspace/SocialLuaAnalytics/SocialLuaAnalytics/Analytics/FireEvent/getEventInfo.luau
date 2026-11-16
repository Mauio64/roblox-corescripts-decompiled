require(script.Parent.Parent.Types)

return function(p)
	return function(p2, p3)
		local v = p[p2]
		assert(v, "Invalid eventName used: " .. tostring(p2) .. " called")

		return v, p3
	end
end
