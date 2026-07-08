local ok, result = pcall(function() -- line: 1
	return game:GetService("StudioService")
end)
local v3 = if not ok then nil else result
local ParentParent = script.Parent.Parent

require(ParentParent.util.Types)

local function getRestrictedUserTable() -- line: 10
	-- upvalues: v3 (copy)
	if v3 then
		return {{
			creatorType = "User",
			id = v3:GetUserId()
		}}
	end

	return {}
end

return getRestrictedUserTable
