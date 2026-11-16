local success, result = pcall(function()
	return game:GetService("StudioService")
end)

if not success then
	result = nil
end

local parent = script.Parent.Parent

require(parent.util.Types)

local function getRestrictedUserTable()
	if result then
		return {
			{ creatorType = "User", id = result:GetUserId() }
		}
	end

	return {}
end

return getRestrictedUserTable
