local Parent = script:FindFirstAncestor("ServerDrivenUi").Parent
local flaggedMutedError = require(Parent.Loggers).flaggedMutedError

local function v3(p1, p2, p3, p4) -- line: 11
	p1[p2] = {
		gridApportioningMetadata = {{
			sortIndex = p4,
			capacity = p3
		}}
	}
end
local function v4(p5, p6, p7) -- line: 22
	-- upvalues: flaggedMutedError (copy)
	for v12, v13 in p5.gridApportioningMetadata do
		if p7 ~= v13.sortIndex then
			if not (p7 < v13.sortIndex) then
				continue
			end

			table.insert(p5.gridApportioningMetadata, v12, {
				sortIndex = p7,
				capacity = p6
			})

			return
		end

		flaggedMutedError("ApportioningSameSortIndex", `Multiple collections at sort index { p7 }`)
	end

	table.insert(p5.gridApportioningMetadata, {
		sortIndex = p7,
		capacity = p6
	})
end

return {
	addToApportioningData = function(p8, p9, p10, p11) -- line: 43
		-- upvalues: v4 (copy), v3 (copy)
		local v18 = p8[p9]

		if v18 then
			v4(v18, p10, p11)

			return
		end

		v3(p8, p9, p10, p11)
	end,
	populateStartingItemIndices = function(p12) -- line: 53
		for _, v21 in p12 do
			local n1 = 1

			for _, v24 in v21.gridApportioningMetadata do
				v24.startingItemIndex = n1
				n1 += v24.capacity
			end
		end
	end
}
