return {
	substituteAmount = function(value, p2)
		local v5, v6 = string.gsub(value, "{amount}", (tostring(p2)))
		return v5
	end,
	substituteReceiverNotAllowed = function(value, p2)
		local v5 = tostring(p2)
		local v6, v7 = string.gsub(value, "{userName}", v5)
		local v8, v9 = string.gsub(v6, "{username}", v5)
		return v8
	end,
	substituteUsername = function(value, p2)
		local v5, v6 = string.gsub(value, "{username}", (tostring(p2)))
		return v5
	end,
	substituteMinAmount = function(value, p2)
		local v5, v6 = string.gsub(value, "{minAmount}", (tostring(p2)))
		return v5
	end,
	substituteMaxAmount = function(value, p2)
		local v5, v6 = string.gsub(value, "{maxAmount}", (tostring(p2)))
		return v5
	end
}
