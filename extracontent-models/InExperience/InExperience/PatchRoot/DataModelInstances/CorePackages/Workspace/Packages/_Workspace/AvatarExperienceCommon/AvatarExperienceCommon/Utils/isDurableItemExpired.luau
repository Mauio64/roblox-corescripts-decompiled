local parent = script:FindFirstAncestor("AvatarExperienceCommon").Parent

local AvatarExperienceFlags = require(parent.AvatarExperienceFlags)
local FFlagAXRemoveExpiredItemsFromInventory = AvatarExperienceFlags.FFlagAXRemoveExpiredItemsFromInventory

local function isDurableItemExpired(p: string): boolean
	if not FFlagAXRemoveExpiredItemsFromInventory then
		return false
	end

	local dateTime = DateTime.fromIsoDate(p)

	if dateTime then
		return DateTime.now().UnixTimestamp >= dateTime.UnixTimestamp
	end

	return false
end

return isDurableItemExpired
