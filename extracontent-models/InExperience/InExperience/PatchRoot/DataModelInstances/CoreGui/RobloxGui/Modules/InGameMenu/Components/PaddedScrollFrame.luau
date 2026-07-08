local CorePackages = game:GetService("CorePackages")
local InGameMenuDependencies = require(CorePackages.Packages.InGameMenuDependencies)
local Roact = InGameMenuDependencies.Roact
local UIBlox = InGameMenuDependencies.UIBlox
local t = InGameMenuDependencies.t
local withStyle = UIBlox.Core.Style.withStyle
local ParentParent = script.Parent.Parent
local Assets = require(ParentParent.Resources.Assets)
local GlobalConfig = require(ParentParent.GlobalConfig)
local v10 = t.strictInterface({
	Size = t.optional(t.UDim2),
	AnchorPoint = t.optional(t.UDim2),
	CanvasSize = t.optional(t.UDim2),
	Position = t.optional(t.UDim2),
	[Roact.Children] = t.optional(t.table)
})

local function PaddedScrollFrame(p1) -- line: 24
	-- upvalues: GlobalConfig (copy), v10 (copy), withStyle (copy), Roact (copy), Assets (copy)
	if GlobalConfig.propValidation then
		assert(v10(p1))
	end

	return withStyle(function(p2) -- line: 28
		-- upvalues: Roact (copy), Assets (copy), p1 (copy)
		return Roact.createElement("ScrollingFrame", {
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			ClipsDescendants = false,
			ScrollBarThickness = 12,
			ScrollBarImageColor3 = p2.Theme.UIEmphasis.Color,
			ScrollBarImageTransparency = p2.Theme.UIEmphasis.Transparency,
			BottomImage = Assets.Images.ScrollBottom,
			MidImage = Assets.Images.ScrollMid,
			TopImage = Assets.Images.ScrollTop,
			Size = p1.Size,
			AnchorPoint = p1.AnchorPoint,
			CanvasSize = p1.CanvasSize,
			Position = p1.Position
		}, p1[Roact.Children])
	end)
end

return PaddedScrollFrame
