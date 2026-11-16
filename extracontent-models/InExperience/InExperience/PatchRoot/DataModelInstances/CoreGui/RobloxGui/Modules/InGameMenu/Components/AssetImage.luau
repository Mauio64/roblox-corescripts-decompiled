local CorePackages = game:GetService("CorePackages")

local InGameMenuDependencies = require(CorePackages.Packages.InGameMenuDependencies)
local Roact = InGameMenuDependencies.Roact
local Cryo = InGameMenuDependencies.Cryo
local UIBlox = InGameMenuDependencies.UIBlox

local parent = script.Parent.Parent

local ImageSetLabel = UIBlox.Core.ImageSet.ImageSetLabel
local ImageSetButton = UIBlox.Core.ImageSet.ImageSetButton

local Assets = require(parent.Resources.Assets)

local function makeAssetImageComponent(p) -- 2 equivalent calls inferred from this helper
	return Roact.forwardRef(function(p2, p3)
		local imageKey = p2.imageKey
		local image = Assets.Images[imageKey]

		local v = typeof(image) == "string" and { Image = image } or image

		local joined = Cryo.Dictionary.join(p2, { imageKey = Cryo.None }, v, {
			BackgroundTransparency = 1
		})

		return Roact.createElement(p, Cryo.Dictionary.join(joined, { [Roact.Ref] = p3 }))
	end)
end

return {
	Label = makeAssetImageComponent(ImageSetLabel), -- inferred equivalent call
	Button = makeAssetImageComponent(ImageSetButton) -- inferred equivalent call
}
