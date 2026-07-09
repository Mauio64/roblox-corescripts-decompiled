local HeadShape = require(script.Parent.HeadShape)
local Parent = script:FindFirstAncestor("AvatarExperienceHeadRefinement").Parent
local AvatarExperienceFlags = require(Parent.AvatarExperienceFlags)
local FFlagDynamicHeadsMigration = AvatarExperienceFlags.FFlagDynamicHeadsMigration
local v5 = game:DefineFastFlag("AXReplaceDefaultHeadAssetId", false)
local FFlagAXAddFacesToHeadList = AvatarExperienceFlags.FFlagAXAddFacesToHeadList
local FFlagAXFixTryOnHeadShapeThumbnail = AvatarExperienceFlags.FFlagAXFixTryOnHeadShapeThumbnail

require(Parent.AvatarExperienceSlotBasedEditor)

if not FFlagDynamicHeadsMigration then
end

local t1 = {
	[HeadShape.Default] = {
		name = HeadShape.Default,
		assetId = not v5 and 7430070993 or 2432102561,
		image = not v5 and "rbxthumb://type=Asset&w=150&h=150&id=7430070993" or "rbxthumb://type=Asset&w=150&h=150&id=2432102561"
	},
	[HeadShape.ManHead] = {
		assetId = 86498048,
		image = "rbxthumb://type=Asset&w=150&h=150&id=86498048",
		name = HeadShape.ManHead
	},
	[HeadShape.WomanHead] = {
		assetId = 86498113,
		image = "rbxthumb://type=Asset&w=150&h=150&id=86498113",
		name = HeadShape.WomanHead
	},
	[HeadShape.Cheeks] = {
		assetId = 746767604,
		image = "rbxthumb://type=Asset&w=150&h=150&id=746767604",
		name = HeadShape.Cheeks
	},
	[HeadShape.Narrow] = {
		assetId = 746774687,
		image = "rbxthumb://type=Asset&w=150&h=150&id=746774687",
		name = HeadShape.Narrow
	},
	[HeadShape.StrongJaw] = {
		assetId = 616399508,
		image = "rbxthumb://type=Asset&w=150&h=150&id=616399508",
		name = HeadShape.StrongJaw
	},
	[HeadShape.Paragon] = {
		assetId = 616398268,
		image = "rbxthumb://type=Asset&w=150&h=150&id=616398268",
		name = HeadShape.Paragon
	},
	[HeadShape.Chiseled] = {
		assetId = 616387160,
		image = "rbxthumb://type=Asset&w=150&h=150&id=616387160",
		name = HeadShape.Chiseled
	},
	[HeadShape.Roundy] = {
		assetId = 6340213,
		image = "rbxthumb://type=Asset&w=150&h=150&id=6340213",
		name = HeadShape.Roundy
	},
	[HeadShape.Blockhead] = {
		assetId = 6340101,
		image = "rbxthumb://type=Asset&w=150&h=150&id=6340101",
		name = HeadShape.Blockhead
	},
	[HeadShape.Trim] = {
		assetId = 6340227,
		image = "rbxthumb://type=Asset&w=150&h=150&id=6340227",
		name = HeadShape.Trim
	}
}

if FFlagDynamicHeadsMigration then
	function t1.fromInventory(p1, s1: string?, s2: string?) -- line: 127
		-- upvalues: t1 (copy), HeadShape (copy), FFlagAXAddFacesToHeadList (copy), FFlagAXFixTryOnHeadShapeThumbnail (copy)
		local t2 = {}

		if t1[HeadShape.Default] then
			t2[HeadShape.Default] = t1[HeadShape.Default]

			if FFlagAXAddFacesToHeadList and s1 then
				t2[HeadShape.Default].image = `rbxthumb://type=Asset&id={ s1 }&w=150&h=150`
			end

			if FFlagAXFixTryOnHeadShapeThumbnail and s2 then
				t2[HeadShape.Default].image = `rbxthumb://type=Asset&id={ s2 }&w=150&h=150`
			end
		end

		if p1 and p1.avatarInventoryItems then
			for _, v14 in p1.avatarInventoryItems do
				if v14.headShape then
					local v15 = "rbxasset://headshapes/" .. v14.headShape .. ".png"

					if FFlagAXAddFacesToHeadList and s1 then
						v15 = `rbxthumb://type=Asset&id={ s1 }&headshape={ v14.headShape }&w=150&h=150`
					end

					if FFlagAXFixTryOnHeadShapeThumbnail and s2 then
						v15 = `rbxthumb://type=Asset&id={ s2 }&headshape={ v14.headShape }&w=150&h=150`
					end

					t2[v14.headShape] = {
						name = v14.headShape,
						assetId = v14.itemId,
						image = v15
					}
				end
			end
		end

		return t2
	end
end

return t1
