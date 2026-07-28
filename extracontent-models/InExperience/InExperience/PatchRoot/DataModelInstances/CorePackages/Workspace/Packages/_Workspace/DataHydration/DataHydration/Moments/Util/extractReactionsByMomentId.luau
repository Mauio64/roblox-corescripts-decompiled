local DataHydration = script:FindFirstAncestor("DataHydration")
local DataHydrationParent = DataHydration.Parent
local MomentsTypes = require(DataHydrationParent.MomentsTypes)

require(DataHydration.Moments.MomentsStoreTypes)

local hardcodedMomentsEmojis = require(DataHydration.Moments.Util.hardcodedMomentsEmojis)
local resolveEmoteId = require(DataHydration.Moments.Util.resolveEmoteId)
local FFlagMomentsEmojiSetsApi = require(DataHydration.Moments.FFlagMomentsEmojiSetsApi)
local t1 = {}

for _, v9 in MomentsTypes.Enums.ReactionType do
	t1[v9] = true
end

local function isValidReactionType(s1: string) -- line: 32
	-- upvalues: t1 (copy), resolveEmoteId (copy)
	return t1[s1] == true or t1[resolveEmoteId.normalizeName(s1)] == true
end
local function asReactionType(s2: string) -- line: 36
	-- upvalues: resolveEmoteId (copy), t1 (copy)
	local v18 = resolveEmoteId.normalizeName(s2)

	if t1[v18] then
		return v18
	end

	return nil
end
local function convertReactionCountsArray(p1, t2: {[any]: any}) -- line: 44
	-- upvalues: resolveEmoteId (copy), t1 (copy)
	local t3 = {}
	local v22 = false
	local v23 = nil

	for _, v25 in p1 do
		if type(v25) == "table" then
			local count = v25.count

			if type(count) == "number" and not (count <= 0) then
				local v27 = nil

				if type(v25.name) == "string" then
					local name = v25.name
					local v29 = resolveEmoteId.normalizeName(name)

					v27 = if not t1[v29] then nil else v29
				end

				if v27 == nil then
					local v30 = v25.emote_id or v25.emoteId

					if type(v30) == "string" then
						local v31 = resolveEmoteId.reactionTypeForEmoteId(t2, v30)

						if v31 ~= nil then
							local v32 = resolveEmoteId.normalizeName(v31)

							v27 = if not t1[v32] then nil else v32
						end
					end
				end

				if v27 ~= nil then
					t3[v27] = count
					v22 = true

					local has_user_reacted = v25.has_user_reacted

					if has_user_reacted == nil then
						has_user_reacted = v25.hasUserReacted
					end

					if has_user_reacted == true then
						v23 = v27
					end
				end
			end
		end
	end

	if v23 ~= nil then
		t3.userReaction = v23
		v22 = true
	end

	if not v22 then
		return nil
	end

	return t3
end
local function convertLegacyApiReactions(p2) -- line: 105
	-- upvalues: FFlagMomentsEmojiSetsApi (copy), t1 (copy), resolveEmoteId (copy)
	local t4 = {}
	local v36 = false
	local counts = p2.counts

	if type(counts) == "table" then
		for v38, v39 in counts do
			if type(v38) == "string" and type(v39) == "number" and v39 > 0 then
				if FFlagMomentsEmojiSetsApi then
					if t1[v38] == true or t1[resolveEmoteId.normalizeName(v38)] == true then
						local v40 = resolveEmoteId.normalizeName(v38)
						local v41 = if not t1[v40] then nil else v40

						if v41 ~= nil then
							t4[v41] = v39
							v36 = true
						end
					end
				elseif t1[v38] then
					t4[v38] = v39
					v36 = true
				end
			end
		end
	end

	local v42 = p2.userReaction or p2.viewerReaction

	if type(v42) == "string" then
		if FFlagMomentsEmojiSetsApi then
			local v43 = resolveEmoteId.normalizeName(v42)
			local v44 = if not t1[v43] then nil else v43

			if v44 ~= nil then
				t4.userReaction = v44
				v36 = true
			end
		elseif t1[v42] then
			t4.userReaction = v42
			v36 = true
		end
	end

	if not v36 then
		return nil
	end

	return t4
end
local function convertApiReactions(p3, t5: {[any]: any}) -- line: 150
	-- upvalues: FFlagMomentsEmojiSetsApi (copy), convertReactionCountsArray (copy), convertLegacyApiReactions (copy)
	if type(p3) ~= "table" then
		return nil
	end

	if FFlagMomentsEmojiSetsApi then
		local v47 = p3.reaction_counts or p3.reactionCounts

		if type(v47) == "table" then
			local v48 = convertReactionCountsArray(v47, t5)

			if v48 ~= nil then
				return v48
			end
		end
	end

	return (convertLegacyApiReactions(p3))
end
local function extractReactionsByMomentId(t6: {[any]: any}?) -- line: 168
	-- upvalues: hardcodedMomentsEmojis (copy), FFlagMomentsEmojiSetsApi (copy), convertReactionCountsArray (copy), convertLegacyApiReactions (copy)
	local t7 = {}
	local v51 = hardcodedMomentsEmojis

	if t6 == nil then
		return t7
	end

	local g57 = nil
	local g58 = nil
	local v56 = nil

	for _, v53 in t6 do
		local v54 = v53.entityId or v53.id

		if v54 == nil then
			continue
		end

		local reactions = v53.reactions

		if type(reactions) ~= "table" then
			v56 = nil
			g57 = true
		end

		if not g57 then
			repeat
				repeat
					if not g58 and (not g58 and FFlagMomentsEmojiSetsApi) then
						local v59 = reactions.reaction_counts or reactions.reactionCounts

						if type(v59) ~= "table" then
							g58 = true
						end

						if not g58 then
							v56 = convertReactionCountsArray(v59, v51)

							if v56 == nil then
								g58 = true
							end
						end
					else
						g58 = false
						v56 = convertLegacyApiReactions(reactions)
					end
				until not g58
			until not g58
		end

		g57 = false

		if v56 ~= nil then
			t7[v54] = v56
		end
	end

	return t7
end

return extractReactionsByMomentId
