local Foundation = script:FindFirstAncestor("Foundation")
local parent = Foundation.Parent

local Dash = require(parent.Dash)
local Flags = require(Foundation.Utility.Flags)
local FoundationCloudAssets = require(parent.FoundationCloudAssets)
local devAssert = require(Foundation.Utility.devAssert)
local Assets = FoundationCloudAssets.Assets
local preloadAsset = FoundationCloudAssets.preloadAsset

return function(value)
	local v = typeof(value) == "string" and { value } or value

	Dash.forEach(v, function(p)
		local formatted = `preloadAssets should only be used with valid FoundationCloudAssets; {p} is an invalid name`

		if Flags.FoundationDevOnlyPropAsserts then
			devAssert(Assets[p], formatted)

			if not Assets[p] then
				return
			end
		else
			assert(Assets[p], formatted)
		end

		preloadAsset(p)
	end)
end
