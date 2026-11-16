local parent = script:FindFirstAncestor("ExpChat").Parent

local React = require(parent.React)

local function calculateScaled(p: number, item: number) -- 1 equivalent call inferred from this helper
	return p + item * (1 - p)
end

local function mergeBindableScalar(value, p)
	return React.joinBindings(typeof(value) == "number" and { p } or { p, value }):map(function(list)
		local item = list[1]
		local v = list[2] or value

		if v == nil then
			return 1
		end

		return calculateScaled(v, item) -- inferred equivalent call
	end)
end

return mergeBindableScalar
