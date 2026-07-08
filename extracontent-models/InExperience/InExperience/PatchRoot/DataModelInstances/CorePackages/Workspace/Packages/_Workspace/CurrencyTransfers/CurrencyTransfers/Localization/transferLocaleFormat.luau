return {
	substituteAmount = function(s1: string, s2: string) -- line: 5
		local result, _ = string.gsub(s1, "{amount}", (tostring(s2)))

		return result
	end,
	substituteReceiverNotAllowed = function(s3: string, s4: string) -- line: 10
		local str = tostring(s4)
		local result, _ = string.gsub(s3, "{userName}", str)
		local result2, _ = string.gsub(result, "{username}", str)

		return result2
	end,
	substituteUsername = function(s5: string, s6: string) -- line: 17
		local result, _ = string.gsub(s5, "{username}", (tostring(s6)))

		return result
	end,
	substituteMinAmount = function(s7: string, s8: string) -- line: 22
		local result, _ = string.gsub(s7, "{minAmount}", (tostring(s8)))

		return result
	end,
	substituteMaxAmount = function(s9: string, s10: string) -- line: 27
		local result, _ = string.gsub(s9, "{maxAmount}", (tostring(s10)))

		return result
	end
}
