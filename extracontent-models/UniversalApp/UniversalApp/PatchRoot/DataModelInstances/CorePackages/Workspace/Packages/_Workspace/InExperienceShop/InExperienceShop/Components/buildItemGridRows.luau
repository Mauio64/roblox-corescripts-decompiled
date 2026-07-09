require(script.Parent.Parent.Types)

local function getItemSlotCost(p1, n1: number, p2: ((...any) -> ...any)) -- line: 8
	if p2(p1, n1) then
		return 2
	end

	return 1
end
local function buildUniformRows(t1: {[any]: any}, n2: number) -- line: 19
	local t2 = {}

	for i = 1, #t1, n2 do
		local t3 = {}

		table.move(t1, i, math.min(i + n2 - 1, #t1), 1, t3)
		table.insert(t2, t3)
	end

	return t2
end

return {
	ROBUX_TILE_SLOT_COST = 2,
	buildItemGridRows = function(t4: {[any]: any}, n3: number, p3: ((...any) -> ...any)?) -- line: 33
		-- upvalues: buildUniformRows (copy)
		if p3 == nil then
			return (buildUniformRows(t4, n3))
		end

		local t5 = {}
		local n4 = 1

		while n4 <= #t4 do
			local t6 = {}
			local n5 = 0
			local n6 = 1

			while n4 <= #t4 do
				local v19 = t4[n4]
				local v20 = not p3(v19, n6) and 1 or 2

				if n3 < n5 + v20 and #t6 > 0 then
					break
				end

				table.insert(t6, v19)
				n5 += v20
				n4 += 1
				n6 += 1

				if n3 <= n5 then
					break
				end
			end

			table.insert(t5, t6)
		end

		return t5
	end
}
