local CorePackages = game:GetService("CorePackages")
local InGameMenuDependencies = require(CorePackages.Packages.InGameMenuDependencies)
local Roact = InGameMenuDependencies.Roact
local t = InGameMenuDependencies.t
local UIBlox = InGameMenuDependencies.UIBlox
local ParentParent = script.Parent.Parent
local Assets = require(ParentParent.Resources.Assets)
local GlobalConfig = require(ParentParent.GlobalConfig)
local ImageSetLabel = UIBlox.Core.ImageSet.ImageSetLabel
local Image = require(CorePackages.Packages.Foundation).Image
local FFlagCoreUiMigrateUIBloxToFoundation = require(CorePackages.Workspace.Packages.SharedFlags).FFlagCoreUiMigrateUIBloxToFoundation
local t1 = {
	[Enum.UserInputType.MouseButton1] = Assets.Images.Mouse1Press,
	[Enum.UserInputType.MouseButton2] = Assets.Images.Mouse2Press,
	[Enum.UserInputType.MouseWheel] = Assets.Images.MouseWheelScroll
}
local v13 = t.strictInterface({
	input = t.enum(Enum.UserInputType),
	AnchorPoint = t.optional(t.Vector2),
	Position = t.optional(t.UDim2),
	LayoutOrder = t.optional(t.integer)
})

local function PointerLabel(p1) -- line: 34
	-- upvalues: GlobalConfig (copy), v13 (copy), t1 (copy), FFlagCoreUiMigrateUIBloxToFoundation (copy), Roact (copy), Image (copy), ImageSetLabel (copy)
	if GlobalConfig.propValidation then
		assert(v13(p1))
	end

	local v16 = t1[p1.input]

	if FFlagCoreUiMigrateUIBloxToFoundation then
		return Roact.createElement(Image, {
			Image = v16.Image,
			imageRect = {
				offset = v16.ImageRectOffset,
				size = v16.ImageRectSize
			},
			Size = UDim2.new(0, 36, 0, 36),
			Position = p1.Position,
			AnchorPoint = p1.AnchorPoint,
			LayoutOrder = p1.LayoutOrder
		})
	end

	return Roact.createElement(ImageSetLabel, {
		BackgroundTransparency = 1,
		Image = v16,
		Size = UDim2.new(0, 36, 0, 36),
		Position = p1.Position,
		AnchorPoint = p1.AnchorPoint,
		LayoutOrder = p1.LayoutOrder
	})
end

return PointerLabel
