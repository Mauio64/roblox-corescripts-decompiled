local ParentParent = script.Parent.Parent.Parent
local FoundationImages = require(ParentParent.Parent.FoundationImages)

FoundationImages.Images.ImagesResolutionScale = FoundationImages.getResolutionScale()

return FoundationImages.Images
