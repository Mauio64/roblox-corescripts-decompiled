local module = require("@luauforge/bundled/dqd")
local module2 = require("@luauforge/bundled/dqE")
local flaggedMutedError = require("@luauforge/bundled/dru").flaggedMutedError
local module3 = require("@luauforge/bundled/dqq")
local reportWarning = require("@luauforge/bundled/dqo").Points.reportWarning

local function getEntitiesForPartialFeedItem(list, p2, p3, p4, p5)
	local firstIndex = p2.firstIndex
	local entryIndices = p2.entryIndices
	local v5 = entryIndices and #entryIndices or nil

	if not firstIndex or not v5 or firstIndex == 1e999 then
		return {}
	end

	if #list == 0 then
		reportWarning(
			module3.default,
			"getEntitiesForPartialFeedItemEmptyEntries",
			"Entries were empty in getEntitiesForPartialFeedItem",
			{
				hasEmphasis = tostring(p3),
				firstIndex = tostring(firstIndex),
				numberOfTiles = tostring(v5),
				itemsPerRow = tostring(p4)
			}
		)

		return {}
	end

	local v6 = 0

	local v7 = false
	local v8

	if p3 then
		if firstIndex == 1 then
			v7 = true
		elseif firstIndex > 1 then
			if firstIndex <= 3 then
				flaggedMutedError(
					"InvalidFirstIndexForSearchFeedItem",
					`Invalid firstIndex: {firstIndex} for feed item`
				)

				return {}
			end

			module2.assert(firstIndex > 3)
			v6 = 3
		end

		v8 = 3
	else
		v8 = 0
	end

	local v9 = firstIndex - v6

	local v10 = if p5 == 1e999 then #list else math.clamp(firstIndex + v5 - v8 - 1, 1, #list)

	local result = {}

	for i = v9, v10 do
		local v11 = #result + 1
		local v12 = p4 and v11 <= p4 - 1 and 1 or 3

		if v11 ~= 1 and v7 and p4 then
			v11 += v12
		end

		table.insert(result, (module.Dictionary.join(list[i], {
			uiIndex = v11,
			topicContentsIndex = i
		})))
	end

	return result
end

return getEntitiesForPartialFeedItem
