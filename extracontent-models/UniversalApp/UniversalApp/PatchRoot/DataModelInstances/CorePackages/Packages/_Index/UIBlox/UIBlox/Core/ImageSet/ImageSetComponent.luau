local createImageSetComponent = require(script.Parent.createImageSetComponent)

local parent = script.Parent.Parent.Parent
local Images = require(parent.App.ImageSet.Images)

local ImagesResolutionScale = Images.ImagesResolutionScale

return {
	Button = createImageSetComponent("ImageButton", ImagesResolutionScale),
	Label = createImageSetComponent("ImageLabel", ImagesResolutionScale)
}
