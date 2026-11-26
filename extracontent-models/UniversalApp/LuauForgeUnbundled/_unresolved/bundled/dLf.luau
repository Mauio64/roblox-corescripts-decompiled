local module = require("@luauforge/bundled/dLg")
local module2 = require("@luauforge/bundled/dLc")
require("@luauforge/bundled/dLh")

local headShape = module2.Enums.HeadShape

local defineFastFlag = game:DefineFastFlag("AXReplaceDefaultHeadAssetId", false)
local fFlagAXAddFacesToHeadList = module.FFlagAXAddFacesToHeadList
local fFlagAXFixTryOnHeadShapeThumbnail = module.FFlagAXFixTryOnHeadShapeThumbnail

local v5 = {
	[headShape.Default] = {
		name = headShape.Default,
		assetId = defineFastFlag and 2432102561 or 7430070993,
		image = defineFastFlag and "rbxthumb://type=Asset&w=150&h=150&id=2432102561" or "rbxthumb://type=Asset&w=150&h=150&id=7430070993"
	},
	[headShape.ManHead] = {
		name = headShape.ManHead,
		assetId = 86498048,
		image = "rbxthumb://type=Asset&w=150&h=150&id=86498048"
	},
	[headShape.WomanHead] = {
		name = headShape.WomanHead,
		assetId = 86498113,
		image = "rbxthumb://type=Asset&w=150&h=150&id=86498113"
	},
	[headShape.Cheeks] = {
		name = headShape.Cheeks,
		assetId = 746767604,
		image = "rbxthumb://type=Asset&w=150&h=150&id=746767604"
	},
	[headShape.Narrow] = {
		name = headShape.Narrow,
		assetId = 746774687,
		image = "rbxthumb://type=Asset&w=150&h=150&id=746774687"
	},
	[headShape.StrongJaw] = {
		name = headShape.StrongJaw,
		assetId = 616399508,
		image = "rbxthumb://type=Asset&w=150&h=150&id=616399508"
	},
	[headShape.Paragon] = {
		name = headShape.Paragon,
		assetId = 616398268,
		image = "rbxthumb://type=Asset&w=150&h=150&id=616398268"
	},
	[headShape.Chiseled] = {
		name = headShape.Chiseled,
		assetId = 616387160,
		image = "rbxthumb://type=Asset&w=150&h=150&id=616387160"
	},
	[headShape.Roundy] = {
		name = headShape.Roundy,
		assetId = 6340213,
		image = "rbxthumb://type=Asset&w=150&h=150&id=6340213"
	},
	[headShape.Blockhead] = {
		name = headShape.Blockhead,
		assetId = 6340101,
		image = "rbxthumb://type=Asset&w=150&h=150&id=6340101"
	},
	[headShape.Trim] = {
		name = headShape.Trim,
		assetId = 6340227,
		image = "rbxthumb://type=Asset&w=150&h=150&id=6340227"
	}
}

function v5.fromInventory(p2, p3, p4)
	local result = {}

	if v5[headShape.Default] then
		result[headShape.Default] = v5[headShape.Default]

		if fFlagAXAddFacesToHeadList and p3 then
			result[headShape.Default].image = `rbxthumb://type=Asset&id={p3}&w=150&h=150`
		end

		if fFlagAXFixTryOnHeadShapeThumbnail and p4 then
			result[headShape.Default].image = `rbxthumb://type=Asset&id={p4}&w=150&h=150`
		end
	end

	if not (p2 and p2.avatarInventoryItems) then
		return result
	end

	for k, avatarInventoryItem in p2.avatarInventoryItems do
		if not avatarInventoryItem.headShape then
			continue
		end

		local v6 = "rbxasset://headshapes/" .. avatarInventoryItem.headShape .. ".png"

		if fFlagAXAddFacesToHeadList and p3 then
			v6 = `rbxthumb://type=Asset&id={p3}&headshape={avatarInventoryItem.headShape}&w=150&h=150`
		end

		if fFlagAXFixTryOnHeadShapeThumbnail and p4 then
			v6 = `rbxthumb://type=Asset&id={p4}&headshape={avatarInventoryItem.headShape}&w=150&h=150`
		end

		result[avatarInventoryItem.headShape] = {
			name = avatarInventoryItem.headShape,
			assetId = avatarInventoryItem.itemId,
			image = v6
		}
	end

	return result
end

return v5
