local Parent = script:FindFirstAncestor("Moments").Parent
local MomentsCommon = require(Parent.MomentsCommon)

require(Parent.MomentsTypes)

local ReactionType = MomentsCommon.Enums.ReactionType
local t1 = {
	[ReactionType.ThumbsUp] = true,
	[ReactionType.Heart] = true,
	[ReactionType.LaughJoy] = true,
	[ReactionType.Wow] = true,
	[ReactionType.Cry] = true,
	[ReactionType.Fire] = true,
	[ReactionType.Skull] = true
}
local t2 = {
	ReactionType.ThumbsUp,
	ReactionType.Heart,
	ReactionType.LaughJoy,
	ReactionType.Wow,
	ReactionType.Cry,
	ReactionType.Fire,
	ReactionType.Skull
}

local function normalizeEmojiName(s1: string) -- line: 37
	local v8 = string.gsub(string.lower(s1), "%-", "")

	if v8 == "crying" then
		return "cry"
	end

	return v8
end

return {
	reactionTypesFromEmojis = function(t3: {[any]: any}) -- line: 47
		-- upvalues: t1 (copy), t2 (copy)
		local t4 = {}

		for _, v12 in t3 do
			local name = v12.name
			local v14 = string.gsub(string.lower(name), "%-", "")
			local v15 = if v14 ~= "crying" then v14 else "cry"

			if t1[v15] then
				table.insert(t4, v15)
			end
		end

		if #t4 == 0 then
			return t2
		end

		return t4
	end,
	FALLBACK_PICKER_REACTIONS = t2
}
