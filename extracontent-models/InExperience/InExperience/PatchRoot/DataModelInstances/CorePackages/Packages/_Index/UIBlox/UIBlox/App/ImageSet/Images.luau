local parent = script.Parent.Parent.Parent
local FoundationImages = require(parent.Parent.FoundationImages)

FoundationImages.Images.ImagesResolutionScale = FoundationImages.getResolutionScale()

return FoundationImages.Images
