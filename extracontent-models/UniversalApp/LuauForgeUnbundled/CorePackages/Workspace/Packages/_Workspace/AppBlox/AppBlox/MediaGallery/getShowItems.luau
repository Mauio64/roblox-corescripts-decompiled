local Cryo = require("@game/CorePackages/Workspace/Packages/_Workspace/AppBlox/Cryo")

local function getShowItems(p2)
	local values = {}
	local values2 = {}

	for i, item in ipairs(p2.items) do
		if item.isYouTubeVideo then
			table.insert(values, Cryo.Dictionary.join(item, { originalIndex = i }))
		else
			table.insert(values2, Cryo.Dictionary.join(item, { originalIndex = i }))
		end
	end

	local joined = Cryo.List.join(values, values2)

	local numberOfThumbnails = p2.numberOfThumbnails

	if numberOfThumbnails then
		for i = #joined + 1, numberOfThumbnails do
			joined[i] = {}
		end
	end

	return joined, #values, #values2
end

return getShowItems
