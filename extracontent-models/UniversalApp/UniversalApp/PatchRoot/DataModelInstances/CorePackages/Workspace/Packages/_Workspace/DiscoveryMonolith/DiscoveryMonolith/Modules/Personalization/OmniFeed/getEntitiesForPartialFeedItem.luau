local Parent = script:FindFirstAncestor("DiscoveryMonolith").Parent
local Cryo = require(Parent.Cryo)
local ArgCheck = require(Parent.ArgCheck)
local flaggedMutedError = require(Parent.Loggers).flaggedMutedError
local LoggingProtocol = require(Parent.LoggingProtocol)
local reportWarning = require(Parent.DiscoveryAnalytics).Points.reportWarning

local function getEntitiesForPartialFeedItem(t1: {[any]: any}, t2: {[any]: any}, b1: boolean, n1: number?, n2: number?) -- line: 32
	-- upvalues: reportWarning (copy), LoggingProtocol (copy), flaggedMutedError (copy), ArgCheck (copy), Cryo (copy)
	local firstIndex = t2.firstIndex
	local entryIndices = t2.entryIndices
	local v15 = if not entryIndices then nil else #entryIndices

	if not firstIndex or (not v15 or firstIndex == 1e999) then
		return {}
	end

	if #t1 == 0 then
		reportWarning(LoggingProtocol.default, "getEntitiesForPartialFeedItemEmptyEntries", "Entries were empty in getEntitiesForPartialFeedItem", {
			hasEmphasis = tostring(b1),
			firstIndex = tostring(firstIndex),
			numberOfTiles = tostring(v15),
			itemsPerRow = tostring(n1)
		})

		return {}
	end

	local n3 = 0
	local n4 = 0
	local v18 = false

	if b1 then
		if firstIndex == 1 then
			v18 = true
		elseif firstIndex > 1 then
			if firstIndex <= 3 then
				flaggedMutedError("InvalidFirstIndexForSearchFeedItem", `Invalid firstIndex: { firstIndex } for feed item`)

				return {}
			end

			ArgCheck.assert(firstIndex > 3)
			n3 = 3
		end

		n4 = 3
	end

	local t3 = {}

	for i = firstIndex - n3, if n2 ~= 1e999 then math.clamp(firstIndex + v15 - n4 - 1, 1, #t1) else #t1 do
		local v21 = #t3 + 1
		local v22 = not (n1 and v21 <= n1 - 1) and 3 or 1
		local v23 = if v21 ~= 1 and (not not v18 and n1) then v21 + v22 else v21

		table.insert(t3, (Cryo.Dictionary.join(t1[i], {
			uiIndex = v23,
			topicContentsIndex = i
		})))
	end

	return t3
end

return getEntitiesForPartialFeedItem
