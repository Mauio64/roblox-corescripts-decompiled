local parent = script:FindFirstAncestor("AppChat").Parent
local Cryo = require(parent.Cryo)

local function getLastMessageWithFilter(list, callback)
	if not list or #list == 0 then
		return nil
	end

	local where = Cryo.List.findWhere(list, callback)
	return where and list[where].messageId or nil
end

return getLastMessageWithFilter
