local DataHydration = script:FindFirstAncestor("DataHydration")
local DataHydrationParent = DataHydration.Parent
local MomentsTypes = require(DataHydrationParent.MomentsTypes)

require(DataHydration.Moments.MomentsStoreTypes)

local t1 = {}

for _, v6 in MomentsTypes.Enums.ReactionType do
	t1[v6] = true
end

local function convertApiReactions(p1) -- line: 27
	-- upvalues: t1 (copy)
	if type(p1) ~= "table" then
		return nil
	end

	local t2 = {}
	local v11 = false
	local counts = p1.counts

	if type(counts) == "table" then
		for v13, v14 in counts do
			if type(v13) == "string" and t1[v13] and type(v14) == "number" and v14 > 0 then
				t2[v13] = v14
				v11 = true
			end
		end
	end

	local v15 = p1.userReaction or p1.viewerReaction

	if type(v15) == "string" and t1[v15] then
		t2.userReaction = v15
		v11 = true
	end

	if not v11 then
		return nil
	end

	return t2
end
local function extractReactionsByMomentId(t3: {[any]: any}?) -- line: 65
	-- upvalues: convertApiReactions (copy)
	local t4 = {}

	if t3 == nil then
		return t4
	end

	for _, v19 in t3 do
		local v20 = v19.entityId or v19.id

		if v20 ~= nil then
			local v21 = convertApiReactions(v19.reactions)

			if v21 ~= nil then
				t4[v20] = v21
			end
		end
	end

	return t4
end

return extractReactionsByMomentId
