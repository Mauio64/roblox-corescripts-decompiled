local flaggedMutedError = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/Loggers").flaggedMutedError

local function fn(p2, p3, p4, p5)
	p2[p3] = {
		gridApportioningMetadata = {
			{ sortIndex = p5, capacity = p4 }
		}
	}
end

local function fn2(p2, p3, p4)
	for k, v5 in p2.gridApportioningMetadata do
		if v5.sortIndex == p4 then
			flaggedMutedError("ApportioningSameSortIndex", `Multiple collections at sort index {p4}`)
		elseif p4 < v5.sortIndex then
			table.insert(p2.gridApportioningMetadata, k, {
				sortIndex = p4,
				capacity = p3
			})

			return
		end
	end

	table.insert(p2.gridApportioningMetadata, { sortIndex = p4, capacity = p3 })
end

return {
	addToApportioningData = function(p2, p3, p4, p5)
		local v5 = p2[p3]

		if v5 then
			fn2(v5, p4, p5)
		else
			fn(p2, p3, p4, p5)
		end
	end,
	populateStartingItemIndices = function(items)
		for k, item in items do
			local total = 1

			for k2, v5 in item.gridApportioningMetadata do
				v5.startingItemIndex = total
				total += v5.capacity
			end
		end
	end
}
