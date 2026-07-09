local Parent = script:FindFirstAncestor("AppChat").Parent
local Cryo = require(Parent.Cryo)

local function getLastMessageWithFilter(t1: {[any]: any}?, p1: ((...any) -> ...any)) -- line: 13
	-- upvalues: Cryo (copy)
	if not t1 or #t1 == 0 then
		return nil
	end

	local v6 = Cryo.List.findWhere(t1, p1)

	return v6 and t1[v6].messageId or nil
end

return getLastMessageWithFilter
