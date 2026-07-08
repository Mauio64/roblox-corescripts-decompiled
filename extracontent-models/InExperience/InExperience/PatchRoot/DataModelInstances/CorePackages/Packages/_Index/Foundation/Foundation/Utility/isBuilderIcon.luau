local Parent = script:FindFirstAncestor("Foundation").Parent

local function isBuilderIcon(s1: string?) -- line: 6
	return s1 ~= nil and (s1 ~= "" and s1:find("[^%l%d%-]") == nil)
end

return require(Parent.Dash).memoize(isBuilderIcon)
