local Parent = script:FindFirstAncestor("Foundation").Parent
local Assets = require(Parent.FoundationCloudAssets).Assets

return function(s1: string) -- line: 6
	-- upvalues: Assets (copy)
	return Assets[s1] ~= nil
end
