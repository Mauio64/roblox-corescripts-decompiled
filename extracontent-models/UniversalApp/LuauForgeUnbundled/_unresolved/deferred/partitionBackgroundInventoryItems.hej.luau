local AvatarExperienceCommon = require("@game/CorePackages/Workspace/Packages/AvatarExperienceCommon")

local BACKGROUNDS_CREATE_TILE_ID = require("@luauforge/deferred/hcL").BACKGROUNDS_CREATE_TILE_ID
require("@luauforge/deferred/heh")

local isPlusExclusiveBackground = AvatarExperienceCommon.Backgrounds.isPlusExclusiveBackground

local function partitionBackgroundInventoryItems(items)
	local result = {}
	local result2 = {}
	local v5 = nil

	for k, item in items do
		if item.itemId == BACKGROUNDS_CREATE_TILE_ID then
			v5 = item
		elseif isPlusExclusiveBackground(item.itemId, item.isPlusExclusive) then
			table.insert(result, item)
		else
			table.insert(result2, item)
		end
	end

	if v5 then
		table.insert(result, 1, v5)
	end

	return result2, result
end

return partitionBackgroundInventoryItems
