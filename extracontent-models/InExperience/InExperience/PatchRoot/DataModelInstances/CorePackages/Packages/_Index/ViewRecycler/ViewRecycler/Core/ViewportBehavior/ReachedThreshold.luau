local Flags = require(script:FindFirstAncestor("ViewRecycler").Flags)

local function validateNumber(p: number, p2: string) -- 2 equivalent calls inferred from this helper
	local v = p >= 0 and p < 1e999
	assert(v, `{p2} must be a finite non-negative number`)
end

local v = {}

function v.validate(value, value2: string?)
	local v2 = value2 or "ReachedThreshold"

	if type(value) == "number" then
		validateNumber(value, v2) -- inferred equivalent call
	else
		assert(type(value) == "table", `{v2} must be a number or viewport-fraction table`)
		assert(type(value.viewportFraction) == "number", `{v2}.viewportFraction must be a number`)
		validateNumber(value.viewportFraction, `{v2}.viewportFraction`) -- inferred equivalent call
	end
end

if Flags.FFlagViewRecyclerReact084 then
	function v.equal(p, p2): boolean
		if p == p2 then
			return true
		end

		return type(p) == "table" and type(p2) == "table" and p.viewportFraction == p2.viewportFraction
	end
end

function v.resolve(p, p2: number, p3: number)
	local v2 = p or p3

	if type(v2) == "number" then
		return v2
	end

	return v2.viewportFraction * p2
end

return table.freeze(v)
