local Parent = script:FindFirstAncestor("Foundation").Parent
local Dash = require(Parent.Dash)
local FoundationCloudAssets = require(Parent.FoundationCloudAssets)
local Assets = FoundationCloudAssets.Assets
local preloadAsset = FoundationCloudAssets.preloadAsset

return function(p1) -- line: 9
	-- upvalues: Dash (copy), Assets (copy), preloadAsset (copy)
	if typeof(p1) == "string" then
		p1 = { p1 }
	end

	Dash.forEach(p1, function(p2) -- line: 12
		-- upvalues: Assets (copy), preloadAsset (copy)
		assert(Assets[p2], `preloadAssets should only be used with valid FoundationCloudAssets; { p2 } is an invalid name`)
		preloadAsset(p2)
	end)
end
