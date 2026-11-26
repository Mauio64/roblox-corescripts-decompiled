return {
	getStringParam = function(p2, p3, p4)
		local v5 = p2[p3]

		if typeof(v5) == "string" then
			return v5
		end

		return p4
	end,
	getBooleanParam = function(p2, p3, p4)
		local v5 = p2[p3]

		if typeof(v5) == "boolean" then
			return v5
		end

		return p4
	end,
	getCallbackParam = function(p2, p3, p4)
		local v5 = p2[p3]

		if typeof(v5) == "function" then
			return function()
				v5()
			end
		end

		return p4
	end
}
