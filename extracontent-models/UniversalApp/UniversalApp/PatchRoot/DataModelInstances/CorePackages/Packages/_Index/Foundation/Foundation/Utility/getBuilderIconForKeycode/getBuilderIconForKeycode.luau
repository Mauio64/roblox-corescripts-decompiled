local parent = script:FindFirstAncestor("Foundation").Parent

local BuilderIcons = require(parent.BuilderIcons)

local getBuilderIconForKeycode = BuilderIcons.getBuilderIconForKeycode

return function(p)
	local success, result = pcall(function()
		return getBuilderIconForKeycode(p)
	end)
	return if success then result else nil
end
