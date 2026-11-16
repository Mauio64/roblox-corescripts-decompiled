return {
	genFuzzStrings = function(p)
		local function getFuzzStrings()
			local allowedChars = p.allowedChars
			local maxLength = p.maxLength
			local count = #allowedChars
			local total = 0

			for i = 1, maxLength do
				total += count ^ i
			end

			coroutine.yield("")

			for i = 0, total - 1 do
				local v = i
				local v2 = ""

				while v >= 0 do
					local v3 = v % count
					v2 = allowedChars[v3 + 1] .. v2
					v = (v - v3) / count - 1
				end

				coroutine.yield(v2)
			end
		end

		return coroutine.wrap(getFuzzStrings)
	end
}
