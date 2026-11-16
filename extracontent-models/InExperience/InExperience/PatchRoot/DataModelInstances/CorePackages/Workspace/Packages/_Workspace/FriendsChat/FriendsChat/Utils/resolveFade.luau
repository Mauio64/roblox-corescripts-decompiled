local parent = script:FindFirstAncestor("FriendsChat").Parent

require(parent.React)

local function resolveFade(p: number, value)
	if type(value) == "number" then
		return p + value * (1 - p)
	end

	if value == nil then
		return p
	end

	return value:map(function(p2: number)
		return p + p2 * (1 - p)
	end)
end

return resolveFade
