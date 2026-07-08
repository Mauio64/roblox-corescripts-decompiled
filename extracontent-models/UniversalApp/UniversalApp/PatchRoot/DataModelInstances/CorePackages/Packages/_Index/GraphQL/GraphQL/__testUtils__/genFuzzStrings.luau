return {
	genFuzzStrings = function(t1: {[any]: any}) -- line: 13
		local function getFuzzStrings() -- line: 14
			-- upvalues: t1 (copy)
			local allowedChars = t1.allowedChars
			local maxLength = t1.maxLength
			local v5 = #allowedChars
			local n1 = 0

			for i = 1, maxLength do
				n1 += v5 ^ i
			end

			coroutine.yield("")

			for i = 0, n1 - 1 do
				local s1 = ""
				local v10 = i

				while v10 >= 0 do
					local v11 = v10 % v5

					s1 = allowedChars[v11 + 1] .. s1
					v10 = (v10 - v11) / v5 - 1
				end

				coroutine.yield(s1)
			end
		end

		return coroutine.wrap(getFuzzStrings)
	end
}
