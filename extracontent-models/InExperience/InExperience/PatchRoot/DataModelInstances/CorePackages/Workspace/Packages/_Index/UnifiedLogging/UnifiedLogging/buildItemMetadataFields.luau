local Parent = script:FindFirstAncestor("UnifiedLogging").Parent
local DiscoveryEventErrorLogger = require(Parent.DiscoveryUtils).DiscoveryEventErrorLogger
local t1 = {
	collectionId = true,
	collectionPosition = true,
	contentType = true,
	id = true,
	itemPosition = true,
	itemsPerRow = true,
	rowNumber = true,
	totalNumberOfItems = true
}

local function shouldIgnoreKey(s1: string) -- line: 17
	-- upvalues: t1 (copy)
	return t1[s1]
end
local function buildItemMetadataFields(t2: {[any]: any}, t3: {[any]: any}, p1) -- line: 21
	-- upvalues: t1 (copy), DiscoveryEventErrorLogger (copy)
	local t4 = {}

	for v11, v12 in t2 do
		local v13 = t3 and t3[v12] or nil

		if v13 ~= nil then
			for v14, v15 in v13 do
				if not t1[v14] then
					if t4[v14] == nil then
						t4[v14] = {}
					end

					t4[v14][v11] = v15
				end
			end
		else
			DiscoveryEventErrorLogger.reportError("buildMetadataFields", "Entry was nil when building item metadataFields for collection", {
				entryIndex = v12,
				collectionId = p1
			})
		end
	end

	for v16, _ in t4 do
		for i = 1, #t2 do
			if t4[v16][i] == nil then
				t4[v16][i] = ""
			end
		end
	end

	local t5 = {}

	for v20, v21 in t4 do
		t5[`{ v20 }_arr`] = table.concat(v21, ",")
	end

	return t5
end

return buildItemMetadataFields
