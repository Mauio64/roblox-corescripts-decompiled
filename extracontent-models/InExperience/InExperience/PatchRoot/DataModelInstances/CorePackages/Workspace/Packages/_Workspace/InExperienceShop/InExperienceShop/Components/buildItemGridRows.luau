require(script.Parent.Parent.Types)

local function getItemSlotCost(item, p: number, callback): number -- 1 equivalent call inferred from this helper
	return if callback(item, p) then 2 else 1
end

local function buildUniformRows(list, p: number)
	local uniformRows = {}

	for i = 1, #list, p do
		local v = {}
		table.move(list, i, math.min(i + p - 1, #list), 1, v)
		table.insert(uniformRows, v)
	end

	return uniformRows
end

return {
	buildItemGridRows = function(list, p: number, callback)
		if callback == nil then
			return buildUniformRows(list, p)
		end

		local v = 1
		local result = {}

		while v <= #list do
			local v2 = 1
			local v3 = {}
			local total = 0

			while v <= #list do
				local item = list[v]
				local itemSlotCost = getItemSlotCost(item, v2, callback) -- inferred equivalent call

				if p < total + itemSlotCost and #v3 > 0 then
					break
				end

				table.insert(v3, item)
				total += itemSlotCost
				v += 1
				v2 += 1

				if p <= total then
					break
				end
			end

			table.insert(result, v3)
		end

		return result
	end,
	ROBUX_TILE_SLOT_COST = 2
}
