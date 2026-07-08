local CorePackages = game:GetService("CorePackages")
local InGameMenuDependencies = require(CorePackages.Packages.InGameMenuDependencies)
local Roact = InGameMenuDependencies.Roact
local t = InGameMenuDependencies.t
local UIBlox = InGameMenuDependencies.UIBlox
local ParentParent = script.Parent.Parent
local Assets = require(ParentParent.Resources.Assets)
local GlobalConfig = require(ParentParent.GlobalConfig)
local ImageSetLabel = UIBlox.Core.ImageSet.ImageSetLabel
local t1 = {
	[Enum.UserInputType.MouseButton1] = Assets.Images.Mouse1Press,
	[Enum.UserInputType.MouseButton2] = Assets.Images.Mouse2Press,
	[Enum.UserInputType.MouseWheel] = Assets.Images.MouseWheelScroll
}
local v11 = t.strictInterface({
	input = t.enum(Enum.UserInputType),
	AnchorPoint = t.optional(t.Vector2),
	Position = t.optional(t.UDim2),
	LayoutOrder = t.optional(t.integer)
})

local function PointerLabel(p1) -- line: 29
	-- upvalues: GlobalConfig (copy), v11 (copy), Roact (copy), ImageSetLabel (copy), t1 (copy)
	if GlobalConfig.propValidation then
		assert(v11(p1))
	end

	return Roact.createElement(ImageSetLabel, {
		BackgroundTransparency = 1,
		Image = t1[p1.input],
		Size = UDim2.new(0, 36, 0, 36),
		Position = p1.Position,
		AnchorPoint = p1.AnchorPoint,
		LayoutOrder = p1.LayoutOrder
	})
end

return PointerLabel
