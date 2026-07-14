local CorePackages = game:GetService("CorePackages")
local InGameMenuDependencies = require(CorePackages.Packages.InGameMenuDependencies)
local Roact = InGameMenuDependencies.Roact
local t = InGameMenuDependencies.t
local withFoundationOrUIBloxStyle = require(CorePackages.Workspace.Packages.CoreGuiCommon).withFoundationOrUIBloxStyle
local ParentParent = script.Parent.Parent
local Assets = require(ParentParent.Resources.Assets)
local GlobalConfig = require(ParentParent.GlobalConfig)
local v9 = t.strictInterface({
	Size = t.optional(t.UDim2),
	AnchorPoint = t.optional(t.UDim2),
	CanvasSize = t.optional(t.UDim2),
	Position = t.optional(t.UDim2),
	[Roact.Children] = t.optional(t.table)
})

local function PaddedScrollFrame(p1) -- line: 23
	-- upvalues: GlobalConfig (copy), v9 (copy), withFoundationOrUIBloxStyle (copy), Roact (copy), Assets (copy)
	if GlobalConfig.propValidation then
		assert(v9(p1))
	end

	return withFoundationOrUIBloxStyle(function(p2) -- line: 27
		return {
			Theme = {
				UIEmphasis = {
					Color = p2.Color.Shift.Shift_400.Color3,
					Transparency = p2.Color.Shift.Shift_400.Transparency
				}
			}
		}
	end, function(p3) -- line: 33
		-- upvalues: Roact (copy), Assets (copy), p1 (copy)
		return Roact.createElement("ScrollingFrame", {
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			ClipsDescendants = false,
			ScrollBarThickness = 12,
			ScrollBarImageColor3 = p3.Theme.UIEmphasis.Color,
			ScrollBarImageTransparency = p3.Theme.UIEmphasis.Transparency,
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
