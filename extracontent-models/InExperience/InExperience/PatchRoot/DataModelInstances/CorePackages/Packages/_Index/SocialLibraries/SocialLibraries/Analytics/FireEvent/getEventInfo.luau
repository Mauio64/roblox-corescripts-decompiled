require(script.Parent.Types)

return function(p)
	return function(p2)
		local v = p[p2]
		assert(v, "Invalid eventName used: " .. tostring(p2) .. " called")

		return v
	end
end
