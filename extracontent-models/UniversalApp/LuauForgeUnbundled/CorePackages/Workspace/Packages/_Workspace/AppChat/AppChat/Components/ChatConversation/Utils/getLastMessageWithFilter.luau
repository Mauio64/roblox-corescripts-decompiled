local Cryo = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/Cryo")

local function getLastMessageWithFilter(list, p2)
	if not list or #list == 0 then
		return nil
	end

	local where = Cryo.List.findWhere(list, p2)
	return where and list[where].messageId or nil
end

return getLastMessageWithFilter
