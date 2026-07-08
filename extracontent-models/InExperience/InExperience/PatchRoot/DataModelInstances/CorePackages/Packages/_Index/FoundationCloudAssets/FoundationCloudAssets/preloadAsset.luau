local scriptParent = script.Parent
local ConsolidatedAssets = require(scriptParent.Generated.ConsolidatedAssets)
local ContentProvider = game:GetService("ContentProvider")

local function preloadAsset(s1: string) -- line: 5
	-- upvalues: ConsolidatedAssets (copy), ContentProvider (copy)
	local ImageLabel = Instance.new("ImageLabel")

	ImageLabel.Image = ConsolidatedAssets[s1].assetId
	task.spawn(function() -- line: 11
		-- upvalues: ContentProvider (copy), ImageLabel (copy)
		ContentProvider:PreloadAsync({ ImageLabel })
		ImageLabel:Destroy()
	end)
end

return preloadAsset
