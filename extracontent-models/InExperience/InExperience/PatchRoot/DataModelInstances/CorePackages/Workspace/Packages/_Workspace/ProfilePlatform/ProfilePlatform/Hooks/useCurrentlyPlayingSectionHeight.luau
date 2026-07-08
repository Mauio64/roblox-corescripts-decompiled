local Parent = script:FindFirstAncestor("ProfilePlatform").Parent
local useTokens = require(Parent.Foundation).Hooks.useTokens

return function(p1) -- line: 6
	-- upvalues: useTokens (copy)
	local v4 = useTokens()

	if p1 == nil or p1.universeId == nil then
		return 0
	end

	return v4.Size.Size_1000 + 2 * v4.Padding.Large
end
