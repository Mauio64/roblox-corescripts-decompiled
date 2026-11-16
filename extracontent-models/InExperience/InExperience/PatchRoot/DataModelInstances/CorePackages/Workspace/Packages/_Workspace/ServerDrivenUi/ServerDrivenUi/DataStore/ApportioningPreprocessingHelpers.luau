local parent = script:FindFirstAncestor("ServerDrivenUi").Parent

local Loggers = require(parent.Loggers)
local flaggedMutedError = Loggers.flaggedMutedError

local function fn(p, p2, capacity, sortIndex)
	p[p2] = {
		gridApportioningMetadata = {
			{ sortIndex = sortIndex, capacity = capacity }
		}
	}
end

local function fn2(p, capacity, sortIndex)
	for k, v in p.gridApportioningMetadata do
		if v.sortIndex == sortIndex then
			flaggedMutedError("ApportioningSameSortIndex", `Multiple collections at sort index {sortIndex}`)
		elseif sortIndex < v.sortIndex then
			table.insert(p.gridApportioningMetadata, k, {
				sortIndex = sortIndex,
				capacity = capacity
			})

			return
		end
	end

	table.insert(p.gridApportioningMetadata, { sortIndex = sortIndex, capacity = capacity })
end

local ApportioningPreprocessingHelpers = {}

function ApportioningPreprocessingHelpers.addToApportioningData(p, p2, capacity, sortIndex)
	local v = p[p2]

	if v then
		fn2(v, capacity, sortIndex)
	else
		fn(p, p2, capacity, sortIndex)
	end
end

function ApportioningPreprocessingHelpers.populateStartingItemIndices(items)
	for _, item in items do
		local total = 1

		for _, v in item.gridApportioningMetadata do
			v.startingItemIndex = total
			total += v.capacity
		end
	end
end

return ApportioningPreprocessingHelpers
