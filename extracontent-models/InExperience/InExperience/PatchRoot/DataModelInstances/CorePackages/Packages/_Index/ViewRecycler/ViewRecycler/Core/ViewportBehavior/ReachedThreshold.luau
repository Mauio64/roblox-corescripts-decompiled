local function validateNumber(p: number, p2: string) -- 2 equivalent calls inferred from this helper
	local v = p >= 0 and p < 1e999
	assert(v, `{p2} must be a finite non-negative number`)
end

return table.freeze({
	validate = function(value, value2: string?)
		local v = value2 or "ReachedThreshold"

		if type(value) == "number" then
			validateNumber(value, v) -- inferred equivalent call
		else
			assert(type(value) == "table", `{v} must be a number or viewport-fraction table`)
			assert(type(value.viewportFraction) == "number", `{v}.viewportFraction must be a number`)
			validateNumber(value.viewportFraction, `{v}.viewportFraction`) -- inferred equivalent call
		end
	end,
	resolve = function(p, p2: number, p3: number)
		local v = p or p3

		if type(v) == "number" then
			return v
		end

		return v.viewportFraction * p2
	end
})
