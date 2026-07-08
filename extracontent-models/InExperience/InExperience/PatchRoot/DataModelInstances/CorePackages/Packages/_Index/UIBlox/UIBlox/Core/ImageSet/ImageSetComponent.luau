local createImageSetComponent = require(script.Parent.createImageSetComponent)
local GuiService = game:GetService("GuiService")
local CorePackages = script:FindFirstAncestor("CorePackages")
local ParentParent = script.Parent.Parent.Parent
local Images = require(ParentParent.App.ImageSet.Images)
local ok, _ = pcall(GuiService.GetResolutionScale, GuiService)

if not ok or not CorePackages then
end

local ImagesResolutionScale = Images.ImagesResolutionScale

return {
	Button = createImageSetComponent("ImageButton", ImagesResolutionScale),
	Label = createImageSetComponent("ImageLabel", ImagesResolutionScale)
}
