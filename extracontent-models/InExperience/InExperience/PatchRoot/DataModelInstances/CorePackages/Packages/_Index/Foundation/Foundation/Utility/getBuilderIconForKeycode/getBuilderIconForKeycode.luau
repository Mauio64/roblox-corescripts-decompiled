local Parent = script:FindFirstAncestor("Foundation").Parent
local getBuilderIconForKeycode = require(Parent.BuilderIcons).getBuilderIconForKeycode

return function(p1) -- line: 8
	-- upvalues: getBuilderIconForKeycode (copy)
	local ok, result = pcall(function() -- line: 9
		-- upvalues: getBuilderIconForKeycode (copy), p1 (copy)
		return getBuilderIconForKeycode(p1)
	end)

	if ok then
		return result
	end

	return nil
end
