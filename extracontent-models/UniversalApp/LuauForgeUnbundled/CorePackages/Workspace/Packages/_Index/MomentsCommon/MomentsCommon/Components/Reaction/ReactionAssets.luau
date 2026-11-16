local GuiService = game:GetService("GuiService")

local ReactionSize = require("@game/CorePackages/Workspace/Packages/_Index/MomentsCommon/MomentsCommon/Enums/ReactionSize")
local ReactionType = require("@game/CorePackages/Workspace/Packages/_Index/MomentsCommon/MomentsCommon/Enums/ReactionType")

local v5 = {
	[ReactionType.ThumbsUp] = "thumbs-up",
	[ReactionType.Heart] = "heart",
	[ReactionType.LaughJoy] = "laugh-joy",
	[ReactionType.Wow] = "wow",
	[ReactionType.Cry] = "crying",
	[ReactionType.Fire] = "fire",
	[ReactionType.Skull] = "skull"
}

local v6 = {
	[ReactionSize.XSmall] = "xsmall",
	[ReactionSize.Small] = "small",
	[ReactionSize.Medium] = "medium",
	[ReactionSize.Large] = "large"
}

local v7 = {
	[ReactionSize.XSmall] = 20,
	[ReactionSize.Small] = 24,
	[ReactionSize.Medium] = 32,
	[ReactionSize.Large] = 48
}

local defineFastFlag = game:DefineFastFlag("MomentsUpdateReactionIllustrationQuality", false)

local function getScaleSuffix(p2): string
	if p2 > 2.5 then
		return "@3x"
	end

	if p2 > 1.5 then
		return "@2x"
	end

	return ""
end

return {
	getAssetKey = function(p2)
		return v5[p2]
	end,
	getAnimatedImageUri = function(p2)
		return `rbxasset://textures/ui/Moments/Reactions/Animated/{p2}.png`
	end,
	getSizeKey = function(p2)
		return v6[p2]
	end,
	getSizePixels = function(p2)
		return v7[p2]
	end,
	getStaticImageUri = function(p2, p3, p4)
		local v8 = v5[p2]

		local v9 = v6[p3]

		if v8 == nil or v9 == nil then
			return nil
		end

		local v10

		if defineFastFlag then
			local v11 = p4 or GuiService:GetResolutionScale()
			v10 = v11 > 2.5 and "@3x" or v11 > 1.5 and "@2x" or ""
		else
			v10 = ""
		end

		return `rbxasset://textures/ui/Moments/Reactions/{v8}-{v9}{v10}.png`
	end,
	getStickerImageUri = function(p2)
		local v8 = v5[p2]

		if v8 == nil then
			return nil
		end

		return `rbxasset://textures/ui/Moments/Reactions/{v8}-large@3x.png`
	end
}
