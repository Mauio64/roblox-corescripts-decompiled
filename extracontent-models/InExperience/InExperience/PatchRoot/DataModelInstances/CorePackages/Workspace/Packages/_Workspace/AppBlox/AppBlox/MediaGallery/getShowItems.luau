local parent = script:FindFirstAncestor("AppBlox").Parent
local Cryo = require(parent.Cryo)

local function getShowItems(p)
	local values = {}
	local values2 = {}

	for i, item in ipairs(p.items) do
		if item.isYouTubeVideo then
			table.insert(values, Cryo.Dictionary.join(item, { originalIndex = i }))
		else
			table.insert(values2, Cryo.Dictionary.join(item, { originalIndex = i }))
		end
	end

	local joined = Cryo.List.join(values, values2)

	local numberOfThumbnails = p.numberOfThumbnails

	if numberOfThumbnails then
		for i = #joined + 1, numberOfThumbnails do
			joined[i] = {}
		end
	end

	return joined, #values, #values2
end

return getShowItems
