local GuiService = game:GetService("GuiService")

local MomentsCommon = script:FindFirstAncestor("MomentsCommon")

local ReactionSize = require(MomentsCommon.Enums.ReactionSize)
local ReactionType = require(MomentsCommon.Enums.ReactionType)

local v = {
	[ReactionType.ThumbsUp] = "thumbs-up",
	[ReactionType.Heart] = "heart",
	[ReactionType.LaughJoy] = "laugh-joy",
	[ReactionType.Wow] = "wow",
	[ReactionType.Cry] = "crying",
	[ReactionType.Fire] = "fire",
	[ReactionType.Skull] = "skull"
}

local v2 = {
	[ReactionSize.XSmall] = "xsmall",
	[ReactionSize.Small] = "small",
	[ReactionSize.Medium] = "medium",
	[ReactionSize.Large] = "large"
}

local v3 = {
	[ReactionSize.XSmall] = 20,
	[ReactionSize.Small] = 24,
	[ReactionSize.Medium] = 32,
	[ReactionSize.Large] = 48
}

local defineFastFlag = game:DefineFastFlag("MomentsUpdateReactionIllustrationQuality", false)

local function getScaleSuffix(p: number): string -- 1 equivalent call inferred from this helper
	if p > 2.5 then
		return "@3x"
	end

	return if p > 1.5 then "@2x" else ""
end

local function getAssetKey(p) -- 2 equivalent calls inferred from this helper
	return v[p]
end

local function getSizeKey(p) -- 1 equivalent call inferred from this helper
	return v2[p]
end

local ReactionAssets = {}
ReactionAssets.getAssetKey = getAssetKey

function ReactionAssets.getAnimatedImageUri(p: string)
	return `rbxasset://textures/ui/Moments/Reactions/Animated/{p}.png`
end

ReactionAssets.getSizeKey = getSizeKey

function ReactionAssets.getSizePixels(p)
	return v3[p]
end

function ReactionAssets.getStaticImageUri(p, p2, p3: number?)
	local assetKey = getAssetKey(p) -- inferred equivalent call
	local sizeKey = getSizeKey(p2) -- inferred equivalent call

	if assetKey == nil or sizeKey == nil then
		return nil
	end

	local v4

	if defineFastFlag then
		v4 = getScaleSuffix(p3 or GuiService:GetResolutionScale()) -- inferred equivalent call
	else
		v4 = ""
	end

	return `rbxasset://textures/ui/Moments/Reactions/{assetKey}-{sizeKey}{v4}.png`
end

function ReactionAssets.getStickerImageUri(p)
	local assetKey = getAssetKey(p) -- inferred equivalent call

	if assetKey == nil then
		return nil
	end

	return `rbxasset://textures/ui/Moments/Reactions/{assetKey}-large@3x.png`
end

return ReactionAssets
