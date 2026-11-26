local fFlagAXRemoveExpiredItemsFromInventory = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCommon/AvatarExperienceFlags").FFlagAXRemoveExpiredItemsFromInventory

local function isDurableItemExpired(p2): boolean
	if not fFlagAXRemoveExpiredItemsFromInventory then
		return false
	end

	local dateTime = DateTime.fromIsoDate(p2)

	if dateTime then
		return DateTime.now().UnixTimestamp >= dateTime.UnixTimestamp
	end

	return false
end

return isDurableItemExpired
