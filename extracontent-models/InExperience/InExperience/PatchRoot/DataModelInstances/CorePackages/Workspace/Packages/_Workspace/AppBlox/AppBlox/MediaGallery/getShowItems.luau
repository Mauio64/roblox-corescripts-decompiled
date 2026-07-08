local Parent = script:FindFirstAncestor("AppBlox").Parent
local Cryo = require(Parent.Cryo)

local function getShowItems(p1) -- line: 6
	-- upvalues: Cryo (copy)
	local t1 = {}
	local t2 = {}

	for i, v in ipairs(p1.items) do
		if v.isYouTubeVideo then
			table.insert(t1, Cryo.Dictionary.join(v, {
				originalIndex = i
			}))
		else
			table.insert(t2, Cryo.Dictionary.join(v, {
				originalIndex = i
			}))
		end
	end

	local v9 = Cryo.List.join(t1, t2)
	local numberOfThumbnails = p1.numberOfThumbnails

	if numberOfThumbnails then
		for i = #v9 + 1, numberOfThumbnails do
			v9[i] = {}
		end
	end

	return v9, #t1, #t2
end

return getShowItems
