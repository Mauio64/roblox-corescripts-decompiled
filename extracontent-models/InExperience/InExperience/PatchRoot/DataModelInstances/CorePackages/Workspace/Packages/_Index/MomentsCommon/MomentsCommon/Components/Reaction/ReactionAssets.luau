local MomentsCommon = script:FindFirstAncestor("MomentsCommon")
local ReactionSize = require(MomentsCommon.Enums.ReactionSize)
local ReactionType = require(MomentsCommon.Enums.ReactionType)
local t1 = {
	[ReactionType.ThumbsUp] = "thumbs-up",
	[ReactionType.Heart] = "heart",
	[ReactionType.LaughJoy] = "laugh-joy",
	[ReactionType.Wow] = "wow",
	[ReactionType.Cry] = "crying",
	[ReactionType.Fire] = "fire",
	[ReactionType.Skull] = "skull"
}
local t2 = {
	[ReactionSize.XSmall] = "xsmall",
	[ReactionSize.Small] = "small",
	[ReactionSize.Medium] = "medium",
	[ReactionSize.Large] = "large"
}
local t3 = {
	[ReactionSize.XSmall] = 20,
	[ReactionSize.Small] = 24,
	[ReactionSize.Medium] = 32,
	[ReactionSize.Large] = 48
}

return {
	getAssetKey = function(p1) -- line: 33
		-- upvalues: t1 (copy)
		return t1[p1]
	end,
	getAnimatedImageUri = function(s1: string) -- line: 56
		return `rbxasset://textures/ui/Moments/Reactions/Animated/{ s1 }.png`
	end,
	getSizeKey = function(p2) -- line: 37
		-- upvalues: t2 (copy)
		return t2[p2]
	end,
	getSizePixels = function(p3) -- line: 41
		-- upvalues: t3 (copy)
		return t3[p3]
	end,
	getStaticImageUri = function(p4, p5) -- line: 45
		-- upvalues: t1 (copy), t2 (copy)
		local v12 = t1[p4]
		local v13 = t2[p5]

		if v12 == nil or v13 == nil then
			return nil
		end

		return `rbxasset://textures/ui/Moments/Reactions/{ v12 }-{ v13 }.png`
	end,
	getStickerImageUri = function(p6) -- line: 62
		-- upvalues: t1 (copy)
		local v16 = t1[p6]

		if v16 == nil then
			return nil
		end

		return `rbxasset://textures/ui/Moments/Reactions/{ v16 }-large@3x.png`
	end
}
