local Parent = script:FindFirstAncestor("AvatarExperienceCommon").Parent
local FFlagAXRemoveExpiredItemsFromInventory = require(Parent.AvatarExperienceFlags).FFlagAXRemoveExpiredItemsFromInventory

local function isDurableItemExpired(s1: string) -- line: 11
	-- upvalues: FFlagAXRemoveExpiredItemsFromInventory (copy)
	if not FFlagAXRemoveExpiredItemsFromInventory then
		return false
	end

	local dateTime = DateTime.fromIsoDate(s1)

	if not dateTime then
		return false
	end

	return DateTime.now().UnixTimestamp >= dateTime.UnixTimestamp
end

return isDurableItemExpired
