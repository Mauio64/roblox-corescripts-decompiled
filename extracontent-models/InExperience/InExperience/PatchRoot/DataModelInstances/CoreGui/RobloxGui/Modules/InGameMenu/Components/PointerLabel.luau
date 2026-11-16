local CorePackages = game:GetService("CorePackages")

local InGameMenuDependencies = require(CorePackages.Packages.InGameMenuDependencies)
local Roact = InGameMenuDependencies.Roact
local t = InGameMenuDependencies.t
local UIBlox = InGameMenuDependencies.UIBlox

local parent = script.Parent.Parent

local Assets = require(parent.Resources.Assets)

local GlobalConfig = require(parent.GlobalConfig)

local ImageSetLabel = UIBlox.Core.ImageSet.ImageSetLabel

local Foundation = require(CorePackages.Packages.Foundation)
local Image = Foundation.Image
local SharedFlags = require(CorePackages.Workspace.Packages.SharedFlags)
local FFlagCoreUiMigrateUIBloxToFoundation = SharedFlags.FFlagCoreUiMigrateUIBloxToFoundation

local v = {
	[Enum.UserInputType.MouseButton1] = Assets.Images.Mouse1Press,
	[Enum.UserInputType.MouseButton2] = Assets.Images.Mouse2Press,
	[Enum.UserInputType.MouseWheel] = Assets.Images.MouseWheelScroll
}

local strictInterface = t.strictInterface({
	input = t.enum(Enum.UserInputType),
	AnchorPoint = t.optional(t.Vector2),
	Position = t.optional(t.UDim2),
	LayoutOrder = t.optional(t.integer)
})

local function PointerLabel(props)
	if GlobalConfig.propValidation then
		assert(strictInterface(props))
	end

	local image = v[props.input]

	if FFlagCoreUiMigrateUIBloxToFoundation then
		return Roact.createElement(Image, {
			Image = image.Image,
			imageRect = { offset = image.ImageRectOffset, size = image.ImageRectSize },
			Size = UDim2.new(0, 36, 0, 36),
			Position = props.Position,
			AnchorPoint = props.AnchorPoint,
			LayoutOrder = props.LayoutOrder
		})
	end

	return Roact.createElement(ImageSetLabel, {
		BackgroundTransparency = 1,
		Image = image,
		Size = UDim2.new(0, 36, 0, 36),
		Position = props.Position,
		AnchorPoint = props.AnchorPoint,
		LayoutOrder = props.LayoutOrder
	})
end

return PointerLabel
