local parent = script.Parent
local ConsolidatedAssets = require(parent.Generated.ConsolidatedAssets)
local ContentProvider = game:GetService("ContentProvider")

local function preloadAsset(p: string)
	local imageLabel = Instance.new("ImageLabel")
	imageLabel.Image = ConsolidatedAssets[p].assetId

	task.spawn(function()
		ContentProvider:PreloadAsync({ imageLabel })
		imageLabel:Destroy()
	end)
end

return preloadAsset
