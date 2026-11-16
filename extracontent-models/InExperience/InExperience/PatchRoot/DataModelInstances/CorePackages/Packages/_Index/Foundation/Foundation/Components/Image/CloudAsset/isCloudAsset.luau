local parent = script:FindFirstAncestor("Foundation").Parent

local FoundationCloudAssets = require(parent.FoundationCloudAssets)
local Assets = FoundationCloudAssets.Assets

return function(p: string): boolean
	return Assets[p] ~= nil
end
