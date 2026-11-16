local headShape = require("@luauforge/bundled/dHT").Enums.HeadShape

local v5 = {}

for k, v6 in {
	headShape.Default,
	headShape.WomanHead,
	headShape.ManHead,
	headShape.Blockhead,
	headShape.Cheeks,
	headShape.Chiseled,
	headShape.Narrow,
	headShape.Paragon,
	headShape.Roundy,
	headShape.StrongJaw,
	headShape.Trim
} do
	v5[v6] = k
end

local function sortHeadShapes(p2, callback)
	local clone = table.clone(p2)
	table.sort(clone, function(a, b): boolean
		local v6 = callback(a)
		local v7 = callback(b)
		local v8 = v5[v6]
		local v9 = v5[v7]

		if v8 == nil and v9 == nil then
			return v6 < v7
		end

		if v8 == nil then
			return false
		end

		if v9 == nil then
			return true
		end

		return v8 < v9
	end)

	return clone
end

return sortHeadShapes
